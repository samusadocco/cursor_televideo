import 'dart:io';

/// Servizio per rilevare il paese dell'utente
class CountryDetector {
  static CountryDetector? _instance;
  
  CountryDetector._();
  
  static CountryDetector get instance {
    _instance ??= CountryDetector._();
    return _instance!;
  }
  
  String? _cachedCountryCode;
  
  /// Ottiene il codice paese dell'utente (es. 'IT', 'DE', 'FR')
  /// 
  /// Usa la localizzazione del dispositivo (Platform.localeName)
  /// Esempio: 'it_IT' → 'IT', 'en_US' → 'US', 'de_DE' → 'DE'
  /// 
  /// NON usa GPS o geolocalizzazione! Usa solo il locale del sistema.
  /// Restituisce null se non è possibile rilevare il paese
  String? getUserCountryCode() {
    print('[CountryDetector] ===== INIZIO RILEVAMENTO PAESE =====');
    
    // Usa la cache se disponibile
    if (_cachedCountryCode != null) {
      print('[CountryDetector] ✅ Usando cache: $_cachedCountryCode');
      return _cachedCountryCode;
    }
    
    try {
      // Usa il locale di sistema di Flutter
      final locale = Platform.localeName; // es. 'it_IT', 'en_US', 'de_DE'
      print('[CountryDetector] 📱 Device locale dal sistema: "$locale"');
      
      if (locale.contains('_')) {
        final parts = locale.split('_');
        print('[CountryDetector] 🔍 Parti divise per "_": $parts');
        if (parts.length >= 2) {
          _cachedCountryCode = parts[1].toUpperCase(); // es. 'IT', 'US', 'DE'
          print('[CountryDetector] ✅ PAESE RILEVATO: "$_cachedCountryCode" da locale "$locale"');
          print('[CountryDetector] ===== FINE RILEVAMENTO PAESE =====');
          return _cachedCountryCode;
        }
      }
      
      // Se il locale non contiene '_', prova con '-' (es. 'en-US')
      if (locale.contains('-')) {
        final parts = locale.split('-');
        print('[CountryDetector] 🔍 Parti divise per "-": $parts');
        if (parts.length >= 2) {
          _cachedCountryCode = parts[1].toUpperCase();
          print('[CountryDetector] ✅ PAESE RILEVATO: "$_cachedCountryCode" da locale "$locale"');
          print('[CountryDetector] ===== FINE RILEVAMENTO PAESE =====');
          return _cachedCountryCode;
        }
      }
      
      print('[CountryDetector] ⚠️ Formato locale non riconosciuto: "$locale"');
    } catch (e) {
      print('[CountryDetector] ❌ ERRORE durante rilevamento: $e');
    }
    
    print('[CountryDetector] ⚠️ Nessun paese rilevato, ritorno null');
    print('[CountryDetector] ===== FINE RILEVAMENTO PAESE =====');
    return null;
  }
  
  /// Resetta la cache del paese
  void resetCache() {
    _cachedCountryCode = null;
  }
}

