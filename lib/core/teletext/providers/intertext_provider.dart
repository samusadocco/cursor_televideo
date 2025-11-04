import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Tipi di pagine Intertext
enum PageType {
  normal,    // TYPE 1: Pagina singola
  subpage,   // TYPE 2: Gruppo di pagine separate (false sottopagine)
  multi,     // TYPE 3: Sottopagine animate vere
}

/// Entry della mappatura pagine Intertext
class PageEntry {
  final String file;
  final PageType type;
  final int page;
  final int? sub;

  PageEntry({
    required this.file,
    required this.type,
    required this.page,
    this.sub,
  });

  factory PageEntry.fromJson(Map<String, dynamic> json) {
    PageType type;
    switch (json['type'] as int) {
      case 1:
        type = PageType.normal;
        break;
      case 2:
        type = PageType.subpage;
        break;
      case 3:
        type = PageType.multi;
        break;
      default:
        type = PageType.normal;
    }

    return PageEntry(
      file: json['file'] as String,
      type: type,
      page: json['page'] as int,
      sub: json['sub'] as int?,
    );
  }
}

/// Provider per il canale Teletext ucraino Intertext
class IntertextProvider implements TeletextProvider {
  final Dio _dio;
  
  // Cache per la mappatura completa delle pagine
  Map<int, List<PageEntry>>? _pageMapping;
  bool _isMappingLoaded = false;

  IntertextProvider({Dio? dio}) : _dio = dio ?? Dio() {
    // Configura headers per superare il blocco 403
    _dio.options.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36';
    _dio.options.headers['Referer'] = 'https://intertext.com.ua/look';
  }

  @override
  String get providerId => 'intertext';

  @override
  String get providerName => 'Intertext Teletext';

  @override
  String get countryCode => 'UA';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  String get _baseUrl => 'https://intertext.com.ua/modules/teletext';

  /// Carica la mappatura completa delle pagine dall'API
  Future<void> _loadPageMapping() async {
    if (_isMappingLoaded) return;

    try {
      print('[IntertextProvider] Loading page mapping...');
      final url = '$_baseUrl/page.php?page=get';
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data is String 
            ? jsonDecode(response.data as String) as List<dynamic>
            : response.data as List<dynamic>;

        // Organizza le entries per numero di pagina
        _pageMapping = {};
        for (final item in jsonData) {
          if (item is Map<String, dynamic> && item.isNotEmpty) {
            try {
              final entry = PageEntry.fromJson(item);
              if (!_pageMapping!.containsKey(entry.page)) {
                _pageMapping![entry.page] = [];
              }
              _pageMapping![entry.page]!.add(entry);
            } catch (e) {
              // Ignora entries malformate
              continue;
            }
          }
        }

        _isMappingLoaded = true;
        print('[IntertextProvider] Page mapping loaded: ${_pageMapping!.length} pages');
      }
    } catch (e) {
      print('[IntertextProvider] Error loading page mapping: $e');
      _pageMapping = {};
      _isMappingLoaded = true; // Marca come caricato anche in caso di errore
    }
  }

  /// Ottiene le entries per una pagina specifica
  List<PageEntry> _getPageEntries(int pageNumber) {
    return _pageMapping?[pageNumber] ?? [];
  }

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      // Carica la mappatura se non già fatto
      await _loadPageMapping();

      print('[IntertextProvider] Fetching page $pageNumber subpage $subPage');
      
      final entries = _getPageEntries(pageNumber);
      
      if (entries.isEmpty) {
        throw Exception('Page $pageNumber not found in mapping');
      }

      // Determina il tipo di pagina
      final firstEntry = entries.first;
      
      switch (firstEntry.type) {
        case PageType.normal:
          return await _fetchNormalPage(pageNumber, entries.first);
        
        case PageType.subpage:
          // Per TYPE 2, trova l'entry corrispondente alla "sottopagina" richiesta
          // Le entries hanno sub: 0, 1, 2, etc.
          final targetEntry = entries.firstWhere(
            (e) => (e.sub ?? 0) == (subPage - 1),
            orElse: () => entries.first,
          );
          return await _fetchSubPageTypePage(pageNumber, subPage, targetEntry, entries.length);
        
        case PageType.multi:
          // Per TYPE 3, usa il file con suffisso (es. "100_01")
          return await _fetchMultiPage(pageNumber, subPage, entries);
      }
    } catch (e) {
      print('[IntertextProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Carica una pagina TYPE 1 (normale)
  Future<TelevideoPage> _fetchNormalPage(int pageNumber, PageEntry entry) async {
    final url = '$_baseUrl/page.php?page=${entry.file}&subpage=0&json&sub';
    print('[IntertextProvider] Normal page URL: $url');

    final jsonResponse = await _dio.get(url);
    final jsonData = jsonResponse.data is String 
        ? jsonDecode(jsonResponse.data as String) as Map<String, dynamic>
        : jsonResponse.data as Map<String, dynamic>;

    final timestamp = jsonData['timestamp'];
    
    // URL dell'immagine
    String imageUrl;
    if (timestamp != null && timestamp != -1) {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0&$timestamp';
    } else {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0';
    }

    // Clickable areas
    List<ClickableArea> clickableAreas = [];
    try {
      final mapUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0&map';
      final mapResponse = await _dio.get(mapUrl);
      if (mapResponse.statusCode == 200 && mapResponse.data != null && mapResponse.data.toString().isNotEmpty) {
        clickableAreas = _extractClickableAreas(mapResponse.data.toString(), pageNumber);
      }
    } catch (e) {
      // Ignora errori nella mappa
    }

    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: 1,
      maxSubPages: 1,
      totalSubPages: 1,
      clickableAreas: clickableAreas,
      providerId: providerId,
    );
  }

  /// Carica una pagina TYPE 2 (false sottopagine - in realtà pagine separate)
  Future<TelevideoPage> _fetchSubPageTypePage(
    int pageNumber,
    int subPage,
    PageEntry entry,
    int totalPages,
  ) async {
    final apiSubPage = entry.sub ?? 0;
    final url = '$_baseUrl/page.php?page=${entry.file}&subpage=$apiSubPage&json&sub';
    print('[IntertextProvider] SubPage type URL: $url (page $pageNumber shown as subpage $subPage)');

    final jsonResponse = await _dio.get(url);
    final jsonData = jsonResponse.data is String 
        ? jsonDecode(jsonResponse.data as String) as Map<String, dynamic>
        : jsonResponse.data as Map<String, dynamic>;

    final timestamp = jsonData['timestamp'];
    
    // URL dell'immagine
    String imageUrl;
    if (timestamp != null && timestamp != -1) {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=$apiSubPage&$timestamp';
    } else {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=$apiSubPage';
    }

    // Clickable areas
    List<ClickableArea> clickableAreas = [];
    try {
      final mapUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=$apiSubPage&map';
      final mapResponse = await _dio.get(mapUrl);
      if (mapResponse.statusCode == 200 && mapResponse.data != null && mapResponse.data.toString().isNotEmpty) {
        clickableAreas = _extractClickableAreas(mapResponse.data.toString(), pageNumber);
      }
    } catch (e) {
      // Ignora errori nella mappa
    }

    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: subPage,
      maxSubPages: totalPages,
      totalSubPages: 1,
      clickableAreas: clickableAreas,
      providerId: providerId,
    );
  }

  /// Carica una pagina TYPE 3 (sottopagine animate vere)
  Future<TelevideoPage> _fetchMultiPage(
    int pageNumber,
    int subPage,
    List<PageEntry> entries,
  ) async {
    // Le entries per TYPE 3 hanno file come "100_01", "100_02", etc.
    // Ordina per file name per avere l'ordine corretto
    final sortedEntries = List<PageEntry>.from(entries)
      ..sort((a, b) => a.file.compareTo(b.file));

    // Prendi l'entry corrispondente al subPage richiesto
    final entryIndex = (subPage - 1).clamp(0, sortedEntries.length - 1);
    final entry = sortedEntries[entryIndex];

    final url = '$_baseUrl/page.php?page=${entry.file}&subpage=0&json&sub';
    print('[IntertextProvider] Multi page URL: $url');

    final jsonResponse = await _dio.get(url);
    final jsonData = jsonResponse.data is String 
        ? jsonDecode(jsonResponse.data as String) as Map<String, dynamic>
        : jsonResponse.data as Map<String, dynamic>;

    final timestamp = jsonData['timestamp'];
    
    // URL dell'immagine
    String imageUrl;
    if (timestamp != null && timestamp != -1) {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0&$timestamp';
    } else {
      imageUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0';
    }

    // Clickable areas
    List<ClickableArea> clickableAreas = [];
    try {
      final mapUrl = '$_baseUrl/page.php?page=${entry.file}&subpage=0&map';
      final mapResponse = await _dio.get(mapUrl);
      if (mapResponse.statusCode == 200 && mapResponse.data != null && mapResponse.data.toString().isNotEmpty) {
        clickableAreas = _extractClickableAreas(mapResponse.data.toString(), pageNumber);
      }
    } catch (e) {
      // Ignora errori nella mappa
    }

    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: subPage,
      maxSubPages: sortedEntries.length,
      totalSubPages: 1,
      clickableAreas: clickableAreas,
      providerId: providerId,
    );
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) {
    throw UnsupportedError('Intertext provider does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await _loadPageMapping();
      return _pageMapping?.containsKey(pageNumber) ?? false;
    } catch (e) {
      return false;
    }
  }

  List<ClickableArea> _extractClickableAreas(String mapHtml, int currentPage) {
    final areas = <ClickableArea>[];
    
    if (mapHtml.isEmpty) return areas;
    
    try {
      final document = html_parser.parse(mapHtml);
      final mapElement = document.querySelector('map');
      
      if (mapElement == null) return areas;
      
      for (final areaElement in mapElement.querySelectorAll('area')) {
        final coords = areaElement.attributes['coords']
            ?.split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .toList();
        
        final href = areaElement.attributes['href'];
        
        if (coords != null && coords.length == 4 && href != null) {
          int? targetPage;
          
          // Pattern per showPageByNumber
          final directMatch = RegExp(r'showPageByNumber\((\d+)\)').firstMatch(href);
          if (directMatch != null) {
            targetPage = int.tryParse(directMatch.group(1)!);
          } else {
            // Pattern per showPageByBottomLink
            final bottomLinkMatch = RegExp(r'showPageByBottomLink\((\d+)\)').firstMatch(href);
            if (bottomLinkMatch != null) {
              final linkNumber = int.tryParse(bottomLinkMatch.group(1)!);
              if (linkNumber != null) {
                final baseHundred = (currentPage ~/ 100) * 100;
                targetPage = baseHundred + linkNumber;
              }
            }
          }
          
          if (targetPage != null) {
            final x1 = coords[0];
            final y1 = coords[1];
            final x2 = coords[2];
            final y2 = coords[3];
            
            areas.add(ClickableArea(
              targetPage: targetPage,
              x: x1,
              y: y1,
              width: x2 - x1,
              height: y2 - y1,
            ));
          }
        }
      }
    } catch (e) {
      print('[IntertextProvider] Error parsing map HTML: $e');
    }
    
    return areas;
  }
}
