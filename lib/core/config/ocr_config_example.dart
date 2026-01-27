/// ESEMPIO: Come configurare Google Cloud Vision API key
/// 
/// Copia questo codice nel tuo main.dart per configurare l'API key temporaneamente
/// durante lo sviluppo/testing.
/// 
/// Per produzione, crea una UI nelle impostazioni dove l'utente può inserire
/// la propria API key.

import 'package:cursor_televideo/core/config/ocr_config_service.dart';

/// Configura l'API key di Google Cloud Vision per OCR
/// Chiamare prima di avviare l'app
Future<void> configureOcrApiKey() async {
  // SOSTITUISCI CON LA TUA API KEY
  const apiKey = 'YOUR_GOOGLE_CLOUD_VISION_API_KEY_HERE';
  
  // Salva l'API key
  await OcrConfigService.setGoogleVisionApiKey(apiKey);
  
  print('[Config] Google Vision API key configured');
}

/// Esempio di utilizzo nel main.dart:
/// 
/// ```dart
/// import 'package:cursor_televideo/core/config/ocr_config_example.dart';
/// 
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Configura OCR (solo per testing)
///   await configureOcrApiKey();
///   
///   // ... resto dell'inizializzazione ...
///   
///   runApp(MyApp());
/// }
/// ```

/// Per verificare se l'API key è configurata:
Future<void> checkOcrConfiguration() async {
  final hasKey = await OcrConfigService.hasApiKey();
  if (hasKey) {
    print('[Config] ✅ Google Vision API key is configured');
  } else {
    print('[Config] ⚠️ Google Vision API key is NOT configured');
    print('[Config] OCR will be disabled for image-based teletext (ARTE)');
  }
}

/// Per rimuovere l'API key:
Future<void> clearOcrConfiguration() async {
  await OcrConfigService.clearGoogleVisionApiKey();
  print('[Config] Google Vision API key removed');
}
