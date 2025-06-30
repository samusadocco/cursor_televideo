class AppSettings {
  static int _cacheDurationInSeconds = 300; // Default: 5 minuti

  static int get cacheDurationInSeconds => _cacheDurationInSeconds;
  
  static void setCacheDuration(int seconds) {
    if (seconds >= 0 && seconds <= 600) {
      _cacheDurationInSeconds = seconds;
    }
  }
} 