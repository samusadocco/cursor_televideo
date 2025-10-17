import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per ZDF Teletext (Germania)
/// 
/// Supporta ZDF, ZDFinfo, ZDFneo e 3sat
/// URL base: https://teletext.zdf.de/teletext/{channel}/
class ZDFProvider implements TeletextProvider {
  final Dio _dio;
  final String channelId;
  final String _baseUrl;

  ZDFProvider({
    Dio? dio,
    required this.channelId,
  }) : _dio = dio ?? Dio(),
       _baseUrl = _getBaseUrl(channelId);

  /// Determina l'URL base in base al channelId
  static String _getBaseUrl(String channelId) {
    switch (channelId) {
      case 'zdf_text':
        return 'https://teletext.zdf.de/teletext/zdf';
      case 'zdfinfo_text':
        return 'https://teletext.zdf.de/teletext/zdfinfo';
      case 'zdfneo_text':
        return 'https://teletext.zdf.de/teletext/zdfneo';
      case '3sat_text':
        return 'https://teletext.zdf.de/teletext/3sat';
      default:
        return 'https://teletext.zdf.de/teletext/zdf';
    }
  }

  @override
  String get providerId => channelId;

  @override
  String get providerName {
    switch (channelId) {
      case 'zdfinfo_text':
        return 'ZDFinfo Text';
      case 'zdfneo_text':
        return 'ZDFneo Text';
      case '3sat_text':
        return '3sat Text';
      default:
        return 'ZDF Text';
    }
  }

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[ZDFProvider] Fetching page $pageNumber subpage $subPage');
      
      // ZDF usa il formato: https://teletext.zdf.de/teletext/zdf/seiten/klassisch/XXX.html
      // Sottopagina 1: XXX.html
      // Sottopagina 2: XXX_1.html
      // Sottopagina 3: XXX_2.html
      // Sottopagina N: XXX_{N-1}.html
      String url;
      if (subPage > 1) {
        final subPageIndex = subPage - 1;
        url = '$_baseUrl/seiten/klassisch/${pageNumber}_$subPageIndex.html';
      } else {
        // Prima sottopagina
        url = '$_baseUrl/seiten/klassisch/$pageNumber.html';
      }
      
      print('[ZDFProvider] URL: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final html = response.data as String;
      return _parseHtmlPage(html, pageNumber, subPage, url);
    } catch (e) {
      print('[ZDFProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // ZDF non ha pagine regionali separate
    print('[ZDFProvider] Regional pages not supported, fetching national page');
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

  /// Parse l'HTML della pagina ZDF e crea un TelevideoPage
  TelevideoPage _parseHtmlPage(String html, int pageNumber, int subPage, String pageUrl) {
    print('[ZDFProvider] Parsing HTML...');
    print('[ZDFProvider] HTML length: ${html.length} bytes');
    
    final document = parse(html);
    
    // ZDF restituisce l'HTML completo già pronto per essere visualizzato
    // Estraiamo solo le informazioni necessarie (sottopagine, link) ma passiamo tutto l'HTML
    
    // Estrai i link cliccabili dall'intero documento
    final clickableAreas = _extractClickableAreas(document.body ?? document.documentElement!);
    
    // Estrai informazioni sulle sottopagine
    final subPageInfo = _extractSubPageInfo(document);
    
    // Estrai i link di navigazione prev/next
    final navigationLinks = _extractNavigationLinks(document);
    
    print('[ZDFProvider] Found ${clickableAreas.length} clickable areas');
    print('[ZDFProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');
    print('[ZDFProvider] Navigation: prev=${navigationLinks['prev']}, next=${navigationLinks['next']}');

    final totalSubPages = subPageInfo['total'] ?? 1;
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: pageUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: true, // Flag per indicare che è HTML, non immagine
      htmlContent: html, // Passa l'HTML completo così com'è
      providerId: providerId,
      metadata: navigationLinks, // Salva i link di navigazione nei metadata
    );
  }
  
  /// Estrae i link di navigazione (pagina precedente/successiva)
  /// ZDF fornisce gli attributi prevpg e nextpg nel tag <body>
  Map<String, dynamic> _extractNavigationLinks(dom.Document document) {
    final result = <String, dynamic>{};
    
    // ZDF indica la pagina precedente e successiva negli attributi del body
    // Esempio: <body subpages="2" test="test" prevpg="777" nextpg="783">
    final body = document.body;
    if (body != null) {
      final prevPg = body.attributes['prevpg'];
      final nextPg = body.attributes['nextpg'];
      
      if (prevPg != null) {
        final prevPage = int.tryParse(prevPg);
        if (prevPage != null) {
          result['prev'] = prevPage;
        }
      }
      
      if (nextPg != null) {
        final nextPage = int.tryParse(nextPg);
        if (nextPage != null) {
          result['next'] = nextPage;
        }
      }
    }
    
    return result;
  }

  /// Estrae le aree cliccabili (link a altre pagine)
  List<ClickableArea> _extractClickableAreas(dom.Element contentDiv) {
    final areas = <ClickableArea>[];
    
    // Trova tutti i link nel documento
    // ZDF usa formati come: klassisch/128.html o 128_0.html
    final links = contentDiv.querySelectorAll('a[href]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dall'href
      // Formato: klassisch/XXX.html o klassisch/XXX_Y.html o semplicemente XXX.html
      final pageMatch = RegExp(r'(?:klassisch/)?(\d+)(?:_\d+)?\.html').firstMatch(href);
      if (pageMatch == null) continue;
      
      final targetPage = int.tryParse(pageMatch.group(1)!);
      if (targetPage == null) continue;
      
      // Ottieni il testo del link
      final text = link.text.trim();
      
      areas.add(ClickableArea(
        x: 0,
        y: 0,
        width: 100,
        height: 30,
        targetPage: targetPage,
        description: text.isNotEmpty ? text : 'Seite $targetPage',
      ));
    }
    
    return areas;
  }

  /// Estrae informazioni sulle sottopagine
  Map<String, int?> _extractSubPageInfo(dom.Document document) {
    // ZDF indica il numero di sottopagine nell'attributo "subpages" del body
    // Esempio: <body subpages="3">
    final body = document.body;
    if (body != null) {
      final subpagesAttr = body.attributes['subpages'];
      if (subpagesAttr != null) {
        final totalSubPages = int.tryParse(subpagesAttr);
        if (totalSubPages != null && totalSubPages > 0) {
          print('[ZDFProvider] Found subpages attribute: $totalSubPages');
          return {
            'current': 1,
            'total': totalSubPages,
          };
        }
      }
    }
    
    print('[ZDFProvider] No subpages attribute found, defaulting to 1');
    return {
      'current': 1,
      'total': 1,
    };
  }
}

