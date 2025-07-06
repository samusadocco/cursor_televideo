import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  int _pageViewCount = 0;
  final int _pagesBeforeAd = 10;

  void incrementPageView() {
    if (kIsWeb) return;  // No ads on web
    _pageViewCount++;
    if (_pageViewCount >= _pagesBeforeAd) {
      _showInterstitialAd();
      _pageViewCount = 0;
    }
  }

  void _loadInterstitialAd() {
    if (kIsWeb) return;  // No ads on web
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (kIsWeb) return;  // No ads on web
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  Future<void> initialize() async {
    if (!kIsWeb) {  // Solo su mobile
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
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    )..load();
  }
} 