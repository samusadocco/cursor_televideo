import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class TrackingService {
  static Future<void> requestTrackingAuthorization() async {
    if (!Platform.isIOS) return;

    try {
      // Ottieni lo stato attuale
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      
      // Se non è stato ancora richiesto il permesso
      if (status == TrackingStatus.notDetermined) {
        // Aspetta che l'app sia completamente avviata
        await Future.delayed(const Duration(milliseconds: 200));
        // Richiedi l'autorizzazione usando il framework di Apple
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      print('Errore durante la richiesta di autorizzazione al tracciamento: $e');
    }
  }
}
