import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

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

class IcelandProvider extends TeletextProvider {
  static const String baseUrl = 'https://textavarp.is';
  
  // Cache per il numero totale di sottopagine con timestamp e verifica
  final Map<int, _SubPageCacheEntry> _subPageCache = {};
  
  // Intervalli di tempo per la gestione della cache
  static const Duration _cacheTTL = Duration(minutes: 30); // TTL completo
  static const Duration _consistencyCheckInterval = Duration(minutes: 2); // Verifica consistenza
  
  @override
  String get providerId => 'ruv_textavarp';
  
  @override
  String get providerName => 'RÚV Textavarp';
  
  @override
  String get countryCode => 'IS';
  
  @override
  bool get supportsRegions => false;
  
  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[IcelandProvider] Fetching page $pageNumber subpage $subPage');
    final url = '$baseUrl/sida/$pageNumber/$subPage';
    print('[IcelandProvider] URL: $url');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      return await _parseHtmlPage(response.body, pageNumber, subPage);
    } catch (e) {
      print('[IcelandProvider] Error fetching page: $e');
      rethrow;
    }
  }

  Future<TelevideoPage> _parseHtmlPage(String htmlContent, int pageNumber, int currentSubPage) async {
    final document = html_parser.parse(htmlContent);
    
    // Estrai il contenuto del div layerData
    final layerData = document.querySelector('div#layerData');
    if (layerData == null) {
      throw Exception('No layerData div found in HTML');
    }
    
    // Verifica se il contenuto è vuoto (solo pre vuoti)
    final hasContent = _hasActualContent(layerData);
    if (!hasContent) {
      throw Exception('Empty page content');
    }
    
    // Estrai link cliccabili
    final clickableAreas = _extractClickableLinks(layerData);
    print('[IcelandProvider] Found ${clickableAreas.length} clickable areas');
    
    // Determina il numero totale di sottopagine usando la cache con verifica di consistenza
    int totalSubPages;
    
    if (_subPageCache.containsKey(pageNumber)) {
      final entry = _subPageCache[pageNumber]!;
      final cacheAge = DateTime.now().difference(entry.timestamp);
      final timeSinceVerification = DateTime.now().difference(entry.lastVerified);
      
      print('[IcelandProvider] Cache found - count: ${entry.count}, age: ${cacheAge.inMinutes}m, last verified: ${timeSinceVerification.inMinutes}m ago');
      
      if (entry.isExpired(_cacheTTL)) {
        // Cache scaduta (oltre 30 minuti), ricarica completamente
        print('[IcelandProvider] ⏰ Cache expired (>${_cacheTTL.inMinutes}m), full reload');
        totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
      } else if (entry.needsConsistencyCheck(_consistencyCheckInterval)) {
        // Cache ancora valida ma necessita controllo di consistenza (oltre 2 minuti)
        print('[IcelandProvider] 🔍 Performing consistency check (last verified ${timeSinceVerification.inMinutes}m ago)...');
        
        // Verifica se la sottopagina cachata esiste ancora
        final cachedSubPageExists = await _checkSubPageExists(pageNumber, entry.count);
        
        if (!cachedSubPageExists) {
          // La sottopagina cachata non esiste più! Invalida e ricarica
          print('[IcelandProvider] ⚠️ Cached subpage ${entry.count} no longer exists! Invalidating cache and reloading...');
          _subPageCache.remove(pageNumber);
          totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
        } else {
          // La sottopagina cachata esiste, verifica se ce ne sono di nuove
          final hasMore = await _checkSubPageExists(pageNumber, entry.count + 1);
          
          if (hasMore) {
            // Trovate nuove sottopagine! Ricarica il conteggio
            print('[IcelandProvider] ✨ Found new subpages beyond ${entry.count}, recounting...');
            totalSubPages = await _countTotalSubPages(pageNumber, entry.count);
            _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
            print('[IcelandProvider] ✅ Updated cache: $totalSubPages subpages');
          } else {
            // Il conteggio è ancora corretto, aggiorna solo il timestamp di verifica
            totalSubPages = entry.count;
            _subPageCache[pageNumber] = entry.withVerification();
            print('[IcelandProvider] ✅ Consistency verified: $totalSubPages subpages (unchanged)');
          }
        }
      } else {
        // Cache valida e verificata di recente
        totalSubPages = entry.count;
        print('[IcelandProvider] ✅ Using cached subpage count: $totalSubPages (verified ${timeSinceVerification.inSeconds}s ago)');
      }
    } else {
      // Prima visita, conta le sottopagine
      print('[IcelandProvider] 🆕 First visit to page $pageNumber, counting subpages...');
      totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
    }
    
    // Costruisci l'HTML ottimizzato (solo head + layerData)
    final optimizedHtml = _buildOptimizedHtml(document, layerData);
    
    print('[IcelandProvider] Creating TelevideoPage with providerId: $providerId');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      imageUrl: '',
      isHtmlContent: true,
      htmlContent: optimizedHtml,
      clickableAreas: clickableAreas,
      providerId: providerId,
      metadata: {
        'prevPage': pageNumber > 100 ? (pageNumber - 1).toString() : null,
        'nextPage': (pageNumber + 1).toString(),
      },
    );
  }

  /// Verifica se il layerData contiene contenuto effettivo
  bool _hasActualContent(dom.Element layerData) {
    final preElements = layerData.querySelectorAll('pre');
    
    // Se non ci sono elementi pre, considera vuoto
    if (preElements.isEmpty) return false;
    
    // Verifica se almeno un pre ha contenuto (testo o tag HTML)
    for (var pre in preElements) {
      final text = pre.text.trim();
      final hasLinks = pre.querySelector('a') != null;
      final hasSpans = pre.querySelector('span') != null;
      
      if (text.isNotEmpty || hasLinks || hasSpans) {
        return true;
      }
    }
    
    return false;
  }

  /// Ricarica il conteggio delle sottopagine da zero
  Future<int> _reloadSubPageCount(int pageNumber, int currentSubPage) async {
    final totalSubPages = await _countTotalSubPages(pageNumber, currentSubPage);
    _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
    print('[IcelandProvider] ✅ Cached subpage count for page $pageNumber: $totalSubPages');
    return totalSubPages;
  }

  /// Verifica se una specifica sottopagina esiste
  Future<bool> _checkSubPageExists(int pageNumber, int subPage) async {
    try {
      final url = '$baseUrl/sida/$pageNumber/$subPage';
      print('[IcelandProvider] 🔍 Checking if subpage $subPage exists: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final layerData = document.querySelector('div#layerData');
        
        // La sottopagina esiste se c'è layerData con contenuto
        final exists = layerData != null && _hasActualContent(layerData);
        print('[IcelandProvider] Subpage $subPage ${exists ? "✅ exists" : "❌ is empty/does not exist"}');
        return exists;
      } else {
        print('[IcelandProvider] Subpage $subPage ❌ returned ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[IcelandProvider] ❌ Error checking subpage $subPage: $e');
      return false;
    }
  }

  /// Conta il numero totale di sottopagine
  Future<int> _countTotalSubPages(int pageNumber, int startFrom) async {
    print('[IcelandProvider] Counting total subpages for page $pageNumber starting from $startFrom');
    
    int count = startFrom;
    int maxAttempts = 10; // Limite di sicurezza
    
    for (int i = startFrom; i < startFrom + maxAttempts; i++) {
      try {
        final url = '$baseUrl/sida/$pageNumber/${i + 1}';
        final response = await http.get(Uri.parse(url));
        
        if (response.statusCode == 200) {
          final document = html_parser.parse(response.body);
          final layerData = document.querySelector('div#layerData');
          
          if (layerData != null && _hasActualContent(layerData)) {
            count = i + 1;
          } else {
            // Sottopagina vuota, ci fermiamo
            break;
          }
        } else {
          break; // La pagina non esiste, ci fermiamo
        }
      } catch (e) {
        print('[IcelandProvider] Error checking subpage ${i + 1}: $e');
        break; // Errore, ci fermiamo
      }
    }
    
    return count;
  }

  /// Estrae i link cliccabili dal layerData
  List<ClickableArea> _extractClickableLinks(dom.Element layerData) {
    final List<ClickableArea> clickableAreas = [];
    final links = layerData.querySelectorAll('a[href]');
    
    for (var link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dall'href (formato: /sida/100/1)
      final match = RegExp(r'/sida/(\d+)/\d+').firstMatch(href);
      if (match != null) {
        final targetPage = int.tryParse(match.group(1)!);
        if (targetPage != null) {
          // Per ora usiamo coordinate fittizie (non abbiamo coordinate esatte nell'HTML)
          // Il viewer HTML gestirà i click direttamente sui link
          clickableAreas.add(ClickableArea(
            x: 0,
            y: 0,
            width: 0,
            height: 0,
            targetPage: targetPage,
          ));
        }
      }
    }
    
    return clickableAreas;
  }

  /// Converte URL relativi in assoluti
  void _convertRelativeUrlsToAbsolute(dom.Document document) {
    print('[IcelandProvider] Converting relative URLs to absolute');
    
    // Converti link CSS
    final linkElements = document.querySelectorAll('link[rel="stylesheet"]');
    for (var link in linkElements) {
      final href = link.attributes['href'];
      if (href != null && !href.startsWith('http')) {
        final absoluteUrl = Uri.parse(baseUrl).resolve(href).toString();
        print('[IcelandProvider] CSS: $href -> $absoluteUrl');
        link.attributes['href'] = absoluteUrl;
      }
    }
    
    // Converti script src
    final scriptElements = document.querySelectorAll('script[src]');
    for (var script in scriptElements) {
      final src = script.attributes['src'];
      if (src != null && !src.startsWith('http')) {
        script.attributes['src'] = Uri.parse(baseUrl).resolve(src).toString();
      }
    }
    
    // Converti immagini
    final imgElements = document.querySelectorAll('img[src]');
    for (var img in imgElements) {
      final src = img.attributes['src'];
      if (src != null && !src.startsWith('http') && !src.startsWith('data:')) {
        img.attributes['src'] = Uri.parse(baseUrl).resolve(src).toString();
      }
    }
    
    // Converti @font-face url() in style elements
    final styleElements = document.querySelectorAll('style');
    for (var style in styleElements) {
      var css = style.text;
      // Trova tutti i url(...) nel CSS - pattern semplificato
      final urlPattern = RegExp(r'url\(([^)]+)\)');
      css = css.replaceAllMapped(urlPattern, (match) {
        var url = match.group(1)!.trim();
        // Rimuovi virgolette se presenti
        if (url.startsWith('"') || url.startsWith("'")) {
          url = url.substring(1, url.length - 1);
        }
        if (!url.startsWith('http') && !url.startsWith('data:')) {
          final absoluteUrl = Uri.parse(baseUrl).resolve(url).toString();
          return 'url("$absoluteUrl")';
        }
        return match.group(0)!;
      });
      style.text = css;
    }
  }

  /// Costruisce un HTML ottimizzato con solo head e layerData
  String _buildOptimizedHtml(dom.Document document, dom.Element layerData) {
    // Converti tutti gli URL relativi in assoluti
    _convertRelativeUrlsToAbsolute(document);
    
    final head = document.head;
    
    // Crea un nuovo documento HTML
    final buffer = StringBuffer();
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html>');
    
    // Aggiungi l'head completo per CSS e font
    if (head != null) {
      buffer.writeln(head.outerHtml);
    } else {
      buffer.writeln('<head><meta charset="UTF-8"></head>');
    }
    
    buffer.writeln('<body style="margin:0;padding:0;background-color:black;">');
    
    // Aggiungi solo il layerData
    buffer.writeln(layerData.outerHtml);
    
    buffer.writeln('</body>');
    buffer.writeln('</html>');
    
    return buffer.toString();
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) async {
    // RÚV non ha pagine regionali, usa sempre le nazionali
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
    print('[IcelandProvider] Subpage cache cleared');
  }
}

