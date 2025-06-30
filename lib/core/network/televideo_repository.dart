import 'package:dio/dio.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:flutter/foundation.dart';

class TelevideoRepository {
  final Dio _dio;
  final String _baseUrl = 'https://www.televideo.rai.it/televideo/pub/tt4web';
  final String _corsProxy = 'https://corsproxy.io/?';

  TelevideoRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<TelevideoPage> getNationalPage(int pageNumber) async {
    try {
      final rawImageUrl = '$_baseUrl/Nazionale/16_9_page-${pageNumber.toString().padLeft(3, '0')}.png';
      final imageUrl = kIsWeb ? '$_corsProxy$rawImageUrl' : rawImageUrl;
      
      // Verifichiamo se la pagina esiste
      final response = await _dio.head(imageUrl);
      
      if (response.statusCode == 200) {
        return TelevideoPage(
          pageNumber: pageNumber,
          imageUrl: imageUrl,
        );
      }
      
      throw Exception('Pagina $pageNumber non trovata');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        throw Exception('Pagina $pageNumber non trovata');
      }
      throw Exception('Errore nel caricamento della pagina $pageNumber: ${e.toString()}');
    }
  }

  Future<TelevideoPage> getRegionalPage(String region, {int pageNumber = 300}) async {
    try {
      final rawImageUrl = '$_baseUrl/$region/16_9_page-${pageNumber.toString().padLeft(3, '0')}.png';
      final imageUrl = kIsWeb ? '$_corsProxy$rawImageUrl' : rawImageUrl;
      
      // Verifichiamo se la pagina esiste
      final response = await _dio.head(imageUrl);
      
      if (response.statusCode == 200) {
        return TelevideoPage(
          pageNumber: pageNumber,
          imageUrl: imageUrl,
          region: region,
        );
      }
      
      // Se la pagina non esiste, prova con la pagina 300
      if (pageNumber != 300) {
        return getRegionalPage(region);
      }
      
      throw Exception('Pagina regionale non trovata per $region');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        if (pageNumber != 300) {
          return getRegionalPage(region);
        }
        throw Exception('Pagina regionale non trovata per $region');
      }
      throw Exception('Errore nel caricamento della pagina regionale per $region: ${e.toString()}');
    }
  }
} 