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

  /// [trackingAllowed] false quando l'utente ha selezionato "Ask App Not to Track" (ATT)
  static Future<void> initialize({bool trackingAllowed = true}) async {
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
      
      // Rispetta ATT: quando tracking negato, non raccogliere dati per advertising (Guideline 5.1.1(iv))
      await analytics.setConsent(
        adStorageConsentGranted: trackingAllowed,
        analyticsStorageConsentGranted: trackingAllowed,
      );
      print('Firebase Analytics consent: trackingAllowed=$trackingAllowed');
      
      await analytics.setAnalyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
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
  Future<void> logTelevideoPageView(String pageNumber, String navigationMethod, {String? sourcePageNumber, String? channelId}) async {
    final parameters = {
      'page_number': pageNumber,
      'navigation_method': navigationMethod, // 'swipe', 'button' o 'link_click'
    };
    
    // Aggiungi la pagina di origine solo per i click sui link
    if (navigationMethod == 'link_click' && sourcePageNumber != null) {
      parameters['source_page'] = sourcePageNumber;
    }
    
    // Aggiungi channel_id se disponibile
    if (channelId != null) {
      parameters['channel_id'] = channelId;
    }
    
    await _safeLogEvent('logTelevideoPageView', () => _analytics!.logEvent(
      name: 'televideo_page_view',
      parameters: parameters,
    ));
  }

  // Eventi di cambio sottopagina
  Future<void> logSubpageChange(String pageNumber, String subpage, String changeType, {String? channelId}) async {
    final parameters = {
      'page_number': pageNumber,
      'subpage': subpage,
      'change_type': changeType, // 'auto_refresh' o 'manual'
    };
    
    // Aggiungi channel_id se disponibile
    if (channelId != null) {
      parameters['channel_id'] = channelId;
    }
    
    await _safeLogEvent('logSubpageChange', () => _analytics!.logEvent(
      name: 'subpage_change',
      parameters: parameters,
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
  Future<void> logLoadTime(String pageNumber, {String? subPage, String? channelId, required int durationMillis, bool isError = false}) async {
    await _safeLogEvent('logLoadTime', () async {
      // Ottieni il tipo di connessione (connectivity_plus 6.x: checkConnectivity restituisce List)
      final connectivity = await Connectivity().checkConnectivity();
      final networkInfo = NetworkInfo();
      String connectionType;
      Map<String, dynamic> parameters = {
        'page_number': pageNumber,
        'sub_page': subPage ?? '1',
        'duration_ms': durationMillis,
        'status': isError ? 'error' : 'success',
      };
      
      // Aggiungi channel_id se disponibile
      if (channelId != null) {
        parameters['channel_id'] = channelId;
      }
      
      if (connectivity.contains(ConnectivityResult.none) && connectivity.length <= 1) {
        connectionType = 'none';
      } else if (connectivity.contains(ConnectivityResult.wifi)) {
        connectionType = connectivity.contains(ConnectivityResult.vpn) ? 'vpn_wifi' : 'wifi';
        try {
          parameters['wifi_name'] = await networkInfo.getWifiName() ?? 'unknown';
        } catch (e) {
          print('Error getting WiFi info: $e');
        }
      } else if (connectivity.contains(ConnectivityResult.mobile)) {
        connectionType = connectivity.contains(ConnectivityResult.vpn) ? 'vpn_mobile' : 'mobile';
      } else if (connectivity.contains(ConnectivityResult.ethernet)) {
        connectionType = 'ethernet';
      } else if (connectivity.contains(ConnectivityResult.vpn)) {
        connectionType = 'vpn_other';
      } else if (connectivity.contains(ConnectivityResult.bluetooth)) {
        connectionType = 'bluetooth';
      } else {
        connectionType = 'other';
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
  
  /// Imposta lo stato dell'abbonamento come User Property
  /// Questo permette di segmentare gli utenti in Firebase Analytics
  Future<void> setSubscriptionStatus(bool isPremium) async {
    final status = isPremium ? 'premium' : 'free';
    await setUserProperty('subscription_status', status);
    print('🔍 Analytics: Subscription status set to $status');
  }
  
  /// Log evento specifico per acquisto/abbonamento
  Future<void> logSubscriptionEvent(String eventName, {
    String? subscriptionId,
    String? price,
    String? currency,
    Map<String, dynamic>? additionalParams,
  }) async {
    final parameters = <String, dynamic>{
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      ...?additionalParams,
    };
    
    await _safeLogEvent('logSubscriptionEvent', () => _analytics!.logEvent(
      name: eventName,
      parameters: parameters,
    ));
  }
}
