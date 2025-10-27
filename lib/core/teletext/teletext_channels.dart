import 'package:freezed_annotation/freezed_annotation.dart';

part 'teletext_channels.freezed.dart';
part 'teletext_channels.g.dart';

/// Rappresenta un canale teletext
@freezed
class TeletextChannel with _$TeletextChannel {
  const factory TeletextChannel({
    required String id,
    required String name,
    required String countryCode,
    required String countryName,
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
        'ValleAosta',
        'Lombardia',
        'TrentinoAltoAdige',
        'Veneto',
        'FriuliVeneziaGiulia',
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
      regions: ['ValleAosta'],
    ),
    TeletextChannel(
      id: 'rai_lombardia',
      name: 'RAI Lombardia',
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
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['TrentinoAltoAdige'],
    ),
    TeletextChannel(
      id: 'rai_veneto',
      name: 'RAI Veneto',
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
      countryCode: 'IT',
      countryName: 'Italia',
      flagEmoji: '🇮🇹',
      broadcasterName: 'RAI',
      type: TeletextChannelType.regional,
      baseUrl: 'https://www.televideo.rai.it/televideo/pub/tt4web',
      htmlBaseUrl: 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp',
      regions: ['FriuliVeneziaGiulia'],
    ),
    TeletextChannel(
      id: 'rai_liguria',
      name: 'RAI Liguria',
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
      countryCode: 'DE',
      countryName: 'Germania',
      flagEmoji: '🇩🇪',
      broadcasterName: 'ZDF',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.zdf.de/teletext/3sat',
      supportsRegions: false,
    ),

    // 🇨🇭 SVIZZERA - RSI LA 1
    TeletextChannel(
      id: 'rsi_la1',
      name: 'RSI LA 1',
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
      countryCode: 'SE',
      countryName: 'Svezia',
      flagEmoji: '🇸🇪',
      broadcasterName: 'SVT',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.svt.se/text-tv',
      supportsRegions: false,
    ),

    // 🇫🇮 FINLANDIA - YLE Teksti-TV
    TeletextChannel(
      id: 'yle_teksti_tv',
      name: 'YLE Teksti-TV',
      countryCode: 'FI',
      countryName: 'Finlandia',
      flagEmoji: '🇫🇮',
      broadcasterName: 'YLE',
      type: TeletextChannelType.national,
      baseUrl: 'https://yle.fi/aihe/yle-ttv',
      supportsRegions: false,
    ),

    // 🇭🇷 CROAZIA - HRT Teletekst
    TeletextChannel(
      id: 'hrt_teletekst',
      name: 'HRT Teletekst',
      countryCode: 'HR',
      countryName: 'Croazia',
      flagEmoji: '🇭🇷',
      broadcasterName: 'HRT',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletekst.hrt.hr',
      supportsRegions: false,
    ),

    // 🇪🇸 SPAGNA - TVE
    TeletextChannel(
      id: 'tve_teletexto',
      name: 'TVE Teletexto',
      countryCode: 'ES',
      countryName: 'Spagna',
      flagEmoji: '🇪🇸',
      broadcasterName: 'TVE',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.rtve.es/teletexto',
      supportsRegions: false,
    ),

    // 🇵🇹 PORTOGALLO - RTP
    TeletextChannel(
      id: 'rtp_teletexto',
      name: 'RTP Teletexto',
      countryCode: 'PT',
      countryName: 'Portogallo',
      flagEmoji: '🇵🇹',
      broadcasterName: 'RTP',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.rtp.pt/teletexto',
      supportsRegions: false,
    ),

    // 🇩🇰 DANIMARCA - DR
    TeletextChannel(
      id: 'dr_tekst_tv',
      name: 'DR Tekst-TV',
      countryCode: 'DK',
      countryName: 'Danimarca',
      flagEmoji: '🇩🇰',
      broadcasterName: 'DR',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.dr.dk/tekst-tv',
      supportsRegions: false,
    ),

    // 🇫🇮 FINLANDIA - YLE
    TeletextChannel(
      id: 'yle_teksti_tv',
      name: 'YLE Teksti-TV',
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
      countryCode: 'CZ',
      countryName: 'Repubblica Ceca',
      flagEmoji: '🇨🇿',
      broadcasterName: 'Česká televize',
      type: TeletextChannelType.national,
      baseUrl: 'https://teletext.ceskatelevize.cz',
      supportsRegions: false,
    ),

    // 🇵🇱 POLONIA - TVP
    TeletextChannel(
      id: 'tvp_telegazeta',
      name: 'TVP Telegazeta',
      countryCode: 'PL',
      countryName: 'Polonia',
      flagEmoji: '🇵🇱',
      broadcasterName: 'TVP',
      type: TeletextChannelType.national,
      baseUrl: 'https://www.tvp.pl/telegazeta',
      supportsRegions: false,
    ),

    // 🇸🇮 SLOVENIA - RTV SLO
    TeletextChannel(
      id: 'rtvslo_teletext',
      name: 'RTV SLO Teletext',
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
      countryCode: 'IS',
      countryName: 'Islanda',
      flagEmoji: '🇮🇸',
      broadcasterName: 'RÚV',
      type: TeletextChannelType.national,
      baseUrl: 'https://textavarp.is',
      supportsRegions: false,
    ),

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
  static List<Map<String, String>> getCountriesWithFlags() {
    final countries = <String, Map<String, String>>{};
    for (final channel in allChannels) {
      if (!countries.containsKey(channel.countryCode)) {
        countries[channel.countryCode] = {
          'code': channel.countryCode,
          'name': channel.countryName,
          'flag': channel.flagEmoji,
        };
      }
    }
    return countries.values.toList()
      ..sort((a, b) => a['name']!.compareTo(b['name']!));
  }

  /// Cerca canali per nome
  static List<TeletextChannel> searchChannels(String query) {
    final lowerQuery = query.toLowerCase();
    return allChannels.where((channel) {
      return channel.name.toLowerCase().contains(lowerQuery) ||
          channel.broadcasterName.toLowerCase().contains(lowerQuery) ||
          channel.countryName.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

