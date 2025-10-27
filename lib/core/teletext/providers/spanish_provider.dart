import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per i canali Teletext iberici (TVE, Antena 3, La Sexta, RTP)
class SpanishProvider implements TeletextProvider {
  final Dio _dio;
  final String channelId;
  final String _baseUrl;
  final String _channelCode;
  final String _countryCode;

  SpanishProvider({
    Dio? dio,
    required this.channelId,
  })  : _dio = dio ?? Dio(),
        _baseUrl = _getBaseUrl(channelId),
        _channelCode = _getChannelCode(channelId),
        _countryCode = _getCountryCode(channelId);

  static String _getBaseUrl(String channelId) {
    switch (channelId) {
      case 'tve':
        return 'https://www.rtve.es/tve/teletexto';
      case 'antena3':
        return 'https://www.antena3.com/teletexto';
      case 'lasexta':
        return 'https://www.lasexta.com/teletexto/datos';
      case 'rtp':
        return 'https://www.rtp.pt/wportal/teletexto';
      default:
        return 'https://www.rtve.es/tve/teletexto';
    }
  }

  static String _getChannelCode(String channelId) {
    switch (channelId) {
      case 'tve':
        return 'TVE';
      case 'antena3':
        return 'Antena 3';
      case 'lasexta':
        return 'La Sexta';
      case 'rtp':
        return 'RTP';
      default:
        return 'TVE';
    }
  }

  static String _getCountryCode(String channelId) {
    switch (channelId) {
      case 'rtp':
        return 'PT';
      default:
        return 'ES';
    }
  }

  @override
  String get providerId => channelId;

  @override
  String get providerName => 'Iberian Teletext - $_channelCode';

  @override
  String get countryCode => _countryCode;

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[SpanishProvider] Fetching page $pageNumber subpage $subPage for $_channelCode');

    // Formato URL: https://www.rtve.es/tve/teletexto/200/234_0001.htm
    // Il path della directory è basato sulla centinaia: (pageNumber ~/ 100) * 100
    // Esempio: pagina 234 -> directory 200, pagina 567 -> directory 500
    final directoryNumber = (pageNumber ~/ 100) * 100;
    
    // Le sottopagine sono numerate: 234_0001.htm, 234_0002.htm, etc.
    final subPageStr = subPage.toString().padLeft(4, '0');
    final url = '$_baseUrl/$directoryNumber/${pageNumber}_$subPageStr.htm';

    print('[SpanishProvider] URL: $url (directory: $directoryNumber)');

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      return _parseHtmlPage(htmlContent, pageNumber, subPage, url);
    } catch (e) {
      print('[SpanishProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Parse la pagina HTML per estrarre l'immagine
  TelevideoPage _parseHtmlPage(String htmlContent, int pageNumber, int subPage, String pageUrl) {
    print('[SpanishProvider] Parsing HTML...');
    print('[SpanishProvider] HTML length: ${htmlContent.length} bytes');

    final document = html_parser.parse(htmlContent);

    // Strategia 1: Cerca l'immagine nel tag con id="FABTTXImage"
    String? imageUrl;
    String? mapName;
    var imgElement = document.getElementById('FABTTXImage');

    if (imgElement != null) {
      final src = imgElement.attributes['src'];
      final usemap = imgElement.attributes['usemap'];
      print('[SpanishProvider] Found image element with src: $src, usemap: $usemap');

      // Estrai il nome della map (rimuove il # iniziale)
      if (usemap != null && usemap.startsWith('#')) {
        mapName = usemap.substring(1);
        print('[SpanishProvider] Map name: $mapName');
      }

      if (src != null) {
        // L'URL dell'immagine è relativo, costruiamo l'URL assoluto
        if (src.startsWith('http')) {
          imageUrl = src;
        } else {
          // Il path dell'immagine è relativo alla directory delle centinaia
          // Esempio: src="234_0001.png" -> https://www.rtve.es/tve/teletexto/200/234_0001.png
          final directoryNumber = (pageNumber ~/ 100) * 100;
          imageUrl = '$_baseUrl/$directoryNumber/$src';
        }
        print('[SpanishProvider] ✅ Resolved image URL: $imageUrl');
      }
    } else {
      print('[SpanishProvider] ⚠️ No element with id="FABTTXImage" found');
      
      // Strategia 2: Cerca qualsiasi immagine con pattern PageNumber_SubPage.png
      final subPageStr = subPage.toString().padLeft(4, '0');
      final expectedImageName = '${pageNumber}_$subPageStr.png';
      
      // Cerca tutte le immagini
      final allImages = document.querySelectorAll('img');
      print('[SpanishProvider] Searching among ${allImages.length} images for pattern: $expectedImageName');
      
      for (final img in allImages) {
        final src = img.attributes['src'];
        final usemap = img.attributes['usemap'];
        
        if (src != null && src.contains(expectedImageName)) {
          print('[SpanishProvider] Found image with matching pattern: $src');
          
          // Estrai mapName se presente
          if (usemap != null && usemap.startsWith('#')) {
            mapName = usemap.substring(1);
            print('[SpanishProvider] Map name: $mapName');
          }
          
          // Costruisci URL assoluto
          if (src.startsWith('http')) {
            imageUrl = src;
          } else {
            final directoryNumber = (pageNumber ~/ 100) * 100;
            imageUrl = '$_baseUrl/$directoryNumber/$src';
          }
          print('[SpanishProvider] ✅ Resolved image URL (fallback): $imageUrl');
          break;
        }
      }
    }

    if (imageUrl == null) {
      throw Exception('No teletext image found in HTML');
    }

    // Cerca il numero totale di sottopagine
    int totalSubPages = 1;
    
    // Le sottopagine sono linkate nella parte inferiore della pagina
    // Formato: <a href="100_0001.htm?sbp=1">1</a>, <a href="100_0002.htm?sbp=2">2</a>, ...
    final subpageLinks = document.querySelectorAll('a[href*="_"]');
    
    for (final link in subpageLinks) {
      final href = link.attributes['href'] ?? '';
      final match = RegExp(r'_(\d+)\.htm').firstMatch(href);
      if (match != null) {
        final subPageNum = int.tryParse(match.group(1)!);
        if (subPageNum != null && subPageNum > totalSubPages) {
          totalSubPages = subPageNum;
        }
      }
    }

    print('[SpanishProvider] Found $totalSubPages subpage(s)');

    // Estrai link di navigazione (prev/next page)
    final navigationLinks = _extractNavigationLinks(document, pageNumber);

    // Estrai clickable areas dalla map se presente
    final clickableAreas = mapName != null 
        ? _extractClickableAreas(document, mapName)
        : <ClickableArea>[];

    if (subPage > totalSubPages)  
      totalSubPages = subPage;
    print('[SpanishProvider] SubPage info: $subPage/$totalSubPages');
    print('[SpanishProvider] Navigation: prev=${navigationLinks['prev']}, next=${navigationLinks['next']}');
    print('[SpanishProvider] Clickable areas found: ${clickableAreas.length}');

    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: imageUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: false,
      providerId: providerId,
      metadata: navigationLinks,
    );
  }

  /// Estrae i link di navigazione dalla pagina
  Map<String, dynamic> _extractNavigationLinks(dom.Document document, int currentPage) {
    final result = <String, dynamic>{};

    // Cerca link "Anterior" (precedente) e "Siguiente" (successivo)
    final links = document.querySelectorAll('a[href]');

    for (final link in links) {
      final href = link.attributes['href'] ?? '';
      final text = link.text.trim().toLowerCase();

      // Estrai numero pagina dall'href
      final pageMatch = RegExp(r'/(\d+)/\d+_').firstMatch(href);
      if (pageMatch != null) {
        final targetPage = int.tryParse(pageMatch.group(1)!);

        if (targetPage != null && targetPage != currentPage) {
          if (text.contains('anterior') || text.contains('prev')) {
            result['prev'] = targetPage;
            result['previousPage'] = targetPage;
          } else if (text.contains('siguiente') || text.contains('next')) {
            result['next'] = targetPage;
            result['nextPage'] = targetPage;
          }
        }
      }
    }

    return result;
  }

  /// Estrae le aree cliccabili dalla map HTML
  List<ClickableArea> _extractClickableAreas(dom.Document document, String mapName) {
    final clickableAreas = <ClickableArea>[];

    print('[SpanishProvider] Looking for map: $mapName');

    // Cerca la map con il nome specificato
    final mapElement = document.querySelector('map[name="$mapName"], map[id="$mapName"]');

    if (mapElement == null) {
      print('[SpanishProvider] ⚠️ Map "$mapName" not found');
      return clickableAreas;
    }

    print('[SpanishProvider] ✅ Found map: $mapName');

    // Cerca tutte le area dentro la map
    final areaElements = mapElement.querySelectorAll('area[shape="rect"]');
    print('[SpanishProvider] Found ${areaElements.length} area elements');

    for (final area in areaElements) {
      final coords = area.attributes['coords'];
      final href = area.attributes['href'];

      if (coords != null && href != null) {
        // Parse delle coordinate: "x1,y1,x2,y2"
        final coordsList = coords.split(',').map((c) => int.tryParse(c.trim())).whereType<int>().toList();

        if (coordsList.length >= 4) {
          // Estrai il numero di pagina dall'href (formato: "234_0001.htm")
          final pageMatch = RegExp(r'(\d+)_\d+\.htm').firstMatch(href);

          if (pageMatch != null) {
            final targetPage = int.tryParse(pageMatch.group(1)!);

            if (targetPage != null) {
              final x = coordsList[0];
              final y = coordsList[1];
              final x2 = coordsList[2];
              final y2 = coordsList[3];
              final width = x2 - x;
              final height = y2 - y;

              clickableAreas.add(ClickableArea(
                x: x,
                y: y,
                width: width,
                height: height,
                targetPage: targetPage,
              ));

              print('[SpanishProvider] ✅ Added clickable area for page $targetPage at ($x,$y) size ${width}x$height');
            }
          }
        }
      }
    }

    print('[SpanishProvider] Total clickable areas extracted: ${clickableAreas.length}');
    return clickableAreas;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    print('[SpanishProvider] Regional pages not supported');
    throw UnimplementedError('Spanish Teletext does not support regional pages');
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
}

