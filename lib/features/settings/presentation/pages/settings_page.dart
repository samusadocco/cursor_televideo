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

  @override
  void initState() {
    super.initState();
    _cacheSliderValue = AppSettings.cacheDurationInSeconds.toDouble();
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
                const SizedBox(height: 8),
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