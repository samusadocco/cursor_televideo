import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/messages/remote_message.dart';
import 'package:cursor_televideo/core/messages/remote_messages_service.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';

/// Overlay che mostra messaggi remoti (snackbar o banner) all'avvio
class RemoteMessagesOverlay extends StatefulWidget {
  final Widget child;
  final RemoteMessagesService service;
  final String? messagesUrl;

  const RemoteMessagesOverlay({
    super.key,
    required this.child,
    required this.service,
    this.messagesUrl,
  });

  @override
  State<RemoteMessagesOverlay> createState() => _RemoteMessagesOverlayState();
}

class _RemoteMessagesOverlayState extends State<RemoteMessagesOverlay> {
  static const String _shownKeyPrefix = 'remote_msg_shown_';

  @override
  void initState() {
    super.initState();
    if (widget.messagesUrl != null) {
      widget.service.setMessagesUrl(widget.messagesUrl!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndShowMessages());
  }

  Future<void> _checkAndShowMessages() async {
    if (!mounted) return;

    final messages = await widget.service.getApplicableMessages();
    if (!mounted || messages.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    String lang;
    try {
      lang = await _getLanguageCode();
    } catch (_) {
      lang = 'en';
    }

    for (final msg in messages) {
      if (!mounted) return;
      final alreadyShown = prefs.getBool('$_shownKeyPrefix${msg.id}') ?? false;
      if (alreadyShown) continue;

      final text = msg.getText(lang);
      if (text.isEmpty) continue;

      if (msg.type == 'banner') {
        await _showBanner(msg, text, prefs);
      } else {
        _showSnackbar(msg, text, prefs);
      }
      // Mostra un messaggio per sessione, poi esci
      break;
    }
  }

  Future<String> _getLanguageCode() async {
    try {
      final locale = await LanguageService.instance.getSelectedLocale();
      return locale.languageCode;
    } catch (_) {
      return 'en';
    }
  }

  void _showSnackbar(RemoteMessage msg, String text, SharedPreferences prefs) {
    if (!mounted) return;
    prefs.setBool('$_shownKeyPrefix${msg.id}', true);
    final isUpdate = msg.isUpdateNotification;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (isUpdate) ...[
              Icon(Icons.system_update_alt, color: Colors.white, size: 24),
              SizedBox(width: 12),
            ],
            Expanded(child: Text(text)),
          ],
        ),
        backgroundColor: isUpdate ? Colors.amber.shade700 : null,
        action: msg.actionUrl != null && msg.actionLabel != null
            ? SnackBarAction(
                label: msg.actionLabel!,
                textColor: Colors.white,
                onPressed: () => _openUrl(msg.actionUrl!),
              )
            : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showBanner(RemoteMessage msg, String text, SharedPreferences prefs) async {
    if (!mounted) return;
    final isUpdate = msg.isUpdateNotification;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        icon: isUpdate ? Icon(Icons.system_update_alt, size: 48, color: Colors.amber.shade700) : null,
        title: Text(isUpdate
            ? (AppLocalizations.of(ctx)?.updateAvailable ?? 'Update available')
            : 'Teletext Europe'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(text),
              if (msg.actionUrl != null && msg.actionLabel != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _openUrl(msg.actionUrl!);
                  },
                  icon: Icon(isUpdate ? Icons.download : Icons.open_in_new),
                  label: Text(msg.actionLabel!),
                  style: isUpdate
                      ? FilledButton.styleFrom(backgroundColor: Colors.amber.shade700)
                      : null,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    // Traccia l'ID come già visualizzato quando il dialog viene chiuso (OK o tap fuori)
    prefs.setBool('$_shownKeyPrefix${msg.id}', true);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
