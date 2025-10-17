import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per ARD Text (Germania)
/// 
/// ARD Text usa un formato HTML con span e immagini per i caratteri.
/// URL base: https://www.ard-text.de/page_only.php?page=XXX&sub=Y
class ARDProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.ard-text.de';
  static const String _pageEndpoint = '/index.php'; // URL completo con layout

  ARDProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'ard_text';

  @override
  String get providerName => 'ARD Text';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => true;

  @override
  List<String> get supportedRegions => [
        'BR', // Bayern
        'HR', // Hessen
        'MDR', // Mitteldeutscher Rundfunk
        'NDR', // Norddeutscher Rundfunk
        'RBB', // Berlin-Brandenburg
        'SR', // Saarland
        'SWR', // Südwestrundfunk
        'WDR', // Westdeutscher Rundfunk
      ];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[ARDProvider] Fetching national page $pageNumber subpage $subPage');
      
      final url = '$_baseUrl$_pageEndpoint?page=$pageNumber&sub=$subPage';
      print('[ARDProvider] URL: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final html = response.data as String;
      return _parseHtmlPage(html, pageNumber, subPage);
    } catch (e) {
      print('[ARDProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // ARD ha pagine regionali specifiche per broadcaster
    // Per ora usiamo lo stesso endpoint, ma potremmo dover aggiungere
    // un parametro regionale in futuro
    print('[ARDProvider] Fetching regional page for $regionCode: $pageNumber');
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

  /// Parse l'HTML della pagina ARD e crea un TelevideoPage
  TelevideoPage _parseHtmlPage(String html, int pageNumber, int subPage) {
    print('[ARDProvider] Parsing HTML...');
    
    final document = parse(html);
    
    // Cerca prima ardtext_classic (versione desktop), poi page_1 (fallback)
    var pageDiv = document.getElementById('ardtext_classic');
    if (pageDiv == null) {
      print('[ARDProvider] ardtext_classic not found, trying page_1');
      pageDiv = document.getElementById('page_1');
    }
    
    if (pageDiv == null) {
      print('[ARDProvider] ERROR: No content div found in HTML');
      print('[ARDProvider] Available IDs: ${document.querySelectorAll('[id]').map((e) => e.id).join(", ")}');
      throw Exception('Page content div not found (tried ardtext_classic and page_1)');
    }
    
    print('[ARDProvider] Using div: ${pageDiv.id}');

    // Converti l'HTML in un formato renderizzabile
    // ARD usa caratteri speciali rappresentati come immagini
    // Per ora, creiamo un'immagine dalla pagina HTML renderizzata
    
    // Estrai i link cliccabili
    final clickableAreas = _extractClickableAreas(pageDiv);
    
    // Estrai informazioni sulle sottopagine
    final subPageInfo = _extractSubPageInfo(document);
    
    print('[ARDProvider] Found ${clickableAreas.length} clickable areas');
    print('[ARDProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');

    // Per ARD, useremo l'URL della pagina come imageUrl
    // La nostra app dovrà renderizzare l'HTML invece di mostrare un'immagine
    final imageUrl = '$_baseUrl$_pageEndpoint?page=$pageNumber&sub=$subPage';

    final totalSubPages = subPageInfo['total'] ?? 1;
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages, // Imposta maxSubPages per l'UI
      totalSubPages: totalSubPages,
      imageUrl: imageUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: true, // Flag per indicare che è HTML, non immagine
      htmlContent: pageDiv.outerHtml, // Salva l'HTML grezzo
      providerId: providerId,
    );
  }

  /// Estrae le aree cliccabili (link a altre pagine)
  List<ClickableArea> _extractClickableAreas(dom.Element pageDiv) {
    final areas = <ClickableArea>[];
    
    // Trova tutti i link nel documento
    final links = pageDiv.querySelectorAll('a[href*="index.php?page="]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dall'href
      final pageMatch = RegExp(r'page=(\d+)').firstMatch(href);
      if (pageMatch == null) continue;
      
      final targetPage = int.tryParse(pageMatch.group(1)!);
      if (targetPage == null) continue;
      
      // Ottieni il testo del link
      final text = link.text.trim();
      
      // Per ora, non abbiamo informazioni precise sulla posizione
      // In futuro, potremmo usare getBoundingClientRect() con JavaScript
      areas.add(ClickableArea(
        x: 0,
        y: 0,
        width: 100,
        height: 30,
        targetPage: targetPage,
        description: text.isNotEmpty ? text : 'Seite $targetPage',
      ));
    }
    
    return areas;
  }

  /// Estrae informazioni sulle sottopagine
  Map<String, int?> _extractSubPageInfo(dom.Document document) {
    // Cerca il contatore delle sottopagine: "1/3"
    final subpageCounter = document.querySelector('#output_unterseite');
    if (subpageCounter != null) {
      final text = subpageCounter.text.trim();
      final match = RegExp(r'(\d+)/(\d+)').firstMatch(text);
      if (match != null) {
        return {
          'current': int.tryParse(match.group(1)!),
          'total': int.tryParse(match.group(2)!),
        };
      }
    }
    
    return {'current': 1, 'total': 1};
  }
}

