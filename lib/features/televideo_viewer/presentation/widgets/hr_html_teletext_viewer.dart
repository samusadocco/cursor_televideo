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
    
    // Aggiungi JavaScript per lo scaling dinamico e la navigazione
    final jsScript = '''
      <script id="flutter-hr-scaling">
        function applyScaling() {
          try {
            const container = document.getElementById('ttxContainer');
            const page = document.getElementById('ttxPage');
            if (!container || !page) {
              console.error('HR: container or page not found');
              return;
            }

            // Misura le dimensioni reali del contenuto
            const contentWidth = page.scrollWidth;
            const contentHeight = page.scrollHeight;
            
            // Calcola lo scale in base al viewport
            const viewportWidth = window.innerWidth;
            const viewportHeight = window.innerHeight;
            
            const scaleX = viewportWidth / contentWidth;
            const scaleY = viewportHeight / contentHeight;
            
            // Determina il device type
            const aspectRatio = viewportWidth / viewportHeight;
            let maxYRatio;
            
            if (aspectRatio > 1.5) {
              // iPad landscape
              maxYRatio = 1.15;
            } else if (aspectRatio > 0.7) {
              // iPad portrait
              maxYRatio = 1.35;
            } else {
              // iPhone
              maxYRatio = 1.60;
            }
            
            // Usa scaleX per la larghezza, limita scaleY
            const finalScaleY = Math.min(scaleY, scaleX * maxYRatio);
            
            // Applica la trasformazione
            container.style.transform = 'scale(' + scaleX + ', ' + finalScaleY + ')';
            container.style.transformOrigin = 'top left';
            container.style.width = contentWidth + 'px';
            container.style.height = contentHeight + 'px';
            container.style.position = 'relative';
            
            // Invia telemetria
            if (typeof HRDebug !== 'undefined') {
              const info = {
                phase: 'scaled',
                viewport: { w: viewportWidth, h: viewportHeight },
                content: { w: contentWidth, h: contentHeight },
                scale: { x: scaleX, y: finalScaleY },
                aspectRatio: aspectRatio,
                maxYRatio: maxYRatio
              };
              HRDebug.postMessage(JSON.stringify(info));
            }
          } catch (e) {
            console.error('HR scaling error:', e);
            if (typeof HRDebug !== 'undefined') {
              HRDebug.postMessage('error:' + e.toString());
            }
          }
        }

        // Applica lo scaling quando il DOM è pronto
        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', function() {
            setTimeout(applyScaling, 50);
          });
        } else {
          setTimeout(applyScaling, 50);
        }
        
        // Riapplica su resize
        window.addEventListener('resize', function() {
          setTimeout(applyScaling, 50);
        });

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
    
    return baseHtml.replaceFirst('</body>', '$jsScript</body>');
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
