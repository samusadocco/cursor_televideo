// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Postavke';

  @override
  String get language => 'Jezik';

  @override
  String get systemLanguage => 'Sistemski jezik';

  @override
  String get darkMode => 'Tamni način';

  @override
  String get autoRefresh => 'Automatsko osvježavanje';

  @override
  String get favorites => 'Favoriti';

  @override
  String get search => 'Pretraži';

  @override
  String get regions => 'Regije';

  @override
  String get home => 'Početna';

  @override
  String get addToFavorites => 'Dodaj u favorite';

  @override
  String get removeFromFavorites => 'Ukloni iz favorita';

  @override
  String get searchHint => 'Unesite broj stranice';

  @override
  String get noResults => 'Nema rezultata';

  @override
  String get loading => 'Učitavanje...';

  @override
  String get error => 'Greška';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get ok => 'U redu';

  @override
  String get cancel => 'Odustani';

  @override
  String get close => 'Zatvori';

  @override
  String get next => 'Sljedeće';

  @override
  String get previous => 'Prethodno';

  @override
  String get pageNotFound => 'Stranica nije pronađena';

  @override
  String get networkError => 'Greška mreže';

  @override
  String get connectionRequired => 'Potrebna je veza';

  @override
  String get refreshing => 'Osvježavanje...';

  @override
  String get lastUpdate => 'Posljednje ažuriranje';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Sistemska tema';

  @override
  String get lightTheme => 'Svijetla tema';

  @override
  String get darkTheme => 'Tamna tema';

  @override
  String get selectTheme => 'Odaberi temu';

  @override
  String get loadFirstFavorite => 'Učitaj prvi favorit pri pokretanju';

  @override
  String get loadFirstFavoriteDescription =>
      'Ako je omogućeno, prvi favorit će se učitati pri pokretanju aplikacije';

  @override
  String get cacheDuration =>
      'Trajanje predmemorije Televideo stranica (0 sekundi za isključivanje)';

  @override
  String get seconds => 'sekundi';

  @override
  String get autoRefreshDescription => 'Automatski osvježi podstranice';

  @override
  String get refreshInterval => 'Interval osvježavanja';

  @override
  String get showOnboardingAtStartup => 'Prikaži upute pri pokretanju';

  @override
  String get showOnboardingAtStartupDescription =>
      'Prikaži upute svaki put kada otvorite aplikaciju';

  @override
  String get showInstructions => 'Prikaži upute';

  @override
  String get showInstructionsDescription =>
      'Ponovno pregledajte upute za korištenje aplikacije';

  @override
  String get backupFavorites => 'Sigurnosna kopija favorita';

  @override
  String get backupFavoritesDescription => 'Spremite i vratite svoje favorite';

  @override
  String get privacySettings => 'Postavke privatnosti';

  @override
  String get privacySettingsDescription =>
      'Izmijenite postavke privatnosti za oglase';

  @override
  String get resetPrivacySettings => 'Resetiraj postavke privatnosti';

  @override
  String get resetPrivacySettingsDescription =>
      'Potpuno resetiraj postavke privatnosti';

  @override
  String get resetPrivacyConfirm =>
      'Želite li zaista resetirati postavke privatnosti? Morat ćete dati pristanak ponovno pri sljedećem pokretanju aplikacije.';

  @override
  String get privacySettingsUnavailable =>
      'Postavke privatnosti trenutno nisu dostupne';

  @override
  String get privacySettingsReset =>
      'Postavke privatnosti su resetirane. Ponovno pokrenite aplikaciju za novi pristanak.';

  @override
  String get version => 'Verzija';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Dobrodošli u TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za jednostavno i brzo pregledavanje RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Povucite lijevo ili desno za promjenu stranice, dodirnite brojeve za izravnu navigaciju';

  @override
  String get onboardingFavorites => 'Favoriti';

  @override
  String get onboardingFavoritesDescription =>
      'Dodajte stranice u favorite za brzi pristup';

  @override
  String get onboardingRegions => 'Regionalni Televideo';

  @override
  String get onboardingRegionsDescription => 'Pristupite Televideo vaše regije';

  @override
  String get onboardingAutoRefresh => 'Automatsko Osvježavanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstranice se automatski osvježavaju';

  @override
  String get onboardingPause => 'Pauziraj Osvježavanje';

  @override
  String get onboardingPauseDescription =>
      'Dodirnite prazno područje za pauziranje automatskog osvježavanja';

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
