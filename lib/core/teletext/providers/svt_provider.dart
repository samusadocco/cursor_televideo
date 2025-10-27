import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per SVT Text (Svezia)
class SVTProvider implements TeletextProvider {
  final Dio _dio;

  SVTProvider({
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  String get providerId => 'svt_text';

  @override
  String get providerName => 'SVT Text';

  @override
  String get countryCode => 'SE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[SVTProvider] Fetching page $pageNumber subpage $subPage');

    // URL: https://www.svt.se/text-tv/100
    final url = 'https://www.svt.se/text-tv/$pageNumber';

    try {
      print('[SVTProvider] Requesting URL: $url');
      final response = await _dio.get(url);
      print('[SVTProvider] Response status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      print('[SVTProvider] HTML received, length: ${response.data.toString().length} bytes');
      return _parseHtmlPage(response.data, pageNumber, subPage);
    } catch (e) {
      print('[SVTProvider] Error fetching page: $e');
      throw Exception('Failed to fetch page $pageNumber: $e');
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    throw UnimplementedError('SVT does not support regional teletext');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final url = 'https://www.svt.se/text-tv/$pageNumber';
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e) {
      print('[SVTProvider] Error checking page existence: $e');
      return false;
    }
  }

  TelevideoPage _parseHtmlPage(String html, int pageNumber, int currentSubPage) {
    try {
      final document = html_parser.parse(html);
      
      // Trova tutti i contenitori di immagini (ogni contenitore = una sottopagina)
      final imageWrappers = document.querySelectorAll('div.Content_imageWrapper__dAgeH');
      
      if (imageWrappers.isEmpty) {
        throw Exception('No teletext image wrappers found in HTML');
      }

      // Il numero totale di sottopagine corrisponde al numero di wrapper
      final totalSubPages = imageWrappers.length;
      
      print('[SVTProvider] Found $totalSubPages subpage(s) for page $pageNumber');

      // Seleziona il wrapper corretto in base alla sottopagina richiesta
      // currentSubPage è 1-based, quindi sottraiamo 1 per l'indice
      final subPageIndex = (currentSubPage - 1).clamp(0, totalSubPages - 1);
      final currentWrapper = imageWrappers[subPageIndex];

      // Cerca l'immagine all'interno di questo wrapper specifico
      final img = currentWrapper.querySelector('img.Content_pageImage__bS0mg');
      if (img == null) {
        throw Exception('No teletext image found in subpage wrapper $currentSubPage');
      }

      final imageSrc = img.attributes['src'];
      if (imageSrc == null || imageSrc.isEmpty) {
        throw Exception('Image URL not found in HTML');
      }

      // L'immagine può essere base64 o URL normale
      final imageUrl = imageSrc.startsWith('data:') 
          ? imageSrc // Base64 già completo
          : 'https://www.svt.se$imageSrc'; // URL relativo

      // Cerca la mappa di link cliccabili per questa sottopagina specifica
      final useMapAttr = img.attributes['usemap'];
      final List<ClickableArea> clickableAreas = [];

      if (useMapAttr != null && useMapAttr.isNotEmpty) {
        // Rimuovi il # dall'inizio (es: "#100-01" -> "100-01")
        final mapName = useMapAttr.replaceFirst('#', '');
        final mapElement = document.querySelector('map[name="$mapName"]');

        if (mapElement != null) {
          clickableAreas.addAll(_parseClickableAreas(mapElement));
          print('[SVTProvider] Found ${clickableAreas.length} clickable areas in map "$mapName"');
        }
      }

      // Estrai le informazioni di navigazione (prevPage/nextPage)
      String? prevPage;
      String? nextPage;

      // Cerca i link di navigazione nella barra superiore
      // Ci sono 2 link con classe NavigationArrow_enabled__ueMbi:
      // 1. Primo = pagina precedente (Förra sidan)
      // 2. Secondo = pagina successiva (Nästa sida)
      final navLinks = document.querySelectorAll('a.NavigationArrow_enabled__ueMbi');
      
      if (navLinks.isNotEmpty) {
        // Primo link = pagina precedente
        final prevLink = navLinks[0];
        final prevHref = prevLink.attributes['href'];
        if (prevHref != null) {
          final match = RegExp(r'/text-tv/(\d+)').firstMatch(prevHref);
          if (match != null) {
            prevPage = match.group(1);
          }
        }
        
        // Secondo link = pagina successiva (se esiste)
        if (navLinks.length > 1) {
          final nextLink = navLinks[1];
          final nextHref = nextLink.attributes['href'];
          if (nextHref != null) {
            final match = RegExp(r'/text-tv/(\d+)').firstMatch(nextHref);
            if (match != null) {
              nextPage = match.group(1);
            }
          }
        }
      }

      print('[SVTProvider] Successfully parsed page $pageNumber, subpage $currentSubPage/$totalSubPages');
      print('[SVTProvider] Image URL: ${imageUrl.substring(0, 50)}...');
      print('[SVTProvider] Found ${clickableAreas.length} clickable links');
      print('[SVTProvider] Navigation: prev=$prevPage, next=$nextPage');

      return TelevideoPage(
        pageNumber: pageNumber,
        subPage: currentSubPage,
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
      print('[SVTProvider] Error parsing HTML: $e');
      throw Exception('Failed to parse page HTML: $e');
    }
  }

  List<ClickableArea> _parseClickableAreas(dom.Element mapElement) {
    final List<ClickableArea> areas = [];

    // Trova tutti gli <AREA> o <area> tag nella mappa (case insensitive)
    final areaElements = mapElement.querySelectorAll('area, AREA');
    
    print('[SVTProvider] Found ${areaElements.length} area elements in map');

    for (final area in areaElements) {
      try {
        // Prova sia minuscolo che maiuscolo per gli attributi
        final coords = area.attributes['coords'] ?? area.attributes['COORDS'];
        final href = area.attributes['href'] ?? area.attributes['HREF'];

        if (coords == null || href == null) {
          print('[SVTProvider] Skipping area: coords=$coords, href=$href');
          continue;
        }

        // Parse coordinates: "x1,y1,x2,y2"
        final coordsList = coords.split(',').map((c) => int.tryParse(c.trim()) ?? 0).toList();
        if (coordsList.length != 4) {
          print('[SVTProvider] Invalid coords format: $coords');
          continue;
        }

        final x1 = coordsList[0];
        final y1 = coordsList[1];
        final x2 = coordsList[2];
        final y2 = coordsList[3];

        // Calcola dimensioni del rettangolo
        final width = (x2 - x1).abs();
        final height = (y2 - y1).abs();

        // Estrai il numero di pagina dall'href
        // SVT usa solo il numero (es: "403") o path completo (es: "/text-tv/403")
        final pageMatch = RegExp(r'(\d+)').firstMatch(href);
        if (pageMatch != null) {
          final targetPage = int.tryParse(pageMatch.group(1)!);
          if (targetPage != null) {
            print('[SVTProvider] Adding clickable area: page=$targetPage, coords=($x1,$y1,$x2,$y2)');
            areas.add(ClickableArea(
              x: x1,
              y: y1,
              width: width,
              height: height,
              targetPage: targetPage,
            ));
          }
        } else {
          print('[SVTProvider] Could not extract page number from href: $href');
        }
      } catch (e) {
        print('[SVTProvider] Error parsing clickable area: $e');
      }
    }

    print('[SVTProvider] Total clickable areas parsed: ${areas.length}');
    return areas;
  }
}




