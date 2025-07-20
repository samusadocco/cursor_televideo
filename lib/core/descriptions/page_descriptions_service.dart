class PageDescriptionsService {
  static final PageDescriptionsService _instance = PageDescriptionsService._internal();
  factory PageDescriptionsService() => _instance;
  PageDescriptionsService._internal();

  // Descrizioni delle pagine nazionali
  final Map<int, String> nationalDescriptions = {
    100: 'Indice Nazionale',
    101: 'Ultim\'ora',
    102: '24 ore non stop',
    103: 'Prima pagina',
    104: 'Oggi',
    120: 'Politica',
    140: 'Dall\' Italia',
    150: 'Dal mondo',
    160: 'Culture',
    190: 'Motori',
    200: 'Sport',
    201: 'Calcio',
    202: 'Serie A:Risultati',
    203: 'Serie A:Classifica',
    204: 'Serie A:Prossimo Turno',
    205: 'Serie A:Marcatori',
    206: 'Serie A:Diretta',
    207: 'Serie A: Best 11',
    208: 'Serie A: Giudice Sportivo',
    209: 'Serie B',
    235: 'Calcio Fiorentina',
    229: 'Brevi Calcio',
  };

  // Descrizioni delle pagine regionali
  final Map<int, String> regionalDescriptions = {
    300: 'Indice Regione',
    301: 'Sport Regione',
    302: 'Calcio',
    307: 'Basket',
    412: 'La regione del gusto',
  };

  // Ottiene la descrizione di una pagina
  String getDescription(int pageNumber, {bool isRegional = false}) {
    final descriptions = isRegional ? regionalDescriptions : nationalDescriptions;
    return descriptions[pageNumber] ?? 'Pagina $pageNumber';
  }
} 