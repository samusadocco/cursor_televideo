// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Inställningar';

  @override
  String get language => 'Språk';

  @override
  String get systemLanguage => 'Systemspråk';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get autoRefresh => 'Automatisk uppdatering';

  @override
  String get favorites => 'Favoriter';

  @override
  String get search => 'Sök';

  @override
  String get regions => 'Regioner';

  @override
  String get home => 'Start';

  @override
  String get addToFavorites => 'Lägg till i favoriter';

  @override
  String get removeFromFavorites => 'Ta bort från favoriter';

  @override
  String get searchHint => 'Ange sidnummer';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get loading => 'Laddar...';

  @override
  String get error => 'Fel';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Försök igen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Avbryt';

  @override
  String get close => 'Stäng';

  @override
  String get next => 'Nästa';

  @override
  String get previous => 'Föregående';

  @override
  String get pageNotFound => 'Sidan hittades inte';

  @override
  String get networkError => 'Nätverksfel';

  @override
  String get connectionRequired => 'Anslutning krävs';

  @override
  String get refreshing => 'Uppdaterar...';

  @override
  String get lastUpdate => 'Senaste uppdatering';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Systemtema';

  @override
  String get lightTheme => 'Ljust tema';

  @override
  String get darkTheme => 'Mörkt tema';

  @override
  String get selectTheme => 'Välj tema';

  @override
  String get loadFirstFavorite => 'Ladda första favoriten vid start';

  @override
  String get loadFirstFavoriteDescription =>
      'Om aktiverad laddas den första favoriten när appen startas';

  @override
  String get cacheDuration =>
      'Cache-varaktighet för Televideo-sidor (0 sekunder för att inaktivera)';

  @override
  String get seconds => 'sekunder';

  @override
  String get autoRefreshDescription => 'Uppdatera undersidor automatiskt';

  @override
  String get refreshInterval => 'Uppdateringsintervall';

  @override
  String get showOnboardingAtStartup => 'Visa instruktioner vid start';

  @override
  String get showOnboardingAtStartupDescription =>
      'Visa instruktioner varje gång du öppnar appen';

  @override
  String get showInstructions => 'Visa instruktioner';

  @override
  String get showInstructionsDescription =>
      'Se app-användningsinstruktioner igen';

  @override
  String get backupFavorites => 'Säkerhetskopiera favoriter';

  @override
  String get backupFavoritesDescription => 'Spara och återställ dina favoriter';

  @override
  String get privacySettings => 'Sekretessinställningar';

  @override
  String get privacySettingsDescription =>
      'Ändra dina sekretessinställningar för annonser';

  @override
  String get resetPrivacySettings => 'Återställ sekretessinställningar';

  @override
  String get resetPrivacySettingsDescription =>
      'Återställ alla sekretessinställningar';

  @override
  String get resetPrivacyConfirm =>
      'Vill du verkligen återställa sekretessinställningarna? Du måste ge samtycke igen vid nästa app-start.';

  @override
  String get privacySettingsUnavailable =>
      'Sekretessinställningar är inte tillgängliga just nu';

  @override
  String get privacySettingsReset =>
      'Sekretessinställningar återställda. Starta om appen för nytt samtycke.';

  @override
  String get version => 'Version';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Välkommen till TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Appen för att enkelt och snabbt läsa RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Svep vänster eller höger för att byta sida, tryck på siffror för direkt navigation';

  @override
  String get onboardingFavorites => 'Favoriter';

  @override
  String get onboardingFavoritesDescription =>
      'Lägg till sidor i favoriter för snabb åtkomst';

  @override
  String get onboardingRegions => 'Regional Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Få tillgång till Televideo för din region';

  @override
  String get onboardingAutoRefresh => 'Automatisk Uppdatering';

  @override
  String get onboardingAutoRefreshDescription =>
      'Undersidor uppdateras automatiskt';

  @override
  String get onboardingPause => 'Pausa Uppdatering';

  @override
  String get onboardingPauseDescription =>
      'Tryck på ett tomt område för att pausa automatisk uppdatering';

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
