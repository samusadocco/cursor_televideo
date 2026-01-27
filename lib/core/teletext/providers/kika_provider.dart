import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per KiKA Teletext (Kinderkanal - ARD/ZDF Germania)
/// Canale basato su immagini con link cliccabili estratti da HTML
class KiKAProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.kika.de/kikatextpages/';

  KiKAProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'kika_text';

  @override
  String get providerName => 'KiKA Text';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await fetchNationalPage(pageNumber);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[KiKA] Fetching page $pageNumber, subpage $subPage');

    // Formato URL: 100_0001.htm (pagina + sottopagina con padding a 4 cifre)
    final subPageStr = subPage.toString().padLeft(4, '0');
    final targetUrl = '$_baseUrl${pageNumber}_$subPageStr.htm';
    
    print('[KiKA] Target URL: $targetUrl');

    try {
      final response = await _dio.get(
        targetUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        print('[KiKA] Page not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[KiKA] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      final document = html_parser.parse(htmlContent);

      // Estrai URL immagine da <img id="FABTTXImage" src="100_0001.png">
      final imgElement = document.querySelector('div#kikatext-page img#FABTTXImage');
      
      if (imgElement == null) {
        print('[KiKA] Error: image not found in div#kikatext-page');
        throw Exception('Immagine Teletext non trovata');
      }

      var imageUrl = imgElement.attributes['src'] ?? '';
      
      // Se l'URL è relativo, rendilo assoluto
      if (!imageUrl.startsWith('http')) {
        imageUrl = '$_baseUrl$imageUrl';
      }
      
      print('[KiKA] Image URL: $imageUrl');

      // Estrai link cliccabili da <map>
      final clickableAreas = _extractClickableAreas(document, pageNumber, subPage);
      print('[KiKA] Found ${clickableAreas.length} clickable areas');

      // Estrai dati pagina da <div id="kikatext-page-data">
      final pageData = _extractPageData(document);
      final maxSubPages = pageData['maxSubPages'] as int;
      final previousPage = pageData['previousPage'] as int?;
      final nextPage = pageData['nextPage'] as int?;
      
      print('[KiKA] Max subpages: $maxSubPages');
      print('[KiKA] Navigation: prev=$previousPage, next=$nextPage');

      return TelevideoPage(
        pageNumber: pageNumber,
        imageUrl: imageUrl,
        subPage: subPage,
        maxSubPages: maxSubPages,
        isHtmlContent: false,
        providerId: providerId,
        clickableAreas: clickableAreas,
        metadata: {
          'source': 'kika',
          'format': 'image',
          'originalUrl': targetUrl,
          'linksCount': clickableAreas.length,
          'previousPage': previousPage,
          'nextPage': nextPage,
        },
      );
    } catch (e) {
      print('[KiKA] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae le aree cliccabili dalla mappa HTML
  List<ClickableArea> _extractClickableAreas(dynamic document, int currentPage, int currentSubPage) {
    final clickableAreas = <ClickableArea>[];

    // Cerca <map name="M100_0001"> (nome basato su pagina + sottopagina)
    final subPageStr = currentSubPage.toString().padLeft(4, '0');
    final mapName = 'M${currentPage}_$subPageStr';
    final map = document.querySelector('map[name="$mapName"], map#$mapName');
    
    if (map == null) {
      print('[KiKA] No image map found with name/id: $mapName');
      return clickableAreas;
    }

    // Estrai tutti i <area> tags
    final areas = map.querySelectorAll('area[href]');
    
    for (final area in areas) {
      final href = area.attributes['href'];
      final coords = area.attributes['coords'];
      final alt = area.attributes['alt'];
      
      if (href != null && coords != null) {
        // Link formato: #101_0001.htm → pagina 101
        // Rimuovi # iniziale e .htm finale, poi estrai numero pagina
        final cleanHref = href.replaceAll('#', '').replaceAll('.htm', '');
        final parts = cleanHref.split('_');
        
        if (parts.isNotEmpty) {
          final targetPage = int.tryParse(parts[0]);
          
          if (targetPage != null && targetPage >= 100 && targetPage <= 999) {
            // Parsing coordinate: "228,14,263,28" → x1,y1,x2,y2
            final coordsList = coords.split(',').map((c) => int.tryParse(c.trim()) ?? 0).toList();
            
            if (coordsList.length >= 4) {
              final x = coordsList[0];
              final y = coordsList[1];
              final x2 = coordsList[2];
              final y2 = coordsList[3];
              final width = x2 - x;
              final height = y2 - y;
              
              clickableAreas.add(ClickableArea(
                targetPage: targetPage,
                x: x,
                y: y,
                width: width,
                height: height,
                description: alt ?? 'Pagina $targetPage',
              ));
            }
          }
        }
      }
    }

    return clickableAreas;
  }

  /// Estrae dati pagina da <div id="kikatext-page-data"> e <div class="SUBPGLIST">
  Map<String, dynamic> _extractPageData(dynamic document) {
    int maxSubPages = 1;
    int? previousPage;
    int? nextPage;

    // Estrai dati JSON da data-kikatext-page
    // Esempio: data-kikatext-page="{&quot;PAGENUM&quot;:&quot;100&quot;,&quot;SUBPGNUM&quot;:&quot;1&quot;,&quot;PREVPGNUM&quot;:&quot;&quot;,&quot;NEXTPGNUM&quot;:&quot;101&quot;}"
    final pageDataDiv = document.querySelector('div#kikatext-page-data');
    
    if (pageDataDiv != null) {
      final dataAttr = pageDataDiv.attributes['data-kikatext-page'];
      
      if (dataAttr != null) {
        try {
          // Decodifica HTML entities (&quot; → ")
          final decodedJson = dataAttr
              .replaceAll('&quot;', '"')
              .replaceAll('&amp;', '&')
              .replaceAll('&lt;', '<')
              .replaceAll('&gt;', '>');
          
          final data = jsonDecode(decodedJson) as Map<String, dynamic>;
          
          // Estrai PREVPGNUM e NEXTPGNUM
          final prevStr = data['PREVPGNUM'] as String?;
          final nextStr = data['NEXTPGNUM'] as String?;
          
          if (prevStr != null && prevStr.isNotEmpty) {
            previousPage = int.tryParse(prevStr);
          }
          
          if (nextStr != null && nextStr.isNotEmpty) {
            nextPage = int.tryParse(nextStr);
          }
          
          print('[KiKA] Page data: PREVPGNUM=$prevStr, NEXTPGNUM=$nextStr');
        } catch (e) {
          print('[KiKA] Error parsing page data JSON: $e');
        }
      }
    }

    // Estrai numero massimo sottopagine da <div class="SUBPGLIST">
    // Esempio: 1, <a href="#100_0002.htm">2</a>, <a href="#100_0003.htm">3</a>, ...
    final subpgList = document.querySelector('div.SUBPGLIST');
    
    if (subpgList != null) {
      final links = subpgList.querySelectorAll('a[href]');
      
      for (final link in links) {
        final href = link.attributes['href'];
        if (href != null) {
          // Link formato: #100_0002.htm → sottopagina 2
          final cleanHref = href.replaceAll('#', '').replaceAll('.htm', '');
          final parts = cleanHref.split('_');
          
          if (parts.length >= 2) {
            final subPageNum = int.tryParse(parts[1]);
            if (subPageNum != null && subPageNum > maxSubPages) {
              maxSubPages = subPageNum;
            }
          }
        }
      }
      
      print('[KiKA] Found $maxSubPages subpages from SUBPGLIST');
    }

    return {
      'maxSubPages': maxSubPages,
      'previousPage': previousPage,
      'nextPage': nextPage,
    };
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // KiKA non ha pagine regionali
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  void dispose() {
    _dio.close();
  }
}
