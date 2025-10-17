import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Widget per visualizzare pagine ZDF Teletext
/// 
/// ZDF usa un formato HTML plain text, diverso da ARD che usa immagini.
/// Questo viewer estrae il contenuto testuale e lo visualizza con styling appropriato.
class ZDFTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const ZDFTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<ZDFTeletextViewer> createState() => _ZDFTeletextViewerState();
}

class _ZDFTeletextViewerState extends State<ZDFTeletextViewer> {
  WebViewController? _controller;
  String? _rawHtmlContent;
  bool _isLoading = true;
  double? _lastWidth;
  double? _lastHeight;

  @override
  void initState() {
    super.initState();
    _extractContent();
  }

  @override
  void didUpdateWidget(ZDFTeletextViewer oldWidget) {
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

      print('[ZDFTeletextViewer] Using pre-fetched HTML content');
      
      // ZDF: l'HTML è già completo e pronto per la visualizzazione
      // Lo prendiamo direttamente dal TelevideoPage
      if (widget.page.htmlContent != null) {
        _rawHtmlContent = widget.page.htmlContent!;
        
        print('[ZDFTeletextViewer] HTML content length: ${_rawHtmlContent?.length ?? 0}');
        
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
      print('[ZDFTeletextViewer] Error loading content: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Inizializza o aggiorna il WebView con scaling dinamico
  void _initializeOrUpdateWebView(double width, double height) {
    // Dimensioni native del contenuto ZDF Teletext
    const nativeWidth = 492.0;
    const nativeHeight = 489.0;
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[ZDFTeletextViewer] Widget size: ${width}x$height (real available space)');
    print('[ZDFTeletextViewer] Native content: ${nativeWidth}x$nativeHeight');
    print('[ZDFTeletextViewer] Calculated scales - X: $scaleX, Y: $scaleY');
    
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
          print('[ZDFTeletextViewer] PageNavigation received: $pageNumber');
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
            print('[ZDFTeletextViewer] Page loaded');
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadHtmlString(_buildHtmlString(scaleX, scaleY));

      print('[ZDFTeletextViewer] WebView initialized');
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Aggiorna solo l'HTML con i nuovi scale factors
      _controller!.loadHtmlString(_buildHtmlString(scaleX, scaleY));
      print('[ZDFTeletextViewer] WebView updated with new scaling');
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
        print('[ZDFTeletextViewer] Converting CSS path: $relativePath -> $absolutePath');
        return 'href="$absolutePath"';
      },
    );
    
    // Converti font relativi in assoluti (nei CSS inline)
    html = html.replaceAllMapped(
      RegExp(r'url\((?!["\x27]?(?:http|data:))([^)]+)\)'),
      (match) {
        final relativePath = match.group(1)!.replaceAll(RegExp(r'["\x27]'), '');
        final absolutePath = _makeAbsoluteUrl(relativePath);
        print('[ZDFTeletextViewer] Converting font path: $relativePath -> $absolutePath');
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
    final htmlWithScaling = html.replaceFirst(
      '</head>',
      '''
  <style>
    /* Scaling dinamico per adattare il contenuto */
    body {
      transform: scale($scaleX, $scaleY);
      transform-origin: top left;
      width: ${100 / scaleX}%;
      height: ${100 / scaleY}%;
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
          // Estrai numero pagina dal link
          const match = href.match(/(?:klassisch\\/)?(\\d+)(?:_\\d+)?\\.html/);
          if (match) {
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

