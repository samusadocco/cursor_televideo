/// Modello per messaggi remoti (temporanei) da server
class RemoteMessage {
  final String id;
  final Map<String, String> content; // lang -> text
  final String? fallbackContent;
  final List<String>? countries; // null = tutti, altrimenti lista codici (IT, DE, ...)
  final List<String>? languages; // null = tutte, altrimenti lista (it, en, ...)
  final List<String>? channels; // null o [] = tutti i canali, altrimenti lista channel id (rai_nazionale, ard_text, ...)
  final String? maxVersion; // messaggio visibile solo se app version < this
  final String? minVersion; // messaggio visibile solo se app version >= this
  final int priority; // maggiore = prima
  final String type; // snackbar, banner, dialog
  final String? actionUrl;
  final String? actionLabel;
  /// Messaggio di aggiornamento app: evidenziato con stile e icona, tipicamente rimando a App Store
  final bool isUpdateNotification;

  const RemoteMessage({
    required this.id,
    required this.content,
    this.fallbackContent,
    this.countries,
    this.languages,
    this.channels,
    this.maxVersion,
    this.minVersion,
    this.priority = 0,
    this.type = 'snackbar',
    this.actionUrl,
    this.actionLabel,
    this.isUpdateNotification = false,
  });

  factory RemoteMessage.fromJson(Map<String, dynamic> json) {
    return RemoteMessage(
      id: json['id'] as String? ?? '',
      content: (json['content'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      fallbackContent: json['fallbackContent'] as String?,
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e.toString().toUpperCase())
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e.toString().toLowerCase())
          .toList(),
      channels: (json['channels'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      maxVersion: json['maxVersion'] as String?,
      minVersion: json['minVersion'] as String?,
      priority: json['priority'] as int? ?? 0,
      type: json['type'] as String? ?? 'snackbar',
      actionUrl: json['actionUrl'] as String?,
      actionLabel: json['actionLabel'] as String?,
      isUpdateNotification: json['isUpdateNotification'] as bool? ?? false,
    );
  }

  /// Ottiene il testo nella lingua richiesta
  String getText(String languageCode) {
    final lang = languageCode.toLowerCase();
    return content[lang] ?? content[lang.split('_').first] ?? fallbackContent ?? '';
  }
}
