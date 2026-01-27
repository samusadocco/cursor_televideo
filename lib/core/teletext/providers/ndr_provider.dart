import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per NDR - Norddeutscher Rundfunk Teletext
class NDRProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.ndr.de/public/teletext/';

  NDRProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'ndr_text';

  @override
  String get providerName => 'NDR Text';

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
    print('[NDR] Fetching page $pageNumber, subpage $subPage');

    // Costruisci URL: 100_01.htm (subpage con padding a 2 cifre)
    final subPageStr = subPage.toString().padLeft(2, '0');
    final targetUrl = '$_baseUrl${pageNumber}_$subPageStr.htm';
    
    print('[NDR] Target URL: $targetUrl');

    try {
      final response = await _dio.get(
        targetUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        print('[NDR] Page not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[NDR] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      final document = html_parser.parse(htmlContent);

      // Estrai il contenuto da <pre class="txt">
      final txtElement = document.querySelector('pre.txt');
      
      if (txtElement == null) {
        print('[NDR] Error: <pre class="txt"> not found');
        throw Exception('Contenuto Teletext non trovato');
      }

      final pageContent = txtElement.innerHtml;
      print('[NDR] Page content extracted: ${pageContent.length} chars');
      
      if (pageContent.trim().isEmpty) {
        print('[NDR] Warning: Page content is empty!');
        throw Exception('Contenuto pagina vuoto');
      }

      // Estrai info sottopagine da <pre class="hdr">
      // Esempio: <pre class="hdr"> <a id="kbd_left" href="193_01.htm">←</a><span id="pg">194</span><a id="kbd_right" href="195_01.htm">→</a>  1/7<a id="kbd_plus" href="194_02.htm">+</a>   NDR Text  <span id="date"></span></pre>
      int maxSubPages = 1;
      final hdrElement = document.querySelector('pre.hdr');
      if (hdrElement != null) {
        final hdrText = hdrElement.text; // Es: "←194→  1/7+   NDR Text  "
        print('[NDR] Header text: "$hdrText"');
        
        // Regex più flessibile per catturare formato n/m anche senza spazi prima
        final match = RegExp(r'(\d+)/(\d+)').firstMatch(hdrText);
        if (match != null) {
          final current = int.tryParse(match.group(1)!) ?? 1;
          maxSubPages = int.tryParse(match.group(2)!) ?? 1;
          print('[NDR] Subpage info from header: $current/$maxSubPages');
        } else {
          print('[NDR] Warning: Could not parse subpage info from header');
        }
      } else {
        print('[NDR] Warning: <pre class="hdr"> not found in HTML');
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
          'source': 'ndr',
          'format': 'html',
          'originalUrl': targetUrl,
          'linksCount': navigationInfo['linksCount'],
        },
      );
    } catch (e) {
      print('[NDR] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae informazioni di navigazione e link cliccabili
  Map<String, dynamic> _extractNavigationInfo(dynamic document) {
    final clickableAreas = <ClickableArea>[];
    int linksCount = 0;

    // Estrai tutti i link <a href="193_01.htm">193</a> dal contenuto
    final links = document.querySelectorAll('pre.txt a[href]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null && href.contains('_')) {
        // Link tipo "193_01.htm"
        final parts = href.replaceAll('.htm', '').split('_');
        final targetPage = int.tryParse(parts[0]);
        
        if (targetPage != null && targetPage >= 100 && targetPage <= 999) {
          linksCount++;
          // Le coordinate verranno calcolate dinamicamente nel viewer
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

    print('[NDR] Found $linksCount clickable links');

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
    
    #ndrStage {
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    
    #ndrContainer {
      position: relative;
      transform-origin: top left;
      background: #000;
      display: inline-block;
    }
    
    pre.txt {
      font-family: 'Courier New', Courier, monospace;
      font-size: 14px;
      line-height: 1.2;
      color: #fff;
      background: #000;
      white-space: pre;
      margin: 0;
      padding: 10px;
    }
    
    pre.txt a {
      color: #00ffff;
      text-decoration: underline;
      cursor: pointer;
    }
    
    pre.txt a:hover {
      color: #ffff00;
      background: #006;
    }
    
    /* Colori Teletext NDR */
    .f0 { color: #000; }
    .f1 { color: #f00; }
    .f2 { color: #0f0; }
    .f3 { color: #ff0; }
    .f4 { color: #00f; }
    .f5 { color: #f0f; }
    .f6 { color: #0ff; }
    .f7 { color: #fff; }
    
    .b0 { background: #000; }
    .b1 { background: #f00; }
    .b2 { background: #0f0; }
    .b3 { background: #ff0; }
    .b4 { background: #00f; }
    .b5 { background: #f0f; }
    .b6 { background: #0ff; }
    .b7 { background: #fff; }
  </style>
</head>
<body>
  <div id="ndrStage">
    <div id="ndrContainer">
      <pre class="txt">$pageContent</pre>
    </div>
  </div>
  
  <script>
    // Converti link relativi in assoluti per Flutter WebView
    document.addEventListener('DOMContentLoaded', function() {
      const links = document.querySelectorAll('a[href*=".htm"]');
      links.forEach(link => {
        const href = link.getAttribute('href');
        if (href && !href.startsWith('http')) {
          link.setAttribute('href', 'https://www.ndr.de/public/teletext/' + href);
        }
      });
    });
    
    // Gestione tap sulla pagina per play/pause
    document.addEventListener('click', function(event) {
      // Controlla se il click non è su un link
      if (!event.target.closest('a')) {
        if (typeof PageTapped !== 'undefined') {
          PageTapped.postMessage('tap');
        }
      }
    });
    
    // Scaling dinamico (come SR/SWR - misura contenuto reale)
    function applyNDRScale() {
      const container = document.getElementById('ndrContainer');
      const pre = document.querySelector('pre.txt');
      
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
      
      console.log('[NDR Scale] Content: ' + contentW + 'x' + contentH + ', Viewport: ' + vw + 'x' + vh + ', Scale: ' + scaleX + ',' + finalScaleY);
    }
    
    // Applica scaling su load e resize
    window.addEventListener('load', function() {
      applyNDRScale();
      setTimeout(applyNDRScale, 50);
      setTimeout(applyNDRScale, 200);
    });
    window.addEventListener('resize', applyNDRScale);
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
    // NDR non ha pagine regionali, usa sempre nazionale
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  void dispose() {
    _dio.close();
  }
}
