import 'package:flutter/foundation.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';

/// Notifier per gestire i cambiamenti del canale selezionato
/// 
/// Questo permette a tutti i widget di ascoltare quando il canale cambia
/// senza dover fare polling o riavviare l'app
class ChannelNotifier extends ChangeNotifier {
  static final ChannelNotifier _instance = ChannelNotifier._internal();
  
  factory ChannelNotifier() {
    return _instance;
  }
  
  ChannelNotifier._internal();
  
  TeletextChannel? _currentChannel;
  
  TeletextChannel? get currentChannel => _currentChannel;
  
  /// Aggiorna il canale corrente e notifica tutti i listener
  void updateChannel(TeletextChannel? channel) {
    if (_currentChannel?.id != channel?.id) {
      _currentChannel = channel;
      print('[ChannelNotifier] Canale aggiornato: ${channel?.flagEmoji} ${channel?.shortName ?? channel?.name}');
      notifyListeners();
    }
  }
  
  /// Pulisce il canale corrente
  void clear() {
    _currentChannel = null;
    notifyListeners();
  }
}

