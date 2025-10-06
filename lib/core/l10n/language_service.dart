import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _isFirstLaunchKey = 'is_first_launch';
  
  final SharedPreferences _prefs;
  final _languageController = StreamController<Locale>.broadcast();

  Stream<Locale> get languageStream => _languageController.stream;

  LanguageService(this._prefs);

  /// Ottiene la lingua attualmente selezionata
  Future<Locale> getSelectedLocale() async {
    // Al primo avvio, imposta la lingua di sistema se supportata, altrimenti inglese
    final isFirstLaunch = _prefs.getBool(_isFirstLaunchKey) ?? true;
    if (isFirstLaunch) {
      final deviceLocale = _getDeviceLocale();
      await _prefs.setString(_languageKey, deviceLocale.languageCode);
      await _prefs.setBool(_isFirstLaunchKey, false);
      return deviceLocale;
    }

    final languageCode = _prefs.getString(_languageKey) ?? 'en';
    return Locale(languageCode);
  }

  /// Imposta la lingua selezionata
  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_languageKey, locale.languageCode);
    await _prefs.setBool(_isFirstLaunchKey, false);
    _languageController.add(locale);
  }

  /// Ottiene la lingua del dispositivo
  Locale _getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final languageCode = deviceLocale.languageCode.toLowerCase();
    
    // Verifica se la lingua del dispositivo è supportata
    if (_isSupportedLanguage(languageCode)) {
      return Locale(languageCode);
    }
    
    // Se la lingua non è supportata, usa l'inglese come fallback
    return const Locale('en');
  }

  /// Verifica se una lingua è supportata
  bool _isSupportedLanguage(String languageCode) {
    return ['it', 'en', 'de', 'fr', 'es', 'pt', 'nl', 'da', 
            'sv', 'fi', 'cs', 'hr', 'sl', 'is', 'hu', 'bs']
        .contains(languageCode);
  }

  void dispose() {
    _languageController.close();
  }
}
