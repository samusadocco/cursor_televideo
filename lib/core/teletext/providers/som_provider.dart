import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';

/// Provider per canali tedeschi, austriaci e svizzeri sulla piattaforma SOM
/// (SAT.1, ProSieben, kabel eins, sixx, etc.)
///
/// Il sito usa ora un frontend JS con API REST:
/// - `/api/page` → metadati JSON (link, dimensioni)
/// - `/api/page/png` → immagine PNG
class SOMProvider implements TeletextProvider {
  final String channelSelector; // es. 's1de' per SAT.1 Deutschland

  SOMProvider({required this.channelSelector});

  @override
  String get providerId => 'som_$channelSelector';

  @override
  String get providerName => 'SOM Teletextviewer ($channelSelector)';

  @override
  String get countryCode {
    if (channelSelector.endsWith('de')) return 'DE';
    if (channelSelector.endsWith('at')) return 'AT';
    if (channelSelector.endsWith('ch')) return 'CH';
    return 'DE';
  }

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  static const String _apiBase = 'https://som-teletextviewer.sim-technik.de';

  final Map<int, _SubPageCacheEntry> _subPageCache = {};
  static const Duration _cacheTTL = Duration(minutes: 30);
  static const Duration _consistencyCheckInterval = Duration(minutes: 2);

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    try {
      print('[SOMProvider] Fetching page $pageNumber subpage $subPage for $channelSelector');

      final requestedPagnr = _formatPagnr(pageNumber, subPage);
      final meta = await _fetchPageMeta(requestedPagnr);
      final actualPagnr = meta['pagnr'] as String? ?? requestedPagnr;
      final actualSubPage = _parseSubPageFromPagnr(actualPagnr);

      final imageUrl = _buildImageUrl(actualPagnr);
      print('[SOMProvider] Image URL: $imageUrl');

      final width = (meta['width'] as num?)?.toInt() ?? 600;
      final height = (meta['height'] as num?)?.toInt() ?? 432;
      print('[SOMProvider] Dimensions: ${width}x$height');

      final clickableAreas = _extractClickableAreas(meta);
      print('[SOMProvider] Found ${clickableAreas.length} clickable areas');

      int totalSubPages;
      if (_subPageCache.containsKey(pageNumber)) {
        final entry = _subPageCache[pageNumber]!;
        if (entry.isExpired(_cacheTTL)) {
          totalSubPages = await _reloadSubPageCount(pageNumber, actualSubPage);
        } else if (entry.needsConsistencyCheck(_consistencyCheckInterval)) {
          final cachedSubPageExists = await _checkSubPageExists(pageNumber, entry.count);
          if (!cachedSubPageExists) {
            _subPageCache.remove(pageNumber);
            totalSubPages = await _reloadSubPageCount(pageNumber, actualSubPage);
          } else {
            final hasMore = await _checkSubPageExists(pageNumber, entry.count + 1);
            if (hasMore) {
              totalSubPages = await _countTotalSubPages(pageNumber, entry.count);
              _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
            } else {
              totalSubPages = entry.count;
              _subPageCache[pageNumber] = entry.withVerification();
            }
          }
        } else {
          totalSubPages = entry.count;
        }
      } else {
        totalSubPages = await _reloadSubPageCount(pageNumber, actualSubPage);
      }

      print('[SOMProvider] Total subpages for page $pageNumber: $totalSubPages');

      return TelevideoPage(
        pageNumber: pageNumber,
        imageUrl: imageUrl,
        subPage: actualSubPage,
        maxSubPages: totalSubPages,
        totalSubPages: 1,
        clickableAreas: clickableAreas,
        providerId: providerId,
        metadata: {
          'width': width,
          'height': height,
        },
      );
    } catch (e) {
      print('[SOMProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Verifica disponibilità del canale (check leggero all'avvio).
  Future<bool> checkAvailability() async {
    try {
      await _fetchPageMeta('100_01');
      return true;
    } catch (e) {
      print('[SOMProvider] Availability check failed: $e');
      return false;
    }
  }

  String _formatPagnr(int pageNumber, int subPage) {
    return '${pageNumber}_${subPage.toString().padLeft(2, '0')}';
  }

  int _parseSubPageFromPagnr(String pagnr) {
    final parts = pagnr.split('_');
    if (parts.length != 2) return 1;
    return int.tryParse(parts[1]) ?? 1;
  }

  Future<Map<String, dynamic>> _fetchPageMeta(String pagnr) async {
    final uri = Uri.parse('$_apiBase/api/page').replace(
      queryParameters: {
        'ttx_select': channelSelector,
        'pagnr': pagnr,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  String _buildImageUrl(String pagnr) {
    return Uri.parse('$_apiBase/api/page/png').replace(
      queryParameters: {
        'ttx_select': channelSelector,
        'pagnr': pagnr,
      },
    ).toString();
  }

  List<ClickableArea> _extractClickableAreas(Map<String, dynamic> meta) {
    final areas = <ClickableArea>[];
    final links = meta['links'] as List<dynamic>? ?? [];
    final xd = (meta['xd'] as num?)?.toDouble() ?? 15.0;
    final yd = (meta['yd'] as num?)?.toDouble() ?? 18.0;

    for (final link in links) {
      if (link is! Map<String, dynamic>) continue;
      if (link['kind'] != 'page') continue;

      final targetPage = int.tryParse(link['target']?.toString() ?? '');
      if (targetPage == null) continue;

      final x1 = ((link['x1'] as num?) ?? 0) * xd;
      final y1 = ((link['y1'] as num?) ?? 0) * yd;
      final x2 = ((link['x2'] as num?) ?? 0) * xd;
      final y2 = ((link['y2'] as num?) ?? 0) * yd;

      areas.add(ClickableArea(
        targetPage: targetPage,
        x: x1.round(),
        y: y1.round(),
        width: (x2 - x1).round(),
        height: (y2 - y1).round(),
      ));
    }

    return areas;
  }

  Future<bool> _checkSubPageExists(int pageNumber, int subPage) async {
    try {
      final requested = _formatPagnr(pageNumber, subPage);
      final meta = await _fetchPageMeta(requested);
      return meta['pagnr'] == requested;
    } catch (e) {
      print('[SOMProvider] Error checking subpage $pageNumber/$subPage: $e');
      return false;
    }
  }

  Future<int> _countTotalSubPages(int pageNumber, int startFrom) async {
    var count = startFrom;

    for (var i = startFrom + 1; i <= 99; i++) {
      final exists = await _checkSubPageExists(pageNumber, i);
      if (!exists) break;
      count = i;
    }

    return count;
  }

  Future<int> _reloadSubPageCount(int pageNumber, int currentSubPage) async {
    print('[SOMProvider] Counting total subpages for page $pageNumber starting from $currentSubPage');

    final totalSubPages = await _countTotalSubPages(pageNumber, currentSubPage);
    _subPageCache[pageNumber] = _SubPageCacheEntry(totalSubPages, DateTime.now());
    print('[SOMProvider] ✅ Cached subpage count for page $pageNumber: $totalSubPages');

    return totalSubPages;
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(String regionCode, int pageNumber, {int subPage = 1}) {
    throw UnsupportedError('SOM provider does not support regional pages');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      final meta = await _fetchPageMeta(_formatPagnr(pageNumber, 1));
      final pagnr = meta['pagnr'] as String? ?? '';
      return pagnr.startsWith('${pageNumber}_');
    } catch (e) {
      return false;
    }
  }
}

class _SubPageCacheEntry {
  final int count;
  final DateTime timestamp;
  final DateTime lastVerified;

  _SubPageCacheEntry(this.count, this.timestamp, {DateTime? lastVerified})
      : lastVerified = lastVerified ?? timestamp;

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(timestamp) > ttl;
  }

  bool needsConsistencyCheck(Duration checkInterval) {
    return DateTime.now().difference(lastVerified) > checkInterval;
  }

  _SubPageCacheEntry withVerification() {
    return _SubPageCacheEntry(count, timestamp, lastVerified: DateTime.now());
  }
}
