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
  double _currentScale = 1.0; // Tiene traccia dello scale CSS applicato

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
    // RTL Teletext - dimensioni native standard
    const double nativeWidth = 492.0;
    const double nativeHeight = 489.0;
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    // USA SCALING UNIFORME per evitare deformazione
    // Prendi il fattore MINORE per mantenere aspect ratio
    final uniformScale = scaleX < scaleY ? scaleX : scaleY;
    
    print('[RTLHtmlTeletextViewer] Widget size: ${width}x$height (real available space)');
    print('[RTLHtmlTeletextViewer] Native size: ${nativeWidth}x$nativeHeight');
    print('[RTLHtmlTeletextViewer] Scale factors: X=$scaleX, Y=$scaleY');
    print('[RTLHtmlTeletextViewer] Using uniform scale: $uniformScale');

    // Salva le dimensioni correnti
    _lastWidth = width;
    _lastHeight = height;

    // Se il controller non è stato creato, creane uno nuovo
    if (_controller == null) {
      _createWebViewController(uniformScale);
    } else {
      // Altrimenti, aggiorna solo lo scaling JavaScript
      _updateScaling(uniformScale);
    }
  }

  /// Crea un nuovo WebViewController
  void _createWebViewController(double scale) {
    print('[RTLHtmlTeletextViewer] Creating new WebViewController (version: $_controllerVersion)');
    
    // Usa scaling UNIFORME per mantenere aspect ratio
    print('[RTLHtmlTeletextViewer] Using uniform scale: $scale');
    
    // Salva lo scale per usarlo nella de-scalatura delle coordinate
    _currentScale = scale;
    
    // Inietta lo scale DIRETTAMENTE nell'HTML prima del caricamento
    final scaledHtml = _injectScaleInHtml(_rawHtmlContent ?? '', scale);
    
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
        
        // Ottieni le coordinate del click relative al document
        var x = event.pageX;
        var y = event.pageY;
        
        console.log('RTL click at: ' + x + ', ' + y);
        
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
    final nativeTapX = scaledTapX / _currentScale;
    final nativeTapY = scaledTapY / _currentScale;
    
    print('[RTLHtmlTeletextViewer] Native tap at ($nativeTapX, $nativeTapY) [scale=$_currentScale]');
    
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
  
  /// Inietta lo scale CSS direttamente nell'HTML
  String _injectScaleInHtml(String html, double scale) {
    print('[RTLHtmlTeletextViewer] Injecting scale=$scale into HTML');
    print('[RTLHtmlTeletextViewer] HTML length before: ${html.length}');
    
    // Cerca il tag <body> e aggiungi lo style inline per lo scaling
    if (html.contains('<body')) {
      // Usa transform: scale(uniform) per mantenere aspect ratio
      // NOTA: Devo usare r'...' (raw string) per evitare che $1 venga interpretato come variabile Dart
      final scaledHtml = html.replaceFirstMapped(
        RegExp(r'<body([^>]*)>'),
        (match) {
          final existingAttrs = match.group(1) ?? '';
          return '<body$existingAttrs style="transform: scale($scale); transform-origin: top left; width: ${100 / scale}%; height: ${100 / scale}%;">';
        },
      );
      
      print('[RTLHtmlTeletextViewer] HTML length after: ${scaledHtml.length}');
      print('[RTLHtmlTeletextViewer] Scale injected successfully');
      
      // Debug: mostra le prime 500 caratteri del body modificato
      final bodyIndex = scaledHtml.indexOf('<body');
      if (bodyIndex >= 0) {
        final bodyPreview = scaledHtml.substring(bodyIndex, bodyIndex + 200);
        print('[RTLHtmlTeletextViewer] Body tag: $bodyPreview');
      }
      
      return scaledHtml;
    }
    
    print('[RTLHtmlTeletextViewer] WARNING: <body> tag not found in HTML!');
    return html;
  }

  /// Aggiorna lo scaling del contenuto tramite JavaScript
  Future<void> _updateScaling(double scale) async {
    if (_controller == null) return;

    print('[RTLHtmlTeletextViewer] Applying uniform scale: $scale');

    try {
      await _controller!.runJavaScript('''
        (function() {
          console.log('Applying RTL Teletext uniform scaling: $scale');
          
          // Applica scaling uniforme al body
          document.body.style.transform = 'scale($scale)';
          document.body.style.transformOrigin = 'top left';
          document.body.style.width = '${100 / scale}%';
          document.body.style.height = '${100 / scale}%';
          
          console.log('RTL Teletext uniform scaling applied successfully');
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

