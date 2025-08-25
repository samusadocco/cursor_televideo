import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';

class InitializationHelper {
  Future<FormError?> initialize() async {
    final completer = Completer<FormError?>();

    // Inizializza prima AdService
    await AdService().initialize();

    // Richiedi il consenso solo se necessario
    final params = ConsentRequestParameters(
      tagForUnderAgeOfConsent: false,
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: ["A83F6F22-7D2B-4AC6-8E9C-F739A979B058"],
      ),
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        final status = await ConsentInformation.instance.getConsentStatus();
        print('Stato consenso privacy: $status');
        
        final isConsentFormAvailable = await ConsentInformation.instance.isConsentFormAvailable();
        print('Form consenso disponibile: $isConsentFormAvailable');
        
        // Richiedi il consenso solo se è richiesto (primo avvio o reset)
        if (status == ConsentStatus.required) {
          print('Richiesta consenso privacy necessaria. Motivo: ${status == ConsentStatus.required ? 'Consenso richiesto' : 'Form consenso disponibile'}');
          await _loadConsentForm();
          
          // Verifica lo stato dopo aver mostrato il form
          final newStatus = await ConsentInformation.instance.getConsentStatus();
          print('Nuovo stato consenso privacy dopo form: $newStatus');
        } else {
          print('Consenso privacy già valido, non è necessario richiederlo');
        }
        
        await _initialize();
        completer.complete(null);
      },
      (FormError error) {
        print('Error updating consent info: ${error.message}');
        completer.complete(error);
      },
    );

    return completer.future;
  }

  Future<FormError?> _loadConsentForm() async {
    final completer = Completer<FormError?>();

    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        consentForm.show(
          (FormError? formError) async {
            if (formError != null) {
              print('Error showing consent form: ${formError.message}');
              completer.complete(formError);
            } else {
              final status = await ConsentInformation.instance.getConsentStatus();
              print('Consent status after showing form: $status');
              completer.complete(null);
            }
          },
        );
      },
      (FormError formError) {
        print('Error loading consent form: ${formError.message}');
        completer.complete(formError);
      },
    );

    return completer.future;
  }
}

Future<void> _initialize() async {
  // Inizializza AdMob
  await MobileAds.instance.initialize();

  // Disabilita il debug mode per gli annunci
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: []),
  );
}