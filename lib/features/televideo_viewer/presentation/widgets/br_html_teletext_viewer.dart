import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/core/debug/debug_logger.dart';

/// Widget per visualizzare pagine BR Teletext (Bayerischer Rundfunk) in formato HTML
/// 
/// Questo widget renderizza il contenuto HTML delle pagine BR teletext,
/// simile ad ARD ma con container bayerntext_container
class BRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const BRHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<BRHtmlTeletextViewer> createState() => _BRHtmlTeletextViewerState();
}

class _BRHtmlTeletextViewerState extends State<BRHtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _rawHtmlContent;  // Contenuto HTML grezzo estratto
  String? _rawCss;          // CSS estratto
  String? _errorMessage;
  double? _lastWidth;       // Ultima larghezza usata per generare HTML
  double? _lastHeight;      // Ultima altezza usata per generare HTML
  
  // Cache statica per i CSS esterni (condivisa tra tutte le istanze)
  static final Map<String, String> _cssCache = {};

  @override
  void initState() {
    super.initState();
    final logger = DebugLogger();
    logger.log('BR', 'initState - page: ${widget.page.pageNumber}_${widget.page.subPage}, URL: ${widget.page.imageUrl}');
    _extractContent();
  }

  @override
  void didUpdateWidget(BRHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final logger = DebugLogger();
    // Ricarica il contenuto se la pagina o la sottopagina sono cambiate
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      logger.log('BR', 'didUpdateWidget - OLD: ${oldWidget.page.pageNumber}_${oldWidget.page.subPage}, NEW: ${widget.page.pageNumber}_${widget.page.subPage}');
      logger.log('BR', 'didUpdateWidget - OLD URL: ${oldWidget.page.imageUrl}');
      logger.log('BR', 'didUpdateWidget - NEW URL: ${widget.page.imageUrl}');
      logger.log('BR', 'didUpdateWidget - _rawHtmlContent: ${_rawHtmlContent != null ? "EXISTS (${_rawHtmlContent!.length} chars)" : "NULL"}');
      logger.log('BR', 'didUpdateWidget - _controller: ${_controller != null ? "EXISTS" : "NULL"}');
      
      print('[BRHtmlTeletextViewer] Page changed, reloading content');
      // IMPORTANTE: Setta _isLoading = true PRIMA di chiamare _extractContent
      // per bloccare il build() dal creare il WebView con il vecchio contenuto
      setState(() {
        _isLoading = true;
      });
      logger.log('BR', 'didUpdateWidget - _isLoading set to TRUE');
      // Resetta le dimensioni per forzare il reload del WebView
      _lastWidth = null;
      _lastHeight = null;
      // Ricarica il contenuto
      _extractContent();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Estrae il contenuto del div bayerntext_container (solo una volta)
  Future<void> _extractContent() async {
    final logger = DebugLogger();
    logger.log('BR', '_extractContent START - page: ${widget.page.pageNumber}_${widget.page.subPage}');
    logger.log('BR', '_extractContent - URL: ${widget.page.imageUrl}');
    logger.log('BR', '_extractContent - mounted: $mounted');
    
    if (!mounted) {
      logger.log('BR', '_extractContent ABORTED - not mounted');
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    logger.log('BR', '_extractContent - setState completed, _isLoading = true');
    
    try {
      print('[BRHtmlTeletextViewer] Fetching page: ${widget.page.imageUrl}');
      logger.log('BR', '_extractContent - Starting HTTP GET');
      
      final response = await http.get(Uri.parse(widget.page.imageUrl));
      print('[BRHtmlTeletextViewer] Response status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      // Decodifica esplicitamente come UTF-8 per supportare caratteri speciali tedeschi (ä, ö, ü, ß)
      final htmlString = utf8.decode(response.bodyBytes);
      print('[BRHtmlTeletextViewer] Page fetched (${htmlString.length} bytes), parsing HTML...');
      
      // Parse HTML
      final document = html_parser.parse(htmlString);
      
      // Trova il div seite_X dove X è il numero della sottopagina
      final subPage = widget.page.subPage;
      final containerId = 'seite_$subPage';
      final brDiv = document.getElementById(containerId);
      
      if (brDiv == null) {
        print('[BRHtmlTeletextViewer] ERROR: $containerId not found');
        print('[BRHtmlTeletextViewer] Available IDs: ${document.querySelectorAll('[id]').map((e) => e.id).join(", ")}');
        throw Exception('$containerId div not found');
      }
      
      print('[BRHtmlTeletextViewer] Found $containerId, innerHTML length: ${brDiv.innerHtml.length}');
      
      if (brDiv.innerHtml.isEmpty) {
        throw Exception('$containerId div is empty');
      }
      
      await _processContent(brDiv, htmlString);
      
      logger.log('BR', '_extractContent COMPLETED - _rawHtmlContent: ${_rawHtmlContent?.length ?? 0} chars, _rawCss: ${_rawCss?.length ?? 0} chars');
      logger.log('BR', '_extractContent - _isLoading: $_isLoading');
      
    } catch (e) {
      print('[BRHtmlTeletextViewer] Error extracting content: $e');
      logger.log('BR', '_extractContent ERROR: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Errore nel caricamento della pagina: $e';
          _isLoading = false;
        });
        logger.log('BR', '_extractContent - Error setState completed');
      }
    }
  }

  /// Processa il contenuto del div trovato
  Future<void> _processContent(element, String htmlString) async {
    // Converti percorsi immagini relativi in assoluti
    final baseUri = Uri.parse(widget.page.imageUrl);
    final baseUrl = '${baseUri.scheme}://${baseUri.host}';
    
    var htmlContent = element.innerHtml;
    
    // Regex per trovare src="./img/..." o src='./img/...'  
    htmlContent = htmlContent.replaceAllMapped(
      RegExp(r'src="\./(img/[^"]+)"'),
      (match) => 'src="$baseUrl/${match.group(1)}"'
    );
    htmlContent = htmlContent.replaceAllMapped(
      RegExp(r"src='\./(img/[^']+)'"),
      (match) => "src='$baseUrl/${match.group(1)}'"
    );
    
    // Converti anche percorsi relativi senza ./
    htmlContent = htmlContent.replaceAllMapped(
      RegExp(r'src="(?!http)([^"]+)"'),
      (match) {
        final src = match.group(1)!;
        if (src.startsWith('/')) {
          return 'src="$baseUrl$src"';
        } else {
          return 'src="$baseUrl/$src"';
        }
      }
    );
    
    print('[BRHtmlTeletextViewer] Converted image paths');
    
    // Wrappa ogni immagine GIF in uno span con larghezza fissa per allineamento perfetto
    htmlContent = htmlContent.replaceAllMapped(
      RegExp(r'<img src="[^"]+\.gif"[^>]*>'),
      (match) => '<span style="width:10px;display:inline-block;margin:0;padding:0;border:0;outline:0;vertical-align:top;">${match.group(0)}</span>'
    );
    
    print('[BRHtmlTeletextViewer] Wrapped GIF images in fixed-width spans');
    
    // Estrai i CSS inline dalla pagina originale (solo i tag <style>)
    final document = html_parser.parse(htmlString);
    final styleTags = document.querySelectorAll('style');
    final cssBuffer = StringBuffer();
    
    for (var style in styleTags) {
      final styleContent = style.innerHtml;
      if (styleContent.isNotEmpty) {
        cssBuffer.writeln(styleContent);
      }
    }
    
    print('[BRHtmlTeletextViewer] Extracted ${cssBuffer.length} chars of inline CSS');
    
    // Scarica i CSS esterni (con cache)
    final linkTags = document.querySelectorAll('link[rel="stylesheet"]');
    int cachedCount = 0;
    int downloadedCount = 0;
    
    for (var link in linkTags) {
      final href = link.attributes['href'];
      if (href != null && href.isNotEmpty) {
        try {
          final cssUrl = href.startsWith('http') 
            ? href 
            : (href.startsWith('/') ? '$baseUrl$href' : '$baseUrl/$href');
          
          // Controlla se il CSS è già in cache
          if (_cssCache.containsKey(cssUrl)) {
            cssBuffer.writeln(_cssCache[cssUrl]!);
            cachedCount++;
            print('[BRHtmlTeletextViewer] ✓ CSS from cache: $cssUrl');
          } else {
            // Scarica il CSS e salvalo in cache
            print('[BRHtmlTeletextViewer] ⬇ Downloading CSS: $cssUrl');
            final cssResponse = await http.get(Uri.parse(cssUrl));
            if (cssResponse.statusCode == 200) {
              // Decodifica come UTF-8 per supportare eventuali caratteri speciali
              final cssBody = utf8.decode(cssResponse.bodyBytes);
              final cssContent = '/* External CSS from $cssUrl */\n$cssBody\n';
              _cssCache[cssUrl] = cssContent;
              cssBuffer.writeln(cssContent);
              downloadedCount++;
              print('[BRHtmlTeletextViewer] ✓ Downloaded and cached CSS: ${cssBody.length} bytes');
            } else {
              print('[BRHtmlTeletextViewer] ✗ Failed to download CSS: ${cssResponse.statusCode}');
            }
          }
        } catch (e) {
          print('[BRHtmlTeletextViewer] ✗ Error with CSS $href: $e');
        }
      }
    }
    
    final inlineCSS = cssBuffer.toString();
    print('[BRHtmlTeletextViewer] CSS summary - Cached: $cachedCount, Downloaded: $downloadedCount, Total size: ${inlineCSS.length} chars');
    
    // Salva i dati grezzi
    if (mounted) {
      setState(() {
        _rawHtmlContent = htmlContent;
        _rawCss = inlineCSS;
        _isLoading = false;
      });
    }
    
    print('[BRHtmlTeletextViewer] Content extracted successfully');
  }

  /// Genera l'HTML finale con gli scale factors appropriati
  String _buildHtmlWithScaling(double scaleX, double scaleY) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <style>
    /* CSS inline dalla pagina originale (per i colori) */
    $_rawCss
    
    /* Override per forzare sfondo nero, font monospace e allineamento perfetto */
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
    #content {
      padding: 0;
      background: #000 !important;
      line-height: 1 !important;
      transform: scale($scaleX, $scaleY);
      transform-origin: top left;
      width: ${100 / scaleX}%;
      height: ${100 / scaleY}%;
    }
    /* Forza Courier New SOLO sul testo (fallback per font CORS bloccati) */
    #content, #content span, #content nobr, #content a {
      font-family: 'Courier New', 'Courier', monospace !important;
    }
    /* Forza tutte le immagini alla stessa dimensione e rimuovi spacing */
    img {
      display: inline-block !important;
      vertical-align: top !important;
      margin: 0 !important;
      padding: 0 !important;
      border: 0 !important;
      line-height: 1 !important;
    }
    /* Fix per eliminare righe verticali negli elementi inline-block con width 10px */
    span[style*="width:10px"][style*="display:inline-block"] {
      font-size: 0;
      line-height: 0;
    }
    span[style*="width:10px"][style*="display:inline-block"] img {
      display: block;
      width: 10px;
      height: auto;
    }
    /* Rimuovi spacing da nobr e span */
    nobr {
      margin: 0 !important;
      padding: 0 !important;
      line-height: 1 !important;
      display: inline !important;
      white-space: nowrap !important;
    }
    span {
      margin: 0 !important;
      padding: 0 !important;
      line-height: 1 !important;
      display: inline-block !important;
      vertical-align: top !important;
      box-sizing: border-box !important;
      overflow: hidden !important;
      min-height: 1em !important;
    }
    /* Forza i div a non avere spacing */
    div {
      margin: 0 !important;
      padding: 0 !important;
      line-height: 1 !important;
    }
    /* Forza altezza fissa per i div interni (le righe) */
    #content > div > div {
      height: 15px !important;
      line-height: 15px !important;
    }
  </style>
</head>
<body>
  <div id="content">
    $_rawHtmlContent
  </div>
</body>
</html>
''';
  }

  /// Inizializza o aggiorna il WebViewController con l'HTML scalato
  void _initializeOrUpdateWebView(double width, double height) {
    final logger = DebugLogger();
    logger.log('BR', '_initializeOrUpdateWebView START - size: ${width}x$height');
    logger.log('BR', '_initializeOrUpdateWebView - _controller: ${_controller != null ? "EXISTS" : "NULL"}');
    logger.log('BR', '_initializeOrUpdateWebView - _rawHtmlContent: ${_rawHtmlContent?.length ?? 0} chars');
    logger.log('BR', '_initializeOrUpdateWebView - page URL: ${widget.page.imageUrl}');
    
    // Dimensioni native del contenuto BR Teletext
    // BR usa un layout più compatto, ridotte rispetto ad ARD per maggiore scaling
    const nativeWidth = 450.0;  // Ridotto per aumentare lo scaling
    const nativeHeight = 350.0; // Aumentato per coprire tutto il contenuto verticale
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[BRHtmlTeletextViewer] Widget size: ${width}x$height (real available space)');
    print('[BRHtmlTeletextViewer] Native content: ${nativeWidth}x$nativeHeight');
    print('[BRHtmlTeletextViewer] Calculated scales - X: $scaleX, Y: $scaleY');
    logger.log('BR', '_initializeOrUpdateWebView - scales: X=$scaleX, Y=$scaleY');
    
    // Genera HTML con gli scale factors corretti
    final htmlContent = _buildHtmlWithScaling(scaleX, scaleY);
    logger.log('BR', '_initializeOrUpdateWebView - htmlContent generated: ${htmlContent.length} chars');
    
    if (_controller == null) {
      // Prima inizializzazione
      bool isFirstLoad = true;
      
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..addJavaScriptChannel(
          'LinkClicked',
          onMessageReceived: (JavaScriptMessage message) {
            print('[BRHtmlTeletextViewer] Link clicked: ${message.message}');
            _handleLinkNavigation(message.message);
          },
        )
        ..addJavaScriptChannel(
          'PageTapped',
          onMessageReceived: (JavaScriptMessage message) {
            print('[BRHtmlTeletextViewer] Page tapped');
            widget.onTap?.call();
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              print('[BRHtmlTeletextViewer] Page loaded');
              
              // Intercetta i click sui link e i tap sulla pagina
              final javascript = '''
                // Intercetta click sui link
                var linkClicked = false;
                document.querySelectorAll('a').forEach(function(link) {
                  link.addEventListener('click', function(e) {
                    e.preventDefault();
                    linkClicked = true;
                    const href = this.getAttribute('href');
                    if (href && LinkClicked) {
                      LinkClicked.postMessage(href);
                    }
                    setTimeout(function() { linkClicked = false; }, 100);
                  });
                });
                
                // Intercetta tap sulla pagina (fuori dai link) per play/pause
                document.addEventListener('click', function(e) {
                  setTimeout(function() {
                    if (!linkClicked && PageTapped) {
                      PageTapped.postMessage('tap');
                    }
                  }, 50);
                });
              ''';
              
              _controller!.runJavaScript(javascript);
              
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              print('[BRHtmlTeletextViewer] Error: ${error.description}');
              if (mounted) {
                setState(() {
                  _errorMessage = 'Errore: ${error.description}';
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              print('[BRHtmlTeletextViewer] Navigation: ${request.url}');
              
              // Permetti il primo caricamento
              if (isFirstLoad) {
                isFirstLoad = false;
                return NavigationDecision.navigate;
              }
              
              // Blocca tutte le altre navigazioni
              return NavigationDecision.prevent;
            },
          ),
        )
        ..loadHtmlString(htmlContent, baseUrl: widget.page.imageUrl);
      
      print('[BRHtmlTeletextViewer] WebView initialized');
      print('[BRHtmlTeletextViewer] → Loaded page: ${widget.page.pageNumber}_${widget.page.subPage}');
      print('[BRHtmlTeletextViewer] → baseUrl: ${widget.page.imageUrl}');
      print('[BRHtmlTeletextViewer] → HTML length: ${htmlContent.length}');
      print('[BRHtmlTeletextViewer] → _rawHtmlContent length: ${_rawHtmlContent?.length ?? 0}');
      logger.log('BR', '_initializeOrUpdateWebView - NEW controller created and loaded');
    } else {
      // Controller già esistente, ricarica con nuovo HTML
      print('[BRHtmlTeletextViewer] WebView updated with new scaling');
      print('[BRHtmlTeletextViewer] → Page should be: ${widget.page.pageNumber}_${widget.page.subPage}');
      print('[BRHtmlTeletextViewer] → baseUrl: ${widget.page.imageUrl}');
      print('[BRHtmlTeletextViewer] → HTML length: ${htmlContent.length}');
      print('[BRHtmlTeletextViewer] → _rawHtmlContent length: ${_rawHtmlContent?.length ?? 0}');
      print('[BRHtmlTeletextViewer] → _rawHtmlContent preview: ${_rawHtmlContent?.substring(0, 100) ?? "NULL"}');
      logger.log('BR', '_initializeOrUpdateWebView - REUSING existing controller, reloading HTML');
      _controller!.loadHtmlString(htmlContent, baseUrl: widget.page.imageUrl);
      logger.log('BR', '_initializeOrUpdateWebView - HTML reloaded in existing controller');
    }
    
    // Salva le dimensioni correnti
    _lastWidth = width;
    _lastHeight = height;
    logger.log('BR', '_initializeOrUpdateWebView COMPLETED');
  }

  /// Gestisce la navigazione da un link cliccato
  void _handleLinkNavigation(String href) {
    print('[BRHtmlTeletextViewer] Handling link: $href');
    
    // Estrai il numero di pagina dall'URL BR: vtxpage=123_1
    final pageMatch = RegExp(r'[?&]vtxpage=(\d+)').firstMatch(href);
    if (pageMatch != null) {
      final pageNumber = int.tryParse(pageMatch.group(1)!);
      if (pageNumber != null && widget.onPageNavigation != null) {
        print('[BRHtmlTeletextViewer] Navigate to page: $pageNumber');
        widget.onPageNavigation!(pageNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = DebugLogger();
    logger.log('BR', 'build() START - _isLoading: $_isLoading, _rawHtmlContent: ${_rawHtmlContent != null ? "${_rawHtmlContent!.length} chars" : "NULL"}, _controller: ${_controller != null ? "EXISTS" : "NULL"}');
    
    if (_errorMessage != null) {
      logger.log('BR', 'build() RETURN - ERROR MESSAGE');
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _errorMessage = null;
                      _isLoading = true;
                    });
                  }
                  _extractContent();
                },
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading || _rawHtmlContent == null || _rawCss == null) {
      logger.log('BR', 'build() RETURN - SPINNER (loading or content not ready)');
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    logger.log('BR', 'build() - Content ready, entering LayoutBuilder');
    // Usa LayoutBuilder per ottenere le dimensioni reali disponibili
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        logger.log('BR', 'build.LayoutBuilder - constraints: ${width}x$height');
        
        // Inizializza o aggiorna il WebView se le dimensioni sono cambiate SIGNIFICATIVAMENTE
        // Ignora piccoli cambi (< 20px) causati dall'UI che si assesta (es. ad banner)
        final bool needsUpdate = _controller == null ||
            _lastWidth == null || 
            _lastHeight == null ||
            (width - (_lastWidth ?? 0)).abs() > 20 ||
            (height - (_lastHeight ?? 0)).abs() > 20;
            
        if (needsUpdate) {
          print('[BRHtmlTeletextViewer] Dimensions changed significantly, updating WebView');
          print('[BRHtmlTeletextViewer] Old: ${_lastWidth}x$_lastHeight, New: ${width}x$height');
          logger.log('BR', 'build.LayoutBuilder - Need WebView init/update (_controller: ${_controller != null ? "EXISTS" : "NULL"}, _lastWidth: $_lastWidth, _lastHeight: $_lastHeight)');
          // Usa addPostFrameCallback per evitare di chiamare setState durante il build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              logger.log('BR', 'build.PostFrameCallback - Calling _initializeOrUpdateWebView');
              _initializeOrUpdateWebView(width, height);
            }
          });
        } else {
          print('[BRHtmlTeletextViewer] Ignoring small dimension change: ${_lastWidth}x$_lastHeight -> ${width}x$height');
        }
        
        if (_controller == null) {
          logger.log('BR', 'build.LayoutBuilder RETURN - SPINNER (controller null, waiting for PostFrameCallback)');
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        
        logger.log('BR', 'build.LayoutBuilder RETURN - WebViewWidget with controller');
        return Container(
          color: Colors.black,
          child: WebViewWidget(controller: _controller!),
        );
      },
    );
  }
}

