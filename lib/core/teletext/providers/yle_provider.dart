import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per YLE Teksti-TV (Finlandia)
/// 
/// URL API: https://yle.fi/aihe/yle-ttv/json?P={pageNumber}_{subPage}
class YLEProvider implements TeletextProvider {
  final Dio _dio;
  
  // Cache per il numero totale di sottopagine per ogni pagina
  // Key: pageNumber, Value: totalSubPages
  final Map<int, int> _subPageCache = {};

  YLEProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'yle_teksti_tv';

  @override
  String get providerName => 'YLE Teksti-TV';

  @override
  String get countryCode => 'FI';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[YLEProvider] Fetching page $pageNumber subpage $subPage');
    
    // YLE usa un formato API JSON
    // Formato: https://yle.fi/aihe/yle-ttv/json?P=100_0001
    final subPageStr = subPage.toString().padLeft(4, '0');
    final apiUrl = 'https://yle.fi/aihe/yle-ttv/json?P=${pageNumber}_$subPageStr';
    
    print('[YLEProvider] API URL: $apiUrl');
    
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      final jsonData = response.data as Map<String, dynamic>;
      return await _parseJsonPage(jsonData, pageNumber, subPage);
      
    } catch (e) {
      print('[YLEProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Parse la risposta JSON dall'API YLE
  Future<TelevideoPage> _parseJsonPage(Map<String, dynamic> json, int pageNumber, int requestedSubPage) async {
    try {
      print('[YLEProvider] Parsing JSON response...');
      
      // Verifica la struttura JSON
      if (json['meta'] == null || json['data'] == null) {
        throw Exception('Invalid JSON structure');
      }
      
      final meta = json['meta'] as Map<String, dynamic>;
      final code = meta['code'] as String?;
      
      if (code != '200') {
        throw Exception('API returned error code: $code');
      }
      
      final dataList = json['data'] as List<dynamic>;
      if (dataList.isEmpty) {
        throw Exception('No data in response');
      }
      
      final data = dataList[0] as Map<String, dynamic>;
      
      // Estrai informazioni sulla pagina
      final pageInfo = data['page'] as Map<String, dynamic>?;
      final info = data['info'] as Map<String, dynamic>?;
      final content = data['content'] as Map<String, dynamic>?;
      
      if (pageInfo == null || info == null || content == null) {
        throw Exception('Missing required fields in JSON');
      }
      
      // Numero di sottopagine
      final pageData = info['page'] as Map<String, dynamic>?;
      final subpagesStr = pageData?['subpages'] as String?;
      int totalSubPages;
      
      if (subpagesStr != null && subpagesStr.isNotEmpty) {
        // Se abbiamo il campo subpages, usalo e salvalo in cache
        totalSubPages = int.tryParse(subpagesStr) ?? 1;
        _subPageCache[pageNumber] = totalSubPages;
        print('[YLEProvider] Total subpages from API: $totalSubPages (cached)');
      } else if (_subPageCache.containsKey(pageNumber)) {
        // Se non abbiamo il campo subpages, usa il valore dalla cache
        totalSubPages = _subPageCache[pageNumber]!;
        print('[YLEProvider] Total subpages from cache: $totalSubPages');
      } else {
        // Se non abbiamo né il campo né la cache, assumiamo 1 sottopagina
        // e facciamo una richiesta alla prima sottopagina per ottenere il conteggio
        totalSubPages = await _fetchTotalSubPages(pageNumber);
        print('[YLEProvider] Total subpages fetched: $totalSubPages');
      }
      
      // Estrai l'immagine (base64)
      final imageHtml = content['image'] as String?;
      String imageUrl = '';
      
      if (imageHtml != null && imageHtml.isNotEmpty) {
        // Parse l'HTML per estrarre l'immagine base64
        final document = html_parser.parse(imageHtml);
        final imgElement = document.querySelector('img');
        
        if (imgElement != null) {
          final src = imgElement.attributes['src'];
          if (src != null && src.startsWith('data:image/')) {
            imageUrl = src;
            print('[YLEProvider] Found base64 image');
          }
        }
      }
      
      if (imageUrl.isEmpty) {
        throw Exception('No image found in response');
      }
      
      // Estrai le aree cliccabili dalla mappa
      final clickableAreas = _parseClickableAreas(content);
      
      print('[YLEProvider] Found ${clickableAreas.length} clickable areas');
      
      // Estrai prev/next dalla paginazione
      final pagination = content['pagination'] as String?;
      String? prevPage;
      String? nextPage;
      
      if (pagination != null) {
        final paginationDoc = html_parser.parse(pagination);
        
        // Cerca il link "Seuraava sivu" (pagina successiva)
        final nextLink = paginationDoc.querySelector('a.js-yle-ttv-next-page');
        if (nextLink != null) {
          final href = nextLink.attributes['href'];
          if (href != null) {
            // Formato: ?P=101
            final match = RegExp(r'\?P=(\d+)').firstMatch(href);
            if (match != null) {
              nextPage = match.group(1);
            }
          }
        }
        
        // Cerca il link alla pagina precedente (se esiste)
        final prevLink = paginationDoc.querySelector('a[title*="Edellinen"]');
        if (prevLink != null) {
          final href = prevLink.attributes['href'];
          if (href != null) {
            final match = RegExp(r'\?P=(\d+)').firstMatch(href);
            if (match != null) {
              prevPage = match.group(1);
            }
          }
        }
      }
      
      print('[YLEProvider] Navigation: prev=$prevPage, next=$nextPage');
      
      return TelevideoPage(
        pageNumber: pageNumber,
        subPage: requestedSubPage,
        totalSubPages: totalSubPages,
        maxSubPages: totalSubPages,
        imageUrl: imageUrl,
        isHtmlContent: false,
        metadata: {
          'prevPage': prevPage,
          'nextPage': nextPage,
        },
        providerId: providerId,
        clickableAreas: clickableAreas,
      );
      
    } catch (e) {
      print('[YLEProvider] Error parsing JSON: $e');
      throw Exception('Failed to parse page JSON: $e');
    }
  }
  
  /// Estrae le aree cliccabili dalla mappa HTML
  List<ClickableArea> _parseClickableAreas(Map<String, dynamic> content) {
    final List<ClickableArea> areas = [];
    
    try {
      // YLE ha un campo separato 'image_map' che contiene la mappa HTML
      final imageMapHtml = content['image_map'] as String?;
      if (imageMapHtml == null || imageMapHtml.isEmpty) {
        print('[YLEProvider] No image_map field found');
        return areas;
      }
      
      final document = html_parser.parse(imageMapHtml);
      
      // Trova l'elemento <map>
      final mapElement = document.querySelector('map');
      if (mapElement == null) {
        print('[YLEProvider] No <map> element found in image_map');
        return areas;
      }
      
      // Estrai tutte le <area>
      final areaElements = mapElement.querySelectorAll('area');
      print('[YLEProvider] Found ${areaElements.length} area elements');
      
      for (final area in areaElements) {
        final shape = area.attributes['shape'];
        final coords = area.attributes['coords'];
        final href = area.attributes['href'];
        
        // Solo le aree rettangolari con href valido che puntano a pagine (?P=xxx)
        if (shape == 'rect' && coords != null && href != null && href.contains('?P=')) {
          // Parse le coordinate
          final coordsList = coords.split(',');
          if (coordsList.length == 4) {
            final x1 = int.tryParse(coordsList[0].trim());
            final y1 = int.tryParse(coordsList[1].trim());
            final x2 = int.tryParse(coordsList[2].trim());
            final y2 = int.tryParse(coordsList[3].trim());
            
            if (x1 != null && y1 != null && x2 != null && y2 != null) {
              // Estrai il numero di pagina dall'href
              // Formato: ?P=101 o ?P=100#2 (sottopagina)
              final pageMatch = RegExp(r'\?P=(\d+)').firstMatch(href);
              if (pageMatch != null) {
                final targetPage = int.tryParse(pageMatch.group(1)!);
                if (targetPage != null && targetPage >= 100 && targetPage <= 899) {
                  areas.add(ClickableArea(
                    x: x1,
                    y: y1,
                    width: x2 - x1,
                    height: y2 - y1,
                    targetPage: targetPage,
                  ));
                  print('[YLEProvider] Added clickable area: page $targetPage at ($x1,$y1) ${x2-x1}x${y2-y1}');
                }
              }
            }
          }
        }
      }
      
      print('[YLEProvider] Total clickable areas parsed: ${areas.length}');
    } catch (e) {
      print('[YLEProvider] Error parsing clickable areas: $e');
    }
    
    return areas;
  }
  
  /// Recupera il numero totale di sottopagine richiedendo la prima sottopagina
  Future<int> _fetchTotalSubPages(int pageNumber) async {
    try {
      print('[YLEProvider] Fetching total subpages for page $pageNumber...');
      
      final apiUrl = 'https://yle.fi/aihe/yle-ttv/json?P=${pageNumber}_0001';
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final dataList = jsonData['data'] as List<dynamic>?;
        
        if (dataList != null && dataList.isNotEmpty) {
          final data = dataList[0] as Map<String, dynamic>;
          final info = data['info'] as Map<String, dynamic>?;
          final pageData = info?['page'] as Map<String, dynamic>?;
          final subpagesStr = pageData?['subpages'] as String?;
          
          if (subpagesStr != null && subpagesStr.isNotEmpty) {
            final total = int.tryParse(subpagesStr) ?? 1;
            _subPageCache[pageNumber] = total;
            return total;
          }
        }
      }
    } catch (e) {
      print('[YLEProvider] Error fetching total subpages: $e');
    }
    
    // Default: 1 sottopagina
    return 1;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) async {
    throw UnimplementedError('YLE does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final url = 'https://yle.fi/aihe/yle-ttv/json?P=${pageNumber}_0001';
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e) {
      print('[YLEProvider] Error checking page existence: $e');
      return false;
    }
  }
}

