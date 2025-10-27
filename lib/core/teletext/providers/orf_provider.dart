import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per i canali Teletext austriaci ORF
/// 
/// Supporta ORF1, ORF2, ORF III, ORF Sport+
/// URL base: https://teletext.orf.at/channel/{CHANNEL}/page/{PAGE}/{SUBPAGE}
class ORFProvider implements TeletextProvider {
  final Dio _dio;
  final String channelId;
  final String _channelCode;

  ORFProvider({
    Dio? dio,
    required this.channelId,
  }) : _dio = dio ?? Dio(),
       _channelCode = _getChannelCode(channelId);

  /// Determina il codice canale in base al channelId
  static String _getChannelCode(String channelId) {
    switch (channelId) {
      case 'orf1':
        return 'orf1';
      case 'orf2':
        return 'orf2';
      case 'orf3':
        return 'orfiii';
      case 'orf_sport_plus':
        return 'sportplus';
      default:
        return 'orf1';
    }
  }

  @override
  String get providerId => channelId;

  @override
  String get providerName {
    switch (channelId) {
      case 'orf1':
        return 'ORF1';
      case 'orf2':
        return 'ORF2';
      case 'orf3':
        return 'ORF III';
      case 'orf_sport_plus':
        return 'ORF Sport+';
      default:
        return 'ORF Teletext';
    }
  }

  @override
  String get countryCode => 'AT';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[ORFProvider] Fetching page $pageNumber subpage $subPage for $_channelCode');
    
    // ORF ha un'API JSON completa!
    // URL formato: https://afeeds.orf.at/teletext/api/v2/mobile/channels/orf1/pages/100
    final apiUrl = 'https://afeeds.orf.at/teletext/api/v2/mobile/channels/$_channelCode/pages/$pageNumber';
    
    print('[ORFProvider] API URL: $apiUrl');
    
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
      return _parseJsonPage(jsonData, pageNumber, subPage);
      
    } catch (e) {
      print('[ORFProvider] Error fetching page: $e');
      rethrow;
    }
  }
  
  /// Parse la risposta JSON dall'API ORF
  TelevideoPage _parseJsonPage(Map<String, dynamic> jsonData, int pageNumber, int requestedSubPage) {
    print('[ORFProvider] Parsing JSON response...');
    
    // Estrai metadata di navigazione
    final previousPage = jsonData['previousPage'] as int?;
    final nextPage = jsonData['nextPage'] as int?;
    
    final navigationLinks = <String, dynamic>{};
    if (previousPage != null && previousPage > 0) {
      navigationLinks['prev'] = previousPage;
      navigationLinks['previousPage'] = previousPage;
    }
    if (nextPage != null && nextPage > 0) {
      navigationLinks['next'] = nextPage;
      navigationLinks['nextPage'] = nextPage;
    }
    
    // Estrai le sottopagine
    final subpagesData = jsonData['subpages'] as List<dynamic>?;
    if (subpagesData == null || subpagesData.isEmpty) {
      throw Exception('No subpages found in API response');
    }
    
    final totalSubPages = subpagesData.length;
    print('[ORFProvider] Found $totalSubPages subpage(s)');
    
    // Trova la sottopagina richiesta (1-indexed)
    final subPageIndex = requestedSubPage - 1;
    if (subPageIndex < 0 || subPageIndex >= totalSubPages) {
      throw Exception('Subpage $requestedSubPage not found (only $totalSubPages available)');
    }
    
    final subpageData = subpagesData[subPageIndex] as Map<String, dynamic>;
    
    // Estrai l'URL dell'immagine
    final imageUrl = subpageData['imageUrl'] as String?;
    if (imageUrl == null) {
      throw Exception('No image URL found for subpage $requestedSubPage');
    }
    
    print('[ORFProvider] ✅ Image URL: $imageUrl');
    
    // Estrai le aree cliccabili
    final clickableAreas = _parseLinksFromJson(subpageData);
    
    print('[ORFProvider] SubPage info: $requestedSubPage/$totalSubPages');
    print('[ORFProvider] Navigation: prev=$previousPage, next=$nextPage');
    print('[ORFProvider] Clickable areas: ${clickableAreas.length}');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: requestedSubPage,
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
  
  /// Parse i link dall'API JSON di ORF
  List<ClickableArea> _parseLinksFromJson(Map<String, dynamic> subpageData) {
    final clickableAreas = <ClickableArea>[];
    
    final linksData = subpageData['links'] as List<dynamic>?;
    if (linksData == null || linksData.isEmpty) {
      print('[ORFProvider] No links found in subpage data');
      return clickableAreas;
    }
    
    print('[ORFProvider] Found ${linksData.length} links in API');
    
    // Le coordinate dell'API sono in una griglia di caratteri (row/col)
    // Dobbiamo convertirle in pixel per l'immagine 720x576
    // Grid teletext: 40 colonne x 24 righe
    const double imageWidth = 823.0;
    const double imageHeight = 494.0;
    const double gridCols = 40.0;
    const double gridRows = 24.0;
    
    final cellWidth = imageWidth / gridCols;  // 18 px
    final cellHeight = imageHeight / gridRows; // 24 px
    
    for (final linkData in linksData) {
      if (linkData is! Map<String, dynamic>) continue;
      
      final type = linkData['type'] as String?;
      if (type != 'internal') {
        // Skip external links
        continue;
      }
      
      final targetPage = linkData['page'] as int?;
      final coords = linkData['coords'] as Map<String, dynamic>?;
      
      if (targetPage == null || coords == null) continue;
      
      final row = (coords['row'] as int?) ?? 0;
      final col = (coords['col'] as int?) ?? 0;
      final width = (coords['width'] as int?) ?? 0;
      final height = (coords['height'] as int?) ?? 0;
      
      if (width == 0 || height == 0) continue;
      
      // Converti da griglia caratteri a pixel
      final x = (col * cellWidth).toInt();
      final y = ((row - 1) * cellHeight).toInt();
      final pixelWidth = (width * cellWidth).toInt();
      final pixelHeight = (height * cellHeight).toInt();
      
      clickableAreas.add(ClickableArea(
        x: x,
        y: y,
        width: pixelWidth,
        height: pixelHeight,
        targetPage: targetPage,
      ));
      
      print('[ORFProvider] ✅ Link to page $targetPage: grid($col,$row ${width}x$height) -> px($x,$y ${pixelWidth}x$pixelHeight)');
    }
    
    return clickableAreas;
  }
  
  /// Parse la pagina HTML ORF Teletext per estrarre l'URL dell'immagine (OLD - non più usato)
  TelevideoPage _parseHtmlPage(String htmlContent, int pageNumber, int subPage, String baseUrl) {
    print('[ORFProvider] Parsing HTML...');
    print('[ORFProvider] HTML length: ${htmlContent.length} bytes');
    
    // Log dell'HTML per debug (primi 1500 caratteri per vedere più info)
    final htmlPreview = htmlContent.length > 1500 ? htmlContent.substring(0, 1500) : htmlContent;
    print('[ORFProvider] HTML preview:\n$htmlPreview\n...');
    
    final document = html_parser.parse(htmlContent);
    
    // ORF usa il meta tag og:image per l'immagine teletext
    // Esempio: <meta property="og:image" content="https://appmeta.orf.at/teletext/orf1/100_0001.png" />
    String? imageUrl;
    
    // Strategia 1: Cerca nel meta tag og:image
    final ogImageMeta = document.querySelector('meta[property="og:image"]');
    if (ogImageMeta != null) {
      imageUrl = ogImageMeta.attributes['content'];
      print('[ORFProvider] ✅ Found image in og:image meta tag: $imageUrl');
    }
    
    // Strategia 2: Se non trovato, cerca nel tag <teletext-page> (potrebbe essere caricato dinamicamente)
    if (imageUrl == null) {
      final teletextPage = document.querySelector('teletext-page');
      
      if (teletextPage != null) {
        print('[ORFProvider] Found teletext-page element');
        
        // Cerca il tag <image> SVG dentro teletext-page
        final svgImage = teletextPage.querySelector('image');
        
        if (svgImage != null) {
          // Prova prima con 'href', poi con 'xlink:href'
          imageUrl = svgImage.attributes['href'] ?? svgImage.attributes['xlink:href'];
          print('[ORFProvider] Found SVG <image>: href=$imageUrl');
          
          if (imageUrl != null && !imageUrl!.startsWith('http')) {
            if (imageUrl!.startsWith('/')) {
              imageUrl = 'https://teletext.orf.at$imageUrl';
            } else {
              imageUrl = 'https://teletext.orf.at/$imageUrl';
            }
          }
          print('[ORFProvider] ✅ Found teletext image in SVG: $imageUrl');
        } else {
          print('[ORFProvider] No SVG <image> found inside teletext-page');
        }
      } else {
        print('[ORFProvider] No <teletext-page> element found (might be loaded via JS)');
      }
    }
    
    if (imageUrl == null) {
      print('[ORFProvider] ⚠️ No teletext image found in HTML');
      throw Exception('No teletext image found in HTML. ORF might be blocking access.');
    }
    
    // Estrai il numero di sottopagine dall'URL dell'immagine
    // Formato: https://appmeta.orf.at/teletext/orf1/100_0001.png
    // Il numero dopo underscore indica la sottopagina
    int totalSubPages = 1;
    
    // Strategia 1: Cerca negli attributi HTML
    final subpageElements = document.querySelectorAll('[data-subpage-count], [data-subpages]');
    for (final element in subpageElements) {
      final count = element.attributes['data-subpage-count'] ?? element.attributes['data-subpages'];
      if (count != null) {
        totalSubPages = int.tryParse(count) ?? 1;
        print('[ORFProvider] Found subpages from HTML attribute: $totalSubPages');
        break;
      }
    }
    
    // Strategia 2: Cerca nei meta tag o script
    if (totalSubPages == 1) {
      // Cerca pattern come "subpages":2 o simili nell'HTML
      final subpageMatch = RegExp(r'"subpages?":\s*(\d+)', caseSensitive: false).firstMatch(htmlContent);
      if (subpageMatch != null) {
        totalSubPages = int.tryParse(subpageMatch.group(1) ?? '1') ?? 1;
        print('[ORFProvider] Found subpages from JSON pattern: $totalSubPages');
      }
    }
    
    // Estrai link di navigazione
    final navigationLinks = _extractNavigationLinks(document);
    
    print('[ORFProvider] SubPage info: $subPage/$totalSubPages');
    print('[ORFProvider] Navigation: prev=${navigationLinks['prev']}, next=${navigationLinks['next']}');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: imageUrl,
      clickableAreas: [], // Le aree cliccabili saranno caricate separatamente se disponibili
      timestamp: DateTime.now(),
      isHtmlContent: false, // ✅ Usa immagine!
      providerId: providerId,
      metadata: navigationLinks,
    );
  }
  
  /// Estrae i link di navigazione dalla pagina
  Map<String, dynamic> _extractNavigationLinks(dom.Document document) {
    final result = <String, dynamic>{};
    
    // Cerca link di navigazione
    final navLinks = document.querySelectorAll('a[href*="/page/"]');
    
    for (final link in navLinks) {
      final href = link.attributes['href'];
      if (href != null) {
        final pageMatch = RegExp(r'/page/(\d+)').firstMatch(href);
        if (pageMatch != null) {
          final targetPage = int.tryParse(pageMatch.group(1)!);
          
          // Identifica se è prev o next basandosi sulla classe o testo
          final classes = link.classes.join(' ');
          final text = link.text.trim().toLowerCase();
          
          if (classes.contains('prev') || text.contains('zurück') || text.contains('<')) {
            result['prev'] = targetPage;
          } else if (classes.contains('next') || text.contains('weiter') || text.contains('>')) {
            result['next'] = targetPage;
          }
        }
      }
    }
    
    return result;
  }
  
  /// Estrae le aree cliccabili dalla pagina HTML o tramite API
  Future<List<ClickableArea>> _extractClickableAreas(String channelCode, int pageNumber, int subPage) async {
    final clickableAreas = <ClickableArea>[];
    
    print('[ORFProvider] Attempting to fetch clickable areas via API...');
    
    // ORF carica i link dinamicamente via JavaScript, quindi non sono nell'HTML statico
    // Proviamo a chiamare un'API JSON simile a quella di Swiss Teletext
    // Formato possibile: https://teletext.orf.at/api/channel/{channel}/page/{page}/{subpage}
    
    try {
      final apiUrl = 'https://teletext.orf.at/api/channel/$channelCode/page/$pageNumber/$subPage';
      print('[ORFProvider] Trying API URL: $apiUrl');
      
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        print('[ORFProvider] ✅ API response received');
        
        // Prova a parsare la risposta JSON
        final data = response.data as Map<String, dynamic>?;
        
        if (data != null) {
          // Cerca link o areas nella risposta
          final links = data['links'] as List<dynamic>?;
          
          if (links != null) {
            print('[ORFProvider] Found ${links.length} links in API response');
            
            // Dimensioni del viewBox SVG (720x432) e dell'immagine reale (720x576)
            const double svgWidth = 720.0;
            const double svgHeight = 432.0;
            const double imageWidth = 720.0;
            const double imageHeight = 576.0;
            
            final scaleX = imageWidth / svgWidth;
            final scaleY = imageHeight / svgHeight;
            
            for (final link in links) {
              if (link is Map<String, dynamic>) {
                final targetPage = link['page'] as int?;
                final x = link['x'] as num?;
                final y = link['y'] as num?;
                final width = link['width'] as num?;
                final height = link['height'] as num?;
                
                if (targetPage != null && x != null && y != null && width != null && height != null) {
                  clickableAreas.add(ClickableArea(
                    x: (x.toDouble() * scaleX).toInt(),
                    y: (y.toDouble() * scaleY).toInt(),
                    width: (width.toDouble() * scaleX).toInt(),
                    height: (height.toDouble() * scaleY).toInt(),
                    targetPage: targetPage,
                  ));
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('[ORFProvider] ⚠️ API call failed: $e');
      print('[ORFProvider] Links will not be available (this is normal for ORF)');
    }
    
    print('[ORFProvider] Total clickable areas extracted: ${clickableAreas.length}');
    return clickableAreas;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // ORF non ha pagine regionali separate in questa implementazione
    print('[ORFProvider] Regional pages not supported, fetching national page');
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
}

