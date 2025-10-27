import 'package:dio/dio.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'dart:convert';

/// Provider per HRT Teletekst (Croazia)
class HRTProvider implements TeletextProvider {
  final Dio _dio;

  HRTProvider({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  String get providerId => 'hrt_teletekst';

  @override
  String get providerName => 'HRT Teletekst';

  @override
  String get countryCode => 'HR';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[HRTProvider] Fetching page $pageNumber subpage $subPage');

    // Formato: "100-01.HTML" (pagina-sottopagina.HTML)
    final subPageStr = subPage.toString().padLeft(2, '0');
    final pageParam = '$pageNumber-$subPageStr.HTML';
    
    final url = 'https://teletekst.hrt.hr/api/getNewPage?pageNum=$pageParam';

    try {
      final response = await _dio.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      return await _parseJsonResponse(response.data, pageNumber, subPage);
    } catch (e) {
      print('[HRTProvider] Error fetching page: $e');
      throw Exception('Failed to fetch page $pageNumber: $e');
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    throw UnimplementedError('HRT does not support regional teletext');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final url = 'https://teletekst.hrt.hr/api/getNewPage?pageNum=$pageNumber-01.HTML';
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e) {
      print('[HRTProvider] Error checking page existence: $e');
      return false;
    }
  }

  Future<TelevideoPage> _parseJsonResponse(dynamic data, int pageNumber, int currentSubPage) async {
    try {
      // Il response può essere già un Map o una String JSON
      final Map<String, dynamic> json = data is String ? jsonDecode(data) : data;

      // Estrai l'immagine base64
      final imageUrl = json['ttxImg'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('No image found in JSON response');
      }

      print('[HRTProvider] Image URL length: ${imageUrl.length} bytes');

      // Estrai le aree cliccabili dalla mappa
      final List<ClickableArea> clickableAreas = [];
      final mapData = json['map'] as Map<String, dynamic>?;
      
      if (mapData != null) {
        final areas = mapData['areas'] as List<dynamic>?;
        if (areas != null) {
          clickableAreas.addAll(_parseClickableAreas(areas));
        }
      }

      // Determina il numero totale di sottopagine
      // Se c'è NEXT_SUBPAGEREF, iteriamo per trovare l'ultima
      int totalSubPages = currentSubPage;
      
      final documentJson = json['documentJson'] as Map<String, dynamic>?;
      
      if (documentJson != null) {
        // La struttura è: documentJson -> DOCUMENT -> NEXT_SUBPAGEREF
        final document = documentJson['DOCUMENT'] as Map<String, dynamic>?;
        
        if (document != null) {
          final nextSubPageRef = document['NEXT_SUBPAGEREF'] as Map<String, dynamic>?;
          
          if (nextSubPageRef != null) {
            final nextSubPageValue = nextSubPageRef['_attributes']?['value'] as String?;
            
            // Se esiste una sottopagina successiva, conta tutte (sincrono con await)
            if (nextSubPageValue != null && nextSubPageValue.isNotEmpty) {
              print('[HRTProvider] Found next subpage reference: $nextSubPageValue');
              // Conta in modo sincrono (questo è già dentro un Future async)
              totalSubPages = await _countTotalSubPagesAsync(pageNumber, currentSubPage);
            }
          }
        }
      }

      print('[HRTProvider] Successfully parsed page $pageNumber, subpage $currentSubPage/$totalSubPages');
      print('[HRTProvider] Found ${clickableAreas.length} clickable areas');

      return TelevideoPage(
        pageNumber: pageNumber,
        subPage: currentSubPage,
        totalSubPages: totalSubPages,
        maxSubPages: totalSubPages,
        imageUrl: imageUrl,
        isHtmlContent: false,
        metadata: {},
        providerId: providerId,
        clickableAreas: clickableAreas,
      );
    } catch (e) {
      print('[HRTProvider] Error parsing JSON: $e');
      throw Exception('Failed to parse page JSON: $e');
    }
  }

  List<ClickableArea> _parseClickableAreas(List<dynamic> areas) {
    final List<ClickableArea> result = [];

    for (final area in areas) {
      try {
        final areaMap = area as Map<String, dynamic>;
        final name = areaMap['name'] as String?;
        final coords = areaMap['coords'] as List<dynamic>?;

        if (name == null || coords == null || coords.length != 4) {
          continue;
        }

        // Estrai il numero di pagina dal nome (es: "110-01.HTML" -> 110)
        final pageMatch = RegExp(r'(\d+)-').firstMatch(name);
        if (pageMatch == null) continue;

        final targetPage = int.tryParse(pageMatch.group(1)!);
        if (targetPage == null) continue;

        // Coordinate: [x1, y1, x2, y2]
        final x1 = (coords[0] as num).toInt();
        final y1 = (coords[1] as num).toInt();
        final x2 = (coords[2] as num).toInt();
        final y2 = (coords[3] as num).toInt();

        final width = (x2 - x1).abs();
        final height = (y2 - y1).abs();

        result.add(ClickableArea(
          x: x1,
          y: y1,
          width: width,
          height: height,
          targetPage: targetPage,
        ));

        print('[HRTProvider] Added clickable area: page=$targetPage, coords=($x1,$y1,$x2,$y2)');
      } catch (e) {
        print('[HRTProvider] Error parsing clickable area: $e');
      }
    }

    return result;
  }

  /// Conta il numero totale di sottopagine iterando fino a trovare l'ultima
  Future<int> _countTotalSubPagesAsync(int pageNumber, int startFrom) async {
    int currentSubPage = startFrom;
    const maxSubPages = 20; // Limite di sicurezza
    
    print('[HRTProvider] Counting total subpages for page $pageNumber starting from $startFrom...');
    
    while (currentSubPage < maxSubPages) {
      try {
        // Prova a caricare la sottopagina successiva
        final nextSubPage = currentSubPage + 1;
        final subPageStr = nextSubPage.toString().padLeft(2, '0');
        final pageParam = '$pageNumber-$subPageStr.HTML';
        final url = 'https://teletekst.hrt.hr/api/getNewPage?pageNum=$pageParam';
        
        final response = await _dio.get(url).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          final json = response.data is String ? jsonDecode(response.data) : response.data;
          final ttxImg = json['ttxImg'] as String?;
          
          if (ttxImg != null && ttxImg.isNotEmpty) {
            // Sottopagina trovata
            currentSubPage = nextSubPage;
            print('[HRTProvider] Found subpage $currentSubPage');
            
            // Controlla se c'è un'altra sottopagina dopo questa
            final documentJson = json['documentJson'] as Map<String, dynamic>?;
            final document = documentJson?['DOCUMENT'] as Map<String, dynamic>?;
            final nextSubPageRef = document?['NEXT_SUBPAGEREF'] as Map<String, dynamic>?;
            final nextSubPageValue = nextSubPageRef?['_attributes']?['value'] as String?;
            
            // Se non c'è più NEXT_SUBPAGEREF, questa è l'ultima
            if (nextSubPageValue == null || nextSubPageValue.isEmpty) {
              print('[HRTProvider] No more subpages, total: $currentSubPage');
              break;
            }
          } else {
            // Nessuna immagine, fine sottopagine
            break;
          }
        } else {
          // Errore HTTP, fine sottopagine
          break;
        }
      } catch (e) {
        // Timeout o errore, fine sottopagine
        print('[HRTProvider] Error checking subpage ${currentSubPage + 1}: $e');
        break;
      }
    }
    
    print('[HRTProvider] Total subpages found: $currentSubPage');
    return currentSubPage;
  }

}

