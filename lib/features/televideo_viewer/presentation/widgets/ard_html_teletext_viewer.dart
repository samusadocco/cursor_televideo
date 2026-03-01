import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/core/debug/debug_logger.dart';

/// Widget per visualizzare pagine ARD Teletext in formato HTML
///
/// Estrae il div #ardtext_classic dalla pagina ARD e lo renderizza
/// in un WebView con CSS che preserva font e colori originali.
class ARDHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int pageNumber)? onPageNavigation;
  final VoidCallback? onTap;

  const ARDHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageNavigation,
    this.onTap,
  });

  @override
  State<ARDHtmlTeletextViewer> createState() => _ARDHtmlTeletextViewerState();
}

class _ARDHtmlTeletextViewerState extends State<ARDHtmlTeletextViewer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _rawHtmlContent;
  String? _rawCss;
  String? _errorMessage;
  double? _lastWidth;
  double? _lastHeight;

  @override
  void initState() {
    super.initState();
    DebugLogger().log('ARD', 'initState - page: ${widget.page.pageNumber}_${widget.page.subPage}');
    _extractContent();
  }

  @override
  void didUpdateWidget(ARDHtmlTeletextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage) {
      setState(() {
        _isLoading = true;
        _lastWidth = null;
        _lastHeight = null;
      });
      _extractContent();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _extractContent() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(widget.page.imageUrl));
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final document = html_parser.parse(response.body);
      final ardDiv = document.getElementById('ardtext_classic');
      if (ardDiv == null) {
        throw Exception('ardtext_classic div not found');
      }

      final baseUri = Uri.parse(widget.page.imageUrl);
      final baseUrl = '${baseUri.scheme}://${baseUri.host}';

      // Converti percorsi immagini relativi in assoluti (sia " che ')
      var htmlContent = ardDiv.innerHtml;
      htmlContent = htmlContent.replaceAllMapped(
        RegExp(r'src="\./(img/[^"]+)"'),
        (m) => 'src="$baseUrl/${m.group(1)}"',
      );
      htmlContent = htmlContent.replaceAllMapped(
        RegExp(r"src='\./(img/[^']+)'"),
        (m) => "src='$baseUrl/${m.group(1)}'",
      );

      // Scarica il CSS principale ARD (colori e font)
      final cssBuffer = StringBuffer();
      try {
        final cssResponse = await http.get(
          Uri.parse('https://www.ard-text.de/classic_stylesheets/stylesheet_master_fira.css?t=1'),
        );
        if (cssResponse.statusCode == 200) {
          // Rimuovi font-face (non caricabili per CORS) ma mantieni colori
          var css = cssResponse.body;
          css = css.replaceAll(RegExp(r'@font-face\s*\{[^}]+\}'), '');
          cssBuffer.write(css);
        }
      } catch (e) {
        print('[ARDViewer] CSS download error: $e');
      }

      if (mounted) {
        setState(() {
          _rawHtmlContent = htmlContent;
          _rawCss = cssBuffer.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[ARDViewer] Error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Errore caricamento: $e';
          _isLoading = false;
        });
      }
    }
  }

  String _buildHtml(double scaleX, double scaleY) {
    return '''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
  <style>
    /* CSS ARD originale: colori span (bgb, bgw, fgw, ecc.) */
    $_rawCss

    /* ── Reset base ── */
    *, *::before, *::after { box-sizing: border-box; }
    html, body {
      margin: 0; padding: 0;
      width: 100%; height: 100%;
      background: #000;
      overflow: hidden;
    }

    /* ── Contenuto scalato ── */
    #content {
      margin: 0; padding: 0;
      background: #000;
      font-family: 'Fira Mono', 'Courier New', monospace;
      font-size: 10px;
      line-height: 16px;
      transform: scale($scaleX, $scaleY);
      transform-origin: top left;
      width: 390px;
      height: 400px;
    }

    /* ── Fira Mono via ARD server (stessa origine, bypassa CORS) ── */
    @font-face {
      font-family: 'Fira Mono';
      src: url('https://www.ard-text.de/fira/ttf/FiraMono-Regular.ttf') format('truetype');
      font-weight: 400;
      font-style: normal;
    }

    /* ── Immagini GIF: 9×16px, non ridimensionare ── */
    img {
      display: inline;
      vertical-align: top;
      width: 9px !important;
      height: 16px !important;
      margin: 0; padding: 0; border: 0;
    }

    /* ── Span: font-size 13px + letter-spacing 2.2px = 10px/char (come ARD originale).
       Il CSS ARD usa #ardtext_classic span, ma il contenuto è in #content,
       quindi quei selettori non si applicano. Li reimpostiamo qui esplicitamente.
       Fira Mono 13px ≈ 7.8px char + 2.2px spacing = 10px → corrisponde ai
       width inline-style degli span (10px, 20px, ..., 380px). ── */
    span {
      display: inline-block;
      vertical-align: top;
      margin: 0; padding: 0;
      font-size: 13px !important;
      letter-spacing: 2.2px !important;
      line-height: 16px !important;
    }

    nobr {
      display: inline;
      white-space: nowrap;
      margin: 0; padding: 0;
    }

    a { margin: 0; padding: 0; text-decoration: none; }

    div { margin: 0; padding: 0; }

    /* ── Ogni riga = 16px (altezza GIF) ── */
    #content > div > div {
      height: 16px;
      line-height: 16px;
      overflow: visible;
      /* font-size:0 elimina i gap whitespace tra inline-block span
         (il parser Dart può inserire spazi/newline tra </span><span>) */
      font-size: 0;
      white-space: nowrap;
    }
  </style>
</head>
<body>
  <div id="content">
    $_rawHtmlContent
  </div>
  <script>
    // Intercetta click sui link teletext
    var lastLink = false;
    document.querySelectorAll('a').forEach(function(a) {
      a.addEventListener('click', function(e) {
        e.preventDefault();
        lastLink = true;
        var href = this.getAttribute('href');
        if (href && window.LinkClicked) LinkClicked.postMessage(href);
        setTimeout(function(){ lastLink = false; }, 200);
      });
    });
    document.addEventListener('click', function() {
      setTimeout(function(){
        if (!lastLink && window.PageTapped) PageTapped.postMessage('tap');
      }, 100);
    });
  </script>
</body>
</html>''';
  }

  void _initializeOrUpdateWebView(double width, double height) {
    // La pagina ARD è 390px larga (10 + 380) e 25 righe × 16px = 400px alta
    const nativeWidth = 390.0;
    const nativeHeight = 400.0;

    final scaleX = width / nativeWidth;
    final scaleY = height / nativeHeight;

    final html = _buildHtml(scaleX, scaleY);

    if (_controller == null) {
      bool firstLoad = true;
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..addJavaScriptChannel(
          'LinkClicked',
          onMessageReceived: (msg) => _handleLinkNavigation(msg.message),
        )
        ..addJavaScriptChannel(
          'PageTapped',
          onMessageReceived: (_) => widget.onTap?.call(),
        )
        ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (req) {
            if (firstLoad) { firstLoad = false; return NavigationDecision.navigate; }
            return NavigationDecision.prevent;
          },
        ))
        ..loadHtmlString(html, baseUrl: widget.page.imageUrl);
    } else {
      _controller!.loadHtmlString(html, baseUrl: widget.page.imageUrl);
    }

    _lastWidth = width;
    _lastHeight = height;
  }

  void _handleLinkNavigation(String href) {
    final m = RegExp(r'[?&]page=(\d+)').firstMatch(href);
    if (m != null) {
      final p = int.tryParse(m.group(1)!);
      if (p != null) widget.onPageNavigation?.call(p);
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
              Text(_errorMessage!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () { setState(() { _errorMessage = null; _isLoading = true; }); _extractContent(); },
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
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final needsUpdate = _controller == null ||
            _lastWidth == null || _lastHeight == null ||
            (w - (_lastWidth ?? 0)).abs() > 20 ||
            (h - (_lastHeight ?? 0)).abs() > 20;

        if (needsUpdate) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _initializeOrUpdateWebView(w, h);
          });
        }

        if (_controller == null) {
          return Container(color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)));
        }

        return Container(
          color: Colors.black,
          child: WebViewWidget(controller: _controller!),
        );
      },
    );
  }
}
