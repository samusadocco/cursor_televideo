// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Beállítások';

  @override
  String get language => 'Nyelv';

  @override
  String get systemLanguage => 'Rendszernyelv';

  @override
  String get darkMode => 'Sötét mód';

  @override
  String get autoRefresh => 'Automatikus frissítés';

  @override
  String get favorites => 'Kedvencek';

  @override
  String get search => 'Keresés';

  @override
  String get regions => 'Régiók';

  @override
  String get home => 'Kezdőlap';

  @override
  String get addToFavorites => 'Hozzáadás a kedvencekhez';

  @override
  String get removeFromFavorites => 'Eltávolítás a kedvencekből';

  @override
  String get searchHint => 'Írja be az oldalszámot';

  @override
  String get noResults => 'Nincs találat';

  @override
  String get loading => 'Betöltés...';

  @override
  String get error => 'Hiba';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Újrapróbálkozás';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Mégse';

  @override
  String get close => 'Bezárás';

  @override
  String get next => 'Következő';

  @override
  String get previous => 'Előző';

  @override
  String get pageNotFound => 'Az oldal nem található';

  @override
  String get networkError => 'Hálózati hiba';

  @override
  String get connectionRequired => 'Kapcsolat szükséges';

  @override
  String get refreshing => 'Frissítés...';

  @override
  String get lastUpdate => 'Utolsó frissítés';

  @override
  String get theme => 'Téma';

  @override
  String get systemTheme => 'Rendszertéma';

  @override
  String get lightTheme => 'Világos téma';

  @override
  String get darkTheme => 'Sötét téma';

  @override
  String get selectTheme => 'Téma kiválasztása';

  @override
  String get loadFirstFavorite => 'Első kedvenc betöltése indításkor';

  @override
  String get loadFirstFavoriteDescription =>
      'Ha engedélyezve van, az első kedvenc oldal betöltődik az alkalmazás indításakor';

  @override
  String get cacheDuration =>
      'Televideo oldalak gyorsítótár időtartama (0 másodperc a kikapcsoláshoz)';

  @override
  String get seconds => 'másodperc';

  @override
  String get autoRefreshDescription => 'Aloldalak automatikus frissítése';

  @override
  String get refreshInterval => 'Frissítési időköz';

  @override
  String get showOnboardingAtStartup => 'Útmutató megjelenítése indításkor';

  @override
  String get showOnboardingAtStartupDescription =>
      'Útmutató megjelenítése minden alkalmazásindításkor';

  @override
  String get showInstructions => 'Útmutató megjelenítése';

  @override
  String get showInstructionsDescription =>
      'Az alkalmazás használati útmutatójának újbóli megtekintése';

  @override
  String get backupFavorites => 'Kedvencek mentése';

  @override
  String get backupFavoritesDescription =>
      'Kedvencek mentése és visszaállítása';

  @override
  String get privacySettings => 'Adatvédelmi beállítások';

  @override
  String get privacySettingsDescription =>
      'Hirdetésekkel kapcsolatos adatvédelmi beállítások módosítása';

  @override
  String get resetPrivacySettings => 'Adatvédelmi beállítások visszaállítása';

  @override
  String get resetPrivacySettingsDescription =>
      'Minden adatvédelmi beállítás visszaállítása';

  @override
  String get resetPrivacyConfirm =>
      'Biztosan visszaállítja az adatvédelmi beállításokat? A következő indításkor újra hozzájárulást kell adnia.';

  @override
  String get privacySettingsUnavailable =>
      'Az adatvédelmi beállítások jelenleg nem érhetők el';

  @override
  String get privacySettingsReset =>
      'Adatvédelmi beállítások visszaállítva. Indítsa újra az alkalmazást az új hozzájáruláshoz.';

  @override
  String get version => 'Verzió';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Üdvözöljük a TeleRetrò Italia alkalmazásban';

  @override
  String get onboardingWelcomeDescription =>
      'Az alkalmazás a RAI Televideo egyszerű és gyors böngészéséhez';

  @override
  String get onboardingNavigation => 'Navigáció';

  @override
  String get onboardingNavigationDescription =>
      'Húzza balra vagy jobbra az oldal váltásához, érintse meg a számokat a közvetlen navigációhoz';

  @override
  String get onboardingFavorites => 'Kedvencek';

  @override
  String get onboardingFavoritesDescription =>
      'Adjon hozzá oldalakat a kedvencekhez a gyors eléréshez';

  @override
  String get onboardingRegions => 'Regionális Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Hozzáférés a régiója Televideo-jához';

  @override
  String get onboardingAutoRefresh => 'Automatikus Frissítés';

  @override
  String get onboardingAutoRefreshDescription =>
      'Az aloldalak automatikusan frissülnek';

  @override
  String get onboardingPause => 'Frissítés Szüneteltetése';

  @override
  String get onboardingPauseDescription =>
      'Érintsen meg egy üres területet az automatikus frissítés szüneteltetéséhez';

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
