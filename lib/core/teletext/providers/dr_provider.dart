import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';

/// Provider per canali danesi DR (DR1, DR2)
class DRProvider implements TeletextProvider {
  final String channelId; // 'dr1' o 'dr2'
  
  // Cache per il numero totale di sottopagine per ogni pagina
  final Map<int, int> _subPageCache = {};
  
  DRProvider({required this.channelId});

  @override
  String get providerId => channelId;

  @override
  String get providerName => channelId == 'dr1' ? 'DR1 Text TV' : 'DR2 Text TV';

  @override
  String get countryCode => 'DK';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  String get baseUrl => channelId == 'dr1' 
      ? 'https://www.dr.dk/cgi-bin/fttv1.exe'
      : 'https://www.dr.dk/cgi-bin/fttv2.exe';

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[DRProvider] Fetching page $pageNumber subpage $subPage for $channelId');
      
      // Costruisci URL
      final url = subPage > 1 
          ? '$baseUrl/$pageNumber/$subPage'
          : '$baseUrl/$pageNumber';
      
      print('[DRProvider] URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return await _parseHtmlPage(response.body, pageNumber, subPage);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('[DRProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) {
    throw UnsupportedError('DR provider does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$pageNumber'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<TelevideoPage> _parseHtmlPage(String htmlContent, int pageNumber, int currentSubPage) async {
    final document = html_parser.parse(htmlContent);
    
    // Trova l'immagine principale (map name="ttv")
    final imgElement = document.querySelector('img[usemap="#ttv"]');
    if (imgElement == null) {
      throw Exception('No teletext image found in HTML');
    }

    final imageSrc = imgElement.attributes['src'];
    if (imageSrc == null) {
      throw Exception('No image src found');
    }

    final imageUrl = _makeAbsoluteUrl(imageSrc);
    
    // Dimensioni originali
    final originalImageWidth = int.tryParse(imgElement.attributes['width'] ?? '320') ?? 320;
    final originalImageHeight = int.tryParse(imgElement.attributes['height'] ?? '375') ?? 375;

    // Estrai clickable areas dalla mappa principale
    final mainMap = document.querySelector('map[name="ttv"]');
    List<ClickableArea> clickableAreas = [];
    if (mainMap != null) {
      clickableAreas = _extractClickableAreas(mainMap, originalImageWidth, originalImageHeight);
    }

    // Determina numero totale di sottopagine
    int totalSubPages;
    
    // Se è in cache, usa il valore cached
    if (_subPageCache.containsKey(pageNumber)) {
      totalSubPages = _subPageCache[pageNumber]!;
      print('[DRProvider] Using cached subpage count for page $pageNumber: $totalSubPages');
    } else {
      // Altrimenti, estrai dalla mappa FPMap1 (solo dalla prima sottopagina)
      totalSubPages = await _extractTotalSubPages(document, pageNumber);
      
      // Salva in cache
      _subPageCache[pageNumber] = totalSubPages;
      print('[DRProvider] Cached subpage count for page $pageNumber: $totalSubPages');
    }
    
    print('[DRProvider] Total subpages for page $pageNumber: $totalSubPages');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      totalSubPages: 1, // Always 1 for image-based pages
      clickableAreas: clickableAreas,
      providerId: providerId,
    );
  }

  String _makeAbsoluteUrl(String relativeUrl) {
    if (relativeUrl.startsWith('http')) {
      return relativeUrl;
    }
    return 'https://www.dr.dk$relativeUrl';
  }

  List<ClickableArea> _extractClickableAreas(dom.Element mapElement, int originalImageWidth, int originalImageHeight) {
    final areas = <ClickableArea>[];
    for (final areaElement in mapElement.querySelectorAll('area')) {
      final coords = areaElement.attributes['coords']?.split(',').map((e) => int.parse(e.trim())).toList();
      final href = areaElement.attributes['href'];

      if (coords != null && coords.length == 4 && href != null) {
        final x1 = coords[0];
        final y1 = coords[1];
        final x2 = coords[2];
        final y2 = coords[3];
        
        // Estrai numero di pagina dall'URL: /cgi-bin/fttv2.exe/XXX o /cgi-bin/fttv2.exe/XXX/Y
        final pageMatch = RegExp(r'/fttv\d\.exe/(\d+)').firstMatch(href);
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
    }
    return areas;
  }

  Future<int> _extractTotalSubPages(dom.Document document, int pageNumber) async {
    // Cerca la mappa FPMap1 che contiene i link alle sottopagine
    final subPageMap = document.querySelector('map[name="FPMap1"]');
    if (subPageMap == null) {
      // Nessuna mappa trovata, probabilmente solo 1 sottopagina
      print('[DRProvider] No FPMap1 found, assuming 1 subpage');
      return 1;
    }

    print('[DRProvider] Found FPMap1, analyzing subpages for page $pageNumber');
    
    int maxSubPage = 1;
    final List<int> subPages = [];
    
    // Estrai tutti i link alle sottopagine
    final areas = subPageMap.querySelectorAll('area');
    print('[DRProvider] Found ${areas.length} area elements in FPMap1');
    
    for (final areaElement in areas) {
      final href = areaElement.attributes['href'];
      print('[DRProvider] Checking href: $href');
      
      if (href != null) {
        // Pattern: /cgi-bin/fttv2.exe/100/2
        // Nota: usa interpolazione di stringa per pageNumber
        final pattern = '/fttv\\d\\.exe/$pageNumber/(\\d+)';
        final subPageMatch = RegExp(pattern).firstMatch(href);
        
        if (subPageMatch != null) {
          final subPageNum = int.tryParse(subPageMatch.group(1)!);
          print('[DRProvider] Found subpage: $subPageNum');
          
          if (subPageNum != null) {
            subPages.add(subPageNum);
            if (subPageNum > maxSubPage) {
              maxSubPage = subPageNum;
            }
          }
        } else {
          print('[DRProvider] No match for pattern: $pattern');
        }
      }
    }
    
    print('[DRProvider] Found subpage links: $subPages, max: $maxSubPage');
    
    // Se abbiamo trovato sottopagine, il massimo è il numero più alto
    // Altrimenti rimane 1
    return maxSubPage;
  }
}

