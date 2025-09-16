import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
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
  final AdService _adService = AdService();

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
    _bannerAd = await _adService.createBannerAd(isPortrait: isPortrait);
    
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
      final expectedSize =(isPortrait ? AdSize.largeBanner : AdSize.banner);
      
      if (currentSize != expectedSize) {
        _loadAd(isPortrait);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox(height: 50);  // Altezza fissa per il web
    }

    // Controlliamo l'orientamento e carichiamo l'ad se necessario
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _checkAndLoadAd(isPortrait);

    if (!_isLoaded || _bannerAd == null) {
      return SizedBox(
        height: Platform.isAndroid ? 50 : (isPortrait ? 100 : 50),
      );
    }

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
} 