import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/debug/debug_logger.dart';

/// Widget per visualizzare pagine HR Text usando WebView con HTML rendering
class HRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final VoidCallback? onTap;
  final Function(int)? onPageNavigation;

  const HRHtmlTeletextViewer({
    Key? key,
    required this.page,
    this.onTap,
    this.onPageNavigation,
  }) : super(key: key);

  @override
  State<HRHtmlTeletextViewer> createState() => _HRHtmlTeletextViewerState();
}

class _HRHtmlTeletextViewerState extends State<HRHtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    print('[HRHtmlTeletextViewer] initState - page ${widget.page.pageNumber}');
  }

  @override
  void didUpdateWidget(HRHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      print('[HRHtmlTeletextViewer] Page changed: ${widget.page.pageNumber}.${widget.page.subPage}');
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _initializeOrUpdateWebView(double width, double height) {
    final logger = DebugLogger();
    logger.log('HR', '_initializeOrUpdateWebView START - size: ${width}x$height');
    
    print('[HRHtmlTeletextViewer] Widget size: ${width}x$height');
    logger.log('HR', 'WebView size: ${width}x$height');

    if (_controller != null) {
      logger.log('HR', 'WebView already initialized, loading new content');
      final html = _buildHtmlWithScaling();
      _controller!.loadHtmlString(html);
      return;
    }

    logger.log('HR', 'Creating new WebViewController');
    bool isFirstLoad = true;
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'HRDebug',
        onMessageReceived: (JavaScriptMessage message) {
          print('[HRHtmlTeletextViewer][Debug] ${message.message}');
        },
      )
      ..addJavaScriptChannel(
        'PageNavigation',
        onMessageReceived: (JavaScriptMessage message) {
          print('[HRHtmlTeletextViewer] Navigation to page: ${message.message}');
          final pageNum = int.tryParse(message.message);
          if (pageNum != null && widget.onPageNavigation != null) {
            widget.onPageNavigation!(pageNum);
          }
        },
      )
      ..addJavaScriptChannel(
        'PageTapped',
        onMessageReceived: (JavaScriptMessage message) {
          print('[HRHtmlTeletextViewer] Page tapped');
          widget.onTap?.call();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (isFirstLoad) {
              logger.log('HR', 'WebView first load completed');
              isFirstLoad = false;
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('[HRHtmlTeletextViewer] WebView error: ${error.description}');
            if (mounted) {
              setState(() {
                _errorMessage = 'Errore caricamento: ${error.description}';
                _isLoading = false;
              });
            }
          },
        ),
      );

    final html = _buildHtmlWithScaling();
    _controller!.loadHtmlString(html);
    logger.log('HR', 'HTML loaded into WebView');
  }

  /// Costruisce l'HTML finale con scaling appropriato
  String _buildHtmlWithScaling() {
    // Usa l'HTML fornito dal provider che contiene già il template + contenuto
    final baseHtml = widget.page.htmlContent ?? '';
    
    if (baseHtml.isEmpty) {
      return '<html><body style="background: #000; color: #fff;">Nessun contenuto disponibile</body></html>';
    }
    
    // Aggiungi CSS di base: lo scaling reale viene calcolato via JS
    final scalingCss = '''
      <style id="flutter-hr-scaling">
        * { box-sizing: border-box; }
        html, body {
          background: #000 !important;
          margin: 0;
          padding: 0;
          width: 100%;
          height: 100%;
          overflow: hidden;
        }
        #ttxContainer {
          transform-origin: top left !important;
          position: relative !important;
          display: inline-block !important;
          opacity: 0;
        }
        #ttxPage {
          width: 100% !important;
          height: auto !important;
        }
      </style>
    ''';

    final html = baseHtml.replaceFirst('</head>', '$scalingCss</head>');

    // Aggiungi JavaScript per lo scaling dinamico e la navigazione
    final jsScript = '''
      <script id="flutter-hr-scaling-script">
        function applyHRScale() {
          try {
            const container = document.getElementById('ttxContainer');
            const page = document.getElementById('ttxPage') || container;
            if (!container || !page) return;
            const contentW = page.scrollWidth || page.clientWidth;
            const contentH = page.scrollHeight || page.clientHeight;
            if (!contentW || !contentH) return;
            // Small safe inset to avoid cropping on some simulators
            // Reduce X inset on narrow screens to avoid right black margin
            const insetY = 18;
            const aspectRatio = window.innerWidth / window.innerHeight;
            const insetX = aspectRatio < 0.7 ? 2 : 8;
            const vw = window.innerWidth - insetX;
            const vh = window.innerHeight - insetY;
            const scaleX = vw / contentW;
            const scaleY = vh / contentH;
            const ar = vw / vh;
            const maxYRatio = ar > 0.9 ? 1.15 : (ar > 0.7 ? 1.35 : 1.6);
            const finalScaleY = Math.min(scaleY, scaleX * maxYRatio);
            container.style.width = contentW + 'px';
            container.style.height = contentH + 'px';
            container.style.transformOrigin = 'top left';
            container.style.transform = 'translate(4px,4px) scale(' + scaleX + ',' + finalScaleY + ')';
            container.style.opacity = '1';
            if (typeof HRDebug !== 'undefined') {
              HRDebug.postMessage(JSON.stringify({
                phase: 'scaled',
                content: { w: contentW, h: contentH },
                viewport: { w: vw, h: vh },
                scale: { x: scaleX, y: finalScaleY }
              }));
            }
          } catch (e) {
            if (typeof HRDebug !== 'undefined') {
              HRDebug.postMessage('error:' + e.toString());
            }
          }
        }

        window.addEventListener('load', function() {
          applyHRScale();
          setTimeout(applyHRScale, 50);
          setTimeout(applyHRScale, 200);
        });
        window.addEventListener('resize', applyHRScale);

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
              // Estrai il numero di pagina dal formato ?page=XXX
              const match = href.match(/[?&]page=(\\d+)/);
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
      </script>
    ''';
    
    return html.replaceFirst('</body>', '$jsScript</body>');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        
        print('[HRHtmlTeletextViewer] LayoutBuilder: ${width}x$height');
        
        if (width > 0 && height > 0) {
          _initializeOrUpdateWebView(width, height);
        }

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

        return Stack(
          children: [
            Container(color: Colors.black),
            if (_controller != null)
              WebViewWidget(controller: _controller!),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    print('[HRHtmlTeletextViewer] dispose');
    super.dispose();
  }
}
