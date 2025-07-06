import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  int _pageViewCount = 0;
  final int _pagesBeforeAd = 10;
  bool _isLoadingAd = false;

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
        },
        onAdFailedToLoad: (error) {
          print('Errore caricamento annuncio interstitial: $error');
          _interstitialAd = null;
          _isLoadingAd = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (kIsWeb) return;  // No ads on web
    
    if (_interstitialAd != null) {
      print('Mostro annuncio interstitial');
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Annuncio interstitial chiuso');
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Errore visualizzazione annuncio interstitial: $error');
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdShowedFullScreenContent: (ad) {
          print('Annuncio interstitial mostrato');
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print('Nessun annuncio interstitial disponibile, ne carico uno nuovo');
      _loadInterstitialAd();
    }
  }

  Future<void> initialize() async {
    if (!kIsWeb) {  // Solo su mobile
      print('Inizializzazione AdService');
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
    }
  }

  void dispose() {
    if (!kIsWeb) {
      _interstitialAd?.dispose();
    }
  }

  static Future<BannerAd?> createBannerAd({required bool isPortrait}) async {
    if (kIsWeb) return null;  // Nessun annuncio su web
    
    final adSize = isPortrait ? AdSize.largeBanner : AdSize.banner;
    
    return BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',  // Test ad unit ID
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('Banner ad caricato.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Errore caricamento banner ad: $error');
        },
        onAdOpened: (Ad ad) => print('Banner ad aperto.'),
        onAdClosed: (Ad ad) => print('Banner ad chiuso.'),
      ),
    )..load();
  }
} 