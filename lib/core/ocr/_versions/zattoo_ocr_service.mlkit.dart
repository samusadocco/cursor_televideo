import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/ocr/ocr_cache_service.dart';

/// Servizio OCR per canali Zattoo usando ML Kit - VERSIONE DEVICE
/// Veloce, on-device, gratuito - solo per dispositivi fisici
class GoogleVisionOcrService {
  final Dio _dio;
  final TextRecognizer _textRecognizer;
  
  GoogleVisionOcrService({Dio? dio}) 
      : _dio = dio ?? Dio(),
        _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin) {
    print('[Zattoo OCR] 🚀 Using ML Kit (fast, device)');
  }

  /// Verifica se il servizio è disponibile
  Future<bool> get isAvailable async => true;

  /// Analizza l'immagine e restituisce sia i link cliccabili che le info sottopagine
  /// Versione ML Kit - veloce e on-device
  Future<Map<String, dynamic>> analyzeImage(
    Uint8List imageBytes,
    int currentPage,
  ) async {
    try {
      // Controlla la cache prima
      final cachedResult = await OcrCacheService.getCachedResults(
        imageBytes: imageBytes,
        pageNumber: currentPage,
      );
      
      if (cachedResult != null) {
        print('[Zattoo OCR ML Kit] ✅ Using cached results (${cachedResult['clickableAreas'].length} links)');
        return cachedResult;
      }

      print('[Zattoo OCR ML Kit] Starting ML Kit text detection for page $currentPage');
      final startTime = DateTime.now();

      // Salva l'immagine in un file temporaneo
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/ocr_temp_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(imageBytes);

      // Crea InputImage
      final inputImage = InputImage.fromFile(tempFile);

      // Esegui OCR con ML Kit
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // Pulisci file temporaneo
      await tempFile.delete();

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      print('[Zattoo OCR ML Kit] ⏱️ ML Kit completed in ${duration}ms');

      // Estrai link cliccabili
      final clickableAreas = _extractClickableLinks(recognizedText, currentPage);
      
      // Estrai info sottopagine
      final subPageInfo = _extractSubpageInfo(recognizedText);

      final result = {
        'clickableAreas': clickableAreas,
        'subPageInfo': subPageInfo,
      };

      // Salva in cache
      await OcrCacheService.cacheResults(
        imageBytes: imageBytes,
        pageNumber: currentPage,
        clickableAreas: clickableAreas,
        subPageInfo: subPageInfo,
      );

      print('[Zattoo OCR ML Kit] ✅ Extracted ${clickableAreas.length} links, cached for future use');
      
      return result;
    } catch (e, stackTrace) {
      print('[Zattoo OCR ML Kit] ❌ Error during OCR: $e');
      print('[Zattoo OCR ML Kit] Stack trace: $stackTrace');
      
      return {
        'clickableAreas': <ClickableArea>[],
        'subPageInfo': {'current': 1, 'total': 1},
      };
    }
  }

  /// Estrae link cliccabili dal testo riconosciuto
  List<ClickableArea> _extractClickableLinks(RecognizedText recognizedText, int currentPage) {
    final clickableAreas = <ClickableArea>[];
    final processedPages = <int>{};

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text;
        
        // Pattern per numeri di pagina (100-999)
        // Cerca numeri di 3 cifre separati da spazi, slash, trattino
        final pageMatches = RegExp(r'\b([1-9]\d{2})\b').allMatches(text);
        
        for (final match in pageMatches) {
          final pageNumStr = match.group(1);
          if (pageNumStr == null) continue;
          
          final pageNum = int.tryParse(pageNumStr);
          if (pageNum == null || pageNum < 100 || pageNum > 999) continue;
          if (pageNum == currentPage) continue; // Ignora numero pagina corrente
          if (processedPages.contains(pageNum)) continue; // Evita duplicati
          
          processedPages.add(pageNum);
          
          // Trova l'elemento che contiene questo numero
          for (final element in line.elements) {
            if (element.text.contains(pageNumStr)) {
              final rect = element.boundingBox;
              
              clickableAreas.add(ClickableArea(
                targetPage: pageNum,
                x: rect.left.toInt(),
                y: rect.top.toInt(),
                width: rect.width.toInt(),
                height: rect.height.toInt(),
                description: 'Pagina $pageNum',
              ));
              
              break;
            }
          }
        }
        
        // Gestisci pattern tipo "200/600" o "200-600" (due link separati)
        final rangeMatches = RegExp(r'\b([1-9]\d{2})[/-]([1-9]\d{2})\b').allMatches(text);
        for (final match in rangeMatches) {
          final page1 = int.tryParse(match.group(1) ?? '');
          final page2 = int.tryParse(match.group(2) ?? '');
          
          if (page1 != null && page1 >= 100 && page1 <= 999 && 
              page1 != currentPage && !processedPages.contains(page1)) {
            processedPages.add(page1);
            
            // Trova coordinate per il primo numero
            for (final element in line.elements) {
              if (element.text.contains(page1.toString())) {
                final rect = element.boundingBox;
                clickableAreas.add(ClickableArea(
                  targetPage: page1,
                  x: rect.left.toInt(),
                  y: rect.top.toInt(),
                  width: rect.width.toInt(),
                  height: rect.height.toInt(),
                  description: 'Pagina $page1',
                ));
                break;
              }
            }
          }
          
          if (page2 != null && page2 >= 100 && page2 <= 999 && 
              page2 != currentPage && !processedPages.contains(page2)) {
            processedPages.add(page2);
            
            // Trova coordinate per il secondo numero  
            for (final element in line.elements) {
              if (element.text.contains(page2.toString())) {
                final rect = element.boundingBox;
                clickableAreas.add(ClickableArea(
                  targetPage: page2,
                  x: rect.left.toInt(),
                  y: rect.top.toInt(),
                  width: rect.width.toInt(),
                  height: rect.height.toInt(),
                  description: 'Pagina $page2',
                ));
                break;
              }
            }
          }
        }
      }
    }

    print('[Zattoo OCR ML Kit] Found ${clickableAreas.length} clickable links');
    return clickableAreas;
  }

  /// Estrae info sottopagine dal testo
  Map<String, int> _extractSubpageInfo(RecognizedText recognizedText) {
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text;
        
        // Pattern: "1/4" o "01/04" o "1 / 4"
        final match = RegExp(r'(\d{1,2})\s*/\s*(\d{1,2})').firstMatch(text);
        if (match != null) {
          final current = int.tryParse(match.group(1) ?? '');
          final total = int.tryParse(match.group(2) ?? '');
          
          if (current != null && total != null && 
              current > 0 && total > 0 && 
              current <= total && total < 100) {
            return {'current': current, 'total': total};
          }
        }
      }
    }
    
    return {'current': 1, 'total': 1};
  }

  /// Pulisce le risorse
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}
