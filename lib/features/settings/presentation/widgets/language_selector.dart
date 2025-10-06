import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';

class LanguageSelector extends StatefulWidget {
  final LanguageService languageService;
  final VoidCallback onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.languageService,
    required this.onLanguageChanged,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late bool _useSystemLanguage;
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _useSystemLanguage = widget.languageService.isUsingSystemLanguage();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final locale = await widget.languageService.getSelectedLocale();
    setState(() {
      _selectedLanguageCode = locale.languageCode;
    });
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'it': return 'Italiano';
      case 'en': return 'English';
      case 'de': return 'Deutsch';
      case 'fr': return 'Français';
      case 'es': return 'Español';
      case 'pt': return 'Português';
      case 'nl': return 'Nederlands';
      case 'da': return 'Dansk';
      case 'sv': return 'Svenska';
      case 'fi': return 'Suomi';
      case 'cs': return 'Čeština';
      case 'hr': return 'Hrvatski';
      case 'sl': return 'Slovenščina';
      case 'is': return 'Íslenska';
      case 'hu': return 'Magyar';
      case 'bs': return 'Bosanski';
      default: return languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(l10n.language),
          subtitle: Text(_useSystemLanguage 
            ? l10n.systemLanguage 
            : _getLanguageName(_selectedLanguageCode)),
          onTap: _showLanguageDialog,
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);

        return AlertDialog(
          title: Text(l10n.language),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Opzione lingua di sistema
                RadioListTile<String>(
                  title: Text(l10n.systemLanguage),
                  value: 'system',
                  groupValue: _useSystemLanguage ? 'system' : _selectedLanguageCode,
                  onChanged: (value) async {
                    if (value == 'system') {
                      await widget.languageService.useSystemLanguage();
                      setState(() {
                        _useSystemLanguage = true;
                      });
                      widget.onLanguageChanged();
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
                ),
                // Lista delle lingue supportate
                ...supportedLocales.map((locale) {
                  return RadioListTile<String>(
                    title: Text(_getLanguageName(locale.languageCode)),
                    value: locale.languageCode,
                    groupValue: _useSystemLanguage ? 'system' : _selectedLanguageCode,
                    onChanged: (value) async {
                      if (value != null) {
                        await widget.languageService.setLocale(Locale(value));
                        setState(() {
                          _useSystemLanguage = false;
                          _selectedLanguageCode = value;
                        });
                        widget.onLanguageChanged();
                        if (mounted) Navigator.of(context).pop();
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

