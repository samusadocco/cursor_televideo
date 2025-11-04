import 'package:package_info_plus/package_info_plus.dart';
import 'package:cursor_televideo/core/utils/country_detector.dart';

/// Servizio per rilevare il paese dello store da cui è stata scaricata l'app
/// 
/// Questo è diverso dal paese del dispositivo: un utente tedesco potrebbe
/// scaricare l'app dall'App Store italiano mentre visita l'Italia.
class StoreCountryDetector {
  static StoreCountryDetector? _instance;
  
  StoreCountryDetector._();
  
  static StoreCountryDetector get instance {
    _instance ??= StoreCountryDetector._();
    return _instance!;
  }
  
  String? _cachedStoreCountry;
  
  /// Ottiene il paese dello store (con fallback al paese del dispositivo)
  /// 
  /// NOTA: Attualmente non esiste un modo affidabile per rilevare il paese
  /// dello store specifico su iOS/Android senza backend.
  /// 
  /// Implementazione attuale:
  /// 1. Prova a rilevare dal Package Info (limitato)
  /// 2. Fallback al paese del dispositivo (Platform.localeName)
  /// 3. Fallback a Italia (IT)
  Future<String> getStoreCountryCode() async {
    print('[StoreCountryDetector] ===== INIZIO RILEVAMENTO PAESE STORE =====');
    
    // Usa la cache se disponibile
    if (_cachedStoreCountry != null) {
      print('[StoreCountryDetector] ✅ Usando cache: $_cachedStoreCountry');
      return _cachedStoreCountry!;
    }
    
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final installerStore = packageInfo.installerStore ?? '';
      
      print('[StoreCountryDetector] 📱 Installer store: "$installerStore"');
      
      // Su iOS/Android, l'installer non fornisce il paese dello store
      // Quindi usiamo il paese del dispositivo come proxy
      final deviceCountry = CountryDetector.instance.getUserCountryCode();
      
      if (deviceCountry != null && deviceCountry.isNotEmpty) {
        _cachedStoreCountry = deviceCountry;
        print('[StoreCountryDetector] ✅ Usando paese dispositivo: $_cachedStoreCountry');
      } else {
        // Fallback finale: Italia
        _cachedStoreCountry = 'IT';
        print('[StoreCountryDetector] ⚠️ Fallback a Italia');
      }
      
      print('[StoreCountryDetector] ===== FINE RILEVAMENTO: $_cachedStoreCountry =====');
      return _cachedStoreCountry!;
    } catch (e) {
      print('[StoreCountryDetector] ❌ ERRORE: $e');
      _cachedStoreCountry = 'IT';
      return _cachedStoreCountry!;
    }
  }
  
  /// Resetta la cache
  void resetCache() {
    _cachedStoreCountry = null;
  }
  
  /// Verifica se lo store è quello italiano
  Future<bool> isItalianStore() async {
    final country = await getStoreCountryCode();
    return country == 'IT';
  }
  
  /// Verifica se lo store è quello tedesco
  Future<bool> isGermanStore() async {
    final country = await getStoreCountryCode();
    return country == 'DE';
  }
  
  /// Verifica se lo store è quello francese
  Future<bool> isFrenchStore() async {
    final country = await getStoreCountryCode();
    return country == 'FR';
  }
  
  /// Ottiene il nome del broadcaster principale per il paese dello store
  Future<String> getPrimaryBroadcasterName() async {
    final country = await getStoreCountryCode();
    
    switch (country) {
      case 'IT':
        return 'RAI';
      case 'DE':
        return 'ARD/ZDF';
      case 'AT':
        return 'ORF';
      case 'CH':
        return 'SRF/RSI';
      case 'FR':
        return 'France TV';
      case 'ES':
        return 'TVE';
      case 'PT':
        return 'RTP';
      case 'NL':
        return 'NOS';
      case 'SE':
        return 'SVT';
      case 'FI':
        return 'YLE';
      case 'DK':
        return 'DR';
      case 'CZ':
        return 'ČT';
      case 'HR':
        return 'HRT';
      case 'SI':
        return 'RTV SLO';
      case 'HU':
        return 'MTVA';
      case 'IS':
        return 'RÚV';
      case 'BA':
        return 'BHRT';
      default:
        return 'RAI'; // Fallback
    }
  }
  
  /// Ottiene l'emoji della bandiera per il paese dello store
  Future<String> getFlagEmoji() async {
    final country = await getStoreCountryCode();
    
    switch (country) {
      case 'IT': return '🇮🇹';
      case 'DE': return '🇩🇪';
      case 'AT': return '🇦🇹';
      case 'CH': return '🇨🇭';
      case 'FR': return '🇫🇷';
      case 'ES': return '🇪🇸';
      case 'PT': return '🇵🇹';
      case 'NL': return '🇳🇱';
      case 'SE': return '🇸🇪';
      case 'FI': return '🇫🇮';
      case 'DK': return '🇩🇰';
      case 'CZ': return '🇨🇿';
      case 'HR': return '🇭🇷';
      case 'SI': return '🇸🇮';
      case 'HU': return '🇭🇺';
      case 'IS': return '🇮🇸';
      case 'BA': return '🇧🇦';
      default: return '🇮🇹'; // Fallback
    }
  }
}

