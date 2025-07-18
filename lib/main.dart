import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/theme/app_theme.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/pages/home_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/theme/theme_bloc.dart';

// Funzione per determinare se il dispositivo è un tablet
bool isTablet(BuildContext context) {
  final data = MediaQuery.of(context);
  final shortestSide = data.size.shortestSide;
  
  // Consideriamo tablet i dispositivi con dimensione minima di 600dp
  return shortestSide >= 600;
}

// Funzione per configurare l'orientamento in base al tipo di dispositivo
void configureOrientation(BuildContext context) {
  if (isTablet(context)) {
    // Tablet: permetti entrambi gli orientamenti
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Telefono: solo orientamento verticale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  
  // Inizializza il servizio degli annunci
  await AdService().initialize();
  
  // Inizializza il servizio dei preferiti
  await FavoritesService().initialize();

  // Inizializza le impostazioni dell'app
  await AppSettings.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: Builder(
              builder: (context) {
                // Configura l'orientamento quando l'app viene costruita
                configureOrientation(context);
                return const HomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
