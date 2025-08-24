class Region {
  final String name;
  final String code;
  final String imagePath;

  const Region({
    required this.name,
    required this.code,
    required this.imagePath,
  });

  static Region fromCode(String code) {
    return values.firstWhere(
      (region) => region.code == code,
      orElse: () => throw Exception('Regione non trovata per il codice: $code'),
    );
  }

  static const List<Region> values = [
    Region(
      name: 'Abruzzo',
      code: 'Abruzzo',
      imagePath: 'assets/images/regions/abruzzo.png',
    ),
    Region(
      name: 'Basilicata',
      code: 'Basilicata',
      imagePath: 'assets/images/regions/basilicata.png',
    ),
    Region(
      name: 'Calabria',
      code: 'Calabria',
      imagePath: 'assets/images/regions/calabria.png',
    ),
    Region(
      name: 'Campania',
      code: 'Campania',
      imagePath: 'assets/images/regions/campania.png',
    ),
    Region(
      name: 'Emilia Romagna',
      code: 'Emilia',
      imagePath: 'assets/images/regions/emilia_romagna.png',
    ),
    Region(
      name: 'Friuli Venezia Giulia',
      code: 'Friuli',
      imagePath: 'assets/images/regions/friuli_venezia_giulia.png',
    ),
    Region(
      name: 'Lazio',
      code: 'Lazio',
      imagePath: 'assets/images/regions/lazio.png',
    ),
    Region(
      name: 'Liguria',
      code: 'Liguria',
      imagePath: 'assets/images/regions/liguria.png',
    ),
    Region(
      name: 'Lombardia',
      code: 'Lombardia',
      imagePath: 'assets/images/regions/lombardia.png',
    ),
    Region(
      name: 'Marche',
      code: 'Marche',
      imagePath: 'assets/images/regions/marche.png',
    ),
    Region(
      name: 'Molise',
      code: 'Molise',
      imagePath: 'assets/images/regions/molise.png',
    ),
    Region(
      name: 'Piemonte',
      code: 'Piemonte',
      imagePath: 'assets/images/regions/piemonte.png',
    ),
    Region(
      name: 'Puglia',
      code: 'Puglia',
      imagePath: 'assets/images/regions/puglia.png',
    ),
    Region(
      name: 'Sardegna',
      code: 'Sardegna',
      imagePath: 'assets/images/regions/sardegna.png',
    ),
    Region(
      name: 'Sicilia',
      code: 'Sicilia',
      imagePath: 'assets/images/regions/sicilia.png',
    ),
    Region(
      name: 'Toscana',
      code: 'Toscana',
      imagePath: 'assets/images/regions/toscana.png',
    ),
    Region(
      name: 'Trentino Alto Adige',
      code: 'Trentino',
      imagePath: 'assets/images/regions/trentino_alto_adige.png',
    ),
    Region(
      name: 'Umbria',
      code: 'Umbria',
      imagePath: 'assets/images/regions/umbria.png',
    ),
    Region(
      name: "Valle d'Aosta",
      code: 'Aosta',
      imagePath: 'assets/images/regions/valle_d_aosta.png',
    ),
    Region(
      name: 'Veneto',
      code: 'Veneto',
      imagePath: 'assets/images/regions/veneto.png',
    ),
  ];
} 