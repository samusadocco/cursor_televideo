import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/config/ocr_config_service.dart';
import 'package:cursor_televideo/core/ocr/ocr_cache_service.dart';
import 'package:image/image.dart' as img;

/// Servizio OCR basato su Google Cloud Vision API
/// Più affidabile e compatibile con tutti i dispositivi (cloud-based)
class GoogleVisionOcrService {
  final Dio _dio;
  static const String _visionApiUrl = 
      'https://vision.googleapis.com/v1/images:annotate';
  
  String? _apiKey;
  bool _apiKeyInitialized = false;
  
  GoogleVisionOcrService({Dio? dio}) : _dio = dio ?? Dio();
  
  /// Inizializza l'API key caricandola dalla configurazione
  Future<void> _ensureApiKeyInitialized() async {
    if (_apiKeyInitialized) return;
    
    _apiKey = await OcrConfigService.getGoogleVisionApiKey();
    _apiKeyInitialized = true;
    
    if (_apiKey != null && _apiKey!.isNotEmpty) {
      print('[GoogleVisionOCR] API key loaded from configuration');
    } else {
      print('[GoogleVisionOCR] No API key configured');
    }
  }
  
  /// Imposta l'API key di Google Cloud Vision manualmente
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
    _apiKeyInitialized = true;
  }
  
  /// Verifica se il servizio è disponibile (ha API key configurata)
  Future<bool> get isAvailable async {
    await _ensureApiKeyInitialized();
    return _apiKey != null && _apiKey!.isNotEmpty;
  }
  
  /// Ottimizza l'immagine con solo compressione JPEG (no ridimensionamento)
  /// Riduce peso file del ~30-40% mantenendo qualità OCR perfetta → API più veloce!
  Uint8List _optimizeImage(Uint8List imageBytes) {
    try {
      // Decodifica l'immagine
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return imageBytes;
      }
      
      final originalSize = imageBytes.length;
      
      // NO ridimensionamento - mantieni dimensione originale
      // Solo compressione JPEG qualità 98 (quasi perfetta per OCR)
      final compressed = img.encodeJpg(image, quality: 98);
      
      final newSize = compressed.length;
      final reduction = ((1 - newSize / originalSize) * 100).toStringAsFixed(1);
      
      if (newSize < originalSize) {
        print('[GoogleVisionOCR] 🗜️ Compressed: ${originalSize}B → ${newSize}B (-$reduction%)');
        return Uint8List.fromList(compressed);
      } else {
        // Se compresso è più grande, usa originale
        return imageBytes;
      }
    } catch (e) {
      return imageBytes;
    }
  }

  /// Analizza l'immagine e restituisce sia i link cliccabili che le info sottopagine
  /// Più efficiente perché fa una sola chiamata API invece di due
  /// Include cache per evitare chiamate ripetute alla stessa pagina
  Future<Map<String, dynamic>> analyzeImage(
    Uint8List imageBytes,
    int currentPage,
  ) async {
    await _ensureApiKeyInitialized();
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      print('[GoogleVisionOCR] ⚠️ API key not configured');
      return {
        'clickableAreas': <ClickableArea>[],
        'subPageInfo': {'current': 1, 'total': 1},
      };
    }
    
    try {
      // Controlla la cache prima di chiamare l'API
      final cachedResult = await OcrCacheService.getCachedResults(
        imageBytes: imageBytes,
        pageNumber: currentPage,
      );
      
      if (cachedResult != null) {
        return cachedResult;
      }
      
      print('[GoogleVisionOCR] Analyzing page $currentPage...');
      
      // Usa immagine originale (ottimizzazione disabilitata per massima accuratezza OCR)
      final optimizedBytes = imageBytes;
      
      // Converti l'immagine in base64
      final base64Image = base64Encode(optimizedBytes);
      
      // Prepara la richiesta per Google Vision API
      final requestBody = {
        'requests': [
          {
            'image': {
              'content': base64Image,
            },
            'features': [
              {
                'type': 'TEXT_DETECTION',
                'maxResults': 30, // Ridotto da 50 a 30 per velocità
              }
            ],
          }
        ]
      };
      
      // Chiamata API
      final response = await _dio.post(
        '$_visionApiUrl?key=$_apiKey',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Google Vision API timeout'),
      );
      
      if (response.statusCode != 200) {
        print('[GoogleVisionOCR] ❌ API error: ${response.statusCode}');
        return {
          'clickableAreas': <ClickableArea>[],
          'subPageInfo': {'current': 1, 'total': 1},
        };
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final responses = responseData['responses'] as List<dynamic>;
      
      if (responses.isEmpty) {
        print('[GoogleVisionOCR] No text detected');
        return {
          'clickableAreas': <ClickableArea>[],
          'subPageInfo': {'current': 1, 'total': 1},
        };
      }
      
      final textAnnotations = responses[0]['textAnnotations'] as List<dynamic>?;
      
      if (textAnnotations == null || textAnnotations.isEmpty) {
        print('[GoogleVisionOCR] No text annotations found');
        return {
          'clickableAreas': <ClickableArea>[],
          'subPageInfo': {'current': 1, 'total': 1},
        };
      }
      
      // Il primo elemento contiene tutto il testo
      final fullText = textAnnotations[0]['description'] as String;
      
      // Trova i link cliccabili (numeri a 3 cifre)
      // Usa pattern più permissivo che trova numeri anche in "200/600"
      final clickableAreas = <ClickableArea>[];
      final pageNumberPattern = RegExp(r'(?<!\d)[1-9]\d{2}(?!\d)');
      final matches = pageNumberPattern.allMatches(fullText);
      
      for (final match in matches) {
        final pageNum = int.tryParse(match.group(0)!);
        
        if (pageNum != null && 
            pageNum != currentPage && 
            pageNum >= 100 && 
            pageNum <= 999) {
          
          final result = _findAnnotationForText(
            match.group(0)!,
            textAnnotations.skip(1).toList(),
          );
          
          if (result != null) {
            final annotation = result['annotation'] as Map<String, dynamic>;
            final fullText = result['fullText'] as String;
            final matchedNumber = match.group(0)!;
            
            final bounds = annotation['boundingPoly']['vertices'] as List<dynamic>;
            double x = (bounds[0]['x'] as num?)?.toDouble() ?? 0;
            final y = (bounds[0]['y'] as num?)?.toDouble() ?? 0;
            double width = ((bounds[1]['x'] as num?)?.toDouble() ?? 0) - x;
            final height = ((bounds[2]['y'] as num?)?.toDouble() ?? 0) - y;
            
            // Se il numero è stato trovato in una stringa composta (es. "200/600"),
            // calcola coordinate approssimative per il numero specifico
            if (fullText != matchedNumber && fullText.contains(matchedNumber)) {
              final numberIndex = fullText.indexOf(matchedNumber);
              final totalChars = fullText.length;
              final charWidth = width / totalChars;
              
              // Aggiusta x e width per isolare il numero
              x += (numberIndex * charWidth);
              width = matchedNumber.length * charWidth;
              
              print('[GoogleVisionOCR] Adjusted coordinates for "$matchedNumber" in "$fullText"');
            }
            
            clickableAreas.add(ClickableArea(
              targetPage: pageNum,
              x: x.round(),
              y: y.round(),
              width: width.round(),
              height: height.round(),
              description: 'Pagina $pageNum',
            ));
          } else {
            clickableAreas.add(ClickableArea(
              targetPage: pageNum,
              x: 100,
              y: 100 + (clickableAreas.length * 30),
              width: 80,
              height: 25,
              description: 'Pagina $pageNum',
            ));
          }
        }
      }
      
      print('[GoogleVisionOCR] ✅ Found ${clickableAreas.length} page links');
      
      final result = {
        'clickableAreas': clickableAreas,
      };
      
      // Salva in cache per utilizzi futuri (solo i link, non le sottopagine)
      await OcrCacheService.cacheResults(
        imageBytes: imageBytes,
        pageNumber: currentPage,
        clickableAreas: clickableAreas,
        subPageInfo: {'current': 1, 'total': 1}, // Non più usato
      );
      
      return result;
      
    } catch (e, stackTrace) {
      print('[GoogleVisionOCR] ❌ Error: $e');
      print('[GoogleVisionOCR] Stack trace: $stackTrace');
      return {
        'clickableAreas': <ClickableArea>[],
        'subPageInfo': {'current': 1, 'total': 1},
      };
    }
  }

  /// Trova link cliccabili (numeri di pagina a 3 cifre) nell'immagine
  /// DEPRECATO: Usa analyzeImage() invece (più efficiente, 1 sola chiamata API)
  @Deprecated('Use analyzeImage() instead')
  Future<List<ClickableArea>> findClickableLinks(
    Uint8List imageBytes,
    int currentPage,
  ) async {
    await _ensureApiKeyInitialized();
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      print('[GoogleVisionOCR] ⚠️ API key not configured');
      return [];
    }
    
    try {
      print('[GoogleVisionOCR] Starting text detection for page $currentPage');
      
      // Converti l'immagine in base64
      final base64Image = base64Encode(imageBytes);
      
      // Prepara la richiesta per Google Vision API
      final requestBody = {
        'requests': [
          {
            'image': {
              'content': base64Image,
            },
            'features': [
              {
                'type': 'TEXT_DETECTION',
                'maxResults': 50,
              }
            ],
          }
        ]
      };
      
      // Chiamata API
      final response = await _dio.post(
        '$_visionApiUrl?key=$_apiKey',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Google Vision API timeout'),
      );
      
      if (response.statusCode != 200) {
        print('[GoogleVisionOCR] ❌ API error: ${response.statusCode}');
        return [];
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final responses = responseData['responses'] as List<dynamic>;
      
      if (responses.isEmpty) {
        print('[GoogleVisionOCR] No text detected');
        return [];
      }
      
      final textAnnotations = responses[0]['textAnnotations'] as List<dynamic>?;
      
      if (textAnnotations == null || textAnnotations.isEmpty) {
        print('[GoogleVisionOCR] No text annotations found');
        return [];
      }
      
      // Il primo elemento contiene tutto il testo
      final fullText = textAnnotations[0]['description'] as String;
      print('[GoogleVisionOCR] Full text detected: ${fullText.substring(0, fullText.length > 100 ? 100 : fullText.length)}...');
      
      // Trova tutti i numeri di pagina a 3 cifre
      final clickableAreas = <ClickableArea>[];
      final pageNumberPattern = RegExp(r'\b[1-9]\d{2}\b');
      final matches = pageNumberPattern.allMatches(fullText);
      
      for (final match in matches) {
        final pageNum = int.tryParse(match.group(0)!);
        if (pageNum != null && 
            pageNum != currentPage && 
            pageNum >= 100 && 
            pageNum <= 999) {
          
          // Cerca questo numero specifico nelle annotazioni per ottenere coordinate
          final annotation = _findAnnotationForText(
            match.group(0)!,
            textAnnotations.skip(1).toList(), // Salta il primo (full text)
          );
          
          if (annotation != null) {
            final bounds = annotation['boundingPoly']['vertices'] as List<dynamic>;
            final x = (bounds[0]['x'] as num?)?.toDouble() ?? 0;
            final y = (bounds[0]['y'] as num?)?.toDouble() ?? 0;
            final width = ((bounds[1]['x'] as num?)?.toDouble() ?? 0) - x;
            final height = ((bounds[2]['y'] as num?)?.toDouble() ?? 0) - y;
            
            clickableAreas.add(ClickableArea(
              targetPage: pageNum,
              x: x.round(),
              y: y.round(),
              width: width.round(),
              height: height.round(),
              description: 'Pagina $pageNum',
            ));
          } else {
            // Fallback senza coordinate precise
            clickableAreas.add(ClickableArea(
              targetPage: pageNum,
              x: 100,
              y: 100 + (clickableAreas.length * 30),
              width: 80,
              height: 25,
              description: 'Pagina $pageNum',
            ));
          }
        }
      }
      
      print('[GoogleVisionOCR] ✅ Found ${clickableAreas.length} page links');
      return clickableAreas;
      
    } catch (e, stackTrace) {
      print('[GoogleVisionOCR] ❌ Error: $e');
      print('[GoogleVisionOCR] Stack trace: $stackTrace');
      return [];
    }
  }
  
  /// Estrae informazioni sulle sottopagine (formato: "1/3", "2/5", etc.)
  /// DEPRECATO: Usa analyzeImage() invece (più efficiente, 1 sola chiamata API)
  @Deprecated('Use analyzeImage() instead')
  Future<Map<String, int>> extractSubpageInfo(Uint8List imageBytes) async {
    await _ensureApiKeyInitialized();
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      return {'current': 1, 'total': 1};
    }
    
    try {
      // Converti l'immagine in base64
      final base64Image = base64Encode(imageBytes);
      
      // Richiesta API
      final requestBody = {
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [
              {'type': 'TEXT_DETECTION', 'maxResults': 10}
            ],
          }
        ]
      };
      
      final response = await _dio.post(
        '$_visionApiUrl?key=$_apiKey',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      ).timeout(const Duration(seconds: 8));
      
      if (response.statusCode != 200) {
        return {'current': 1, 'total': 1};
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final responses = responseData['responses'] as List<dynamic>;
      
      if (responses.isEmpty) {
        return {'current': 1, 'total': 1};
      }
      
      final textAnnotations = responses[0]['textAnnotations'] as List<dynamic>?;
      
      if (textAnnotations == null || textAnnotations.isEmpty) {
        return {'current': 1, 'total': 1};
      }
      
      final fullText = textAnnotations[0]['description'] as String;
      
      // Cerca pattern tipo "1/3", "2/5", etc.
      final subpagePattern = RegExp(r'(\d+)\s*/\s*(\d+)');
      final match = subpagePattern.firstMatch(fullText);
      
      if (match != null) {
        final current = int.tryParse(match.group(1)!) ?? 1;
        final total = int.tryParse(match.group(2)!) ?? 1;
        print('[GoogleVisionOCR] Subpage info: $current/$total');
        return {'current': current, 'total': total};
      }
      
      return {'current': 1, 'total': 1};
      
    } catch (e) {
      print('[GoogleVisionOCR] Error extracting subpage info: $e');
      return {'current': 1, 'total': 1};
    }
  }
  
  /// Trova l'annotazione specifica per un testo
  /// Trova l'annotation per un testo specifico
  /// Restituisce un Map con 'annotation' e 'fullText' per permettere calcolo coordinate
  Map<String, dynamic>? _findAnnotationForText(
    String text,
    List<dynamic> annotations,
  ) {
    // Prima prova match esatto
    for (final annotation in annotations) {
      final description = annotation['description'] as String?;
      if (description == text) {
        return {
          'annotation': annotation as Map<String, dynamic>,
          'fullText': description,
        };
      }
    }
    
    // Se non trova match esatto, cerca il numero all'interno di stringhe tipo "200/600" o "200-600"
    // Usa regex per verificare che sia un numero isolato (non parte di un numero più grande)
    final numberPattern = RegExp('(?<![\\d])$text(?![\\d])');
    for (final annotation in annotations) {
      final description = annotation['description'] as String?;
      if (description != null && numberPattern.hasMatch(description)) {
        print('[GoogleVisionOCR] Found "$text" inside "$description"');
        return {
          'annotation': annotation as Map<String, dynamic>,
          'fullText': description,
        };
      }
    }
    
    return null;
  }
  
  void dispose() {
    _dio.close();
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}
