import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/ads/page_categories_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  int _pageViewCount = 0;
  final int _pagesBeforeAd = 10;
  final int _pagesBeforeAdLoad = 6; // Inizia a caricare alla 6ª pagina
  final int _pagesBeforeBannerRefresh = 8;
  bool _isLoadingAd = false;
  bool _isShowingAd = false;
  
  // Contatore per il refresh del banner
  int _bannerRefreshCount = 0;


  // Stream controller per gli eventi degli annunci
  final _adEventController = StreamController<AdEvent>.broadcast();
  Stream<AdEvent> get adEventStream => _adEventController.stream;
  bool get isShowingAd => _isShowingAd;
  
  // Stream controller per gli eventi di refresh del banner
  final _bannerRefreshController = StreamController<bool>.broadcast();
  Stream<bool> get bannerRefreshStream => _bannerRefreshController.stream;

  void dispose() {
    _interstitialAd?.dispose();
    _adEventController.close();
    _bannerRefreshController.close();
  }

  String? _currentPageNumber;
  String? _currentSection;
  bool _isRegional = false;
  Region? _currentRegion;
  String? _channelId;
  String? _countryCode;
  String? _language;

  void setContext({
    String? pageNumber,
    String? section,
    bool isRegional = false,
    Region? region,
    String? channelId,
    String? countryCode,
    String? language,
  }) {
    _currentPageNumber = pageNumber;
    _currentSection = section;
    _isRegional = isRegional;
    _currentRegion = region;
    _channelId = channelId;
    _countryCode = countryCode;
    _language = language;
  }

  AdRequest _createAdRequest() {
    var keywords = <String>[];
    
    // Determina il content URL in base al canale
    String contentUrl = 'https://www.televideo.rai.it'; // Default RAI
    if (_channelId != null) {
      // Germania - ARD e ZDF
      if (_channelId!.startsWith('ard_') || _channelId!.startsWith('zdf_')) {
        contentUrl = 'https://www.ard-text.de';
      }
      // Germania - BR (Bayerischer Rundfunk)
      else if (_channelId == 'br_text') {
        contentUrl = 'https://www.br.de/text';
      }
      // Germania - WDR (Westdeutscher Rundfunk)
      else if (_channelId == 'wdr_text') {
        contentUrl = 'https://www1.wdr.de/wdrtext';
      }
      // Germania - NDR (Norddeutscher Rundfunk)
      else if (_channelId == 'ndr_text') {
        contentUrl = 'https://www.ndr.de/public/teletext';
      }
      // Germania - HR (Hessischer Rundfunk)
      else if (_channelId == 'hr_text') {
        contentUrl = 'https://www.hr-text.hr-online.de';
      }
      // Germania - SWR (Südwestrundfunk) - Baden-Württemberg e Rheinland-Pfalz
      else if (_channelId == 'swr_bw' || _channelId == 'swr_rp') {
        contentUrl = 'https://www.swr.de/swrtext';
      }
      // Germania - SR (Saarländischer Rundfunk)
      else if (_channelId == 'sr_text') {
        contentUrl = 'https://www.sr-online.de/sr-fernsehen/videotext';
      }
      // Germania - RTL
      else if (_channelId == 'rtl_text') {
        contentUrl = 'https://www.rtl.de/cms/rtltext';
      }
      // Germania - 3sat
      else if (_channelId == '3sat_text') {
        contentUrl = 'https://teletext.3sat.de';
      }
      // Germania - Canali Zattoo (ARTE, RBB, MDR, ARD Alpha, Phoenix, n-tv, VOX)
      else if (_channelId == 'arte_text') {
        contentUrl = 'https://zapi.zattoo.com/teletext/DE_arte';
      } else if (_channelId == 'rbb_text') {
        contentUrl = 'https://zapi.zattoo.com/teletext/rbb';
      } else if (_channelId == 'mdr_text') {
        contentUrl = 'https://zapi.zattoo.com/teletext/mdr-sachsen';
      } else if (_channelId == 'ard_alpha_text') {
        contentUrl = 'https://zapi.zattoo.com/teletext/br-alpha';
      } else if (_channelId == 'phoenix_text') {
        contentUrl = 'https://zapi.zattoo.com/teletext/phoenix';
      } else if (_channelId == 'ntv_text') {
        contentUrl = 'https://zattoo-abox.zattoo.com/teletext/ntv_de';
      } else if (_channelId == 'vox_text') {
        contentUrl = 'https://zattoo-abox.zattoo.com/teletext/vox';
      }
      // Svizzera
      else if (_channelId == 'swiss_teletext') {
        contentUrl = 'https://www.teletext.ch';
      } else if (_channelId!.startsWith('srf_')) {
        contentUrl = 'https://www.srf.ch/teletext';
      } else if (_channelId!.startsWith('rts_')) {
        contentUrl = 'https://www.rts.ch/teletext';
      } else if (_channelId!.startsWith('rsi_')) {
        contentUrl = 'https://www.rsi.ch/teletext';
      }
      // Austria - ORF
      else if (_channelId == 'orf_teletext' || _channelId!.startsWith('orf')) {
        contentUrl = 'https://teletext.orf.at';
      }
      // Spagna
      else if (_channelId == 'tve' || _channelId == 'tve_teletexto') {
        contentUrl = 'https://www.rtve.es/tve/teletexto';
      } else if (_channelId == 'antena3' || _channelId == 'antena3_teletexto') {
        contentUrl = 'https://www.antena3.com/teletexto';
      } else if (_channelId == 'lasexta' || _channelId == 'lasexta_teletexto') {
        contentUrl = 'https://www.lasexta.com/teletexto';
      }
      // Portogallo
      else if (_channelId == 'rtp' || _channelId == 'rtp_teletexto') {
        contentUrl = 'https://www.rtp.pt/wportal/teletexto';
      }
      // Olanda
      else if (_channelId == 'nos_teletekst') {
        contentUrl = 'https://nos.nl/teletekst';
      }
      // Svezia
      else if (_channelId == 'svt_text') {
        contentUrl = 'https://www.svt.se/text-tv';
      }
      // Croazia
      else if (_channelId == 'hrt_teletekst') {
        contentUrl = 'https://teletekst.hrt.hr';
      }
      // Finlandia
      else if (_channelId == 'yle_teksti_tv') {
        contentUrl = 'https://yle.fi/aihe/yle-ttv';
      }
      // Repubblica Ceca
      else if (_channelId == 'ct_teletext') {
        contentUrl = 'https://teletext.ceskatelevize.cz';
      }
      // Slovenia
      else if (_channelId == 'rtvslo_teletext') {
        contentUrl = 'https://teletext.rtvslo.si';
      }
      // Ungheria
      else if (_channelId == 'mtva_teletext') {
        contentUrl = 'https://www.teletext.hu';
      }
      // Islanda
      else if (_channelId == 'ruv_textavarp') {
        contentUrl = 'https://textavarp.is';
      }
      // Olanda - Omroep Zeeland
      else if (_channelId == 'omroepzeeland_teletekst') {
        contentUrl = 'https://www.omroepzeeland.nl/teletekst';
      }
      // Ucraina - Intertext
      else if (_channelId == 'intertext') {
        contentUrl = 'https://intertext.com.ua';
      }
      // Bosnia - BHRT, RTVFBiH
      else if (_channelId == 'bhrt' || _channelId == 'rtvfbih') {
        contentUrl = 'https://www.bhrt.ba/teletext';
      }
      // Danimarca - DR
      else if (_channelId == 'dr1' || _channelId == 'dr2') {
        contentUrl = 'https://www.dr.dk/tekst-tv';
      }
      // Polonia - Polsat
      else if (_channelId == 'polsat_telegazeta') {
        contentUrl = 'https://www.polsatnews.pl/telegazeta';
      }
      // Germania - Kika
      else if (_channelId == 'kika_text') {
        contentUrl = 'https://www.kika.de/teletext';
      }
      // Germania - SOM Teletextviewer
      else if (_channelId!.startsWith('som_')) {
        contentUrl = 'https://www.teletextviewer.de';
      }
    }

    // Aggiungi keywords basate sul contesto
    if (_currentPageNumber != null) {
      final pageNum = int.tryParse(_currentPageNumber!) ?? 0;
      
      // Aggiungi la descrizione della pagina come keyword (se disponibile)
      if (_currentSection != null && _currentSection!.isNotEmpty) {
        // Estrai parole chiave dalla descrizione
        final descriptionWords = _currentSection!
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\sàèéìòùäöüßåæøčšž]'), '') // Rimuovi punteggiatura ma mantieni caratteri accentati europei
            .split(' ')
            .where((word) => word.length > 3) // Solo parole significative
            .toList();
        
        keywords.addAll(descriptionWords);
      }
      
      // Aggiungi categorie specifiche del canale basate sul range di pagine
      if (pageNum > 0) {
        final categoryKeywords = PageCategoriesService().getCategoriesForPage(
          pageNumber: pageNum,
          channelId: _channelId,
          isRegional: _isRegional,
        );
        keywords.addAll(categoryKeywords);
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

    // Aggiungi keywords basate sul paese del canale
    if (_countryCode != null) {
      keywords.add(_countryCode!.toLowerCase());
      
      // Aggiungi parole chiave specifiche per paese
      switch (_countryCode!.toUpperCase()) {
        case 'IT':
          keywords.addAll(['italia', 'italian']);
          break;
        case 'CZ':
          keywords.addAll(['cechia', 'czech', 'repubblica-ceca']);
          break;
        case 'FI':
          keywords.addAll(['finlandia', 'finland', 'finnish']);
          break;
        case 'SE':
          keywords.addAll(['svezia', 'sweden', 'swedish']);
          break;
        case 'NL':
          keywords.addAll(['olanda', 'netherlands', 'dutch']);
          break;
        case 'DE':
          keywords.addAll(['germania', 'germany', 'german']);
          break;
        case 'AT':
          keywords.addAll(['austria', 'austrian']);
          break;
        case 'CH':
          keywords.addAll(['svizzera', 'switzerland', 'swiss']);
          break;
        case 'ES':
          keywords.addAll(['spagna', 'spain', 'spanish']);
          break;
        case 'PT':
          keywords.addAll(['portogallo', 'portugal', 'portuguese']);
          break;
        case 'HR':
          keywords.addAll(['croazia', 'croatia', 'croatian']);
          break;
        case 'SI':
          keywords.addAll(['slovenia', 'slovenian', 'sloveno']);
          break;
        case 'HU':
          keywords.addAll(['ungheria', 'hungary', 'hungarian', 'magyar']);
          break;
        case 'IS':
          keywords.addAll(['islanda', 'iceland', 'icelandic', 'nordic']);
          break;
      }
    }

    // Aggiungi la lingua del canale
    if (_language != null) {
      keywords.add(_language!.toLowerCase());
    }

    // Aggiungi il channel ID come keyword
    if (_channelId != null) {
      keywords.add(_channelId!);
    }

    // Rimuovi duplicati e limita il numero di keywords
    keywords = keywords.toSet().toList();
    if (keywords.length > 15) {
      keywords = keywords.sublist(0, 15);
    }

    // Log del contesto per AdMob
    print('\n=== CONTESTO ADMOB ===');
    print('Channel ID: $_channelId');
    print('Country Code: $_countryCode');
    print('Language: $_language');
    print('Page Number: $_currentPageNumber');
    print('Section: $_currentSection');
    print('Is Regional: $_isRegional');
    if (_currentRegion != null) {
      print('Region: ${_currentRegion!.name} (${_currentRegion!.code})');
    }
    print('Keywords (${keywords.length}): ${keywords.join(", ")}');
    print('Content URL: $contentUrl');
    print('Personalized Ads: ${AppSettings.adsPersonalizationEnabled}');
    print('=== FINE CONTESTO ADMOB ===\n');

    return AdRequest(
      keywords: keywords,
      contentUrl: contentUrl,
      nonPersonalizedAds: !AppSettings.adsPersonalizationEnabled,
    );
  }

  void incrementPageView({bool isSubPage = false}) {
    if (kIsWeb) return;  // No ads on web
    
    // Non aggiornare il contesto qui - dovrebbe essere già stato impostato da _updateAdContext
    
    _pageViewCount++;
    _bannerRefreshCount++;
    
    print('Conteggio visualizzazioni: $_pageViewCount/$_pagesBeforeAd | Banner refresh: $_bannerRefreshCount/$_pagesBeforeBannerRefresh (${isSubPage ? "Sottopagina" : "Pagina"})');
    
    // Inizia a caricare l'annuncio alla 6ª pagina (prima di mostrarlo alla 10ª)
    if (_pageViewCount == _pagesBeforeAdLoad && _interstitialAd == null && !_isLoadingAd) {
      print('🎯 Raggiunta pagina $_pagesBeforeAdLoad, inizio caricamento annuncio...');
      _loadInterstitialAd();
    }
    
    // Controlla se mostrare annuncio interstitial
    if (_pageViewCount >= _pagesBeforeAd) {
      _showInterstitialAd();
      _pageViewCount = 0;
    }
    
    // Controlla se aggiornare il banner
    if (_bannerRefreshCount >= _pagesBeforeBannerRefresh) {
      print('🔄 Refresh banner richiesto dopo $_pagesBeforeBannerRefresh visualizzazioni');
      _bannerRefreshController.add(true);
      _bannerRefreshCount = 0;
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
              // Non precarichiamo più subito - verrà caricato dopo 6 visualizzazioni
            },
            onAdDismissedFullScreenContent: (ad) {
              print('Annuncio chiuso');
              _isShowingAd = false;
              _adEventController.add(AdEvent.dismissed);
              ad.dispose();
              _interstitialAd = null;
              // Il prossimo annuncio verrà caricato alla 6ª visualizzazione
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Errore visualizzazione annuncio: $error');
              _isShowingAd = false;
              _adEventController.add(AdEvent.failed);
              ad.dispose();
              _interstitialAd = null;
              // Riprova a caricare immediatamente in caso di errore
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
      print('AdService inizializzato - l\'annuncio verrà caricato dopo $_pagesBeforeAdLoad visualizzazioni');
      // NON carichiamo più il primo annuncio all'avvio
      // Verrà caricato alla 6ª pagina in incrementPageView()
    }
  }

  Future<BannerAd?> createBannerAd({required bool isPortrait}) async {
    if (kIsWeb) return null;
    
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

    // Determina la dimensione del banner - usa adaptive solo se conveniente
    AdSize size;
    final fixedSize = (isPortrait ? AdSize.largeBanner : AdSize.banner);
    final fixedSurface = fixedSize.width * fixedSize.height;
    
    try {
      final screenWidth = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first
      ).size.width.truncate();
      
      // Prova ad ottenere la dimensione adaptive
      final orientation = isPortrait ? Orientation.portrait : Orientation.landscape;
      final adaptiveSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
        orientation,
        screenWidth,
      );
      
      if (adaptiveSize != null) {
        final adaptiveSurface = adaptiveSize.width * adaptiveSize.height;
        
        // Usa adaptive SOLO se ha superficie >= fixed banner E altezza >= 80px
        if (adaptiveSurface >= fixedSurface && adaptiveSize.height >= 80) {
          size = adaptiveSize;
          print('✅ Banner Adaptive conveniente: ${adaptiveSize.width}x${adaptiveSize.height}px ($adaptiveSurface pixel²) vs fisso ${fixedSize.width}x${fixedSize.height}px ($fixedSurface pixel²)');
        } else {
          size = fixedSize;
          print('⚠️ Banner Fisso più conveniente: ${fixedSize.width}x${fixedSize.height}px ($fixedSurface pixel²) vs adaptive ${adaptiveSize.width}x${adaptiveSize.height}px ($adaptiveSurface pixel²)');
        }
      } else {
        // Adaptive non disponibile
        size = fixedSize;
        print('📏 Banner Fisso (adaptive non disponibile): ${fixedSize.width}x${fixedSize.height}px');
      }
    } catch (e) {
      // Fallback in caso di errore
      size = fixedSize;
      print('⚠️ Errore nel calcolo adaptive banner: $e. Uso banner fisso: ${fixedSize.width}x${fixedSize.height}px');
    }

    // Usa un Completer per aspettare il risultato del caricamento
    final completer = Completer<BannerAd?>();
       
    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: _createAdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          print('✅ Banner Ad caricato con successo');
          // Aspetta un momento per permettere all'SDK di completare tutte le operazioni interne
          await Future.delayed(Duration(milliseconds: 100));
          if (!completer.isCompleted) {
            completer.complete(ad as BannerAd);
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ Banner Ad failed to load: $error');
          ad.dispose();
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
      ),
    );

    try {
      await bannerAd.load();
      // Aspetta che il listener confermi il caricamento
      final result = await completer.future.timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Timeout nel caricamento del banner');
          bannerAd.dispose();
          return null;
        },
      );
      
      if (result != null) {
        print('✅ Banner pronto per essere visualizzato');
      }
      
      return result;
    } catch (e) {
      print('❌ Errore nel caricamento del banner: $e');
      bannerAd.dispose();
      return null;
    }
  }
}

enum AdEvent {
  shown,
  dismissed,
  failed
} 