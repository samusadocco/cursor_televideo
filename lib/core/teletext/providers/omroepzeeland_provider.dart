import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per Omroep Zeeland Teletekst (Olanda)
/// Canale basato su immagini con link cliccabili estratti da HTML
class OmroepZeelandProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://teletxt.omroepzeeland.nl/teletext.php';

  OmroepZeelandProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'omroepzeeland_teletekst';

  @override
  String get providerName => 'Omroep Zeeland';

  @override
  String get countryCode => 'NL';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

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
    print('[OmroepZeeland] Fetching page $pageNumber, subpage $subPage');

    // Formato URL: page=100s0 (sottopagina - 1, quindi subPage 1 = s0, subPage 2 = s1, etc.)
    final subPageParam = subPage - 1;
    final targetUrl = '$_baseUrl?page=${pageNumber}s$subPageParam';
    
    print('[OmroepZeeland] Target URL: $targetUrl');

    try {
      final response = await _dio.get(
        targetUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 404) {
        print('[OmroepZeeland] Page not found: $pageNumber/$subPage');
        throw Exception('Pagina non trovata');
      }

      if (response.statusCode != 200) {
        print('[OmroepZeeland] HTTP error: ${response.statusCode}');
        throw Exception('Errore HTTP: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      final document = html_parser.parse(htmlContent);

      // Estrai URL immagine da <img src="/teletext/100s00.png">
      final imgElement = document.querySelector('div.tt-content img[src*="/teletext/"]');
      
      if (imgElement == null) {
        print('[OmroepZeeland] Error: image not found in div.tt-content');
        throw Exception('Immagine Teletext non trovata');
      }

      var imageUrl = imgElement.attributes['src'] ?? '';
      
      // Se l'URL è relativo, rendilo assoluto
      if (imageUrl.startsWith('/')) {
        imageUrl = 'https://teletxt.omroepzeeland.nl$imageUrl';
      }
      
      print('[OmroepZeeland] Image URL: $imageUrl');
      
      // Verifica se la pagina esiste: se richiediamo pagina != 100 ma riceviamo 100s00.png,
      // significa che la pagina non esiste (il server restituisce sempre la pagina 100 come fallback)
      if (pageNumber != 100 && imageUrl.contains('100s00.png')) {
        print('[OmroepZeeland] Page $pageNumber not found (server returned default page 100)');
        throw Exception('Pagina non trovata');
      }

      // Estrai link cliccabili da <map id="teletextmap">
      final clickableAreas = _extractClickableAreas(document);
      print('[OmroepZeeland] Found ${clickableAreas.length} clickable areas');

      // Estrai numero massimo di sottopagine da <ul class="pagination">
      final maxSubPages = _extractMaxSubPages(document);
      print('[OmroepZeeland] Max subpages: $maxSubPages');

      // Estrai pagine precedenti/successive da <ul class="pagination arrow-nav">
      final navigationInfo = _extractNavigationPages(document, pageNumber);
      print('[OmroepZeeland] Navigation: prev=${navigationInfo['previousPage']}, next=${navigationInfo['nextPage']}');

      return TelevideoPage(
        pageNumber: pageNumber,
        imageUrl: imageUrl,
        subPage: subPage,
        maxSubPages: maxSubPages,
        isHtmlContent: false,
        providerId: providerId,
        clickableAreas: clickableAreas,
        metadata: {
          'source': 'omroepzeeland',
          'format': 'image',
          'originalUrl': targetUrl,
          'linksCount': clickableAreas.length,
          'previousPage': navigationInfo['previousPage'],
          'nextPage': navigationInfo['nextPage'],
        },
      );
    } catch (e) {
      print('[OmroepZeeland] Error fetching page: $e');
      rethrow;
    }
  }

  /// Estrae le aree cliccabili dalla mappa HTML
  List<ClickableArea> _extractClickableAreas(dynamic document) {
    final clickableAreas = <ClickableArea>[];

    // Cerca <map id="teletextmap"> o <map name="teletextmap">
    final map = document.querySelector('map#teletextmap, map[name="teletextmap"]');
    
    if (map == null) {
      print('[OmroepZeeland] No image map found');
      return clickableAreas;
    }

    // Estrai tutti i <area> tags
    final areas = map.querySelectorAll('area[href]');
    
    for (final area in areas) {
      final href = area.attributes['href'];
      final coords = area.attributes['coords'];
      final alt = area.attributes['alt'];
      
      if (href != null && coords != null) {
        // Estrai numero pagina dall'URL: page=101s0 → 101
        final pageMatch = RegExp(r'page=(\d+)s\d+').firstMatch(href);
        if (pageMatch != null) {
          final targetPage = int.tryParse(pageMatch.group(1)!);
          
          if (targetPage != null && targetPage >= 100 && targetPage <= 999) {
            // Parsing coordinate: "30,72,60,84" → x1,y1,x2,y2
            final coordsList = coords.split(',').map((c) => int.tryParse(c.trim()) ?? 0).toList();
            
            if (coordsList.length >= 4) {
              final x = coordsList[0];
              final y = coordsList[1];
              final x2 = coordsList[2];
              final y2 = coordsList[3];
              final width = x2 - x;
              final height = y2 - y;
              
              clickableAreas.add(ClickableArea(
                targetPage: targetPage,
                x: x,
                y: y,
                width: width,
                height: height,
                description: alt ?? 'Pagina $targetPage',
              ));
            }
          }
        }
      }
    }

    return clickableAreas;
  }

  /// Estrae il numero massimo di sottopagine dai link di paginazione
  int _extractMaxSubPages(dynamic document) {
    int maxSubPages = 1;

    // Cerca <ul class="pagination"> (non "arrow-nav")
    final paginationUl = document.querySelectorAll('ul.pagination');
    
    for (final ul in paginationUl) {
      // Salta se è "arrow-nav" (navigazione prev/next)
      final classes = ul.attributes['class'] ?? '';
      if (classes.contains('arrow-nav')) {
        continue;
      }

      // Conta i link alle sottopagine
      // Esempio: <a href="...page=100s1">2</a> indica sottopagina 2
      final links = ul.querySelectorAll('a[href*="page="]');
      
      for (final link in links) {
        final href = link.attributes['href'];
        if (href != null) {
          // Estrai numero sottopagina dall'URL: page=100s1 → 2 (s1 = sottopagina 2)
          final subPageMatch = RegExp(r'page=\d+s(\d+)').firstMatch(href);
          if (subPageMatch != null) {
            final subPageParam = int.tryParse(subPageMatch.group(1)!);
            if (subPageParam != null) {
              final actualSubPage = subPageParam + 1; // s0 = subpage 1, s1 = subpage 2, etc.
              if (actualSubPage > maxSubPages) {
                maxSubPages = actualSubPage;
              }
            }
          }
        }
      }
    }

    return maxSubPages;
  }

  /// Estrae pagine precedenti/successive da <ul class="pagination arrow-nav">
  Map<String, int?> _extractNavigationPages(dynamic document, int currentPage) {
    int? previousPage;
    int? nextPage;

    // Cerca <ul class="pagination arrow-nav">
    final arrowNavUl = document.querySelectorAll('ul.pagination.arrow-nav');
    
    for (final ul in arrowNavUl) {
      final links = ul.querySelectorAll('a[href*="page="]');
      
      for (int i = 0; i < links.length; i++) {
        final link = links[i];
        final href = link.attributes['href'];
        
        if (href != null) {
          // Estrai numero pagina dall'URL: page=100s0 → 100
          final pageMatch = RegExp(r'page=(\d+)s\d+').firstMatch(href);
          if (pageMatch != null) {
            final pageNum = int.tryParse(pageMatch.group(1)!);
            
            if (pageNum != null) {
              // Il primo link è Previous, il secondo è Next
              if (i == 0 && pageNum != currentPage) {
                previousPage = pageNum;
              } else if (i == 1 && pageNum != currentPage) {
                nextPage = pageNum;
              }
            }
          }
        }
      }
    }

    return {
      'previousPage': previousPage,
      'nextPage': nextPage,
    };
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String region,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // Omroep Zeeland non ha pagine regionali
    return fetchNationalPage(pageNumber, subPage: subPage);
  }

  void dispose() {
    _dio.close();
  }
}
