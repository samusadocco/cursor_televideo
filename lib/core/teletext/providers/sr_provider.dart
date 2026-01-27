import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per SR - Saarländischer Rundfunk Teletext (Saar Text)
class SRProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.saartext.de/';

  SRProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'sr_text';

  @override
  String get providerName => 'Saar Text';

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
    print('[SR] Fetching page $pageNumber, subpage $subPage');

    // Costruisci URL: /100 oppure /100/02 (subpage con padding a 2 cifre)
    final targetUrl = subPage == 1 
        ? '$_baseUrl$pageNumber'
        : '$_baseUrl$pageNumber/${subPage.toString().padLeft(2, '0')}';
    
    print('[SR] Target URL: $targetUrl');

    try {
      final response = await _dio.get(
        targetUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        print('[SR] Page not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[SR] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      final document = html_parser.parse(htmlContent);

      // Estrai il contenuto da <pre class="saartext_page">
      final preElement = document.querySelector('pre.saartext_page');
      
      if (preElement == null) {
        print('[SR] Error: <pre class="saartext_page"> not found');
        throw Exception('Contenuto Teletext non trovato');
      }

      final pageContent = preElement.innerHtml;
      print('[SR] Page content extracted: ${pageContent.length} chars');

      // Estrai info sottopagine da <span class="saartext_pagenumber_unterseite">Unterseite 2/4</span>
      int maxSubPages = 1;
      final subpageSpan = document.querySelector('span.saartext_pagenumber_unterseite');
      if (subpageSpan != null) {
        final subpageText = subpageSpan.text; // Es: "Unterseite 2/4"
        final match = RegExp(r'(\d+)/(\d+)').firstMatch(subpageText);
        if (match != null) {
          maxSubPages = int.tryParse(match.group(2)!) ?? 1;
          print('[SR] Subpage info: ${match.group(1)}/$maxSubPages');
        }
      }

      // Estrai link cliccabili e navigazione
      final navigationInfo = _extractNavigationInfo(document);

      // Crea HTML con template
      final htmlOutput = _createHtmlTemplate(
        pageContent: pageContent,
        pageNumber: pageNumber,
        subPage: subPage,
        maxSubPages: maxSubPages,
      );

      return TelevideoPage(
        pageNumber: pageNumber,
        htmlContent: htmlOutput,
        imageUrl: '', // Non usato per contenuto HTML
        subPage: subPage,
        maxSubPages: maxSubPages,
        isHtmlContent: true,
        providerId: providerId,
        clickableAreas: navigationInfo['clickableAreas'] as List<ClickableArea>,
        metadata: {
          'source': 'sr',
          'format': 'html',
          'originalUrl': targetUrl,
          'linksCount': navigationInfo['linksCount'],
        },
      );
    } catch (e) {
      print('[SR] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae informazioni di navigazione e link cliccabili
  Map<String, dynamic> _extractNavigationInfo(dynamic document) {
    final clickableAreas = <ClickableArea>[];
    int linksCount = 0;

    // Estrai tutti i link <a href="/110">110</a> dal contenuto
    final links = document.querySelectorAll('pre.saartext_page a[href]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null && href.startsWith('/')) {
        // Link tipo "/110" o "/100/02"
        final parts = href.substring(1).split('/');
        final targetPage = int.tryParse(parts[0]);
        
        if (targetPage != null && targetPage >= 100 && targetPage <= 999) {
          linksCount++;
          // Le coordinate verranno calcolate dinamicamente nel viewer
          // Per ora aggiungiamo info di base
          clickableAreas.add(ClickableArea(
            targetPage: targetPage,
            x: 0,
            y: 0,
            width: 0,
            height: 0,
            description: 'Pagina $targetPage',
          ));
        }
      }
    }

    print('[SR] Found $linksCount clickable links');

    return {
      'clickableAreas': clickableAreas,
      'linksCount': linksCount,
    };
  }

  /// Crea template HTML per la visualizzazione
  String _createHtmlTemplate({
    required String pageContent,
    required int pageNumber,
    required int subPage,
    required int maxSubPages,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    html, body {
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: #000;
    }
    
    body {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    #ttxStage {
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    
    #ttxContainer {
      position: relative;
      transform-origin: top left;
      background: #000;
      display: inline-block;
    }
    
    pre.saartext_page {
      font-family: 'Courier New', Courier, monospace;
      font-size: 14px;
      line-height: 1.2;
      color: #fff;
      background: #000;
      white-space: pre;
      margin: 0;
      padding: 10px;
    }
    
    pre.saartext_page a {
      color: #00ffff;
      text-decoration: underline;
      cursor: pointer;
    }
    
    pre.saartext_page a:hover {
      color: #ffff00;
      background: #006;
    }
  </style>
</head>
<body>
  <div id="ttxStage">
    <div id="ttxContainer">
      <pre class="saartext_page">$pageContent</pre>
    </div>
  </div>
  
  <script>
    // Converti link relativi in assoluti per Flutter WebView
    document.addEventListener('DOMContentLoaded', function() {
      const links = document.querySelectorAll('a[href^="/"]');
      links.forEach(link => {
        const href = link.getAttribute('href');
        if (href) {
          link.setAttribute('href', 'https://www.saartext.de' + href);
        }
      });
    });
    
    // Scaling dinamico (come SWR - misura contenuto reale)
    function applySRScale() {
      const container = document.getElementById('ttxContainer');
      const pre = document.querySelector('pre.saartext_page');
      
      if (!container || !pre) return;
      
      // Misura dimensioni reali del contenuto
      const contentW = pre.scrollWidth || pre.clientWidth;
      const contentH = pre.scrollHeight || pre.clientHeight;
      
      if (!contentW || !contentH) return;
      
      // Dimensioni viewport
      const vw = window.innerWidth;
      const vh = window.innerHeight;
      
      // Calcola scale X e Y
      const scaleX = vw / contentW;
      const scaleY = vh / contentH;
      
      // Aspect ratio e limiti Y
      const ar = vw / vh;
      const maxYRatio = ar > 0.9 ? 1.15 : (ar > 0.7 ? 1.35 : 1.6);
      const finalScaleY = Math.min(scaleY, scaleX * maxYRatio);
      
      // Applica transform
      container.style.width = contentW + 'px';
      container.style.height = contentH + 'px';
      container.style.transformOrigin = 'top left';
      container.style.transform = 'scale(' + scaleX + ',' + finalScaleY + ')';
      
      console.log('[SR Scale] Content: ' + contentW + 'x' + contentH + ', Viewport: ' + vw + 'x' + vh + ', Scale: ' + scaleX + ',' + finalScaleY);
    }
    
    // Applica scaling su load e resize
    window.addEventListener('load', function() {
      applySRScale();
      setTimeout(applySRScale, 50);
      setTimeout(applySRScale, 200);
    });
    window.addEventListener('resize', applySRScale);
  </script>
</body>
</html>
''';
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // SR non ha pagine regionali, usa sempre nazionale
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  void dispose() {
    _dio.close();
  }
}
