import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/debug/debug_logger.dart';
import 'package:html/parser.dart' as html_parser;

/// Widget per visualizzare pagine WDR Text (Westdeutscher Rundfunk) in formato HTML
/// 
/// Questo widget renderizza il contenuto HTML delle pagine WDR text
class WDRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const WDRHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<WDRHtmlTeletextViewer> createState() => _WDRHtmlTeletextViewerState();
}

class _WDRHtmlTeletextViewerState extends State<WDRHtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _rawHtmlContent;
  String? _vtRowInfoHtml;
  String? _seiteContentHtml;
  double? _lastWidth;
  double? _lastHeight;

  @override
  void initState() {
    super.initState();
    final logger = DebugLogger();
    logger.log('WDR', 'initState - page: ${widget.page.pageNumber}_${widget.page.subPage}');
    _extractContent();
  }

  @override
  void didUpdateWidget(WDRHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final logger = DebugLogger();
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      logger.log('WDR', 'didUpdateWidget - page changed');
      setState(() {
        _isLoading = true;
      });
      _lastWidth = null;
      _lastHeight = null;
      _rawHtmlContent = null;
      _vtRowInfoHtml = null;
      _seiteContentHtml = null;
      _extractContent();
    }
  }

  Future<void> _extractContent() async {
    final logger = DebugLogger();
    logger.log('WDR', '_extractContent START');
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final htmlString = widget.page.htmlContent ?? '';
      
      if (htmlString.isEmpty) {
        throw Exception('No HTML content from provider');
      }
      
      final document = html_parser.parse(htmlString);
      
      // Estrai vt_row_info
      final vtRowInfoDiv = document.getElementById('vt_row_info');
      if (vtRowInfoDiv != null) {
        _vtRowInfoHtml = vtRowInfoDiv.outerHtml;
        logger.log('WDR', 'vt_row_info extracted: ${_vtRowInfoHtml!.length} chars');
        print('[WDRHtmlTeletextViewer] vt_row_info extracted');
      } else {
        print('[WDRHtmlTeletextViewer] WARNING: vt_row_info NOT found in HTML');
      }
      
      // Estrai seite_nn
      final subPage = widget.page.subPage;
      final seiteId = 'seite_$subPage';
      final seiteDiv = document.getElementById(seiteId);
      
      if (seiteDiv == null) {
        throw Exception('$seiteId not found');
      }
      
      _seiteContentHtml = seiteDiv.outerHtml;
      _rawHtmlContent = htmlString;
      
      logger.log('WDR', '_extractContent COMPLETED');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
          }
        } catch (e) {
      logger.log('WDR', '_extractContent ERROR: $e');
    if (mounted) {
      setState(() {
          _errorMessage = 'Errore: $e';
        _isLoading = false;
      });
    }
    }
  }

  void _initializeOrUpdateWebView(double width, double height) {
    final logger = DebugLogger();
    logger.log('WDR', '_initializeOrUpdateWebView START - size: ${width}x$height');
    
    // Dimensioni native del contenuto WDR mobiltext (come ARD)
    const nativeWidth = 640.0;
    const nativeHeight = 640.0;
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[WDRHtmlTeletextViewer] Widget size: ${width}x$height');
    print('[WDRHtmlTeletextViewer] Native content: ${nativeWidth}x$nativeHeight');
    print('[WDRHtmlTeletextViewer] Scale factors: X=$scaleX, Y=$scaleY');
    logger.log('WDR', 'Scale: ${scaleX}x${scaleY}');
    
    // Controlla se serve ricaricare il controller
    // Aggiungiamo una tolleranza di 20px per evitare reload inutili dovuti a piccoli shift (es. banner pubblicitari)
    final dimensionsChanged = _lastWidth == null || _lastHeight == null ||
        (width - _lastWidth!).abs() > 20 || (height - _lastHeight!).abs() > 20;
    
    if (_controller == null) {
      bool isFirstLoad = true;
      
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..addJavaScriptChannel(
          'PageNavigation',
          onMessageReceived: (JavaScriptMessage message) {
            final pageNumber = int.tryParse(message.message);
            if (pageNumber != null && widget.onPageNavigation != null) {
              widget.onPageNavigation!(pageNumber);
            }
          },
        )
        ..addJavaScriptChannel(
          'PageTapped',
          onMessageReceived: (JavaScriptMessage message) {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              logger.log('WDR', 'Page loaded');
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              if (isFirstLoad) {
                isFirstLoad = false;
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
          ),
        )
        ..loadHtmlString(_buildHtmlWithScaling(scaleX, scaleY));
      
      logger.log('WDR', 'NEW controller created');
    } else if (dimensionsChanged) {
      logger.log('WDR', 'REUSING controller, reloading HTML');
      _controller!.loadHtmlString(_buildHtmlWithScaling(scaleX, scaleY));
    }
    
    _lastWidth = width;
    _lastHeight = height;
  }

  String _buildHtmlWithScaling(double scaleX, double scaleY) {
    // Le variabili vtRowInfo e seiteContent sono estratte dall'HTML scaricato
    // e usate nel template statico HTML definito sotto
    final vtRowInfo = _vtRowInfoHtml ?? '''<div class="vt_row bg_black white" id="vt_row_info">
                <div class="bg_black white vt_col col2"><span class="vt_span style1"></span></div>
                <div class="bg_black white vt_col col4"><span class="invisible">aktuelle Seite </span><span class="vt_span style1">&nbsp;200&nbsp;</span></div>
                <div class="bg_black white vt_col col4"><span class="invisible">nächste Seite </span><span class="vt_span style1">201&nbsp;</span></div>
                <div class="bg_black white vt_col col10"><span class="vt_span style1"> WDR Text &nbsp;</span></div>
                <div class="bg_black white vt_col col10"><span class="invisible">Datum </span><span class="vt_span style1" id="vt_date">Do 08.01. &nbsp;</span></div>
                <div class="bg_black white vt_col col10"><span class="invisible">Uhrzeit </span><span class="vt_span style1" id="vt_time">14:23:12</span></div>
              </div>''';
    final seiteContent = _seiteContentHtml ?? '<div id="seite_1"><p>Loading...</p></div>';
    
    return '''
<html lang="de" xml:lang="de" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <base href="https://mobiltext.wdr.de/" target="_blank" />
    <meta content="de" name="Language" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta content="M. Wegmann" name="Author" />
    <meta content="Nur WDR" name="DC.Rights" />
    <meta content="900" http-equiv="expires" />
    <meta content="noarchive" name="googlebot" />
    <meta content="index,follow" name="robots" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
    <title>WDR-Text - Seite ${widget.page.pageNumber}</title>
    <link title="Copyright" href="/107.html" rel="copyright" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/640.css" />
    <link rel="stylesheet" type="text/css" href="css/fonts.css" />
    <style id="flutter-wdr-scaling">
      /* Scaling per adattare il contenuto alle dimensioni del device (come ARD) */
      * {
        box-sizing: border-box;
      }
      html, body {
        background: #000 !important;
        margin: 0;
        padding: 0;
        
        width: 100%;
        height: 100%;
        overflow: hidden;
      }
      #wdrtext_outer {
        transform: scale($scaleX, $scaleY);
        transform-origin: top left;
        width: ${100 / scaleX}%;
        height: ${100 / scaleY}%;
      }
    </style>
    <script src="js/tv_mobil.js" type="text/javascript"></script>
    <script type="text/javascript">
      <!--
      var act_pagenum = ${widget.page.pageNumber};
      var page_count = ${widget.page.maxSubPages};
      var act_page = ${widget.page.subPage - 1};
      var datum = "";
      //-->
    </script>
    <script src="js/jquery-2.1.3.min.js" type="text/javascript"></script>
    <script src="js/vtxMobileTracker.min.js" type="text/javascript"></script>
  </head>
  <body>
    <div id="wdrtext_outer">
      <div class="vt_container_header">
        <!--Version V1.11 17012012-->
        <!--googleoff: index-->
        $vtRowInfo
        <!--googleon: index-->
        <div id="wdrtext_inner">
          $seiteContent
        </div>
      </div>
    </div>
    
    <script id="flutter-wdr-navigation">
      // Intercetta i click sui link per la navigazione tra pagine
      document.addEventListener('click', function(e) {
        let target = e.target;
        // Risali all'elemento <a> più vicino
        while (target && target.tagName !== 'A') {
          target = target.parentElement;
        }
        
        if (target && target.tagName === 'A') {
          e.preventDefault();
          const href = target.getAttribute('href');
          if (href) {
            // Estrai il numero di pagina dal formato XXX.html
            const match = href.match(/(\\d+)\\.html\$/);
            if (match && typeof PageNavigation !== 'undefined') {
              PageNavigation.postMessage(match[1]);
            }
          }
          return false;
        }
        
        // Se il click non è su un link, notifica il tap generico
        if (typeof PageTapped !== 'undefined') {
          PageTapped.postMessage('tap');
        }
      });
      
      // Funzione per aggiornare data e ora in tempo reale
      var days = ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"];
      
      function dateStr() {
        var now = new Date();
        var day = days[now.getDay()];
        var mday = now.getDate();
        var month = now.getMonth() + 1;
        if (mday < 10) { mday = "0" + mday; }
        if (month < 10) { month = "0" + month; }
        return day + " " + mday + "." + month + ". ";
      }
      
      function timeStr() {
        var now = new Date();
        var hour = now.getHours();
        var min = now.getMinutes();
        var sec = now.getSeconds();
        if (hour < 10) { hour = "0" + hour; }
        if (min < 10) { min = "0" + min; }
        if (sec < 10) { sec = "0" + sec; }
        return hour + ":" + min + ":" + sec;
      }
      
      function updateDateTime() {
        var vt_time = document.getElementById('vt_time');
        var vt_date = document.getElementById('vt_date');
        
        if (vt_time) {
          vt_time.innerHTML = timeStr();
        }
        if (vt_date) {
          vt_date.innerHTML = dateStr() + "&#160;";
        }
        
        setTimeout(updateDateTime, 1000);
      }
      
      // Avvia l'aggiornamento di data/ora quando il documento è pronto
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateDateTime);
      } else {
        updateDateTime();
      }
    </script>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
                _errorMessage!,
            style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_isLoading || _rawHtmlContent == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _initializeOrUpdateWebView(width, height);
            }
          });
        
        if (_controller == null) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        
        return Container(
          color: Colors.black,
          child: WebViewWidget(
            key: ValueKey(widget.page.imageUrl),
            controller: _controller!,
          ),
        );
      },
    );
  }
}
