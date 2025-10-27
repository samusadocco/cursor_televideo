import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class RTVSLOProvider extends TeletextProvider {
  static const String baseUrl = 'https://teletext.rtvslo.si';
  
  @override
  String get providerId => 'rtvslo_teletext';
  
  @override
  String get providerName => 'RTV SLO Teletext';
  
  @override
  String get countryCode => 'SI';
  
  @override
  bool get supportsRegions => false;
  
  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[RTVSLOProvider] Fetching page $pageNumber subpage $subPage');
    
    final url = '$baseUrl/$pageNumber/$subPage';
    print('[RTVSLOProvider] URL: $url');
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
      
      final document = html_parser.parse(response.body);
      return _parseHtmlPage(document, pageNumber, subPage);
    } catch (e) {
      print('[RTVSLOProvider] Error: $e');
      rethrow;
    }
  }

  TelevideoPage _parseHtmlPage(dom.Document document, int pageNumber, int currentSubPage) {
    // Estrai l'immagine
    final imgElement = document.querySelector('img#mainDisplay');
    if (imgElement == null) {
      throw Exception('No teletext image found in HTML');
    }
    
    final imgSrc = imgElement.attributes['src'];
    if (imgSrc == null || imgSrc.isEmpty) {
      throw Exception('Image source not found');
    }
    
    // Costruisci l'URL assoluto dell'immagine
    final imageUrl = imgSrc.startsWith('http') ? imgSrc : '$baseUrl$imgSrc';
    print('[RTVSLOProvider] Image URL: $imageUrl');
    
    // Estrai il numero totale di sottopagine
    int totalSubPages = 1;
    final subPageLinks = document.querySelectorAll('a.podstranLink');
    if (subPageLinks.isNotEmpty) {
      totalSubPages = subPageLinks.length;
      print('[RTVSLOProvider] Found $totalSubPages subpages');
    }
    
    // Estrai la mappa dei link cliccabili
    final mapName = imgElement.attributes['usemap']?.replaceAll('#', '');
    final clickableAreas = <ClickableArea>[];
    
    if (mapName != null && mapName.isNotEmpty) {
      final mapElement = document.querySelector('map[name="$mapName"]');
      if (mapElement != null) {
        final areas = mapElement.querySelectorAll('area');
        print('[RTVSLOProvider] Found ${areas.length} clickable areas');
        
        for (final area in areas) {
          final coords = area.attributes['coords'];
          final href = area.attributes['href'];
          
          if (coords != null && href != null) {
            final coordsList = coords.split(',').map((c) => int.tryParse(c.trim()) ?? 0).toList();
            if (coordsList.length == 4) {
              // Estrai il numero di pagina dall'href (formato: /102/1)
              final match = RegExp(r'/(\d+)/\d+').firstMatch(href);
              if (match != null) {
                final targetPage = int.tryParse(match.group(1)!);
                if (targetPage != null) {
                  clickableAreas.add(ClickableArea(
                    x: coordsList[0],
                    y: coordsList[1],
                    width: coordsList[2] - coordsList[0],
                    height: coordsList[3] - coordsList[1],
                    targetPage: targetPage,
                  ));
                }
              }
            }
          }
        }
      }
    }
    
    print('[RTVSLOProvider] Parsed ${clickableAreas.length} clickable areas');
    
    // Estrai prev/next page dai link di navigazione
    String? prevPage;
    String? nextPage;
    
    // I link di navigazione non sono sempre presenti, quindi li lasciamo null
    // e usiamo la navigazione standard +1/-1
    
    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      clickableAreas: clickableAreas,
      isHtmlContent: false,
      providerId: providerId,
      metadata: {
        'prevPage': prevPage,
        'nextPage': nextPage,
      },
    );
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) async {
    // RTV SLO non ha pagine regionali, usa sempre le nazionali
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

