import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';
import 'package:cursor_televideo/core/teletext/channel_notifier.dart';
import 'package:cursor_televideo/core/settings/first_launch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/core/utils/country_detector.dart';

/// Dialog per la selezione del canale iniziale al primo avvio
class InitialChannelSelectionDialog extends StatefulWidget {
  const InitialChannelSelectionDialog({Key? key}) : super(key: key);

  @override
  State<InitialChannelSelectionDialog> createState() => _InitialChannelSelectionDialogState();
}

class _InitialChannelSelectionDialogState extends State<InitialChannelSelectionDialog> {
  TeletextChannel? _selectedChannel;
  bool _isLoading = true;
  List<TeletextChannel> _sortedChannels = [];
  String? _userCountryCode;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Rileva il paese dell'utente
    _userCountryCode = await CountryDetector.instance.getUserCountryCode();
    
    // Ordina i canali (paese utente per primo, poi alfabetico)
    _sortedChannels = TeletextChannels.getSortedChannels(
      userCountryCode: _userCountryCode,
      getLocalizedCountryName: _getLocalizedCountryName,
    );
    
    // Seleziona il primo canale del paese dell'utente come default
    if (_userCountryCode != null) {
      _selectedChannel = _sortedChannels.firstWhere(
        (ch) => ch.countryCode == _userCountryCode,
        orElse: () => _sortedChannels.first,
      );
    } else {
      _selectedChannel = _sortedChannels.first;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  String _getLocalizedCountryName(String countryCode) {
    final l10n = AppLocalizations.of(context)!;
    final dummyChannel = TeletextChannel(
      id: 'temp',
      name: 'Temp',
      broadcasterName: 'Temp',
      countryCode: countryCode,
      flagEmoji: '🏳️',
      baseUrl: '',
      type: TeletextChannelType.national, // Richiesto, ma non usato
    );
    return dummyChannel.getLocalizedCountryName(l10n);
  }

  Future<void> _confirmSelection() async {
    if (_selectedChannel == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final channelService = FavoriteChannelsService(prefs);
      final firstLaunchService = FirstLaunchService(prefs);

      // Controlla se esistono già canali preferiti salvati (verifica diretta in SharedPreferences)
      final favoritesJson = prefs.getString('favorite_channels');
      final hasExistingFavorites = favoritesJson != null && favoritesJson.isNotEmpty;
      
      // Salva il canale come predefinito
      await channelService.setSelectedChannelId(_selectedChannel!.id);
      
      // Aggiungi il canale ai preferiti SOLO se NON ci sono preferiti salvati
      // In questo caso è il primo avvio e dobbiamo popolare la lista
      if (!hasExistingFavorites) {
        await channelService.saveFavoriteChannels([_selectedChannel!.id]);
        print('[InitialChannelSelection] Primo avvio: inizializzo lista preferiti con canale: ${_selectedChannel!.id}');
      } else {
        // Durante il reset del canale predefinito, preserviamo SEMPRE la lista esistente
        // e aggiorniamo solo il canale selezionato (già fatto sopra con setSelectedChannelId)
        print('[InitialChannelSelection] Reset canale predefinito: lista preferiti preservata, aggiornato solo canale selezionato');
      }

      // Marca la selezione come completata e salva l'ID del canale iniziale
      await firstLaunchService.markInitialChannelSelected(channelId: _selectedChannel!.id);

      // Notifica il cambio canale a tutti i listener
      ChannelNotifier().updateChannel(_selectedChannel);
      print('[InitialChannelSelection] Notificato cambio canale: ${_selectedChannel!.flagEmoji} ${_selectedChannel!.shortName}');

      // Chiudi il dialog e ritorna il canale selezionato
      if (mounted) {
        Navigator.of(context).pop(_selectedChannel);
      }
    } catch (e) {
      print('[InitialChannelSelection] Error saving selection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel salvare la selezione: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async => false, // Impedisce la chiusura con il back button
      child: AlertDialog(
        title: Row(
          children: [
            Icon(Icons.tv, color: theme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.welcome,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectYourChannel,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 20),
              // Lista canali con loading
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildChannelsList(theme),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (_isLoading)
            const SizedBox.shrink()
          else
            ElevatedButton(
              onPressed: _selectedChannel != null ? _confirmSelection : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                l10n.ok,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  /// Costruisce la lista di canali raggruppati per paese
  Widget _buildChannelsList(ThemeData theme) {
    // Raggruppa per paese
    final channelsByCountry = <String, List<TeletextChannel>>{};
    for (final channel in _sortedChannels) {
      channelsByCountry.putIfAbsent(channel.countryCode, () => []).add(channel);
    }

    // Ordina i paesi mantenendo l'ordine già definito in _sortedChannels
    final sortedCountries = channelsByCountry.keys.toList()
      ..sort((a, b) {
        // Se uno dei due è il paese dell'utente, mettilo per primo
        if (_userCountryCode != null) {
          if (a == _userCountryCode) return -1;
          if (b == _userCountryCode) return 1;
        }
        
        // Altrimenti ordina per nome localizzato
        final nameA = _getLocalizedCountryName(a);
        final nameB = _getLocalizedCountryName(b);
        return nameA.compareTo(nameB);
      });

    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortedCountries.length,
      itemBuilder: (context, countryIndex) {
        final countryCode = sortedCountries[countryIndex];
        final countryChannels = channelsByCountry[countryCode]!;
        final firstChannel = countryChannels.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del paese
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[200],
              child: Text(
                '${firstChannel.flagEmoji}  ${_getLocalizedCountryName(countryCode)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Canali del paese
            ...countryChannels.map((channel) => _buildChannelTile(channel, theme)),
          ],
        );
      },
    );
  }

  /// Costruisce un tile per un singolo canale
  Widget _buildChannelTile(TeletextChannel channel, ThemeData theme) {
    final isSelected = _selectedChannel?.id == channel.id;

    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.1),
      leading: CircleAvatar(
        backgroundColor: isSelected 
            ? theme.primaryColor.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        child: Text(
          channel.flagEmoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        channel.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        channel.broadcasterName,
        style: TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodySmall?.color,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.primaryColor)
          : null,
      onTap: () {
        setState(() {
          _selectedChannel = channel;
        });
      },
    );
  }
}

