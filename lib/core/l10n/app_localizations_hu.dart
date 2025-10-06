// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Az oldal képét nem lehet betölteni.\nKérjük, próbálja újra később.';

  @override
  String get pageNotAvailable => 'A kért oldal nem érhető el';

  @override
  String get pageLoadError =>
      'Hiba történt az oldal betöltése közben.\nVissza a 100. oldalra';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'A(z) $pageNumber. oldal nem érhető el a következő régióban: $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'A(z) $pageNumber. oldal nem érhető el a következő régióban: $regionName.\nPróbáljon meg egy másik számot 100 és 999 között.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Nincs több elérhető oldal a következő régióban: $regionName';
  }

  @override
  String get noMorePages => 'Nincs több elérhető oldal';

  @override
  String get invalidSubpageNumber => 'Érvénytelen aloldal szám';

  @override
  String subpageError(int current, int total) {
    return 'Hiba történt a(z) $current/$total aloldal betöltése közben';
  }

  @override
  String get swipePrevious => '← Előző';

  @override
  String get swipeNext => 'Következő →';

  @override
  String get swipeNextUp => 'Következő ↑';

  @override
  String get swipePreviousDown => 'Előző ↓';

  @override
  String get swipeRefresh => 'Frissítés ↻';

  @override
  String get pageAddedToFavorites => 'Oldal hozzáadva a kedvencekhez';

  @override
  String get pageRemovedFromFavorites => 'Oldal eltávolítva a kedvencekből';

  @override
  String get editDescription => 'Leírás szerkesztése';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Oldal $pageNumber - $regionName';
  }

  @override
  String get description => 'Leírás';

  @override
  String get enterCustomDescription => 'Adjon meg egyéni leírást';

  @override
  String get restoreHint =>
      'Tipp: tartsa nyomva a \"VISSZAÁLLÍTÁS\" gombot az alapértelmezett leíráshoz való visszatéréshez.';

  @override
  String get restore => 'VISSZAÁLLÍTÁS';

  @override
  String get cancel => 'MÉGSE';

  @override
  String get save => 'MENTÉS';

  @override
  String get searchHint => 'Oldal keresése...';

  @override
  String get noResults => 'Nincs találat';

  @override
  String get settings => 'Beállítások';

  @override
  String get enterPageNumber => 'Adja meg az oldalszámot';

  @override
  String pageNumberRange(int minPage) {
    return 'Szám $minPage-tól 999-ig';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Kedvencek listája';

  @override
  String get confirmRemoval => 'Törlés megerősítése';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Biztosan el szeretné távolítani a következőt a kedvencekből: $description?';
  }

  @override
  String get remove => 'Eltávolítás';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get close => 'Bezárás';

  @override
  String get noFavorites => 'Nincsenek kedvencek';

  @override
  String get useFavoriteIcon =>
      'Használja a ❤️ ikont oldalak kedvencekhez adásához';

  @override
  String loadingPage(int pageNumber) {
    return 'Oldal betöltése: $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Nincs oldal a kedvencekhez adáshoz';

  @override
  String get language => 'Nyelv';

  @override
  String get systemLanguage => 'Rendszer nyelve';

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
  String get loading => 'Betöltés...';

  @override
  String get error => 'Hiba';

  @override
  String errorWithMessage(String message) {
    return 'Hiba: $message';
  }

  @override
  String get retry => 'Újrapróbálás';

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
  String get systemTheme => 'Rendszer téma';

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
      'Ha engedélyezve van, az alkalmazás indításakor az első kedvenc oldal töltődik be';

  @override
  String get cacheDuration =>
      'Televideo oldalképek gyorsítótár időtartama (0 másodperc a kikapcsoláshoz)';

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
      'Útmutató megjelenítése minden alkalommal, amikor megnyitja az alkalmazást';

  @override
  String get showInstructions => 'Útmutató megjelenítése';

  @override
  String get showInstructionsDescription =>
      'Az alkalmazás használati útmutatójának megtekintése';

  @override
  String get backupFavorites => 'Kedvencek biztonsági mentése';

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
      'Biztosan visszaállítja az adatvédelmi beállításokat? Az alkalmazás következő indításakor újra meg kell adnia a hozzájárulását.';

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
  String get onboardingWelcome => 'Üdvözöljük a TeleRetrò Italia-ban';

  @override
  String get onboardingWelcomeDescription =>
      'Az alkalmazás a RAI Televideo gyors és egyszerű használatához';

  @override
  String get onboardingNavigation => 'Navigáció';

  @override
  String get onboardingNavigationDescription =>
      'Húzza balra vagy jobbra az oldal váltásához, érintse meg a számokat a közvetlen navigációhoz';

  @override
  String get onboardingFavorites => 'Kedvencek';

  @override
  String get onboardingFavoritesDescription =>
      'Adjon oldalakat a kedvencekhez a gyors hozzáféréshez';

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
  String get onboardingPageSelector => 'Oldalválasztó';

  @override
  String get onboardingPageSelectorDescription =>
      'Érintse meg a középső számot az oldal közvetlen megadásához.\n\nAdjon meg egy számot 100 és 999 között az adott oldalra ugráshoz.';

  @override
  String get onboardingSubpageNavigation => 'Aloldal Navigáció';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Ha az oldalnak vannak aloldalai, látni fogja a jelzőt:\n• 1/3 jelentése: első aloldal a három elérhetőből\n\nHasználja a középső nyilakat az aloldalak közötti navigációhoz:\n\n• Felfelé nyíl: következő aloldalra\n• Lefelé nyíl: előző aloldalra\n\nA nyilak csak akkor aktívak, ha vannak elérhető aloldalak.';

  @override
  String get onboardingSwipe => 'Húzás Navigáció';

  @override
  String get onboardingSwipeDescription =>
      'Könnyen navigálhat az oldalak között a fent bemutatott gesztusokkal.';

  @override
  String get onboardingClickableNumbers => 'Kattintható Oldalszámok';

  @override
  String get onboardingClickableNumbersDescription =>
      'Érintse meg a kiemelt oldalszámokat az adott oldalra való közvetlen navigációhoz\n\nA Nemzeti Televideo 100/1 és a Regionális Televideo 300/1 oldalai nem kattinthatók';

  @override
  String get onboardingShortcuts => 'Menü Parancsikonok';

  @override
  String get onboardingShortcutsDescription =>
      'Gyors hozzáférés a legfontosabb Televideo oldalakhoz.\n\nHasználja ezt a menüt a közvetlen ugráshoz:\n• 100. oldal: Nemzeti index\n• 200. oldal: Hírek\n.....\nKereshet oldalakat cím szerint is az Oldal keresése opció kiválasztásával';

  @override
  String get onboardingFavoritesList => 'Kedvencek Lista';

  @override
  String get onboardingFavoritesListDescription =>
      'Kezelje kedvenc oldalait:\n\n• Érintse meg az oldalt a megnyitáshoz\n• Húzza balra az eltávolításhoz\n• Érintse meg a ceruzát a leírás szerkesztéséhez\n• Tartsa nyomva a sorrend módosításához\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Testreszabhatja az alkalmazást preferenciái szerint:\n\n• Első kedvenc betöltése indításkor: döntse el, melyik Televideo oldallal kezdjen\n• Téma: válasszon világos, sötét vagy automatikus között\n• Automatikus frissítés: engedélyezze az aloldalak automatikus betöltését\n• Gyorsítótár: kezelje az oldalak gyorsítótár időtartamát\n• Útmutató: tekintse meg ezt az oktatóanyagot bármikor\n• Kedvencek biztonsági mentése: mentse és állítsa vissza kedvenceit\n• Adatvédelmi beállítások és visszaállítás: kezelje vagy állítsa vissza adatvédelmi választásait';

  @override
  String get dontShowAgain => 'Ne mutassa újra';

  @override
  String get start => 'Indítás';

  @override
  String get reset => 'Visszaállítás';

  @override
  String backToPage(int pageNumber) {
    return 'Vissza a(z) $pageNumber. oldalra';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'Page $pageNumber is not available.\nTry another number between $minPage and 999.\nBack to $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'An error occurred while loading the page.\nBack to $minPage';
  }
}
