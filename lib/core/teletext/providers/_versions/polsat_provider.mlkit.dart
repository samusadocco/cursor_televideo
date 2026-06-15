import 'package:dio/dio.dart';
import 'dart:async';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/cache/subpage_cache_service.dart';

/// Provider per Polsat Telegazeta (Polonia) - VERSIONE ML KIT
/// Canale basato su immagini con ML Kit OCR per estrarre link cliccabili
/// ⚠️ SOLO PER DEVICE FISICI (non funziona su simulatore iOS)
class PolsatProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://niutech.github.io/telegazeta-browser/popup.html';
  
  // Cache per clickableAreas (chiave: "pageNumber-subPage")
  final Map<String, List<ClickableArea>> _clickableAreasCache = {};

  PolsatProvider({Dio? dio})
      : _dio = dio ?? Dio() {
    print('[Polsat] 🚀 Using ML Kit OCR (lazy background enrichment)');
  }

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
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // Polsat non supporta pagine regionali
    throw UnimplementedError('Polsat non supporta pagine regionali');
  }

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    final requestStart = DateTime.now();
    print('[Polsat] ⏱️ === START fetchNationalPage($pageNumber, subPage: $subPage) ===');
    
    try {
      // Costruisci URL immagine (formato originale Polsat)
      final firstDigit = pageNumber.toString()[0];
      final subPagePadded = subPage.toString().padLeft(2, '0');
      final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
      final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
      final imageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
      
      // 1. HEAD request per verificare esistenza pagina
      final headStart = DateTime.now();
      print('[Polsat] 📡 Sending HEAD request to verify page...');
      print('[Polsat] Image URL: $imageUrl');
      
      final headResponse = await _dio.head(
        imageUrl,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      
      final headDuration = DateTime.now().difference(headStart).inMilliseconds;
      print('[Polsat] ⏱️ HEAD request completed in ${headDuration}ms, status: ${headResponse.statusCode}');
      
      if (headResponse.statusCode != 200) {
        print('[Polsat] ❌ Page not found (${headResponse.statusCode})');
        throw Exception('Pagina non trovata');
      }

      // 2. Determina maxSubPages (con cache)
      int maxSubPages = 1;
      
      if (subPage == 1) {
        // Controlla cache prima
        final cached = SubpageCacheService.getCachedSubpageCount(
          providerId: providerId,
          pageNumber: pageNumber,
        );
        
        if (cached != null) {
          maxSubPages = cached;
          print('[Polsat] ✅ Using cached maxSubPages: $maxSubPages');
        } else {
          final detectStart = DateTime.now();
          print('[Polsat] 🔍 Detecting max subpages...');
          maxSubPages = await _detectMaxSubPages(pageNumber);
          SubpageCacheService.cacheSubpageCount(
            providerId: providerId,
            pageNumber: pageNumber,
            maxSubPages: maxSubPages,
          );
          final detectDuration = DateTime.now().difference(detectStart).inMilliseconds;
          print('[Polsat] ⏱️ Max subpages detected in ${detectDuration}ms: $maxSubPages');
        }
      } else {
        // Per subPage > 1, usa cache o default a 1
        maxSubPages = SubpageCacheService.getCachedSubpageCount(
          providerId: providerId,
          pageNumber: pageNumber,
        ) ?? 1;
      }

      // 3. Estrai clickable areas (OCR lazy in background)
      final cacheKey = '$pageNumber-$subPage';
      List<ClickableArea> clickableAreas;
      var lazyOcrPending = true;

      if (_clickableAreasCache.containsKey(cacheKey)) {
        clickableAreas = _clickableAreasCache[cacheKey]!;
        lazyOcrPending = false;
        print('[Polsat] ✅ Using cached clickable areas: ${clickableAreas.length} areas');
      } else {
        clickableAreas = [];
        print('[Polsat] ⚡ Returning page without OCR (lazy enrichment in background)');
      }

      final totalDuration = DateTime.now().difference(requestStart).inMilliseconds;
      print('[Polsat] ✅ === COMPLETED in ${totalDuration}ms ===');

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
          'source': 'polsat_mlkit',
          'format': 'image',
          'originalUrl': '$_baseUrl#0-$pageNumber-$subPage',
          'imageUrl': imageUrl,
          'linksCount': clickableAreas.length,
          'lazyOcrPending': lazyOcrPending,
          'lazyOcrEngine': 'polsat',
          'ocrMethod': 'mlkit',
        },
      );
    } catch (e) {
      final errorDuration = DateTime.now().difference(requestStart).inMilliseconds;
      print('[Polsat] ❌ Error after ${errorDuration}ms: $e');
      rethrow;
    }
  }

  /// Rileva il numero massimo di sottopagine con ricerca esponenziale + binaria
  Future<int> _detectMaxSubPages(int pageNumber) async {
    print('[Polsat] 🔢 Starting exponential + binary search for max subpages...');
    
    // Fase 1: Ricerca esponenziale per trovare range (2, 4, 8, 16, 32...)
    int lower = 1;
    int upper = 2;
    
    while (await _checkSubpageExists(pageNumber, upper)) {
      print('[Polsat]   ✅ Subpage $upper exists, doubling...');
      lower = upper;
      upper *= 2;
      
      // Safety limit
      if (upper > 1000) {
        print('[Polsat]   ⚠️ Reached safety limit at 1000');
        upper = 1000;
        break;
      }
    }
    
    print('[Polsat]   📍 Range found: $lower - $upper');
    
    // Fase 2: Ricerca binaria nel range trovato
    while (lower < upper - 1) {
      final mid = (lower + upper) ~/ 2;
      
      if (await _checkSubpageExists(pageNumber, mid)) {
        print('[Polsat]   ✅ Subpage $mid exists, searching higher...');
        lower = mid;
      } else {
        print('[Polsat]   ❌ Subpage $mid not found, searching lower...');
        upper = mid;
      }
    }
    
    print('[Polsat] 🎯 Max subpages determined: $lower');
    return lower;
  }

  /// Verifica se una sottopagina specifica esiste
  Future<bool> _checkSubpageExists(int pageNumber, int subPage) async {
    try {
      final firstDigit = pageNumber.toString()[0];
      final subPagePadded = subPage.toString().padLeft(2, '0');
      final imagePath = '${firstDigit}00/${pageNumber}_00$subPagePadded.png';
      final polsatBaseUrl = 'http://gazetatvpolsat.pl/';
      final imageUrl = 'https://images.weserv.nl/?url=$polsatBaseUrl$imagePath&maxage=1d';
      
      final response = await _dio.head(
        imageUrl,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<int>> searchPages(String query) async {
    // Polsat non supporta ricerca testuale (canale basato su immagini)
    return [];
  }
}
