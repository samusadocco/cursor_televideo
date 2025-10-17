import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per RAI Televideo (Italia)
/// 
/// Wrapper attorno a TelevideoRepository esistente per mantenere retrocompatibilità.
/// RAI usa immagini PNG per le pagine.
class RAIProvider implements TeletextProvider {
  final TelevideoRepository _repository;

  RAIProvider({TelevideoRepository? repository})
      : _repository = repository ?? TelevideoRepository();

  @override
  String get providerId => 'rai_televideo';

  @override
  String get providerName => 'RAI Televideo';

  @override
  String get countryCode => 'IT';

  @override
  bool get supportsRegions => true;

  @override
  List<String> get supportedRegions => [
        'Piemonte',
        'ValleAosta',
        'Lombardia',
        'TrentinoAltoAdige',
        'Veneto',
        'FriuliVeneziaGiulia',
        'Liguria',
        'EmiliaRomagna',
        'Toscana',
        'Umbria',
        'Marche',
        'Lazio',
        'Abruzzo',
        'Molise',
        'Campania',
        'Puglia',
        'Basilicata',
        'Calabria',
        'Sicilia',
        'Sardegna',
      ];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[RAIProvider] Fetching national page $pageNumber subpage $subPage');
      
      final page = await _repository.getNationalPage(
        pageNumber,
        subPage: subPage,
      );
      
      // Aggiungi metadati provider
      return page.copyWith(
        providerId: providerId,
        subPage: subPage,
        totalSubPages: page.maxSubPages,
        timestamp: DateTime.now(),
        isHtmlContent: false, // RAI usa PNG
      );
    } catch (e) {
      print('[RAIProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    try {
      print('[RAIProvider] Fetching regional page for $regionCode: $pageNumber subpage $subPage');
      
      final page = await _repository.getRegionalPage(
        regionCode,
        pageNumber: pageNumber,
        subPage: subPage,
      );
      
      // Aggiungi metadati provider
      return page.copyWith(
        providerId: providerId,
        subPage: subPage,
        totalSubPages: page.maxSubPages,
        timestamp: DateTime.now(),
        isHtmlContent: false, // RAI usa PNG
        region: regionCode,
      );
    } catch (e) {
      print('[RAIProvider] Error fetching regional page: $e');
      rethrow;
    }
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await fetchNationalPage(pageNumber);
      return true;
    } catch (e) {
      return false;
    }
  }
}


