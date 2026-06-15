import 'package:dio/dio.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per ČT Teletext (Repubblica Ceca)
///
/// API JSON: https://api-teletext.ceskatelevize.cz/pages
/// Immagine: https://api-teletext.ceskatelevize.cz/pages/{codice}/image.webp?t={timestamp}
/// Web: https://teletext.ceskatelevize.cz/?p={page}-{subpage}
class CTProvider implements TeletextProvider {
  static const String _apiUrl = 'https://api-teletext.ceskatelevize.cz/pages';
  static const String _imageBaseUrl = 'https://api-teletext.ceskatelevize.cz/pages';

  final Dio _dio;

  // Cache per il numero totale di sottopagine per ogni pagina
  final Map<int, int> _subPageCache = {};

  // Cache per i dati dell'API JSON completa
  Map<String, dynamic>? _apiDataCache;
  int? _apiTimestamp;
  DateTime? _apiCacheTime;
  static const Duration _cacheValidity = Duration(minutes: 5);

  static const Map<String, String> _requestHeaders = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'application/json',
    'Referer': 'https://teletext.ceskatelevize.cz/',
  };

  CTProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'ct_teletext';

  @override
  String get providerName => 'ČT Teletext';

  @override
  String get countryCode => 'CZ';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[CTProvider] Fetching page $pageNumber subpage $subPage');

    final jsonData = await _fetchApiData();

    final pageData = jsonData[pageNumber.toString()] as Map<String, dynamic>?;
    if (pageData == null) {
      throw Exception('Page $pageNumber not found in API data');
    }

    final subpagesList = pageData['subpages'] as List<dynamic>?;
    final totalSubPages = subpagesList?.length ?? 0;
    final validSubPage = totalSubPages > 0 ? subPage.clamp(1, totalSubPages) : 1;

    if (validSubPage != subPage) {
      print('[CTProvider] Subpage $subPage out of range, using $validSubPage');
    }

    return _parseJsonData(jsonData, pageNumber, validSubPage);
  }

  /// Verifica disponibilità (GET: il server risponde 403 a HEAD).
  /// Popola anche la cache API per il caricamento immediato della pagina.
  Future<bool> checkAvailability() async {
    try {
      await _fetchApiData();
      return true;
    } catch (e) {
      print('[CTProvider] Availability check failed: $e');
      return false;
    }
  }

  /// Recupera i dati dall'API con cache
  Future<Map<String, dynamic>> _fetchApiData() async {
    if (_apiDataCache != null && _apiCacheTime != null) {
      final cacheAge = DateTime.now().difference(_apiCacheTime!);
      if (cacheAge < _cacheValidity) {
        print('[CTProvider] Using cached API data (age: ${cacheAge.inSeconds}s)');
        return _apiDataCache!;
      }
    }

    print('[CTProvider] Fetching fresh API data...');

    try {
      final response = await _dio.get(
        _apiUrl,
        options: Options(headers: _requestHeaders),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load API: ${response.statusCode}');
      }

      final jsonData = response.data as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid API response: missing data');
      }

      _apiDataCache = data;
      _apiTimestamp = (jsonData['timestamp'] as num?)?.toInt();
      _apiCacheTime = DateTime.now();

      print('[CTProvider] API data cached successfully');

      return data;
    } catch (e) {
      print('[CTProvider] Error fetching API: $e');

      if (_apiDataCache != null) {
        print('[CTProvider] Using stale cache as fallback');
        return _apiDataCache!;
      }

      rethrow;
    }
  }

  /// Converte il numero della sottopagina in lettera (1->A, 2->B, 3->C, etc.)
  String _subPageToLetter(int subPage) {
    if (subPage < 1 || subPage > 26) {
      return 'A';
    }
    return String.fromCharCode(64 + subPage);
  }

  String _buildPageCode(int pageNumber, int currentSubPage, int totalSubPages) {
    if (totalSubPages > 0) {
      return '$pageNumber${_subPageToLetter(currentSubPage)}';
    }
    return pageNumber.toString();
  }

  String _buildImageUrl(String pageCode) {
    final timestamp = _apiTimestamp;
    final query = timestamp != null ? '?t=$timestamp' : '';
    return '$_imageBaseUrl/$pageCode/image.webp$query';
  }

  /// Parse i dati JSON dall'API
  TelevideoPage _parseJsonData(
    Map<String, dynamic> data,
    int pageNumber,
    int currentSubPage,
  ) {
    try {
      print('[CTProvider] Parsing JSON data...');

      final pageData = data[pageNumber.toString()] as Map<String, dynamic>?;
      if (pageData == null) {
        throw Exception('Page $pageNumber not found in API data');
      }

      final subpagesList = pageData['subpages'] as List<dynamic>?;
      final totalSubPages = subpagesList?.length ?? 0;

      _subPageCache[pageNumber] = totalSubPages > 0 ? totalSubPages : 1;

      print('[CTProvider] Total subpages: ${totalSubPages > 0 ? totalSubPages : 1}');

      final pageCode = _buildPageCode(pageNumber, currentSubPage, totalSubPages);
      final imageUrl = _buildImageUrl(pageCode);

      print('[CTProvider] Image URL: $imageUrl');

      final links = pageData['links'] as Map<String, dynamic>?;
      final clickableAreas = <ClickableArea>[];

      if (links != null) {
        final pageLinks = links[pageCode] as List<dynamic>?;

        if (pageLinks != null) {
          print('[CTProvider] Found ${pageLinks.length} links for $pageCode');

          for (final linkData in pageLinks) {
            final linkMap = linkData as Map<String, dynamic>;
            final coordinates = linkMap['coordinates'] as List<dynamic>?;
            final targetPage = linkMap['link'] as int?;

            if (coordinates != null &&
                coordinates.length == 4 &&
                targetPage != null) {
              final x1 = (coordinates[0] as num).toInt();
              final y1 = (coordinates[1] as num).toInt();
              final x2 = (coordinates[2] as num).toInt();
              final y2 = (coordinates[3] as num).toInt();

              clickableAreas.add(ClickableArea(
                x: x1,
                y: y1,
                width: x2 - x1,
                height: y2 - y1,
                targetPage: targetPage,
              ));
            }
          }
        }
      }

      print('[CTProvider] Found ${clickableAreas.length} clickable areas');

      String? prevPage;
      String? nextPage;

      if (pageNumber > 100) {
        prevPage = (pageNumber - 1).toString();
      }
      if (pageNumber < 899) {
        nextPage = (pageNumber + 1).toString();
      }

      print('[CTProvider] Navigation: prev=$prevPage, next=$nextPage');

      return TelevideoPage(
        pageNumber: pageNumber,
        subPage: currentSubPage,
        totalSubPages: totalSubPages > 0 ? totalSubPages : 1,
        maxSubPages: totalSubPages > 0 ? totalSubPages : 1,
        imageUrl: imageUrl,
        isHtmlContent: false,
        metadata: {
          'prevPage': prevPage,
          'nextPage': nextPage,
        },
        providerId: providerId,
        clickableAreas: clickableAreas,
      );
    } catch (e) {
      print('[CTProvider] Error parsing JSON: $e');
      throw Exception('Failed to parse JSON data: $e');
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    throw UnimplementedError('ČT Teletext does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final data = await _fetchApiData();
      return data.containsKey(pageNumber.toString());
    } catch (e) {
      print('[CTProvider] Error checking page existence: $e');
      return false;
    }
  }
}
