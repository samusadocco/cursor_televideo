import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

/// Widget per visualizzare pagine teletext in formato HTML (es. ARD)
/// 
/// Questo widget renderizza il contenuto HTML delle pagine teletext
/// che non usano immagini PNG (come ARD, ZDF, ecc.)
class HtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const HtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<HtmlTeletextViewer> createState() => _HtmlTeletextViewerState();
}

class _HtmlTeletextViewerState extends State<HtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _rawHtmlContent;  // Contenuto HTML grezzo estratto
  String? _rawCss;          // CSS estratto
  String? _errorMessage;
  double? _lastWidth;       // Ultima larghezza usata per generare HTML
  double? _lastHeight;      // Ultima altezza usata per generare HTML

  @override
  void initState() {
    super.initState();
    _extractContent();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Estrae il contenuto del div ardtext_classic (solo una volta)
  Future<void> _extractContent() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      print('[HtmlTeletextViewer] Fetching page: ${widget.page.imageUrl}');
      
      final response = await http.get(Uri.parse(widget.page.imageUrl));
      print('[HtmlTeletextViewer] Response status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      print('[HtmlTeletextViewer] Page fetched (${response.body.length} bytes), parsing HTML...');
      
      // Parse HTML
      final document = html_parser.parse(response.body);
      
      // Trova il div ardtext_classic
      final ardDiv = document.getElementById('ardtext_classic');
      if (ardDiv == null) {
        throw Exception('ardtext_classic div not found');
      }
      
      print('[HtmlTeletextViewer] Found ardtext_classic, innerHTML length: ${ardDiv.innerHtml.length}');
      
      if (ardDiv.innerHtml.isEmpty) {
        throw Exception('ardtext_classic div is empty');
      }
      
      // Converti percorsi immagini relativi in assoluti
      final baseUri = Uri.parse(widget.page.imageUrl);
      final baseUrl = '${baseUri.scheme}://${baseUri.host}';
      
      var htmlContent = ardDiv.innerHtml;
      
      // Regex per trovare src="./img/..." o src='./img/...'
      htmlContent = htmlContent.replaceAllMapped(
        RegExp(r'src="\./(img/[^"]+)"'),
        (match) => 'src="$baseUrl/${match.group(1)}"'
      );
      htmlContent = htmlContent.replaceAllMapped(
        RegExp(r"src='\./(img/[^']+)'"),
        (match) => "src='$baseUrl/${match.group(1)}'"
      );
      
      print('[HtmlTeletextViewer] Converted image paths');
      
      // Estrai i CSS inline dalla pagina originale (solo i tag <style>)
      final styleTags = document.querySelectorAll('style');
      final cssBuffer = StringBuffer();
      
      for (var style in styleTags) {
        final styleContent = style.innerHtml;
        if (styleContent.isNotEmpty) {
          cssBuffer.writeln(styleContent);
        }
      }
      
      print('[HtmlTeletextViewer] Extracted ${cssBuffer.length} chars of inline CSS');
      
      // Scarica SOLO il CSS principale per i colori (stylesheet_master_fira.css)
      final mainCssUrl = 'https://www.ard-text.de/classic_stylesheets/stylesheet_master_fira.css?t=1';
      try {
        print('[HtmlTeletextViewer] Downloading main CSS: $mainCssUrl');
        final cssResponse = await http.get(Uri.parse(mainCssUrl));
        if (cssResponse.statusCode == 200) {
          // Rimuovi tutti i riferimenti a font-family dal CSS
          var cssText = cssResponse.body;
          cssText = cssText.replaceAll(RegExp(r'font-family:[^;]+;'), '');
          cssText = cssText.replaceAll(RegExp(r'font-family:[^}]+}'), '}');
          cssBuffer.writeln(cssText);
          print('[HtmlTeletextViewer] Downloaded and cleaned main CSS (${cssText.length} bytes)');
        }
      } catch (e) {
        print('[HtmlTeletextViewer] Error downloading CSS: $e');
      }
      
      final inlineCSS = cssBuffer.toString();
      print('[HtmlTeletextViewer] Total CSS: ${inlineCSS.length} chars');
      
      // Salva i dati grezzi
      if (mounted) {
        setState(() {
          _rawHtmlContent = htmlContent;
          _rawCss = inlineCSS;
          _isLoading = false;
        });
      }
      
      print('[HtmlTeletextViewer] Content extracted successfully');
      
    } catch (e) {
      print('[HtmlTeletextViewer] Error extracting content: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Errore nel caricamento della pagina: $e';
          _isLoading = false;
        });
      }
    }
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
      font-family: 'Courier New', 'Courier', monospace !important;
    }
    html, body {
      background: #000 !important;
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      overflow: hidden;
      line-height: 1 !important;
      font-family: 'Courier New', 'Courier', monospace !important;
    }
    #content {
      padding: 0;
      background: #000 !important;
      line-height: 1 !important;
      font-family: 'Courier New', 'Courier', monospace !important;
      transform: scale($scaleX, $scaleY);
      transform-origin: top left;
      width: ${100 / scaleX}%;
      height: ${100 / scaleY}%;
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
    // Dimensioni native del contenuto ARD Teletext
    const nativeWidth = 390.0;
    const nativeHeight = 375.0;
    
    // Calcola scale factors
    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;
    
    print('[HtmlTeletextViewer] Widget size: ${width}x$height (real available space)');
    print('[HtmlTeletextViewer] Native content: ${nativeWidth}x$nativeHeight');
    print('[HtmlTeletextViewer] Calculated scales - X: $scaleX, Y: $scaleY');
    
    // Genera HTML con gli scale factors corretti
    final htmlContent = _buildHtmlWithScaling(scaleX, scaleY);
    
    if (_controller == null) {
      // Prima inizializzazione
      bool isFirstLoad = true;
      
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..addJavaScriptChannel(
          'LinkClicked',
          onMessageReceived: (JavaScriptMessage message) {
            print('[HtmlTeletextViewer] Link clicked: ${message.message}');
            _handleLinkNavigation(message.message);
          },
        )
        ..addJavaScriptChannel(
          'PageTapped',
          onMessageReceived: (JavaScriptMessage message) {
            print('[HtmlTeletextViewer] Page tapped');
            widget.onTap?.call();
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              print('[HtmlTeletextViewer] Page loaded');
              
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
              print('[HtmlTeletextViewer] Error: ${error.description}');
              if (mounted) {
                setState(() {
                  _errorMessage = 'Errore: ${error.description}';
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              print('[HtmlTeletextViewer] Navigation: ${request.url}');
              
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
      
      print('[HtmlTeletextViewer] WebView initialized');
    } else {
      // Controller già esistente, ricarica con nuovo HTML
      _controller!.loadHtmlString(htmlContent, baseUrl: widget.page.imageUrl);
      print('[HtmlTeletextViewer] WebView updated with new scaling');
    }
    
    // Salva le dimensioni correnti
    _lastWidth = width;
    _lastHeight = height;
  }

  /// Gestisce la navigazione da un link cliccato
  void _handleLinkNavigation(String href) {
    print('[HtmlTeletextViewer] Handling link: $href');
    
    // Estrai il numero di pagina dall'URL
    final pageMatch = RegExp(r'[?&]page=(\d+)').firstMatch(href);
    if (pageMatch != null) {
      final pageNumber = int.tryParse(pageMatch.group(1)!);
      if (pageNumber != null && widget.onPageNavigation != null) {
        print('[HtmlTeletextViewer] Navigate to page: $pageNumber');
        widget.onPageNavigation!(pageNumber);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
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
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
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
