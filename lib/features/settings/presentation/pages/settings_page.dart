import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
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
                      onChanged: (value) {
                        setState(() {
                          _liveShowEnabled = value;
                          AppSettings.setLiveShowEnabled(value);
                        });
                      },
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Intervallo: ${_liveShowIntervalValue.toInt()} secondi',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Slider(
                    value: _liveShowIntervalValue,
                    min: 3,
                    max: 30,
                    divisions: 27,
                    label: _liveShowIntervalValue.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _liveShowIntervalValue = value;
                        AppSettings.setLiveShowInterval(value.toInt());
                      });
                    },
                  ),
                  const Text(
                    'Imposta il tempo di attesa tra una sottopagina e l\'altra (da 3 a 30 secondi).',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],

                // Cache Duration Setting
                const Text(
                  'Durata Cache Immagini',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _cacheSliderValue == 0
                      ? 'Cache disabilitata'
                      : 'Durata: ${_cacheSliderValue.toInt()} secondi',
                ),
                Slider(
                  value: _cacheSliderValue,
                  min: 0,
                  max: 600,
                  divisions: 60,
                  label: _cacheSliderValue.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _cacheSliderValue = value;
                      AppSettings.setCacheDuration(value.toInt());
                      // Svuota la cache quando viene modificata la durata
                      DefaultCacheManager().emptyCache();
                    });
                  },
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