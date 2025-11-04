import 'package:shared_preferences/shared_preferences.dart';

/// Servizio per gestire il primo avvio dell'applicazione
class FirstLaunchService {
  static const String _firstLaunchKey = 'channel_selection_first_launch'; // Chiave separata da LanguageService
  static const String _initialChannelSelectedKey = 'initial_channel_selected';
  static const String _initialChannelIdKey = 'initial_channel_id'; // Salva l'ID del canale iniziale

  final SharedPreferences _prefs;

  FirstLaunchService(this._prefs);

  /// Verifica se è il primo avvio dell'applicazione
  bool isFirstLaunch() {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Verifica se l'utente ha già selezionato il canale iniziale
  bool hasSelectedInitialChannel() {
    return _prefs.getBool(_initialChannelSelectedKey) ?? false;
  }

  /// Marca il primo avvio come completato
  Future<void> markFirstLaunchComplete() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  /// Marca la selezione del canale iniziale come completata e salva l'ID del canale
  Future<void> markInitialChannelSelected({String? channelId}) async {
    await _prefs.setBool(_initialChannelSelectedKey, true);
    if (channelId != null) {
      await _prefs.setString(_initialChannelIdKey, channelId);
    }
    await markFirstLaunchComplete();
  }

  /// Ottiene l'ID del canale iniziale selezionato dall'utente
  String? getInitialChannelId() {
    return _prefs.getString(_initialChannelIdKey);
  }

  /// Reset per testing (torna allo stato di primo avvio)
  Future<void> resetFirstLaunch() async {
    await _prefs.setBool(_firstLaunchKey, true);
    await _prefs.setBool(_initialChannelSelectedKey, false);
    // Non rimuoviamo l'ID del canale iniziale per mantenere la scelta dell'utente
  }
}

