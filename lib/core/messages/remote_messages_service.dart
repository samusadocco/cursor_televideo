import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/messages/remote_message.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';
import 'package:cursor_televideo/core/utils/store_country_detector.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';

/// Servizio per messaggi temporanei remoti (lingua, paese, versione)
class RemoteMessagesService {
  static const String _defaultUrl =
      'https://www.codebysam.it/teleretro/messages.json';
  static const Duration _cacheDuration = Duration(minutes: 30);

  final Dio _dio = Dio();
  List<RemoteMessage>? _cachedMessages;
  DateTime? _cacheTime;
  String _configUrl = _defaultUrl;

  /// Configura l'URL (JSON statico o endpoint PHP)
  void setMessagesUrl(String url) {
    _configUrl = url;
    _cachedMessages = null;
  }

  /// Carica e filtra i messaggi applicabili
  Future<List<RemoteMessage>> getApplicableMessages() async {
    if (_cachedMessages != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _filterMessages(_cachedMessages!);
    }

    try {
      String url = _configUrl;
      if (url.contains('.php') || url.contains('?')) {
        final packageInfo = await PackageInfo.fromPlatform();
        String lang;
        try {
          lang = (await LanguageService.instance.getSelectedLocale()).languageCode;
        } catch (_) {
          lang = PlatformDispatcher.instance.locale.languageCode;
        }
        final country = await StoreCountryDetector.instance.getStoreCountryCode();
        final prefs = await SharedPreferences.getInstance();
        final channelService = FavoriteChannelsService(prefs);
        final channelId = await channelService.getSelectedChannelId();
        final sep = url.contains('?') ? '&' : '?';
        url = '$url${sep}lang=$lang&country=$country&version=${packageInfo.version}&channel=$channelId';
      }
      final response = await _dio.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode != 200) return [];

      final data = response.data;
      List<dynamic> rawList;

      if (data is Map && data.containsKey('messages')) {
        rawList = data['messages'] as List;
      } else if (data is List) {
        rawList = data;
      } else {
        return [];
      }

      _cachedMessages = rawList
          .map((e) => RemoteMessage.fromJson(e as Map<String, dynamic>))
          .toList();
      _cacheTime = DateTime.now();

      return _filterMessages(_cachedMessages!);
    } catch (e) {
      return [];
    }
  }

  Future<List<RemoteMessage>> _filterMessages(List<RemoteMessage> messages) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;
    String lang;
    try {
      lang = (await LanguageService.instance.getSelectedLocale()).languageCode;
    } catch (_) {
      lang = PlatformDispatcher.instance.locale.languageCode;
    }
    final country = await StoreCountryDetector.instance.getStoreCountryCode();
    final prefs = await SharedPreferences.getInstance();
    final channelService = FavoriteChannelsService(prefs);
    final channelId = await channelService.getSelectedChannelId();

    return messages.where((m) => _matches(m, appVersion, lang, country, channelId)).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  bool _matches(RemoteMessage m, String appVersion, String lang, String country, String channelId) {
    if (m.content.isEmpty && m.fallbackContent == null) return false;
    if (m.getText(lang).isEmpty && (m.fallbackContent?.isEmpty ?? true)) {
      return false;
    }

    if (m.languages != null && m.languages!.isNotEmpty) {
      if (!m.languages!.contains(lang.toLowerCase()) &&
          !m.languages!.contains(lang.split('_').first)) {
        return false;
      }
    }

    if (m.countries != null && m.countries!.isNotEmpty) {
      if (!m.countries!.contains(country.toUpperCase())) {
        return false;
      }
    }

    if (m.channels != null && m.channels!.isNotEmpty) {
      if (!m.channels!.contains(channelId)) {
        return false;
      }
    }

    if (m.maxVersion != null) {
      if (_compareVersions(appVersion, m.maxVersion!) >= 0) return false;
    }
    if (m.minVersion != null) {
      if (_compareVersions(appVersion, m.minVersion!) < 0) return false;
    }

    return true;
  }

  int _compareVersions(String v1, String v2) {
    v1 = v1.contains('+') ? v1.split('+').first : v1;
    v2 = v2.contains('+') ? v2.split('+').first : v2;
    final p1 = v1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final p2 = v2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    for (int i = 0; i < 3; i++) {
      final a = i < p1.length ? p1[i] : 0;
      final b = i < p2.length ? p2[i] : 0;
      if (a > b) return 1;
      if (a < b) return -1;
    }
    return 0;
  }

  /// Invalida la cache (es. dopo cambio lingua/paese)
  void invalidateCache() {
    _cachedMessages = null;
    _cacheTime = null;
  }
}
