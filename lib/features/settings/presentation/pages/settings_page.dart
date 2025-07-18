import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/theme/theme_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _cacheSliderValue;
  late bool _liveShowEnabled;
  late double _liveShowIntervalValue;

  @override
  void initState() {
    super.initState();
    _cacheSliderValue = AppSettings.cacheDurationInSeconds.toDouble();
    _liveShowEnabled = AppSettings.liveShowEnabled;
    _liveShowIntervalValue = AppSettings.liveShowIntervalSeconds.toDouble();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Setting
                const Text(
                  'Tema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          icon: const Icon(Icons.brightness_auto),
                          label: const Text('Auto'),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          icon: const Icon(Icons.light_mode),
                          label: const Text('Chiaro'),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          icon: const Icon(Icons.dark_mode),
                          label: const Text('Scuro'),
                        ),
                      ],
                      selected: {state.themeMode},
                      onSelectionChanged: (Set<ThemeMode> selection) {
                        if (selection.isNotEmpty) {
                          context.read<ThemeBloc>().add(
                            ThemeEvent.changeTheme(selection.first),
                          );
                        }
                      },
                    );
                  },
                ),
                const Text(
                  'Scegli il tema dell\'app. In modalità automatica verrà utilizzato il tema di sistema.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Live Show Setting
                const Text(
                  'Live Show Sottopagine',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Switch(
                      value: _liveShowEnabled,
                      onChanged: _updateLiveShowEnabled,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _liveShowEnabled ? 'Abilitato' : 'Disabilitato',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const Text(
                  'Quando abilitato, le sottopagine verranno mostrate automaticamente in sequenza.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Live Show Interval Setting
                if (_liveShowEnabled) ...[
                  const Text(
                    'Intervallo Live Show',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _liveShowIntervalValue,
                          min: 3,
                          max: 30,
                          divisions: 27,
                          label: '${_liveShowIntervalValue.toInt()} secondi',
                          onChanged: _updateLiveShowInterval,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${_liveShowIntervalValue.toInt()}s',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Imposta l\'intervallo di tempo tra il cambio automatico delle sottopagine.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],

                // Cache Duration Setting
                const Text(
                  'Durata Cache',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _cacheSliderValue,
                        min: 0,
                        max: 600,
                        divisions: 60,
                        label: '${_cacheSliderValue.toInt()} secondi',
                        onChanged: _updateCacheDuration,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${_cacheSliderValue.toInt()}s',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Imposta per quanto tempo le immagini del televideo vengono mantenute in cache. '
                  'Un valore di 0 disabilita la cache, mentre il massimo è di 600 secondi (10 minuti).',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 