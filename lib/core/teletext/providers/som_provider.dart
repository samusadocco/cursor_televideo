import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';

/// Provider per canali tedeschi, austriaci e svizzeri sulla piattaforma SOM
/// (SAT.1, ProSieben, kabel eins, sixx, etc.)
class SOMProvider implements TeletextProvider {
  final String channelSelector; // es. 's1de' per SAT.1 Deutschland
  
  SOMProvider({required this.channelSelector});

  @override
  String get providerId => 'som_$channelSelector';

  @override
  String get providerName => 'SOM Teletextviewer ($channelSelector)';

  @override
  String get countryCode {
    // Determina il paese dal selettore (es. 's1de' -> 'DE', 's1at' -> 'AT', 's1ch' -> 'CH')
    if (channelSelector.endsWith('de')) return 'DE';
    if (channelSelector.endsWith('at')) return 'AT';
    if (channelSelector.endsWith('ch')) return 'CH';
    return 'DE'; // Default Germania
  }

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  static const String baseUrl = 'https://som-teletextviewer.sim-technik.de/tius/teletextviewer/desk.php';
  
  // Cache per il conteggio delle sottopagine
  final Map<int, _SubPageCacheEntry> _subPageCache = {};
  static const Duration _cacheTTL = Duration(minutes: 30);
  static const Duration _consistencyCheckInterval = Duration(minutes: 2);

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[SOMProvider] Fetching page $pageNumber subpage $subPage for $channelSelector');
      
      // Costruisci URL: pagnr=XXX_YY dove XXX è la pagina e YY è la sottopagina (con zero padding)
      final subPageStr = subPage.toString().padLeft(2, '0');
      final url = '$baseUrl?pagnr=${pageNumber}_$subPageStr&ttx_select=$channelSelector';
      print('[SOMProvider] URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return await _parseHtmlPage(response.body, pageNumber, subPage);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('[SOMProvider] Error fetching page: $e');
      rethrow;
    }
  }

  Future<TelevideoPage> _parseHtmlPage(String htmlContent, int pageNumber, int currentSubPage) async {
    final document = html_parser.parse(htmlContent);
    
    // Estrai l'immagine dal div.ttimagemap
    final imageMapDiv = document.querySelector('div.ttimagemap');
    if (imageMapDiv == null) {
      throw Exception('No ttimagemap div found');
    }
    
    final img = imageMapDiv.querySelector('img');
    if (img == null) {
      throw Exception('No image found in ttimagemap');
    }
    
    // Estrai URL immagine (relativo)
    final relativeImageUrl = img.attributes['src'];
    if (relativeImageUrl == null || relativeImageUrl.isEmpty) {
      throw Exception('No image src found');
    }
    
    // Converti URL relativo in assoluto
    final imageUrl = _makeAbsoluteUrl(relativeImageUrl);
    print('[SOMProvider] Image URL: $imageUrl');
    
    // Estrai dimensioni originali dell'immagine
    final width = int.tryParse(img.attributes['width'] ?? '400') ?? 400;
    final height = int.tryParse(img.attributes['height'] ?? '288') ?? 288;
    print('[SOMProvider] Original dimensions: ${width}x$height');
    
    // Estrai clickable areas dalla mappa
    final clickableAreas = _extractClickableAreas(imageMapDiv, width, height);
    print('[SOMProvider] Found ${clickableAreas.length} clickable areas');
    
    // Determina il numero totale di sottopagine
    int totalSubPages;
    if (_subPageCache.containsKey(pageNumber)) {
      final entry = _subPageCache[pageNumber]!;
      if (entry.isExpired(_cacheTTL)) {
        totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
      } else if (entry.needsConsistencyCheck(_consistencyCheckInterval)) {
        final cachedSubPageExists = await _checkSubPageExists(pageNumber, entry.count);
        if (!cachedSubPageExists) {
          _subPageCache.remove(pageNumber);
          totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
        } else {
          final hasMore = await _checkSubPageExists(pageNumber, entry.count + 1);
          if (hasMore) {
            totalSubPages = await _countTotalSubPages(pageNumber, entry.count);
            _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
          } else {
            totalSubPages = entry.count;
            _subPageCache[pageNumber] = entry.withVerification();
          }
        }
      } else {
        totalSubPages = entry.count;
      }
    } else {
      totalSubPages = await _reloadSubPageCount(pageNumber, currentSubPage);
    }
    
    print('[SOMProvider] Total subpages for page $pageNumber: $totalSubPages');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      totalSubPages: 1,
      clickableAreas: clickableAreas,
      providerId: providerId,
    );
  }

  String _makeAbsoluteUrl(String relativeUrl) {
    if (relativeUrl.startsWith('http')) {
      return relativeUrl;
    }
    // Rimuovi il leading './' se presente
    var cleanUrl = relativeUrl.startsWith('./') ? relativeUrl.substring(2) : relativeUrl;
    return 'https://som-teletextviewer.sim-technik.de/tius/teletextviewer/$cleanUrl';
  }

  List<ClickableArea> _extractClickableAreas(dom.Element imageMapDiv, int imageWidth, int imageHeight) {
    final areas = <ClickableArea>[];
    final map = imageMapDiv.querySelector('map');
    
    if (map == null) return areas;
    
    for (final area in map.querySelectorAll('area')) {
      final coordsStr = area.attributes['coords'];
      final href = area.attributes['href'];
      
      if (coordsStr == null || href == null) continue;
      
      // Parse coordinates: "x1 , y1 , x2 , y2"
      final coords = coordsStr.split(',').map((s) => s.trim()).map(int.tryParse).toList();
      if (coords.length != 4 || coords.any((c) => c == null)) continue;
      
      final x1 = coords[0]!;
      final y1 = coords[1]!;
      final x2 = coords[2]!;
      final y2 = coords[3]!;
      
      // Estrai numero di pagina dall'URL: pagnr=XXX_YY
      final pageMatch = RegExp(r'pagnr=(\d+)_\d+').firstMatch(href);
      if (pageMatch != null) {
        final targetPage = int.tryParse(pageMatch.group(1)!);
        if (targetPage != null) {
          areas.add(ClickableArea(
            targetPage: targetPage,
            x: x1,
            y: y1,
            width: x2 - x1,
            height: y2 - y1,
          ));
        }
      }
    }
    
    return areas;
  }

  /// Verifica se una sottopagina esiste controllando il valore dell'input
  Future<bool> _checkSubPageExists(int pageNumber, int subPage) async {
    try {
      final subPageStr = subPage.toString().padLeft(2, '0');
      final url = '$baseUrl?pagnr=${pageNumber}_$subPageStr&ttx_select=$channelSelector';
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return false;
      
      final document = html_parser.parse(response.body);
      
      // Cerca l'input con id="inputpagnrsub"
      final input = document.querySelector('input#inputpagnrsub');
      if (input == null) return false;
      
      final value = input.attributes['value'];
      if (value == null) return false;
      
      // Se il valore è uguale alla sottopagina richiesta, esiste
      // Altrimenti (es. torna '01' quando richiesta '02'), non esiste
      return value == subPageStr;
    } catch (e) {
      print('[SOMProvider] Error checking subpage $pageNumber/$subPage: $e');
      return false;
    }
  }

  Future<int> _countTotalSubPages(int pageNumber, int startFrom) async {
    int count = startFrom;
    
    // Cerca fino a trovare una sottopagina che non esiste
    for (int i = startFrom + 1; i <= 99; i++) {
      final exists = await _checkSubPageExists(pageNumber, i);
      if (!exists) break;
      count = i;
    }
    
    return count;
  }

  Future<int> _reloadSubPageCount(int pageNumber, int currentSubPage) async {
    print('[SOMProvider] Counting total subpages for page $pageNumber starting from $currentSubPage');
    
    // Parte dalla sottopagina corrente e cerca in avanti
    final totalSubPages = await _countTotalSubPages(pageNumber, currentSubPage);
    
    // Salva in cache
    _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
    print('[SOMProvider] ✅ Cached subpage count for page $pageNumber: $totalSubPages');
    
    return totalSubPages;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) {
    throw UnsupportedError('SOM provider does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?pagnr=${pageNumber}_01&ttx_select=$channelSelector'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Cache entry per le sottopagine
class _SubPageCacheEntry {
  final int count;
  final DateTime timestamp;
  final DateTime lastVerified;
  
  _SubPageCacheEntry(this.count, this.timestamp, {DateTime? lastVerified})
      : lastVerified = lastVerified ?? timestamp;
  
  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }
  
  bool needsConsistencyCheck(Duration checkInterval) {
    return DateTime.now().difference(lastVerified) > checkInterval;
  }
  
  _SubPageCacheEntry withVerification() {
    return _SubPageCacheEntry(count, timestamp, lastVerified: DateTime.now());
  }
}

