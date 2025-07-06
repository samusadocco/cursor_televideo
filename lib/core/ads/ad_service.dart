import 'dart:async';
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

  void _loadInterstitialAd() {
    if (kIsWeb || _isLoadingAd) return;  // No ads on web or if already loading
    
    _isLoadingAd = true;
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
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
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd == null) {
      _loadInterstitialAd();
      return;
    }

    await _interstitialAd?.show();
  }

  Future<void> initialize() async {
    if (!kIsWeb) {  // Solo su mobile
      print('Inizializzazione AdService');
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
    }
  }

  static Future<BannerAd?> createBannerAd({required bool isPortrait}) async {
    if (kIsWeb) return null;

    final size = isPortrait ? AdSize.largeBanner : AdSize.banner;
    final bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/2934735716', // Test ad unit ID
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