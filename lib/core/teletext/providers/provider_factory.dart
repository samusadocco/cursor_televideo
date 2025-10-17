import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/rai_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/ard_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/zdf_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/swiss_provider.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';

/// Factory per creare il provider appropriato in base al canale
class TeletextProviderFactory {
  static final Map<String, TeletextProvider> _providerCache = {};

  /// Ottiene il provider appropriato per il canale specificato
  /// 
  /// Usa una cache per evitare di creare nuove istanze ad ogni chiamata
  static TeletextProvider getProvider(TeletextChannel channel) {
    // Controlla se abbiamo già un'istanza in cache
    if (_providerCache.containsKey(channel.id)) {
      return _providerCache[channel.id]!;
    }

    // Crea il provider appropriato in base al paese/broadcaster
    TeletextProvider provider;
    
    if (channel.countryCode == 'IT' && channel.broadcasterName == 'RAI') {
      // RAI Televideo (Italia)
      provider = RAIProvider();
    } else if (channel.id == 'ard_text') {
      // ARD Text (Germania)
      provider = ARDProvider();
    } else if (channel.id == 'zdf_text' || 
               channel.id == 'zdfinfo_text' || 
               channel.id == 'zdfneo_text' || 
               channel.id == '3sat_text') {
      // ZDF/ZDFinfo/ZDFneo/3sat Text (Germania)
      provider = ZDFProvider(channelId: channel.id);
    } else if (channel.countryCode == 'CH') {
      // Swiss Teletext (Svizzera) - RSI, RTS, SRF
      provider = SwissProvider(channelId: channel.id);
    } else {
      // Altri canali non ancora implementati
      throw UnimplementedError(
        'Provider for channel "${channel.name}" (${channel.id}) not yet implemented.\n'
        'Currently supported: RAI Televideo (IT), ARD Text (DE), ZDF/ZDFinfo/ZDFneo/3sat (DE), Swiss Teletext (CH)',
      );
    }

    // Salva in cache
    _providerCache[channel.id] = provider;
    return provider;
  }

  /// Pulisce la cache dei provider
  static void clearCache() {
    _providerCache.clear();
  }

  /// Verifica se un provider è disponibile per il canale
  static bool isProviderAvailable(TeletextChannel channel) {
    try {
      getProvider(channel);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Ottiene la lista dei provider disponibili
  static List<String> getAvailableProviders() {
    return ['RAI', 'ARD', 'ZDF', 'Swiss'];
  }
}


