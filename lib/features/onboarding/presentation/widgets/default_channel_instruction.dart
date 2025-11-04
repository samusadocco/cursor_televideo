import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/utils/country_detector.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/channel_notifier.dart';

/// Widget che mostra l'istruzione per la selezione del canale di default
class DefaultChannelInstruction extends StatelessWidget {
  const DefaultChannelInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icona principale con animazione (più piccola)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tv,
                size: isTablet ? 80 : 50,
                color: theme.primaryColor,
              ),
            ),
          ),
          
          SizedBox(height: isTablet ? 24 : 16),
          
          // Rappresentazione visiva dei canali disponibili
          _buildChannelsList(context, isTablet),
          
          SizedBox(height: isTablet ? 20 : 12),
          
          // Freccia verso il canale selezionato
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 10),
                  child: child,
                ),
              );
            },
            child: Icon(
              Icons.arrow_downward,
              size: isTablet ? 32 : 24,
              color: theme.primaryColor,
            ),
          ),
          
          SizedBox(height: isTablet ? 16 : 10),
          
          // Indicazione del canale selezionato (dinamico)
          _buildSelectedChannelBadge(context, isTablet),
          
          SizedBox(height: isTablet ? 20 : 12),
          
          // Info aggiuntiva (più compatta)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 10 : 8,
            ),
            margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(isTablet ? 10 : 6),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: theme.primaryColor,
                  size: isTablet ? 20 : 16,
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Flexible(
                  child: Text(
                    'Modificabile in Impostazioni',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectedChannelBadge(BuildContext context, bool isTablet) {
    // Ottieni il canale predefinito corrente
    final selectedChannel = ChannelNotifier().currentChannel;
    
    // Fallback a RAI se non c'è nessun canale selezionato
    final flag = selectedChannel?.flagEmoji ?? '🇮🇹';
    final name = selectedChannel?.shortName ?? selectedChannel?.name ?? 'RAI';
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: isTablet ? 24 : 20,
          ),
          SizedBox(width: isTablet ? 12 : 8),
          Text(
            '$flag $name',
            style: TextStyle(
              fontSize: isTablet ? 18 : 15,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChannelsList(BuildContext context, bool isTablet) {
    final theme = Theme.of(context);
    
    // Lista base di canali (senza France, con ORF)
    final baseChannels = [
      {'flag': '🇮🇹', 'name': 'RAI', 'countryCode': 'IT'},
      {'flag': '🇩🇪', 'name': 'ARD', 'countryCode': 'DE'},
      {'flag': '🇦🇹', 'name': 'ORF', 'countryCode': 'AT'},
      {'flag': '🇪🇸', 'name': 'TVE', 'countryCode': 'ES'},
    ];
    
    // Ottieni il paese dell'utente
    final userCountryCode = CountryDetector.instance.getUserCountryCode();
    
    // Aggiungi il canale del paese utente se non è già presente
    final List<Map<String, String>> channels = List.from(baseChannels);
    if (userCountryCode != null && 
        !baseChannels.any((ch) => ch['countryCode'] == userCountryCode)) {
      // Trova il primo canale del paese utente
      final userCountryChannels = TeletextChannels.allChannels
          .where((ch) => ch.countryCode == userCountryCode)
          .toList();
      
      if (userCountryChannels.isNotEmpty) {
        final firstChannel = userCountryChannels.first;
        channels.add({
          'flag': firstChannel.flagEmoji,
          'name': firstChannel.shortName ?? firstChannel.name,
          'countryCode': userCountryCode,
        });
      }
    }
    
    // Ottieni il canale predefinito corrente
    final selectedChannel = ChannelNotifier().currentChannel;
    final selectedCountryCode = selectedChannel?.countryCode;
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 30, 0),
            child: child,
          ),
        );
      },
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: isTablet ? 12 : 8,
        runSpacing: isTablet ? 12 : 8,
        children: channels.map((channel) {
          // Verifica se questo è il canale selezionato
          final isSelected = channel['countryCode'] == selectedCountryCode;
          
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 10 : 8,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? Colors.green.withOpacity(0.1) 
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(isTablet ? 10 : 6),
              border: Border.all(
                color: isSelected 
                    ? Colors.green 
                    : theme.dividerColor,
                width: isSelected ? 2.0 : 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: isTablet ? 18 : 15,
                  ),
                  SizedBox(width: isTablet ? 6 : 4),
                ],
                Text(
                  '${channel['flag']} ${channel['name']}',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.green : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


