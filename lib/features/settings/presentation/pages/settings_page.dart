import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/theme/theme_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cursor_televideo/core/onboarding/onboarding_service.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/backup_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _cacheSliderValue;
  late bool _liveShowEnabled;
  late double _liveShowIntervalValue;
  late bool _showOnboardingOnStartup;

  @override
  void initState() {
    super.initState();
    _cacheSliderValue = AppSettings.cacheDurationInSeconds.toDouble();
    _liveShowEnabled = AppSettings.liveShowEnabled;
    _liveShowIntervalValue = AppSettings.liveShowIntervalSeconds.toDouble();
    _showOnboardingOnStartup = OnboardingService().showOnStartup;
  }

  Future<void> _updateCacheDuration(double value) async {
    setState(() {
      _cacheSliderValue = value;
    });
    await AppSettings.setCacheDuration(value.toInt());
    if (mounted) {
      // Svuota la cache quando viene modificata la durata
      await DefaultCacheManager().emptyCache();
    }
  }

  Future<void> _updateLiveShowEnabled(bool value) async {
    setState(() {
      _liveShowEnabled = value;
    });
    await AppSettings.setLiveShowEnabled(value);
  }

  Future<void> _updateLiveShowInterval(double value) async {
    setState(() {
      _liveShowIntervalValue = value;
    });
    await AppSettings.setLiveShowInterval(value.toInt());
  }

  Future<void> _updateShowOnboardingOnStartup(bool value) async {
    setState(() {
      _showOnboardingOnStartup = value;
    });
    await OnboardingService().setShowOnStartup(value);
  }

  void _showInstructions() {
    OnboardingService().showOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        children: [
          // Sezione Cache
          ListTile(
            title: const Text('Durata cache immagini pagine Televideo (0 secondi per disabilitare)'),
            subtitle: Text('${_cacheSliderValue.toInt()} secondi'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Slider(
              value: _cacheSliderValue,
              min: 0,
              max: 600,
              divisions: 60,
              label: '${_cacheSliderValue.toInt()} secondi',
              onChanged: _updateCacheDuration,
            ),
          ),
          const Divider(),

          // Sezione Live Show
          SwitchListTile(
            title: const Text('Aggiornamento automatico'),
            subtitle: const Text('Aggiorna automaticamente le sottopagine'),
            value: _liveShowEnabled,
            onChanged: _updateLiveShowEnabled,
          ),
          if (_liveShowEnabled) ...[
            ListTile(
              title: const Text('Intervallo aggiornamento'),
              subtitle: Text('${_liveShowIntervalValue.toInt()} secondi'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Slider(
                value: _liveShowIntervalValue,
                min: 3,
                max: 30,
                divisions: 27,
                label: '${_liveShowIntervalValue.toInt()} secondi',
                onChanged: _updateLiveShowInterval,
              ),
            ),
          ],
          const Divider(),

          // Sezione Onboarding
          SwitchListTile(
            title: const Text('Mostra istruzioni all\'avvio'),
            subtitle: const Text('Mostra le istruzioni ogni volta che apri l\'app'),
            value: _showOnboardingOnStartup,
            onChanged: _updateShowOnboardingOnStartup,
          ),
          ListTile(
            title: const Text('Mostra istruzioni'),
            subtitle: const Text('Rivedi le istruzioni per l\'utilizzo dell\'app'),
            trailing: const Icon(Icons.help_outline),
            onTap: _showInstructions,
          ),
          const Divider(),

          // Sezione Backup
          ListTile(
            title: const Text('Backup preferiti'),
            subtitle: const Text('Salva e ripristina i tuoi preferiti'),
            trailing: const Icon(Icons.backup),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupPage(),
                ),
              );
            },
          ),
          const Divider(),

          // Sezione Tema
          ListTile(
            title: const Text('Tema'),
            subtitle: Text(
              BlocProvider.of<ThemeBloc>(context).state.themeMode == ThemeMode.system
                  ? 'Usa tema di sistema'
                  : BlocProvider.of<ThemeBloc>(context).state.themeMode == ThemeMode.light
                      ? 'Tema chiaro'
                      : 'Tema scuro',
            ),
            trailing: const Icon(Icons.palette_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Seleziona tema'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Tema di sistema'),
                        leading: const Icon(Icons.brightness_auto),
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(const ThemeEvent.changeTheme(ThemeMode.system));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Tema chiaro'),
                        leading: const Icon(Icons.brightness_high),
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(const ThemeEvent.changeTheme(ThemeMode.light));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Tema scuro'),
                        leading: const Icon(Icons.brightness_4),
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(const ThemeEvent.changeTheme(ThemeMode.dark));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 