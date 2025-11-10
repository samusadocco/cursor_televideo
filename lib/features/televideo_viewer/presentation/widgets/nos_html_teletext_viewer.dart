import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Widget per visualizzare pagine NOS Teletekst
/// 
/// NOS usa un formato HTML simile a ZDF.
/// Questo viewer estrae il contenuto testuale e lo visualizza con styling appropriato.
class NOSHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const NOSHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<NOSHtmlTeletextViewer> createState() => _NOSHtmlTeletextViewerState();
}

class _NOSHtmlTeletextViewerState extends State<NOSHtmlTeletextViewer> {
  WebViewController? _controller;
  String? _rawHtmlContent;
  bool _isLoading = true;
  double? _lastWidth;
  double? _lastHeight;
  
  // Dimensioni native per NOS (ridotte ulteriormente per maggiore ingrandimento)
  double _nativeWidth = 390.0;
  double _nativeHeight = 500.0;

  @override
  void initState() {
    super.initState();
    _extractContent();
  }

  @override
  void didUpdateWidget(NOSHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.imageUrl != widget.page.imageUrl ||
        oldWidget.page.subPage != widget.page.subPage) {
      _extractContent();
    }
  }

  /// Estrae il contenuto HTML dalla pagina ZDF
  Future<void> _extractContent() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('[NOSHtmlTeletextViewer] Using pre-fetched HTML content');
      
      // ZDF: l'HTML è già completo e pronto per la visualizzazione
      // Lo prendiamo direttamente dal TelevideoPage
      if (widget.page.htmlContent != null) {
        _rawHtmlContent = widget.page.htmlContent!;
        
        print('[NOSHtmlTeletextViewer] HTML content length: ${_rawHtmlContent?.length ?? 0}');
        
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
      print('[NOSHtmlTeletextViewer] Error loading content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Inizializza o aggiorna il WebView con scaling dinamico
  void _initializeOrUpdateWebView(double width, double height) {
    // NOS Teletekst - dimensioni native adattive in base al dispositivo
    // Calcoliamo le dimensioni native in base all'aspect ratio disponibile
    final aspectRatio = width / height;
    
    if (aspectRatio > 1.5) {
      // iPad orizzontale o dispositivo molto largo
      // Usa dimensioni native più grandi per evitare ingrandimento eccessivo
      _nativeWidth = 480.0;
      _nativeHeight = 600.0;
      print('[NOSHtmlTeletextViewer] Mode: iPad landscape (wide)');
    } else if (aspectRatio > 0.7) {
      // iPad verticale o tablet
      _nativeWidth = 480.0;
      _nativeHeight = 600.0;
      print('[NOSHtmlTeletextViewer] Mode: iPad portrait (medium)');
    } else {
      // iPhone o dispositivo stretto
      _nativeWidth = 360.0;
      _nativeHeight = 460.0;
      print('[NOSHtmlTeletextViewer] Mode: iPhone (narrow)');
    }
    
    // Calcola scale factors
    final scaleX = width / _nativeWidth;
    final scaleY = height / _nativeHeight;
    
    print('[NOSHtmlTeletextViewer] Widget size: ${width}x$height (aspect: ${aspectRatio.toStringAsFixed(2)})');
    print('[NOSHtmlTeletextViewer] Native content: ${_nativeWidth}x$_nativeHeight');
    print('[NOSHtmlTeletextViewer] Calculated scales - X: $scaleX, Y: $scaleY');
    
    // Salva le dimensioni correnti
    _lastWidth = width;
    _lastHeight = height;
    
    if (_controller == null) {
      // Prima inizializzazione
      _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'PageNavigation',
        onMessageReceived: (JavaScriptMessage message) {
          final pageNumber = int.tryParse(message.message);
          print('[NOSHtmlTeletextViewer] PageNavigation received: $pageNumber');
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
      ..addJavaScriptChannel(
        'DebugLog',
        onMessageReceived: (JavaScriptMessage message) {
          print('[WebView JS] ${message.message}');
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            print('[NOSHtmlTeletextViewer] Page loaded');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadHtmlString(_buildHtmlString(scaleX, scaleY));

      print('[NOSHtmlTeletextViewer] WebView initialized');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Aggiorna solo l'HTML con i nuovi scale factors
      _controller!.loadHtmlString(_buildHtmlString(scaleX, scaleY));
      print('[NOSHtmlTeletextViewer] WebView updated with new scaling');
    }
  }

  /// Costruisce la stringa HTML completa per il WebView con scaling
  String _buildHtmlString(double scaleX, double scaleY) {
    // ZDF fornisce HTML completo, ma dobbiamo convertire i percorsi relativi in assoluti
    // per CSS, font e immagini
    var html = _rawHtmlContent!;
    
    // Converti link CSS relativi in assoluti
    html = html.replaceAllMapped(
      RegExp(r'href="(?!http)([^"]+\.css[^"]*)"'),
      (match) {
        final relativePath = match.group(1)!;
        final absolutePath = _makeAbsoluteUrl(relativePath);
        print('[NOSHtmlTeletextViewer] Converting CSS path: $relativePath -> $absolutePath');
        return 'href="$absolutePath"';
      },
    );
    
    // Converti font relativi in assoluti (nei CSS inline)
    html = html.replaceAllMapped(
      RegExp(r'url\((?!["\x27]?(?:http|data:))([^)]+)\)'),
      (match) {
        final relativePath = match.group(1)!.replaceAll(RegExp(r'["\x27]'), '');
        final absolutePath = _makeAbsoluteUrl(relativePath);
        print('[NOSHtmlTeletextViewer] Converting font path: $relativePath -> $absolutePath');
        return 'url("$absolutePath")';
      },
    );
    
    // Converti immagini relative in assolute
    html = html.replaceAllMapped(
      RegExp(r'src="(?!http)([^"]+)"'),
      (match) {
        final relativePath = match.group(1)!;
        final absolutePath = _makeAbsoluteUrl(relativePath);
        return 'src="$absolutePath"';
      },
    );
    
    // Inserisci CSS per lo scaling prima di </head>
    // Approccio semplice come ZDF
    final htmlWithScaling = html.replaceFirst(
      '</head>',
      '''
  <style id="nos-teletext-override">
    /* Styling base per lo scaling (come ZDF) */
    body {
      margin: 0 !important;
      padding: 0 !important;
      overflow: hidden !important;
      background: black !important;
      transform: scale($scaleX, $scaleY) !important;
      transform-origin: top left !important;
      width: ${_nativeWidth}px !important;
      height: ${_nativeHeight}px !important;
    }
  </style>
</head>
''',
    );
    
    // Inseriamo gli script JS alla fine del body
    final htmlWithScripts = htmlWithScaling.replaceFirst(
      '</body>',
      '''
  <script>
    // Intercetta click su link
    document.addEventListener('click', function(e) {
      if (e.target.tagName === 'A') {
        e.preventDefault();
        const href = e.target.getAttribute('href');
        if (href) {
          // Pattern per ZDF: klassisch/123.html o 123.html
          let match = href.match(/(?:klassisch\\/)?(\\d+)(?:_\\d+)?\\.html/);
          
          // Pattern per NOS: /teletekst/123
          if (!match) {
            match = href.match(/\\/teletekst\\/(\\d+)/);
          }
          
          if (match) {
            console.log('[TeletextViewer] Click on link to page: ' + match[1]);
            PageNavigation.postMessage(match[1]);
          }
        }
        return false;
      }
      
      // Click fuori dai link per play/pause
      PageTapped.postMessage('tap');
    });
    
    // Disabilita zoom con gesture
    document.addEventListener('touchmove', function(e) {
      if (e.touches.length > 1) {
        e.preventDefault();
      }
    }, { passive: false });
  </script>
</body>
''',
    );
    
    return htmlWithScripts;
  }
  
  /// Converte un percorso relativo in assoluto per ZDF
  String _makeAbsoluteUrl(String relativePath) {
    const baseUrl = 'https://teletext.zdf.de';
    
    // Se inizia con /, è già assoluto relativo al dominio
    if (relativePath.startsWith('/')) {
      return '$baseUrl$relativePath';
    }
    
    // Altrimenti è relativo alla cartella corrente
    // Assumi che siamo in /teletext/zdf/seiten/klassisch/
    return '$baseUrl/teletext/zdf/seiten/klassisch/$relativePath';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _rawHtmlContent == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    // Usa LayoutBuilder per ottenere le dimensioni reali disponibili
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        
        // Inizializza o aggiorna il WebView se le dimensioni sono cambiate
        if (_controller == null || _lastWidth != width || _lastHeight != height) {
          // Usa addPostFrameCallback per evitare di chiamare setState durante il build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _initializeOrUpdateWebView(width, height);
            }
          });
        }
        
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
          child: WebViewWidget(controller: _controller!),
        );
      },
    );
  }
}

