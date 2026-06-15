import 'package:dio/dio.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Stub OCR per simulatore iOS / build WebView (senza google_mlkit_text_recognition).
class MLKitPolsatOcrService {
  MLKitPolsatOcrService({Dio? dio});

  Future<List<ClickableArea>> extractClickableAreas({
    required String imageUrl,
    required int pageNumber,
  }) async {
    print('[MLKit OCR] Stub WebView/simulator - OCR disabilitato');
    return [];
  }
}
