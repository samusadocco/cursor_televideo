import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Servizio OCR per Polsat usando WebView + JavaScript recognize()
/// Usato come fallback per simulatori iOS dove ML Kit non funziona
class WebViewPolsatOcrService {
  static const String _baseUrl = 'https://niutech.github.io/telegazeta-browser/popup.html';

  /// Estrae aree cliccabili usando WebView per eseguire JavaScript
  Future<List<ClickableArea>> extractClickableAreas({
    required int pageNumber,
    required int subPage,
  }) async {
    final methodStart = DateTime.now();
    final clickableAreas = <ClickableArea>[];
    
    try {
      // SEMPRE carica sottopagina 1 per inizializzare JavaScript correttamente
      final pageUrl = '$_baseUrl#0-$pageNumber-1';
      print('[WebView OCR]   📄 Loading URL: $pageUrl');
      
      // Crea WebViewController
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              print('[WebView OCR] Page finished loading: $url');
            },
          ),
        );
      
      // Pulisci la cache per forzare reload fresco
      await controller.clearCache();
      await controller.clearLocalStorage();
      
      final loadStart = DateTime.now();
      print('[WebView OCR]   🌐 Loading fresh page...');
      await controller.loadRequest(Uri.parse(pageUrl));
      
      // Aspetta che la pagina sia caricata
      await Future.delayed(const Duration(milliseconds: 500));
      
      final loadDuration = DateTime.now().difference(loadStart).inMilliseconds;
      print('[WebView OCR]   ⏱️ Page loaded in ${loadDuration}ms');
      
      // Setup per aspettare che l'immagine sia pronta e forzare dimensioni
      await controller.runJavaScript(
        '''
        (function() {
          const img = document.querySelector('img');
          if (img) {
            window.polsatImageLoaded = false;
            window.polsatImageDimensions = { width: 0, height: 0 };
            
            function forceDimensions() {
              console.log('[WebView OCR JS] Before force: img.width=' + img.width);
              
              img.width = 480;
              img.height = 336;
              img.setAttribute('width', '480');
              img.setAttribute('height', '336');
              img.style.width = '480px';
              img.style.height = '336px';
              img.style.minWidth = '480px';
              img.style.minHeight = '336px';
              
              console.log('[WebView OCR JS] After force: img.width=' + img.width);
              window.polsatImageDimensions = { width: 480, height: 336 };
              window.polsatImageLoaded = true;
            }
            
            if (img.complete && img.naturalWidth > 0) {
              console.log('[WebView OCR JS] Image already loaded');
              setTimeout(forceDimensions, 50);
            } else {
              console.log('[WebView OCR JS] Waiting for image to load...');
              img.onload = function() {
                console.log('[WebView OCR JS] Image loaded, naturalWidth=' + img.naturalWidth);
                setTimeout(forceDimensions, 50);
              };
            }
          }
        })();
        '''
      );
      
      // Aspetta che l'immagine di subpage 1 sia pronta
      if (subPage == 1) {
        print('[WebView OCR]   ⏳ Waiting for subpage 1 image...');
        await Future.delayed(const Duration(milliseconds: 200));
        
        int attempts = 0;
        bool imageReady = false;
        while (attempts < 25) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
          
          final loaded = await controller.runJavaScriptReturningResult('window.polsatImageLoaded || false');
          if (loaded.toString() == 'true') {
            print('[WebView OCR]   📐 Subpage 1 image ready');
            imageReady = true;
            break;
          }
        }
        
        if (!imageReady) {
          print('[WebView OCR]   ⚠️ WARNING: Subpage 1 image timeout');
        }
      }
      
      // Se richiesta sottopagina > 1, modifica l'URL dell'immagine
      if (subPage > 1) {
        final modifyStart = DateTime.now();
        print('[WebView OCR]   🔄 Modifying image for subpage $subPage...');
        
        final subPagePadded = subPage.toString().padLeft(4, '0');
        await controller.runJavaScript(
          '''
          (function() {
            const img = document.querySelector('img');
            if (img) {
              const currentSrc = img.src;
              const newSrc = currentSrc.replace(/_\\d{4}\\.png/, '_$subPagePadded.png');
              
              window.polsatImageLoaded = false;
              window.polsatImageDimensions = { width: 0, height: 0 };
              
              img.onload = function() {
                setTimeout(function() {
                  img.width = 480;
                  img.height = 336;
                  img.setAttribute('width', '480');
                  img.setAttribute('height', '336');
                  img.style.width = '480px';
                  img.style.height = '336px';
                  img.style.minWidth = '480px';
                  img.style.minHeight = '336px';
                  img.style.display = 'block';
                  
                  window.polsatImageDimensions = { width: 480, height: 336 };
                  window.polsatImageLoaded = true;
                }, 50);
              };
              
              img.onerror = function(e) {
                console.error('[WebView OCR JS] Image loading error:', e);
                window.polsatImageLoaded = false;
              };
              
              img.src = newSrc;
              
              setTimeout(function() {
                if (img.complete && img.naturalWidth > 0 && !window.polsatImageLoaded) {
                  img.width = 480;
                  img.height = 336;
                  window.polsatImageDimensions = { width: 480, height: 336 };
                  window.polsatImageLoaded = true;
                }
              }, 100);
            }
          })();
          '''
        );
        
        // Aspetta che l'immagine sia caricata
        await Future.delayed(const Duration(milliseconds: 200));
        
        int attempts = 0;
        bool imageLoaded = false;
        while (attempts < 25) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
          
          final loaded = await controller.runJavaScriptReturningResult('window.polsatImageLoaded || false');
          if (loaded.toString() == 'true') {
            final modifyDuration = DateTime.now().difference(modifyStart).inMilliseconds;
            print('[WebView OCR]   ⏱️ Subpage image ready in ${modifyDuration}ms');
            imageLoaded = true;
            break;
          }
        }
        
        if (!imageLoaded) {
          print('[WebView OCR]   ⚠️ WARNING: Image load timeout');
        }
      }
      
      // Chiama recognize()
      await controller.runJavaScript(
        '''
        (function() {
          const img = document.querySelector('img');
          const map = document.querySelector('map[name="links"]');
          
          if (img && map && typeof recognize === 'function') {
            map.innerHTML = '';
            
            if (img.width === 0) {
              img.width = 480;
              img.height = 336;
              img.setAttribute('width', '480');
              img.setAttribute('height', '336');
              img.style.width = '480px';
              img.style.height = '336px';
            }
            
            recognize();
          }
        })();
        '''
      );
      
      // Aspetta che recognize() completi
      final recognizeStart = DateTime.now();
      print('[WebView OCR]   🤖 Waiting for recognize()...');
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final recognizeDuration = DateTime.now().difference(recognizeStart).inMilliseconds;
      print('[WebView OCR]   ⏱️ recognize() completed in ${recognizeDuration}ms');
      
      // Estrai l'HTML della mappa
      final result = await controller.runJavaScriptReturningResult(
        '''
        (function() {
          const map = document.querySelector('map[name="links"]');
          if (!map) return '';
          return map.innerHTML;
        })();
        '''
      );
      final mapHtml = result.toString();
      
      print('[WebView OCR]   ⏱️ Map HTML extracted: ${mapHtml.length} chars');
      
      // Parse HTML
      if (mapHtml.isNotEmpty) {
        String mapHtmlStr = mapHtml;
        if (mapHtmlStr.startsWith('"') && mapHtmlStr.endsWith('"')) {
          mapHtmlStr = mapHtmlStr.substring(1, mapHtmlStr.length - 1);
        }
        
        final document = html_parser.parse('<map name="links">$mapHtmlStr</map>');
        final mapElement = document.querySelector('map[name="links"]');
        
        if (mapElement != null) {
          final areas = mapElement.querySelectorAll('area');
          print('[WebView OCR] Found ${areas.length} <area> elements');
          
          for (final area in areas) {
            final href = area.attributes['href'];
            final coords = area.attributes['coords'];
            
            if (href == null || coords == null) continue;
            
            int? targetPage;
            if (href.startsWith('#')) {
              final parts = href.substring(1).split('-');
              if (parts.length >= 2) {
                targetPage = int.tryParse(parts[1]);
              }
            }
            
            if (targetPage == null || targetPage < 100 || targetPage > 999) {
              continue;
            }
            
            final coordsList = coords.split(',')
                .map((c) => int.tryParse(c.trim()))
                .toList();
            
            if (coordsList.length < 4 || coordsList.any((c) => c == null)) {
              continue;
            }
            
            final x1 = coordsList[0]!;
            final y1 = coordsList[1]!;
            final x2 = coordsList[2]!;
            final y2 = coordsList[3]!;
            
            clickableAreas.add(ClickableArea(
              targetPage: targetPage,
              x: x1,
              y: y1,
              width: x2 - x1,
              height: y2 - y1,
              description: 'Pagina $targetPage',
            ));
            
            print('[WebView OCR] ✅ Added clickable area for page $targetPage');
          }
        }
      }
      
      final methodDuration = DateTime.now().difference(methodStart).inMilliseconds;
      print('[WebView OCR]   ✅ Total time: ${methodDuration}ms, extracted ${clickableAreas.length} areas');
    } catch (e) {
      final errorDuration = DateTime.now().difference(methodStart).inMilliseconds;
      print('[WebView OCR]   ❌ Error after ${errorDuration}ms: $e');
    }
    
    return clickableAreas;
  }
}
