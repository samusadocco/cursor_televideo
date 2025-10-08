import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';
import 'package:cursor_televideo/features/channel_selector/presentation/pages/channel_selector_page.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChannelSelectorButton extends StatefulWidget {
  const ChannelSelectorButton({super.key});

  @override
  State<ChannelSelectorButton> createState() => _ChannelSelectorButtonState();
}

class _ChannelSelectorButtonState extends State<ChannelSelectorButton> {
  TeletextChannel? _currentChannel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentChannel();
  }

  Future<void> _loadCurrentChannel() async {
    final prefs = await SharedPreferences.getInstance();
    final service = FavoriteChannelsService(prefs);
    final channel = await service.getSelectedChannel();
    
    if (mounted) {
      setState(() {
        _currentChannel = channel ?? TeletextChannels.getChannelById('rai_nazionale');
        _isLoading = false;
      });
    }
  }

  Future<void> _openChannelSelector() async {
    final selectedChannel = await Navigator.push<TeletextChannel>(
      context,
      MaterialPageRoute(
        builder: (context) => const ChannelSelectorPage(),
      ),
    );

    if (selectedChannel != null && mounted) {
      setState(() {
        _currentChannel = selectedChannel;
      });
      
      // Invia evento al bloc per cambiare canale
      context.read<TelevideoBloc>().add(
        TelevideoEvent.changeChannel(selectedChannel),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 120,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final channel = _currentChannel;
    if (channel == null) {
      return const SizedBox(width: 120);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openChannelSelector,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bandiera
              Text(
                channel.flagEmoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              // Nome canale (abbreviato se necessario)
              Flexible(
                child: Text(
                  _getDisplayName(channel),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              // Icona dropdown
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayName(TeletextChannel channel) {
    // Abbrevia nomi lunghi per adattarli alla UI
    if (channel.id == 'rai_nazionale') {
      return 'RAI Naz.';
    } else if (channel.id.startsWith('rai_')) {
      // Per le regioni RAI, mostra solo il nome della regione
      return channel.name.replaceFirst('RAI ', '');
    } else {
      // Per altri canali, usa il nome completo o abbreviato
      final name = channel.name;
      if (name.length > 15) {
        // Abbrevia se troppo lungo
        return '${name.substring(0, 12)}...';
      }
      return name;
    }
  }
}

