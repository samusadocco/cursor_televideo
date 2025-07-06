import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class LocationService {
  static Future<Region?> getCurrentRegion() async {
    try {
      // Verifica se la geolocalizzazione è abilitata
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Servizio di geolocalizzazione non abilitato');
        return null;
      }

      // Richiedi i permessi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Permessi di geolocalizzazione negati');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Permessi di geolocalizzazione negati permanentemente');
        return null;
      }

      // Ottieni la posizione corrente
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      print('Posizione rilevata: Lat: ${position.latitude}, Lon: ${position.longitude}');

      // Carica il file GeoJSON delle regioni
      final String geoJson = await rootBundle.loadString('scripts/limits_IT_regions.geojson');
      final Map<String, dynamic> geoData = json.decode(geoJson);

      // Controlla in quale regione si trova il punto
      for (var feature in geoData['features']) {
        final properties = feature['properties'];
        final geometry = feature['geometry'];
        final regionName = properties['reg_name'];
        
        print('Verifico regione: $regionName');
        
        if (isPointInPolygon(position.longitude, position.latitude, geometry)) {
          print('Trovata corrispondenza con la regione: $regionName');
          
          // Converti il nome della regione nel formato corretto
          final foundRegion = Region.values.firstWhere(
            (region) => region.name.toLowerCase() == regionName.toLowerCase(),
            orElse: () {
              print('Nome regione non trovato nel mapping: $regionName');
              return Region.values.first;
            },
          );
          return foundRegion;
        }
      }

      print('Nessuna regione trovata per le coordinate');
      return null;
    } catch (e) {
      print('Errore nel recupero della posizione: $e');
      return null;
    }
  }

  static bool isPointInPolygon(double lon, double lat, Map<String, dynamic> geometry) {
    if (geometry['type'] != 'MultiPolygon' && geometry['type'] != 'Polygon') {
      print('Tipo di geometria non supportato: ${geometry['type']}');
      return false;
    }

    List<List<List<List<double>>>> polygons = [];
    
    if (geometry['type'] == 'Polygon') {
      // Converti un singolo poligono nel formato MultiPolygon per uniformità
      polygons = [
        (geometry['coordinates'] as List).map((ring) {
          return (ring as List).map((point) {
            return (point as List).map((coord) => (coord as num).toDouble()).toList();
          }).toList();
        }).toList()
      ];
    } else { // MultiPolygon
      polygons = (geometry['coordinates'] as List).map((polygon) {
        return (polygon as List).map((ring) {
          return (ring as List).map((point) {
            return (point as List).map((coord) => (coord as num).toDouble()).toList();
          }).toList();
        }).toList();
      }).toList();
    }

    // Controlla ogni poligono
    for (var polygon in polygons) {
      // Prendi il primo anello (il confine esterno)
      var points = polygon[0];
      int intersections = 0;
      
      for (int i = 0, j = points.length - 1; i < points.length; j = i++) {
        var xi = points[i][0], yi = points[i][1];
        var xj = points[j][0], yj = points[j][1];
        
        if (((yi > lat) != (yj > lat)) &&
            (lon < (xj - xi) * (lat - yi) / (yj - yi) + xi)) {
          intersections++;
        }
      }
      
      // Se il numero di intersezioni è dispari, il punto è dentro il poligono
      if (intersections % 2 == 1) {
        print('Punto trovato dentro il poligono');
        return true;
      }
    }
    
    return false;
  }
} 