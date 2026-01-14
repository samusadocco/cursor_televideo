import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per WDR Text (Westdeutscher Rundfunk - Germania/Renania Settentrionale-Vestfalia)
/// 
/// WDR Text usa un formato HTML semplice.
/// URL base: https://mobiltext.wdr.de/
/// Gli URL delle pagine sono nel formato: https://mobiltext.wdr.de/XXX.html
class WDRProvider implements TeletextProvider {
  final Dio _dio;
  static const String _baseUrl = 'https://mobiltext.wdr.de';

  WDRProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'wdr_text';

  @override
  String get providerName => 'WDR Text';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[WDRProvider] Fetching page $pageNumber subpage $subPage');
      
      // Costruisci l'URL diretto: https://mobiltext.wdr.de/XXX.html
      final targetUrl = '$_baseUrl/$pageNumber.html';
      print('[WDRProvider] Target URL: $targetUrl');
      
      final response = await _dio.get(targetUrl);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final html = response.data as String;
      return _parseHtmlPage(html, pageNumber, subPage, targetUrl);
    } catch (e) {
      print('[WDRProvider] Error fetching page: $e');
      rethrow;
    }
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    // WDR è già regionale (Renania Settentrionale-Vestfalia), usa lo stesso endpoint
    print('[WDRProvider] Fetching regional page for $regionCode: $pageNumber');
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

  /// Parse l'HTML della pagina WDR e crea un TelevideoPage
  TelevideoPage _parseHtmlPage(String html, int pageNumber, int subPage, String sourceUrl) {
    print('[WDRProvider] Parsing HTML for page $pageNumber, subpage $subPage...');
    
    final document = parse(html);
    
    // Cerca il container WDR: seite_X dove X è il numero della sottopagina
    final containerId = 'seite_$subPage';
    var pageDiv = document.getElementById(containerId);
    
    if (pageDiv == null) {
      print('[WDRProvider] ERROR: $containerId not found in HTML');
      print('[WDRProvider] Available IDs: ${document.querySelectorAll('[id]').map((e) => e.id).join(", ")}');
      throw Exception('Page content div not found (tried $containerId)');
    }
    
    print('[WDRProvider] Using div: ${pageDiv.id}');

    // Converti i percorsi relativi in assoluti (sia per il div che per il documento completo)
    _convertRelativeUrlsToAbsolute(document);

    // Estrai i link cliccabili
    final clickableAreas = _extractClickableAreas(pageDiv);
    
    // Estrai informazioni di navigazione (prev/next page)
    final navInfo = _extractNavigationInfo(document);
    print('[WDRProvider] Navigation - Prev: ${navInfo['prev']}, Next: ${navInfo['next']}');
    
    // Estrai informazioni sulle sottopagine
    final subPageInfo = _extractSubPageInfo(document);
    
    print('[WDRProvider] Found ${clickableAreas.length} clickable areas');
    print('[WDRProvider] SubPage info: ${subPageInfo['current']}/${subPageInfo['total']}');

    final totalSubPages = subPageInfo['total'] ?? 1;
    
    // Prepara metadata con informazioni di navigazione
    final metadata = <String, dynamic>{};
    if (navInfo['prev'] != null) {
      metadata['prev'] = navInfo['prev'];
      print('[WDRProvider] Setting prev page in metadata: ${navInfo['prev']}');
    }
    if (navInfo['next'] != null) {
      metadata['next'] = navInfo['next'];
      print('[WDRProvider] Setting next page in metadata: ${navInfo['next']}');
    }
    
    // Estrai anche vt_row_info per la barra informazioni
    final vtRowInfo = document.getElementById('vt_row_info');
    
    // Costruisci HTML completo con <head> (CSS) + contenuto
    final completeHtml = _buildCompleteHtml(document, pageDiv, vtRowInfo);
    
    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: sourceUrl,
      clickableAreas: clickableAreas,
      timestamp: DateTime.now(),
      isHtmlContent: true,
      htmlContent: completeHtml, // HTML completo con <head> e CSS
      providerId: providerId,
      metadata: metadata.isNotEmpty ? metadata : null,
    );
  }

  /// Costruisce un HTML completo con <head> (CSS) e il contenuto della pagina
  String _buildCompleteHtml(dom.Document document, dom.Element pageDiv, dom.Element? vtRowInfo) {
    final head = document.head;
    
    final buffer = StringBuffer();
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html>');
    
    // Includi tutto il <head> con i CSS
    if (head != null) {
      buffer.writeln(head.outerHtml);
    } else {
      buffer.writeln('<head><meta charset="UTF-8"></head>');
    }
    
    buffer.writeln('<body style="margin:0;padding:0;background-color:black;">');
    
    // Includi vt_row_info se presente (barra informazioni con numero pagina, data, ora)
    if (vtRowInfo != null) {
      buffer.writeln(vtRowInfo.outerHtml);
    }
    
    // Includi il contenuto della pagina (seite_X)
    buffer.writeln(pageDiv.outerHtml);
    buffer.writeln('</body>');
    buffer.writeln('</html>');
    
    final result = buffer.toString();
    print('[WDRProvider] Built complete HTML with head, vt_row_info and CSS (${result.length} chars)');
    return result;
  }

  /// Converte i percorsi relativi in assoluti nell'intero documento
  void _convertRelativeUrlsToAbsolute(dom.Document document) {
    // Converti link CSS (nel <head>)
    final links = document.querySelectorAll('link[rel="stylesheet"], link[href]');
    for (final link in links) {
      final href = link.attributes['href'];
      if (href != null && !href.startsWith('http') && !href.startsWith('data:')) {
        // Per il nuovo formato mobiltext, i CSS sono sempre relativi (css/XXX.css)
        final absoluteUrl = href.startsWith('/')
            ? '$_baseUrl$href'
            : '$_baseUrl/$href';
        link.attributes['href'] = absoluteUrl;
        print('[WDRProvider] Converted CSS: $href -> $absoluteUrl');
      }
    }

    // Converti immagini
    final images = document.querySelectorAll('img[src]');
    for (final img in images) {
      final src = img.attributes['src'];
      if (src != null && !src.startsWith('http') && !src.startsWith('data:')) {
        final absoluteUrl = src.startsWith('/')
            ? '$_baseUrl$src'
            : '$_baseUrl/$src';
        img.attributes['src'] = absoluteUrl;
        print('[WDRProvider] Converted image: $src -> $absoluteUrl');
      }
    }

    // Converti script
    final scripts = document.querySelectorAll('script[src]');
    for (final script in scripts) {
      final src = script.attributes['src'];
      if (src != null && !src.startsWith('http') && !src.startsWith('data:')) {
        final absoluteUrl = src.startsWith('/')
            ? '$_baseUrl$src'
            : '$_baseUrl/$src';
        script.attributes['src'] = absoluteUrl;
        print('[WDRProvider] Converted script: $src -> $absoluteUrl');
      }
    }

    // Converti link HTML (nel formato XXX.html)
    final htmlLinks = document.querySelectorAll('a[href\$=".html"]');
    for (final link in htmlLinks) {
      final href = link.attributes['href'];
      if (href != null && !href.startsWith('http') && !href.startsWith('data:')) {
        final absoluteUrl = href.startsWith('/')
            ? '$_baseUrl$href'
            : '$_baseUrl/$href';
        link.attributes['href'] = absoluteUrl;
        print('[WDRProvider] Converted link: $href -> $absoluteUrl');
      }
    }

    // Converti URL nei CSS inline (tag <style>)
    final styles = document.querySelectorAll('style');
    for (final style in styles) {
      if (style.text.contains('url(')) {
        style.text = _convertCssUrls(style.text, _baseUrl);
      }
    }
  }

  /// Converte gli URL relativi nei CSS inline
  String _convertCssUrls(String css, String baseUrl) {
    return css.replaceAllMapped(RegExp(r'url\(([^)]+)\)'), (match) {
      var url = match.group(1)!.trim();
      // Rimuovi virgolette se presenti
      if ((url.startsWith('"') && url.endsWith('"')) ||
          (url.startsWith("'") && url.endsWith("'"))) {
        url = url.substring(1, url.length - 1);
      }
      // Se è già assoluto o data URI, lascia com'è
      if (url.startsWith('http') || url.startsWith('data:')) {
        return match.group(0)!;
      }
      // Converti in assoluto
      final absoluteUrl = url.startsWith('/') ? '$baseUrl$url' : '$baseUrl/$url';
      return 'url("$absoluteUrl")';
    });
  }

  /// Estrae informazioni di navigazione (pagina precedente/successiva)
  Map<String, int?> _extractNavigationInfo(dom.Document document) {
    int? prevPage;
    int? nextPage;
    
    // WDR mobiltext usa link nel formato XXX.html
    // Cerca i link di navigazione (di solito nei pulsanti rosso/verde)
    final navLinks = document.querySelectorAll('a[href\$=".html"]');
    
    for (final link in navLinks) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dal formato XXX.html
      final pageMatch = RegExp(r'(\d+)\.html$').firstMatch(href);
      if (pageMatch == null) continue;
      
      final pageNum = int.tryParse(pageMatch.group(1)!);
      if (pageNum == null) continue;
      
      // Determina se è prev o next basandosi sul colore del pulsante o sul testo
      final classes = link.classes.join(' ').toLowerCase();
      final parentClasses = link.parent?.classes.join(' ').toLowerCase() ?? '';
      
      // Rosso (- / prev) o Verde (+ / next)
      if (classes.contains('red') || parentClasses.contains('red') || 
          classes.contains('bg_red') || parentClasses.contains('bg_red')) {
        prevPage = pageNum;
      } else if (classes.contains('green') || parentClasses.contains('green') ||
                 classes.contains('bg_green') || parentClasses.contains('bg_green')) {
        nextPage = pageNum;
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
    
    // Trova tutti i link nel formato XXX.html
    final links = pageDiv.querySelectorAll('a[href\$=".html"]');
    
    for (final link in links) {
      final href = link.attributes['href'];
      if (href == null) continue;
      
      // Estrai il numero di pagina dall'href: XXX.html
      final pageMatch = RegExp(r'(\d+)\.html$').firstMatch(href);
      if (pageMatch == null) continue;
      
      final targetPage = int.tryParse(pageMatch.group(1)!);
      if (targetPage == null) continue;
      
      // Ottieni il testo del link (rimuovi i tag invisibili)
      final visibleSpans = link.querySelectorAll('span:not(.invisible)');
      final text = visibleSpans.map((e) => e.text).join(' ').trim();
      
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

  /// Estrae informazioni sulle sottopagine dal tag #subpage_count
  Map<String, int?> _extractSubPageInfo(dom.Document document) {
    // WDR mobiltext: cerca tutti i tag con id="seite_X" (es. seite_1, seite_2, etc.)
    // e trova il valore massimo per determinare il numero di sottopagine
    
    int maxSubPage = 1;
    int currentSubPage = 1;
    
    // Cerca tutti gli elementi nel documento
    final allElements = document.querySelectorAll('*[id]');
    
    for (final element in allElements) {
      final id = element.id;
      
      // Verifica se l'id corrisponde al pattern seite_X
      final seiteMatch = RegExp(r'^seite_(\d+)$').firstMatch(id);
      
      if (seiteMatch != null) {
        final pageNum = int.tryParse(seiteMatch.group(1)!);
        if (pageNum != null && pageNum > maxSubPage) {
          maxSubPage = pageNum;
        }
        
        // Determina quale sottopagina è quella corrente 
        // (quella visibile o senza classe "hidden"/"hide")
        if (!element.classes.contains('hidden') && 
            !element.classes.contains('hide') &&
            element.attributes['style']?.contains('display:none') != true &&
            element.attributes['style']?.contains('display: none') != true) {
          final num = int.tryParse(seiteMatch.group(1)!);
          if (num != null) {
            currentSubPage = num;
          }
        }
      }
    }
    
    print('[WDRProvider] Found $maxSubPage subpages (current: $currentSubPage)');
    print('[WDRProvider] SubPage elements found: ${allElements.where((e) => e.id.startsWith('seite_')).map((e) => e.id).join(', ')}');
    
    return {
      'current': currentSubPage,
      'total': maxSubPage,
    };
  }
}

