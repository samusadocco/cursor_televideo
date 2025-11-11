import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Widget per visualizzare pagine RTL Teletext
/// 
/// RTL usa un formato XML proprietario che viene convertito in HTML
/// dal provider. Questo viewer visualizza l'HTML risultante.
class RTLHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const RTLHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<RTLHtmlTeletextViewer> createState() => _RTLHtmlTeletextViewerState();
}

class _RTLHtmlTeletextViewerState extends State<RTLHtmlTeletextViewer> {
  WebViewController? _controller;
  String? _rawHtmlContent;
  bool _isLoading = true;
  double? _lastWidth;
  double? _lastHeight;
  int _controllerVersion = 0; // Per forzare rebuild
  double _currentScaleX = 1.0; // Tiene traccia dello scale X CSS applicato
  double _currentScaleY = 1.0; // Tiene traccia dello scale Y CSS applicato

  @override
  void initState() {
    super.initState();
    _extractContent();
  }

  @override
  void didUpdateWidget(RTLHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.imageUrl != widget.page.imageUrl ||
        oldWidget.page.subPage != widget.page.subPage) {
      // Reset controller per forzare ricreazione
      _controller = null;
      _lastWidth = null;
      _lastHeight = null;
      _extractContent();
    }
  }

  /// Estrae il contenuto HTML dalla pagina RTL
  Future<void> _extractContent() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('[RTLHtmlTeletextViewer] Using pre-fetched HTML content');
      
      // RTL: l'HTML è già completo e generato dal provider
      // Lo prendiamo direttamente dal TelevideoPage
      if (widget.page.htmlContent != null) {
        _rawHtmlContent = widget.page.htmlContent!;
        
        print('[RTLHtmlTeletextViewer] HTML content length: ${_rawHtmlContent?.length ?? 0}');
        
        // Il WebView sarà inizializzato nel build method tramite LayoutBuilder
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        throw Exception('No HTML content in page');
      }
    } catch (e) {
      print('[RTLHtmlTeletextViewer] Error loading content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Inizializza o aggiorna il WebView con scaling dinamico
  void _initializeOrUpdateWebView(double width, double height) {
    // RTL Teletext - dimensioni native adattive basate sull'aspect ratio
    final aspectRatio = width / height;
    
    double nativeWidth;
    double nativeHeight;
    
    if (aspectRatio > 1.5) {
      // iPad orizzontale o dispositivo molto largo
      nativeWidth = 520.0;
      nativeHeight = 390.0;
      print('[RTLHtmlTeletextViewer] Mode: iPad landscape (wide)');
    } else if (aspectRatio > 0.7) {
      // iPad verticale o tablet
      nativeWidth = 460.0;
      nativeHeight = 580.0;
      print('[RTLHtmlTeletextViewer] Mode: iPad portrait (medium)');
    } else {
      // iPhone o dispositivo stretto
      nativeWidth = 440.0;
      nativeHeight = 450.0;
      print('[RTLHtmlTeletextViewer] Mode: iPhone (narrow)');
    }
    
    // Calcola scale factors (usa scaling NON uniforme come NOS)
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[RTLHtmlTeletextViewer] Widget size: ${width}x$height (aspect: ${aspectRatio.toStringAsFixed(2)})');
    print('[RTLHtmlTeletextViewer] Native size: ${nativeWidth}x$nativeHeight');
    print('[RTLHtmlTeletextViewer] Scale factors: X=$scaleX, Y=$scaleY');

    // Salva le dimensioni correnti
    _lastWidth = width;
    _lastHeight = height;

    // Se il controller non è stato creato, creane uno nuovo
    if (_controller == null) {
      _createWebViewController(scaleX, scaleY, nativeWidth, nativeHeight);
    } else {
      // Altrimenti, aggiorna solo lo scaling JavaScript
      _updateScaling(scaleX, scaleY);
    }
  }

  /// Crea un nuovo WebViewController
  void _createWebViewController(double scaleX, double scaleY, double nativeWidth, double nativeHeight) {
    print('[RTLHtmlTeletextViewer] Creating new WebViewController (version: $_controllerVersion)');
    
    print('[RTLHtmlTeletextViewer] Using scaleX: $scaleX, scaleY: $scaleY');
    
    // Salva entrambi gli scale per i click (X e Y separati per scaling non uniforme)
    _currentScaleX = scaleX;
    _currentScaleY = scaleY;
    
    // Inietta lo scale DIRETTAMENTE nell'HTML prima del caricamento
    final scaledHtml = _injectScaleInHtml(_rawHtmlContent ?? '', scaleX, scaleY, nativeWidth, nativeHeight);
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'TapHandler',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptTap(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _injectTapHandler();
          },
        ),
      )
      ..loadHtmlString(scaledHtml);

    // Incrementa version per forzare rebuild del WebViewWidget
    _controllerVersion++;

    if (mounted) {
      setState(() {});
    }
  }
  
  /// Inietta JavaScript per catturare i tap e inviarli a Flutter
  Future<void> _injectTapHandler() async {
    if (_controller == null) return;
    
    print('[RTLHtmlTeletextViewer] Injecting tap handler JavaScript');
    
    await _controller!.runJavaScript('''
      document.body.addEventListener('click', function(event) {
        // Previeni il comportamento di default
        event.preventDefault();
        
        // Ottieni le coordinate del click relative al viewport
        var x = event.clientX;
        var y = event.clientY;
        
        // Ottieni il bounding rect del #content (che ha padding di 8px)
        var contentDiv = document.getElementById('content');
        if (contentDiv) {
          var rect = contentDiv.getBoundingClientRect();
          // Sottrai l'offset del content div per ottenere coordinate relative al contenuto
          x = x - rect.left;
          y = y - rect.top;
          
          console.log('RTL click at (relative to content): ' + x + ', ' + y);
          console.log('Content rect:', rect.left, rect.top, rect.width, rect.height);
        } else {
          console.log('RTL click at (viewport): ' + x + ', ' + y);
        }
        
        // Invia le coordinate a Flutter tramite il channel
        TapHandler.postMessage(x + ',' + y);
      }, true); // true = capture phase per intercettare prima del WebView
    ''');
  }
  
  /// Gestisce il tap ricevuto da JavaScript
  void _handleJavaScriptTap(String message) {
    // Il messaggio è nel formato "x,y"
    final parts = message.split(',');
    if (parts.length != 2) return;
    
    final scaledTapX = double.tryParse(parts[0]);
    final scaledTapY = double.tryParse(parts[1]);
    
    if (scaledTapX == null || scaledTapY == null) return;
    
    print('[RTLHtmlTeletextViewer] JavaScript tap at SCALED coordinates: ($scaledTapX, $scaledTapY)');
    
    // De-scala le coordinate per confrontarle con le clickable areas
    // Le clickable areas sono in coordinate native (pre-scaling)
    // IMPORTANTE: Usa scaleX per X e scaleY per Y separatamente!
    final nativeTapX = scaledTapX / _currentScaleX;
    final nativeTapY = scaledTapY / _currentScaleY;
    
    print('[RTLHtmlTeletextViewer] Native tap at ($nativeTapX, $nativeTapY) [scaleX=$_currentScaleX, scaleY=$_currentScaleY]');
    
    // Controlla se il tap è su una clickable area
    final clickableAreas = widget.page.clickableAreas;
    for (final area in clickableAreas) {
      if (nativeTapX >= area.x && 
          nativeTapX <= (area.x + area.width) &&
          nativeTapY >= area.y && 
          nativeTapY <= (area.y + area.height)) {
        print('[RTLHtmlTeletextViewer] ✅ Clicked on area: page ${area.targetPage} at (${area.x},${area.y}) size ${area.width}x${area.height}');
        
        // Naviga alla pagina
        if (widget.onPageNavigation != null) {
          widget.onPageNavigation!(area.targetPage);
        }
        return;
      }
    }
    
    print('[RTLHtmlTeletextViewer] ❌ No clickable area found at tap position');
    
    // Debug: mostra tutte le clickable areas
    print('[RTLHtmlTeletextViewer] Available clickable areas:');
    for (final area in clickableAreas) {
      print('  - Page ${area.targetPage}: (${area.x},${area.y}) size ${area.width}x${area.height}');
    }
    
    // Se non c'è un'area cliccabile, esegui l'azione di tap generica
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }
  
  /// Inietta lo scale CSS (NON uniforme per X e Y) nell'HTML
  String _injectScaleInHtml(String html, double scaleX, double scaleY, double nativeWidth, double nativeHeight) {
    print('[RTLHtmlTeletextViewer] Injecting scaleX=$scaleX, scaleY=$scaleY into HTML');
    print('[RTLHtmlTeletextViewer] HTML length before: ${html.length}');
    
    // Prima inietta CSS per rimuovere spacing tra righe (già fatto nel provider ma forziamo)
    String modifiedHtml = html;
    if (html.contains('</head>')) {
      const cssOverride = '''
<style>
  /* Rimuove bande nere tra le righe */
  * {
    margin: 0 !important;
    padding: 0 !important;
    line-height: 1 !important;
  }
  pre, div {
    margin: 0 !important;
    padding: 0 !important;
    line-height: 1 !important;
    display: block !important;
  }
  span, a {
    margin: 0 !important;
    padding: 0 !important;
    line-height: 1 !important;
    display: inline !important;
    vertical-align: baseline !important;
  }
</style>
''';
      modifiedHtml = html.replaceFirst('</head>', '$cssOverride</head>');
      print('[RTLHtmlTeletextViewer] CSS override injected');
    }
    
    // Cerca il tag <body> e aggiungi lo style inline per lo scaling NON uniforme
    if (modifiedHtml.contains('<body')) {
      // Usa transform: scale(X, Y) per scaling indipendente su assi
      final scaledHtml = modifiedHtml.replaceFirstMapped(
        RegExp(r'<body([^>]*)>'),
        (match) {
          final existingAttrs = match.group(1) ?? '';
          return '<body$existingAttrs style="transform: scale($scaleX, $scaleY); transform-origin: top left; width: ${nativeWidth}px; height: ${nativeHeight}px;">';
        },
      );
      
      print('[RTLHtmlTeletextViewer] HTML length after: ${scaledHtml.length}');
      print('[RTLHtmlTeletextViewer] Scale injected successfully');
      
      // Debug: mostra le prime 200 caratteri del body modificato
      final bodyIndex = scaledHtml.indexOf('<body');
      if (bodyIndex >= 0 && bodyIndex + 200 <= scaledHtml.length) {
        final bodyPreview = scaledHtml.substring(bodyIndex, bodyIndex + 200);
        print('[RTLHtmlTeletextViewer] Body tag: $bodyPreview');
      }
      
      return scaledHtml;
    }
    
    print('[RTLHtmlTeletextViewer] WARNING: <body> tag not found in HTML!');
    return modifiedHtml;
  }

  /// Aggiorna lo scaling del contenuto tramite JavaScript
  Future<void> _updateScaling(double scaleX, double scaleY) async {
    if (_controller == null) return;

    print('[RTLHtmlTeletextViewer] Applying non-uniform scale: X=$scaleX, Y=$scaleY');

    try {
      await _controller!.runJavaScript('''
        (function() {
          console.log('Applying RTL Teletext non-uniform scaling: X=$scaleX, Y=$scaleY');
          
          // Applica scaling NON uniforme al body
          document.body.style.transform = 'scale($scaleX, $scaleY)';
          document.body.style.transformOrigin = 'top left';
          
          console.log('RTL Teletext non-uniform scaling applied successfully');
        })();
      ''');
    } catch (e) {
      print('[RTLHtmlTeletextViewer] Error updating scaling: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_rawHtmlContent == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Errore nel caricamento della pagina',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        print('[RTLHtmlTeletextViewer] LayoutBuilder constraints: ${width}x$height');

        // Inizializza o aggiorna il WebView solo se le dimensioni sono cambiate
        if (_lastWidth != width || _lastHeight != height) {
          print('[RTLHtmlTeletextViewer] Dimensions changed, updating WebView');
          // Usa addPostFrameCallback per evitare di modificare lo stato durante il build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _initializeOrUpdateWebView(width, height);
            }
          });
        }

        if (_controller == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        return Container(
          color: Colors.black,
          width: width,
          height: height,
          child: WebViewWidget(
            key: ValueKey('rtl_webview_$_controllerVersion'),
            controller: _controller!,
          ),
        );
      },
    );
  }
}

