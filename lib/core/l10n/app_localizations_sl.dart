// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Slike strani ni mogoče naložiti.\nPoskusite ponovno čez trenutek.';

  @override
  String get pageNotAvailable => 'Zahtevana stran ni na voljo';

  @override
  String get pageLoadError =>
      'Pri nalaganju strani je prišlo do napake.\nNazaj na stran 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Stran $pageNumber ni na voljo za $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Stran $pageNumber ni na voljo za $regionName.\nPoskusite z drugo številko med 100 in 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Ni več strani na voljo za $regionName';
  }

  @override
  String get noMorePages => 'Ni več strani na voljo';

  @override
  String get invalidSubpageNumber => 'Neveljavna številka podstrani';

  @override
  String subpageError(int current, int total) {
    return 'Napaka pri nalaganju podstrani $current od $total';
  }

  @override
  String get swipePrevious => '← Prejšnja';

  @override
  String get swipeNext => 'Naslednja →';

  @override
  String get swipeNextUp => 'Naslednja ↑';

  @override
  String get swipePreviousDown => 'Prejšnja ↓';

  @override
  String get swipeRefresh => 'Osveži ↻';

  @override
  String get pageAddedToFavorites => 'Stran dodana med priljubljene';

  @override
  String get pageRemovedFromFavorites => 'Stran odstranjena iz priljubljenih';

  @override
  String get editDescription => 'Uredi opis';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Stran $pageNumber - $regionName';
  }

  @override
  String get description => 'Opis';

  @override
  String get enterCustomDescription => 'Vnesite prilagojen opis';

  @override
  String get restoreHint =>
      'Nasvet: dolgo pritisnite gumb \"OBNOVI\" za vrnitev na privzeti opis.';

  @override
  String get restore => 'OBNOVI';

  @override
  String get cancel => 'Prekliči';

  @override
  String get save => 'Shrani';

  @override
  String get searchHint => 'Išči stran...';

  @override
  String get noResults => 'Ni rezultatov';

  @override
  String get settings => 'Nastavitve';

  @override
  String get enterPageNumber => 'Vnesite številko strani';

  @override
  String pageNumberRange(int minPage) {
    return 'Številka od $minPage do 999';
  }

  @override
  String get ok => 'V redu';

  @override
  String get favoritesList => 'Seznam priljubljenih';

  @override
  String get confirmRemoval => 'Potrdi odstranitev';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Ali res želite odstraniti $description iz priljubljenih?';
  }

  @override
  String get remove => 'Odstrani';

  @override
  String get edit => 'Uredi';

  @override
  String get close => 'Zapri';

  @override
  String get noFavorites => 'Ni priljubljenih';

  @override
  String get useFavoriteIcon =>
      'Uporabite ikono ❤️ za dodajanje strani med priljubljene';

  @override
  String loadingPage(int pageNumber) {
    return 'Nalaganje strani $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Ni strani za dodajanje med priljubljene';

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
  String get search => 'Išči';

  @override
  String get regions => 'Regije';

  @override
  String get home => 'Domov';

  @override
  String get addToFavorites => 'Dodaj med priljubljene';

  @override
  String get removeFromFavorites => 'Odstrani iz priljubljenih';

  @override
  String get loading => 'Nalaganje...';

  @override
  String get error => 'Napaka';

  @override
  String errorWithMessage(String message) {
    return 'Napaka: $message';
  }

  @override
  String get retry => 'Poskusi ponovno';

  @override
  String get next => 'Naprej';

  @override
  String get previous => 'Nazaj';

  @override
  String get pageNotFound => 'Stran ni najdena';

  @override
  String get networkError => 'Omrežna napaka';

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
      'Če je omogočeno, se bo ob zagonu aplikacije naložila prva priljubljena stran s seznama';

  @override
  String get cacheDuration =>
      'Trajanje predpomnilnika slik strani Televideo (0 sekund za onemogočenje)';

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
      'Preglejte navodila za uporabo aplikacije';

  @override
  String get backupFavorites => 'Varnostno kopiraj priljubljene';

  @override
  String get backupFavoritesDescription =>
      'Shranite in obnovite svoje priljubljene';

  @override
  String get privacySettings => 'Nastavitve zasebnosti';

  @override
  String get privacySettingsDescription =>
      'Spremenite svoje nastavitve zasebnosti za oglase';

  @override
  String get resetPrivacySettings => 'Ponastavi nastavitve zasebnosti';

  @override
  String get resetPrivacySettingsDescription =>
      'Popolnoma ponastavi nastavitve zasebnosti';

  @override
  String get resetPrivacyConfirm =>
      'Ali res želite ponastaviti nastavitve zasebnosti? Ob naslednjem zagonu aplikacije boste ponovno pozvani k privolitvi.';

  @override
  String get privacySettingsUnavailable =>
      'Nastavitve zasebnosti trenutno niso na voljo';

  @override
  String get privacySettingsReset =>
      'Nastavitve zasebnosti so ponastavljene. Ponovno zaženite aplikacijo za novo privolitev.';

  @override
  String get version => 'Različica';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Dobrodošli v TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za hitro in enostavno posvetovanje z RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Podrsajte levo ali desno za spremembo strani, tapnite številke za neposredno navigacijo';

  @override
  String get onboardingFavorites => 'Priljubljene';

  @override
  String get onboardingFavoritesDescription =>
      'Dodajte strani med priljubljene za hiter dostop';

  @override
  String get onboardingRegions => 'Regionalni Televideo';

  @override
  String get onboardingRegionsDescription => 'Dostop do Televideo vaše regije';

  @override
  String get onboardingAutoRefresh => 'Samodejno Osveževanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstrani se samodejno posodabljajo';

  @override
  String get onboardingPause => 'Premor Osveževanja';

  @override
  String get onboardingPauseDescription =>
      'Tapnite prazno območje za premor samodejnega osveževanja';

  @override
  String get onboardingPageSelector => 'Izbirnik Strani';

  @override
  String get onboardingPageSelectorDescription =>
      'Tapnite srednjo številko za neposreden vnos strani.\n\nVnesite številko med 100 in 999 za skok na to stran.';

  @override
  String get onboardingSubpageNavigation => 'Navigacija Podstrani';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Če ima stran podstrani, boste videli tudi indikator:\n• 1/3 pomeni: prva podstran od treh razpoložljivih\n\nUporabite sredinske puščice za navigacijo med podstranmi:\n\n• Puščica gor: pojdi na naslednjo podstran\n• Puščica dol: pojdi na prejšnjo podstran\n\nPuščice so aktivne samo, ko so na voljo podstrani.';

  @override
  String get onboardingSwipe => 'Navigacija z Drsenjem';

  @override
  String get onboardingSwipeDescription =>
      'Enostavno se premikajte med stranmi z gestami, prikazanimi zgoraj.';

  @override
  String get onboardingClickableNumbers => 'Klikljive Številke Strani';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tapnite poudarjene številke strani za neposredno navigacijo na to stran\n\nStrani 100/1 Nacionalnega Televideo in 300/1 Regionalnega Televideo niso klikljive';

  @override
  String get onboardingShortcuts => 'Meni Bližnjic';

  @override
  String get onboardingShortcutsDescription =>
      'Hiter dostop do najpomembnejših strani Televideo.\n\nUporabite ta meni za neposreden skok na:\n• Stran 100: Nacionalni indeks\n• Stran 200: Novice\n.....\nPrav tako lahko iščete strani po naslovu z izbiro možnosti Išči stran';

  @override
  String get onboardingFavoritesList => 'Seznam Priljubljenih';

  @override
  String get onboardingFavoritesListDescription =>
      'Upravljajte svoje priljubljene strani:\n\n• Tapnite stran za odpiranje\n• Podrsajte levo za odstranitev\n• Tapnite svinčnik za urejanje opisa\n• Dolgo pritisnite za spremembo vrstnega reda\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Prilagodite aplikacijo svojim željam:\n\n• Naloži prvo priljubljeno ob zagonu: odločite se, s katero stranjo Televideo začeti\n• Tema: izberite med svetlo, temno ali samodejno\n• Samodejno osveževanje: omogočite samodejno nalaganje podstrani\n• Predpomnilnik: upravljajte trajanje predpomnilnika strani\n• Navodila: preglejte ta vodič kadarkoli želite\n• Varnostno kopiranje priljubljenih: shranite in obnovite svoje priljubljene\n• Nastavitve zasebnosti in ponastavitev: upravljajte ali ponastavite svoje izbire zasebnosti';

  @override
  String get dontShowAgain => 'Ne prikaži več';

  @override
  String get start => 'Začni';

  @override
  String get reset => 'Ponastavi';

  @override
  String backToPage(int pageNumber) {
    return 'Nazaj na stran $pageNumber';
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
  String get channelSelection => 'Izbira kanala';

  @override
  String get favoriteChannels => 'Priljubljeni kanali';

  @override
  String get reorder => 'Preurediti';

  @override
  String get searchChannelOrCountry => 'Iskanje kanala ali države...';

  @override
  String get showAllChannels => 'Prikaži vse kanale';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanalov na voljo iz $countries držav';
  }

  @override
  String get allChannels => 'Vsi kanali';

  @override
  String get noFavoriteChannelsFound => 'Ni najdenih priljubljenih kanalov';

  @override
  String get noChannelsFound => 'Ni najdenih kanalov';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name dodano med priljubljene';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name odstranjeno iz priljubljenih';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regij na voljo';
  }

  @override
  String get reorderFavorites => 'Preurediti priljubljene';
}
