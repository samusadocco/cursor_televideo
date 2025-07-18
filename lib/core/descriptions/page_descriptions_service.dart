class PageDescriptionsService {
  static final PageDescriptionsService _instance = PageDescriptionsService._internal();
  factory PageDescriptionsService() => _instance;
  PageDescriptionsService._internal();

  // Descrizioni delle pagine nazionali
  final Map<int, String> nationalDescriptions = {
    100: 'Indice Nazionale',
    101: 'Ultim\'ora',
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