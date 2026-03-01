import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersionInfo {
  final String version;
  final List<String> changes;

  VersionInfo({required this.version, required this.changes});

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      version: json['version'] as String,
      changes: List<String>.from(json['changes'] as List),
    );
  }
}

class VersionManager {
  static const String _lastVersionKey = 'last_version';
  static const String _defaultLastVersion = '1.0.2';
  
  Future<List<VersionInfo>> getVersionHistory() async {
    try {
      // Ottiene la lingua corrente dal dispositivo
      final locale = PlatformDispatcher.instance.locale;
      final languageCode = locale.languageCode.toLowerCase();
      
      // Determina quale file caricare in base alla lingua
      String fileName = 'lib/core/version_history_$languageCode.json';
      
      // Prova a caricare il file per la lingua corrente
      String jsonString;
      try {
        jsonString = await rootBundle.loadString(fileName);
      } catch (e) {
        // Se il file per la lingua corrente non esiste, usa l'inglese come fallback
        print('File per lingua $languageCode non trovato, uso inglese come fallback');
        jsonString = await rootBundle.loadString('lib/core/version_history_en.json');
      }
      
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      // Converte il JSON in una lista di VersionInfo
      final List<dynamic> versions = jsonMap['versions'];
      return versions.map((v) => VersionInfo.fromJson(v)).toList();
    } catch (e) {
      print('Errore nel caricamento della cronologia versioni: $e');
      return [];
    }
  }

  Future<List<VersionInfo>> getNewVersions() async {
    try {
      // Ottiene la versione corrente
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      // Ottiene l'ultima versione eseguita
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String lastVersion = prefs.getString(_lastVersionKey) ?? _defaultLastVersion;

      // Se è la prima esecuzione o c'è un aggiornamento
      if (lastVersion != currentVersion) {
        // Salva la versione corrente
        await prefs.setString(_lastVersionKey, currentVersion);

        // Ottiene la cronologia delle versioni
        final List<VersionInfo> allVersions = await getVersionHistory();

        // Filtra le versioni più recenti dell'ultima versione eseguita
        final filtered = allVersions.where((v) {
          return _compareVersions(v.version, lastVersion) > 0 &&
                 _compareVersions(v.version, currentVersion) <= 0;
        }).toList();
        // Ordine decrescente: versione più recente per prima (2.1.0 in cima)
        filtered.sort((a, b) => _compareVersions(b.version, a.version));
        return filtered;
      }

      return [];
    } catch (e) {
      print('Errore nel controllo delle nuove versioni: $e');
      return [];
    }
  }

  /// Confronta due versioni (formato x.y.z, eventuale +build ignorato).
  /// Gestisce versioni con 2 parti (es. "2.1" → "2.1.0").
  int _compareVersions(String v1, String v2) {
    v1 = _normalizeVersion(v1);
    v2 = _normalizeVersion(v2);
    var v1Parts = v1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    var v2Parts = v2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    while (v1Parts.length < 3) v1Parts.add(0);
    while (v2Parts.length < 3) v2Parts.add(0);
    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }

  String _normalizeVersion(String v) {
    final plus = v.indexOf('+');
    return (plus >= 0) ? v.substring(0, plus).trim() : v.trim();
  }
}