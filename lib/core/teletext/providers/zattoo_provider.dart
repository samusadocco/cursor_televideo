import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/ocr/google_vision_ocr_service.dart';
import 'package:cursor_televideo/core/cache/subpage_cache_service.dart';

/// Provider generico per canali Teletext su piattaforma Zattoo con OCR Google Cloud Vision
/// Supporta ARTE e altri canali Zattoo futuri
class ZattooProvider implements TeletextProvider {
  final Dio _dio;
  final GoogleVisionOcrService _ocrService;
  final String _channelId; // es. 'DE_arte', 'rbb', 'mdr-sachsen', etc.
  final String _providerId;
  final String _providerName;
  final String _countryCode;
  final String _apiDomain; // 'zapi' o 'zattoo-abox'

  ZattooProvider({
    required String channelId,
    required String providerId,
    required String providerName,
    required String countryCode,
    String apiDomain = 'zapi', // default 'zapi.zattoo.com'
    Dio? dio,
    GoogleVisionOcrService? ocrService,
  })  : _channelId = channelId,
        _providerId = providerId,
        _providerName = providerName,
        _countryCode = countryCode,
        _apiDomain = apiDomain,
        _dio = dio ?? Dio(),
        _ocrService = ocrService ?? GoogleVisionOcrService();

  /// Factory per ARTE (Germania/Francia)
  factory ZattooProvider.arte() {
    return ZattooProvider(
      channelId: 'DE_arte',
      providerId: 'arte_text',
      providerName: 'ARTE Text',
      countryCode: 'DE',
    );
  }

  /// Factory per RBB (Rundfunk Berlin-Brandenburg)
  factory ZattooProvider.rbb() {
    return ZattooProvider(
      channelId: 'rbb',
      providerId: 'rbb_text',
      providerName: 'RBB Text',
      countryCode: 'DE',
    );
  }

  /// Factory per MDR (Mitteldeutscher Rundfunk - Sachsen)
  factory ZattooProvider.mdr() {
    return ZattooProvider(
      channelId: 'mdr-sachsen',
      providerId: 'mdr_text',
      providerName: 'MDR Text',
      countryCode: 'DE',
    );
  }

  /// Factory per ARD Alpha (Bildungskanal)
  factory ZattooProvider.ardAlpha() {
    return ZattooProvider(
      channelId: 'br-alpha',
      providerId: 'ard_alpha_text',
      providerName: 'ARD Alpha Text',
      countryCode: 'DE',
    );
  }

  /// Factory per Phoenix (Ereignis- und Dokumentationskanal)
  factory ZattooProvider.phoenix() {
    return ZattooProvider(
      channelId: 'phoenix',
      providerId: 'phoenix_text',
      providerName: 'Phoenix Text',
      countryCode: 'DE',
    );
  }

  /// Factory per n-tv (Nachrichtensender)
  factory ZattooProvider.ntv() {
    return ZattooProvider(
      channelId: 'ntv_de',
      providerId: 'ntv_text',
      providerName: 'n-tv Text',
      countryCode: 'DE',
      apiDomain: 'zattoo-abox',
    );
  }

  /// Factory per VOX
  factory ZattooProvider.vox() {
    return ZattooProvider(
      channelId: 'vox',
      providerId: 'vox_text',
      providerName: 'VOX Text',
      countryCode: 'DE',
      apiDomain: 'zattoo-abox',
    );
  }

  /// Factory per RTL (Germania)
  factory ZattooProvider.rtl() {
    return ZattooProvider(
      channelId: 'rtl',
      providerId: 'rtl_text',
      providerName: 'RTL Text',
      countryCode: 'DE',
      apiDomain: 'zattoo-abox',
    );
  }

  String get _baseUrl => 'https://$_apiDomain.zattoo.com/teletext/$_channelId/hd/';

  @override
  String get providerId => _providerId;

  @override
  String get providerName => _providerName;

  @override
  String get countryCode => _countryCode;

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  /// Rileva il numero massimo di sottopagine provando sequenzialmente
  /// Usa cache con TTL 5 minuti per evitare probe ripetuti
  Future<int> _detectMaxSubPages(int pageNumber) async {
    // Controlla cache prima
    final cached = SubpageCacheService.getCachedSubpageCount(
      providerId: providerId,
      pageNumber: pageNumber,
    );
    
    if (cached != null) {
      return cached;
    }
    
    print('[Zattoo/$_channelId] Detecting subpages for page $pageNumber...');
    
    int maxSubPages = 1;
    
    // Prova sottopagina 2, 3, 4, ... finché non trovi 404
    // Limite massimo 10 sottopagine per evitare troppe richieste
    for (int subPageNum = 2; subPageNum <= 10; subPageNum++) {
      try {
        final testUrl = '$_baseUrl$pageNumber/$subPageNum.html';
        final response = await _dio.get(
          testUrl,
          options: Options(
            responseType: ResponseType.plain,
            validateStatus: (status) => status! < 500,
          ),
        ).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          maxSubPages = subPageNum;
          print('[Zattoo/$_channelId] Subpage $subPageNum exists');
        } else if (response.statusCode == 404) {
          // Non esiste, fermati
          print('[Zattoo/$_channelId] Subpage $subPageNum not found, stopping probe');
          break;
        }
      } catch (e) {
        // Errore o timeout, assumiamo che non esista
        print('[Zattoo/$_channelId] Subpage $subPageNum probe failed: $e');
        break;
      }
    }
    
    print('[Zattoo/$_channelId] ✅ Detected $maxSubPages subpages for page $pageNumber');
    
    // Salva in cache (5 minuti)
    SubpageCacheService.cacheSubpageCount(
      providerId: providerId,
      pageNumber: pageNumber,
      maxSubPages: maxSubPages,
    );
    
    return maxSubPages;
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

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[Zattoo/$_channelId] Fetching page $pageNumber, subpage $subPage');

    final targetUrl = '$_baseUrl$pageNumber/$subPage.html';
    print('[Zattoo/$_channelId] Target URL: $targetUrl');

    try {
      // Scarica l'HTML che contiene l'immagine embedded
      final response = await _dio.get(
        targetUrl,
        options: Options(
          responseType: ResponseType.plain, // HTML come stringa
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        print('[Zattoo/$_channelId] Page not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[Zattoo/$_channelId] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }

      // Parsa l'HTML per estrarre il data URI dell'immagine
      final htmlContent = response.data as String;
      final document = html_parser.parse(htmlContent);
      final imgElement = document.querySelector('img');
      
      if (imgElement == null || !imgElement.attributes.containsKey('src')) {
        print('[Zattoo/$_channelId] No image found in HTML');
        throw Exception('Immagine non trovata nell\'HTML');
      }

      final dataUri = imgElement.attributes['src']!;
      print('[Zattoo/$_channelId] Data URI extracted from HTML: ${dataUri.substring(0, 50)}...');

      final ocrAvailable = await _ocrService.isAvailable;
      final lazyOcrPending = ocrAvailable && subPage == 1;
      if (lazyOcrPending) {
        print('[Zattoo/$_channelId] OCR deferred to background (lazy ML Kit)');
      }

      // Rileva sottopagine provando sequenzialmente
      // Prima controlla cache (disponibile per tutte le sottopagine)
      int maxSubPages = SubpageCacheService.getCachedSubpageCount(
        providerId: providerId,
        pageNumber: pageNumber,
      ) ?? 1;
      
      // Se non in cache e siamo sulla sottopagina 1, esegui rilevamento
      if (maxSubPages == 1 && subPage == 1) {
        maxSubPages = await _detectMaxSubPages(pageNumber);
      }
      
      print('[Zattoo/$_channelId] Page $pageNumber/$subPage has maxSubPages: $maxSubPages');

      return TelevideoPage(
        pageNumber: pageNumber,
        imageUrl: dataUri, // Data URI estratto dall'HTML
        subPage: subPage,
        maxSubPages: maxSubPages,
        isHtmlContent: false, // È un'immagine
        providerId: providerId,
        clickableAreas: const [],
        metadata: {
          'source': 'zattoo',
          'format': 'image',
          'originalUrl': targetUrl,
          'ocrEnabled': ocrAvailable && subPage == 1,
          'lazyOcrPending': lazyOcrPending,
          if (lazyOcrPending) 'lazyOcrEngine': 'zattoo',
          'ocrLinksCount': 0,
          'linksCount': 0,
          'subpagesDetected': maxSubPages,
        },
      );
    } catch (e) {
      print('[Zattoo/$_channelId] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // Zattoo non supporta pagine regionali
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  /// Rilascia le risorse
  void dispose() {
    _dio.close();
    _ocrService.dispose();
  }
}
