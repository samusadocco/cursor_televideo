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

  // BR Text (Bayern - Bayerischer Rundfunk)
  final List<ShortcutPage> _brShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Startseite'),
    const ShortcutPage(pageNumber: 790, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 155, title: 'Wirtschaft'),
    const ShortcutPage(pageNumber: 360, title: 'Bayern'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 470, title: 'BR-Intern'),
    const ShortcutPage(pageNumber: 710, title: 'Börse'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
  ];

  // WDR Text (NRW - Westdeutscher Rundfunk)
  final List<ShortcutPage> _wdrShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Startseite'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 180, title: 'Wetter in NRW'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'WDR Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'WDR Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Service-Seiten'),
    const ShortcutPage(pageNumber: 700, title: 'Landesstudios'),
    const ShortcutPage(pageNumber: 800, title: 'Aktuelle Dossiers'),
    const ShortcutPage(pageNumber: 891, title: 'A-Z'),
  ];

  // ZDF Text (Germania - Hauptprogramm)
  final List<ShortcutPage> _zdfShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 111, title: 'Schlagzeilen'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 555, title: 'Gewinnzahlen'),
    const ShortcutPage(pageNumber: 710, title: 'ZDFinfo'),
    const ShortcutPage(pageNumber: 715, title: 'ZDFneo'),
    const ShortcutPage(pageNumber: 890, title: 'Index A-Z'),
  ];

  // ZDFinfo Text (Germania - Documentari)
  final List<ShortcutPage> _zdfinfoShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 102, title: 'Inhalt (A-Z)'),
    const ShortcutPage(pageNumber: 111, title: 'Schlagzeilen'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 300, title: 'ZDFinfo Programm'),
    const ShortcutPage(pageNumber: 710, title: 'ZDF-Programm'),
    const ShortcutPage(pageNumber: 715, title: 'ZDFneo'),
  ];

  // ZDFneo Text (Germania - Entertainment)
  final List<ShortcutPage> _zdfneoShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 102, title: 'Inhalt (A-Z)'),
    const ShortcutPage(pageNumber: 111, title: 'Letzte Meldung'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 555, title: 'Gewinnzahlen'),
    const ShortcutPage(pageNumber: 710, title: 'ZDFinfo'),
    const ShortcutPage(pageNumber: 715, title: 'ZDF-Programm'),
  ];

  // 3sat Text (Germania/Austria/Svizzera - Cultura)
  final List<ShortcutPage> _dreisatShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten Deutschland'),
    const ShortcutPage(pageNumber: 150, title: 'Nachrichten Österreich'),
    const ShortcutPage(pageNumber: 151, title: 'Nachrichten Schweiz'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm 3sat'),
    const ShortcutPage(pageNumber: 400, title: 'Wetter'),
    const ShortcutPage(pageNumber: 500, title: 'Kultur'),
  ];

  // RSI Teletext (Svizzera italiana - RSI LA1 e LA2)
  final List<ShortcutPage> _rsiShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'News'),
    const ShortcutPage(pageNumber: 180, title: 'Sport'),
    const ShortcutPage(pageNumber: 500, title: 'Meteo'),
    const ShortcutPage(pageNumber: 700, title: 'TV&Radio'),
      const ShortcutPage(pageNumber: 800, title: 'Impressum'),
      ];

  // RTS Teletext (Svizzera francese - RTS 1 e 2)
  final List<ShortcutPage> _rtsShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'News'),
    const ShortcutPage(pageNumber: 180, title: 'Sport'),
    const ShortcutPage(pageNumber: 500, title: 'Météo'),
    const ShortcutPage(pageNumber: 700, title: 'TV&Radio'),
      const ShortcutPage(pageNumber: 800, title: 'Impressum'),
  ];

  // SRF Teletext (Svizzera tedesca - SRF 1, zwei, info)
  final List<ShortcutPage> _srfShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'News'),
    const ShortcutPage(pageNumber: 180, title: 'Sport'),
    const ShortcutPage(pageNumber: 500, title: 'Meteo'),
    const ShortcutPage(pageNumber: 700, title: 'TV&Radio'),
      const ShortcutPage(pageNumber: 800, title: 'Impressum'),
  ];

  // ORF1 Teletext (Austria - ORF1)
  final List<ShortcutPage> _orf1Shortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Seite 100'),
    const ShortcutPage(pageNumber: 111, title: 'Schlagzeilen'),
    const ShortcutPage(pageNumber: 112, title: 'Politik Österreich + EU'),
    const ShortcutPage(pageNumber: 126, title: 'Politik International'),
    const ShortcutPage(pageNumber: 135, title: 'Chronik'),
    const ShortcutPage(pageNumber: 145, title: 'Leute'),
    const ShortcutPage(pageNumber: 150, title: 'Wirtschaft'),
    const ShortcutPage(pageNumber: 190, title: 'Kultur + Show'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 380, title: 'Radios'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur + Show Termine'),
    const ShortcutPage(pageNumber: 420, title: 'Help'),
    const ShortcutPage(pageNumber: 430, title: 'Motor'),
    const ShortcutPage(pageNumber: 460, title: 'Multimedia'),
    const ShortcutPage(pageNumber: 470, title: 'Nachrichten leicht (B1)'),
    const ShortcutPage(pageNumber: 480, title: 'Nachrichten leichter (A2)'),
    const ShortcutPage(pageNumber: 600, title: 'Wetter'),
    const ShortcutPage(pageNumber: 640, title: 'Gesundheit'),
    const ShortcutPage(pageNumber: 700, title: 'Bundesländer'),
    const ShortcutPage(pageNumber: 720, title: 'Spiel + Sterne'),
    const ShortcutPage(pageNumber: 750, title: 'Fußball 2'),
    const ShortcutPage(pageNumber: 770, title: 'Lesen statt hören'),
    const ShortcutPage(pageNumber: 800, title: 'Reisen'),
    const ShortcutPage(pageNumber: 825, title: 'Reiseinfo'),
    const ShortcutPage(pageNumber: 870, title: 'Ihr ORF'),
    const ShortcutPage(pageNumber: 890, title: 'Index A-Z'),
  ];

  // ORF2 Teletext (Austria - ORF2)
  final List<ShortcutPage> _orf2Shortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Seite 100'),
    const ShortcutPage(pageNumber: 111, title: 'Schlagzeilen'),
    const ShortcutPage(pageNumber: 112, title: 'Politik Österreich + EU'),
    const ShortcutPage(pageNumber: 135, title: 'Chronik'),
    const ShortcutPage(pageNumber: 150, title: 'Wirtschaft'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur + Show Termine'),
    const ShortcutPage(pageNumber: 600, title: 'Wetter'),
    const ShortcutPage(pageNumber: 700, title: 'Bundesländer'),
    const ShortcutPage(pageNumber: 890, title: 'Index A-Z'),
  ];

  // ORF III Teletext (Austria - ORF III)
  final List<ShortcutPage> _orf3Shortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Seite 100'),
    const ShortcutPage(pageNumber: 311, title: 'ORF III heute'),
    const ShortcutPage(pageNumber: 327, title: 'ORF III morgen'),
    const ShortcutPage(pageNumber: 350, title: 'ORF III Vorschau'),
    const ShortcutPage(pageNumber: 380, title: 'Kultur + Show'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur + Show Termine'),
    const ShortcutPage(pageNumber: 470, title: 'Nachrichten leicht (B1)'),
    const ShortcutPage(pageNumber: 600, title: 'Wetter'),
    const ShortcutPage(pageNumber: 870, title: 'Ihr ORF'),
    const ShortcutPage(pageNumber: 890, title: 'Index A-Z'),
  ];

  // ORF Sport+ Teletext (Austria - ORF Sport+)
  final List<ShortcutPage> _orfSportPlusShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Seite 100'),
    const ShortcutPage(pageNumber: 311, title: 'ORF III heute'),
    const ShortcutPage(pageNumber: 327, title: 'ORF III morgen'),
    const ShortcutPage(pageNumber: 350, title: 'ORF III Vorschau'),
    const ShortcutPage(pageNumber: 380, title: 'Kultur + Show'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur + Show Termine'),
    const ShortcutPage(pageNumber: 470, title: 'Nachrichten leicht (B1)'),
    const ShortcutPage(pageNumber: 600, title: 'Wetter'),
    const ShortcutPage(pageNumber: 870, title: 'Ihr ORF'),
    const ShortcutPage(pageNumber: 890, title: 'Index A-Z'),
  ];

  // TVE Teletext (Spagna - RTVE - Televisión pública)
  final List<ShortcutPage> _tveShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 101, title: 'Primera Página'),
    const ShortcutPage(pageNumber: 102, title: 'Nacional'),
    const ShortcutPage(pageNumber: 120, title: 'Internacional'),
    const ShortcutPage(pageNumber: 135, title: 'Noticias Deportes'),
    const ShortcutPage(pageNumber: 200, title: 'Deportes Indice'),
    const ShortcutPage(pageNumber: 201, title: 'Fútbol'),
    const ShortcutPage(pageNumber: 210, title: 'Quiniela'),
    const ShortcutPage(pageNumber: 220, title: 'Baloncesto'),
    const ShortcutPage(pageNumber: 230, title: 'Motor'),
    const ShortcutPage(pageNumber: 300, title: 'Servicios Indice'),
    const ShortcutPage(pageNumber: 301, title: 'Servicios El Tiempo'),
    const ShortcutPage(pageNumber: 400, title: 'Programas TVE'),
    const ShortcutPage(pageNumber: 460, title: 'Sorteos'),
    const ShortcutPage(pageNumber: 600, title: 'Tráfico'),
    const ShortcutPage(pageNumber: 800, title: 'Gaceta Sordo'),
  ];

  // Antena 3 Teletext (Spagna - Atresmedia)
  final List<ShortcutPage> _antena3Shortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 101, title: 'Noticias'),
    const ShortcutPage(pageNumber: 102, title: 'España'),
    const ShortcutPage(pageNumber: 120, title: 'Economía'),
    const ShortcutPage(pageNumber: 130, title: 'Deportes'),
    const ShortcutPage(pageNumber: 140, title: 'Otros Deportes'),
    const ShortcutPage(pageNumber: 150, title: 'Sociedad'),
    const ShortcutPage(pageNumber: 160, title: 'Cultura'),
    const ShortcutPage(pageNumber: 200, title: 'Marcador Fútbol'),
    const ShortcutPage(pageNumber: 301, title: 'Loterías'),
    const ShortcutPage(pageNumber: 330, title: 'El Tiempo'),
    const ShortcutPage(pageNumber: 350, title: 'La Bolsa'),
    const ShortcutPage(pageNumber: 800, title: 'Programación'),
  ];

  // La Sexta Teletext (Spagna - Atresmedia)
  final List<ShortcutPage> _lasextaShortcuts = [
     const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 101, title: 'Noticias'),
    const ShortcutPage(pageNumber: 102, title: 'España'),
    const ShortcutPage(pageNumber: 120, title: 'Economía'),
    const ShortcutPage(pageNumber: 130, title: 'Deportes'),
    const ShortcutPage(pageNumber: 140, title: 'Otros Deportes'),
    const ShortcutPage(pageNumber: 150, title: 'Sociedad'),
    const ShortcutPage(pageNumber: 160, title: 'Cultura'),
    const ShortcutPage(pageNumber: 200, title: 'Marcador Fútbol'),
    const ShortcutPage(pageNumber: 301, title: 'Loterías'),
    const ShortcutPage(pageNumber: 330, title: 'El Tiempo'),
    const ShortcutPage(pageNumber: 350, title: 'La Bolsa'),
    const ShortcutPage(pageNumber: 800, title: 'Programación'),
  ];

  // Portuguese Teletext (Portogallo - RTP)
  final List<ShortcutPage> _portugueseShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Índice'),
    const ShortcutPage(pageNumber: 120, title: 'Notícias'),
    const ShortcutPage(pageNumber: 121, title: 'Economia'),
    const ShortcutPage(pageNumber: 240, title: 'Bolsa'),
    const ShortcutPage(pageNumber: 300, title: 'Televisão'),
    const ShortcutPage(pageNumber: 400, title: 'Desporto'),
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
    const ShortcutPage(pageNumber: 100, title: 'Etusivu'),
    const ShortcutPage(pageNumber: 101, title: 'Uutiset'),
    const ShortcutPage(pageNumber: 160, title: 'Talous'),
    const ShortcutPage(pageNumber: 190, title: 'English'),
    const ShortcutPage(pageNumber: 201, title: 'Urheilu'),
    const ShortcutPage(pageNumber: 300, title: 'TV-Ohjelmat'),
    const ShortcutPage(pageNumber: 400, title: 'Sää'),
    const ShortcutPage(pageNumber: 500, title: 'Alueet'),
    const ShortcutPage(pageNumber: 575, title: 'Teksti-TV'),
    const ShortcutPage(pageNumber: 600, title: 'Urheilun suurtapahtumat'),
    const ShortcutPage(pageNumber: 670, title: 'Eurojalkapallo'),
    const ShortcutPage(pageNumber: 700, title: 'På svenska'),
    const ShortcutPage(pageNumber: 800, title: 'Viikkomakasiini')
    ];

  // Slovenian Teletext (Slovenia - RTV SLO)
  final List<ShortcutPage> _slovenianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Indeks'),
    const ShortcutPage(pageNumber: 101, title: 'Zadnja novica'),
    const ShortcutPage(pageNumber: 110, title: 'Slovenija'),
    const ShortcutPage(pageNumber: 140, title: 'Svet'),
    const ShortcutPage(pageNumber: 160, title: 'Vreme'),
    const ShortcutPage(pageNumber: 190, title: 'Črna kronika'),
     const ShortcutPage(pageNumber: 200, title: 'Spored'),
    const ShortcutPage(pageNumber: 400, title: 'Kultura'),
    const ShortcutPage(pageNumber: 500, title: 'Šport'),
    const ShortcutPage(pageNumber: 600, title: 'Zabava'),
  ];

  // Hungarian Teletext (Ungheria - MTVA)
  final List<ShortcutPage> _hungarianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Főmenü'),
    const ShortcutPage(pageNumber: 101, title: 'Hírek'),
    const ShortcutPage(pageNumber: 102, title: 'Belfűld'),
    const ShortcutPage(pageNumber: 130, title: 'Külföld'),
    const ShortcutPage(pageNumber: 150, title: 'Gazdaság'),
    const ShortcutPage(pageNumber: 160, title: 'Kultúra'),
    const ShortcutPage(pageNumber: 175, title: 'Időjárás'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'MTVA műsorok'),
    const ShortcutPage(pageNumber: 470, title: 'Műsorinfök'),
    const ShortcutPage(pageNumber: 500, title: 'Gazdaság'),
    const ShortcutPage(pageNumber: 530, title: 'Tozsde'),
    const ShortcutPage(pageNumber: 700, title: 'Naptar'),
    const ShortcutPage(pageNumber: 850, title: 'Segitö Oldalak'),
    const ShortcutPage(pageNumber: 890, title: 'MTVA műsorok'),
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
    const ShortcutPage(pageNumber: 101, title: 'Index'),
    const ShortcutPage(pageNumber: 102, title: 'Inhalt'),
    const ShortcutPage(pageNumber: 110, title: 'News'),
    const ShortcutPage(pageNumber: 180, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV-Programm'),
    const ShortcutPage(pageNumber: 400, title: 'Ratgeber'),
    const ShortcutPage(pageNumber: 500, title: 'Reisen'),
  ];

  // NDR Text (Norddeutscher Rundfunk)
  final List<ShortcutPage> _ndrShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Start Seite'),
    const ShortcutPage(pageNumber: 101, title: 'Inhalt (A-Z)'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 120, title: 'Niedersachsen/Bremen'),
    const ShortcutPage(pageNumber: 140, title: 'Schleswig-Holstein'),
    const ShortcutPage(pageNumber: 160, title: 'Mecklenburg-Vorpommern'),
    const ShortcutPage(pageNumber: 170, title: 'Hamburg'),
    const ShortcutPage(pageNumber: 180, title: 'Inland/Ausland'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehprogramm'),
    const ShortcutPage(pageNumber: 400, title: 'Radio'),
    const ShortcutPage(pageNumber: 500, title: 'Mein NDR'),
    const ShortcutPage(pageNumber: 600, title: 'Service'),
    const ShortcutPage(pageNumber: 650, title: 'Wetter'),
    const ShortcutPage(pageNumber: 700, title: 'Verkehr'),
  ];

  // SWR Text Baden-Württemberg (Südwestrundfunk)
  final List<ShortcutPage> _swrbwShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Startseite'),
    const ShortcutPage(pageNumber: 102, title: 'Index A-Z'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 151, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Reise+Verkehr'),
    const ShortcutPage(pageNumber: 700, title: 'Service'),
  ];

  // SWR Text Rheinland-Pfalz (Südwestrundfunk)
  final List<ShortcutPage> _swrrpShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Startseite'),
    const ShortcutPage(pageNumber: 102, title: 'Index A-Z'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 151, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Reise+Verkehr'),
    const ShortcutPage(pageNumber: 700, title: 'Service'),
  ];

  // HR Text (Hessischer Rundfunk)
  final List<ShortcutPage> _hrShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 102, title: 'Inhalt A-Z'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter Hessen'),
    const ShortcutPage(pageNumber: 200, title: 'Sportmeldungen'),
    const ShortcutPage(pageNumber: 300, title: 'hr-fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Börse'),
    const ShortcutPage(pageNumber: 570, title: 'Verkehrsinfos'),
    const ShortcutPage(pageNumber: 620, title: 'Notrufnummern'),
  ];

  // SR Text (Saarländischer Rundfunk)
  final List<ShortcutPage> _srShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 110, title: 'Regionalnachrichten'),
    const ShortcutPage(pageNumber: 160, title: 'Wetterübersicht'),
    const ShortcutPage(pageNumber: 200, title: 'Sportübersicht'),
    const ShortcutPage(pageNumber: 300, title: 'SR Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Hörfunkübersicht'),
    const ShortcutPage(pageNumber: 500, title: 'Service'),
    const ShortcutPage(pageNumber: 540, title: 'Verkehrsübersicht'),
  ];

  // RBB Text (Rundfunk Berlin-Brandenburg)
  final List<ShortcutPage> _rbbShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport I'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 480, title: 'Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Sport II'),
    const ShortcutPage(pageNumber: 600, title: 'Sport III'),
  ];

  // KiKA Text (Kinderkanal von ARD und ZDF)
  final List<ShortcutPage> _kikaShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Inhalt'),
    const ShortcutPage(pageNumber: 112, title: 'Mitmach-Aktionen'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 331, title: 'logo!'),
    const ShortcutPage(pageNumber: 400, title: 'KIKANINCHEN'),
    const ShortcutPage(pageNumber: 700, title: 'KiKA LIVE'),
    const ShortcutPage(pageNumber: 780, title: 'Kinderrechte'),
  ];

  // ARTE Text
  final List<ShortcutPage> _arteShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Inhaltsverzeichnis'),
    const ShortcutPage(pageNumber: 105, title: 'Aus aller Welt'),
    const ShortcutPage(pageNumber: 116, title: 'Kultur'),
    const ShortcutPage(pageNumber: 200, title: 'TV-Service'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 380, title: 'Programm-Highlights'),
  ];

  // ARD alpha Text
  final List<ShortcutPage> _ardAlphaShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport I'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur'),
    const ShortcutPage(pageNumber: 480, title: 'Hörfunk'),
    const ShortcutPage(pageNumber: 500, title: 'Sport II'),
    const ShortcutPage(pageNumber: 600, title: 'Sport III'),
    const ShortcutPage(pageNumber: 720, title: 'Börse'),
  ];

  // Phoenix Text
  final List<ShortcutPage> _phoenixShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Inhalt'),
    const ShortcutPage(pageNumber: 110, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 116, title: 'Politik'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 202, title: 'Börse'),
    const ShortcutPage(pageNumber: 300, title: 'Fernsehen'),
    const ShortcutPage(pageNumber: 600, title: 'Programmbegleitung'),
  ];

  // n-tv Text
  final List<ShortcutPage> _ntvShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten Übersicht'),
    const ShortcutPage(pageNumber: 140, title: 'Wetter'),
    const ShortcutPage(pageNumber: 185, title: 'Sport / Fußball'),
    const ShortcutPage(pageNumber: 200, title: 'Börse Deutsche Börsen'),
    const ShortcutPage(pageNumber: 300, title: 'Auslands-Börsen'),
    const ShortcutPage(pageNumber: 500, title: 'Programm n-tv'),
  ];

  // VOX Text
  final List<ShortcutPage> _voxShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht'),
    const ShortcutPage(pageNumber: 110, title: 'Aktuelles/News'),
    const ShortcutPage(pageNumber: 150, title: 'Prominent/Stars'),
    const ShortcutPage(pageNumber: 180, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm'),
    const ShortcutPage(pageNumber: 400, title: 'Ratgeber'),
  ];

  // Omroep Zeeland Teletekst (Olanda)
  final List<ShortcutPage> _omroepZeelandShortcuts = [
    const ShortcutPage(pageNumber: 101, title: 'Zeeland Nu'),
    const ShortcutPage(pageNumber: 200, title: 'Televisie'),
    const ShortcutPage(pageNumber: 250, title: 'Radio'),
    const ShortcutPage(pageNumber: 400, title: 'Weer'),
    const ShortcutPage(pageNumber: 500, title: 'Adverteren'),
    const ShortcutPage(pageNumber: 600, title: 'Sport'),
  ];

  // Polsat Teletekst (Polonia)
  final List<ShortcutPage> _polsatShortcuts = [
    const ShortcutPage(pageNumber: 109, title: 'Aktualności'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Program telewizyjny'),
    const ShortcutPage(pageNumber: 350, title: 'Cyfrowy Polsat'),
    const ShortcutPage(pageNumber: 500, title: 'Ogłoszenia'),
    const ShortcutPage(pageNumber: 715, title: 'Rozrywka'),
  ];
  
  // Croatian Teletext (Croazia - HRT)
  final List<ShortcutPage> _croatianShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Sadržaj'),

    const ShortcutPage(pageNumber: 110, title: 'Hrvatska'),
    const ShortcutPage(pageNumber: 150, title: 'Svijet'),
    const ShortcutPage(pageNumber: 180, title: 'Europska Unija'),
    const ShortcutPage(pageNumber: 200, title: 'Gospodarstvo'),
     const ShortcutPage(pageNumber: 250, title: 'Kultura'),   
    const ShortcutPage(pageNumber: 300, title: 'Program HTV-a'),
    const ShortcutPage(pageNumber: 450, title: 'Vrijeme'),
    const ShortcutPage(pageNumber: 500, title: 'Sport'),
  ];
  
  // Czech Teletext (Repubblica Ceca - ČT)
  final List<ShortcutPage> _czechShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Obsah'),
    const ShortcutPage(pageNumber: 101, title: 'Zprávy DNE'),
    const ShortcutPage(pageNumber: 110, title: 'Zprávy domova'),
    const ShortcutPage(pageNumber: 130, title: 'Zprávy světa'),
    const ShortcutPage(pageNumber: 170, title: 'Počasí'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programy ČT'),
    const ShortcutPage(pageNumber: 500, title: 'Finance'),
    const ShortcutPage(pageNumber: 600, title: 'Zájmy'),
    const ShortcutPage(pageNumber: 850, title: 'Stránky ČT'),
    const ShortcutPage(pageNumber: 890, title: 'Obsah'),

  ];
  
  // Danish Teletext (Danimarca - DR)
  final List<ShortcutPage> _danishShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Forside'),
    const ShortcutPage(pageNumber: 106, title: 'Indhold'),
    const ShortcutPage(pageNumber: 110, title: 'Nyheder'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV'),
    const ShortcutPage(pageNumber: 600, title: 'Radio'),
  ];
  
  // BHRT Teletext (Bosnia ed Erzegovina - BHRT)
  final List<ShortcutPage> _bhrtShortcuts = [
    const ShortcutPage(pageNumber: 102, title: 'Sadržaj'),
    const ShortcutPage(pageNumber: 109, title: 'Vijesti'),
    const ShortcutPage(pageNumber: 160, title: 'Kultura'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV program'),
    const ShortcutPage(pageNumber: 400, title: 'Vremenska Prognoza'),
  ];

  // RTVFBiH Teletext (Bosnia ed Erzegovina - Federalna TV)
  final List<ShortcutPage> _rtvfbihShortcuts = [
    const ShortcutPage(pageNumber: 102, title: 'Sadržaj'),
    const ShortcutPage(pageNumber: 109, title: 'Vijesti'),
     const ShortcutPage(pageNumber: 160, title: 'Kultura'),
     const ShortcutPage(pageNumber: 190, title: 'Religija'),
         const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'TV program'),
    const ShortcutPage(pageNumber: 400, title: 'Vrijeme'), 
    const ShortcutPage(pageNumber: 406, title: 'Putevi'), 
    const ShortcutPage(pageNumber: 493, title: 'Vadostaj'), 
    const ShortcutPage(pageNumber: 499, title: 'Kursna Lista'), 
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
    
    // BR Text (Bayern - Bayerischer Rundfunk)
    if (channelId == 'br_text') {
      return _brShortcuts;
    }
    
    // WDR Text (NRW - Westdeutscher Rundfunk)
    if (channelId == 'wdr_text') {
      return _wdrShortcuts;
    }
    
    // ZDF Text (Germania - Hauptprogramm)
    if (channelId == 'zdf_text') {
      return _zdfShortcuts;
    }
    
    // ZDFinfo Text (Germania - Documentari)
    if (channelId == 'zdfinfo_text') {
      return _zdfinfoShortcuts;
    }
    
    // ZDFneo Text (Germania - Entertainment)
    if (channelId == 'zdfneo_text') {
      return _zdfneoShortcuts;
    }
    
    // 3sat Text (Germania/Austria/Svizzera - Cultura)
    if (channelId == '3sat_text') {
      return _dreisatShortcuts;
    }
    
    // RSI Teletext (Svizzera italiana)
    if (channelId.startsWith('rsi_')) {
      return _rsiShortcuts;
    }
    
    // RTS Teletext (Svizzera francese)
    if (channelId.startsWith('rts_')) {
      return _rtsShortcuts;
    }
    
    // SRF Teletext (Svizzera tedesca)
    if (channelId.startsWith('srf_')) {
      return _srfShortcuts;
    }
    
    // ORF1 Teletext (Austria)
    if (channelId == 'orf1') {
      return _orf1Shortcuts;
    }
    
    // ORF2 Teletext (Austria)
    if (channelId == 'orf2') {
      return _orf2Shortcuts;
    }
    
    // ORF III Teletext (Austria)
    if (channelId == 'orf3') {
      return _orf3Shortcuts;
    }
    
    // ORF Sport+ Teletext (Austria)
    if (channelId == 'orf_sport_plus') {
      return _orfSportPlusShortcuts;
    }
    
    // TVE Teletext (Spagna - RTVE)
    if (channelId == 'tve') {
      return _tveShortcuts;
    }
    
    // Antena 3 Teletext (Spagna - Atresmedia)
    if (channelId == 'antena3') {
      return _antena3Shortcuts;
    }
    
    // La Sexta Teletext (Spagna - Atresmedia)
    if (channelId == 'lasexta') {
      return _lasextaShortcuts;
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

    // NDR Text
    if (channelId == 'ndr_text') {
      return _ndrShortcuts;
    }

    // SWR Text Baden-Württemberg
    if (channelId == 'swr_bw') {
      return _swrbwShortcuts;
    }

    // SWR Text Rheinland-Pfalz
    if (channelId == 'swr_rp') {
      return _swrrpShortcuts;
    }

    // HR Text
    if (channelId == 'hr_text') {
      return _hrShortcuts;
    }

    // SR Text
    if (channelId == 'sr_text') {
      return _srShortcuts;
    }

    // RBB Text
    if (channelId == 'rbb_text') {
      return _rbbShortcuts;
    }

    // KiKA Text
    if (channelId == 'kika_text') {
      return _kikaShortcuts;
    }

    // ARTE Text
    if (channelId == 'arte_text') {
      return _arteShortcuts;
    }

    // ARD alpha Text
    if (channelId == 'ard_alpha_text') {
      return _ardAlphaShortcuts;
    }

    // Phoenix Text
    if (channelId == 'phoenix_text') {
      return _phoenixShortcuts;
    }

    // n-tv Text
    if (channelId == 'ntv_text') {
      return _ntvShortcuts;
    }

    // VOX Text
    if (channelId == 'vox_text') {
      return _voxShortcuts;
    }

    // Omroep Zeeland Teletekst
    if (channelId == 'omroepzeeland_teletekst') {
      return _omroepZeelandShortcuts;
    }

    // Polsat Teletekst
    if (channelId == 'polsat_telegazeta') {
      return _polsatShortcuts;
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
    
    // BHRT Teletext (Bosnia ed Erzegovina)
    if (channelId == 'bhrt') {
      return _bhrtShortcuts;
    }
    
    // RTVFBiH Teletext (Bosnia ed Erzegovina - Federalna TV)
    if (channelId == 'rtvfbih') {
      return _rtvfbihShortcuts;
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