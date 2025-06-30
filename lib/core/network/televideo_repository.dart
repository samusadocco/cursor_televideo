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
      throw Exception('Errore nel caricamento della pagina $pageNumber: ${e.toString()}');
    }
  }

  Future<TelevideoPage> getRegionalPage(String region) async {
    try {
      final rawImageUrl = '$_baseUrl/$region/16_9_page-300.png';
      final imageUrl = kIsWeb ? '$_corsProxy$rawImageUrl' : rawImageUrl;
      
      // Verifichiamo se la pagina esiste
      final response = await _dio.head(imageUrl);
      
      if (response.statusCode == 200) {
        return TelevideoPage(
          pageNumber: 300,
          imageUrl: imageUrl,
          region: region,
        );
      }
      
      throw Exception('Pagina regionale non trovata per $region');
    } catch (e) {
      throw Exception('Errore nel caricamento della pagina regionale per $region: ${e.toString()}');
    }
  }
} 