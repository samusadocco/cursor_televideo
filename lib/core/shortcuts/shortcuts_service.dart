import 'package:cursor_televideo/shared/models/shortcut_page.dart';

class ShortcutsService {
  static final ShortcutsService _instance = ShortcutsService._internal();
  factory ShortcutsService() => _instance;
  ShortcutsService._internal();

  // RAI Nazionale
  final List<ShortcutPage> _raiNationalShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Indice'),
    const ShortcutPage(pageNumber: 101, title: 'Ultim\'ora'),
    const ShortcutPage(pageNumber: 103, title: 'Prima'),
    //const ShortcutPage(pageNumber: 110, title: 'Primo Piano'),
    const ShortcutPage(pageNumber: 120, title: 'Politica'),
    const ShortcutPage(pageNumber: 130, title: 'Economia'),
    const ShortcutPage(pageNumber: 140, title: 'Dall\'Italia'),
    const ShortcutPage(pageNumber: 150, title: 'Dal mondo'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 400, title: 'Pubblica Utilità'),
    const ShortcutPage(pageNumber: 401, title: 'Almanacco'),
    const ShortcutPage(pageNumber: 545, title: 'Magazine'),
    const ShortcutPage(pageNumber: 613, title: 'Viabilità'),
    const ShortcutPage(pageNumber: 700, title: 'Meteo'),
  ];

  // RAI Regionale
  final List<ShortcutPage> _raiRegionalShortcuts = [
    const ShortcutPage(pageNumber: 300, title: 'Indice Regione'),
    const ShortcutPage(pageNumber: 301, title: 'Sport Regione'),
    const ShortcutPage(pageNumber: 401, title: 'Meteo'),
    const ShortcutPage(pageNumber: 406, title: 'Eventi-Mostre'),
    const ShortcutPage(pageNumber: 412, title: 'La regione del gusto'),
    const ShortcutPage(pageNumber: 420, title: 'In viaggio'),
    const ShortcutPage(pageNumber: 430, title: 'Cinema'),
    const ShortcutPage(pageNumber: 450, title: 'Teatri'),
    const ShortcutPage(pageNumber: 498, title: 'Istituzioni'),
    const ShortcutPage(pageNumber: 520, title: 'Società'),
    const ShortcutPage(pageNumber: 575, title: 'Culturambiente'),
    const ShortcutPage(pageNumber: 690, title: 'Farmacie'),
  ];

  // ARD Text (Germania)
  final List<ShortcutPage> _ardShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Seite 100'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten '),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur'),
    const ShortcutPage(pageNumber: 171, title: 'Wetter'),
    const ShortcutPage(pageNumber: 700, title: 'Börse'),
    const ShortcutPage(pageNumber: 790, title: 'Inhalt A-Z'),
  ];

  // ZDF Text (Germania)
  final List<ShortcutPage> _zdfShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht (Indice)'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm (TV)'),
    const ShortcutPage(pageNumber: 400, title: 'Sport II'),
    const ShortcutPage(pageNumber: 500, title: 'Kultur'),
    const ShortcutPage(pageNumber: 600, title: 'Ratgeber'),
    const ShortcutPage(pageNumber: 700, title: 'Service'),
  ];

  // Swiss Teletext (Svizzera - RSI/RTS/SRF)
  final List<ShortcutPage> _swissShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Indice / Sommaire'),
    const ShortcutPage(pageNumber: 101, title: 'Notizie / Nouvelles'),
    const ShortcutPage(pageNumber: 120, title: 'Svizzera / Suisse'),
    const ShortcutPage(pageNumber: 150, title: 'Mondo / Monde'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programmi TV'),
    const ShortcutPage(pageNumber: 400, title: 'Cultura'),
    const ShortcutPage(pageNumber: 500, title: 'Economia'),
    const ShortcutPage(pageNumber: 700, title: 'Meteo / Météo'),
  ];

  // ORF Teletext (Austria)
  final List<ShortcutPage> _orfShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'ORF Teletext Inhalt'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 104, title: 'International'),
    const ShortcutPage(pageNumber: 105, title: 'Sport'),
    const ShortcutPage(pageNumber: 106, title: 'Kultur'),
    const ShortcutPage(pageNumber: 109, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 230, title: 'Fußball'),
    const ShortcutPage(pageNumber: 300, title: 'TV-Programm'),
    const ShortcutPage(pageNumber: 400, title: 'Service'),
    const ShortcutPage(pageNumber: 520, title: 'Weltgeschehen'),
    const ShortcutPage(pageNumber: 700, title: 'Verkehr'),
  ];

  // Spanish Teletext (Spagna - TVE, Antena 3, La Sexta)
  final List<ShortcutPage> _spanishShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 101, title: 'Noticias'),
    const ShortcutPage(pageNumber: 102, title: 'España'),
    const ShortcutPage(pageNumber: 120, title: 'Internacional'),
    const ShortcutPage(pageNumber: 130, title: 'Sociedad'),
    const ShortcutPage(pageNumber: 140, title: 'Cultura'),
    const ShortcutPage(pageNumber: 150, title: 'Economía'),
    const ShortcutPage(pageNumber: 180, title: 'El Tiempo'),
    const ShortcutPage(pageNumber: 200, title: 'Deportes'),
    const ShortcutPage(pageNumber: 201, title: 'Fútbol'),
    const ShortcutPage(pageNumber: 300, title: 'Servicios'),
    const ShortcutPage(pageNumber: 400, title: 'Programación TV'),
    const ShortcutPage(pageNumber: 600, title: 'Tráfico'),
  ];

  // Portuguese Teletext (Portogallo - RTP)
  final List<ShortcutPage> _portugueseShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 102, title: 'Notícias'),
    const ShortcutPage(pageNumber: 120, title: 'Internacional'),
    const ShortcutPage(pageNumber: 121, title: 'Economia'),
    const ShortcutPage(pageNumber: 241, title: 'Bolsa'),
    const ShortcutPage(pageNumber: 300, title: 'Televisão'),
    const ShortcutPage(pageNumber: 400, title: 'Desporto'),
    const ShortcutPage(pageNumber: 473, title: 'Campeonato Mundo'),
    const ShortcutPage(pageNumber: 490, title: 'Totolotarias'),
    const ShortcutPage(pageNumber: 500, title: 'Utilidades'),
    const ShortcutPage(pageNumber: 575, title: 'Meteorologia'),
    const ShortcutPage(pageNumber: 800, title: 'Farmácias'),
  ];

  // Dutch Teletext (Olanda - NOS)
  final List<ShortcutPage> _dutchShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Voorpagina'),
    const ShortcutPage(pageNumber: 101, title: 'Nieuws'),
    const ShortcutPage(pageNumber: 104, title: 'Binnenland'),
    const ShortcutPage(pageNumber: 106, title: 'Buitenland'),
    const ShortcutPage(pageNumber: 200, title: 'Televisie'),
    const ShortcutPage(pageNumber: 250, title: 'Radio'),
    const ShortcutPage(pageNumber: 501, title: 'Financieel'),
    const ShortcutPage(pageNumber: 600, title: 'Sport'),
    const ShortcutPage(pageNumber: 700, title: 'Weer/Verkeer'),
    const ShortcutPage(pageNumber: 800, title: 'Voetbal'),
    const ShortcutPage(pageNumber: 888, title: 'Ondertiteling'),
  ];

  // Swedish Teletext (Svezia - SVT)
  final List<ShortcutPage> _swedishShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Nyheter'),
    const ShortcutPage(pageNumber: 300, title: 'Sport'),
    const ShortcutPage(pageNumber: 330, title: 'Resultatbörsen'),
    const ShortcutPage(pageNumber: 377, title: 'Målservice'),
    const ShortcutPage(pageNumber: 400, title: 'Väder'),
    const ShortcutPage(pageNumber: 500, title: 'Blandat'),
    const ShortcutPage(pageNumber: 600, title: 'På TV'),
    const ShortcutPage(pageNumber: 700, title: 'Innehåll'),
    const ShortcutPage(pageNumber: 800, title: 'UR'),
  ];

  // Finnish Teletext (Finlandia - YLE)
  final List<ShortcutPage> _finnishShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Uutiset'),
    const ShortcutPage(pageNumber: 160, title: 'Talous'),
    const ShortcutPage(pageNumber: 190, title: 'English'),
    const ShortcutPage(pageNumber: 201, title: 'Urheilu'),
    const ShortcutPage(pageNumber: 300, title: 'Ohjelmat'),
    const ShortcutPage(pageNumber: 400, title: 'Sää'),
    const ShortcutPage(pageNumber: 500, title: 'Alueet'),
    const ShortcutPage(pageNumber: 575, title: 'Teksti-TV'),
    const ShortcutPage(pageNumber: 799, title: 'Svenska'),
  ];

  // Slovenian Teletext (Slovenia - RTV SLO)
  final List<ShortcutPage> _slovenianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Indeks'),
    const ShortcutPage(pageNumber: 101, title: 'Zadnja novica'),
    const ShortcutPage(pageNumber: 110, title: 'Slovenija'),
    const ShortcutPage(pageNumber: 140, title: 'Svet'),
    const ShortcutPage(pageNumber: 160, title: 'Vreme'),
    const ShortcutPage(pageNumber: 190, title: 'Črna kronika'),
    const ShortcutPage(pageNumber: 400, title: 'Kultura'),
    const ShortcutPage(pageNumber: 500, title: 'Šport'),
    const ShortcutPage(pageNumber: 600, title: 'Zabava'),
  ];

  // Hungarian Teletext (Ungheria - MTVA)
  final List<ShortcutPage> _hungarianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Főmenü'),
    const ShortcutPage(pageNumber: 101, title: 'Hírek'),
    const ShortcutPage(pageNumber: 102, title: 'Belföld'),
    const ShortcutPage(pageNumber: 130, title: 'Külföld'),
    const ShortcutPage(pageNumber: 150, title: 'Gazdaság'),
    const ShortcutPage(pageNumber: 160, title: 'Kultúra'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Időjárás'),
    const ShortcutPage(pageNumber: 500, title: 'TV műsor'),
  ];

  // Icelandic Teletext (Islanda - RÚV)
  final List<ShortcutPage> _icelandicShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Forsíða'),
    const ShortcutPage(pageNumber: 101, title: 'Fréttir'),
    const ShortcutPage(pageNumber: 102, title: 'Innlendar'),
    const ShortcutPage(pageNumber: 103, title: 'Erlendar'),
    const ShortcutPage(pageNumber: 160, title: 'Veður'),
    const ShortcutPage(pageNumber: 200, title: 'Dagskrá'),
    const ShortcutPage(pageNumber: 300, title: 'Íþróttir'),
    const ShortcutPage(pageNumber: 400, title: 'Samgöngur'),
    const ShortcutPage(pageNumber: 555, title: 'Efnisyfirlit'),
  ];

  // RTL Text (Germania)
  final List<ShortcutPage> _rtlShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Startseite'),
    const ShortcutPage(pageNumber: 102, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 110, title: 'Wetter'),
    const ShortcutPage(pageNumber: 144, title: 'RTL aktuell'),
    const ShortcutPage(pageNumber: 150, title: 'Guten Morgen Deutschland'),
    const ShortcutPage(pageNumber: 180, title: 'Punkt 12'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV-Programm'),
    const ShortcutPage(pageNumber: 500, title: 'Service'),
  ];
  
  // Croatian Teletext (Croazia - HRT)
  final List<ShortcutPage> _croatianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Sadržaj'),
    const ShortcutPage(pageNumber: 101, title: 'Vijesti'),
    const ShortcutPage(pageNumber: 102, title: 'Hrvatska'),
    const ShortcutPage(pageNumber: 103, title: 'Svijet'),
    const ShortcutPage(pageNumber: 150, title: 'Gospodarstvo'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Vrijeme'),
    const ShortcutPage(pageNumber: 400, title: 'Kultura'),
    const ShortcutPage(pageNumber: 500, title: 'TV program'),
  ];
  
  // Czech Teletext (Repubblica Ceca - ČT)
  final List<ShortcutPage> _czechShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Obsah'),
    const ShortcutPage(pageNumber: 101, title: 'Zprávy'),
    const ShortcutPage(pageNumber: 102, title: 'Česko'),
    const ShortcutPage(pageNumber: 103, title: 'Zahraničí'),
    const ShortcutPage(pageNumber: 150, title: 'Ekonomika'),
    const ShortcutPage(pageNumber: 160, title: 'Kultura'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Počasí'),
    const ShortcutPage(pageNumber: 500, title: 'TV program'),
  ];
  
  // Danish Teletext (Danimarca - DR)
  final List<ShortcutPage> _danishShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Forside'),
    const ShortcutPage(pageNumber: 101, title: 'Nyheder'),
    const ShortcutPage(pageNumber: 102, title: 'Indland'),
    const ShortcutPage(pageNumber: 103, title: 'Udland'),
    const ShortcutPage(pageNumber: 150, title: 'Økonomi'),
    const ShortcutPage(pageNumber: 160, title: 'Vejr'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Kultur'),
    const ShortcutPage(pageNumber: 500, title: 'TV-guide'),
  ];
  
  // Bosnian Teletext (Bosnia ed Erzegovina - BHRT/RTVFBiH)
  final List<ShortcutPage> _bosnianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Sadržaj'),
    const ShortcutPage(pageNumber: 101, title: 'Vijesti'),
    const ShortcutPage(pageNumber: 102, title: 'BiH'),
    const ShortcutPage(pageNumber: 103, title: 'Svijet'),
    const ShortcutPage(pageNumber: 150, title: 'Ekonomija'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Vrijeme'),
    const ShortcutPage(pageNumber: 400, title: 'Kultura'),
    const ShortcutPage(pageNumber: 500, title: 'TV program'),
  ];
  
  // Ukrainian Teletext (Ucraina - Intertext)
  final List<ShortcutPage> _ukrainianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Головна'),
    const ShortcutPage(pageNumber: 101, title: 'Новини'),
    const ShortcutPage(pageNumber: 102, title: 'Україна'),
    const ShortcutPage(pageNumber: 103, title: 'Світ'),
    const ShortcutPage(pageNumber: 150, title: 'Економіка'),
    const ShortcutPage(pageNumber: 200, title: 'Спорт'),
    const ShortcutPage(pageNumber: 300, title: 'Погода'),
    const ShortcutPage(pageNumber: 400, title: 'Культура'),
    const ShortcutPage(pageNumber: 500, title: 'ТВ-програма'),
  ];

  // SOM Teletextviewer (Germania/Austria/Svizzera - SAT.1, ProSieben, etc.)
  final List<ShortcutPage> _somShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Inhalt'),
    const ShortcutPage(pageNumber: 111, title: 'News'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV-Programm'),
    const ShortcutPage(pageNumber: 310, title: 'Spielfilm-Übersicht'),
    const ShortcutPage(pageNumber: 400, title: 'Service'),
    const ShortcutPage(pageNumber: 500, title: 'Wetter'),
  ];

  /// Restituisce gli shortcuts in base al channelId
  List<ShortcutPage> getShortcutsForChannel({
    required String? channelId,
    required bool isRegional,
    bool isPage100Available = true,
  }) {
    // Se channelId è null o inizia con 'rai', usa le shortcuts RAI
    if (channelId == null || channelId.startsWith('rai')) {
      if (isRegional) {
        return _raiRegionalShortcuts;
      } else {
        if (isPage100Available) {
          return _raiNationalShortcuts;
        } else {
          return _raiNationalShortcuts.where((s) => s.pageNumber != 100).toList();
        }
      }
    }
    
    // ARD Text
    if (channelId == 'ard_text') {
      return _ardShortcuts;
    }
    
    // ZDF Text (tutti i canali ZDF usano gli stessi shortcuts)
    if (channelId == 'zdf_text' || 
        channelId == 'zdfinfo_text' || 
        channelId == 'zdfneo_text' || 
        channelId == '3sat_text') {
      return _zdfShortcuts;
    }
    
    // Swiss Teletext (RSI, RTS, SRF)
    if (channelId.startsWith('rsi_') || 
        channelId.startsWith('rts_') || 
        channelId.startsWith('srf_')) {
      return _swissShortcuts;
    }
    
    // ORF Teletext (Austria)
    if (channelId == 'orf1' || 
        channelId == 'orf2' || 
        channelId == 'orf3' || 
        channelId == 'orf_sport_plus') {
      return _orfShortcuts;
    }
    
    // Spanish Teletext (Spagna)
    if (channelId == 'tve' || 
        channelId == 'antena3' || 
        channelId == 'lasexta') {
      return _spanishShortcuts;
    }
    
    // Portuguese Teletext (Portogallo)
    if (channelId == 'rtp') {
      return _portugueseShortcuts;
    }
    
    // Dutch Teletext (Olanda)
    if (channelId == 'nos_teletekst') {
      return _dutchShortcuts;
    }
    
    // Swedish Teletext (Svezia)
    if (channelId == 'svt_text') {
      return _swedishShortcuts;
    }
    
    // Finnish Teletext (Finlandia)
    if (channelId == 'yle_teksti_tv') {
      return _finnishShortcuts;
    }
    
    if (channelId == 'rtvslo_teletext') {
      return _slovenianShortcuts;
    }
    
    if (channelId == 'mtva_teletext') {
      return _hungarianShortcuts;
    }
    
    if (channelId == 'ruv_textavarp') {
      return _icelandicShortcuts;
    }
    
    // RTL Text
    if (channelId == 'rtl_text') {
      return _rtlShortcuts;
    }
    
    // Croatian Teletext (HRT)
    if (channelId == 'hrt_teletekst') {
      return _croatianShortcuts;
    }
    
    // Czech Teletext (ČT)
    if (channelId == 'ct_teletext') {
      return _czechShortcuts;
    }
    
    // Danish Teletext (DR1 e DR2)
    if (channelId == 'dr1' || channelId == 'dr2') {
      return _danishShortcuts;
    }
    
    // Bosnian Teletext (BHRT e RTVFBiH)
    if (channelId == 'bhrt' || channelId == 'rtvfbih') {
      return _bosnianShortcuts;
    }
    
    // Ukrainian Teletext (Intertext)
    if (channelId == 'intertext') {
      return _ukrainianShortcuts;
    }
    
    // SOM Teletextviewer (Germania/Austria/Svizzera)
    if (channelId.startsWith('som_')) {
      return _somShortcuts;
    }
    
    // Default: RAI nazionale
    return _raiNationalShortcuts;
  }

  // Metodi legacy per retrocompatibilità
  @Deprecated('Use getShortcutsForChannel instead')
  final List<ShortcutPage> regionalShortcuts = const [
    ShortcutPage(pageNumber: 300, title: 'Indice Regione'),
    ShortcutPage(pageNumber: 301, title: 'Sport Regione'),
    ShortcutPage(pageNumber: 401, title: 'Meteo'),
    ShortcutPage(pageNumber: 406, title: 'Eventi-Mostre'),
    ShortcutPage(pageNumber: 412, title: 'La regione del gusto'),
    ShortcutPage(pageNumber: 420, title: 'In viaggio'),
    ShortcutPage(pageNumber: 430, title: 'Cinema'),
    ShortcutPage(pageNumber: 450, title: 'Teatri'),
    ShortcutPage(pageNumber: 498, title: 'Istituzioni'),
    ShortcutPage(pageNumber: 520, title: 'Società'),
    ShortcutPage(pageNumber: 575, title: 'Culturambiente'),
    ShortcutPage(pageNumber: 690, title: 'Farmacie'),
  ];

  @Deprecated('Use getShortcutsForChannel instead')
  List<ShortcutPage> getNationalShortcuts({required bool isPage100Available}) {
    if (isPage100Available) {
      return _raiNationalShortcuts;
    } else {
      return _raiNationalShortcuts.where((shortcut) => shortcut.pageNumber != 100).toList();
    }
  }

  @Deprecated('Use getShortcutsForChannel instead')
  List<ShortcutPage> getShortcuts({required bool isNational}) {
    return isNational ? _raiNationalShortcuts : _raiRegionalShortcuts;
  }
} 