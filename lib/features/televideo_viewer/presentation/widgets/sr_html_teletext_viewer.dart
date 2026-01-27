import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Widget per visualizzare le pagine HTML di SR Saar Text con scaling dinamico
class SRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int)? onPageTap;

  const SRHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onPageTap,
  });

  @override
  State<SRHtmlTeletextViewer> createState() => _SRHtmlTeletextViewerState();
}

class _SRHtmlTeletextViewerState extends State<SRHtmlTeletextViewer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Aggiungi un piccolo delay per il fade-in
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Intercetta click sui link
            if (request.url.startsWith('https://www.saartext.de/')) {
              final uri = Uri.parse(request.url);
              final pathSegments = uri.pathSegments;
              
              if (pathSegments.isNotEmpty) {
                final pageNum = int.tryParse(pathSegments[0]);
                if (pageNum != null && pageNum >= 100 && pageNum <= 999) {
                  print('[SR Viewer] Link clicked: page $pageNum');
                  widget.onPageTap?.call(pageNum);
                }
              }
              
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.page.htmlContent ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // WebView con fade-in
        AnimatedOpacity(
          opacity: _isLoading ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: WebViewWidget(controller: _controller),
        ),
        
        // Loading indicator
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            ),
          ),
      ],
    );
  }
}
