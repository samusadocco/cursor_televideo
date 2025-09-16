import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/shared/models/region.dart';

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

  String? _currentPageNumber;
  String? _currentSection;
  bool _isRegional = false;
  Region? _currentRegion;

  void setContext({
    String? pageNumber,
    String? section,
    bool isRegional = false,
    Region? region,
  }) {
    _currentPageNumber = pageNumber;
    _currentSection = section;
    _isRegional = isRegional;
    _currentRegion = region;
  }

  AdRequest _createAdRequest() {
    var keywords = <String>[];
    final contentUrl = 'https://www.televideo.rai.it';

    // Aggiungi keywords basate sul contesto
    if (_currentPageNumber != null) {
      final pageNum = int.tryParse(_currentPageNumber!) ?? 0;
      
      // Aggiungi la descrizione della pagina come keyword
      final description = PageDescriptionsService().getDescription(
        pageNum,
        isRegional: _isRegional,
      );
      
      // Estrai parole chiave dalla descrizione
      final descriptionWords = description
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '') // Rimuovi punteggiatura
          .split(' ')
          .where((word) => word.length > 3) // Solo parole significative
          .toList();
      
      keywords.addAll(descriptionWords);
      
      // Aggiungi categorie basate sul numero di pagina
      if (pageNum >= 100 && pageNum < 200) {
        keywords.addAll(['news', 'attualita', 'cronaca']);
      } else if (pageNum >= 200 && pageNum < 300) {
        keywords.addAll(['sport', 'calcio', 'campionato']);
      } else if (pageNum >= 300 && pageNum < 400) {
        keywords.addAll(['economia', 'finanza', 'mercati']);
      } else if (pageNum >= 400 && pageNum < 500) {
        keywords.addAll(['utilita', 'servizi', 'informazioni']);
      } else if (pageNum >= 500 && pageNum < 600) {
        keywords.addAll(['cultura', 'spettacolo', 'entertainment']);
      } else if (pageNum >= 600 && pageNum < 700) {
        keywords.addAll(['viabilita', 'trasporti', 'mobilita']);
      } else if (pageNum >= 700) {
        keywords.addAll(['meteo', 'previsioni', 'tempo']);
      }

      // Aggiungi il contesto regionale se presente
      if (_isRegional) {
        keywords.add('regionale');
        keywords.add('locale');
        
        // Aggiungi informazioni specifiche della regione
        if (_currentRegion != null) {
          // Aggiungi il nome della regione
          keywords.add(_currentRegion!.name.toLowerCase());
          
          // Aggiungi parole chiave basate sulla regione
          // Aggiungi parole chiave basate sul codice della regione
          switch (_currentRegion!.code) {
            case 'Abruzzo':
              keywords.addAll(['abruzzese', 'adriatico', 'appennino']);
              break;
            case 'Basilicata':
              keywords.addAll(['lucano', 'lucana', 'meridionale']);
              break;
            case 'Calabria':
              keywords.addAll(['calabrese', 'meridionale', 'mediterraneo']);
              break;
            case 'Campania':
              keywords.addAll(['campano', 'vesuvio', 'meridionale']);
              break;
            case 'Emilia':
              keywords.addAll(['emiliano', 'romagnolo', 'padano']);
              break;
            case 'Friuli':
              keywords.addAll(['friulano', 'giuliano', 'nordest']);
              break;
            case 'Lazio':
              keywords.addAll(['laziale', 'romano', 'centrale']);
              break;
            case 'Liguria':
              keywords.addAll(['ligure', 'riviera', 'tirreno']);
              break;
            case 'Lombardia':
              keywords.addAll(['lombardo', 'padano', 'alpino']);
              break;
            case 'Marche':
              keywords.addAll(['marchigiano', 'adriatico', 'centrale']);
              break;
            case 'Molise':
              keywords.addAll(['molisano', 'adriatico', 'appennino']);
              break;
            case 'Piemonte':
              keywords.addAll(['piemontese', 'alpino', 'padano']);
              break;
            case 'Puglia':
              keywords.addAll(['pugliese', 'adriatico', 'meridionale']);
              break;
            case 'Sardegna':
              keywords.addAll(['sardo', 'isola', 'mediterraneo']);
              break;
            case 'Sicilia':
              keywords.addAll(['siciliano', 'isola', 'mediterraneo']);
              break;
            case 'Toscana':
              keywords.addAll(['toscano', 'tirreno', 'centrale']);
              break;
            case 'Trentino':
              keywords.addAll(['trentino', 'altoatesino', 'alpino']);
              break;
            case 'Umbria':
              keywords.addAll(['umbro', 'appennino', 'centrale']);
              break;
            case 'Aosta':
              keywords.addAll(['valdostano', 'alpino', 'montano']);
              break;
            case 'Veneto':
              keywords.addAll(['veneto', 'nordest', 'adriatico']);
              break;
          }
        }
      }
    }

    if (_currentSection != null) {
      keywords.add(_currentSection!.toLowerCase());
    }

    // Rimuovi duplicati e limita il numero di keywords
    keywords = keywords.toSet().toList();
    if (keywords.length > 10) {
      keywords = keywords.sublist(0, 10);
    }

    // Log del contesto per AdMob
    print('\n=== CONTESTO ADMOB ===');
    print('Page Number: $_currentPageNumber');
    print('Section: $_currentSection');
    print('Is Regional: $_isRegional');
    if (_currentRegion != null) {
      print('Region: ${_currentRegion!.name} (${_currentRegion!.code})');
    }
    print('Keywords: ${keywords.join(", ")}');
    print('Content URL: $contentUrl');
    print('Personalized Ads: ${AppSettings.adsPersonalizationEnabled}');
    print('=== FINE CONTESTO ADMOB ===\n');

    return AdRequest(
      keywords: keywords,
      contentUrl: contentUrl,
      nonPersonalizedAds: !AppSettings.adsPersonalizationEnabled,
    );
  }

  void incrementPageView({bool isSubPage = false, String? pageNumber}) {
    if (kIsWeb) return;  // No ads on web
    
    if (pageNumber != null) {
      setContext(pageNumber: pageNumber);
    }
    
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
      request: _createAdRequest(),
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
      request: _createAdRequest(),
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

  Future<BannerAd?> createBannerAd({required bool isPortrait}) async {
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
      request: _createAdRequest(),
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