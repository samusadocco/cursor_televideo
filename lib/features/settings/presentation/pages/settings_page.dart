import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/theme/theme_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cursor_televideo/core/onboarding/onboarding_service.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/backup_page.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/support_page.dart';
import 'package:cursor_televideo/features/settings/presentation/widgets/language_selector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/core/l10n/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _loadFirstFavorite;
  late double _cacheSliderValue;
  late bool _liveShowEnabled;
  late double _liveShowIntervalValue;
  late bool _showOnboardingOnStartup;
  LanguageService? _languageService;
  StreamSubscription<Locale>? _languageSubscription;
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadFirstFavorite = AppSettings.loadFirstFavorite;
    _cacheSliderValue = AppSettings.cacheDurationInSeconds.toDouble();
    _liveShowEnabled = AppSettings.liveShowEnabled;
    _liveShowIntervalValue = AppSettings.liveShowIntervalSeconds.toDouble();
    _showOnboardingOnStartup = OnboardingService().showOnStartup;
    _loadPackageInfo();
    _initializeLanguageService();
  }

  Future<void> _initializeLanguageService() async {
    final prefs = await SharedPreferences.getInstance();
    _languageService = LanguageService(prefs);
    
    // Ascolta i cambiamenti di lingua dopo l'inizializzazione
    _languageSubscription = _languageService?.languageStream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'it': return 'Italiano';
      case 'en': return 'English';
      case 'de': return 'Deutsch';
      case 'fr': return 'Français';
      case 'es': return 'Español';
      case 'pt': return 'Português';
      case 'nl': return 'Nederlands';
      case 'da': return 'Dansk';
      case 'sv': return 'Svenska';
      case 'fi': return 'Suomi';
      case 'cs': return 'Čeština';
      case 'hr': return 'Hrvatski';
      case 'sl': return 'Slovenščina';
      case 'is': return 'Íslenska';
      case 'hu': return 'Magyar';
      case 'bs': return 'Bosanski';
      default: return languageCode;
    }
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  Future<void> _updateLoadFirstFavorite(bool value) async {
    setState(() {
      _loadFirstFavorite = value;
    });
    await AppSettings.setLoadFirstFavorite(value);
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

  Future<void> _resetConsentSettings() async {
    final l10n = AppLocalizations.of(context)!;
    // Mostra un dialogo di conferma
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetPrivacySettings),
        content: Text(l10n.resetPrivacyConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.reset),
          ),
        ],
      ),
    ) ?? false;

    if (shouldReset && mounted) {
      await ConsentInformation.instance.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.privacySettingsReset),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _languageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // Sezione Caricamento Preferiti
          SwitchListTile(
            title: Text(l10n.loadFirstFavorite),
            subtitle: Text(l10n.loadFirstFavoriteDescription),
            value: _loadFirstFavorite,
            onChanged: _updateLoadFirstFavorite,
          ),
          const Divider(),

          // Sezione Cache
          ListTile(
            title: Text(l10n.cacheDuration),
            subtitle: Text('${_cacheSliderValue.toInt()} ${l10n.seconds}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Slider(
              value: _cacheSliderValue,
              min: 0,
              max: 600,
              divisions: 60,
              label: '${_cacheSliderValue.toInt()} ${l10n.seconds}',
              onChanged: _updateCacheDuration,
            ),
          ),
          const Divider(),

          // Sezione Live Show
          SwitchListTile(
            title: Text(l10n.autoRefresh),
            subtitle: Text(l10n.autoRefreshDescription),
            value: _liveShowEnabled,
            onChanged: _updateLiveShowEnabled,
          ),
          if (_liveShowEnabled) ...[
            ListTile(
              title: Text(l10n.refreshInterval),
              subtitle: Text('${_liveShowIntervalValue.toInt()} ${l10n.seconds}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Slider(
                value: _liveShowIntervalValue,
                min: 3,
                max: 30,
                divisions: 27,
                label: '${_liveShowIntervalValue.toInt()} ${l10n.seconds}',
                onChanged: _updateLiveShowInterval,
              ),
            ),
          ],
          const Divider(),

          // Sezione Onboarding
          SwitchListTile(
            title: Text(l10n.showOnboardingAtStartup),
            subtitle: Text(l10n.showOnboardingAtStartupDescription),
            value: _showOnboardingOnStartup,
            onChanged: _updateShowOnboardingOnStartup,
          ),
          ListTile(
            title: Text(l10n.showInstructions),
            subtitle: Text(l10n.showInstructionsDescription),
            trailing: const Icon(Icons.help_outline),
            onTap: _showInstructions,
          ),
          const Divider(),

          // Sezione Backup
          ListTile(
            title: Text(l10n.backupFavorites),
            subtitle: Text(l10n.backupFavoritesDescription),
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
          
          // Supporto
          ListTile(
            title: Text(l10n.support),
            subtitle: const Text('Contattaci per assistenza'),
            trailing: const Icon(Icons.support_agent),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportPage(),
                ),
              );
            },
          ),
          const Divider(),

          // Sezione Lingua
          ListTile(
            title: Text(l10n.language),
            subtitle: FutureBuilder<Locale>(
              future: _languageService?.getSelectedLocale() ?? Future.value(const Locale('en')),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('...');
                }
                return Text(_getLanguageName(snapshot.data!.languageCode));
              },
            ),
            trailing: const Icon(Icons.language),
            onTap: () async {
              if (_languageService == null) return;
              final currentLocale = await _languageService!.getSelectedLocale();
              if (!mounted) return;
              
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.language),
                  content: SingleChildScrollView(
                    child: LanguageSelector(
                      languageService: _languageService!,
                      currentLocale: currentLocale,
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Sezione Tema
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(
              BlocProvider.of<ThemeBloc>(context).state.themeMode == ThemeMode.system
                  ? l10n.systemTheme
                  : BlocProvider.of<ThemeBloc>(context).state.themeMode == ThemeMode.light
                      ? l10n.lightTheme
                      : l10n.darkTheme,
            ),
            trailing: const Icon(Icons.palette_outlined),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.selectTheme),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(l10n.systemTheme),
                        leading: const Icon(Icons.brightness_auto),
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(const ThemeEvent.changeTheme(ThemeMode.system));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(l10n.lightTheme),
                        leading: const Icon(Icons.brightness_high),
                        onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(const ThemeEvent.changeTheme(ThemeMode.light));
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(l10n.darkTheme),
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
          const Divider(),
          
          // Sezione Privacy
          ListTile(
            title: Text(l10n.privacySettings),
            subtitle: Text(l10n.privacySettingsDescription),
            trailing: const Icon(Icons.privacy_tip_outlined),
            onTap: () async {
              try {
                // Prima verifichiamo se il form è disponibile
                final isAvailable = await ConsentInformation.instance.isConsentFormAvailable();
                if (!isAvailable && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.privacySettingsUnavailable),
                    ),
                  );
                  return;
                }

                // Carichiamo e mostriamo il form
                ConsentForm.loadConsentForm(
                  (ConsentForm consentForm) {
                    consentForm.show(
                      (FormError? formError) {
                        if (formError != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.errorWithMessage(formError.message)),
                            ),
                          );
                        }
                      },
                    );
                  },
                  (FormError formError) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.errorWithMessage(formError.message)),
                        ),
                      );
                    }
                  },
                );
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorWithMessage(e.toString())),
                    ),
                  );
                }
              }
            },
          ),
          ListTile(
            title: Text(l10n.resetPrivacySettings),
            subtitle: Text(l10n.resetPrivacySettingsDescription),
            trailing: const Icon(Icons.restore),
            onTap: _resetConsentSettings,
          ),
          const Divider(),

          // Sezione Informazioni App
          if (_packageInfo != null) ...[
            ListTile(
              title: Text(l10n.version),
              subtitle: Text('${_packageInfo!.version} (${l10n.build} ${_packageInfo!.buildNumber})'),
              trailing: const Icon(Icons.info_outline),
            ),
          ],
        ],
      ),
    );
  }
}