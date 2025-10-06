// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get systemLanguage => 'Järjestelmän kieli';

  @override
  String get darkMode => 'Tumma tila';

  @override
  String get autoRefresh => 'Automaattinen päivitys';

  @override
  String get favorites => 'Suosikit';

  @override
  String get search => 'Haku';

  @override
  String get regions => 'Alueet';

  @override
  String get home => 'Koti';

  @override
  String get addToFavorites => 'Lisää suosikkeihin';

  @override
  String get removeFromFavorites => 'Poista suosikeista';

  @override
  String get searchHint => 'Syötä sivunumero';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get loading => 'Ladataan...';

  @override
  String get error => 'Virhe';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Peruuta';

  @override
  String get close => 'Sulje';

  @override
  String get next => 'Seuraava';

  @override
  String get previous => 'Edellinen';

  @override
  String get pageNotFound => 'Sivua ei löydy';

  @override
  String get networkError => 'Verkkovirhe';

  @override
  String get connectionRequired => 'Yhteys vaaditaan';

  @override
  String get refreshing => 'Päivitetään...';

  @override
  String get lastUpdate => 'Viimeisin päivitys';

  @override
  String get theme => 'Teema';

  @override
  String get systemTheme => 'Järjestelmän teema';

  @override
  String get lightTheme => 'Vaalea teema';

  @override
  String get darkTheme => 'Tumma teema';

  @override
  String get selectTheme => 'Valitse teema';

  @override
  String get loadFirstFavorite => 'Lataa ensimmäinen suosikki käynnistettäessä';

  @override
  String get loadFirstFavoriteDescription =>
      'Jos käytössä, ensimmäinen suosikki ladataan sovelluksen käynnistyessä';

  @override
  String get cacheDuration =>
      'Televideo-sivujen välimuistin kesto (0 sekuntia poistaa käytöstä)';

  @override
  String get seconds => 'sekuntia';

  @override
  String get autoRefreshDescription => 'Päivitä alasivut automaattisesti';

  @override
  String get refreshInterval => 'Päivitysväli';

  @override
  String get showOnboardingAtStartup => 'Näytä ohjeet käynnistettäessä';

  @override
  String get showOnboardingAtStartupDescription =>
      'Näytä ohjeet joka kerta kun avaat sovelluksen';

  @override
  String get showInstructions => 'Näytä ohjeet';

  @override
  String get showInstructionsDescription =>
      'Katso sovelluksen käyttöohjeet uudelleen';

  @override
  String get backupFavorites => 'Varmuuskopioi suosikit';

  @override
  String get backupFavoritesDescription => 'Tallenna ja palauta suosikkisi';

  @override
  String get privacySettings => 'Yksityisyysasetukset';

  @override
  String get privacySettingsDescription =>
      'Muuta mainoksiin liittyviä yksityisyysasetuksiasi';

  @override
  String get resetPrivacySettings => 'Nollaa yksityisyysasetukset';

  @override
  String get resetPrivacySettingsDescription =>
      'Nollaa kaikki yksityisyysasetukset';

  @override
  String get resetPrivacyConfirm =>
      'Haluatko varmasti nollata yksityisyysasetukset? Sinun täytyy antaa suostumus uudelleen seuraavalla käynnistyskerralla.';

  @override
  String get privacySettingsUnavailable =>
      'Yksityisyysasetukset eivät ole tällä hetkellä saatavilla';

  @override
  String get privacySettingsReset =>
      'Yksityisyysasetukset nollattu. Käynnistä sovellus uudelleen antaaksesi uuden suostumuksen.';

  @override
  String get version => 'Versio';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Tervetuloa TeleRetrò Italiaan';

  @override
  String get onboardingWelcomeDescription =>
      'Sovellus RAI Televideon helppoon ja nopeaan selaamiseen';

  @override
  String get onboardingNavigation => 'Navigointi';

  @override
  String get onboardingNavigationDescription =>
      'Pyyhkäise vasemmalle tai oikealle vaihtaaksesi sivua, napauta numeroita siirtyäksesi suoraan';

  @override
  String get onboardingFavorites => 'Suosikit';

  @override
  String get onboardingFavoritesDescription =>
      'Lisää sivuja suosikkeihin nopeaa pääsyä varten';

  @override
  String get onboardingRegions => 'Alueellinen Televideo';

  @override
  String get onboardingRegionsDescription => 'Pääsy alueesi Televideoon';

  @override
  String get onboardingAutoRefresh => 'Automaattinen Päivitys';

  @override
  String get onboardingAutoRefreshDescription =>
      'Alasivut päivittyvät automaattisesti';

  @override
  String get onboardingPause => 'Keskeytä Päivitys';

  @override
  String get onboardingPauseDescription =>
      'Napauta tyhjää aluetta keskeyttääksesi automaattisen päivityksen';

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
