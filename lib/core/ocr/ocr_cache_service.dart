import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:crypto/crypto.dart';

/// Servizio per cachare i risultati OCR e ridurre le chiamate API
class OcrCacheService {
  static const String _cachePrefix = 'ocr_cache_';
  static const int _maxCacheAgeHours = 24; // Cache valida per 24 ore
  
  /// Genera una chiave cache dall'hash dell'immagine
  static String _getCacheKey(List<int> imageBytes, int pageNumber) {
    // Usa hash dell'immagine per garantire che cache sia valida solo per la stessa immagine
    final imageHash = md5.convert(imageBytes).toString();
    return '$_cachePrefix${pageNumber}_$imageHash';
  }
  
  /// Salva i risultati OCR nella cache
  static Future<void> cacheResults({
    required List<int> imageBytes,
    required int pageNumber,
    required List<ClickableArea> clickableAreas,
    required Map<String, int> subPageInfo,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getCacheKey(imageBytes, pageNumber);
      
      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'pageNumber': pageNumber,
        'clickableAreas': clickableAreas.map((area) => {
          'targetPage': area.targetPage,
          'x': area.x,
          'y': area.y,
          'width': area.width,
          'height': area.height,
          'description': area.description,
        }).toList(),
        'subPageInfo': subPageInfo,
      };
      
      await prefs.setString(key, jsonEncode(cacheData));
      print('[OcrCache] ✅ Cached results for page $pageNumber (${clickableAreas.length} links)');
    } catch (e) {
      print('[OcrCache] ⚠️ Error caching results: $e');
    }
  }
  
  /// Recupera i risultati OCR dalla cache (se validi)
  static Future<Map<String, dynamic>?> getCachedResults({
    required List<int> imageBytes,
    required int pageNumber,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getCacheKey(imageBytes, pageNumber);
      final cachedJson = prefs.getString(key);
      
      if (cachedJson == null) {
        print('[OcrCache] Cache miss for page $pageNumber');
        return null;
      }
      
      final cacheData = jsonDecode(cachedJson) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      final ageHours = age / (1000 * 60 * 60);
      
      // Verifica se la cache è ancora valida
      if (ageHours > _maxCacheAgeHours) {
        print('[OcrCache] Cache expired for page $pageNumber (age: ${ageHours.toStringAsFixed(1)}h)');
        await prefs.remove(key); // Rimuovi cache scaduta
        return null;
      }
      
      // Ricostruisci gli oggetti dalle mappe
      final clickableAreasData = cacheData['clickableAreas'] as List<dynamic>;
      final clickableAreas = clickableAreasData.map((areaData) {
        final area = areaData as Map<String, dynamic>;
        return ClickableArea(
          targetPage: area['targetPage'] as int,
          x: area['x'] as int,
          y: area['y'] as int,
          width: area['width'] as int,
          height: area['height'] as int,
          description: area['description'] as String?,
        );
      }).toList();
      
      final subPageInfo = Map<String, int>.from(cacheData['subPageInfo'] as Map);
      
      print('[OcrCache] ✅ Cache hit for page $pageNumber (age: ${ageHours.toStringAsFixed(1)}h, ${clickableAreas.length} links)');
      
      return {
        'clickableAreas': clickableAreas,
        'subPageInfo': subPageInfo,
      };
    } catch (e) {
      print('[OcrCache] ⚠️ Error reading cache: $e');
      return null;
    }
  }
  
  /// Pulisce la cache scaduta
  static Future<void> cleanExpiredCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      int removed = 0;
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          final cachedJson = prefs.getString(key);
          if (cachedJson != null) {
            try {
              final cacheData = jsonDecode(cachedJson) as Map<String, dynamic>;
              final timestamp = cacheData['timestamp'] as int;
              final age = DateTime.now().millisecondsSinceEpoch - timestamp;
              final ageHours = age / (1000 * 60 * 60);
              
              if (ageHours > _maxCacheAgeHours) {
                await prefs.remove(key);
                removed++;
              }
            } catch (e) {
              // Cache corrotta, rimuovi
              await prefs.remove(key);
              removed++;
            }
          }
        }
      }
      
      if (removed > 0) {
        print('[OcrCache] Cleaned $removed expired cache entries');
      }
    } catch (e) {
      print('[OcrCache] Error cleaning cache: $e');
    }
  }
  
  /// Pulisce tutta la cache OCR
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      int removed = 0;
      
      for (final key in keys) {
        if (key.startsWith(_cachePrefix)) {
          await prefs.remove(key);
          removed++;
        }
      }
      
      print('[OcrCache] Cleared all cache ($removed entries)');
    } catch (e) {
      print('[OcrCache] Error clearing cache: $e');
    }
  }
}
