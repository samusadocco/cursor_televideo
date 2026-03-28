import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// Servizio per gestire l'App Tracking Transparency (ATT) su iOS.
/// Quando l'utente seleziona "Ask App Not to Track", non dobbiamo raccogliere
/// dati per il tracking (Guideline 5.1.1(iv)).
class TrackingService {
  static TrackingStatus _lastStatus = TrackingStatus.notDetermined;
  
  /// Stato ATT dopo la richiesta. Usare per configurare ads, analytics, WebView.
  static TrackingStatus get trackingStatus => _lastStatus;
  
  /// True se l'utente ha negato il tracking ("Ask App Not to Track")
  static bool get isTrackingDenied => _lastStatus == TrackingStatus.denied;
  
  static Future<void> requestTrackingAuthorization() async {
    if (!Platform.isIOS) return;

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      _lastStatus = status;
      
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
        _lastStatus = newStatus;
        print('[TrackingService] ATT result: $newStatus');
      }
    } catch (e) {
      print('Errore durante la richiesta di autorizzazione al tracciamento: $e');
    }
  }
}
