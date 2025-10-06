// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get systemLanguage => 'Systeemtaal';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get autoRefresh => 'Automatisch vernieuwen';

  @override
  String get favorites => 'Favorieten';

  @override
  String get search => 'Zoeken';

  @override
  String get regions => 'Regio\'s';

  @override
  String get home => 'Start';

  @override
  String get addToFavorites => 'Toevoegen aan favorieten';

  @override
  String get removeFromFavorites => 'Verwijderen uit favorieten';

  @override
  String get searchHint => 'Voer paginanummer in';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fout';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuleren';

  @override
  String get close => 'Sluiten';

  @override
  String get next => 'Volgende';

  @override
  String get previous => 'Vorige';

  @override
  String get pageNotFound => 'Pagina niet gevonden';

  @override
  String get networkError => 'Netwerkfout';

  @override
  String get connectionRequired => 'Verbinding vereist';

  @override
  String get refreshing => 'Vernieuwen...';

  @override
  String get lastUpdate => 'Laatste update';

  @override
  String get theme => 'Thema';

  @override
  String get systemTheme => 'Systeemthema';

  @override
  String get lightTheme => 'Licht thema';

  @override
  String get darkTheme => 'Donker thema';

  @override
  String get selectTheme => 'Selecteer thema';

  @override
  String get loadFirstFavorite => 'Eerste favoriet laden bij opstarten';

  @override
  String get loadFirstFavoriteDescription =>
      'Als dit is ingeschakeld, wordt de eerste favoriet geladen bij het opstarten van de app';

  @override
  String get cacheDuration =>
      'Cache-duur voor Televideo-pagina\'s (0 seconden om uit te schakelen)';

  @override
  String get seconds => 'seconden';

  @override
  String get autoRefreshDescription => 'Subpagina\'s automatisch vernieuwen';

  @override
  String get refreshInterval => 'Vernieuwingsinterval';

  @override
  String get showOnboardingAtStartup => 'Instructies tonen bij opstarten';

  @override
  String get showOnboardingAtStartupDescription =>
      'Toon de instructies elke keer dat je de app opent';

  @override
  String get showInstructions => 'Instructies tonen';

  @override
  String get showInstructionsDescription =>
      'Bekijk de gebruiksinstructies van de app opnieuw';

  @override
  String get backupFavorites => 'Back-up van favorieten';

  @override
  String get backupFavoritesDescription => 'Favorieten opslaan en herstellen';

  @override
  String get privacySettings => 'Privacy-instellingen';

  @override
  String get privacySettingsDescription =>
      'Wijzig je privacyvoorkeuren voor advertenties';

  @override
  String get resetPrivacySettings => 'Privacy-instellingen resetten';

  @override
  String get resetPrivacySettingsDescription =>
      'Privacy-instellingen volledig resetten';

  @override
  String get resetPrivacyConfirm =>
      'Wil je de privacy-instellingen echt resetten? Je moet opnieuw toestemming geven bij de volgende start van de app.';

  @override
  String get privacySettingsUnavailable =>
      'Privacy-instellingen zijn momenteel niet beschikbaar';

  @override
  String get privacySettingsReset =>
      'Privacy-instellingen gereset. Start de app opnieuw voor nieuwe toestemming.';

  @override
  String get version => 'Versie';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Welkom bij TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'De app om de RAI Televideo eenvoudig en snel te raadplegen';

  @override
  String get onboardingNavigation => 'Navigatie';

  @override
  String get onboardingNavigationDescription =>
      'Veeg naar links of rechts om van pagina te wisselen, tik op nummers om direct te navigeren';

  @override
  String get onboardingFavorites => 'Favorieten';

  @override
  String get onboardingFavoritesDescription =>
      'Voeg pagina\'s toe aan favorieten voor snelle toegang';

  @override
  String get onboardingRegions => 'Regionale Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Toegang tot de Televideo van jouw regio';

  @override
  String get onboardingAutoRefresh => 'Automatische Vernieuwing';

  @override
  String get onboardingAutoRefreshDescription =>
      'Subpagina\'s worden automatisch vernieuwd';

  @override
  String get onboardingPause => 'Vernieuwing Pauzeren';

  @override
  String get onboardingPauseDescription =>
      'Tik op een leeg gebied om automatische vernieuwing te pauzeren';

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
