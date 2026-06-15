import 'dart:async';
import 'package:dio/dio.dart';
import 'package:cursor_televideo/core/network/connectivity_utils.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/providers/provider_factory.dart';
import 'package:cursor_televideo/core/teletext/providers/telegazeta_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/ct_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/som_provider.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/shared/models/region.dart';

/// Risultato del check del canale all'avvio
enum ChannelCheckResult {
  ok,
  noConnectivity,
  noInternet,
  dnsError,
  channelError,
}

/// Servizio per verificare la connettività e la disponibilità del canale prima del primo caricamento.
/// Distingue tra problemi di rete (modalità aereo, assenza internet, DNS) e problemi del server televisivo.
class ChannelCheckService {
  static const Duration _timeout = Duration(seconds: 5);
  static const String _dnsTestUrl = 'https://www.google.com/generate_204';

  final TelevideoRepository _repository = TelevideoRepository();
  final Dio _dio = Dio();

  /// Esegue il check completo: connettività, DNS, canale (pagina 100).
  /// Restituisce il risultato appropriato per mostrare il messaggio corretto.
  Future<ChannelCheckResult> checkChannel(TeletextChannel? channel) async {
    // 1. Verifica connettività (modalità aereo, nessuna rete)
    final results = await getConnectivityResults();
    if (isNetworkUnavailable(results)) {
      return ChannelCheckResult.noConnectivity;
    }

    // 2. Verifica DNS / raggiungibilità internet (Google)
    try {
      final response = await _dio.get(_dnsTestUrl).timeout(_timeout);
      if (response.statusCode == null || response.statusCode! >= 500) {
        return ChannelCheckResult.noInternet;
      }
    } on TimeoutException {
      return ChannelCheckResult.dnsError;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ChannelCheckResult.dnsError;
      }
      // Connection error, timeout, etc. = problema di rete/DNS
      return ChannelCheckResult.noInternet;
    } catch (_) {
      return ChannelCheckResult.noInternet;
    }

    // 3. Verifica canale (pagina 100)
    try {
      if (channel == null || channel.id == 'rai_nazionale') {
        // RAI nazionale: verifica HTML + immagine pagina 100
        await _checkRaiPage100();
      } else if (channel.id.startsWith('rai_') &&
          channel.regions != null &&
          channel.regions!.isNotEmpty) {
        // RAI regionale: verifica pagina 300 (indice regionale)
        final region = Region.fromCode(channel.regions!.first);
        await _checkRaiRegionalPage100(region.code);
      } else {
        // Altri canali: verifica leggera quando possibile
        await _checkProviderChannel(channel);
      }
      return ChannelCheckResult.ok;
    } catch (_) {
      return ChannelCheckResult.channelError;
    }
  }

  Future<void> _checkRaiPage100() async {
    final available = await _repository.isPage100Available().timeout(_timeout);
    if (!available) throw Exception('Page 100 not available');
  }

  Future<void> _checkRaiRegionalPage100(String regionCode) async {
    await _repository.getRegionalPage(regionCode, pageNumber: 300, subPage: 1).timeout(_timeout);
  }

  Future<void> _checkProviderChannel(TeletextChannel channel) async {
    if (!TeletextProviderFactory.isProviderAvailable(channel)) {
      throw Exception('Provider not available');
    }

    // TVP/Polsat Telegazeta: status.json (evita fetch pagina 100 + OCR all'avvio)
    if (channel.id.endsWith('_telegazeta')) {
      final provider = TeletextProviderFactory.getProvider(channel);
      if (provider is TelegazetaProvider) {
        final available = await provider.checkAvailability().timeout(_timeout);
        if (!available) throw Exception('Telegazeta channel not available');
        return;
      }
    }

    // ČT Teletext: GET sull'API JSON (HEAD non supportato, restituisce 403)
    if (channel.id == 'ct_teletext') {
      final provider = TeletextProviderFactory.getProvider(channel);
      if (provider is CTProvider) {
        final available = await provider.checkAvailability().timeout(_timeout);
        if (!available) throw Exception('CT teletext channel not available');
        return;
      }
    }

    // SOM Teletextviewer: GET su /api/page (desk.php non contiene più l'immagine)
    if (channel.id.startsWith('som_')) {
      final provider = TeletextProviderFactory.getProvider(channel);
      if (provider is SOMProvider) {
        final available = await provider.checkAvailability().timeout(_timeout);
        if (!available) throw Exception('SOM teletext channel not available');
        return;
      }
    }

    final provider = TeletextProviderFactory.getProvider(channel);
    await provider.fetchNationalPage(100).timeout(_timeout);
  }
}
