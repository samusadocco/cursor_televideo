import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  FirebaseAnalytics? _analytics;
  bool _isInitialized = false;

  factory AnalyticsService() {
    _instance ??= AnalyticsService._internal();
    return _instance!;
  }

  AnalyticsService._internal();

  static Future<void> initialize() async {
    if (_instance?._isInitialized ?? false) return;

    try {
      // Verifica che Firebase sia inizializzato
      if (!Firebase.apps.isNotEmpty) {
        throw Exception('Firebase non è stato inizializzato. Chiamare Firebase.initializeApp() prima di AnalyticsService.initialize()');
      }

      final analytics = FirebaseAnalytics.instance;
      
      // Verifica che Analytics sia disponibile
      final isSupported = await analytics.isSupported();
      print('Firebase Analytics is supported: $isSupported');
      
      if (!isSupported) {
        throw Exception('Firebase Analytics non è supportato su questa piattaforma');
      }
      
      // Abilita la raccolta dati e il debug verbose
      await analytics.setAnalyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      
      // Abilita il debug verbose per vedere tutti i dettagli degli eventi
      if (true) { // TODO: cambia in base all'ambiente (dev/prod)
        await analytics.setConsent(adStorageConsentGranted: true, analyticsStorageConsentGranted: true);
        print('Firebase Analytics debug verbose enabled');
      }
      print('Firebase Analytics collection enabled');
      
      // Imposta l'ID utente anonimo
      final deviceId = await analytics.appInstanceId;
      print('Firebase Analytics app instance ID: $deviceId');
      
      // Imposta la sessione ID
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      await analytics.setUserProperty(name: 'session_id', value: sessionId);
      print('Firebase Analytics session ID set: $sessionId');
      
      _instance ??= AnalyticsService._internal();
      _instance!._analytics = analytics;
      _instance!._isInitialized = true;
      print('AnalyticsService initialized successfully');
    } catch (e, stackTrace) {
      print('Error initializing AnalyticsService: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Rilanciamo l'errore per gestirlo nel main
    }
  }

  // Helper per gestire gli eventi in modo sicuro
  Future<void> _safeLogEvent(String eventName, Future<void> Function() logFunction) async {
    if (!_isInitialized || _analytics == null) {
      print('Analytics event ignored (service not initialized): $eventName');
      return;
    }
    try {
      print('🔍 Analytics event: $eventName');
      final startTime = DateTime.now();
      await logFunction();
      final duration = DateTime.now().difference(startTime);
      print('✅ Analytics event logged successfully: $eventName (${duration.inMilliseconds}ms)');
    } catch (e, stackTrace) {
      print('❌ Error logging $eventName: $e');
      print('Stack trace: $stackTrace');
    }
  }

  // Eventi di navigazione
  Future<void> logPageView(String pageName) async {
    await _safeLogEvent('logPageView', () => _analytics!.logScreenView(
      screenName: pageName,
    ));
  }

  // Eventi di interazione con le pagine del televideo
  Future<void> logTelevideoPageView(String pageNumber, String navigationMethod, {String? sourcePageNumber}) async {
    final parameters = {
      'page_number': pageNumber,
      'navigation_method': navigationMethod, // 'swipe', 'button' o 'link_click'
    };
    
    // Aggiungi la pagina di origine solo per i click sui link
    if (navigationMethod == 'link_click' && sourcePageNumber != null) {
      parameters['source_page'] = sourcePageNumber;
    }
    
    await _safeLogEvent('logTelevideoPageView', () => _analytics!.logEvent(
      name: 'televideo_page_view',
      parameters: parameters,
    ));
  }

  // Eventi di cambio sottopagina
  Future<void> logSubpageChange(String pageNumber, String subpage, String changeType) async {
    await _safeLogEvent('logSubpageChange', () => _analytics!.logEvent(
      name: 'subpage_change',
      parameters: {
        'page_number': pageNumber,
        'subpage': subpage,
        'change_type': changeType, // 'auto_refresh' o 'manual'
      },
    ));
  }

  // Eventi di interazione con le regioni
  Future<void> logRegionView(String regionName) async {
    await _safeLogEvent('logRegionView', () => _analytics!.logEvent(
      name: 'region_view',
      parameters: {
        'region_name': regionName,
      },
    ));
  }

  // Eventi dei preferiti
  Future<void> logFavoriteAction(String pageNumber, String action) async {
    await _safeLogEvent('logFavoriteAction', () => _analytics!.logEvent(
      name: 'favorite_action',
      parameters: {
        'page_number': pageNumber,
        'action': action, // 'add' o 'remove'
      },
    ));
  }

  // Eventi di ricerca
  Future<void> logSearch(String searchTerm) async {
    await _safeLogEvent('logSearch', () => _analytics!.logSearch(
      searchTerm: searchTerm,
    ));
  }

  // Eventi di errore
  Future<void> logError(String errorType, String errorMessage) async {
    await _safeLogEvent('logError', () => _analytics!.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
    ));
  }

  // Eventi di performance
  Future<void> logLoadTime(String pageNumber, {String? subPage, required int durationMillis, bool isError = false}) async {
    await _safeLogEvent('logLoadTime', () async {
      // Ottieni il tipo di connessione
      final connectivity = await Connectivity().checkConnectivity();
      final networkInfo = NetworkInfo();
      String connectionType;
      Map<String, dynamic> parameters = {
        'page_number': pageNumber,
        'sub_page': subPage ?? '1',
        'duration_ms': durationMillis,
        'status': isError ? 'error' : 'success',
      };
      
      switch (connectivity) {
        case ConnectivityResult.wifi:
          connectionType = 'wifi';
          // Aggiungi informazioni WiFi
          try {
            parameters['wifi_name'] = await networkInfo.getWifiName() ?? 'unknown';
          } catch (e) {
            print('Error getting WiFi info: $e');
          }
          break;
        case ConnectivityResult.mobile:
          connectionType = 'mobile';
          break;
        case ConnectivityResult.ethernet:
          connectionType = 'ethernet';
          break;
        case ConnectivityResult.vpn:
          // Se è VPN, controlliamo la connessione sottostante
          if (await Connectivity().checkConnectivity() == ConnectivityResult.wifi) {
            connectionType = 'vpn_wifi';
            // Aggiungi informazioni WiFi anche per VPN su WiFi
            try {
              parameters['wifi_name'] = await networkInfo.getWifiName() ?? 'unknown';
            } catch (e) {
              print('Error getting WiFi info: $e');
            }
          } else if (await Connectivity().checkConnectivity() == ConnectivityResult.mobile) {
            connectionType = 'vpn_mobile';
          } else {
            connectionType = 'vpn_other';
          }
          break;
        case ConnectivityResult.bluetooth:
          connectionType = 'bluetooth';
          break;
        case ConnectivityResult.other:
          connectionType = 'other';
          break;
        case ConnectivityResult.none:
          connectionType = 'none';
          break;
      }

      parameters['connection_type'] = connectionType;

      return _analytics!.logEvent(
        name: 'page_load_time',
        parameters: parameters,
      );
    });
  }

  // Eventi di sessione
  Future<void> logAppOpen() async {
    await _safeLogEvent('logAppOpen', () => _analytics!.logAppOpen());
  }

  // Eventi di interazione con gli annunci
  Future<void> logAdEvent(String adType, String action) async {
    await _safeLogEvent('logAdEvent', () => _analytics!.logEvent(
      name: 'ad_event',
      parameters: {
        'ad_type': adType, // 'banner' o 'interstitial'
        'action': action, // 'impression', 'click', ecc.
      },
    ));
  }

  // Eventi di condivisione
  Future<void> logShare(String contentType, String itemId) async {
    await _safeLogEvent('logShare', () => _analytics!.logShare(
      contentType: contentType,
      itemId: itemId,
      method: 'share',
    ));
  }

  // Impostazione delle proprietà utente
  Future<void> setUserProperty(String name, String value) async {
    await _safeLogEvent('setUserProperty', () => _analytics!.setUserProperty(
      name: name,
      value: value,
    ));
  }
}
