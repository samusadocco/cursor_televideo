import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatelessWidget {
  final LanguageService languageService;
  final Locale currentLocale;

  const LanguageSelector({
    super.key,
    required this.languageService,
    required this.currentLocale,
  });

  /// Mappa delle bandiere emoji per ogni lingua
  String _getFlag(String languageCode) {
    switch (languageCode) {
      case 'it': return '🇮🇹'; // Italia
      case 'en': return '🇬🇧'; // Regno Unito
      case 'de': return '🇩🇪'; // Germania
      case 'fr': return '🇫🇷'; // Francia
      case 'es': return '🇪🇸'; // Spagna
      case 'pt': return '🇵🇹'; // Portogallo
      case 'nl': return '🇳🇱'; // Paesi Bassi
      case 'da': return '🇩🇰'; // Danimarca
      case 'sv': return '🇸🇪'; // Svezia
      case 'fi': return '🇫🇮'; // Finlandia
      case 'cs': return '🇨🇿'; // Repubblica Ceca
      case 'hr': return '🇭🇷'; // Croazia
      case 'sl': return '🇸🇮'; // Slovenia
      case 'is': return '🇮🇸'; // Islanda
      case 'hu': return '🇭🇺'; // Ungheria
      case 'bs': return '🇧🇦'; // Bosnia ed Erzegovina
      default: return '🌍'; // Globo generico
    }
  }

  /// Nomi delle lingue nella loro lingua nativa
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
      default: return languageCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Locale('it'), // Italiano
        Locale('en'), // Inglese
        Locale('de'), // Tedesco
        Locale('fr'), // Francese
        Locale('es'), // Spagnolo
        Locale('pt'), // Portoghese
        Locale('nl'), // Olandese
        Locale('da'), // Danese
        Locale('sv'), // Svedese
        Locale('fi'), // Finlandese
        Locale('cs'), // Ceco
        Locale('hr'), // Croato
        Locale('sl'), // Sloveno
        Locale('is'), // Islandese
        Locale('hu'), // Ungherese
        Locale('bs'), // Bosniaco
      ].map((locale) {
        return RadioListTile<String>(
          title: Row(
            children: [
              // Bandiera emoji
              Text(
                _getFlag(locale.languageCode),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              // Nome della lingua
              Text(_getLanguageName(locale.languageCode)),
            ],
          ),
          value: locale.languageCode,
          groupValue: currentLocale.languageCode,
          onChanged: (value) async {
            if (value != null) {
              print('[LanguageSelector] Cambio lingua a: $value');
              
              // Salva la nuova lingua
              await languageService.setLocale(Locale(value));
              
              // IMPORTANTE: Pulisci lo stato salvato prima del riavvio
              // per evitare errori nel caricamento delle pagine
              // MA mantieni il canale corrente selezionato
              print('[LanguageSelector] Pulizia stato salvato prima del riavvio...');
              
              // Salva il canale corrente prima di pulire lo stato
              final prefs = await SharedPreferences.getInstance();
              final channelService = FavoriteChannelsService(prefs);
              final currentChannelId = await channelService.getSelectedChannelId();
              print('[LanguageSelector] Canale corrente prima della pulizia: $currentChannelId');
              
              // Pulisci lo stato della pagina ma mantieni il canale
              await AppSettings.clearLastState();
              
              // Ripristina il canale corrente se non è vuoto
              if (currentChannelId.isNotEmpty) {
                await channelService.setSelectedChannelId(currentChannelId);
                print('[LanguageSelector] Canale corrente ripristinato: $currentChannelId');
              } else {
                print('[LanguageSelector] Nessun canale corrente da ripristinare, verrà usato il default');
              }
              
              if (context.mounted) {
                Navigator.of(context).pop();
                print('[LanguageSelector] Lingua cambiata, l\'app si aggiornerà automaticamente');
                // Non serve più Phoenix.rebirth(), l'app si aggiornerà automaticamente tramite lo stream
              }
            }
          },
        );
      }).toList(),
    );
  }
}
