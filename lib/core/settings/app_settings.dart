import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Opzioni per la pagina da caricare all'avvio dell'app
enum StartupPageOption {
  /// Carica l'ultima pagina visualizzata (default)
  lastPage,
  
  /// Carica il primo preferito, se disponibile, altrimenti l'ultima pagina
  firstFavorite,
  
  /// Carica la pagina iniziale dell'ultimo canale visualizzato
  channelHomePage,
}

class AppSettings {
  static const String _cacheDurationKey = 'cache_duration_seconds';
  static const String _liveShowEnabledKey = 'live_show_enabled';
  static const String _liveShowIntervalKey = 'live_show_interval_seconds';
  static const String _themeModeKey = 'theme_mode';
  static const String _startupPageOptionKey = 'startup_page_option';
  static const String _adsPersonalizationEnabledKey = 'ads_personalization_enabled';
  static const String _appSessionTimestampKey = 'app_session_timestamp';
  
  // State Persistence keys
  static const String _lastPageNumberKey = 'last_page_number';
  static const String _lastSubPageKey = 'last_sub_page';
  static const String _lastIsNationalModeKey = 'last_is_national_mode';
  static const String _lastRegionCodeKey = 'last_region_code';
  static const String _lastChannelIdKey = 'last_channel_id';

  // Valori di default
  static const int _defaultCacheDuration = 300; // 5 minuti
  static const bool _defaultLiveShowEnabled = true;
  static const int _defaultLiveShowInterval = 10; // 10 secondi
  static const ThemeMode _defaultThemeMode = ThemeMode.dark;
  static const StartupPageOption _defaultStartupPageOption = StartupPageOption.lastPage;
  static const bool _defaultAdsPersonalizationEnabled = true;

  // Valori in memoria
  static int _cacheDurationInSeconds = _defaultCacheDuration;
  static bool _liveShowEnabled = _defaultLiveShowEnabled;
  static int _liveShowIntervalSeconds = _defaultLiveShowInterval;
  static ThemeMode _themeMode = _defaultThemeMode;
  static StartupPageOption _startupPageOption = _defaultStartupPageOption;
  static bool _adsPersonalizationEnabled = _defaultAdsPersonalizationEnabled;
  static int _appSessionTimestamp = DateTime.now().millisecondsSinceEpoch;
  
  // State Persistence values
  static int? _lastPageNumber;
  static int? _lastSubPage;
  static bool? _lastIsNationalMode;
  static String? _lastRegionCode;
  static String? _lastChannelId;

  // Getters
  static int get cacheDurationInSeconds => _cacheDurationInSeconds;
  static bool get liveShowEnabled => _liveShowEnabled;
  static int get liveShowIntervalSeconds => _liveShowIntervalSeconds;
  static ThemeMode get themeMode => _themeMode;
  static StartupPageOption get startupPageOption => _startupPageOption;
  static bool get adsPersonalizationEnabled => _adsPersonalizationEnabled;
  static int get appSessionTimestamp => _appSessionTimestamp;
  
  // State Persistence getters
  static int? get lastPageNumber => _lastPageNumber;
  static int? get lastSubPage => _lastSubPage;
  static bool? get lastIsNationalMode => _lastIsNationalMode;
  static String? get lastRegionCode => _lastRegionCode;
  static String? get lastChannelId => _lastChannelId;

  // Inizializzazione
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    _cacheDurationInSeconds = prefs.getInt(_cacheDurationKey) ?? _defaultCacheDuration;
    _liveShowEnabled = prefs.getBool(_liveShowEnabledKey) ?? _defaultLiveShowEnabled;
    _liveShowIntervalSeconds = prefs.getInt(_liveShowIntervalKey) ?? _defaultLiveShowInterval;
    _adsPersonalizationEnabled = prefs.getBool(_adsPersonalizationEnabledKey) ?? _defaultAdsPersonalizationEnabled;
    
    final themeModeIndex = prefs.getInt(_themeModeKey);
    _themeMode = themeModeIndex != null 
        ? ThemeMode.values[themeModeIndex]
        : _defaultThemeMode;
    
    final startupPageOptionIndex = prefs.getInt(_startupPageOptionKey);
    _startupPageOption = startupPageOptionIndex != null 
        ? StartupPageOption.values[startupPageOptionIndex]
        : _defaultStartupPageOption;
    
    // Genera un nuovo session timestamp ad ogni avvio dell'app
    _appSessionTimestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_appSessionTimestampKey, _appSessionTimestamp);
    final date = DateTime.fromMillisecondsSinceEpoch(_appSessionTimestamp);
    print('🚀 [AppSettings] Nuovo session timestamp generato: $_appSessionTimestamp');
    print('📅 [AppSettings] Data sessione: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}');
    
    // Carica State Persistence
    _lastPageNumber = prefs.getInt(_lastPageNumberKey);
    _lastSubPage = prefs.getInt(_lastSubPageKey);
    _lastIsNationalMode = prefs.getBool(_lastIsNationalModeKey);
    _lastRegionCode = prefs.getString(_lastRegionCodeKey);
    _lastChannelId = prefs.getString(_lastChannelIdKey);
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

  static Future<void> setStartupPageOption(StartupPageOption option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_startupPageOptionKey, option.index);
    _startupPageOption = option;
  }

  static Future<void> setAdsPersonalizationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adsPersonalizationEnabledKey, enabled);
    _adsPersonalizationEnabled = enabled;
  }
  
  // State Persistence setters
  static Future<void> saveLastState({
    required int? pageNumber,
    required int? subPage,
    required bool? isNationalMode,
    required String? regionCode,
    required String? channelId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (pageNumber != null) {
      await prefs.setInt(_lastPageNumberKey, pageNumber);
      _lastPageNumber = pageNumber;
    } else {
      await prefs.remove(_lastPageNumberKey);
      _lastPageNumber = null;
    }
    
    if (subPage != null) {
      await prefs.setInt(_lastSubPageKey, subPage);
      _lastSubPage = subPage;
    } else {
      await prefs.remove(_lastSubPageKey);
      _lastSubPage = null;
    }
    
    if (isNationalMode != null) {
      await prefs.setBool(_lastIsNationalModeKey, isNationalMode);
      _lastIsNationalMode = isNationalMode;
    } else {
      await prefs.remove(_lastIsNationalModeKey);
      _lastIsNationalMode = null;
    }
    
    if (regionCode != null) {
      await prefs.setString(_lastRegionCodeKey, regionCode);
      _lastRegionCode = regionCode;
    } else {
      await prefs.remove(_lastRegionCodeKey);
      _lastRegionCode = null;
    }
    
    if (channelId != null) {
      await prefs.setString(_lastChannelIdKey, channelId);
      _lastChannelId = channelId;
    } else {
      await prefs.remove(_lastChannelIdKey);
      _lastChannelId = null;
    }
  }
  
  static Future<void> clearLastState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastPageNumberKey);
    await prefs.remove(_lastSubPageKey);
    await prefs.remove(_lastIsNationalModeKey);
    await prefs.remove(_lastRegionCodeKey);
    await prefs.remove(_lastChannelIdKey);
    
    _lastPageNumber = null;
    _lastSubPage = null;
    _lastIsNationalMode = null;
    _lastRegionCode = null;
    _lastChannelId = null;
  }
} 