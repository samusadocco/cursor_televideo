import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _cacheDurationKey = 'cache_duration_seconds';
  static const String _liveShowEnabledKey = 'live_show_enabled';
  static const String _liveShowIntervalKey = 'live_show_interval_seconds';
  static const String _themeModeKey = 'theme_mode';

  // Valori di default
  static const int _defaultCacheDuration = 300; // 5 minuti
  static const bool _defaultLiveShowEnabled = true;
  static const int _defaultLiveShowInterval = 10; // 10 secondi
  static const ThemeMode _defaultThemeMode = ThemeMode.dark;

  // Valori in memoria
  static int _cacheDurationInSeconds = _defaultCacheDuration;
  static bool _liveShowEnabled = _defaultLiveShowEnabled;
  static int _liveShowIntervalSeconds = _defaultLiveShowInterval;
  static ThemeMode _themeMode = _defaultThemeMode;

  // Getters
  static int get cacheDurationInSeconds => _cacheDurationInSeconds;
  static bool get liveShowEnabled => _liveShowEnabled;
  static int get liveShowIntervalSeconds => _liveShowIntervalSeconds;
  static ThemeMode get themeMode => _themeMode;

  // Inizializzazione
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    _cacheDurationInSeconds = prefs.getInt(_cacheDurationKey) ?? _defaultCacheDuration;
    _liveShowEnabled = prefs.getBool(_liveShowEnabledKey) ?? _defaultLiveShowEnabled;
    _liveShowIntervalSeconds = prefs.getInt(_liveShowIntervalKey) ?? _defaultLiveShowInterval;
    
    final themeModeIndex = prefs.getInt(_themeModeKey);
    _themeMode = themeModeIndex != null 
        ? ThemeMode.values[themeModeIndex]
        : _defaultThemeMode;
  }

  // Setters con persistenza
  static Future<void> setCacheDuration(int seconds) async {
    if (seconds >= 0 && seconds <= 600) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_cacheDurationKey, seconds);
      _cacheDurationInSeconds = seconds;
    }
  }

  static Future<void> setLiveShowEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_liveShowEnabledKey, enabled);
    _liveShowEnabled = enabled;
  }

  static Future<void> setLiveShowInterval(int seconds) async {
    if (seconds >= 3 && seconds <= 30) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_liveShowIntervalKey, seconds);
      _liveShowIntervalSeconds = seconds;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    _themeMode = mode;
  }
} 