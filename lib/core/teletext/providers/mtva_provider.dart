import 'dart:io';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Entry per la cache delle sottopagine con timestamp e stato di verifica
class _SubPageCacheEntry {
  final int count;
  final DateTime timestamp;
  final DateTime lastVerified;
  
  _SubPageCacheEntry(this.count, this.timestamp, {DateTime? lastVerified})
      : lastVerified = lastVerified ?? timestamp;
  
  /// Verifica se la cache è scaduta (oltre il TTL)
  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }
  
  /// Verifica se è necessario un controllo di consistenza
  bool needsConsistencyCheck(Duration checkInterval) {
    return DateTime.now().difference(lastVerified) > checkInterval;
  }
  
  /// Crea una nuova entry con timestamp di verifica aggiornato
  _SubPageCacheEntry withVerification() {
    return _SubPageCacheEntry(count, timestamp, lastVerified: DateTime.now());
  }
}

class MTVAProvider extends TeletextProvider {
  static const String baseUrl = 'https://www.teletext.hu/mtv1';
  
  // HttpClient che accetta certificati self-signed per teletext.hu
  static http.Client? _httpClient;
  
  // Cache per il numero totale di sottopagine con timestamp e verifica
  final Map<int, _SubPageCacheEntry> _subPageCache = {};
  
  // Intervalli di tempo per la gestione della cache
  static const Duration _cacheTTL = Duration(minutes: 30); // TTL completo
  static const Duration _consistencyCheckInterval = Duration(minutes: 2); // Verifica consistenza
  
  static http.Client _getHttpClient() {
    if (_httpClient == null) {
      final ioClient = HttpClient();
      ioClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Accetta il certificato solo per teletext.hu
        return host == 'www.teletext.hu' || host == 'teletext.hu';
      };
      _httpClient = IOClient(ioClient);
    }
    return _httpClient!;
  }
  
  @override
  String get providerId => 'mtva_teletext';
  
  @override
  String get providerName => 'MTVA Teletext';
  
  @override
  String get countryCode => 'HU';
  
  @override
  bool get supportsRegions => false;
  
  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[MTVAProvider] Fetching page $pageNumber subpage $subPage');
    
    // Formato sottopagina: 01, 02, 03, ecc.
    final subPageStr = subPage.toString().padLeft(2, '0');
    final url = '$baseUrl/$pageNumber-$subPageStr.HTM';
    print('[MTVAProvider] URL: $url');
    
    try {
      final client = _getHttpClient();
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      final document = html_parser.parse(response.body);
      return await _parseHtmlPage(document, pageNumber, subPage);
    } catch (e) {
      print('[MTVAProvider] Error: $e');
      rethrow;
    }
  }

  Future<TelevideoPage> _parseHtmlPage(dom.Document document, int pageNumber, int currentSubPage) async {
    // Estrai l'immagine
    final imgElement = document.querySelector('img[usemap]');
    if (imgElement == null) {
      throw Exception('No teletext image found in HTML');
    }
    
    final imgSrc = imgElement.attributes['src'];
    if (imgSrc == null || imgSrc.isEmpty) {
      throw Exception('Image source not found');
    }
    
    // Costruisci l'URL assoluto dell'immagine
    final imageUrl = imgSrc.startsWith('http') ? imgSrc : '$baseUrl/$imgSrc';
    print('[MTVAProvider] Image URL: $imageUrl');
    
    // Estrai i metadati di navigazione dai campi hidden
    final nextSubInput = document.querySelector('input#nextSub');
    final prevSubInput = document.querySelector('input#prevSub');
    final nextPageInput = document.querySelector('input#next');
    final prevPageInput = document.querySelector('input#prev');
    
    final nextSubValue = nextSubInput?.attributes['value'];
    final prevSubValue = prevSubInput?.attributes['value'];
    final nextPageValue = nextPageInput?.attributes['value'];
    final prevPageValue = prevPageInput?.attributes['value'];
    
    print('[MTVAProvider] Navigation - nextSub: $nextSubValue, prevSub: $prevSubValue, next: $nextPageValue, prev: $prevPageValue');
    
    // Determina il numero totale di sottopagine usando la cache con verifica di consistenza
    int totalSubPages;
    
    if (_subPageCache.containsKey(pageNumber)) {
      final entry = _subPageCache[pageNumber]!;
      final cacheAge = DateTime.now().difference(entry.timestamp);
      final timeSinceVerification = DateTime.now().difference(entry.lastVerified);
      
      print('[MTVAProvider] Cache found - count: ${entry.count}, age: ${cacheAge.inMinutes}m, last verified: ${timeSinceVerification.inMinutes}m ago');
      
      if (entry.isExpired(_cacheTTL)) {
        // Cache scaduta (oltre 30 minuti), ricarica completamente
        print('[MTVAProvider] ⏰ Cache expired (>${_cacheTTL.inMinutes}m), full reload');
        totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage, nextSubValue);
      } else if (entry.needsConsistencyCheck(_consistencyCheckInterval)) {
        // Cache ancora valida ma necessita controllo di consistenza (oltre 2 minuti)
        print('[MTVAProvider] 🔍 Performing consistency check (last verified ${timeSinceVerification.inMinutes}m ago)...');
        
        // Verifica se la sottopagina cachata esiste ancora
        final cachedSubPageExists = await _checkSubPageExists(pageNumber, entry.count);
        
        if (!cachedSubPageExists) {
          // La sottopagina cachata non esiste più! Invalida e ricarica
          print('[MTVAProvider] ⚠️ Cached subpage ${entry.count} no longer exists! Invalidating cache and reloading...');
          _subPageCache.remove(pageNumber);
          totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage, nextSubValue);
        } else {
          // La sottopagina cachata esiste, verifica se ce ne sono di nuove
          final hasMore = await _checkSubPageExists(pageNumber, entry.count + 1);
          
          if (hasMore) {
            // Trovate nuove sottopagine! Ricarica il conteggio
            print('[MTVAProvider] ✨ Found new subpages beyond ${entry.count}, recounting...');
            totalSubPages = await _countTotalSubPages(pageNumber, entry.count);
            _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
            print('[MTVAProvider] ✅ Updated cache: $totalSubPages subpages');
          } else {
            // Il conteggio è ancora corretto, aggiorna solo il timestamp di verifica
            totalSubPages = entry.count;
            _subPageCache[pageNumber] = entry.withVerification();
            print('[MTVAProvider] ✅ Consistency verified: $totalSubPages subpages (unchanged)');
          }
        }
      } else {
        // Cache valida e verificata di recente
        totalSubPages = entry.count;
        print('[MTVAProvider] ✅ Using cached subpage count: $totalSubPages (verified ${timeSinceVerification.inSeconds}s ago)');
      }
    } else {
      // Prima visita, conta le sottopagine
      print('[MTVAProvider] 🆕 First visit to page $pageNumber, counting subpages...');
      totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage, nextSubValue);
    }
    
    print('[MTVAProvider] Total subpages: $totalSubPages');
    
    // Estrai la mappa dei link cliccabili
    final mapName = imgElement.attributes['usemap']?.replaceAll('#', '');
    final clickableAreas = <ClickableArea>[];
    
    if (mapName != null && mapName.isNotEmpty) {
      final mapElement = document.querySelector('map[name="$mapName"]');
      if (mapElement != null) {
        final areas = mapElement.querySelectorAll('area');
        print('[MTVAProvider] Found ${areas.length} clickable areas');
        
        for (final area in areas) {
          final coords = area.attributes['COORDS'] ?? area.attributes['coords'];
          final href = area.attributes['HREF'] ?? area.attributes['href'];
          
          if (coords != null && href != null && !href.startsWith('http')) {
            final coordsList = coords.split(',').map((c) => int.tryParse(c.trim()) ?? 0).toList();
            if (coordsList.length == 4) {
              // Estrai il numero di pagina dall'href (formato: 101-01.HTM)
              final match = RegExp(r'(\d+)-\d+\.HTM', caseSensitive: false).firstMatch(href);
              if (match != null) {
                final targetPage = int.tryParse(match.group(1)!);
                if (targetPage != null) {
                  clickableAreas.add(ClickableArea(
                    x: coordsList[0],
                    y: coordsList[1],
                    width: coordsList[2] - coordsList[0],
                    height: coordsList[3] - coordsList[1],
                    targetPage: targetPage,
                  ));
                }
              }
            }
          }
        }
      }
    }
    
    print('[MTVAProvider] Parsed ${clickableAreas.length} clickable areas');
    
    // Estrai numeri di pagina dai metadati
    String? nextPage;
    String? prevPage;
    
    if (nextPageValue != null && nextPageValue.isNotEmpty) {
      final match = RegExp(r'(\d+)-').firstMatch(nextPageValue);
      if (match != null) {
        nextPage = match.group(1);
      }
    }
    
    if (prevPageValue != null && prevPageValue.isNotEmpty) {
      final match = RegExp(r'(\d+)-').firstMatch(prevPageValue);
      if (match != null) {
        prevPage = match.group(1);
      }
    }
    
    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      clickableAreas: clickableAreas,
      isHtmlContent: false,
      providerId: providerId,
      metadata: {
        'prevPage': prevPage,
        'nextPage': nextPage,
      },
    );
  }

  /// Ricarica il conteggio delle sottopagine da zero
  Future<int> _reloadSubPageCount(int pageNumber, int currentSubPage, String? nextSubValue) async {
    int totalSubPages = currentSubPage;
    
    if (nextSubValue != null && nextSubValue.isNotEmpty) {
      // Se c'è una sottopagina successiva, contale tutte
      totalSubPages = await _countTotalSubPages(pageNumber, currentSubPage);
      _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
      print('[MTVAProvider] ✅ Cached subpage count for page $pageNumber: $totalSubPages');
    } else {
      // Nessuna sottopagina successiva, questa è l'unica/ultima
      _subPageCache[pageNumber] = _SubPageCacheEntry(currentSubPage, DateTime.now());
      print('[MTVAProvider] ✅ Single subpage cached for page $pageNumber');
    }
    
    return totalSubPages;
  }

  /// Verifica se una specifica sottopagina esiste
  Future<bool> _checkSubPageExists(int pageNumber, int subPage) async {
    try {
      final subPageStr = subPage.toString().padLeft(2, '0');
      final url = '$baseUrl/$pageNumber-$subPageStr.HTM';
      final client = _getHttpClient();
      
      print('[MTVAProvider] 🔍 Checking if subpage $subPage exists: $url');
      final response = await client.head(Uri.parse(url));
      final exists = response.statusCode == 200;
      print('[MTVAProvider] Subpage $subPage ${exists ? "✅ exists" : "❌ does not exist"}');
      
      return exists;
    } catch (e) {
      print('[MTVAProvider] ❌ Error checking subpage $subPage: $e');
      return false;
    }
  }

  Future<int> _countTotalSubPages(int pageNumber, int startFrom) async {
    print('[MTVAProvider] Counting total subpages for page $pageNumber starting from $startFrom');
    
    int count = startFrom;
    int maxAttempts = 20; // Limite di sicurezza
    
    final client = _getHttpClient();
    
    for (int i = startFrom; i < startFrom + maxAttempts; i++) {
      try {
        final subPageStr = (i + 1).toString().padLeft(2, '0');
        final url = '$baseUrl/$pageNumber-$subPageStr.HTM';
        
        final response = await client.head(Uri.parse(url));
        
        if (response.statusCode == 200) {
          // Verifica se ha una sottopagina successiva leggendo il contenuto
          final fullResponse = await client.get(Uri.parse(url));
          final document = html_parser.parse(fullResponse.body);
          final nextSubInput = document.querySelector('input#nextSub');
          final nextSubValue = nextSubInput?.attributes['value'];
          
          count = i + 1;
          
          // Se non c'è una sottopagina successiva, ci fermiamo
          if (nextSubValue == null || nextSubValue.isEmpty) {
            break;
          }
        } else {
          // La sottopagina non esiste, ci fermiamo
          break;
        }
      } catch (e) {
        print('[MTVAProvider] Error checking subpage ${i + 1}: $e');
        break;
      }
    }
    
    print('[MTVAProvider] Found $count total subpages');
    return count;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) async {
    // MTVA non ha pagine regionali, usa sempre le nazionali
    return fetchNationalPage(pageNumber, subPage: subPage);
  }
  
  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await fetchNationalPage(pageNumber);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Pulisce la cache delle sottopagine
  void clearSubPageCache() {
    _subPageCache.clear();
    print('[MTVAProvider] Subpage cache cleared');
  }
}

