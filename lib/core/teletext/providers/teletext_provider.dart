import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider astratto per recuperare pagine teletext da diverse fonti
abstract class TeletextProvider {
  /// ID univoco del provider
  String get providerId;
  
  /// Nome del provider
  String get providerName;
  
  /// Codice paese del provider (ISO 3166-1 alpha-2)
  String get countryCode;
  
  /// Recupera una pagina teletext nazionale
  /// 
  /// [pageNumber] Numero della pagina da recuperare
  /// [subPage] Numero della sottopagina (opzionale, default 1)
  /// 
  /// Returns Future<TelevideoPage> con i dati della pagina
  /// Throws Exception in caso di errore
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1});
  
  /// Recupera una pagina teletext regionale
  /// 
  /// [regionCode] Codice della regione
  /// [pageNumber] Numero della pagina da recuperare  
  /// [subPage] Numero della sottopagina (opzionale, default 1)
  /// 
  /// Returns Future<TelevideoPage> con i dati della pagina
  /// Throws Exception in caso di errore
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  });
  
  /// Verifica se il provider supporta le pagine regionali
  bool get supportsRegions;
  
  /// Lista dei codici regione supportati (se supportsRegions è true)
  List<String> get supportedRegions;
  
  /// Verifica se una pagina esiste
  /// 
  /// [pageNumber] Numero della pagina da verificare
  /// 
  /// Returns Future<bool> true se la pagina esiste
  Future<bool> pageExists(int pageNumber);
}


