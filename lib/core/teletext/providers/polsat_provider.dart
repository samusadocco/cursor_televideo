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
    print('[Polsat] Fetching page $pageNumber, subpage $subPage');

    // Costruisci URL immagine direttamente (come fa il JavaScript della pagina)
    // Formato: https://images.weserv.nl/?url=http://gazetatvpolsat.pl/100/100_0001.png&maxage=1d
    final firstDigit = pageNumber.toString()[0];
    final subPagePadded = subPage.toString().padLeft(2, '0');
    final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
    final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
    final imageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
    
    print('[Polsat] Image URL: $imageUrl');

    // Verifica che l'immagine esista facendo una richiesta HEAD
    try {
      final response = await _dio.head(
        imageUrl,
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

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
      print('[Polsat] Extracting clickable areas via WebView for subpage $subPage...');
      
      // Estrai link per ogni sottopagina (i link cambiano!)
      clickableAreas = await _extractClickableAreasViaWebView(pageNumber, subPage);
      print('[Polsat] WebView extraction found ${clickableAreas.length} clickable areas');

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
          print('[Polsat] Using cached maxSubPages: $maxSubPages');
        } else {
          // Probing sequenziale (come Zattoo)
          maxSubPages = await _detectMaxSubPages(pageNumber);
          SubpageCacheService.cacheSubpageCount(
            providerId: providerId,
            pageNumber: pageNumber,
            maxSubPages: maxSubPages,
          );
          print('[Polsat] Detected and cached maxSubPages: $maxSubPages');
        }
      } else {
        // Per subPage > 1, usa cache o default a 1
        maxSubPages = SubpageCacheService.getCachedSubpageCount(
          providerId: providerId,
          pageNumber: pageNumber,
        ) ?? 1;
      }

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
        },
      );
    } catch (e) {
      print('[Polsat] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae aree cliccabili usando WebView per eseguire JavaScript
  Future<List<ClickableArea>> _extractClickableAreasViaWebView(
    int pageNumber,
    int subPage,
  ) async {
    final clickableAreas = <ClickableArea>[];
    
    try {
      // SEMPRE carica sottopagina 1 per inizializzare JavaScript correttamente
      final pageUrl = '$_baseUrl#0-$pageNumber-1';
      print('[Polsat] Loading URL in WebView (always subpage 1): $pageUrl');
      
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
      
      print('[Polsat] Loading fresh page (cache cleared): $pageUrl');
      await controller.loadRequest(Uri.parse(pageUrl));
      
      // Aspetta che la pagina sia caricata (ridotto a 500ms)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Se richiesta sottopagina > 1, modifica l'URL dell'immagine
      if (subPage > 1) {
        print('[Polsat] Requested subpage $subPage > 1, modifying image URL...');
        
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
              
              img.onload = function() {
                console.log('[Polsat JS] Subpage $subPage image loaded');
                window.polsatImageLoaded = true;
              };
              
              img.src = newSrc;
            }
          })();
          '''
        );
        
        // Aspetta che l'immagine sia caricata (polling intelligente)
        int attempts = 0;
        while (attempts < 20) { // Max 2 secondi
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
          
          final loaded = await controller.runJavaScriptReturningResult('window.polsatImageLoaded || false');
          if (loaded.toString() == 'true') {
            print('[Polsat] Subpage image loaded after ${attempts * 100}ms');
            break;
          }
        }
      }
      
      // Aspetta che l'immagine sia completamente caricata e POI chiama recognize()
      await controller.runJavaScript(
        '''
        (function() {
          const img = document.querySelector('img');
          const map = document.querySelector('map[name="links"]');
          
          if (img && map && typeof recognize === 'function') {
            console.log('[Polsat JS] Current img.width=' + img.width + ', img.height=' + img.height);
            
            // Funzione per chiamare recognize quando immagine è pronta
            function callRecognizeWhenReady() {
              console.log('[Polsat JS] BEFORE force - img.width=' + img.width + ', img.clientWidth=' + img.clientWidth + ', img.offsetWidth=' + img.offsetWidth);
              
              // Pulisci la mappa esistente
              map.innerHTML = '';
              
              // Forza dimensioni corrette in tutti i modi possibili
              img.width = 480;
              img.height = 336;
              img.setAttribute('width', '480');
              img.setAttribute('height', '336');
              img.style.width = '480px';
              img.style.height = '336px';
              img.style.maxWidth = '480px';
              img.style.maxHeight = '336px';
              
              console.log('[Polsat JS] AFTER force - img.width=' + img.width + ', img.clientWidth=' + img.clientWidth + ', img.offsetWidth=' + img.offsetWidth);
              
              // Chiama recognize() con dimensioni corrette
              recognize();
              
              console.log('[Polsat JS] recognize() called, checking map...');
              setTimeout(function() {
                const areas = map.querySelectorAll('area');
                console.log('[Polsat JS] Map has ' + areas.length + ' areas after recognize()');
                if (areas.length > 0) {
                  console.log('[Polsat JS] First area coords: ' + areas[0].getAttribute('coords'));
                }
              }, 100);
            }
            
            // Se l'immagine è già caricata
            if (img.complete && img.naturalWidth > 0) {
              console.log('[Polsat JS] Image already loaded');
              callRecognizeWhenReady();
            } else {
              // Aspetta l'evento onload
              console.log('[Polsat JS] Waiting for image to load...');
              img.onload = function() {
                console.log('[Polsat JS] Image loaded! naturalWidth=' + img.naturalWidth);
                callRecognizeWhenReady();
              };
              
              // Fallback dopo 3 secondi
              setTimeout(function() {
                if (map.querySelectorAll('area').length === 0) {
                  console.log('[Polsat JS] Timeout fallback - forcing recognize()');
                  callRecognizeWhenReady();
                }
              }, 3000);
            }
          } else {
            console.log('[Polsat JS] Error: img=' + !!img + ', map=' + !!map + ', recognize=' + (typeof recognize));
          }
        })();
        '''
      );
      
      // Aspetta che recognize() completi il pattern matching
      // recognize() è asincrono (usa Web Workers), quindi aspettiamo un po'
      print('[Polsat] Waiting for recognize() to complete pattern matching...');
      await Future.delayed(const Duration(seconds: 3));
      
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
      
      print('[Polsat] Map HTML extracted: ${mapHtml.toString().length} chars');
      
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
      
      print('[Polsat] Total clickable areas extracted: ${clickableAreas.length}');
    } catch (e) {
      print('[Polsat] Error in WebView extraction: $e');
    }
    
    return clickableAreas;
  }

  /// Rileva numero massimo di sottopagine tramite probing sequenziale
  Future<int> _detectMaxSubPages(int pageNumber) async {
    print('[Polsat] Starting subpage detection for page $pageNumber');
    
    int maxSubPages = 1;
    
    // Prova sottopagine da 2 fino a 30
    for (int subPage = 2; subPage <= 30; subPage++) {
      // Costruisci URL immagine per questa sottopagina
      final firstDigit = pageNumber.toString()[0];
      final subPagePadded = subPage.toString().padLeft(2, '0');
      final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
      final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
      final probeImageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
      
      try {
        print('[Polsat] Probing subpage $subPage: $probeImageUrl');
        
        // Fai una richiesta HEAD per verificare se l'immagine esiste
        final response = await _dio.head(
          probeImageUrl,
          options: Options(
            validateStatus: (status) => status! < 500,
          ),
        );
        
        if (response.statusCode == 404) {
          print('[Polsat] Subpage $subPage does not exist (404)');
          break;
        }
        
        if (response.statusCode == 200) {
          maxSubPages = subPage;
          print('[Polsat] Subpage $subPage exists');
        } else {
          print('[Polsat] Unexpected status ${response.statusCode} for subpage $subPage');
          break;
        }
      } catch (e) {
        print('[Polsat] Error probing subpage $subPage: $e');
        break;
      }
    }
    
    print('[Polsat] Max subpages detected: $maxSubPages');
    return maxSubPages;
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
