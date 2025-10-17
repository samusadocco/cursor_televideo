import 'package:dio/dio.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per i canali Teletext svizzeri (Svizzera)
/// 
/// Supporta RSI LA 1, RSI LA 2, RTS 1, RTS 2, SRF 1, SRF zwei, SRF info
/// URL base: https://www.teletext.ch/{CHANNEL}/
class SwissProvider implements TeletextProvider {
  final Dio _dio;
  final String channelId;
  final String _channelCode;

  SwissProvider({
    Dio? dio,
    required this.channelId,
  }) : _dio = dio ?? Dio(),
       _channelCode = _getChannelCode(channelId);

  /// Determina il codice canale in base al channelId
  static String _getChannelCode(String channelId) {
    switch (channelId) {
      case 'rsi_la1':
        return 'RSILA1';
      case 'rsi_la2':
        return 'RSILA2';
      case 'rts_1':
        return 'RTSUn';
      case 'rts_2':
        return 'RTSDeux';
      case 'srf_1':
        return 'SRF1';
      case 'srf_zwei':
        return 'SRFzwei';
      case 'srf_info':
        return 'SRFInfo';
      default:
        return 'RSILA1';
    }
  }

  @override
  String get providerId => channelId;

  @override
  String get providerName {
    switch (channelId) {
      case 'rsi_la1':
        return 'RSI LA 1';
      case 'rsi_la2':
        return 'RSI LA 2';
      case 'rts_1':
        return 'RTS 1';
      case 'rts_2':
        return 'RTS 2';
      case 'srf_1':
        return 'SRF 1';
      case 'srf_zwei':
        return 'SRF zwei';
      case 'srf_info':
        return 'SRF info';
      default:
        return 'Swiss Teletext';
    }
  }

  @override
  String get countryCode => 'CH';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[SwissProvider] Fetching page $pageNumber subpage $subPage for $_channelCode');
    
    // Swiss Teletext ha un'API JSON che fornisce tutti i dati
    // Formato: https://api.teletext.ch/channels/RSILA1/pages/101
    final apiUrl = 'https://api.teletext.ch/channels/$_channelCode/pages/$pageNumber';
    
    print('[SwissProvider] API URL: $apiUrl');
    
    try {
      final response = await _dio.get(apiUrl);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      final jsonData = response.data as Map<String, dynamic>;
      return _parseJsonPage(jsonData, pageNumber, subPage);
      
    } catch (e) {
      print('[SwissProvider] Error fetching from API: $e');
      rethrow;
    }
  }
  
  /// Parse la risposta JSON dell'API Swiss Teletext
  TelevideoPage _parseJsonPage(Map<String, dynamic> json, int requestedPage, int requestedSubPage) {
    print('[SwissProvider] Parsing JSON response...');
    
    final pageNumber = json['pageNumber'] as int;
    final subpages = json['subpages'] as List<dynamic>;
    
    print('[SwissProvider] Page: $pageNumber, Subpages: ${subpages.length}');
    
    // Trova la sottopagina richiesta (0-indexed nell'API, quindi requestedSubPage - 1)
    final subPageIndex = requestedSubPage - 1;
    
    // Verifica che l'indice sia valido
    if (subPageIndex < 0 || subPageIndex >= subpages.length) {
      print('[SwissProvider] Invalid subpage index: $subPageIndex (available: ${subpages.length})');
      throw Exception('Subpage $requestedSubPage not found (only ${subpages.length} subpages available)');
    }
    
    final subpageData = subpages[subPageIndex];
    
    if (subpageData == null) {
      throw Exception('Subpage data is null');
    }
    
    // Estrai i link dalla sottopagina
    print('[SwissProvider] Subpage data keys: ${subpageData.keys}');
    
    // I link potrebbero essere direttamente in subpageData o dentro ep1Info
    var links = subpageData['links'] as List<dynamic>?;
    
    // Se non ci sono link diretti, prova dentro ep1Info
    if (links == null || links.isEmpty) {
      final ep1Info = subpageData['ep1Info'];
      if (ep1Info != null) {
        print('[SwissProvider] Checking ep1Info for links...');
        print('[SwissProvider] ep1Info keys: ${ep1Info.keys}');
        links = ep1Info['links'] as List<dynamic>?;
      }
    }
    
    print('[SwissProvider] Links in JSON: ${links?.length ?? 0}');
    if (links != null && links.isNotEmpty) {
      print('[SwissProvider] First link: ${links[0]}');
    }
    final clickableAreas = _parseLinksFromJson(links);
    
    print('[SwissProvider] Found ${clickableAreas.length} clickable areas from API');
    
    // Costruisci l'URL dell'immagine
    final subPageIndexImage = (subpages.length == 1) ? 0 : subPageIndex + 1;
    final imageUrl = 'https://api.teletext.ch/online/pics/medium/${_channelCode}_$pageNumber-$subPageIndexImage.gif';
    
    print('[SwissProvider] Image URL: $imageUrl');
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: requestedSubPage,
      maxSubPages: subpages.length,
      totalSubPages: subpages.length,
      imageUrl: imageUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: false,
      providerId: providerId,
      metadata: {
        'previousPage': json['previousPage'],
        'nextPage': json['nextPage'],
      },
    );
  }
  
  /// Estrae le ClickableArea dai link JSON
  List<ClickableArea> _parseLinksFromJson(List<dynamic>? links) {
    if (links == null || links.isEmpty) {
      print('[SwissProvider] No links to parse');
      return [];
    }
    
    print('[SwissProvider] Parsing ${links.length} links...');
    final areas = <ClickableArea>[];
    
    for (final link in links) {
      final page = link['page'] as int?;
      final row = link['row'] as int?;
      final col = link['col'] as int?;
      final width = link['width'] as int?;
      final height = link['height'] as int?;
      final text = link['text'] as String?;
      
      print('[SwissProvider] Link: page=$page, row=$row, col=$col, w=$width, h=$height, text=$text');
      
      if (page != null && row != null && col != null && width != null && height != null) {
        // Le coordinate devono essere in pixel dell'immagine GIF originale
        // L'immagine GIF Swiss Teletext è 640x460 pixel
        // La griglia teletext è 40 colonne x 23 righe (non 41x24!)
        const imageWidth = 640.0;
        const imageHeight = 460.0;
        const gridCols = 40.0;
        const gridRows = 23.0;
        
        // Calcola la dimensione di una cella della griglia
        final cellWidth = imageWidth / gridCols;   // 16.0 pixel per colonna
        final cellHeight = imageHeight / gridRows; // 20.0 pixel per riga
        
        // Le colonne (X) sono già 0-indexed, le righe (Y) sono 1-indexed
        final x = (col * cellWidth).toInt();
        final y = ((row - 1) * cellHeight).toInt();  // Row è 1-indexed
        final w = (width * cellWidth).toInt();
        final h = (height * cellHeight).toInt();
        
        print('[SwissProvider] Grid: col=$col (0-idx), row=$row (1-idx) → Pixels: x=$x, y=$y, w=$w, h=$h, target=$page');
        
        areas.add(ClickableArea(
          x: x,
          y: y,
          width: w,
          height: h,
          targetPage: page,
          description: text ?? 'Pagina $page',
        ));
      } else {
        print('[SwissProvider] Skipping link - missing data');
      }
    }
    
    print('[SwissProvider] Created ${areas.length} clickable areas');
    return areas;
  }
  

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // I canali svizzeri non hanno pagine regionali separate
    print('[SwissProvider] Regional pages not supported, fetching national page');
    return fetchNationalPage(pageNumber, subPage: subPage);
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

