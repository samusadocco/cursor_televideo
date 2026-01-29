import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/cache/subpage_cache_service.dart';

/// Provider per Polsat Telegazeta (Polonia)
/// Canale basato su immagini con WebView per estrarre link cliccabili via JavaScript
class PolsatProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://niutech.github.io/telegazeta-browser/popup.html';
  
  // Cache per clickableAreas (chiave: "pageNumber-subPage")
  final Map<String, List<ClickableArea>> _clickableAreasCache = {};

  PolsatProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'polsat_telegazeta';

  @override
  String get providerName => 'Polsat Telegazeta';

  @override
  String get countryCode => 'PL';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await fetchNationalPage(pageNumber);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    final startTime = DateTime.now();
    print('[Polsat] 🚀 Fetching page $pageNumber, subpage $subPage');

    // Costruisci URL immagine direttamente (come fa il JavaScript della pagina)
    // Formato: https://images.weserv.nl/?url=http://gazetatvpolsat.pl/100/100_0001.png&maxage=1d
    final firstDigit = pageNumber.toString()[0];
    final subPagePadded = subPage.toString().padLeft(2, '0');
    final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
    final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
    final imageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
    
    print('[Polsat] Image URL: $imageUrl');

    // Verifica che l'immagine esista facendo una richiesta HEAD
    final headStart = DateTime.now();
    try {
      final response = await _dio.head(
        imageUrl,
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );
      
      final headDuration = DateTime.now().difference(headStart).inMilliseconds;
      print('[Polsat] ⏱️ HEAD request completed in ${headDuration}ms');

      if (response.statusCode == 404) {
        print('[Polsat] Image not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[Polsat] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('[Polsat] Error checking image: $e');
      rethrow;
    }

    // Usa WebView per caricare la pagina, eseguire JavaScript e estrarre i link
    // NOTA: La mappa HTML è vuota e viene popolata dinamicamente via JavaScript
    List<ClickableArea> clickableAreas = [];
    
    try {
      // Controlla cache clickableAreas (chiave: pageNumber-subPage)
      final cacheKey = '$pageNumber-$subPage';
      if (_clickableAreasCache.containsKey(cacheKey)) {
        clickableAreas = _clickableAreasCache[cacheKey]!;
        print('[Polsat] ⚡ Using cached clickable areas for page $pageNumber subpage $subPage: ${clickableAreas.length} areas');
      } else {
        // Estrai link via WebView (i link possono essere diversi per ogni sottopagina!)
        final webviewStart = DateTime.now();
        print('[Polsat] 🔍 Extracting clickable areas via WebView for page $pageNumber subpage $subPage...');
        
        clickableAreas = await _extractClickableAreasViaWebView(pageNumber, subPage);
        
        // Salva in cache
        _clickableAreasCache[cacheKey] = clickableAreas;
        
        final webviewDuration = DateTime.now().difference(webviewStart).inMilliseconds;
        print('[Polsat] ⏱️ WebView extraction completed in ${webviewDuration}ms, found ${clickableAreas.length} clickable areas (cached)');
      }

      // Determina max sottopagine solo per subPage == 1
      int maxSubPages = 1;
      if (subPage == 1) {
        // Controlla cache prima
        final cached = SubpageCacheService.getCachedSubpageCount(
          providerId: providerId,
          pageNumber: pageNumber,
        );
        if (cached != null) {
          maxSubPages = cached;
          print('[Polsat] ⚡ Using cached maxSubPages: $maxSubPages');
        } else {
          // Probing sequenziale (come Zattoo)
          final probingStart = DateTime.now();
          print('[Polsat] 🔎 Starting subpage detection...');
          
          maxSubPages = await _detectMaxSubPages(pageNumber);
          
          final probingDuration = DateTime.now().difference(probingStart).inMilliseconds;
          print('[Polsat] ⏱️ Subpage detection completed in ${probingDuration}ms, found $maxSubPages subpages');
          
          SubpageCacheService.cacheSubpageCount(
            providerId: providerId,
            pageNumber: pageNumber,
            maxSubPages: maxSubPages,
          );
        }
      } else {
        // Per subPage > 1, usa cache o default a 1
        maxSubPages = SubpageCacheService.getCachedSubpageCount(
          providerId: providerId,
          pageNumber: pageNumber,
        ) ?? 1;
      }

      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;
      print('[Polsat] ✅ Total page load time: ${totalDuration}ms');

      return TelevideoPage(
        pageNumber: pageNumber,
        htmlContent: '',
        imageUrl: imageUrl,
        subPage: subPage,
        maxSubPages: maxSubPages,
        isHtmlContent: false,
        providerId: providerId,
        clickableAreas: clickableAreas,
        metadata: {
          'source': 'polsat',
          'format': 'image',
          'originalUrl': '$_baseUrl#0-$pageNumber-$subPage',
          'imageUrl': imageUrl,
          'linksCount': clickableAreas.length,
          'loadTime': totalDuration,
        },
      );
    } catch (e) {
      final errorDuration = DateTime.now().difference(startTime).inMilliseconds;
      print('[Polsat] ❌ Error fetching page after ${errorDuration}ms: $e');
      rethrow;
    }
  }

  /// Estrae aree cliccabili usando WebView per eseguire JavaScript
  Future<List<ClickableArea>> _extractClickableAreasViaWebView(
    int pageNumber,
    int subPage,
  ) async {
    final methodStart = DateTime.now();
    final clickableAreas = <ClickableArea>[];
    
    try {
      // SEMPRE carica sottopagina 1 per inizializzare JavaScript correttamente
      final pageUrl = '$_baseUrl#0-$pageNumber-1';
      print('[Polsat]   📄 Loading URL in WebView (always subpage 1): $pageUrl');
      
      final webviewCreateStart = DateTime.now();
      // Crea WebViewController
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              print('[Polsat] Page finished loading: $url');
            },
          ),
        );
      
      // Pulisci la cache per forzare reload fresco
      await controller.clearCache();
      await controller.clearLocalStorage();
      
      final loadStart = DateTime.now();
      print('[Polsat]   🌐 Loading fresh page (cache cleared)...');
      await controller.loadRequest(Uri.parse(pageUrl));
      
      // Aspetta che la pagina sia caricata
      await Future.delayed(const Duration(milliseconds: 500));
      
      final loadDuration = DateTime.now().difference(loadStart).inMilliseconds;
      print('[Polsat]   ⏱️ Page loaded in ${loadDuration}ms');
      
      // Setup per aspettare che l'immagine sia pronta e forzare dimensioni
      await controller.runJavaScript(
        '''
        (function() {
          const img = document.querySelector('img');
          if (img) {
            window.polsatImageLoaded = false;
            window.polsatImageDimensions = { width: 0, height: 0 };
            
            function forceDimensions() {
              console.log('[Polsat JS] Subpage 1 - Before force: img.width=' + img.width + ', offsetWidth=' + img.offsetWidth);
              
              img.width = 480;
              img.height = 336;
              img.setAttribute('width', '480');
              img.setAttribute('height', '336');
              img.style.width = '480px';
              img.style.height = '336px';
              img.style.minWidth = '480px';
              img.style.minHeight = '336px';
              
              console.log('[Polsat JS] Subpage 1 - After force: img.width=' + img.width);
              window.polsatImageDimensions = { width: 480, height: 336 };
              window.polsatImageLoaded = true;
            }
            
            if (img.complete && img.naturalWidth > 0) {
              console.log('[Polsat JS] Subpage 1 image already loaded');
              setTimeout(forceDimensions, 50);
            } else {
              console.log('[Polsat JS] Waiting for subpage 1 image to load...');
              img.onload = function() {
                console.log('[Polsat JS] Subpage 1 image loaded, naturalWidth=' + img.naturalWidth);
                setTimeout(forceDimensions, 50);
              };
            }
          }
        })();
        '''
      );
      
      // Aspetta che l'immagine di subpage 1 sia pronta
      if (subPage == 1) {
        print('[Polsat]   ⏳ Waiting for subpage 1 image to be ready...');
        await Future.delayed(const Duration(milliseconds: 200));
        
        int attempts = 0;
        bool imageReady = false;
        while (attempts < 25) {
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
          
          final loaded = await controller.runJavaScriptReturningResult('window.polsatImageLoaded || false');
          if (loaded.toString() == 'true') {
            final imgWidth = await controller.runJavaScriptReturningResult('document.querySelector("img").width');
            print('[Polsat]   📐 Subpage 1 image ready: img.width=$imgWidth');
            imageReady = true;
            break;
          }
        }
        
        if (!imageReady) {
          print('[Polsat]   ⚠️ WARNING: Subpage 1 image timeout, forcing anyway');
        }
      }
      
      // Se richiesta sottopagina > 1, modifica l'URL dell'immagine
      if (subPage > 1) {
        final modifyStart = DateTime.now();
        print('[Polsat]   🔄 Requested subpage $subPage > 1, modifying image URL...');
        
        final subPagePadded = subPage.toString().padLeft(4, '0');
        await controller.runJavaScript(
          '''
          (function() {
            const img = document.querySelector('img');
            if (img) {
              const currentSrc = img.src;
              console.log('[Polsat JS] Current image src: ' + currentSrc);
              
              // Sostituisci _000X.png con _${subPagePadded}.png
              // Esempio: 102_0001.png -> 102_0002.png
              const newSrc = currentSrc.replace(/_\\d{4}\\.png/, '_$subPagePadded.png');
              
              console.log('[Polsat JS] New image src: ' + newSrc);
              
              // Flag per tracciare caricamento
              window.polsatImageLoaded = false;
              window.polsatImageDimensions = { width: 0, height: 0 };
              
              img.onload = function() {
                console.log('[Polsat JS] Subpage $subPage image loaded, naturalWidth=' + img.naturalWidth);
                
                // Aspetta un tick prima di forzare dimensioni (per assicurarsi che l'immagine sia renderizzata)
                setTimeout(function() {
                  console.log('[Polsat JS] Before force: img.width=' + img.width + ', offsetWidth=' + img.offsetWidth);
                  
                  // FORZA dimensioni in tutti i modi possibili
                  img.width = 480;
                  img.height = 336;
                  img.setAttribute('width', '480');
                  img.setAttribute('height', '336');
                  img.style.width = '480px';
                  img.style.height = '336px';
                  img.style.minWidth = '480px';
                  img.style.minHeight = '336px';
                  img.style.display = 'block';
                  
                  console.log('[Polsat JS] After force: img.width=' + img.width + ', offsetWidth=' + img.offsetWidth);
                  window.polsatImageDimensions = { width: 480, height: 336 };
                  window.polsatImageLoaded = true;
                }, 50);
              };
              
              img.onerror = function(e) {
                console.error('[Polsat JS] Image loading error:', e);
                window.polsatImageLoaded = false;
              };
              
              img.src = newSrc;
              
              // Fallback: controlla se già caricata (dopo 100ms)
              setTimeout(function() {
                if (img.complete && img.naturalWidth > 0 && !window.polsatImageLoaded) {
                  console.log('[Polsat JS] Image already complete (fallback), forcing dimensions...');
                  img.width = 480;
                  img.height = 336;
                  img.setAttribute('width', '480');
                  img.setAttribute('height', '336');
                  img.style.width = '480px';
                  img.style.height = '336px';
                  window.polsatImageDimensions = { width: 480, height: 336 };
                  window.polsatImageLoaded = true;
                }
              }, 100);
            }
          })();
          '''
        );
        
        // Aspetta che l'immagine sia caricata (polling intelligente)
        // Aspetta almeno 200ms per dare tempo al setTimeout(50ms) di eseguire
        await Future.delayed(const Duration(milliseconds: 200));
        
        int attempts = 0;
        bool imageLoaded = false;
        while (attempts < 25) { // Max 2.5 secondi dopo il delay iniziale
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
          
          final loaded = await controller.runJavaScriptReturningResult('window.polsatImageLoaded || false');
          if (loaded.toString() == 'true') {
            final dims = await controller.runJavaScriptReturningResult('JSON.stringify(window.polsatImageDimensions)');
            final imgWidth = await controller.runJavaScriptReturningResult('document.querySelector("img").width');
            print('[Polsat]   📐 Dimensions after load: $dims, actual img.width=$imgWidth');
            
            final modifyDuration = DateTime.now().difference(modifyStart).inMilliseconds;
            print('[Polsat]   ⏱️ Subpage image modified and loaded in ${modifyDuration}ms');
            imageLoaded = true;
            break;
          }
        }
        
        if (!imageLoaded) {
          print('[Polsat]   ⚠️ WARNING: Image load timeout after ${200 + attempts * 100}ms');
        }
      }
      
      // Chiama recognize() (per subpage > 1, dimensioni già forzate in onload)
      await controller.runJavaScript(
        '''
        (function() {
          const img = document.querySelector('img');
          const map = document.querySelector('map[name="links"]');
          
          if (img && map && typeof recognize === 'function') {
            console.log('[Polsat JS] Preparing recognize()...');
            console.log('[Polsat JS] img.width=' + img.width + ', img.height=' + img.height);
            console.log('[Polsat JS] img.naturalWidth=' + img.naturalWidth + ', img.complete=' + img.complete);
            
            // Pulisci la mappa esistente
            map.innerHTML = '';
            
            // Per subpage 1, forza dimensioni (per subpage > 1 già fatto)
            if (img.width === 0) {
              console.log('[Polsat JS] WARNING: img.width=0, forcing dimensions...');
              img.width = 480;
              img.height = 336;
              img.setAttribute('width', '480');
              img.setAttribute('height', '336');
              img.style.width = '480px';
              img.style.height = '336px';
              console.log('[Polsat JS] After force: img.width=' + img.width);
            }
            
            // Chiama recognize()
            console.log('[Polsat JS] Calling recognize()...');
            recognize();
            console.log('[Polsat JS] recognize() called');
          } else {
            console.log('[Polsat JS] Error: img=' + !!img + ', map=' + !!map + ', recognize=' + (typeof recognize));
          }
        })();
        '''
      );
      
      // Aspetta che recognize() completi il pattern matching
      // recognize() è asincrono (usa Web Workers), quindi aspettiamo un po'
      // Ridotto a 1.5s per velocizzare il caricamento
      final recognizeStart = DateTime.now();
      print('[Polsat]   🤖 Waiting for recognize() to complete pattern matching...');
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final recognizeDuration = DateTime.now().difference(recognizeStart).inMilliseconds;
      print('[Polsat]   ⏱️ recognize() wait completed in ${recognizeDuration}ms');
      
      // Estrai l'HTML della mappa
      final extractStart = DateTime.now();
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
      
      final extractDuration = DateTime.now().difference(extractStart).inMilliseconds;
      print('[Polsat]   ⏱️ Map HTML extracted in ${extractDuration}ms: ${mapHtml.length} chars');
      
      // Fai parsing dell'HTML estratto
      if (mapHtml != null && mapHtml.toString().isNotEmpty) {
        // Rimuovi le virgolette all'inizio e alla fine se presenti
        String mapHtmlStr = mapHtml.toString();
        if (mapHtmlStr.startsWith('"') && mapHtmlStr.endsWith('"')) {
          mapHtmlStr = mapHtmlStr.substring(1, mapHtmlStr.length - 1);
        }
        
        // Crea un documento HTML temporaneo per fare parsing
        final document = html_parser.parse('<map name="links">$mapHtmlStr</map>');
        final mapElement = document.querySelector('map[name="links"]');
        
        if (mapElement != null) {
          final areas = mapElement.querySelectorAll('area');
          print('[Polsat] Found ${areas.length} <area> elements');
          
          for (final area in areas) {
            final href = area.attributes['href'];
            final coords = area.attributes['coords'];
            
            if (href == null || coords == null) continue;
            
            // Parse href per estrarre numero pagina (#0-200-1 -> 200)
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
            
            // Parse coordinate (formato: "x1,y1,x2,y2")
            print('[Polsat] Raw coords string: "$coords"');
            
            final coordsList = coords.split(',')
                .map((c) => int.tryParse(c.trim()))
                .toList();
            
            print('[Polsat] Parsed coords: $coordsList (length: ${coordsList.length})');
            
            if (coordsList.length < 4 || coordsList.any((c) => c == null)) {
              print('[Polsat] ⚠️ Invalid coords: skipping');
              continue;
            }
            
            final x1 = coordsList[0]!;
            final y1 = coordsList[1]!;
            final x2 = coordsList[2]!;
            final y2 = coordsList[3]!;
            
            print('[Polsat] Coordinates: ($x1,$y1) to ($x2,$y2) → width=${x2-x1}, height=${y2-y1}');
            
            clickableAreas.add(ClickableArea(
              targetPage: targetPage,
              x: x1,
              y: y1,
              width: x2 - x1,
              height: y2 - y1,
              description: 'Pagina $targetPage',
            ));
            
            print('[Polsat] ✅ Added clickable area for page $targetPage at ($x1,$y1)-($x2,$y2)');
          }
        }
      }
      
      final methodDuration = DateTime.now().difference(methodStart).inMilliseconds;
      print('[Polsat]   ✅ Total WebView extraction time: ${methodDuration}ms, extracted ${clickableAreas.length} areas');
    } catch (e) {
      final errorDuration = DateTime.now().difference(methodStart).inMilliseconds;
      print('[Polsat]   ❌ Error in WebView extraction after ${errorDuration}ms: $e');
    }
    
    return clickableAreas;
  }

  /// Rileva numero massimo di sottopagine con ricerca esponenziale + binaria
  Future<int> _detectMaxSubPages(int pageNumber) async {
    print('[Polsat] 🔍 Starting optimized subpage detection for page $pageNumber');
    
    // Fase 1: Ricerca esponenziale (2, 4, 8, 16, 32, 64, 128...)
    int lowerBound = 1; // Sappiamo che esiste almeno subpage 1
    int upperBound = 1;
    int probedSubpage = 2;
    
    print('[Polsat]   Phase 1: Exponential search...');
    
    while (probedSubpage <= 128) { // Max 128 sottopagine
      final exists = await _checkSubpageExists(pageNumber, probedSubpage);
      
      if (exists) {
        print('[Polsat]   ✅ Subpage $probedSubpage exists');
        lowerBound = probedSubpage;
        upperBound = probedSubpage * 2;
        probedSubpage = probedSubpage * 2;
      } else {
        print('[Polsat]   ❌ Subpage $probedSubpage not found');
        upperBound = probedSubpage;
        break;
      }
    }
    
    // Se abbiamo raggiunto il limite senza trovare un KO, il max è 128+
    if (lowerBound == 128) {
      print('[Polsat]   ⚠️ Reached max limit (128), stopping search');
      return 128;
    }
    
    // Fase 2: Ricerca binaria nel range [lowerBound, upperBound]
    print('[Polsat]   Phase 2: Binary search in range [$lowerBound, $upperBound]...');
    
    while (lowerBound < upperBound - 1) {
      final mid = (lowerBound + upperBound) ~/ 2;
      final exists = await _checkSubpageExists(pageNumber, mid);
      
      if (exists) {
        print('[Polsat]   ✅ Subpage $mid exists');
        lowerBound = mid;
      } else {
        print('[Polsat]   ❌ Subpage $mid not found');
        upperBound = mid;
      }
    }
    
    print('[Polsat]   🎯 Max subpage found: $lowerBound');
    return lowerBound;
  }
  
  /// Verifica se una sottopagina esiste (HEAD request)
  Future<bool> _checkSubpageExists(int pageNumber, int subPage) async {
    final firstDigit = pageNumber.toString()[0];
    final subPagePadded = subPage.toString().padLeft(2, '0');
    final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
    final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
    final probeImageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
    
    try {
      final response = await _dio.head(
        probeImageUrl,
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[Polsat]   ⚠️ Error checking subpage $subPage: $e');
      return false;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // Polsat non ha pagine regionali
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  void dispose() {
    _dio.close();
  }
}
