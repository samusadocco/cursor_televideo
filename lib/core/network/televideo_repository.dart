import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:cursor_televideo/core/settings/app_settings.dart';

class TelevideoRepository {
  final Dio _dio;
  final String _baseUrl = 'https://www.televideo.rai.it/televideo/pub/tt4web';
  final String _htmlBaseUrl = 'https://www.televideo.rai.it/televideo/pub/pagina.jsp';
  final String _htmlRegionalBaseUrl = 'https://www.televideo.rai.it/televideo/pub/homeregione.jsp';
  final String _corsProxy = 'https://corsproxy.io/?';
  TelevideoRepository({Dio? dio}) : _dio = dio ?? Dio() {
    // Configura Dio per utilizzare la durata della cache dalle impostazioni
    _dio.options.headers = {
      'Cache-Control': 'max-age=${AppSettings.cacheDurationInSeconds}',
    };

    // Aggiungi interceptor per loggare le richieste dalla cache
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        final fromCache = response.headers['x-cache']?.contains('HIT') ?? false;
        print('\n=== CACHE INFO ===');
        print('URL: ${response.requestOptions.uri}');
        print('Cache Headers:');
        response.headers.forEach((name, values) {
          if (name.toLowerCase().contains('cache') || 
              name.toLowerCase() == 'age' || 
              name.toLowerCase() == 'expires' ||
              name.toLowerCase() == 'etag') {
            print('  $name: $values');
          }
        });
        print('Caricato da: ${fromCache ? "CACHE" : "RETE"}');
        print('================\n');
        handler.next(response);
      },
    ));
  }

  /// Verifica se la pagina 100 è disponibile
  Future<bool> isPage100Available() async {
    try {
      final url = 'https://www.servizitelevideo.rai.it/televideo/pub/tt4web/Nazionale/16_9_page-100.png';
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Estrae le aree cliccabili dalla pagina HTML
  Future<List<ClickableArea>> _extractClickableAreas(String html) async {
    print('\n=== ESTRAZIONE AREE CLICCABILI ===');
    final document = html_parser.parse(html);
    final areas = <ClickableArea>[];
    
    // Cerca la mappa con name="map1"
    final map = document.querySelector('map[name="map1"]');
    if (map == null) {
      print('❌ Mappa con name="map1" non trovata nell\'HTML');
      return areas;
    }
    
    print('✅ Mappa map1 trovata');
    
    // Cerca tutti gli elementi <area> nella mappa specifica
    final areaElements = map.getElementsByTagName('area');
    print('Trovate ${areaElements.length} aree nella mappa\n');
    
    for (final area in areaElements) {
      print('Analisi area:');
      final href = area.attributes['href'];
      final coords = area.attributes['coords'];
      print('  href: $href');
      print('  coords (raw): $coords');
      
      if (href == null) {
        print('  ❌ Area ignorata: href mancante\n');
        continue;
      }
      
      // Estrai il numero della pagina dall'href
      final pageMatch = RegExp(r'p=(\d+)').firstMatch(href);
      if (pageMatch == null) {
        print('  ❌ Area ignorata: numero pagina non trovato nell\'href\n');
        continue;
      }
      
      // Estrai le coordinate dall'attributo coords
      var coordsList = coords?.split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      print('  Coordinate dopo pulizia: $coordsList');
      
      // Ci aspettiamo sempre 4 coordinate: x1,y1,x2,y2
      if (coordsList == null || coordsList.length != 4) {
        print('  ❌ Area ignorata: formato coordinate non valido (attesi 4 numeri per il rettangolo, trovati: ${coordsList?.length})\n');
        continue;
      }
      
      try {
        final targetPage = int.parse(pageMatch.group(1)!);
        final x1 = int.parse(coordsList[0]);
        final y1 = int.parse(coordsList[1]);
        final x2 = int.parse(coordsList[2]);
        final y2 = int.parse(coordsList[3]);
        
        // Assicuriamoci che x1,y1 sia l'angolo in alto a sinistra e x2,y2 quello in basso a destra
        final left = min(x1, x2);
        final top = min(y1, y2);
        final right = max(x1, x2);
        final bottom = max(y1, y2);
        
        print('  ✅ Area rettangolare valida:');
        print('    Pagina destinazione: $targetPage');
        print('    Punto 1: ($x1, $y1)');
        print('    Punto 2: ($x2, $y2)');
        print('    Rettangolo normalizzato: ($left, $top) -> ($right, $bottom)');
        print('    Dimensioni: ${right - left} x ${bottom - top}\n');
        
        areas.add(ClickableArea(
          targetPage: targetPage,
          x: left,
          y: top,
          width: right - left,
          height: bottom - top,
        ));
      } catch (e) {
        print('  ❌ Area ignorata: errore parsing numeri: $e\n');
        continue;
      }
    }
    
    print('Totale aree cliccabili estratte: ${areas.length}');
    print('=== FINE ESTRAZIONE ===\n');
    return areas;
  }

  /// Estrae il numero massimo di sottopagine dalla pagina HTML
  int _extractMaxSubPages(String html) {
    print('\n=== ESTRAZIONE NUMERO SOTTOPAGINE ===');
    final document = html_parser.parse(html);
    
    try {
      // Cerca il testo tra "<span> / " e "</span>"
      final spans = document.getElementsByTagName('span');
      for (final span in spans) {
        final text = span.text.trim();
        if (text.startsWith('/')) {
          final subPageText = text.substring(1).trim();
          final maxSubPages = int.tryParse(subPageText);
          if (maxSubPages != null && maxSubPages > 0) {
            print('Numero massimo di sottopagine trovato: $maxSubPages');
            print('=== FINE ESTRAZIONE SOTTOPAGINE ===\n');
            return maxSubPages;
          }
        }
      }
    } catch (e) {
      print('Errore durante l\'estrazione del numero di sottopagine: $e');
    }
    
    print('Nessun numero di sottopagine trovato, uso valore di default: 1');
    print('=== FINE ESTRAZIONE SOTTOPAGINE ===\n');
    return 1;
  }

  /// Costruisce l'URL dell'immagine includendo il numero di sottopagina se necessario
  String _buildImageUrl(String baseUrl, String path, int pageNumber, {int subPage = 1}) {
    assert(subPage > 0, 'Il numero di sottopagina deve essere maggiore di 0');
    final pageNumberStr = pageNumber.toString().padLeft(3, '0');
    final imagePath = subPage > 1
        ? '16_9_page-$pageNumberStr.$subPage.png'
        : '16_9_page-$pageNumberStr.png';
    return '$baseUrl/$path/$imagePath';
  }

  Future<TelevideoPage> getNationalPage(int pageNumber, {int subPage = 1, bool forceRefresh = false}) async {
    if (forceRefresh) {
      _dio.options.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
      _dio.options.headers['Pragma'] = 'no-cache';
      _dio.options.headers['Expires'] = '0';
    } else {
      _dio.options.headers['Cache-Control'] = 'max-age=${AppSettings.cacheDurationInSeconds}';
      _dio.options.headers.remove('Pragma');
      _dio.options.headers.remove('Expires');
    }
    try {
      if (subPage < 1) {
        throw ArgumentError('Il numero di sottopagina deve essere maggiore di 0');
      }

      final rawImageUrl = _buildImageUrl(_baseUrl, 'Nazionale', pageNumber, subPage: subPage);
      final imageUrl = kIsWeb ? '$_corsProxy$rawImageUrl' : rawImageUrl;
      final baseHtmlUrl = '$_htmlBaseUrl?p=$pageNumber';
      final htmlUrl = subPage > 1 ? '$baseHtmlUrl&s=$subPage&r=Nazionale' : baseHtmlUrl;
      
      print('\nCaricamento pagina:');
      print('URL HTML: $htmlUrl');
      print('URL Immagine: $imageUrl');
      
      // Prima recuperiamo l'HTML per ottenere il numero massimo di sottopagine
      final htmlResponse = await _dio.get(htmlUrl);
      final maxSubPages = _extractMaxSubPages(htmlResponse.data);
      
      // Verifichiamo che la sottopagina richiesta sia valida
      if (subPage > maxSubPages) {
        throw ArgumentError('Sottopagina $subPage non valida. Massimo disponibile: $maxSubPages');
      }
      
      // Verifichiamo se la pagina esiste
      final response = await _dio.head(imageUrl);
      
      if (response.statusCode == 200) {
        print('HTML response received, length: ${htmlResponse.data.length}');
        
        final document = html_parser.parse(htmlResponse.data);
        print('\nCercando mappa con name="map1" nell\'HTML di: $htmlUrl');
        final map = document.querySelector('map[name="map1"]');
        if (map == null) {
          print('Mappa con name="map1" NON trovata nell\'HTML');
        } else {
          print('Mappa con name="map1" trovata nell\'HTML');
        }
        
        final clickableAreas = await _extractClickableAreas(htmlResponse.data);
        
        return TelevideoPage(
          pageNumber: pageNumber,
          imageUrl: imageUrl,
          clickableAreas: clickableAreas,
          maxSubPages: maxSubPages,
        );
      }
      
      throw 'La pagina richiesta non è disponibile';
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        throw 'La pagina richiesta non è disponibile';
      }
      throw 'Si è verificato un errore durante il caricamento della pagina';
    }
  }

  Future<TelevideoPage> getRegionalPage(String region, {int pageNumber = 300, int subPage = 1, bool forceRefresh = false}) async {
    if (forceRefresh) {
      _dio.options.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
      _dio.options.headers['Pragma'] = 'no-cache';
      _dio.options.headers['Expires'] = '0';
    } else {
      _dio.options.headers['Cache-Control'] = 'max-age=${AppSettings.cacheDurationInSeconds}';
      _dio.options.headers.remove('Pragma');
      _dio.options.headers.remove('Expires');
    }
    try {
      if (subPage < 1) {
        throw ArgumentError('Il numero di sottopagina deve essere maggiore di 0');
      }

      final rawImageUrl = _buildImageUrl(_baseUrl, region, pageNumber, subPage: subPage);
      final imageUrl = kIsWeb ? '$_corsProxy$rawImageUrl' : rawImageUrl;
      final baseHtmlUrl = '$_htmlRegionalBaseUrl?r=$region&p=$pageNumber';
      final htmlUrl = subPage > 1 ? '$baseHtmlUrl&s=$subPage' : baseHtmlUrl;
      
      // Prima recuperiamo l'HTML per ottenere il numero massimo di sottopagine
      final htmlResponse = await _dio.get(htmlUrl);
      final maxSubPages = _extractMaxSubPages(htmlResponse.data);
      
      // Verifichiamo che la sottopagina richiesta sia valida
      if (subPage > maxSubPages) {
        throw ArgumentError('Sottopagina $subPage non valida. Massimo disponibile: $maxSubPages');
      }
      
      // Verifichiamo se la pagina esiste
      final response = await _dio.head(imageUrl);
      
      if (response.statusCode == 200) {
        print('HTML response received, length: ${htmlResponse.data.length}');
        
        final document = html_parser.parse(htmlResponse.data);
        print('\nCercando mappa con name="map1" nell\'HTML di: $htmlUrl');
        final map = document.querySelector('map[name="map1"]');
        if (map == null) {
          print('Mappa con name="map1" NON trovata nell\'HTML');
        } else {
          print('Mappa con name="map1" trovata nell\'HTML');
        }
        
        final clickableAreas = await _extractClickableAreas(htmlResponse.data);
        
        return TelevideoPage(
          pageNumber: pageNumber,
          imageUrl: imageUrl,
          region: region,
          clickableAreas: clickableAreas,
          maxSubPages: maxSubPages,
        );
      }
      
      throw 'La pagina richiesta non è disponibile';
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        throw 'La pagina richiesta non è disponibile';
      }
      throw 'Si è verificato un errore durante il caricamento della pagina';
    }
  }
} 