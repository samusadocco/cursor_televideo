import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:flutter/foundation.dart';

/// Servizio OCR veloce per Polsat usando ML Kit (on-device, gratuito)
class MLKitPolsatOcrService {
  final Dio _dio;
  final TextRecognizer? _textRecognizer;
  final bool _isSimulator;

  MLKitPolsatOcrService({Dio? dio})
      : _dio = dio ?? Dio(),
        _isSimulator = _shouldDisableOCR(),
        _textRecognizer = _initializeTextRecognizer() {
    if (_isSimulator) {
      print('[MLKit OCR] ⚠️ OCR disabled - running without clickable links');
    }
  }

  /// Inizializza TextRecognizer con fallback per simulatore
  static TextRecognizer? _initializeTextRecognizer() {
    if (_shouldDisableOCR()) {
      return null;
    }
    
    try {
      return TextRecognizer(script: TextRecognitionScript.latin);
    } catch (e) {
      print('[MLKit OCR] ⚠️ Failed to initialize TextRecognizer: $e');
      return null;
    }
  }

  /// Determina se l'OCR deve essere disabilitato
  /// Controlla: override manuale, simulatore, o kDebugMode
  static bool _shouldDisableOCR() {
    // Override manuale via dart-define
    const enableOcr = String.fromEnvironment('ENABLE_OCR', defaultValue: 'auto');
    
    if (enableOcr == 'false') {
      print('[MLKit OCR] 🔧 OCR manually disabled via --dart-define=ENABLE_OCR=false');
      return true;
    }
    
    if (enableOcr == 'true') {
      print('[MLKit OCR] 🔧 OCR manually enabled via --dart-define=ENABLE_OCR=true');
      return false;
    }
    
    // Auto-detect: disabilita su simulatore iOS
    if (!Platform.isIOS) return false;
    
    // Metodo 1: Variabili d'ambiente del simulatore
    final environment = Platform.environment;
    if (environment['SIMULATOR_DEVICE_NAME'] != null || 
        environment['SIMULATOR_UDID'] != null) {
      print('[MLKit OCR] 🔍 iOS Simulator detected - OCR auto-disabled');
      return true;
    }
    
    // Metodo 2: Controlla se Platform.version contiene "Simulator"
    if (Platform.version.toLowerCase().contains('simulator')) {
      print('[MLKit OCR] 🔍 iOS Simulator detected - OCR auto-disabled');
      return true;
    }
    
    return false;
  }

  /// Estrae link cliccabili da un'immagine Polsat usando ML Kit OCR
  Future<List<ClickableArea>> extractClickableAreas({
    required String imageUrl,
    required int pageNumber,
  }) async {
    // Su simulatore iOS, ritorna lista vuota (ML Kit non supportato)
    if (_isSimulator) {
      print('[MLKit OCR] ⚠️ Skipping OCR on iOS Simulator - returning empty list');
      return [];
    }

    final startTime = DateTime.now();
    print('[MLKit OCR] 🚀 Starting extraction from: $imageUrl');

    try {
      // Step 1: Scarica l'immagine
      final downloadStart = DateTime.now();
      final tempFile = await _downloadImage(imageUrl);
      final downloadDuration = DateTime.now().difference(downloadStart).inMilliseconds;
      print('[MLKit OCR] ⏱️ Image downloaded in ${downloadDuration}ms');

      // Step 2: Esegui OCR con ML Kit
      final ocrStart = DateTime.now();
      final inputImage = InputImage.fromFilePath(tempFile.path);
      final recognizedText = await _textRecognizer!.processImage(inputImage);
      final ocrDuration = DateTime.now().difference(ocrStart).inMilliseconds;
      print('[MLKit OCR] ⏱️ OCR completed in ${ocrDuration}ms, found ${recognizedText.blocks.length} text blocks');

      // Step 3: Cerca numeri a 3 cifre (pagine 100-999)
      final clickableAreas = _extractPageNumbers(recognizedText);
      
      // Cleanup
      await tempFile.delete();

      final totalDuration = DateTime.now().difference(startTime).inMilliseconds;
      print('[MLKit OCR] ✅ Total extraction time: ${totalDuration}ms, found ${clickableAreas.length} clickable areas');

      return clickableAreas;
    } catch (e) {
      print('[MLKit OCR] ❌ Error: $e');
      rethrow;
    }
  }

  /// Scarica l'immagine in un file temporaneo
  Future<File> _downloadImage(String imageUrl) async {
    final response = await _dio.get<Uint8List>(
      imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/polsat_ocr_${DateTime.now().millisecondsSinceEpoch}.png');
    await tempFile.writeAsBytes(response.data!);

    return tempFile;
  }

  /// Estrae numeri di pagina (100-999) dal testo riconosciuto
  List<ClickableArea> _extractPageNumbers(RecognizedText recognizedText) {
    final clickableAreas = <ClickableArea>[];
    final pageNumberPattern = RegExp(r'\b([1-9]\d{2})\b'); // Numeri a 3 cifre (100-999)

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text;
        final matches = pageNumberPattern.allMatches(text);

        for (final match in matches) {
          final pageNumberStr = match.group(1);
          if (pageNumberStr == null) continue;

          final pageNumber = int.tryParse(pageNumberStr);
          if (pageNumber == null || pageNumber < 100 || pageNumber > 999) continue;

          // Usa bounding box della linea come area cliccabile
          final boundingBox = line.boundingBox;
          
          // Le coordinate ML Kit sono già nell'orientamento corretto dell'immagine
          // Immagine Polsat: 480x336
          // ML Kit restituisce coordinate assolute nell'immagine
          
          clickableAreas.add(ClickableArea(
            targetPage: pageNumber,
            x: boundingBox.left.toInt(),
            y: boundingBox.top.toInt(),
            width: boundingBox.width.toInt(),
            height: boundingBox.height.toInt(),
            description: 'Pagina $pageNumber',
          ));

          print('[MLKit OCR] ✅ Found page $pageNumber at (${boundingBox.left.toInt()},${boundingBox.top.toInt()}) size ${boundingBox.width.toInt()}x${boundingBox.height.toInt()}');
        }
      }
    }

    return clickableAreas;
  }

  /// Libera risorse
  Future<void> dispose() async {
    if (_textRecognizer != null) {
      await _textRecognizer!.close();
    }
  }
}
