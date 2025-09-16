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
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/features/splash/presentation/widgets/splash_screen.dart';
import 'package:cursor_televideo/core/ads/initialize_screen.dart';
import 'package:cursor_televideo/core/version_manager.dart';
import 'package:cursor_televideo/features/version/widgets/version_changes_dialog.dart';
import 'package:cursor_televideo/core/review/review_service.dart';
import 'package:cursor_televideo/core/tracking/tracking_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Richiedi autorizzazione al tracciamento su iOS prima di tutto
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
    
    // Inizializza Analytics
    print('Starting Analytics initialization...');
    await AnalyticsService.initialize();
    print('Analytics initialized successfully');
    
    // Log dell'apertura dell'app
    await AnalyticsService().logAppOpen();
    print('App open event logged successfully');
  } catch (e, stackTrace) {
    print('Error initializing Firebase/Analytics: $e');
    print('Stack trace: $stackTrace');
  }
  
  // Inizializza le impostazioni
  try {
    await AppSettings.initialize();
    print('AppSettings initialized successfully');
    await OnboardingService().initialize();
    print('OnboardingService initialized successfully');
    await FavoritesService().initialize();
    print('FavoritesService initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
  
  // Inizializza il servizio di recensioni
  try {
    final reviewService = await ReviewService.create();
    await reviewService.incrementLaunchCount();
    print('ReviewService initialized successfully');
  } catch (e) {
    print('Error initializing ReviewService: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
          return MaterialApp(
            title: 'TeleRetro Italia',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const InitializeScreen(
              targetWidget: SplashScreen(
                child: OnboardingWrapper(
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