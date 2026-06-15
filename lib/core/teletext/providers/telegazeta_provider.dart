import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per i canali TVP Telegazeta (Polonia).
///
/// API immagini/HTML: https://telegazeta.pl/sync/ncexp/{networkCode}/{dir}/{page}_{subpage}.png|.htm
/// Metadati pagine: https://telegazeta.pl/sync/ncexp/{networkCode}/status.json
/// Il web viewer ufficiale (telegazeta.pl) mostra il PNG e usa status.json;
/// l'HTM con image map può mancare anche quando il PNG esiste.
class TelegazetaProvider implements TeletextProvider {
  static const String _syncHost = 'https://telegazeta.pl/sync/ncexp';

  final Dio _dio;
  final String channelId;
  final String _networkCode;

  final Map<int, bool> _contentValidityCache = {};
  final Map<int, int> _fallbackPageCache = {};

  Map<String, dynamic>? _statusCache;
  DateTime? _statusCacheTime;
  List<int>? _availablePagesCache;
  static const Duration _statusCacheTtl = Duration(minutes: 5);

  TelegazetaProvider({
    Dio? dio,
    required this.channelId,
  })  : _dio = dio ?? Dio(),
        _networkCode = _networkCodeForChannel(channelId);

  static String _networkCodeForChannel(String channelId) {
    switch (channelId) {
      case 'tvp1_telegazeta':
        return 'TG1';
      case 'tvp2_telegazeta':
        return 'TG2';
      case 'tvp3_telegazeta':
        return 'OTV';
      case 'tvp_kultura_telegazeta':
        return 'KUL';
      case 'tvp_historia_telegazeta':
        return 'HIS';
      case 'tvp_sport_telegazeta':
        return 'SPO';
      case 'tvp_polonia_telegazeta':
        return 'SAT';
      default:
        throw ArgumentError('Unknown Telegazeta channel: $channelId');
    }
  }

  String get _syncBase => '$_syncHost/$_networkCode';

  @override
  String get providerId => channelId;

  @override
  String get providerName {
    switch (channelId) {
      case 'tvp1_telegazeta':
        return 'TVP1 Telegazeta';
      case 'tvp2_telegazeta':
        return 'TVP2 Telegazeta';
      case 'tvp3_telegazeta':
        return 'TVP3 Telegazeta';
      case 'tvp_kultura_telegazeta':
        return 'TVP Kultura Telegazeta';
      case 'tvp_historia_telegazeta':
        return 'TVP Historia Telegazeta';
      case 'tvp_sport_telegazeta':
        return 'TVP Sport Telegazeta';
      case 'tvp_polonia_telegazeta':
        return 'TVP Polonia Telegazeta';
      default:
        return 'TVP Telegazeta';
    }
  }

  @override
  String get countryCode => 'PL';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    print('[TelegazetaProvider] Fetching $_networkCode page $pageNumber subpage $subPage');

    if (!await pageExists(pageNumber)) {
      throw Exception('Pagina $pageNumber non trovata');
    }

    final resolvedPage = pageNumber;
    String htmlContent = '';
    var htmlValid = false;

    try {
      htmlContent = await _fetchHtmlContent(resolvedPage, subPage);
      htmlValid = _isValidPageContent(htmlContent);
    } catch (e) {
      print('[TelegazetaProvider] HTM non disponibile per pagina $resolvedPage: $e');
    }

    if (!htmlValid) {
      final pngValid = await _hasValidPngAt(resolvedPage, subPage);
      if (!pngValid) {
        final fallback = await _findFallbackPage(pageNumber);
        if (fallback == null) {
          throw Exception('Pagina $pageNumber non trovata');
        }

        print(
          '[TelegazetaProvider] Pagina $pageNumber non disponibile su $_networkCode, '
          'uso fallback $fallback',
        );
        return fetchNationalPage(fallback, subPage: subPage);
      }

      print(
        '[TelegazetaProvider] HTM assente per pagina $resolvedPage, '
        'uso PNG (come il web viewer Telegazeta)',
      );
    }

    _contentValidityCache[resolvedPage] = true;

    final imageUrl = _buildResourceUrl(resolvedPage, subPage, 'png');

    try {
      final totalSubPages = await _getTotalSubPages(resolvedPage, htmlContent);
      final navigation = await _resolveNavigation(resolvedPage, htmlContent);

      return await _buildTelevideoPage(
        htmlContent,
        resolvedPage,
        subPage,
        imageUrl,
        totalSubPages,
        navigation,
      );
    } catch (e) {
      print('[TelegazetaProvider] Error fetching page: $e');
      rethrow;
    }
  }

  Future<String> _fetchHtmlContent(int pageNumber, int subPage) async {
    final htmlUrl = _buildResourceUrl(pageNumber, subPage, 'htm');
    final response = await _dio.get(htmlUrl);
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return response.data as String;
  }

  Future<bool> _hasValidPngAt(int pageNumber, int subPage) async {
    try {
      final response = await _dio.head(_buildResourceUrl(pageNumber, subPage, 'png'));
      if (response.statusCode != 200) {
        return false;
      }
      final contentType = response.headers.value('content-type') ?? '';
      return contentType.contains('image/png');
    } catch (_) {
      try {
        final response = await _dio.get<List<int>>(
          _buildResourceUrl(pageNumber, subPage, 'png'),
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.statusCode != 200 || response.data == null) {
          return false;
        }
        final bytes = response.data!;
        return bytes.length >= 8 &&
            bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47;
      } catch (_) {
        return false;
      }
    }
  }

  Future<bool> _hasValidContentAt(int pageNumber, {int subPage = 1}) async {
    if (_contentValidityCache.containsKey(pageNumber)) {
      return _contentValidityCache[pageNumber]!;
    }

    try {
      final htmlContent = await _fetchHtmlContent(pageNumber, subPage);
      if (_isValidPageContent(htmlContent)) {
        _contentValidityCache[pageNumber] = true;
        return true;
      }
    } catch (_) {
      // HTM assente: il web viewer usa comunque il PNG.
    }

    final pngValid = await _hasValidPngAt(pageNumber, subPage);
    _contentValidityCache[pageNumber] = pngValid;
    return pngValid;
  }

  /// Cerca la prima pagina con HTML valido (status.json può elencare pagine assenti).
  Future<int?> _findFallbackPage(int nearPage) async {
    if (_fallbackPageCache.containsKey(nearPage)) {
      return _fallbackPageCache[nearPage];
    }

    final available = await _getAvailablePages();
    if (available.isEmpty) {
      return null;
    }

    int? fallback;

    final blockStart = (nearPage ~/ 100) * 100;
    for (final page in available) {
      if (page >= blockStart && page < blockStart + 100) {
        if (await _hasValidContentAt(page)) {
          fallback = page;
          break;
        }
      }
    }

    fallback ??= await _firstValidPageFrom(available, minPage: nearPage);
    fallback ??= await _firstValidPageFrom(available, minPage: 100);
    fallback ??= await _firstValidPageFrom(available, minPage: 0);

    if (fallback != null) {
      _fallbackPageCache[nearPage] = fallback;
    }

    return fallback;
  }

  Future<int?> _firstValidPageFrom(List<int> pages, {required int minPage}) async {
    for (final page in pages) {
      if (page >= minPage && await _hasValidContentAt(page)) {
        return page;
      }
    }
    return null;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) {
    throw UnsupportedError('Telegazeta provider does not support regional pages');
  }

  /// Verifica leggera della disponibilità del canale (status.json, senza OCR).
  Future<bool> checkAvailability() async {
    try {
      final response = await _dio.head('$_syncBase/status.json');
      return response.statusCode == 200;
    } catch (e) {
      print('[TelegazetaProvider] Availability check failed: $e');
      return false;
    }
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final status = await _fetchStatusData();
      final pageKey = 'p$pageNumber';
      final pages = status['teletext']?['pages'] as Map<String, dynamic>?;
      if (pages == null || !pages.containsKey(pageKey)) {
        return false;
      }

      final subpageCount = int.tryParse(
        pages[pageKey]?['page']?['subpagecount']?.toString() ?? '',
      );
      return subpageCount != null && subpageCount > 0;
    } catch (e) {
      print('[TelegazetaProvider] Error checking page existence: $e');
      return false;
    }
  }

  String _buildResourceUrl(int pageNumber, int subPage, String extension) {
    final directory = (pageNumber ~/ 100) * 100;
    final subPageStr = subPage.toString().padLeft(4, '0');
    return '$_syncBase/$directory/${pageNumber}_$subPageStr.$extension';
  }

  Future<Map<String, dynamic>> _fetchStatusData() async {
    if (_statusCache != null && _statusCacheTime != null) {
      final age = DateTime.now().difference(_statusCacheTime!);
      if (age < _statusCacheTtl) {
        return _statusCache!;
      }
    }

    final response = await _dio.get('$_syncBase/status.json');
    if (response.statusCode != 200) {
      throw Exception('Failed to load status.json: ${response.statusCode}');
    }

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : Map<String, dynamic>.from(response.data as Map);

    _statusCache = data;
    _statusCacheTime = DateTime.now();
    _availablePagesCache = null;
    return data;
  }

  Future<List<int>> _getAvailablePages() async {
    if (_availablePagesCache != null) {
      return _availablePagesCache!;
    }

    final status = await _fetchStatusData();
    final pages = status['teletext']?['pages'] as Map<String, dynamic>?;
    if (pages == null) {
      return [];
    }

    final available = <int>[];
    for (final entry in pages.entries) {
      final pageNumber = int.parse(entry.key.substring(1));
      final subpageCount = int.tryParse(
        entry.value['page']?['subpagecount']?.toString() ?? '',
      );
      if (subpageCount != null && subpageCount > 0) {
        available.add(pageNumber);
      }
    }

    available.sort();
    _availablePagesCache = available;
    return available;
  }

  bool _isValidPageContent(String htmlContent) {
    if (htmlContent.contains('nie istnieje')) {
      return false;
    }
    if (htmlContent.contains('HTTP-EQUIV="REFRESH"')) {
      return false;
    }
    return htmlContent.contains('FABTTXImage') || htmlContent.contains('<map');
  }

  Future<Map<String, int?>> _resolveNavigation(int pageNumber, String htmlContent) async {
    final document = html_parser.parse(htmlContent);
    final htmlNav = _extractNavigationLinks(document);
    var prevPage = htmlNav['prev'];
    var nextPage = htmlNav['next'];

    final availablePages = await _getAvailablePages();
    if (availablePages.isEmpty) {
      return {'prev': prevPage, 'next': nextPage};
    }

    if (prevPage == null || !availablePages.contains(prevPage)) {
      prevPage = await _findAdjacentValidPage(pageNumber, availablePages, searchNext: false);
    } else if (!await _hasValidContentAt(prevPage)) {
      prevPage = await _findAdjacentValidPage(pageNumber, availablePages, searchNext: false);
    }

    if (nextPage == null || !availablePages.contains(nextPage)) {
      nextPage = await _findAdjacentValidPage(pageNumber, availablePages, searchNext: true);
    } else if (!await _hasValidContentAt(nextPage)) {
      nextPage = await _findAdjacentValidPage(pageNumber, availablePages, searchNext: true);
    }

    return {'prev': prevPage, 'next': nextPage};
  }

  Future<int?> _findAdjacentValidPage(
    int pageNumber,
    List<int> availablePages, {
    required bool searchNext,
  }) async {
    final candidates = searchNext
        ? availablePages.where((page) => page > pageNumber)
        : availablePages.where((page) => page < pageNumber).toList().reversed;

    for (final page in candidates) {
      if (await _hasValidContentAt(page)) {
        return page;
      }
    }
    return null;
  }

  Map<String, int?> _extractNavigationLinks(dom.Document document) {
    int? prevPage;
    int? nextPage;

    for (final row in document.querySelectorAll('tr')) {
      final cells = row.querySelectorAll('td');
      if (cells.length < 2) {
        continue;
      }

      final firstLink = cells[0].querySelector('a');
      final secondLink = cells[1].querySelector('a');
      final firstLabel = (firstLink?.text ?? cells[0].text).trim().toLowerCase();
      final secondLabel = (secondLink?.text ?? cells[1].text).trim().toLowerCase();

      if (firstLabel == 'pp' && firstLink != null) {
        prevPage = _extractTargetPage(firstLink.attributes['href'] ?? '');
      }
      if (secondLabel == 'np' && secondLink != null) {
        nextPage = _extractTargetPage(secondLink.attributes['href'] ?? '');
      }
    }

    return {'prev': prevPage, 'next': nextPage};
  }

  Future<int> _getTotalSubPages(int pageNumber, String htmlContent) async {
    try {
      final status = await _fetchStatusData();
      final pageKey = 'p$pageNumber';
      final pages = status['teletext']?['pages'] as Map<String, dynamic>?;
      final countStr = pages?[pageKey]?['page']?['subpagecount']?.toString();
      final count = int.tryParse(countStr ?? '');
      if (count != null && count > 0) {
        return count;
      }
    } catch (e) {
      print('[TelegazetaProvider] status.json subpage lookup failed: $e');
    }

    return _extractTotalSubPagesFromHtml(htmlContent, pageNumber);
  }

  Future<TelevideoPage> _buildTelevideoPage(
    String htmlContent,
    int pageNumber,
    int currentSubPage,
    String imageUrl,
    int totalSubPages,
    Map<String, int?> navigation,
  ) async {
    final document = html_parser.parse(htmlContent);
    final mapElement = document.querySelector('map');

    final mapAreas = mapElement != null
        ? _extractClickableAreas(mapElement)
        : <ClickableArea>[];

    final prevPage = navigation['prev'];
    final nextPage = navigation['next'];
    final clickableAreas = mapAreas;

    print(
      '[TelegazetaProvider] Parsed ${mapAreas.length} map areas, '
      '$totalSubPages subpages, prev=$prevPage, next=$nextPage '
      '(OCR lazy in background)',
    );

    return TelevideoPage(
      pageNumber: pageNumber,
      imageUrl: imageUrl,
      subPage: currentSubPage,
      maxSubPages: totalSubPages,
      totalSubPages: totalSubPages,
      clickableAreas: clickableAreas,
      metadata: {
        'navigationResolved': true,
        'lazyOcrPending': true,
        'lazyOcrEngine': 'polsat',
        'mapLinksCount': mapAreas.length,
        'ocrLinksCount': 0,
        'linksCount': mapAreas.length,
        if (prevPage != null) ...{
          'prev': prevPage,
          'prevPage': prevPage.toString(),
          'previousPage': prevPage,
        },
        if (nextPage != null) ...{
          'next': nextPage,
          'nextPage': nextPage.toString(),
        },
      },
      providerId: providerId,
    );
  }

  List<ClickableArea> _extractClickableAreas(dom.Element mapElement) {
    final areas = <ClickableArea>[];

    for (final areaElement in mapElement.querySelectorAll('area')) {
      final coords = areaElement.attributes['coords']
          ?.split(',')
          .map((value) => int.tryParse(value.trim()) ?? 0)
          .toList();
      final href = areaElement.attributes['href'];

      if (coords == null || coords.length != 4 || href == null) {
        continue;
      }

      final targetPage = _extractTargetPage(href);
      if (targetPage == null) {
        continue;
      }

      areas.add(ClickableArea(
        targetPage: targetPage,
        x: coords[0],
        y: coords[1],
        width: coords[2] - coords[0],
        height: coords[3] - coords[1],
      ));
    }

    return areas;
  }

  int? _extractTargetPage(String href) {
    final match = RegExp(r'(\d{3})_\d{4}\.htm').firstMatch(href);
    if (match == null) {
      return null;
    }
    return int.tryParse(match.group(1)!);
  }

  int _extractTotalSubPagesFromHtml(String htmlContent, int pageNumber) {
    final document = html_parser.parse(htmlContent);
    var maxSubPage = 1;

    for (final link in document.querySelectorAll('a[href]')) {
      final href = link.attributes['href'];
      if (href == null) {
        continue;
      }

      final pattern = RegExp('${pageNumber}_(\\d{4})\\.htm');
      final match = pattern.firstMatch(href);
      if (match == null) {
        continue;
      }

      final subPageNum = int.tryParse(match.group(1)!);
      if (subPageNum != null && subPageNum > maxSubPage) {
        maxSubPage = subPageNum;
      }
    }

    return maxSubPage;
  }
}
