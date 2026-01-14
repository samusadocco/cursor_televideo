import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

part 'teletext_channels.freezed.dart';
part 'teletext_channels.g.dart';

/// Rappresenta un canale teletext
@freezed
class TeletextChannel with _$TeletextChannel {
  const TeletextChannel._();
  
  const factory TeletextChannel({
    required String id,
    required String name,
    String? shortName, // Nome abbreviato per visualizzazione compatta
    required String countryCode,
    @Deprecated('Use getLocalizedCountryName() instead') String? countryName, // Deprecated: ora usiamo countryCode + localizzazione
    required String flagEmoji,
    required String broadcasterName,
    required TeletextChannelType type,
    String? baseUrl,
    String? htmlBaseUrl,
    bool? supportsRegions,
    List<String>? regions,
    @Default(true) bool isActive,
  }) = _TeletextChannel;

  factory TeletextChannel.fromJson(Map<String, dynamic> json) =>
      _$TeletextChannelFromJson(json);
  
  /// Ottiene il nome del paese localizzato in base al countryCode
  String getLocalizedCountryName(AppLocalizations l10n) {
    switch (countryCode) {
      case 'IT':
        return l10n.countryIT;
      case 'DE':
        return l10n.countryDE;
      case 'AT':
        return l10n.countryAT;
      case 'CH':
        return l10n.countryCH;
      case 'ES':
        return l10n.countryES;
      case 'PT':
        return l10n.countryPT;
      case 'NL':
        return l10n.countryNL;
      case 'SE':
        return l10n.countrySE;
      case 'FI':
        return l10n.countryFI;
      case 'DK':
        return l10n.countryDK;
      case 'CZ':
        return l10n.countryCZ;
      case 'HR':
        return l10n.countryHR;
      case 'BA':
        return l10n.countryBA;
      case 'HU':
        return l10n.countryHU;
      case 'IS':
        return l10n.countryIS;
      case 'SI':
        return l10n.countrySI;
      case 'UA':
        return l10n.countryUA;
      default:
        return countryCode; // Fallback al codice se non trovato
    }
  }
}

enum TeletextChannelType {
  national,
  regional,
}

/// Lista completa dei canali teletext europei
class TeletextChannels {
  static final List<TeletextChannel> allChannels = [
    // 🇮🇹 ITALIA - RAI
    TeletextChannel(
      id: 'rai_nazionale',
      name: 'RAI Nazionale',
      shortName: 'RAI',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/pagina.jsp',
      supportsRegions: true,
      regions: [
        'Piemonte',
        'Aosta',
        'Lombardia',
        'Trentino',
        'Veneto',
        'Friuli',
        'Liguria',
        'EmiliaRomagna',
        'Toscana',
        'Umbria',
        'Marche',
        'Lazio',
        'Abruzzo',
        'Molise',
        'Campania',
        'Puglia',
        'Basilicata',
        'Calabria',
        'Sicilia',
        'Sardegna',
      ],
    ),

    // 🇮🇹 ITALIA - RAI REGIONI (una voce per regione per il selettore)
    TeletextChannel(
      id: 'rai_piemonte',
      name: 'RAI Piemonte',
      shortName: 'Piemonte',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Piemonte'],
    ),
    TeletextChannel(
      id: 'rai_valledaosta',
      name: 'RAI Valle d\'Aosta',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Aosta'],
    ),
    TeletextChannel(
      id: 'rai_lombardia',
      name: 'RAI Lombardia',
      shortName: 'Lombardia',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Lombardia'],
    ),
    TeletextChannel(
      id: 'rai_trentinoaltoadige',
      name: 'RAI Trentino Alto Adige',
      shortName: 'Trentino',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Trentino'],
    ),
    TeletextChannel(
      id: 'rai_veneto',
      name: 'RAI Veneto',
      shortName: 'Veneto',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Veneto'],
    ),
    TeletextChannel(
      id: 'rai_friuliveneziagiulia',
      name: 'RAI Friuli Venezia Giulia',
      shortName: 'Friuli',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Friuli'],
    ),
    TeletextChannel(
      id: 'rai_liguria',
      name: 'RAI Liguria',
      shortName: 'Liguria',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Liguria'],
    ),
    TeletextChannel(
      id: 'rai_emiliaromagna',
      name: 'RAI Emilia Romagna',
      shortName: 'Emilia',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['EmiliaRomagna'],
    ),
    TeletextChannel(
      id: 'rai_toscana',
      name: 'RAI Toscana',
      shortName: 'Toscana',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Toscana'],
    ),
    TeletextChannel(
      id: 'rai_umbria',
      name: 'RAI Umbria',
      shortName: 'Umbria',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Umbria'],
    ),
    TeletextChannel(
      id: 'rai_marche',
      name: 'RAI Marche',
      shortName: 'Marche',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Marche'],
    ),
    TeletextChannel(
      id: 'rai_lazio',
      name: 'RAI Lazio',
      shortName: 'Lazio',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Lazio'],
    ),
    TeletextChannel(
      id: 'rai_abruzzo',
      name: 'RAI Abruzzo',
      shortName: 'Abruzzo',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Abruzzo'],
    ),
    TeletextChannel(
      id: 'rai_molise',
      name: 'RAI Molise',
      shortName: 'Molise',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Molise'],
    ),
    TeletextChannel(
      id: 'rai_campania',
      name: 'RAI Campania',
      shortName: 'Campania',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Campania'],
    ),
    TeletextChannel(
      id: 'rai_puglia',
      name: 'RAI Puglia',
      shortName: 'Puglia',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Puglia'],
    ),
    TeletextChannel(
      id: 'rai_basilicata',
      name: 'RAI Basilicata',
      shortName: 'Basilicata',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Basilicata'],
    ),
    TeletextChannel(
      id: 'rai_calabria',
      name: 'RAI Calabria',
      shortName: 'Calabria',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Calabria'],
    ),
    TeletextChannel(
      id: 'rai_sicilia',
      name: 'RAI Sicilia',
      shortName: 'Sicilia',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Sicilia'],
    ),
    TeletextChannel(
      id: 'rai_sardegna',
      name: 'RAI Sardegna',
      shortName: 'Sardegna',
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['Sardegna'],
    ),



    // 🇩🇪 GERMANIA - ARD
    TeletextChannel(
      id: 'ard_text',
      name: 'ARD Text',
      shortName: 'ARD',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ARD',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.ard-text.de',
      supportsRegions: true,
      regions: [
        'BR', // Bayern
        'HR', // Hessen
        'MDR', // Mitteldeutscher Rundfunk
        'NDR', // Norddeutscher Rundfunk
        'RBB', // Berlin-Brandenburg
        'SR', // Saarland
        'SWR', // Südwestrundfunk
        'WDR', // Westdeutscher Rundfunk
      ],
    ),

    // 🇩🇪 GERMANIA - ZDF
    TeletextChannel(
      id: 'zdf_text',
      name: 'ZDF Text',
      shortName: 'ZDF',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ZDF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.zdf.de/teletext/zdf',
      supportsRegions: false,
    ),

    // 🇩🇪 GERMANIA - ZDFinfo
    TeletextChannel(
      id: 'zdfinfo_text',
      name: 'ZDFinfo Text',
      shortName: 'ZDFinfo',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ZDF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.zdf.de/teletext/zdfinfo',
      supportsRegions: false,
    ),

    // 🇩🇪 GERMANIA - ZDFneo
    TeletextChannel(
      id: 'zdfneo_text',
      name: 'ZDFneo Text',
      shortName: 'ZDFneo',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ZDF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.zdf.de/teletext/zdfneo',
      supportsRegions: false,
    ),

    // 🇩🇪 GERMANIA - 3sat
    TeletextChannel(
      id: '3sat_text',
      name: '3sat Text',
      shortName: '3sat',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ZDF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.zdf.de/teletext/3sat',
      supportsRegions: false,
    ),
    
    // 🇩🇪 GERMANIA - BR (Bayerischer Rundfunk)
    TeletextChannel(
      id: 'br_text',
      name: 'BR Text',
      shortName: 'BR',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'Bayerischer Rundfunk',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.br.de/fernsehen/ardtext',
      htmlBaseUrl: 'https://www.br.de/fernsehen/ardtext/ardtext-100.html',
      supportsRegions: false,
    ),

    // 🇩🇪 GERMANIA - WDR (Westdeutscher Rundfunk)
    TeletextChannel(
      id: 'wdr_text',
      name: 'WDR Text',
      shortName: 'WDR',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'Westdeutscher Rundfunk',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www1.wdr.de/wdrtext',
      htmlBaseUrl: 'https://www1.wdr.de/wdrtext/index.html',
      supportsRegions: false,
    ),
    
    // 🇩🇪 GERMANIA - SWR BW (Baden-Württemberg)
    TeletextChannel(
      id: 'swr_bw',
      name: 'SWR BW Text',
      shortName: 'SWR BW',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'Südwestrundfunk (Baden-Württemberg)',
      type: TeletextChannelType.regional,
      baseUrl: 'https://wraps.swr.de/videotext/',
      htmlBaseUrl: 'https://wraps.swr.de/videotext/?page=100&stream=bw',
      supportsRegions: false,
    ),
    
    // 🇩🇪 GERMANIA - SWR RP (Rheinland-Pfalz)
    TeletextChannel(
      id: 'swr_rp',
      name: 'SWR RP Text',
      shortName: 'SWR RP',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'Südwestrundfunk (Rheinland-Pfalz)',
      type: TeletextChannelType.regional,
      baseUrl: 'https://wraps.swr.de/videotext/',
      htmlBaseUrl: 'https://wraps.swr.de/videotext/?page=100&stream=rp',
      supportsRegions: false,
    ),
    
    // ⚠️ TEMPORANEAMENTE DISABILITATO - In fase di perfezionamento visualizzazione
    // // 🇩🇪 GERMANIA - RTL
    // TeletextChannel(
    //   id: 'rtl_text',
    //   name: 'RTL Text',
    //   shortName: 'RTL',
    //   countryCode: 'DE',
    //   countryName: 'Germania',
    //   flagEmoji: '🇩🇪',
    //   broadcasterName: 'RTL',
    //   type: TeletextChannelType.national,
    //   baseUrl: 'http://193.16.161.100/teletext/rtl',
    //   supportsRegions: false,
    // ),
    
    // 🇨🇭 SVIZZERA - RSI LA 1
    TeletextChannel(
      id: 'rsi_la1',
      name: 'RSI LA 1',
      shortName: 'RSI LA 1',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'RSI',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/RSILA1',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - RSI LA 2
    TeletextChannel(
      id: 'rsi_la2',
      name: 'RSI LA 2',
      shortName: 'RSI LA 2',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'RSI',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/RSILA2',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - RTS 1
    TeletextChannel(
      id: 'rts_1',
      name: 'RTS 1',
      shortName: 'RTS 1',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'RTS',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/RTS1',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - RTS 2
    TeletextChannel(
      id: 'rts_2',
      name: 'RTS 2',
      shortName: 'RTS 2',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'RTS',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/RTS2',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - SRF 1
    TeletextChannel(
      id: 'srf_1',
      name: 'SRF 1',
      shortName: 'SRF 1',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'SRF',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/SRF1',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - SRF zwei
    TeletextChannel(
      id: 'srf_zwei',
      name: 'SRF zwei',
      shortName: 'SRF zwei',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'SRF',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/SRF2',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - SRF info
    TeletextChannel(
      id: 'srf_info',
      name: 'SRF info',
      shortName: 'SRF info',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'SRF',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.ch/SRFinfo',
      supportsRegions: false,
    ),

    // 🇦🇹 AUSTRIA - ORF1
    TeletextChannel(
      id: 'orf1',
      name: 'ORF1',
      shortName: 'ORF1',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ORF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.orf.at/channel/orf1',
      supportsRegions: false,
    ),

    // 🇦🇹 AUSTRIA - ORF2
    TeletextChannel(
      id: 'orf2',
      name: 'ORF2',
      shortName: 'ORF2',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ORF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.orf.at/channel/orf2',
      supportsRegions: false,
    ),

    // 🇦🇹 AUSTRIA - ORF III
    TeletextChannel(
      id: 'orf3',
      name: 'ORF III',
      shortName: 'ORF III',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ORF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.orf.at/channel/orfiii',
      supportsRegions: false,
    ),

    // 🇦🇹 AUSTRIA - ORF Sport+
    TeletextChannel(
      id: 'orf_sport_plus',
      name: 'ORF Sport+',
      shortName: 'ORF Sport+',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ORF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.orf.at/channel/sportplus',
      supportsRegions: false,
    ),

    // 🇪🇸 SPAIN - TVE
    TeletextChannel(
      id: 'tve',
      name: 'TVE',
      shortName: 'TVE',
      countryCode: 'ES',
      countryName: 'España',
      flagEmoji: '🇪🇸',
      broadcasterName: 'RTVE',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.rtve.es/tve/teletexto',
      supportsRegions: false,
    ),

    // 🇪🇸 SPAIN - Antena 3
    TeletextChannel(
      id: 'antena3',
      name: 'Antena 3',
      shortName: 'Antena 3',
      countryCode: 'ES',
      countryName: 'España',
      flagEmoji: '🇪🇸',
      broadcasterName: 'Atresmedia',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.antena3.com/teletexto',
      supportsRegions: false,
    ),

    // 🇪🇸 SPAIN - La Sexta
    TeletextChannel(
      id: 'lasexta',
      name: 'La Sexta',
      shortName: 'La Sexta',
      countryCode: 'ES',
      countryName: 'España',
      flagEmoji: '🇪🇸',
      broadcasterName: 'Atresmedia',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.lasexta.com/teletexto/datos',
      supportsRegions: false,
    ),

    // 🇵🇹 PORTUGAL - RTP
    TeletextChannel(
      id: 'rtp',
      name: 'RTP',
      shortName: 'RTP',
      countryCode: 'PT',
      countryName: 'Portugal',
      flagEmoji: '🇵🇹',
      broadcasterName: 'RTP',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.rtp.pt/wportal/teletexto',
      supportsRegions: false,
    ),

    // 🇳🇱 OLANDA - NOS
    TeletextChannel(
      id: 'nos_teletekst',
      name: 'NOS Teletekst',
      shortName: 'NOS',
      countryCode: 'NL',
      countryName: 'Olanda',
      flagEmoji: '🇳🇱',
      broadcasterName: 'NOS',
      type: TeletextChannelType.national,
      baseUrl: 'https://nos.nl/teletekst',
      supportsRegions: false,
    ),

    // 🇸🇪 SVEZIA - SVT Text
    TeletextChannel(
      id: 'svt_text',
      name: 'SVT Text',
      shortName: 'SVT',
      countryCode: 'SE',
      countryName: 'Svezia',
      flagEmoji: '🇸🇪',
      broadcasterName: 'SVT',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.svt.se/text-tv',
      supportsRegions: false,
    ),

    // 🇫🇮 FINLANDIA - YLE Teksti-TV
    // TeletextChannel(
    //   id: 'yle_teksti_tv',
    //   name: 'YLE Teksti-TV',
    //   countryCode: 'FI',
    //   countryName: 'Finlandia',
    //   flagEmoji: '🇫🇮',
    //   broadcasterName: 'YLE',
    //   type: TeletextChannelType.national,
    //   baseUrl: 'https://yle.fi/aihe/yle-ttv',
    //   supportsRegions: false,
    // ),

    // 🇭🇷 CROAZIA - HRT Teletekst
    TeletextChannel(
      id: 'hrt_teletekst',
      name: 'HRT Teletekst',
      shortName: 'HRT',
      countryCode: 'HR',
      countryName: 'Croazia',
      flagEmoji: '🇭🇷',
      broadcasterName: 'HRT',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletekst.hrt.hr',
      supportsRegions: false,
    ),

    // // 🇵🇹 PORTOGALLO - RTP
    // TeletextChannel(
    //   id: 'rtp_teletexto',
    //   name: 'RTP Teletexto',
    //   countryCode: 'PT',
    //   countryName: 'Portogallo',
    //   flagEmoji: '🇵🇹',
    //   broadcasterName: 'RTP',
    //   type: TeletextChannelType.national,
    //   baseUrl: 'https://www.rtp.pt/teletexto',
    //   supportsRegions: false,
    // ),

    // 🇩🇰 DANIMARCA - DR
    // TeletextChannel(
    //   id: 'dr_tekst_tv',
    //   name: 'DR Tekst-TV',
    //   countryCode: 'DK',
    //   countryName: 'Danimarca',
    //   flagEmoji: '🇩🇰',
    //   broadcasterName: 'DR',
    //   type: TeletextChannelType.national,
    //   baseUrl: 'https://www.dr.dk/tekst-tv',
    //   supportsRegions: false,
    // ),

    // 🇫🇮 FINLANDIA - YLE
    TeletextChannel(
      id: 'yle_teksti_tv',
      name: 'YLE Teksti-TV',
      shortName: 'YLE',
      countryCode: 'FI',
      countryName: 'Finlandia',
      flagEmoji: '🇫🇮',
      broadcasterName: 'YLE',
      type: TeletextChannelType.national,
      baseUrl: 'https://yle.fi/tekstitv',
      supportsRegions: false,
    ),

    // 🇨🇿 REPUBBLICA CECA - ČT
    TeletextChannel(
      id: 'ct_teletext',
      name: 'ČT Teletext',
      shortName: 'ČT',
      countryCode: 'CZ',
      countryName: 'Repubblica Ceca',
      flagEmoji: '🇨🇿',
      broadcasterName: 'Česká televize',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.ceskatelevize.cz',
      supportsRegions: false,
    ),

    // 🇸🇮 SLOVENIA - RTV SLO
    TeletextChannel(
      id: 'rtvslo_teletext',
      name: 'RTV SLO Teletext',
      shortName: 'RTV SLO',
      countryCode: 'SI',
      countryName: 'Slovenia',
      flagEmoji: '🇸🇮',
      broadcasterName: 'RTV Slovenija',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.rtvslo.si',
      supportsRegions: false,
    ),

    // 🇭🇺 UNGHERIA - MTVA
    TeletextChannel(
      id: 'mtva_teletext',
      name: 'MTVA Teletext',
      shortName: 'MTVA',
      countryCode: 'HU',
      countryName: 'Ungheria',
      flagEmoji: '🇭🇺',
      broadcasterName: 'MTVA',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.teletext.hu/mtv1',
      supportsRegions: false,
    ),

    // 🇮🇸 ISLANDA - RÚV
    TeletextChannel(
      id: 'ruv_textavarp',
      name: 'RÚV Textavarp',
      shortName: 'RÚV',
      countryCode: 'IS',
      countryName: 'Islanda',
      flagEmoji: '🇮🇸',
      broadcasterName: 'RÚV',
      type: TeletextChannelType.national,
      baseUrl: 'https://textavarp.is',
      supportsRegions: false,
    ),

    // 🇩🇪 GERMANIA - SOM Teletextviewer (SAT.1, ProSieben, kabel eins, etc.)
    TeletextChannel(
      id: 'som_s1de',
      name: 'SAT.1',
      shortName: 'SAT.1',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'SAT.1',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7de',
      name: 'ProSieben',
      shortName: 'Pro7',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ProSieben',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_k1de',
      name: 'kabel eins',
      shortName: 'k1',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'kabel eins',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_sixx',
      name: 'sixx',
      shortName: 'sixx',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'sixx',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_s1gold',
      name: 'SAT.1 Gold',
      shortName: 'SAT.1 Gold',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'SAT.1 Gold',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7maxx',
      name: 'ProSieben MAXX',
      shortName: 'Pro7 MAXX',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ProSieben MAXX',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_k1doku',
      name: 'kabel eins Doku',
      shortName: 'k1 Doku',
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'kabel eins Doku',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    // 🇦🇹 AUSTRIA - SOM Teletextviewer (SAT.1, ProSieben, kabel eins, sixx)
    TeletextChannel(
      id: 'som_s1at',
      name: 'AT SAT.1',
      shortName: 'SAT.1',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'SAT.1 Österreich',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7at',
      name: 'AT ProSieben',
      shortName: 'Pro7',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ProSieben Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_k1at',
      name: 'AT kabel eins',
      shortName: 'k1',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'kabel eins Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_sixxat',
      name: 'AT sixx',
      shortName: 'sixx',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'sixx Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_s1goldat',
      name: 'AT SAT.1 Gold',
      shortName: 'SAT.1 Gold',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'SAT.1 Gold Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7maxxat',
      name: 'AT ProSieben MAXX',
      shortName: 'Pro7 MAXX',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'ProSieben MAXX Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_k1dokuat',
      name: 'AT kabel eins Doku',
      shortName: 'k1 Doku',
      countryCode: 'AT',
      countryName: 'Austria',
      flagEmoji: '🇦🇹',
      broadcasterName: 'kabel eins Doku Austria',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - SOM Teletextviewer (SAT.1, ProSieben, kabel eins, sixx, Puls 8)
    TeletextChannel(
      id: 'som_s1ch',
      name: 'CH SAT.1',
      shortName: 'SAT.1',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'SAT.1 Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7ch',
      name: 'CH ProSieben',
      shortName: 'Pro7',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'ProSieben Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_k1ch',
      name: 'CH kabel eins',
      shortName: 'k1',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'kabel eins Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_sixxch',
      name: 'CH sixx',
      shortName: 'sixx',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'sixx Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_s1goldch',
      name: 'CH SAT.1 Gold',
      shortName: 'SAT.1 Gold',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'SAT.1 Gold Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_p7maxxch',
      name: 'CH ProSieben MAXX',
      shortName: 'Pro7 MAXX',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'ProSieben MAXX Schweiz',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'som_puls8ch',
      name: 'CH Puls 8',
      shortName: 'Puls 8',
      countryCode: 'CH',
      countryName: 'Svizzera',
      flagEmoji: '🇨🇭',
      broadcasterName: 'Puls 8',
      type: TeletextChannelType.national,
      baseUrl: 'https://som-teletextviewer.sim-technik.de',
      supportsRegions: false,
    ),

    // 🇩🇰 DANIMARCA - DR (Danmarks Radio)
    TeletextChannel(
      id: 'dr1',
      name: 'DR1 Text TV',
      shortName: 'DR1 TV',
      countryCode: 'DK',
      countryName: 'Danimarca',
      flagEmoji: '🇩🇰',
      broadcasterName: 'DR1',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.dr.dk/cgi-bin/fttv1.exe',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'dr2',
      name: 'DR2 Text TV',
      shortName: 'DR2 TV',
      countryCode: 'DK',
      countryName: 'Danimarca',
      flagEmoji: '🇩🇰',
      broadcasterName: 'DR2',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.dr.dk/cgi-bin/fttv2.exe',
      supportsRegions: false,
    ),

    // 🇧🇦 BOSNIA ED ERZEGOVINA - BHRT & RTVFBiH
    TeletextChannel(
      id: 'bhrt',
      name: 'BHRT Teletext',
      shortName: 'BHRT',
      countryCode: 'BA',
      countryName: 'Bosnia ed Erzegovina',
      flagEmoji: '🇧🇦',
      broadcasterName: 'BHRT',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.bhrt.ba',
      supportsRegions: false,
    ),

    TeletextChannel(
      id: 'rtvfbih',
      name: 'RTVFBiH Teletext',
      shortName: 'RTVFBiH',
      countryCode: 'BA',
      countryName: 'Bosnia ed Erzegovina',
      flagEmoji: '🇧🇦',
      broadcasterName: 'Federalna TV',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.rtvfbih.ba',
      supportsRegions: false,
    ),

    // ⚠️ TEMPORANEAMENTE DISABILITATO - In fase di perfezionamento visualizzazione
    // // 🇺🇦 UCRAINA - Intertext
    // TeletextChannel(
    //   id: 'intertext',
    //   name: 'Intertext',
    //   shortName: 'Intertext',
    //   countryCode: 'UA',
    //   countryName: 'Ucraina',
    //   flagEmoji: '🇺🇦',
    //   broadcasterName: 'Intertext',
    //   type: TeletextChannelType.national,
    //   baseUrl: 'https://intertext.com.ua',
    //   supportsRegions: false,
    // ),

  ];

  /// Ottiene tutti i canali attivi
  static List<TeletextChannel> getActiveChannels() {
    return allChannels.where((channel) => channel.isActive).toList();
  }

  /// Ottiene i canali per paese
  static List<TeletextChannel> getChannelsByCountry(String countryCode) {
    return allChannels
        .where((channel) => channel.countryCode == countryCode)
        .toList();
  }

  /// Ottiene un canale per ID
  static TeletextChannel? getChannelById(String id) {
    try {
      return allChannels.firstWhere((channel) => channel.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Ottiene tutti i paesi disponibili
  static List<String> getAvailableCountries() {
    return allChannels
        .map((channel) => channel.countryCode)
        .toSet()
        .toList()
      ..sort();
  }

  /// Ottiene la lista di paesi con nome e bandiera
  /// NOTA: Usa getLocalizedCountryName() per i nomi localizzati
  static List<Map<String, String>> getCountriesWithFlags() {
    final countries = <String, Map<String, String>>{};
    for (final channel in allChannels) {
      if (!countries.containsKey(channel.countryCode)) {
        countries[channel.countryCode] = {
          'code': channel.countryCode,
          'name': channel.countryCode, // Usa il codice come placeholder
          'flag': channel.flagEmoji,
        };
      }
    }
    return countries.values.toList()
      ..sort((a, b) => a['code']!.compareTo(b['code']!));
  }

  /// Cerca canali per nome, broadcaster e paese (localizzato)
  /// 
  /// [query] è la stringa di ricerca
  /// [getLocalizedCountryName] è una funzione opzionale per ottenere il nome localizzato del paese.
  /// Se fornita, la ricerca includerà anche il nome del paese tradotto.
  static List<TeletextChannel> searchChannels(
    String query, {
    String Function(String countryCode)? getLocalizedCountryName,
  }) {
    final lowerQuery = query.toLowerCase();
    return allChannels.where((channel) {
      // Cerca nel nome del canale
      if (channel.name.toLowerCase().contains(lowerQuery)) return true;
      
      // Cerca nel nome del broadcaster
      if (channel.broadcasterName.toLowerCase().contains(lowerQuery)) return true;
      
      // Cerca nel codice paese (es. "IT", "DE")
      if (channel.countryCode.toLowerCase().contains(lowerQuery)) return true;
      
      // Cerca nel nome del paese LOCALIZZATO (es. "Italia", "Germany", "Deutschland")
      if (getLocalizedCountryName != null) {
        final localizedCountryName = getLocalizedCountryName(channel.countryCode);
        if (localizedCountryName.toLowerCase().contains(lowerQuery)) return true;
      }
      
      return false;
    }).toList();
  }
  
  /// Ottiene tutti i canali ordinati in modo intelligente
  /// 
  /// L'ordinamento è:
  /// 1. Canali del paese dell'utente (se rilevato)
  /// 2. Altri canali ordinati per nome del paese localizzato
  /// 
  /// [userCountryCode] è il codice ISO del paese dell'utente (es. 'IT', 'DE')
  /// [getLocalizedCountryName] è una funzione per ottenere il nome localizzato del paese
  static List<TeletextChannel> getSortedChannels({
    String? userCountryCode,
    required String Function(String countryCode) getLocalizedCountryName,
  }) {
    final List<TeletextChannel> result = [];
    final Set<String> processedCountries = {};
    
    // 1. Se c'è un paese utente, aggiungi prima i suoi canali
    if (userCountryCode != null && userCountryCode.isNotEmpty) {
      final userCountryChannels = allChannels
          .where((channel) => channel.countryCode == userCountryCode)
          .toList();
      
      if (userCountryChannels.isNotEmpty) {
        result.addAll(userCountryChannels);
        processedCountries.add(userCountryCode);
        print('[TeletextChannels] Added ${userCountryChannels.length} channels for user country: $userCountryCode');
      }
    }
    
    // 2. Raggruppa i canali per paese
    final Map<String, List<TeletextChannel>> channelsByCountry = {};
    for (final channel in allChannels) {
      if (!processedCountries.contains(channel.countryCode)) {
        channelsByCountry.putIfAbsent(channel.countryCode, () => []).add(channel);
      }
    }
    
    // 3. Ordina i paesi per nome localizzato
    final sortedCountries = channelsByCountry.keys.toList()
      ..sort((a, b) {
        final nameA = getLocalizedCountryName(a);
        final nameB = getLocalizedCountryName(b);
        return nameA.compareTo(nameB);
      });
    
    // 4. Aggiungi i canali di ogni paese nell'ordine ordinato
    for (final countryCode in sortedCountries) {
      final countryChannels = channelsByCountry[countryCode]!;
      result.addAll(countryChannels);
    }
    
    print('[TeletextChannels] Total channels sorted: ${result.length}');
    return result;
  }
  
  /// Ottiene un set unico di country codes presenti nei canali
  static Set<String> getAllCountryCodes() {
    return allChannels.map((channel) => channel.countryCode).toSet();
  }
}

