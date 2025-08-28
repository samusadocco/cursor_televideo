import 'dart:convert';
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
      // Carica il file JSON
      final String jsonString = await rootBundle.loadString('lib/core/version_history.json');
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
        return allVersions.where((v) {
          return _compareVersions(v.version, lastVersion) > 0 &&
                 _compareVersions(v.version, currentVersion) <= 0;
        }).toList()
          ..sort((a, b) => _compareVersions(a.version, b.version));
      }

      return [];
    } catch (e) {
      print('Errore nel controllo delle nuove versioni: $e');
      return [];
    }
  }

  // Confronta due numeri di versione (assume il formato x.y.z)
  int _compareVersions(String v1, String v2) {
    final List<int> v1Parts = v1.split('.').map(int.parse).toList();
    final List<int> v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }
}