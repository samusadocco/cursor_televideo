import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/rai_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/rtl_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/ard_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/br_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/wdr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/swr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/hr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/sr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/ndr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/kika_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/zattoo_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/zdf_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/swiss_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/orf_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/spanish_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/nos_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/omroepzeeland_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/polsat_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/svt_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/hrt_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/yle_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/ct_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/rtvslo_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/mtva_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/iceland_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/som_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/dr_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/bhrt_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/rtvfbih_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/intertext_provider.dart';
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
    } else if (channel.id == 'rtl_text') {
      // RTL Text (Germania) - Piattaforma Zattoo con OCR
      provider = ZattooProvider.rtl();
    } else if (channel.id == 'ard_text') {
      // ARD Text (Germania)
      provider = ARDProvider();
    } else if (channel.id == 'br_text') {
      // BR Text (Bayerischer Rundfunk - Germania/Baviera)
      provider = BRProvider();
    } else if (channel.id == 'wdr_text') {
      // WDR Text (Westdeutscher Rundfunk - Germania/NRW)
      provider = WDRProvider();
    } else if (channel.id == 'swr_bw') {
      // SWR BW Text (Südwestrundfunk - Baden-Württemberg)
      provider = SWRProvider('bw');
    } else if (channel.id == 'swr_rp') {
      // SWR RP Text (Südwestrundfunk - Rheinland-Pfalz)
      provider = SWRProvider('rp');
    } else if (channel.id == 'hr_text') {
      // HR Text (Hessischer Rundfunk - Germania/Hessen)
      provider = HRProvider();
    } else if (channel.id == 'sr_text') {
      // SR Text (Saarländischer Rundfunk - Saar Text)
      provider = SRProvider();
    } else if (channel.id == 'ndr_text') {
      // NDR Text (Norddeutscher Rundfunk)
      provider = NDRProvider();
    } else if (channel.id == 'kika_text') {
      // KiKA Text (Kinderkanal - ARD/ZDF)
      provider = KiKAProvider();
    } else if (channel.id == 'arte_text') {
      // ARTE Text (Germania/Francia) - Piattaforma Zattoo con OCR
      provider = ZattooProvider.arte();
    } else if (channel.id == 'rbb_text') {
      // RBB Text (Rundfunk Berlin-Brandenburg) - Piattaforma Zattoo con OCR
      provider = ZattooProvider.rbb();
    } else if (channel.id == 'mdr_text') {
      // MDR Text (Mitteldeutscher Rundfunk) - Piattaforma Zattoo con OCR
      provider = ZattooProvider.mdr();
    } else if (channel.id == 'ard_alpha_text') {
      // ARD Alpha Text - Piattaforma Zattoo con OCR
      provider = ZattooProvider.ardAlpha();
    } else if (channel.id == 'phoenix_text') {
      // Phoenix Text - Piattaforma Zattoo con OCR
      provider = ZattooProvider.phoenix();
    } else if (channel.id == 'ntv_text') {
      // n-tv Text - Piattaforma Zattoo con OCR
      provider = ZattooProvider.ntv();
    } else if (channel.id == 'vox_text') {
      // VOX Text - Piattaforma Zattoo con OCR
      provider = ZattooProvider.vox();
    } else if (channel.id == 'zdf_text' || 
               channel.id == 'zdfinfo_text' || 
               channel.id == 'zdfneo_text' || 
               channel.id == '3sat_text') {
      // ZDF/ZDFinfo/ZDFneo/3sat Text (Germania)
      provider = ZDFProvider(channelId: channel.id);
    } else if (channel.id.startsWith('som_')) {
      // SOM Teletextviewer (Germania, Austria, Svizzera) - SAT.1, ProSieben, etc.
      // IMPORTANTE: deve essere prima dei check generici per countryCode
      // Estrai il selettore del canale dall'ID (es. 'som_s1de' -> 's1de')
      final selector = channel.id.substring(4);
      provider = SOMProvider(channelSelector: selector);
    } else if (channel.countryCode == 'CH') {
      // Swiss Teletext (Svizzera) - RSI, RTS, SRF
      provider = SwissProvider(channelId: channel.id);
    } else if (channel.countryCode == 'AT' && channel.broadcasterName == 'ORF') {
      // ORF Teletext (Austria) - ORF1, ORF2, ORF III, ORF Sport+
      provider = ORFProvider(channelId: channel.id);
    } else if (channel.countryCode == 'ES' || channel.countryCode == 'PT') {
      // Iberian Teletext (Spagna/Portogallo) - TVE, Antena 3, La Sexta, RTP
      provider = SpanishProvider(channelId: channel.id);
    } else if (channel.id == 'nos_teletekst') {
      // NOS Teletekst (Olanda)
      provider = NOSProvider();
    } else if (channel.id == 'omroepzeeland_teletekst') {
      // Omroep Zeeland Teletekst (Olanda)
      provider = OmroepZeelandProvider();
    } else if (channel.id == 'polsat_telegazeta') {
      // Polsat Telegazeta (Polonia)
      provider = PolsatProvider();
    } else if (channel.id == 'svt_text') {
      // SVT Text (Svezia)
      provider = SVTProvider();
    } else if (channel.id == 'yle_teksti_tv') {
      // YLE Teksti-TV (Finlandia)
      provider = YLEProvider();
    } else if (channel.id == 'ct_teletext') {
      // ČT Teletext (Repubblica Ceca)
      provider = CTProvider();
    } else if (channel.id == 'hrt_teletekst') {
      // HRT Teletekst (Croazia)
      provider = HRTProvider();
    } else if (channel.id == 'rtvslo_teletext') {
      // RTV SLO Teletext (Slovenia)
      provider = RTVSLOProvider();
    } else if (channel.id == 'mtva_teletext') {
      // MTVA Teletext (Ungheria)
      provider = MTVAProvider();
    } else if (channel.id == 'ruv_textavarp') {
      // RÚV Textavarp (Islanda)
      provider = IcelandProvider();
    } else if (channel.id == 'dr1' || channel.id == 'dr2') {
      // DR Text TV (Danimarca)
      provider = DRProvider(channelId: channel.id);
    } else if (channel.id == 'bhrt') {
      // BHRT Teletext (Bosnia ed Erzegovina)
      provider = BHRTProvider();
    } else if (channel.id == 'rtvfbih') {
      // RTVFBiH Teletext - Federalna TV (Bosnia ed Erzegovina)
      provider = RTVFBiHProvider();
    } else if (channel.id == 'intertext') {
      // Intertext (Ucraina)
      provider = IntertextProvider();
    } else {
      // Altri canali non ancora implementati
      throw UnimplementedError(
        'Provider for channel "${channel.name}" (${channel.id}) not yet implemented.\n'
        'Currently supported: RAI Televideo (IT), ARD Text (DE), ZDF/ZDFinfo/ZDFneo/3sat (DE), Swiss Teletext (CH), ORF Teletext (AT), Iberian Teletext (ES/PT), NOS Teletekst (NL), SVT Text (SE), YLE Teksti-TV (FI), ČT Teletext (CZ), HRT Teletekst (HR), RTV SLO (SI), MTVA (HU), RÚV Textavarp (IS)',
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
    return ['RAI', 'ARD', 'ZDF', 'Swiss', 'ORF', 'Spanish', 'NOS', 'SVT', 'YLE', 'CT', 'HRT', 'RTVSLO', 'MTVA', 'Iceland'];
  }
}


