import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Entry della cache per le sottopagine
class _SubPageCacheEntry {
  final int count;
  final DateTime timestamp;
  final DateTime lastVerified;

  _SubPageCacheEntry(this.count, this.timestamp, [DateTime? lastVerified])
      : lastVerified = lastVerified ?? timestamp;

  /// Verifica se la cache è scaduta
  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }

  /// Verifica se è necessario un controllo di consistenza
  bool needsConsistencyCheck(Duration interval) {
    return DateTime.now().difference(lastVerified) > interval;
  }

  /// Crea una nuova entry con timestamp di verifica aggiornato
  _SubPageCacheEntry withVerification() {
    return _SubPageCacheEntry(count, timestamp, DateTime.now());
  }
}

/// Provider per NOS Teletekst (Olanda)
/// Usa HTML puro senza immagini
class NOSProvider implements TeletextProvider {
  final Dio _dio;
  
  // Cache per il numero totale di sottopagine
  // Key: pageNumber, Value: entry con count e timestamp
  final Map<int, _SubPageCacheEntry> _subPageCache = {};
  
  // TTL della cache: 2 ore
  final Duration _cacheTTL = const Duration(hours: 2);
  
  // Intervallo per controllo di consistenza: 10 minuti
  final Duration _consistencyCheckInterval = const Duration(minutes: 10);

  NOSProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'nos_teletekst';

  @override
  String get providerName => 'NOS Teletekst';

  @override
  String get countryCode => 'NL';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[NOSProvider] Fetching page $pageNumber subpage $subPage');

    // Piccolo delay per permettere alla UI di mostrare lo stato loading
    // PRIMA di iniziare la richiesta HTTP
    await Future.delayed(const Duration(milliseconds: 50));

    // Formato URL: https://nos.nl/teletekst/100 (prima sottopagina)
    //              https://nos.nl/teletekst/100/2 (seconda sottopagina)
    //              https://nos.nl/teletekst/100/3 (terza sottopagina)
    final url = subPage == 1 
        ? 'https://nos.nl/teletekst/$pageNumber'
        : 'https://nos.nl/teletekst/$pageNumber/$subPage';

    print('[NOSProvider] URL: $url');

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load page: ${response.statusCode}');
      }

      final htmlContent = response.data as String;
      return await _parseHtmlPage(htmlContent, pageNumber, subPage, url);
    } catch (e) {
      print('[NOSProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Parse la pagina HTML per estrarre il contenuto teletext
  Future<TelevideoPage> _parseHtmlPage(String htmlContent, int pageNumber, int subPage, String pageUrl) async {
    print('[NOSProvider] Parsing HTML...');
    print('[NOSProvider] HTML length: ${htmlContent.length} bytes');

    final document = html_parser.parse(htmlContent);

    // Converti tutti gli URL relativi in assoluti
    final baseUrl = 'https://nos.nl';
    _convertRelativeUrlsToAbsolute(document, baseUrl);

    // Estrai solo il contenuto teletext dal div specifico
    final contentDiv = document.querySelector('div.sc-5fbcdf78-1.bsxcGC');
    
    if (contentDiv == null) {
      print('[NOSProvider] ⚠️ Teletext content div not found');
      throw Exception('Teletext content div not found');
    }

    print('[NOSProvider] ✅ Found teletext content div');

    // Determina il numero totale di sottopagine usando la cache con verifica di consistenza
    int totalSubPages;
    
    if (_subPageCache.containsKey(pageNumber)) {
      final entry = _subPageCache[pageNumber]!;
      final cacheAge = DateTime.now().difference(entry.timestamp);
      final timeSinceVerification = DateTime.now().difference(entry.lastVerified);
      
      print('[NOSProvider] ✅ Cache found - count: ${entry.count}, age: ${cacheAge.inMinutes}m, last verified: ${timeSinceVerification.inMinutes}m ago');
      
      if (entry.isExpired(_cacheTTL)) {
        // Cache scaduta (oltre 2 ore), ricarica completamente
        print('[NOSProvider] ⏰ Cache expired (>${_cacheTTL.inMinutes}m), full reload');
        totalSubPages = await _extractTotalSubPages(document, pageNumber, subPage);
        _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
        print('[NOSProvider] 💾 Cached subpage count: $totalSubPages');
      } else if (entry.needsConsistencyCheck(_consistencyCheckInterval)) {
        // Cache ancora valida ma necessita controllo di consistenza
        print('[NOSProvider] 🔍 Consistency check needed (last verified ${timeSinceVerification.inMinutes}m ago)');
        print('[NOSProvider] 📊 Verifying subpage count...');
        
        // Verifica solo se ce ne sono di nuove, partendo dal conteggio cached
        final updatedCount = await _quickCheckForMoreSubPages(pageNumber, entry.count);
        print('[NOSProvider] ✅ Verification complete');
        
        if (updatedCount > entry.count) {
          // Trovate nuove sottopagine!
          print('[NOSProvider] ✨ Found new subpages: ${entry.count} -> $updatedCount');
          _subPageCache[pageNumber] = _SubPageCacheEntry(updatedCount, DateTime.now());
          totalSubPages = updatedCount;
        } else {
          // Il conteggio è ancora corretto, aggiorna solo il timestamp di verifica
          _subPageCache[pageNumber] = entry.withVerification();
          totalSubPages = entry.count;
          print('[NOSProvider] ✅ Consistency verified: $totalSubPages subpages (unchanged)');
        }
      } else {
        // Cache valida e verificata di recente - USA SUBITO!
        totalSubPages = entry.count;
        print('[NOSProvider] ⚡ Using cached subpage count: $totalSubPages (verified ${timeSinceVerification.inSeconds}s ago) - INSTANT!');
      }
    } else {
      // Prima visita, conta le sottopagine
      print('[NOSProvider] 🆕 First visit to page $pageNumber');
      print('[NOSProvider] 📊 Counting subpages (this may take a moment)...');
      totalSubPages = await _extractTotalSubPages(document, pageNumber, subPage);
      _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
      print('[NOSProvider] ✅ Subpage count complete: $totalSubPages');
      print('[NOSProvider] 💾 Cached for future visits');
    }

    // Estrai link di navigazione
    final navigationLinks = _extractNavigationLinks(document, pageNumber);

    // Estrai i link cliccabili dalla pagina
    final clickableAreas = _extractClickableLinks(contentDiv);

    // Crea un HTML ottimizzato: <head> completo + solo il div teletext
    final optimizedHtml = _buildOptimizedHtml(document, contentDiv);

    print('[NOSProvider] SubPage info: $subPage/$totalSubPages');
    print('[NOSProvider] Navigation: prev=${navigationLinks['prev']}, next=${navigationLinks['next']}');
    print('[NOSProvider] Found ${clickableAreas.length} clickable links');
    print('[NOSProvider] Optimized HTML length: ${optimizedHtml.length} chars');

    return TelevideoPage(
      pageNumber: pageNumber,
      subPage: subPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      imageUrl: pageUrl, // Usiamo l'URL della pagina come riferimento
      htmlContent: optimizedHtml, // HTML ottimizzato con CSS e solo il contenuto teletext
      clickableAreas: clickableAreas, // Link cliccabili estratti dall'HTML
      timestamp: DateTime.now(),
      isHtmlContent: true, // ⭐ IMPORTANTE: usa rendering HTML
      providerId: providerId,
      metadata: navigationLinks,
    );
  }

  /// Costruisce un HTML ottimizzato con solo head + contenuto teletext
  String _buildOptimizedHtml(dom.Document document, dom.Element contentDiv) {
    final head = document.head;
    
    if (head == null) {
      // Fallback: solo il contenuto
      return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body {
      margin: 0;
      padding: 0;
      background: black;
      color: white;
      font-family: monospace;
    }
  </style>
</head>
<body>
${contentDiv.outerHtml}
</body>
</html>
''';
    }

    // NON rimuovere più CSS/script - lasciamo tutto come ZDF
    // Il viewer si occuperà dell'override con !important

    // Costruisci HTML con head "pulito" + solo il div teletext
    final optimizedHtml = '''
<!DOCTYPE html>
<html>
${head.outerHtml}
<body style="margin: 0; padding: 0; overflow: hidden; background: black;">
${contentDiv.outerHtml}
</body>
</html>
''';
    
    print('[NOSProvider] Optimized HTML preview (first 500 chars):');
    print(optimizedHtml.substring(0, optimizedHtml.length > 500 ? 500 : optimizedHtml.length));
    
    return optimizedHtml;
  }

  /// Converte tutti gli URL relativi in assoluti nell'HTML
  void _convertRelativeUrlsToAbsolute(dom.Document document, String baseUrl) {
    // Converti link CSS
    for (final link in document.querySelectorAll('link[rel="stylesheet"]')) {
      final href = link.attributes['href'];
      if (href != null && !href.startsWith('http')) {
        link.attributes['href'] = href.startsWith('/') 
            ? '$baseUrl$href' 
            : '$baseUrl/$href';
      }
    }

    // Converti script
    for (final script in document.querySelectorAll('script[src]')) {
      final src = script.attributes['src'];
      if (src != null && !src.startsWith('http')) {
        script.attributes['src'] = src.startsWith('/') 
            ? '$baseUrl$src' 
            : '$baseUrl/$src';
      }
    }

    // Converti immagini
    for (final img in document.querySelectorAll('img[src]')) {
      final src = img.attributes['src'];
      if (src != null && !src.startsWith('http') && !src.startsWith('data:')) {
        img.attributes['src'] = src.startsWith('/') 
            ? '$baseUrl$src' 
            : '$baseUrl/$src';
      }
    }

    // Converti font face URL nel CSS inline
    for (final style in document.querySelectorAll('style')) {
      if (style.text.contains('@font-face') || style.text.contains('url(')) {
        style.text = _convertCssUrls(style.text, baseUrl);
      }
    }
  }

  /// Converte gli URL relativi nei CSS
  String _convertCssUrls(String css, String baseUrl) {
    // Pattern per trovare url() nei CSS
    final urlPattern = RegExp(r'url\(["\x27]?([^"\x27)]+)["\x27]?\)');
    
    return css.replaceAllMapped(urlPattern, (match) {
      final url = match.group(1)!;
      
      // Se è già assoluto, lascialo così
      if (url.startsWith('http') || url.startsWith('data:') || url.startsWith('//')) {
        return match.group(0)!;
      }
      
      // Converti in assoluto
      final absoluteUrl = url.startsWith('/') 
          ? '$baseUrl$url' 
          : '$baseUrl/$url';
      
      return 'url("$absoluteUrl")';
    });
  }

  /// Estrae il numero totale di sottopagine caricando iterativamente le successive
  Future<int> _extractTotalSubPages(dom.Document document, int pageNumber, int currentSubPage) async {
    print('[NOSProvider] Detecting total subpages for page $pageNumber (current subpage: $currentSubPage)');
    
    // Cerca se c'è un link alla sottopagina successiva nell'HTML corrente
    final nextSubPage = _findNextSubPageLink(document, pageNumber, currentSubPage);
    
    if (nextSubPage == null) {
      // Non ci sono sottopagine successive
      print('[NOSProvider] No next subpage found, total: $currentSubPage');
      return currentSubPage;
    }
    
    print('[NOSProvider] Found link to subpage $nextSubPage, loading it to check for more...');
    
    // Carica la sottopagina successiva per verificare se ce ne sono altre
    try {
      final nextUrl = 'https://nos.nl/teletekst/$pageNumber/$nextSubPage';
      final response = await _dio.get(
        nextUrl,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final nextDocument = html_parser.parse(response.data as String);
        // Ricorsione: controlla se questa sottopagina ha a sua volta una successiva
        return await _extractTotalSubPages(nextDocument, pageNumber, nextSubPage);
      } else {
        print('[NOSProvider] Failed to load subpage $nextSubPage, assuming total: $currentSubPage');
        return currentSubPage;
      }
    } catch (e) {
      print('[NOSProvider] Error loading subpage $nextSubPage: $e');
      print('[NOSProvider] Assuming total subpages: $currentSubPage');
      return currentSubPage;
    }
  }
  
  /// Estrae i link cliccabili dal contenuto teletext
  List<ClickableArea> _extractClickableLinks(dom.Element contentDiv) {
    final clickableAreas = <ClickableArea>[];
    
    // Trova tutti i link nel div teletext
    final links = contentDiv.querySelectorAll('a[href]');
    
    print('[NOSProvider] Found ${links.length} links in content');
    
    for (final link in links) {
      final href = link.attributes['href'] ?? '';
      
      // Estrai il numero di pagina dall'href
      // Pattern: /teletekst/101, /teletekst/200, etc.
      final pageMatch = RegExp(r'/teletekst/(\d+)').firstMatch(href);
      
      if (pageMatch != null) {
        final targetPage = int.tryParse(pageMatch.group(1)!);
        
        if (targetPage != null) {
          // NOS usa rendering HTML, quindi non abbiamo coordinate pixel precise
          // Il click verrà gestito dal JavaScript nel ZDFTeletextViewer
          // Creiamo un ClickableArea simbolico per indicare che questo link esiste
          clickableAreas.add(
            ClickableArea(
              x: 0,
              y: 0,
              width: 0,
              height: 0,
              targetPage: targetPage,
            ),
          );
          
          print('[NOSProvider] Found clickable link to page $targetPage');
        }
      }
    }
    
    return clickableAreas;
  }
  
  /// Trova il link alla sottopagina successiva nell'HTML
  int? _findNextSubPageLink(dom.Document document, int pageNumber, int currentSubPage) {
    final allLinks = document.querySelectorAll('a, button');
    
    // Pattern: /teletekst/100/2, /teletekst/100/3, etc.
    // IMPORTANTE: usa interpolazione corretta per includere il pageNumber
    final pattern = RegExp('/teletekst/$pageNumber/(\\d+)');
    
    for (final link in allLinks) {
      final href = link.attributes['href'] ?? '';
      final ariaLabel = link.attributes['aria-label']?.toLowerCase() ?? '';
      final text = link.text.toLowerCase();
      
      // Cerca link che indicano "prossima sottopagina"
      if (text.contains('volgende subpagina') || 
          ariaLabel.contains('volgende subpagina') ||
          text.contains('next subpage') ||
          ariaLabel.contains('next subpage')) {
        
        print('[NOSProvider] Checking link: href="$href", text="$text"');
        
        final match = pattern.firstMatch(href);
        if (match != null) {
          final subPageNum = int.tryParse(match.group(1)!);
          if (subPageNum != null && subPageNum > currentSubPage) {
            print('[NOSProvider] ✅ Found next subpage link: $subPageNum (current: $currentSubPage)');
            return subPageNum;
          }
        }
      }
    }
    
    print('[NOSProvider] No next subpage link found');
    return null;
  }

  /// Estrae i link di navigazione dalla pagina
  Map<String, dynamic> _extractNavigationLinks(dom.Document document, int currentPage) {
    final result = <String, dynamic>{};

    // Cerca link "Vorige pagina" (previous) e "Volgende pagina" (next)
    final links = document.querySelectorAll('button, a');

    for (final link in links) {
      final href = link.attributes['href'] ?? '';
      final text = link.text.trim().toLowerCase();
      final ariaLabel = link.attributes['aria-label']?.toLowerCase() ?? '';

      // Estrai numero pagina dall'href (/teletekst/101)
      final pageMatch = RegExp(r'/teletekst/(\d+)').firstMatch(href);
      
      if (pageMatch != null) {
        final targetPage = int.tryParse(pageMatch.group(1)!);

        if (targetPage != null && targetPage != currentPage) {
          if (text.contains('vorige') || ariaLabel.contains('vorige') || 
              text.contains('previous') || ariaLabel.contains('previous')) {
            result['prev'] = targetPage;
            result['previousPage'] = targetPage;
          } else if (text.contains('volgende') || ariaLabel.contains('volgende') ||
                     text.contains('next') || ariaLabel.contains('next')) {
            result['next'] = targetPage;
            result['nextPage'] = targetPage;
          }
        }
      }
    }

    return result;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    print('[NOSProvider] Regional pages not supported');
    throw UnimplementedError('NOS Teletekst does not support regional pages');
  }

  /// Verifica velocemente se ci sono più sottopagine rispetto al conteggio cached
  /// Controlla solo le sottopagine successive a quelle già note
  Future<int> _quickCheckForMoreSubPages(int pageNumber, int knownCount) async {
    print('[NOSProvider] Quick check: looking for subpages beyond $knownCount...');
    
    // Controlla fino a 5 sottopagine oltre il conteggio conosciuto
    for (int i = knownCount + 1; i <= knownCount + 5; i++) {
      try {
        final url = 'https://nos.nl/teletekst/$pageNumber/$i';
        final response = await _dio.get(
          url,
          options: Options(
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            },
          ),
        );
        
        if (response.statusCode == 200) {
          // Verifica che la pagina contenga effettivamente contenuto teletext
          final htmlContent = response.data as String;
          final document = html_parser.parse(htmlContent);
          final contentDiv = document.querySelector('div.sc-5fbcdf78-1.bsxcGC');
          
          if (contentDiv != null) {
            print('[NOSProvider] ✅ Found subpage $i');
            // Continua a cercare
            continue;
          } else {
            // Non è una sottopagina valida
            print('[NOSProvider] Subpage $i has no content, stopping at ${i - 1}');
            return i - 1;
          }
        } else {
          // La sottopagina non esiste
          print('[NOSProvider] Subpage $i does not exist (status ${response.statusCode}), stopping at ${i - 1}');
          return i - 1;
        }
      } catch (e) {
        // Errore nel caricamento, assumiamo che non ci siano più sottopagine
        print('[NOSProvider] Error checking subpage $i: $e');
        return i - 1;
      }
    }
    
    // Se arriviamo qui, ci sono almeno 5 sottopagine in più
    print('[NOSProvider] Found at least ${knownCount + 5} subpages');
    return knownCount + 5;
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

