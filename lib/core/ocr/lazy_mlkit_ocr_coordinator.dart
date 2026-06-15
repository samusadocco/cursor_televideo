import 'dart:convert';
import 'dart:typed_data';

import 'package:cursor_televideo/core/ocr/google_vision_ocr_service.dart';
import 'package:cursor_televideo/core/ocr/mlkit_polsat_ocr_service.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Motori OCR lazy supportati (entrambi ML Kit on-device).
enum LazyOcrEngine {
  polsat,
  zattoo,
}

LazyOcrEngine? lazyOcrEngineFromMetadata(Map<String, dynamic>? metadata) {
  final value = metadata?['lazyOcrEngine']?.toString();
  switch (value) {
    case 'zattoo':
      return LazyOcrEngine.zattoo;
    case 'polsat':
      return LazyOcrEngine.polsat;
    default:
      return null;
  }
}

/// Arricchisce le aree cliccabili con OCR ML Kit in background.
class LazyMlkitOcrCoordinator {
  LazyMlkitOcrCoordinator._();

  static final LazyMlkitOcrCoordinator instance = LazyMlkitOcrCoordinator._();

  final MLKitPolsatOcrService _polsatOcrService = MLKitPolsatOcrService();
  final GoogleVisionOcrService _zattooOcrService = GoogleVisionOcrService();
  final Map<String, List<ClickableArea>> _cache = {};

  Future<List<ClickableArea>> enrich({
    required LazyOcrEngine engine,
    required String? providerId,
    required List<ClickableArea> existingAreas,
    required String imageUrl,
    required int pageNumber,
    required int subPage,
  }) async {
    final cacheKey = '${providerId ?? engine.name}-$pageNumber-$subPage';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final merged = List<ClickableArea>.from(existingAreas);
    final coveredTargets = existingAreas.map((area) => area.targetPage).toSet();

    final ocrStart = DateTime.now();
    print(
      '[LazyOCR] Starting background ${engine.name} OCR for '
      '$providerId page $pageNumber/$subPage',
    );

    try {
      final ocrAreas = await _runOcr(
        engine: engine,
        imageUrl: imageUrl,
        pageNumber: pageNumber,
      );

      var added = 0;
      for (final area in ocrAreas) {
        if (coveredTargets.add(area.targetPage)) {
          merged.add(area);
          added++;
        }
      }

      final ocrDuration = DateTime.now().difference(ocrStart).inMilliseconds;
      print(
        '[LazyOCR] ${engine.name} completed in ${ocrDuration}ms: '
        '${ocrAreas.length} detected, $added added (${existingAreas.length} existing)',
      );
    } catch (e) {
      print('[LazyOCR] ${engine.name} failed, keeping existing areas: $e');
    }

    _cache[cacheKey] = merged;
    return merged;
  }

  Future<List<ClickableArea>> _runOcr({
    required LazyOcrEngine engine,
    required String imageUrl,
    required int pageNumber,
  }) async {
    switch (engine) {
      case LazyOcrEngine.polsat:
        return _polsatOcrService.extractClickableAreas(
          imageUrl: imageUrl,
          pageNumber: pageNumber,
        );
      case LazyOcrEngine.zattoo:
        final imageBytes = _decodeDataUri(imageUrl);
        if (imageBytes == null) {
          throw Exception('Invalid data URI for Zattoo lazy OCR');
        }
        final result = await _zattooOcrService.analyzeImage(imageBytes, pageNumber);
        return result['clickableAreas'] as List<ClickableArea>;
    }
  }

  Uint8List? _decodeDataUri(String imageUrl) {
    if (!imageUrl.startsWith('data:image/') || !imageUrl.contains(',')) {
      return null;
    }
    return base64Decode(imageUrl.split(',')[1]);
  }

  void invalidate({String? providerId, required int pageNumber, required int subPage}) {
    _cache.remove('${providerId ?? 'polsat'}-$pageNumber-$subPage');
    _cache.remove('${providerId ?? 'zattoo'}-$pageNumber-$subPage');
  }
}

/// Alias per compatibilità con codice esistente.
typedef LazyPolsatOcrCoordinator = LazyMlkitOcrCoordinator;
