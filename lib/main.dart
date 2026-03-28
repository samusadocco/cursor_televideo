import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:cursor_televideo/features/televideo_viewer/presentation/pages/home_page.dart';
import 'package:cursor_televideo/core/theme/app_theme.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/onboarding/onboarding_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/onboarding_carousel.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/theme/theme_bloc.dart';
import 'package:cursor_televideo/core/ads/initialize_screen.dart';
import 'package:cursor_televideo/core/version_manager.dart';
import 'package:cursor_televideo/features/version/widgets/version_changes_dialog.dart';
import 'package:cursor_televideo/core/review/review_service.dart';
import 'package:cursor_televideo/core/tracking/tracking_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/firebase_options.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cursor_televideo/core/config/ocr_config_service.dart';
import 'package:cursor_televideo/core/iap/iap_service.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/messages/remote_messages_overlay.dart';
import 'package:cursor_televideo/core/messages/remote_messages_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza AppSettings prima di ATT (serve per salvare lo stato)
  try {
    await AppSettings.initialize();
    print('AppSettings initialized successfully');
  } catch (e) {
    print('Error initializing AppSettings: $e');
  }

  // Richiedi autorizzazione al tracciamento su iOS
  // TEMPORANEO: non si applicano restrizioni in caso di rifiuto (annunci, UMP, cookie)
  try {
    await TrackingService.requestTrackingAuthorization();
    print('TrackingService authorization requested successfully');
  } catch (e) {
    print('Error requesting tracking authorization: $e');
  }
  
  // Inizializza Firebase e Analytics
  try {
    print('Starting Firebase initialization...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    
    // Verifica che Firebase sia inizializzato correttamente
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase non è stato inizializzato correttamente');
    }
    
    // Inizializza Analytics (TEMPORANEO: si registrano sempre, indipendentemente da ATT)
    print('Starting Analytics initialization...');
    await AnalyticsService.initialize(
      trackingAllowed: true, // !TrackingService.isTrackingDenied
    );
    print('Analytics initialized successfully');
    
    // Log dell'apertura dell'app
    await AnalyticsService().logAppOpen();
    print('App open event logged successfully');
  } catch (e, stackTrace) {
    print('Error initializing Firebase/Analytics: $e');
    print('Stack trace: $stackTrace');
  }
  
  // Inizializza gli altri servizi
  try {
    final prefs = await SharedPreferences.getInstance();
    await OnboardingService().initialize();
    print('OnboardingService initialized successfully');
    await FavoritesService().initialize();
    print('FavoritesService initialized successfully');
    
    // Inizializza il servizio della lingua (singleton)
    await LanguageService.initialize(prefs);
    print('LanguageService initialized successfully');
    
    // Inizializza il servizio In-App Purchase
    final iapService = IAPService(prefs);
    final iapInitialized = await iapService.initialize();
    if (iapInitialized) {
      print('✅ IAP Service initialized successfully');
      // Collega IAP Service ad Ad Service per controllare lo stato premium
      AdService().setIAPService(iapService);
      print('✅ IAP Service connected to Ad Service');
    } else {
      print('⚠️ IAP Service initialization failed, ads will show normally');
    }
  } catch (e) {
    print('Error initializing services: $e');
  }
  
  // ⚠️ CONFIGURA LA TUA GOOGLE VISION API KEY QUI ⚠️
  // Sostituisci 'YOUR_API_KEY_HERE' con la tua vera API key
  // TEMPORANEO: In produzione, crea un'interfaccia nelle impostazioni
  try {
    // DECOMMENTARE E SOSTITUIRE CON LA TUA API KEY:
     await OcrConfigService.setGoogleVisionApiKey('AIzaSyAh-J9L6jsZ-f2ggQSSlSb5showvVZk7Mw');
     print('✅ Google Vision API key configured for OCR');
    
    // Verifica se l'API key è già configurata
    final hasKey = await OcrConfigService.hasApiKey();
    if (hasKey) {
      print('✅ Google Vision OCR: API key configured');
    } else {
      print('⚠️ Google Vision OCR: API key NOT configured');
      print('   OCR will be disabled for ARTE and other image-based channels');
    }
  } catch (e) {
    print('Error configuring OCR: $e');
  }
  
  // Inizializza il servizio di recensioni
  try {
    final reviewService = await ReviewService.create();
    await reviewService.incrementLaunchCount();
    print('ReviewService initialized successfully');
  } catch (e) {
    print('Error initializing ReviewService: $e');
  }
  
  runApp(
    Phoenix(  
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget { 
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  LanguageService? _languageService;
  SharedPreferences? _prefs;
  Locale? _currentLocale;
  StreamSubscription<Locale>? _languageSubscription;

  @override
  void initState() {
    super.initState();                          
    WidgetsBinding.instance.addObserver(this);
    _initializeLanguage();
  }

  @override
  void dispose() {
    _languageSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();      
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _initializeLanguage();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('[MyApp] App lifecycle state changed: $state');
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App va in background - salva lo stato corrente
      print('[MyApp] App going to background, saving state...');
      _saveAppState();
    } else if (state == AppLifecycleState.resumed) {
      // App torna in foreground
    }
  }
  
  void _saveAppState() {
    // Salva lo stato del TelevideoBloc
    try {
      // Nota: il context potrebbe non essere disponibile qui
      // Il salvataggio verrà gestito dal HomePage
      print('[MyApp] State save triggered');
    } catch (e) {
      print('[MyApp] Error saving state: $e');
    }
  }

  Future<void> _initializeLanguage() async {
    // Inizializza il LanguageService singleton solo una volta
    if (_languageService == null) {
      _prefs = await SharedPreferences.getInstance();
      _languageService = await LanguageService.initialize(_prefs!);
      
      // Ascolta i cambi di lingua (solo una volta)
      _languageSubscription = LanguageService.instance.languageStream.listen((newLocale) {
        print('[MyApp] Cambio lingua rilevato dallo stream: ${newLocale.languageCode}');
        if (mounted) {
          setState(() {
            _currentLocale = newLocale;
            print('[MyApp] Locale aggiornato a: ${_currentLocale?.languageCode}');
          });
        }
      });
    }
    
    final locale = await LanguageService.instance.getSelectedLocale();
    print('[MyApp] Lingua iniziale: ${locale.languageCode}');
    
    if (mounted) {
      setState(() {
        _currentLocale = locale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocale == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TelevideoBloc(
            repository: TelevideoRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => RegionBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (_currentLocale == null) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          
          return MaterialApp(
            title: 'TeleRetro Italia',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            locale: _currentLocale,
            supportedLocales: const [
              Locale('it'), // Italiano
              Locale('en'), // Inglese
              Locale('de'), // Tedesco
              Locale('fr'), // Francese
              Locale('es'), // Spagnolo
              Locale('pt'), // Portoghese
              Locale('nl'), // Olandese
              Locale('da'), // Danese
              Locale('sv'), // Svedese
              Locale('fi'), // Finlandese
              Locale('cs'), // Ceco
              Locale('hr'), // Croato
              Locale('sl'), // Sloveno
              Locale('is'), // Islandese
              Locale('hu'), // Ungherese
              Locale('bs'), // Bosniaco
              Locale('pl'), // Polacco
              Locale('uk'), // Ucraino
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: InitializeScreen(
              targetWidget: OnboardingWrapper(
                child: RemoteMessagesOverlay(
                  service: RemoteMessagesService(),
                  messagesUrl: 'https://www.codebysam.it/teleretro/messages.json',
                  child: HomePage(),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class OnboardingWrapper extends StatefulWidget {
  final Widget child;

  const OnboardingWrapper({
    super.key,
    required this.child,
  });

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  StreamSubscription? _onboardingSubscription;
  bool _hasShownVersionChanges = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    _listenToOnboardingEvents();
  }

  @override
  void dispose() {
    _onboardingSubscription?.cancel();
    super.dispose();
  }

  void _listenToOnboardingEvents() {
    _onboardingSubscription = OnboardingService()
        .showOnboardingStream
        .listen((_) {
      _showOnboardingDialog();
    });
  }

  void _checkOnboarding() async {
    final onboardingService = OnboardingService();
    final hasSeenOnboarding = onboardingService.hasSeenOnboarding;
    final showOnStartup = onboardingService.showOnStartup;

    // Mostra il carousel se:
    // - Non è mai stato visto prima, oppure
    // - L'utente ha abilitato la visualizzazione all'avvio
    if (!hasSeenOnboarding || showOnStartup) {
      // Aspetta il primo frame per mostrare il dialogo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboardingDialog();
      });
    } else {
      // Se non dobbiamo mostrare l'onboarding, controlliamo le novità della versione
      _checkVersionChanges();
    }
  }

  void _checkVersionChanges() async {
    if (_hasShownVersionChanges) return;

    final versionManager = VersionManager();
    final newVersions = await versionManager.getNewVersions();

    if (newVersions.isNotEmpty && mounted) {
      _hasShownVersionChanges = true;
      // Aspetta il primo frame per mostrare il dialogo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => VersionChangesDialog(versions: newVersions),
        ).then((_) => _checkReview()); // Controlla le recensioni dopo aver mostrato le novità
      });
    } else {
      // Se non ci sono novità, controlla subito le recensioni
      _checkReview();
    }
  }

  void _checkReview() async {
    final reviewService = await ReviewService.create();
    if (await reviewService.shouldRequestReview()) {
      await reviewService.requestReview();
    }
  }

  void _showOnboardingDialog() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OnboardingCarousel(
        onDismiss: () async {
          await OnboardingService().markOnboardingAsSeen();
          if (mounted && context.mounted) {
            Navigator.of(context).pop();
            // Dopo l'onboarding, controlliamo le novità della versione
            _checkVersionChanges(); // Questo a sua volta controllerà le recensioni
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}