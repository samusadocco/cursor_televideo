import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Non facciamo nulla qui
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadAd(bool isPortrait) async {
    if (!mounted) return;
    
    _bannerAd?.dispose();
    _bannerAd = await AdService.createBannerAd(isPortrait: isPortrait);
    
    if (_bannerAd != null && mounted) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  void _checkAndLoadAd(bool isPortrait) {
    if (!_isInitialized) {
      _isInitialized = true;
      _loadAd(isPortrait);
    } else {
      final currentSize = _bannerAd?.size;
      final expectedSize = isPortrait ? AdSize.largeBanner : AdSize.banner;
      
      if (currentSize != expectedSize) {
        _loadAd(isPortrait);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      return SizedBox(height: isPortrait ? 100 : 50);
    }

    // Controlliamo l'orientamento e carichiamo l'ad se necessario
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _checkAndLoadAd(isPortrait);

    if (!_isLoaded || _bannerAd == null) {
      return SizedBox(height: isPortrait ? 100 : 50);
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
} 