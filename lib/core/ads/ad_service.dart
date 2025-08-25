import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  int _pageViewCount = 0;
  final int _pagesBeforeAd = 10;
  bool _isLoadingAd = false;
  bool _isShowingAd = false;

  // Stream controller per gli eventi degli annunci
  final _adEventController = StreamController<AdEvent>.broadcast();
  Stream<AdEvent> get adEventStream => _adEventController.stream;
  bool get isShowingAd => _isShowingAd;

  void dispose() {
    _interstitialAd?.dispose();
    _adEventController.close();
  }

  void incrementPageView({bool isSubPage = false}) {
    if (kIsWeb) return;  // No ads on web
    
    _pageViewCount++;
    print('Conteggio visualizzazioni: $_pageViewCount/${_pagesBeforeAd} (${isSubPage ? "Sottopagina" : "Pagina"})');
    
    if (_pageViewCount >= _pagesBeforeAd) {
      _showInterstitialAd();
      _pageViewCount = 0;
    }
  }

  void _loadInterstitialAd({int retryAttempt = 0}) {
    if (kIsWeb) return;  // No ads on web
    
    // Se è già in caricamento o se abbiamo già un annuncio, non carichiamo
    if (_isLoadingAd || _interstitialAd != null) {
      print('Annuncio già ${_isLoadingAd ? "in caricamento" : "caricato"}, skip...');
      return;
    }
    
    if (retryAttempt >= 3) {
      print('Raggiunto numero massimo di tentativi di caricamento annuncio');
      return; // Massimo 3 tentativi
    }
    
    print('Inizio caricamento nuovo annuncio interstitial');
    _isLoadingAd = true;

    // Determina l'ID dell'annuncio in base alla piattaforma e alla modalità
    String adUnitId;
    if (Platform.isIOS && !kDebugMode) {
      // iOS Release mode - ID di produzione
      adUnitId = 'ca-app-pub-5405772972501741/4067949899';
    } else if (Platform.isAndroid && !kDebugMode) {
      // Android Release mode - ID di produzione
      adUnitId = 'ca-app-pub-5405772972501741/3606853269';
    } else {    
      // Debug mode o altre piattaforme - ID di test
      adUnitId = 'ca-app-pub-3940256099942544/1033173712';
    }
 

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Annuncio interstitial caricato');
          _interstitialAd = ad;
          _isLoadingAd = false;

          // Configura i callback per l'annuncio
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('Annuncio mostrato');
              _isShowingAd = true;
              _adEventController.add(AdEvent.shown);
              // Precarica il prossimo annuncio immediatamente
              _loadInterstitialAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              print('Annuncio chiuso');
              _isShowingAd = false;
              _adEventController.add(AdEvent.dismissed);
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Errore visualizzazione annuncio');
              _isShowingAd = false;
              _adEventController.add(AdEvent.failed);
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Errore caricamento annuncio interstitial: $error');
          _interstitialAd = null;
          _isLoadingAd = false;
          
          // Riprova dopo un breve delay
          Future.delayed(Duration(seconds: 1), () {
            _loadInterstitialAd(retryAttempt: retryAttempt + 1);
          });
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd == null && !_isLoadingAd) {
      _loadInterstitialAd();
      return;
    }

    try {
      await _interstitialAd?.show();
    } catch (e) {
      print('Errore durante la visualizzazione dell\'annuncio: $e');
      _loadInterstitialAd(); // Ricarica l'annuncio in caso di errore
    }
  }

  Future<void> initialize() async {
    if (!kIsWeb) {  // Solo su mobile
      print('Inizializzazione AdService');
      await MobileAds.instance.initialize();
      // Attendiamo che il primo annuncio sia caricato
      await _loadInterstitialAdWithCompletion();
      print('Primo annuncio interstitial precaricato e pronto');
    }
  }

  Future<void> _loadInterstitialAdWithCompletion() {
    final completer = Completer<void>();
    
    if (_interstitialAd != null) {
      completer.complete();
      return completer.future;
    }

    // Se è già in caricamento, non fare nulla
    if (_isLoadingAd) {
      completer.complete();
      return completer.future;
    }

    String adUnitId;
    if (Platform.isIOS && !kDebugMode) {
      adUnitId = 'ca-app-pub-5405772972501741/4067949899';
    } else if (Platform.isAndroid && !kDebugMode) {
      adUnitId = 'ca-app-pub-5405772972501741/3606853269';
    } else {    
      adUnitId = 'ca-app-pub-3940256099942544/1033173712';
    }

    _isLoadingAd = true;

      
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Primo annuncio interstitial caricato con successo');
          _interstitialAd = ad;
          _isLoadingAd = false;

          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('Annuncio mostrato');
              _isShowingAd = true;
              _adEventController.add(AdEvent.shown);
              // Precarica il prossimo annuncio immediatamente
              _loadInterstitialAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              print('Annuncio chiuso');
              _isShowingAd = false;
              _adEventController.add(AdEvent.dismissed);
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Errore visualizzazione annuncio');
              _isShowingAd = false;
              _adEventController.add(AdEvent.failed);
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd();
            },
          );
          completer.complete();
        },
        onAdFailedToLoad: (error) {
          print('Errore caricamento primo annuncio interstitial: $error');
          _interstitialAd = null;
          _isLoadingAd = false;
          
          // Se l'errore è "Too many requests", aspetta più a lungo
          if (error.message.contains('Too many recently failed requests')) {
            print('Troppe richieste fallite, attendo 30 secondi prima di riprovare...');
            Future.delayed(Duration(seconds: 30), () {
              _isLoadingAd = false;
              _loadInterstitialAdWithCompletion().then((_) => completer.complete());
            });
          } else if (error.message.contains('No ad to show')) {
            // Se non ci sono annunci disponibili, non riprovare subito
            print('Nessun annuncio disponibile, completo senza ritentare');
            _isLoadingAd = false;
            completer.complete();
          } else {
            // Per altri errori, riprova dopo 5 secondi
            print('Errore generico, riprovo tra 5 secondi...');
            Future.delayed(Duration(seconds: 5), () {
              _isLoadingAd = false;
              _loadInterstitialAdWithCompletion().then((_) => completer.complete());
            });
          }
        },
      ),
    );

    return completer.future;
  }

  static Future<BannerAd?> createBannerAd({required bool isPortrait}) async {
    if (kIsWeb) return null;

    // Determina la dimensione del banner in base alla piattaforma
    final size = (isPortrait ? AdSize.largeBanner : AdSize.banner);  // Dimensioni originali per iOS
    
    // Determina l'ID dell'annuncio in base alla piattaforma e alla modalità
    String adUnitId;
    if (Platform.isIOS && !kDebugMode) {
      // iOS Release mode - ID di produzione
      adUnitId = 'ca-app-pub-5405772972501741/8976947054';
    } else {
      if (Platform.isAndroid && !kDebugMode) {
        // Android Release mode - ID di produzione
        adUnitId = 'ca-app-pub-5405772972501741/2593154495';
      } else {
        // Debug mode o altre piattaforme - ID di test
        adUnitId = 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    //adUnitId = 'ca-app-pub-3940256099942544/2934735716';
    //adUnitId = 'ca-app-pub-5405772972501741/8976947054';
    
       
    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner Ad loaded.');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    try {
      await bannerAd.load();
      return bannerAd;
    } catch (e) {
      print('Errore nel caricamento del banner: $e');
      return null;
    }
  }
}

enum AdEvent {
  shown,
  dismissed,
  failed
} 