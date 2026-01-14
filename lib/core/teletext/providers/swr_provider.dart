import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/debug/debug_logger.dart';
import 'teletext_provider.dart';

/// Provider per SWR Text (Baden-Württemberg e Rheinland-Pfalz)
/// 
/// SWR Text è disponibile in due versioni regionali:
/// - SWR BW (Baden-Württemberg): stream=bw
/// - SWR RP (Rheinland-Pfalz): stream=rp
/// 
/// URL format: https://wraps.swr.de/videotext/?page=XXX&stream=YYY&sub=Z
class SWRProvider implements TeletextProvider {
  final Dio _dio;
  final String _baseUrl = 'https://wraps.swr.de/videotext/';
  final String _stream; // 'bw' o 'rp'
  
  SWRProvider(this._stream, {Dio? dio}) : _dio = dio ?? Dio();
  
  @override
  String get providerId => _stream == 'bw' ? 'swr_bw' : 'swr_rp';
  
  @override
  String get providerName => _stream == 'bw' ? 'SWR BW Text' : 'SWR RP Text';
  
  @override
  String get countryCode => 'DE';
  
  @override
  bool get supportsRegions => false;
  
  @override
  List<String> get supportedRegions => [];
  
  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // SWR non supporta regioni, usa fetchNationalPage
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

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    final logger = DebugLogger();
    logger.log('SWR', 'Fetching page $pageNumber, subpage $subPage (stream: $_stream)');

    // Costruisci URL con parametri query
    final targetUrl = '$_baseUrl?page=$pageNumber&stream=$_stream&sub=$subPage';
    logger.log('SWR', 'Target URL: $targetUrl');

    try {
      final response = await _dio.get(targetUrl);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      // Parse HTML
      final html = response.data as String;
      final document = parser.parse(html);
      
      // Estrai informazioni dalla pagina
      final pageDiv = _extractPageContent(document);
      final navInfo = _extractNavigationInfo(document);
      final subPageInfo = _extractSubPageInfo(document);
      final clickableAreas = _extractClickableAreas(document);

      print('[SWRProvider] Found ${clickableAreas.length} clickable areas');
      print('[SWRProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');

      final totalSubPages = subPageInfo['total'] ?? 1;
      
      // Prepara metadata con informazioni di navigazione
      final metadata = <String, dynamic>{};
      if (navInfo['prev'] != null) {
        metadata['prev'] = navInfo['prev'];
        print('[SWRProvider] Setting prev page in metadata: ${navInfo['prev']}');
      }
      if (navInfo['next'] != null) {
        metadata['next'] = navInfo['next'];
        print('[SWRProvider] Setting next page in metadata: ${navInfo['next']}');
      }

      // Costruisci HTML completo con template + contenuto
      final completeHtml = _buildCompleteHtml(document, pageDiv);
      
      return TelevideoPage(
        pageNumber: pageNumber,
        subPage: subPage,
        maxSubPages: totalSubPages,
        totalSubPages: totalSubPages,
        imageUrl: targetUrl,
        clickableAreas: clickableAreas,
        metadata: metadata,
        htmlContent: completeHtml,
        isHtmlContent: true,
        providerId: providerId,
      );
    } catch (e) {
      print('[SWRProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae il contenuto della pagina dal div ttxPage
  dom.Element? _extractPageContent(dom.Document document) {
    return document.getElementById('ttxPage');
  }

  /// Estrae informazioni di navigazione (pagina precedente/successiva)
  Map<String, int?> _extractNavigationInfo(dom.Document document) {
    int? prevPage;
    int? nextPage;
    
    // SWR usa elementi <pre> con id specifici per le info di navigazione
    final prevPageElement = document.getElementById('ttxPrevPageNum');
    final nextPageElement = document.getElementById('ttxNextPageNum');
    
    if (prevPageElement != null) {
      prevPage = int.tryParse(prevPageElement.text.trim());
    }
    
    if (nextPageElement != null) {
      nextPage = int.tryParse(nextPageElement.text.trim());
    }
    
    return {
      'prev': prevPage,
      'next': nextPage,
    };
  }

  /// Estrae le aree cliccabili (link) dalla pagina
  List<ClickableArea> _extractClickableAreas(dom.Document document) {
    final areas = <ClickableArea>[];
    final pageDiv = document.getElementById('ttxPage');
    
    if (pageDiv == null) return areas;
    
    // Cerca tutti i link nella pagina
    final links = pageDiv.querySelectorAll('a[href]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dal formato ?page=XXX&stream=YYY
      final pageMatch = RegExp(r'[?&]page=(\d+)').firstMatch(href);
      if (pageMatch == null) continue;
      
      final pageNum = int.tryParse(pageMatch.group(1)!);
      if (pageNum == null) continue;
      
      areas.add(ClickableArea(
        x: 0,
        y: 0,
        width: 100,
        height: 30,
        targetPage: pageNum,
        description: link.text.trim(),
      ));
    }
    
    return areas;
  }

  /// Estrae informazioni sulle sottopagine
  Map<String, int?> _extractSubPageInfo(dom.Document document) {
    // SWR usa elementi <pre> con id specifici
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
    
    print('[SWRProvider] Found subpage info: $current/$total');
    
    return {
      'current': current,
      'total': total,
    };
  }

  /// Costruisce l'HTML completo con template + contenuto dinamico
  String _buildCompleteHtml(dom.Document document, dom.Element? pageDiv) {
    // Estrai il contenuto del div ttxPage
    final pageContent = pageDiv?.outerHtml ?? '<div id="ttxPage"></div>';
    
    // Template HTML base con link CSS esterni (come WDR)
    return '''<!DOCTYPE html>
<html>
<head>
  <base href="https://wraps.swr.de/videotext/" target="_blank" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta http-equiv="Content-Security-Policy" content="img-src * data: blob: android-webview-video-poster:;">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="mobile-web-app-capable" content="yes">
  
  <title>SWR-Text | SWR.de</title>
  
  <link rel="stylesheet" href="css/ttxweb_ttx.css">
  <link rel="stylesheet" href="css/ttxweb_g1.css">
  <link rel="stylesheet" href="templates/swr/css/template_style.css">
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
