import 'package:dio/dio.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per ČT Teletext (Repubblica Ceca)
/// 
/// URL base: https://teletext.ceskatelevize.cz/?p={page}-{subpage}
/// Immagine: https://api-teletext.ceskatelevize.cz/services-old/teletext/picture.php?channel=CT2&page={page}A
class CTProvider implements TeletextProvider {
  final Dio _dio;
  
  // Cache per il numero totale di sottopagine per ogni pagina
  final Map<int, int> _subPageCache = {};
  
  // Cache per i dati dell'API JSON completa
  Map<String, dynamic>? _apiDataCache;
  DateTime? _apiCacheTime;
  static const Duration _cacheValidity = Duration(minutes: 5);

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
    
    // Ottieni i dati dall'API (con cache)
    final jsonData = await _fetchApiData();
    
    return await _parseJsonData(jsonData, pageNumber, subPage);
  }
  
  /// Recupera i dati dall'API con cache
  Future<Map<String, dynamic>> _fetchApiData() async {
    // Controlla se la cache è valida
    if (_apiDataCache != null && _apiCacheTime != null) {
      final cacheAge = DateTime.now().difference(_apiCacheTime!);
      if (cacheAge < _cacheValidity) {
        print('[CTProvider] Using cached API data (age: ${cacheAge.inSeconds}s)');
        return _apiDataCache!;
      }
    }
    
    // Cache non valida o assente: fetch dall'API
    print('[CTProvider] Fetching fresh API data...');
    
    final apiUrl = 'https://api-teletext.ceskatelevize.cz/teletext-api/';
    
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load API: ${response.statusCode}');
      }
      
      final jsonData = response.data as Map<String, dynamic>;
      
      // Aggiorna la cache
      _apiDataCache = jsonData;
      _apiCacheTime = DateTime.now();
      
      print('[CTProvider] API data cached successfully');
      
      return jsonData;
      
    } catch (e) {
      print('[CTProvider] Error fetching API: $e');
      
      // Se abbiamo una cache vecchia, usala come fallback
      if (_apiDataCache != null) {
        print('[CTProvider] Using stale cache as fallback');
        return _apiDataCache!;
      }
      
      rethrow;
    }
  }
  
  /// Converte il numero della sottopagina in lettera (1->A, 2->B, 3->C, etc.)
  String _subPageToLetter(int subPage) {
    // A=1, B=2, C=3, ... Z=26
    if (subPage < 1 || subPage > 26) {
      return 'A'; // Default alla prima sottopagina
    }
    return String.fromCharCode(64 + subPage); // 64 + 1 = 65 = 'A'
  }

  /// Parse i dati JSON dall'API
  Future<TelevideoPage> _parseJsonData(Map<String, dynamic> jsonData, int pageNumber, int currentSubPage) async {
    try {
      print('[CTProvider] Parsing JSON data...');
      
      // Struttura JSON: {"data": {"100": {"subpages": ["A","B",...], "links": {"100A": [...], ...}}}}
      final data = jsonData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('No data field in JSON');
      }
      
      final pageData = data[pageNumber.toString()] as Map<String, dynamic>?;
      if (pageData == null) {
        throw Exception('Page $pageNumber not found in API data');
      }
      
      // Sottopagine disponibili (es: ["A", "B", "C"])
      final subpagesList = pageData['subpages'] as List<dynamic>?;
      final totalSubPages = subpagesList?.length ?? 0;
      
      // Aggiorna la cache
      _subPageCache[pageNumber] = totalSubPages > 0 ? totalSubPages : 1;
      
      print('[CTProvider] Total subpages: ${totalSubPages > 0 ? totalSubPages : 1}');
      
      // Costruisci l'URL dell'immagine
      // Se non ci sono sottopagine (lista vuota), non aggiungere la lettera
      String imageUrl;
      if (totalSubPages > 0) {
        // Ci sono sottopagine: aggiungi la lettera (A, B, C, ...)
        final subPageLetter = _subPageToLetter(currentSubPage);
        imageUrl = 'https://api-teletext.ceskatelevize.cz/services-old/teletext/picture.php?channel=CT2&page=$pageNumber$subPageLetter';
      } else {
        // Nessuna sottopagina: URL senza lettera
        imageUrl = 'https://api-teletext.ceskatelevize.cz/services-old/teletext/picture.php?channel=CT2&page=$pageNumber';
      }
      
      print('[CTProvider] Image URL: $imageUrl');
      
      // Estrai i link cliccabili per questa sottopagina
      final links = pageData['links'] as Map<String, dynamic>?;
      final clickableAreas = <ClickableArea>[];
      
      if (links != null) {
        // Costruisci la chiave: se ci sono sottopagine usa "100A", altrimenti solo "100"
        final pageKey = totalSubPages > 0 
            ? '$pageNumber${_subPageToLetter(currentSubPage)}' 
            : pageNumber.toString();
        final pageLinks = links[pageKey] as List<dynamic>?;
        
        if (pageLinks != null) {
          print('[CTProvider] Found ${pageLinks.length} links for $pageKey');
          
          for (final linkData in pageLinks) {
            final linkMap = linkData as Map<String, dynamic>;
            final coordinates = linkMap['coordinates'] as List<dynamic>?;
            final targetPage = linkMap['link'] as int?;
            
            if (coordinates != null && coordinates.length == 4 && targetPage != null) {
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
      
      // Per prev/next page, usiamo la logica sequenziale
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
        totalSubPages: totalSubPages,
        maxSubPages: totalSubPages,
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
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) async {
    throw UnimplementedError('ČT Teletext does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final url = 'https://teletext.ceskatelevize.cz/?p=$pageNumber-1';
      final response = await _dio.head(
        url,
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[CTProvider] Error checking page existence: $e');
      return false;
    }
  }
}

