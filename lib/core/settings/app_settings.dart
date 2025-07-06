class AppSettings {
  static int _cacheDurationInSeconds = 300; // Default: 5 minuti
  static bool _liveShowEnabled = true; // Default: abilitato
  static int _liveShowIntervalSeconds = 10; // Default: 10 secondi

  static int get cacheDurationInSeconds => _cacheDurationInSeconds;
  static bool get liveShowEnabled => _liveShowEnabled;
  static int get liveShowIntervalSeconds => _liveShowIntervalSeconds;
  
  static void setCacheDuration(int seconds) {
    if (seconds >= 0 && seconds <= 600) {
      _cacheDurationInSeconds = seconds;
    }
  }

  static void setLiveShowEnabled(bool enabled) {
    _liveShowEnabled = enabled;
  }

  static void setLiveShowInterval(int seconds) {
    if (seconds >= 3 && seconds <= 30) { // Limiti: minimo 3 secondi, massimo 30 secondi
      _liveShowIntervalSeconds = seconds;
    }
  }
} 