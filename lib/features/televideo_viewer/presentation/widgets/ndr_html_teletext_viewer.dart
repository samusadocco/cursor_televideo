import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Widget per visualizzare le pagine HTML di NDR Text con scaling dinamico
class NDRHtmlTeletextViewer extends StatefulWidget {
  final TelevideoPage page;
  final VoidCallback? onTap;  // Per play/pause sottopagine
  final Function(int)? onPageTap;  // Per navigazione tra pagine

  const NDRHtmlTeletextViewer({
    super.key,
    required this.page,
    this.onTap,
    this.onPageTap,
  });

  @override
  State<NDRHtmlTeletextViewer> createState() => _NDRHtmlTeletextViewerState();
}

class _NDRHtmlTeletextViewerState extends State<NDRHtmlTeletextViewer> {
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
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'PageTapped',
        onMessageReceived: (JavaScriptMessage message) {
          print('[NDR Viewer] Page tapped');
          widget.onTap?.call();
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Rimuovi loading immediatamente, il fade-in CSS interno gestisce la transizione
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Intercetta click sui link
            if (request.url.contains('ndr.de/public/teletext/')) {
              final uri = Uri.parse(request.url);
              final pathSegments = uri.pathSegments;
              
              if (pathSegments.isNotEmpty) {
                final filename = pathSegments.last; // Es: "194_02.htm"
                final parts = filename.replaceAll('.htm', '').split('_');
                
                if (parts.isNotEmpty) {
                  final pageNum = int.tryParse(parts[0]);
                  if (pageNum != null && pageNum >= 100 && pageNum <= 999) {
                    print('[NDR Viewer] Link clicked: page $pageNum');
                    widget.onPageTap?.call(pageNum);
                  }
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
