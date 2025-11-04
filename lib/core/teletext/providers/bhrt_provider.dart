import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per il canale Teletext bosniaco BHRT (Bosnia ed Erzegovina)
class BHRTProvider implements TeletextProvider {
  final Dio _dio;
  
  // Cache per il numero totale di sottopagine
  final Map<int, int> _subPageCache = {};

  BHRTProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'bhrt';

  @override
  String get providerName => 'BHRT Teletext';

  @override
  String get countryCode => 'BA';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  String get _baseUrl => 'https://teletext.bhrt.ba';

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[BHRTProvider] Fetching page $pageNumber subpage $subPage');
      
      // Calcola la directory (xxx mod 100) * 100
      final directory = (pageNumber ~/ 100) * 100;
      
      // Formatta il numero di sottopagina con 4 cifre
      final subPageStr = subPage.toString().padLeft(4, '0');
      
      // Costruisci l'URL: baseUrl/directory/pageNumber_subPage.htm
      final url = '$_baseUrl/$directory/${pageNumber}_$subPageStr.htm';
      print('[BHRTProvider] URL: $url (directory: $directory)');
      
      final response = await _dio.get(url);
      
      if (response.statusCode == 200) {
        final htmlContent = response.data as String;
        return await _parseHtmlPage(htmlContent, pageNumber, subPage, url);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('[BHRTProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) {
    throw UnsupportedError('BHRT provider does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final directory = (pageNumber ~/ 100) * 100;
      final url = '$_baseUrl/$directory/${pageNumber}_0001.htm';
      final response = await _dio.get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<TelevideoPage> _parseHtmlPage(
    String htmlContent,
    int pageNumber,
    int currentSubPage,
    String pageUrl,
  ) async {
    print('[BHRTProvider] Parsing HTML...');
    print('[BHRTProvider] HTML length: ${htmlContent.length} bytes');
    
    final document = html_parser.parse(htmlContent);
    
    // Cerca l'immagine con id="FABTTXImage"
    final imgElement = document.querySelector('img#FABTTXImage');
    
    if (imgElement == null) {
      print('[BHRTProvider] ⚠️ No element with id="FABTTXImage" found');
      throw Exception('No teletext image found in HTML');
    }
    
    // Ottieni l'URL dell'immagine
    final imgSrc = imgElement.attributes['src'];
    if (imgSrc == null) {
      throw Exception('Image src not found');
    }
    
    print('[BHRTProvider] Found image src: $imgSrc');
    
    // Converti l'URL relativo in assoluto
    final imageUrl = _makeAbsoluteImageUrl(imgSrc, pageNumber);
    print('[BHRTProvider] Absolute image URL: $imageUrl');
    
    // Ottieni il nome della mappa dall'attributo usemap
    final usemap = imgElement.attributes['usemap']?.replaceAll('#', '');
    
    List<ClickableArea> clickableAreas = [];
    
    if (usemap != null) {
      print('[BHRTProvider] Looking for map: $usemap');
      final mapElement = document.querySelector('map[name="$usemap"], map[id="$usemap"]');
      
      if (mapElement != null) {
        print('[BHRTProvider] Found map element');
        clickableAreas = _extractClickableAreas(mapElement, pageNumber);
        print('[BHRTProvider] Extracted ${clickableAreas.length} clickable areas');
      } else {
        print('[BHRTProvider] ⚠️ Map element not found');
      }
    }
    
    // Determina il numero totale di sottopagine
    int totalSubPages;
    
    if (_subPageCache.containsKey(pageNumber)) {
      totalSubPages = _subPageCache[pageNumber]!;
      print('[BHRTProvider] Using cached subpage count for page $pageNumber: $totalSubPages');
    } else {
      totalSubPages = _extractTotalSubPages(document, pageNumber);
      _subPageCache[pageNumber] = totalSubPages;
      print('[BHRTProvider] Cached subpage count for page $pageNumber: $totalSubPages');
    }
    
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

  String _makeAbsoluteImageUrl(String relativePath, int pageNumber) {
    if (relativePath.startsWith('http')) {
      return relativePath;
    }
    
    // Se è un path relativo semplice (es. "100_0001.png")
    // deve essere nella stessa directory della pagina HTML
    final directory = (pageNumber ~/ 100) * 100;
    
    if (relativePath.startsWith('../')) {
      // Path relativo con ../
      // Es: ../300/300_0001.htm
      final uri = Uri.parse(_baseUrl);
      return Uri.parse('${uri.scheme}://${uri.host}').resolve(relativePath).toString();
    } else {
      // Path semplice nella stessa directory
      return '$_baseUrl/$directory/$relativePath';
    }
  }

  List<ClickableArea> _extractClickableAreas(dom.Element mapElement, int currentPage) {
    final areas = <ClickableArea>[];
    
    for (final areaElement in mapElement.querySelectorAll('area')) {
      final coords = areaElement.attributes['coords']
          ?.split(',')
          .map((e) => int.tryParse(e.trim()) ?? 0)
          .toList();
      
      final href = areaElement.attributes['href'];
      
      if (coords != null && coords.length == 4 && href != null) {
        // Estrai il numero di pagina dall'href
        // Formato: "102_0001.htm" o "../300/300_0001.htm"
        final pageMatch = RegExp(r'(\d{3})_\d{4}\.htm').firstMatch(href);
        
        if (pageMatch != null) {
          final targetPage = int.tryParse(pageMatch.group(1)!);
          
          if (targetPage != null) {
            final x1 = coords[0];
            final y1 = coords[1];
            final x2 = coords[2];
            final y2 = coords[3];
            
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
    }
    
    return areas;
  }

  int _extractTotalSubPages(dom.Document document, int pageNumber) {
    // Cerca i link alle sottopagine nel formato: <a href="100_0002.htm">2</a>
    final links = document.querySelectorAll('a[href]');
    int maxSubPage = 1;
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null) {
        // Pattern: pageNumber_XXXX.htm
        final pattern = '${pageNumber}_\\d{4}\\.htm';
        final match = RegExp(pattern).firstMatch(href);
        
        if (match != null) {
          // Estrai il numero di sottopagina: 100_0002.htm -> 0002 -> 2
          final subPageMatch = RegExp(r'_(\d{4})\.htm').firstMatch(href);
          if (subPageMatch != null) {
            final subPageNum = int.tryParse(subPageMatch.group(1)!);
            if (subPageNum != null && subPageNum > maxSubPage) {
              maxSubPage = subPageNum;
            }
          }
        }
      }
    }
    
    print('[BHRTProvider] Found $maxSubPage subpages for page $pageNumber');
    return maxSubPage;
  }
}

