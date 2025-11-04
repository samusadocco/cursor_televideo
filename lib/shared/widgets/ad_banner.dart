import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
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
  StreamSubscription<bool>? _bannerRefreshSubscription;
  int _bannerVersion = 0; // Track banner refreshes

  @override
  void initState() {
    super.initState();
    
    print('🎬 AdBanner: initState called');
    
    // Ascolta gli eventi di refresh del banner
    _bannerRefreshSubscription = _adService.bannerRefreshStream.listen((shouldRefresh) {
      print('📱 AdBanner: evento ricevuto da stream, shouldRefresh=$shouldRefresh, mounted=$mounted');
      if (shouldRefresh && mounted) {
        print('📱 AdBanner: ricevuto evento di refresh, eseguo _refreshBanner()');
        _refreshBanner();
      }
    });
    
    print('📱 AdBanner: sottoscrizione stream configurata');
  }

  @override
  void dispose() {
    _bannerRefreshSubscription?.cancel();
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
  
  Future<void> _refreshBanner() async {
    if (!mounted) {
      print('⚠️ AdBanner: widget not mounted, skip refresh');
      return;
    }
    
    print('🔄 Refresh banner in corso... (versione corrente: $_bannerVersion)');
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    // Incrementa la versione del banner
    _bannerVersion++;
    print('🔄 Nuova versione banner: $_bannerVersion');
    
    // Prima imposta come non caricato per mostrare un placeholder
    if (mounted) {
      setState(() {
        _isLoaded = false;
      });
    }
    
    // Dispone del banner corrente
    _bannerAd?.dispose();
    _bannerAd = null;
    
    print('🔄 Banner vecchio dispose, caricamento nuovo banner...');
    
    // Aspetta un attimo per permettere il dispose completo
    await Future.delayed(Duration(milliseconds: 100));
    
    // Carica un nuovo banner
    _bannerAd = await _adService.createBannerAd(isPortrait: isPortrait);
    
    if (_bannerAd != null && mounted) {
      setState(() {
        _isLoaded = true;
      });
      print('✅ Banner aggiornato con successo (versione $_bannerVersion)');
    } else {
      print('❌ Errore nell\'aggiornamento del banner (versione $_bannerVersion)');
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