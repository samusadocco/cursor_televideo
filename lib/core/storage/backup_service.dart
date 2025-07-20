import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  static const String _backupVersion = '1.0.0';

  Future<String> createBackup() async {
    try {
      final favorites = FavoritesService().getFavorites();
      
      final backupData = {
        'version': _backupVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'favorites': favorites.map((f) => f.toJson()).toList(),
      };

      final backupJson = jsonEncode(backupData);
      
      // Salva il backup nella directory dei documenti
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final fileName = 'televideo_favorites_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(backupJson);
      
      return file.path;
    } catch (e) {
      throw Exception('Errore durante la creazione del backup: $e');
    }
  }

  Future<void> restoreBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File di backup non trovato');
      }

      final backupJson = await file.readAsString();
      final backupData = jsonDecode(backupJson) as Map<String, dynamic>;
      
      // Verifica la versione del backup
      final version = backupData['version'] as String?;
      if (version != _backupVersion) {
        throw Exception('Versione del backup non compatibile');
      }

      // Converte i dati in FavoritePage
      final favoritesJson = backupData['favorites'] as List<dynamic>;
      final favorites = favoritesJson
          .map((json) => FavoritePage.fromJson(json as Map<String, dynamic>))
          .toList();

      // Ripristina i preferiti
      await FavoritesService().restoreFromBackup(favorites);
      
    } catch (e) {
      throw Exception('Errore durante il ripristino del backup: $e');
    }
  }

  Future<List<BackupInfo>> getAvailableBackups() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory
          .listSync()
          .whereType<File>()
          .where((f) => f.path.contains('televideo_favorites_'))
          .toList();

      final backups = <BackupInfo>[];
      
      for (final file in files) {
        try {
          final content = await file.readAsString();
          final data = jsonDecode(content) as Map<String, dynamic>;
          
          backups.add(
            BackupInfo(
              filePath: file.path,
              timestamp: DateTime.parse(data['timestamp'] as String),
              version: data['version'] as String,
              favoritesCount: (data['favorites'] as List).length,
            ),
          );
        } catch (_) {
          // Ignora i file non validi
          continue;
        }
      }

      // Ordina per data, più recenti prima
      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return backups;
    } catch (e) {
      throw Exception('Errore durante il recupero dei backup disponibili: $e');
    }
  }

  Future<void> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Errore durante l\'eliminazione del backup: $e');
    }
  }
}

class BackupInfo {
  final String filePath;
  final DateTime timestamp;
  final String version;
  final int favoritesCount;

  BackupInfo({
    required this.filePath,
    required this.timestamp,
    required this.version,
    required this.favoritesCount,
  });
} 