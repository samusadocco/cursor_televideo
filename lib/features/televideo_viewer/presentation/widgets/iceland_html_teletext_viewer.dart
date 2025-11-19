import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';

class IcelandHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final VoidCallback? onTap;

  const IcelandHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onTap,
  });

  @override
  State<IcelandHtmlTeletextViewer> createState() => _IcelandHtmlTeletextViewerState();
}

class _IcelandHtmlTeletextViewerState extends State<IcelandHtmlTeletextViewer> {
  late final WebViewController _controller;
  bool _isInitialized = false;
  bool _hasLoadedContent = false;
  double _lastWidth = 0;
  double _lastHeight = 0;
  
  // Dimensioni native del contenuto RÚV Textavarp
  // Dimensioni reali del contenuto come viene fornito dal server
  static const double _nativeWidth = 400.0;
  static const double _nativeHeight = 380.0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'NavigateTo',
        onMessageReceived: (JavaScriptMessage message) {
          print('[IcelandViewer] Navigation request: ${message.message}');
          final pageNumber = int.tryParse(message.message);
          if (pageNumber != null && mounted) {
            context.read<TelevideoBloc>().add(
              TelevideoEvent.loadNationalPage(pageNumber),
            );
          }
        },
      )
      ..addJavaScriptChannel(
        'OnTap',
        onMessageReceived: (JavaScriptMessage message) {
          print('[IcelandViewer] Tap detected via JavaScript');
          if (widget.onTap != null && mounted) {
            widget.onTap!();
          }
        },
      )
      ..addJavaScriptChannel(
        'DebugLog',
        onMessageReceived: (JavaScriptMessage message) {
          print('[IcelandViewer-JS] ${message.message}');
        },
      );
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(IcelandHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      setState(() {
        _hasLoadedContent = false;
        _lastWidth = 0;
        _lastHeight = 0;
      });
    }
  }

  void _initializeOrUpdateWebView(double width, double height) {
    if (!_hasLoadedContent || _lastWidth != width || _lastHeight != height) {
      final scaleX = width / _nativeWidth;
      final scaleY = height / _nativeHeight;
      
      print('[IcelandViewer] Loading content with size: ${width}x$height');
      print('[IcelandViewer] Scale factors: scaleX=$scaleX, scaleY=$scaleY');
      print('[IcelandViewer] Building HTML with scaleX=$scaleX, scaleY=$scaleY');
      print('[IcelandViewer] Native dimensions: ${_nativeWidth}x$_nativeHeight');
      
      final htmlString = _buildHtmlString(scaleX, scaleY);
      print('[IcelandViewer] Final HTML length: ${htmlString.length} bytes');
      
      // Usa loadHtmlString con baseUrl per permettere il caricamento del font
      // Il baseUrl consente al WebView di caricare risorse esterne (font, CSS) senza problemi CORS
      _controller.loadHtmlString(
        htmlString,
        baseUrl: 'https://textavarp.is/',
      );
      
      _lastWidth = width;
      _lastHeight = height;
      _hasLoadedContent = true;
    }
  }

  String _buildHtmlString(double scaleX, double scaleY) {
    final originalHtml = widget.page.htmlContent ?? '';
    
    // Aggiungi viewport meta tag se non presente
    String modifiedHtml = originalHtml;
    if (!modifiedHtml.contains('viewport')) {
      modifiedHtml = modifiedHtml.replaceFirst(
        '</head>',
        '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"></head>',
      );
    }
    
    // CSS per forzare il scaling e riempire tutto lo schermo
    final injectedCss = '''
      <style id="iceland-scaling-override">
        * { box-sizing: border-box !important; }
        html, body {
          margin: 0 !important;
          padding: 0 !important;
          overflow: hidden !important;
          background-color: black !important;
          width: 100% !important;
          height: 100% !important;
        }
        #layerData {
          width: ${_nativeWidth}px !important;
          height: ${_nativeHeight}px !important;
          min-width: ${_nativeWidth}px !important;
          min-height: ${_nativeHeight}px !important;
          max-width: ${_nativeWidth}px !important;
          max-height: ${_nativeHeight}px !important;
          margin: 0 !important;
          padding: 0 !important;
          overflow: hidden !important;
          font-family: externalFont, monospace !important;
          position: absolute !important;
          left: 0 !important;
          top: 0 !important;
          transform: scale($scaleX, $scaleY) !important;
          transform-origin: top left !important;
        }
        #layerData div, #layerData pre {
          margin: 0 !important;
          padding: 0 !important;
          line-height: 1 !important;
          font-family: externalFont, monospace !important;
          color: white !important;
        }
        #layerData span { font-family: inherit !important; }
        a { cursor: pointer !important; text-decoration: none !important; }
      </style>
    ''';
    
    // JavaScript per intercettare click e navigazione
    final injectedScript = '''
      <script>
        document.addEventListener('DOMContentLoaded', function() {
          DebugLog.postMessage('Page loaded');
          
          // FORZA dimensioni su html e body rimuovendo inline styles
          document.documentElement.removeAttribute('style');
          document.body.removeAttribute('style');
          
          // Applica dimensioni sul body
          document.body.style.setProperty('width', '100%', 'important');
          document.body.style.setProperty('height', '100%', 'important');
          document.body.style.setProperty('margin', '0', 'important');
          document.body.style.setProperty('padding', '0', 'important');
          document.body.style.setProperty('overflow', 'hidden', 'important');
          document.body.style.setProperty('background-color', 'black', 'important');
          
          // FORZA dimensioni e transform su layerData rimuovendo inline styles
          var layerData = document.getElementById('layerData');
          if (layerData) {
            // Rimuovi TUTTI gli inline styles dal layerData
            layerData.removeAttribute('style');
            
            // Applica le dimensioni fisse e il transform via JavaScript
            layerData.style.setProperty('width', '${_nativeWidth}px', 'important');
            layerData.style.setProperty('height', '${_nativeHeight}px', 'important');
            layerData.style.setProperty('min-width', '${_nativeWidth}px', 'important');
            layerData.style.setProperty('min-height', '${_nativeHeight}px', 'important');
            layerData.style.setProperty('max-width', '${_nativeWidth}px', 'important');
            layerData.style.setProperty('max-height', '${_nativeHeight}px', 'important');
            layerData.style.setProperty('position', 'absolute', 'important');
            layerData.style.setProperty('left', '0', 'important');
            layerData.style.setProperty('top', '0', 'important');
            layerData.style.setProperty('margin', '0', 'important');
            layerData.style.setProperty('padding', '0', 'important');
            layerData.style.setProperty('overflow', 'hidden', 'important');
            layerData.style.setProperty('font-family', 'externalFont, monospace', 'important');
            layerData.style.setProperty('transform', 'scale($scaleX, $scaleY)', 'important');
            layerData.style.setProperty('transform-origin', 'top left', 'important');
            
            DebugLog.postMessage('Inline styles removed, dimensions and transform applied');
            DebugLog.postMessage('Scale factors: scaleX=$scaleX, scaleY=$scaleY');
            var computedStyle = window.getComputedStyle(layerData);
            DebugLog.postMessage('LayerData font-family: ' + computedStyle.fontFamily);
            DebugLog.postMessage('LayerData width: ' + computedStyle.width);
            DebugLog.postMessage('LayerData height: ' + computedStyle.height);
            DebugLog.postMessage('LayerData transform: ' + computedStyle.transform);
            DebugLog.postMessage('Body width: ' + window.getComputedStyle(document.body).width);
            DebugLog.postMessage('Body height: ' + window.getComputedStyle(document.body).height);
            
            // Check if custom font is loaded
            document.fonts.ready.then(function() {
              var fontLoaded = document.fonts.check('1em externalFont');
              DebugLog.postMessage('externalFont loaded: ' + fontLoaded);
              if (!fontLoaded) {
                DebugLog.postMessage('WARNING: externalFont NOT loaded, falling back to monospace');
              }
            });
          }
          
          // Intercetta click su link e tap generico
          document.addEventListener('click', function(e) {
            var linkElement = e.target.closest('a[href]');
            if (linkElement) {
              e.preventDefault();
              e.stopPropagation();
              var href = linkElement.getAttribute('href');
              var match = href.match(/\\/sida\\/(\\d+)\\/\\d+/);
              if (match) {
                NavigateTo.postMessage(match[1]);
              }
            } else {
              OnTap.postMessage('tap');
            }
          }, true);
        });
      </script>
    ''';
    
    final finalHtml = modifiedHtml
        .replaceFirst('</head>', '$injectedCss</head>')
        .replaceFirst('</body>', '$injectedScript</body>');
    
    return finalHtml;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || widget.page.htmlContent == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.yellow),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _initializeOrUpdateWebView(constraints.maxWidth, constraints.maxHeight);
          return WebViewWidget(controller: _controller);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
