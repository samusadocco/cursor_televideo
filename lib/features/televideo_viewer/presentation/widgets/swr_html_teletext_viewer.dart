import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/debug/debug_logger.dart';

/// Widget per visualizzare pagine SWR Text usando WebView con HTML rendering
/// Supporta sia SWR BW (Baden-Württemberg) che SWR RP (Rheinland-Pfalz)
class SWRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final VoidCallback? onTap;
  final Function(int)? onPageNavigation;

  const SWRHtmlTeletextViewer({
    Key? key,
    required this.page,
    this.onTap,
    this.onPageNavigation,
  }) : super(key: key);

  @override
  State<SWRHtmlTeletextViewer> createState() => _SWRHtmlTeletextViewerState();
}

class _SWRHtmlTeletextViewerState extends State<SWRHtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    print('[SWRHtmlTeletextViewer] initState - page ${widget.page.pageNumber}');
  }

  @override
  void didUpdateWidget(SWRHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      print('[SWRHtmlTeletextViewer] Page changed: ${widget.page.pageNumber}.${widget.page.subPage}');
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _initializeOrUpdateWebView(double width, double height) {
    final logger = DebugLogger();
    logger.log('SWR', '_initializeOrUpdateWebView START - size: ${width}x$height');
    
    // Dimensioni native del contenuto SWR Text
    const nativeWidth = 520.0;
    const nativeHeight = 520.0;
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[SWRHtmlTeletextViewer] Widget size: ${width}x$height');
    print('[SWRHtmlTeletextViewer] Native content: ${nativeWidth}x$nativeHeight');
    print('[SWRHtmlTeletextViewer] Scale factors: X=$scaleX, Y=$scaleY');
    logger.log('SWR', 'Scale: ${scaleX}x${scaleY}');

    if (_controller != null) {
      logger.log('SWR', 'WebView already initialized, loading new content');
      final html = _buildHtmlWithScaling(scaleX, scaleY);
      _controller!.loadHtmlString(html);
      return;
    }

    logger.log('SWR', 'Creating new WebViewController');
    bool isFirstLoad = true;
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'PageNavigation',
        onMessageReceived: (JavaScriptMessage message) {
          print('[SWRHtmlTeletextViewer] Navigation to page: ${message.message}');
          final pageNum = int.tryParse(message.message);
          if (pageNum != null && widget.onPageNavigation != null) {
            widget.onPageNavigation!(pageNum);
          }
        },
      )
      ..addJavaScriptChannel(
        'PageTapped',
        onMessageReceived: (JavaScriptMessage message) {
          print('[SWRHtmlTeletextViewer] Page tapped');
          widget.onTap?.call();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (isFirstLoad) {
              logger.log('SWR', 'WebView first load completed');
              isFirstLoad = false;
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('[SWRHtmlTeletextViewer] WebView error: ${error.description}');
            if (mounted) {
              setState(() {
                _errorMessage = 'Errore caricamento: ${error.description}';
                _isLoading = false;
              });
            }
          },
        ),
      );

    final html = _buildHtmlWithScaling(scaleX, scaleY);
    _controller!.loadHtmlString(html);
    logger.log('SWR', 'HTML loaded into WebView');
  }

  /// Costruisce l'HTML finale con scaling appropriato
  String _buildHtmlWithScaling(double scaleX, double scaleY) {
    // Usa l'HTML fornito dal provider che contiene già il template + contenuto
    final baseHtml = widget.page.htmlContent ?? '';
    
    if (baseHtml.isEmpty) {
      return '<html><body style="background: #000; color: #fff;">Nessun contenuto disponibile</body></html>';
    }
    
    // Aggiungi CSS di scaling all'HTML esistente
    final scalingCss = '''
      <style id="flutter-swr-scaling">
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
   
                line-height: 1 !important;
        }
        #ttxStage {
      padding: 0;
      background: #000 !important;
      line-height: 1 !important;
      transform: scale($scaleX, $scaleY);
             transform-origin: top left;
      width: ${100 / scaleX}%;
      height: ${100 / scaleY}%;
        }
      </style>
    ''';
    
    // Inserisci il CSS prima del </head>
    final html = baseHtml.replaceFirst('</head>', '$scalingCss</head>');
    
    // Aggiungi JavaScript per la navigazione
    final jsNavigation = '''
      <script id="flutter-swr-navigation">
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
    
    return html.replaceFirst('</body>', '$jsNavigation</body>');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        
        print('[SWRHtmlTeletextViewer] LayoutBuilder: ${width}x$height');
        
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
    print('[SWRHtmlTeletextViewer] dispose');
    super.dispose();
  }
}
