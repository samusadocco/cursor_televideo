// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Indstillinger';

  @override
  String get language => 'Sprog';

  @override
  String get systemLanguage => 'Systemsprog';

  @override
  String get darkMode => 'Mørk tilstand';

  @override
  String get autoRefresh => 'Automatisk opdatering';

  @override
  String get favorites => 'Favoritter';

  @override
  String get search => 'Søg';

  @override
  String get regions => 'Regioner';

  @override
  String get home => 'Start';

  @override
  String get addToFavorites => 'Tilføj til favoritter';

  @override
  String get removeFromFavorites => 'Fjern fra favoritter';

  @override
  String get searchHint => 'Indtast sidenummer';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get loading => 'Indlæser...';

  @override
  String get error => 'Fejl';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Prøv igen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuller';

  @override
  String get close => 'Luk';

  @override
  String get next => 'Næste';

  @override
  String get previous => 'Forrige';

  @override
  String get pageNotFound => 'Side ikke fundet';

  @override
  String get networkError => 'Netværksfejl';

  @override
  String get connectionRequired => 'Forbindelse påkrævet';

  @override
  String get refreshing => 'Opdaterer...';

  @override
  String get lastUpdate => 'Seneste opdatering';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Systemtema';

  @override
  String get lightTheme => 'Lyst tema';

  @override
  String get darkTheme => 'Mørkt tema';

  @override
  String get selectTheme => 'Vælg tema';

  @override
  String get loadFirstFavorite => 'Indlæs første favorit ved opstart';

  @override
  String get loadFirstFavoriteDescription =>
      'Hvis aktiveret, indlæses den første favorit ved app-start';

  @override
  String get cacheDuration =>
      'Cache-varighed for Televideo-sider (0 sekunder for at deaktivere)';

  @override
  String get seconds => 'sekunder';

  @override
  String get autoRefreshDescription => 'Opdater undersider automatisk';

  @override
  String get refreshInterval => 'Opdateringsinterval';

  @override
  String get showOnboardingAtStartup => 'Vis instruktioner ved opstart';

  @override
  String get showOnboardingAtStartupDescription =>
      'Vis instruktioner hver gang du åbner appen';

  @override
  String get showInstructions => 'Vis instruktioner';

  @override
  String get showInstructionsDescription =>
      'Gennemgå app-brugsinstruktioner igen';

  @override
  String get backupFavorites => 'Backup af favoritter';

  @override
  String get backupFavoritesDescription => 'Gem og gendan dine favoritter';

  @override
  String get privacySettings => 'Privatlivsindstillinger';

  @override
  String get privacySettingsDescription =>
      'Ændre dine privatlivsindstillinger for annoncer';

  @override
  String get resetPrivacySettings => 'Nulstil privatlivsindstillinger';

  @override
  String get resetPrivacySettingsDescription =>
      'Nulstil alle privatlivsindstillinger';

  @override
  String get resetPrivacyConfirm =>
      'Vil du virkelig nulstille privatlivsindstillingerne? Du skal give samtykke igen ved næste app-start.';

  @override
  String get privacySettingsUnavailable =>
      'Privatlivsindstillinger er ikke tilgængelige i øjeblikket';

  @override
  String get privacySettingsReset =>
      'Privatlivsindstillinger nulstillet. Genstart appen for nyt samtykke.';

  @override
  String get version => 'Version';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Velkommen til TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Appen til nem og hurtig adgang til RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Stryg til venstre eller højre for at skifte side, tryk på tal for direkte navigation';

  @override
  String get onboardingFavorites => 'Favoritter';

  @override
  String get onboardingFavoritesDescription =>
      'Tilføj sider til favoritter for hurtig adgang';

  @override
  String get onboardingRegions => 'Regional Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Få adgang til Televideo for din region';

  @override
  String get onboardingAutoRefresh => 'Automatisk Opdatering';

  @override
  String get onboardingAutoRefreshDescription =>
      'Undersider opdateres automatisk';

  @override
  String get onboardingPause => 'Pause Opdatering';

  @override
  String get onboardingPauseDescription =>
      'Tryk på et tomt område for at pause automatisk opdatering';

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
