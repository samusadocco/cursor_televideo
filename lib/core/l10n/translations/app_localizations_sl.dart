// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Nastavitve';

  @override
  String get language => 'Jezik';

  @override
  String get systemLanguage => 'Sistemski jezik';

  @override
  String get darkMode => 'Temni način';

  @override
  String get autoRefresh => 'Samodejno osveževanje';

  @override
  String get favorites => 'Priljubljene';

  @override
  String get search => 'Iskanje';

  @override
  String get regions => 'Regije';

  @override
  String get home => 'Domov';

  @override
  String get addToFavorites => 'Dodaj med priljubljene';

  @override
  String get removeFromFavorites => 'Odstrani iz priljubljenih';

  @override
  String get searchHint => 'Vnesite številko strani';

  @override
  String get noResults => 'Ni rezultatov';

  @override
  String get loading => 'Nalaganje...';

  @override
  String get error => 'Napaka';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Poskusi ponovno';

  @override
  String get ok => 'V redu';

  @override
  String get cancel => 'Prekliči';

  @override
  String get close => 'Zapri';

  @override
  String get next => 'Naprej';

  @override
  String get previous => 'Nazaj';

  @override
  String get pageNotFound => 'Stran ni najdena';

  @override
  String get networkError => 'Napaka omrežja';

  @override
  String get connectionRequired => 'Potrebna je povezava';

  @override
  String get refreshing => 'Osveževanje...';

  @override
  String get lastUpdate => 'Zadnja posodobitev';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Sistemska tema';

  @override
  String get lightTheme => 'Svetla tema';

  @override
  String get darkTheme => 'Temna tema';

  @override
  String get selectTheme => 'Izberi temo';

  @override
  String get loadFirstFavorite => 'Naloži prvo priljubljeno ob zagonu';

  @override
  String get loadFirstFavoriteDescription =>
      'Če je omogočeno, se prva priljubljena stran naloži ob zagonu aplikacije';

  @override
  String get cacheDuration =>
      'Trajanje predpomnilnika Televideo strani (0 sekund za izklop)';

  @override
  String get seconds => 'sekund';

  @override
  String get autoRefreshDescription => 'Samodejno osveži podstrani';

  @override
  String get refreshInterval => 'Interval osveževanja';

  @override
  String get showOnboardingAtStartup => 'Prikaži navodila ob zagonu';

  @override
  String get showOnboardingAtStartupDescription =>
      'Prikaži navodila vsakič, ko odprete aplikacijo';

  @override
  String get showInstructions => 'Prikaži navodila';

  @override
  String get showInstructionsDescription =>
      'Ponovno si oglejte navodila za uporabo aplikacije';

  @override
  String get backupFavorites => 'Varnostna kopija priljubljenih';

  @override
  String get backupFavoritesDescription =>
      'Shranite in obnovite svoje priljubljene';

  @override
  String get privacySettings => 'Nastavitve zasebnosti';

  @override
  String get privacySettingsDescription =>
      'Spremenite nastavitve zasebnosti za oglase';

  @override
  String get resetPrivacySettings => 'Ponastavi nastavitve zasebnosti';

  @override
  String get resetPrivacySettingsDescription =>
      'Popolnoma ponastavi nastavitve zasebnosti';

  @override
  String get resetPrivacyConfirm =>
      'Ali res želite ponastaviti nastavitve zasebnosti? Ob naslednjem zagonu aplikacije boste morali ponovno dati soglasje.';

  @override
  String get privacySettingsUnavailable =>
      'Nastavitve zasebnosti trenutno niso na voljo';

  @override
  String get privacySettingsReset =>
      'Nastavitve zasebnosti so ponastavljene. Ponovno zaženite aplikacijo za novo soglasje.';

  @override
  String get version => 'Različica';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Dobrodošli v TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za enostavno in hitro brskanje po RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Povlecite levo ali desno za menjavo strani, dotaknite se številk za neposredno navigacijo';

  @override
  String get onboardingFavorites => 'Priljubljene';

  @override
  String get onboardingFavoritesDescription =>
      'Dodajte strani med priljubljene za hiter dostop';

  @override
  String get onboardingRegions => 'Regionalni Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Dostopajte do Televideo vaše regije';

  @override
  String get onboardingAutoRefresh => 'Samodejno Osveževanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstrani se samodejno osvežujejo';

  @override
  String get onboardingPause => 'Premor Osveževanja';

  @override
  String get onboardingPauseDescription =>
      'Dotaknite se praznega območja za premor samodejnega osveževanja';

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
