import 'package:shared_preferences/shared_preferences.dart';

/// Servizio per gestire la configurazione dell'OCR (Google Cloud Vision API)
class OcrConfigService {
  static const String _apiKeyPrefsKey = 'google_vision_api_key';
  
  /// Salva l'API key di Google Cloud Vision
  static Future<void> setGoogleVisionApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPrefsKey, apiKey);
    print('[OcrConfig] Google Vision API key saved');
  }
  
  /// Recupera l'API key di Google Cloud Vision
  static Future<String?> getGoogleVisionApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyPrefsKey);
    
    if (apiKey != null && apiKey.isNotEmpty) {
      print('[OcrConfig] Google Vision API key loaded from preferences');
      return apiKey;
    }
    
    // Fallback: prova a caricare da variabile d'ambiente (per sviluppo)
    // TODO: In produzione, potresti voler rimuovere questo o usare un file config
    print('[OcrConfig] No API key found in preferences');
    return null;
  }
  
  /// Rimuove l'API key salvata
  static Future<void> clearGoogleVisionApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyPrefsKey);
    print('[OcrConfig] Google Vision API key cleared');
  }
  
  /// Verifica se l'API key è configurata
  static Future<bool> hasApiKey() async {
    final apiKey = await getGoogleVisionApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }
}
