// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Kan ikke indlæse sidebilledet.\nPrøv igen om et øjeblik.';

  @override
  String get pageNotAvailable => 'Den ønskede side er ikke tilgængelig';

  @override
  String get pageLoadError =>
      'Der opstod en fejl under indlæsning af siden.\nTilbage til side 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Side $pageNumber er ikke tilgængelig for $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Side $pageNumber er ikke tilgængelig for $regionName.\nPrøv et andet nummer mellem 100 og 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Ingen flere sider tilgængelige for $regionName';
  }

  @override
  String get noMorePages => 'Ingen flere sider tilgængelige';

  @override
  String get invalidSubpageNumber => 'Ugyldigt undersidenummer';

  @override
  String subpageError(int current, int total) {
    return 'Fejl ved indlæsning af underside $current af $total';
  }

  @override
  String get swipePrevious => '← Forrige';

  @override
  String get swipeNext => 'Næste →';

  @override
  String get swipeNextUp => 'Næste ↑';

  @override
  String get swipePreviousDown => 'Forrige ↓';

  @override
  String get swipeRefresh => 'Opdater ↻';

  @override
  String get pageAddedToFavorites => 'Side tilføjet til favoritter';

  @override
  String get pageRemovedFromFavorites => 'Side fjernet fra favoritter';

  @override
  String get editDescription => 'Rediger beskrivelse';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Side $pageNumber - $regionName';
  }

  @override
  String get description => 'Beskrivelse';

  @override
  String get enterCustomDescription => 'Indtast en tilpasset beskrivelse';

  @override
  String get restoreHint =>
      'Tip: tryk længe på \"GENDAN\" knappen for at vende tilbage til standardbeskrivelsen.';

  @override
  String get restore => 'GENDAN';

  @override
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get searchHint => 'Søg side...';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get settings => 'Indstillinger';

  @override
  String get enterPageNumber => 'Indtast sidenummer';

  @override
  String pageNumberRange(int minPage) {
    return 'Nummer fra $minPage til 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Favoritliste';

  @override
  String get confirmRemoval => 'Bekræft fjernelse';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Vil du virkelig fjerne $description fra favoritter?';
  }

  @override
  String get remove => 'Fjern';

  @override
  String get edit => 'Rediger';

  @override
  String get close => 'Luk';

  @override
  String get noFavorites => 'Ingen favoritter';

  @override
  String get useFavoriteIcon =>
      'Brug ❤️ ikonet til at tilføje sider til favoritter';

  @override
  String loadingPage(int pageNumber) {
    return 'Indlæser side $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Ingen side at tilføje til favoritter';

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
  String get home => 'Hjem';

  @override
  String get addToFavorites => 'Tilføj til favoritter';

  @override
  String get removeFromFavorites => 'Fjern fra favoritter';

  @override
  String get loading => 'Indlæser...';

  @override
  String get error => 'Fejl';

  @override
  String errorWithMessage(String message) {
    return 'Fejl: $message';
  }

  @override
  String get retry => 'Prøv igen';

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
      'Hvis aktiveret, vil den første favorit på listen blive indlæst når appen starter';

  @override
  String get cacheDuration =>
      'Cache-varighed for Televideo-sidebilleder (0 sekunder for at deaktivere)';

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
  String get showInstructionsDescription => 'Gennemgå appens brugsvejledning';

  @override
  String get backupFavorites => 'Backup favoritter';

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
      'Vil du virkelig nulstille privatlivsindstillingerne? Du vil blive bedt om samtykke igen næste gang du starter appen.';

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
      'Appen til at konsultere RAI Televideo hurtigt og nemt';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Stryg til venstre eller højre for at skifte side, tryk på tal for at navigere direkte';

  @override
  String get onboardingFavorites => 'Favoritter';

  @override
  String get onboardingFavoritesDescription =>
      'Tilføj sider til favoritter for hurtig adgang';

  @override
  String get onboardingRegions => 'Regional Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Få adgang til din regions Televideo';

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
  String get onboardingPageSelector => 'Sidevælger';

  @override
  String get onboardingPageSelectorDescription =>
      'Tryk på det midterste tal for at indtaste en side direkte.\n\nIndtast et nummer mellem 100 og 999 for at springe til den side.';

  @override
  String get onboardingSubpageNavigation => 'Underside Navigation';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Hvis siden har undersider, vil du også se indikatoren:\n• 1/3 betyder: første underside af tre tilgængelige\n\nBrug de midterste pile til at navigere mellem undersider:\n\n• Pil op: gå til næste underside\n• Pil ned: gå til forrige underside\n\nPilene er kun aktive når der er undersider tilgængelige.';

  @override
  String get onboardingSwipe => 'Stryg Navigation';

  @override
  String get onboardingSwipeDescription =>
      'Naviger nemt mellem sider med bevægelserne vist ovenfor.';

  @override
  String get onboardingClickableNumbers => 'Klikkelige Sidenumre';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tryk på de fremhævede sidenumre for at navigere direkte til den side\n\nSide 100/1 af National Televideo og 300/1 af Regional Televideo kan ikke klikkes på';

  @override
  String get onboardingShortcuts => 'Menu Genveje';

  @override
  String get onboardingShortcutsDescription =>
      'Få hurtig adgang til de vigtigste Televideo-sider.\n\nBrug denne menu til at springe direkte til:\n• Side 100: Nationalt indeks\n• Side 200: Nyheder\n.....\nDu kan også søge efter sider efter titel ved at vælge Søg side muligheden';

  @override
  String get onboardingFavoritesList => 'Favoritliste';

  @override
  String get onboardingFavoritesListDescription =>
      'Administrer dine favoritside:\n\n• Tryk på en side for at åbne den\n• Stryg til venstre for at fjerne den\n• Tryk på blyanten for at redigere beskrivelsen\n• Tryk længe for at ændre rækkefølgen\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Tilpas appen efter dine præferencer:\n\n• Indlæs første favorit ved opstart: beslut hvilken Televideo-side at starte med\n• Tema: vælg mellem lyst, mørkt eller automatisk\n• Automatisk opdatering: aktiver automatisk indlæsning af undersider\n• Cache: administrer sidernes cache-varighed\n• Instruktioner: gennemgå denne vejledning når som helst\n• Backup Favoritter: gem og gendan dine favoritter\n• Privatlivsindstillinger og nulstilling: administrer eller nulstil dine privatlivsvalg';

  @override
  String get dontShowAgain => 'Vis ikke igen';

  @override
  String get start => 'Start';

  @override
  String get reset => 'Nulstil';

  @override
  String backToPage(int pageNumber) {
    return 'Tilbage til side $pageNumber';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'Page $pageNumber is not available.\nTry another number between $minPage and 999.\nBack to $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'An error occurred while loading the page.\nBack to $minPage';
  }

  @override
  String get channelSelection => 'Kanalvalg';

  @override
  String get favoriteChannels => 'Favoritkanaler';

  @override
  String get reorder => 'Omarranger';

  @override
  String get searchChannelOrCountry => 'Søg kanal eller land...';

  @override
  String get showAllChannels => 'Vis alle kanaler';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanaler tilgængelige fra $countries lande';
  }

  @override
  String get allChannels => 'Alle kanaler';

  @override
  String get noFavoriteChannelsFound => 'Ingen favoritkanaler fundet';

  @override
  String get noChannelsFound => 'Ingen kanaler fundet';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name tilføjet til favoritter';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name fjernet fra favoritter';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regioner tilgængelige';
  }

  @override
  String get reorderFavorites => 'Omarranger favoritter';
}
