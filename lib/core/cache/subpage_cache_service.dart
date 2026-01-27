/// Servizio cache per memorizzare il numero di sottopagine per ogni pagina
/// TTL: 5 minuti (le sottopagine cambiano raramente)
class SubpageCacheService {
  static final Map<String, _CachedSubpageInfo> _cache = {};
  static const _ttlMinutes = 5;

  /// Genera chiave cache
  static String _getCacheKey(String providerId, int pageNumber) {
    return '${providerId}_$pageNumber';
  }

  /// Salva il numero di sottopagine in cache
  static void cacheSubpageCount({
    required String providerId,
    required int pageNumber,
    required int maxSubPages,
  }) {
    final key = _getCacheKey(providerId, pageNumber);
    _cache[key] = _CachedSubpageInfo(
      maxSubPages: maxSubPages,
      timestamp: DateTime.now(),
    );
    print('[SubpageCache] ✅ Cached: page $pageNumber has $maxSubPages subpages (TTL: $_ttlMinutes min)');
  }

  /// Recupera il numero di sottopagine dalla cache (se valida)
  static int? getCachedSubpageCount({
    required String providerId,
    required int pageNumber,
  }) {
    final key = _getCacheKey(providerId, pageNumber);
    final cached = _cache[key];

    if (cached == null) {
      return null;
    }

    // Verifica TTL (5 minuti)
    final age = DateTime.now().difference(cached.timestamp);
    if (age.inMinutes >= _ttlMinutes) {
      _cache.remove(key);
      print('[SubpageCache] Cache expired for page $pageNumber (age: ${age.inMinutes} min)');
      return null;
    }

    print('[SubpageCache] ✅ Cache hit: page $pageNumber has ${cached.maxSubPages} subpages (age: ${age.inSeconds}s)');
    return cached.maxSubPages;
  }

  /// Pulisce tutta la cache
  static void clearAll() {
    final count = _cache.length;
    _cache.clear();
    print('[SubpageCache] Cleared all cache ($count entries)');
  }

  /// Pulisce le entry scadute
  static void cleanExpired() {
    final now = DateTime.now();
    final toRemove = <String>[];

    _cache.forEach((key, value) {
      if (now.difference(value.timestamp).inMinutes >= _ttlMinutes) {
        toRemove.add(key);
      }
    });

    for (final key in toRemove) {
      _cache.remove(key);
    }

    if (toRemove.isNotEmpty) {
      print('[SubpageCache] Cleaned ${toRemove.length} expired entries');
    }
  }
}

/// Informazioni sulle sottopagine cachate
class _CachedSubpageInfo {
  final int maxSubPages;
  final DateTime timestamp;

  _CachedSubpageInfo({
    required this.maxSubPages,
    required this.timestamp,
  });
}
