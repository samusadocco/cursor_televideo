import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per BR Text (Bayerischer Rundfunk - Germania/Baviera)
/// 
/// BR Text usa un formato HTML simile ad ARD.
/// URL base: https://www.br.de/fernsehen/ardtext/ardtext-100.html?vtxpage=XXX_Y
/// Il parametro vtxpage è formato da: numero_pagina + "_" + sottopagina
class BRProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://www.br.de';
  static const String _pageEndpoint = '/fernsehen/ardtext/ardtext-100.html';

  BRProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'br_text';

  @override
  String get providerName => 'BR Text';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[BRProvider] Fetching page $pageNumber subpage $subPage');
      
      // Formato BR: vtxpage=100_1 (pagina_sottopagina)
      final vtxpage = '${pageNumber}_$subPage';
      final url = '$_baseUrl$_pageEndpoint?vtxpage=$vtxpage';
      print('[BRProvider] URL: $url');
      
      final response = await _dio.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final html = response.data as String;
      return _parseHtmlPage(html, pageNumber, subPage);
    } catch (e) {
      print('[BRProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // BR è già regionale (Baviera), usa lo stesso endpoint
    print('[BRProvider] Fetching regional page for $regionCode: $pageNumber');
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

  /// Parse l'HTML della pagina BR e crea un TelevideoPage
  TelevideoPage _parseHtmlPage(String html, int pageNumber, int subPage) {
    print('[BRProvider] Parsing HTML for page $pageNumber, subpage $subPage...');
    
    final document = parse(html);
    
    // Cerca il container BR: seite_X dove X è il numero della sottopagina
    final containerId = 'seite_$subPage';
    var pageDiv = document.getElementById(containerId);
    
    if (pageDiv == null) {
      print('[BRProvider] ERROR: $containerId not found in HTML');
      print('[BRProvider] Available IDs: ${document.querySelectorAll('[id]').map((e) => e.id).join(", ")}');
      throw Exception('Page content div not found (tried $containerId)');
    }
    
    print('[BRProvider] Using div: ${pageDiv.id}');

    // Converti i percorsi relativi in assoluti
    _convertRelativeUrlsToAbsolute(pageDiv);

    // Estrai i link cliccabili
    final clickableAreas = _extractClickableAreas(pageDiv);
    
    // Estrai informazioni di navigazione (prev/next page)
    final navInfo = _extractNavigationInfo(document);
    print('[BRProvider] Navigation - Prev: ${navInfo['prev']}, Next: ${navInfo['next']}');
    
    // Estrai informazioni sulle sottopagine
    final subPageInfo = _extractSubPageInfo(document);
    
    print('[BRProvider] Found ${clickableAreas.length} clickable areas');
    print('[BRProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');

    // URL per reference
    final vtxpage   = '${pageNumber}_$subPage';
    final imageUrl = '$_baseUrl$_pageEndpoint?vtxpage=$vtxpage';

    final totalSubPages = subPageInfo['total'] ?? 1;
    
    // Prepara metadata con informazioni di navigazione
    // Usa 'prev' e 'next' per coerenza con ZDF
    final metadata = <String, dynamic>{};
    if (navInfo['prev'] != null) {
      metadata['prev'] = navInfo['prev'];
      print('[BRProvider] Setting prev page in metadata: ${navInfo['prev']}');
    }
    if (navInfo['next'] != null) {
      metadata['next'] = navInfo['next'];
      print('[BRProvider] Setting next page in metadata: ${navInfo['next']}');
    }
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: imageUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: true, // Flag per indicare che è HTML, non immagine
      htmlContent: pageDiv.outerHtml, // Salva l'HTML grezzo
      providerId: providerId,
      metadata: metadata.isNotEmpty ? metadata : null, // Salva prev/next in metadata
    );
  }

  /// Converte i percorsi relativi in assoluti
  void _convertRelativeUrlsToAbsolute(dom.Element element) {
    // Converti immagini
    final images = element.querySelectorAll('img[src]');
    for (final img in images) {
      final src = img.attributes['src'];
                                                                                                                                                                                                                                                                                                    if (src != null && !src.startsWith('http')) {
                                                                                                                                                                                                                                                                                                      final absoluteUrl = src.startsWith('/')
                                                                                                                                                                                                                                                                                                          ? '$_baseUrl$src'
                                                                                                                                                                                                                                                                                                          : '$_baseUrl/$src';
                                                                                                                                                                                                                                                                                                      img.attributes['src'] = absoluteUrl;
                                                                                                                                                                                                                                                                                                      print('[BRProvider] Converted image: $src -> $absoluteUrl');
                                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                                  }

                                                                                                                                                                                                                                                                                                  // Converti link CSS
                                                                                                                                                                                                                                                                                                  final links = element.querySelectorAll('link[href]');
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null && !href.startsWith('http') && href.endsWith('.css')) {
        final absoluteUrl = href.startsWith('/')
            ? '$_baseUrl$href'
            : '$_baseUrl/$href';
        link.attributes['href'] = absoluteUrl;
        print('[BRProvider] Converted CSS: $href -> $absoluteUrl');
      }
    }
  }

  /// Estrae informazioni di navigazione (pagina precedente/successiva)
  Map<String, int?> _extractNavigationInfo(dom.Document document) {
    // BR usa una struttura specifica per la navigazione:
    // <div class="bayerntext_page">
    //   <a title="vorherige Seite" href="?vtxpage=117_1"><span class="bayerntext_pre_button">...</span></a>
    //   <a title="nächste Seite" href="?vtxpage=130_1"><span class="bayerntext_next_button">...</span></a>
    // </div>
    
    int? prevPage;
    int? nextPage;
    
    // Cerca il link con bayerntext_pre_button (pagina precedente)
    final preButton = document.querySelector('.bayerntext_pre_button');
    if (preButton != null) {
      // Il link è il parent dello span
      final preLink = preButton.parent;
      if (preLink != null && preLink.localName == 'a') {
        final href = preLink.attributes['href'];
        if (href != null) {
          final pageMatch = RegExp(r'vtxpage=(\d+)').firstMatch(href);
          if (pageMatch != null) {
            prevPage = int.tryParse(pageMatch.group(1)!);
          }
        }
      }
    }
    
    // Cerca il link con bayerntext_next_button (pagina successiva)
    final nextButton = document.querySelector('.bayerntext_next_button');
    if (nextButton != null) {
      // Il link è il parent dello span
      final nextLink = nextButton.parent;
      if (nextLink != null && nextLink.localName == 'a') {
        final href = nextLink.attributes['href'];
        if (href != null) {
          final pageMatch = RegExp(r'vtxpage=(\d+)').firstMatch(href);
          if (pageMatch != null) {
            nextPage = int.tryParse(pageMatch.group(1)!);
          }
        }
      }
    }
    
    return {
      'prev': prevPage,
      'next': nextPage,
    };
  }

  /// Estrae le aree cliccabili (link a altre pagine)
  List<ClickableArea> _extractClickableAreas(dom.Element pageDiv) {
    final areas = <ClickableArea>[];
    
    // Trova tutti i link nel documento
    // BR usa il formato: ardtext-100.html?vtxpage=XXX_Y
    final links = pageDiv.querySelectorAll('a[href*="vtxpage="]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dall'href: vtxpage=123_1
      final pageMatch = RegExp(r'vtxpage=(\d+)').firstMatch(href);
      if (pageMatch == null) continue;
      
      final targetPage = int.tryParse(pageMatch.group(1)!);
      if (targetPage == null) continue;
      
      // Ottieni il testo del link
      final text = link.text.trim();
      
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
    // BR usa una struttura specifica per le sottopagine:
    // <div class="bayerntext_sub_page">
    //   <span class="active_page">1/2</span>
    // </div>
    
    // Cerca il div con class bayerntext_sub_page
    final subPageDiv = document.querySelector('.bayerntext_sub_page');
    if (subPageDiv != null) {
      // Cerca lo span con class active_page
      final activePage = subPageDiv.querySelector('.active_page');
      if (activePage != null) {
        final text = activePage.text.trim();
        print('[BRProvider] Found subpage info: $text');
        
        // Formato: "1/2"
        final match = RegExp(r'(\d+)/(\d+)').firstMatch(text);
        if (match != null) {
          final current = int.tryParse(match.group(1)!);
          final total = int.tryParse(match.group(2)!);
          print('[BRProvider] Parsed subpages: $current/$total');
          return {
            'current': current,
            'total': total,
          };
        }
      }
    }
    
    print('[BRProvider] No subpage info found, defaulting to 1/1');
    return {'current': 1, 'total': 1};
  }
}

