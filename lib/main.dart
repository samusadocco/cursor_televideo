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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza le impostazioni
  await AppSettings.initialize();
  await OnboardingService().initialize();
  await FavoritesService().initialize();
  
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
