// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get autoRefresh => 'Automatische Aktualisierung';

  @override
  String get favorites => 'Favoriten';

  @override
  String get search => 'Suche';

  @override
  String get regions => 'Regionen';

  @override
  String get home => 'Startseite';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get searchHint => 'Seitennummer eingeben';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schließen';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get connectionRequired => 'Verbindung erforderlich';

  @override
  String get refreshing => 'Aktualisiere...';

  @override
  String get lastUpdate => 'Letzte Aktualisierung';

  @override
  String get theme => 'Thema';

  @override
  String get systemTheme => 'Systemthema';

  @override
  String get lightTheme => 'Helles Thema';

  @override
  String get darkTheme => 'Dunkles Thema';

  @override
  String get selectTheme => 'Thema auswählen';

  @override
  String get loadFirstFavorite => 'Ersten Favoriten beim Start laden';

  @override
  String get loadFirstFavoriteDescription =>
      'Wenn aktiviert, wird der erste Favorit beim Start der App geladen';

  @override
  String get cacheDuration =>
      'Cache-Dauer für Televideo-Seiten (0 Sekunden zum Deaktivieren)';

  @override
  String get seconds => 'Sekunden';

  @override
  String get autoRefreshDescription => 'Unterseiten automatisch aktualisieren';

  @override
  String get refreshInterval => 'Aktualisierungsintervall';

  @override
  String get showOnboardingAtStartup => 'Anleitung beim Start anzeigen';

  @override
  String get showOnboardingAtStartupDescription =>
      'Zeigt die Anleitung bei jedem App-Start an';

  @override
  String get showInstructions => 'Anleitung anzeigen';

  @override
  String get showInstructionsDescription =>
      'Anleitung zur App-Nutzung erneut ansehen';

  @override
  String get backupFavorites => 'Favoriten sichern';

  @override
  String get backupFavoritesDescription =>
      'Favoriten speichern und wiederherstellen';

  @override
  String get privacySettings => 'Datenschutz-Einstellungen';

  @override
  String get privacySettingsDescription =>
      'Datenschutz-Einstellungen für Werbung ändern';

  @override
  String get resetPrivacySettings => 'Datenschutz-Einstellungen zurücksetzen';

  @override
  String get resetPrivacySettingsDescription =>
      'Datenschutz-Einstellungen komplett zurücksetzen';

  @override
  String get resetPrivacyConfirm =>
      'Möchten Sie die Datenschutz-Einstellungen wirklich zurücksetzen? Sie werden beim nächsten Start der App erneut nach Ihrer Einwilligung gefragt.';

  @override
  String get privacySettingsUnavailable =>
      'Datenschutz-Einstellungen sind derzeit nicht verfügbar';

  @override
  String get privacySettingsReset =>
      'Datenschutz-Einstellungen zurückgesetzt. Starten Sie die App neu für die neue Einwilligung.';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get onboardingWelcome => 'Willkommen bei TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Die App zum einfachen und schnellen Durchsuchen des RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Wischen Sie nach links oder rechts, um die Seite zu wechseln, tippen Sie auf Zahlen zur direkten Navigation';

  @override
  String get onboardingFavorites => 'Favoriten';

  @override
  String get onboardingFavoritesDescription =>
      'Fügen Sie Seiten zu Ihren Favoriten hinzu für schnellen Zugriff';

  @override
  String get onboardingRegions => 'Regionales Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Greifen Sie auf das Televideo Ihrer Region zu';

  @override
  String get onboardingAutoRefresh => 'Automatische Aktualisierung';

  @override
  String get onboardingAutoRefreshDescription =>
      'Unterseiten werden automatisch aktualisiert';

  @override
  String get onboardingPause => 'Aktualisierung pausieren';

  @override
  String get onboardingPauseDescription =>
      'Tippen Sie auf einen leeren Bereich, um die automatische Aktualisierung zu pausieren';

  @override
  String get onboardingPageSelector => 'Page Selector';

  @override
  String get onboardingPageSelectorDescription =>
      'Tap the central number to directly enter a page.\n\nEnter a number between 100 and 999 to jump to that page.';

  @override
  String get onboardingSubpageNavigation => 'Subpage Navigation';

  @override
  String get onboardingSubpageNavigationDescription =>
      'If the page has subpages, you\'ll also see the indicator:\n• 1/3 means: first subpage of three available\n\nUse the central arrows to navigate between subpages:\n\n• Up arrow: go to next subpage\n• Down arrow: go to previous subpage\n\nThe arrows are active only when there are subpages available.';

  @override
  String get onboardingSwipe => 'Swipe Navigation';

  @override
  String get onboardingSwipeDescription =>
      'Navigate easily between pages with the gestures shown above.';

  @override
  String get onboardingClickableNumbers => 'Clickable Page Numbers';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tap the highlighted page numbers to navigate directly to that page\n\nPages 100/1 of National Televideo and 300/1 of Regional Televideo are not clickable';

  @override
  String get onboardingShortcuts => 'Shortcuts Menu';

  @override
  String get onboardingShortcutsDescription =>
      'Quickly access the most important Televideo pages.\n\nUse this menu to jump directly to:\n• Page 100: National index\n• Page 200: News\n.....\nYou can also search pages by title by selecting the Search page option';

  @override
  String get onboardingFavoritesList => 'Favorites List';

  @override
  String get onboardingFavoritesListDescription =>
      'Manage your favorite pages:\n\n• Tap a page to open it\n• Swipe left to remove it\n• Tap the pencil to edit the description\n• Long press to change the order\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Customize the app according to your preferences:\n\n• Load first favorite at startup: decide which Televideo page to start with\n• Theme: choose between light, dark or automatic\n• Auto refresh: enable automatic loading of subpages\n• Cache: manage page cache duration\n• Instructions: review this tutorial whenever you want\n• Backup Favorites: save and restore your favorites\n• Privacy Settings and reset: manage or reset your privacy choices';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get start => 'Start';
}
