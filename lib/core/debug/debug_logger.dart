import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Servizio per raccogliere log di debug e permettere l'esportazione
class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  // Buffer circolare per i log (max 500 entry)
  final _logs = Queue<String>();
  static const _maxLogs = 500;
  
  // Flag per abilitare/disabilitare il logging
  bool _enabled = true;
  
  void enable() {
    _enabled = true;
    log('DebugLogger', 'Logging enabled');
  }
  
  void disable() {
    log('DebugLogger', 'Logging disabled');
    _enabled = false;
  }
  
  /// Aggiunge un log con timestamp
  void log(String tag, String message) {
    if (!_enabled) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final entry = '[$timestamp] [$tag] $message';
    
    _logs.add(entry);
    
    // Mantieni solo gli ultimi _maxLogs
    while (_logs.length > _maxLogs) {
      _logs.removeFirst();
    }
    
    // Stampa anche in console
    debugPrint(entry);
  }
  
  /// Ottiene tutti i log come stringa
  String getAllLogs() {
    return _logs.join('\n');
  }
  
  /// Pulisce tutti i log
  void clear() {
    _logs.clear();
    log('DebugLogger', 'Logs cleared');
  }
  
  /// Copia i log negli appunti
  Future<void> copyLogsToClipboard() async {
    final logs = getAllLogs();
    if (logs.isEmpty) {
      log('DebugLogger', 'No logs to copy');
      return;
    }
    
    await Clipboard.setData(ClipboardData(text: logs));
    log('DebugLogger', 'Logs copied to clipboard');
  }
  
  /// Mostra dialog con i log
  void showLogsDialog(BuildContext context) {
    final logs = getAllLogs();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Logs'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              logs.isEmpty ? 'Nessun log disponibile' : logs,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
          TextButton(
            onPressed: () async {
              await copyLogsToClipboard();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Log copiati negli appunti!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Copia'),
          ),
          TextButton(
            onPressed: () {
              clear();
              Navigator.pop(context);
            },
            child: const Text('Cancella'),
          ),
        ],
      ),
    );
  }
}

