import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per HR Text (Hessischer Rundfunk - Germania/Hessen)
/// 
/// HR Text usa un formato HTML simile a SWR.
/// URL base: https://www.hr-text.hr-fernsehen.de/ttxweb/?page=100
/// Il parametro sub indica la sottopagina
class HRProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.hr-text.hr-fernsehen.de/ttxweb/';

  HRProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'hr_text';

  @override
  String get providerName => 'HR Text';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[HRProvider] Fetching page $pageNumber subpage $subPage');
      
      // Formato HR: ?page=100&sub=1
      final url = '$_baseUrl?page=$pageNumber&sub=$subPage';
      print('[HRProvider] URL: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final html = response.data as String;
      return _parseHtmlPage(html, pageNumber, subPage, url);
    } catch (e) {
      print('[HRProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // HR è già regionale (Hessen), usa lo stesso endpoint
    print('[HRProvider] Fetching regional page for $regionCode: $pageNumber');
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

  /// Parse l'HTML della pagina HR e crea un TelevideoPage
  TelevideoPage _parseHtmlPage(String html, int pageNumber, int subPage, String url) {
    print('[HRProvider] Parsing HTML for page $pageNumber, subpage $subPage...');
    
    final document = parse(html);
    
    // Cerca il container HR: ttxPage
    var pageDiv = document.getElementById('ttxPage');
    
    if (pageDiv == null) {
      print('[HRProvider] ERROR: ttxPage not found in HTML');
      throw Exception('Page content div not found (tried ttxPage)');
    }
    
    print('[HRProvider] Using div: ${pageDiv.id}');

    // Estrai i link cliccabili
    final clickableAreas = _extractClickableAreas(pageDiv);
    
    // Estrai informazioni di navigazione (prev/next page)
    final navInfo = _extractNavigationInfo(document);
    print('[HRProvider] Navigation - Prev: ${navInfo['prev']}, Next: ${navInfo['next']}');
    
    // Estrai informazioni sulle sottopagine
    final subPageInfo = _extractSubPageInfo(document);
    
    print('[HRProvider] Found ${clickableAreas.length} clickable areas');
    print('[HRProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');

    final totalSubPages = subPageInfo['total'] ?? 1;

    // Costruisci l'HTML completo con il template HR
    final completeHtml = _buildCompleteHtml(document, pageDiv);

    // Metadata
    final metadata = <String, dynamic>{
      'provider': providerId,
      'pageNumber': pageNumber,
      'subPage': subPage,
      'totalSubPages': totalSubPages,
    };

    if (navInfo['prev'] != null) {
      metadata['prevPage'] = navInfo['prev'];
      print('[HRProvider] Setting prev page in metadata: ${navInfo['prev']}');
    }
    if (navInfo['next'] != null) {
      metadata['nextPage'] = navInfo['next'];
      print('[HRProvider] Setting next page in metadata: ${navInfo['next']}');
    }

    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: url,
      clickableAreas: clickableAreas,
      metadata: metadata,
      htmlContent: completeHtml,
      isHtmlContent: true,
      providerId: providerId,
    );
  }

  /// Estrae informazioni di navigazione (pagina precedente/successiva)
  Map<String, int?> _extractNavigationInfo(dom.Document document) {
    int? prevPage;
    int? nextPage;

    // Cerca nei tag <pre> dentro ttxEnv
    final ttxPrevPageNum = document.getElementById('ttxPrevPageNum');
    final ttxNextPageNum = document.getElementById('ttxNextPageNum');

    if (ttxPrevPageNum != null) {
      prevPage = int.tryParse(ttxPrevPageNum.text.trim());
    }

    if (ttxNextPageNum != null) {
      nextPage = int.tryParse(ttxNextPageNum.text.trim());
    }

    return {
      'prev': prevPage,
      'next': nextPage,
    };
  }

  /// Estrae i link cliccabili dalla pagina
  List<ClickableArea> _extractClickableAreas(dom.Element pageDiv) {
    final areas = <ClickableArea>[];
    final links = pageDiv.querySelectorAll('a[href]');
    
    int index = 0;
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dal formato ?page=XXX
      final pageMatch = RegExp(r'[?&]page=(\d+)').firstMatch(href);
      if (pageMatch != null) {
        final targetPage = int.tryParse(pageMatch.group(1)!);
        if (targetPage != null) {
          // Usa valori placeholder per le coordinate (non disponibili nell'HTML)
          areas.add(ClickableArea(
            targetPage: targetPage,
            x: 0,
            y: index * 20,
            width: 100,
            height: 20,
            description: link.text.trim(),
          ));
          index++;
        }
      }
    }
    
    return areas;
  }

  /// Estrae informazioni sulle sottopagine
  Map<String, int?> _extractSubPageInfo(dom.Document document) {
    // HR usa <pre> tags con id specifici
    final subpageNumElement = document.getElementById('ttxSubpageNum');
    final numSubpagesElement = document.getElementById('ttxNumSubpages');
    
    int? current = 1;
    int? total = 1;
    
    if (subpageNumElement != null) {
      current = int.tryParse(subpageNumElement.text.trim());
    }
    
    if (numSubpagesElement != null) {
      total = int.tryParse(numSubpagesElement.text.trim());
    }
    
    print('[HRProvider] Found subpage info: $current/$total');
    
    return {
      'current': current,
      'total': total,
    };
  }

  /// Costruisce l'HTML completo con template + contenuto dinamico
  String _buildCompleteHtml(dom.Document document, dom.Element? pageDiv) {
    // Estrai il contenuto del div ttxPage
    final pageContent = pageDiv?.outerHtml ?? '<div id="ttxPage"></div>';
    
    // Template HTML base HR (semplificato per WebView)
    return '''<!DOCTYPE html>
<html lang="de">
<head>
  <base href="https://www.hr-text.hr-fernsehen.de/ttxweb/" target="_blank" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta http-equiv="Content-Security-Policy" content="img-src * data: blob: android-webview-video-poster:;">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="mobile-web-app-capable" content="yes">
  
  <title>HR Text</title>
  
  <link rel="stylesheet" href="css/ttxweb_ttx.css">
  <link rel="stylesheet" href="css/ttxweb_g1.css">
  <link rel="stylesheet" href="templates/hr/css/template_style.css">
</head>

<body>
  <div id="ttxContainer">
    $pageContent
  </div>
</body>
</html>''';
  }

  Future<List<int>> getAvailableSubPages(int pageNumber) async {
    final page = await fetchNationalPage(pageNumber);
    return List.generate(page.maxSubPages, (index) => index + 1);
  }
}
