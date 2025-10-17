// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Sivun kuvaa ei voida ladata.\nYritä uudelleen hetken kuluttua.';

  @override
  String get pageNotAvailable => 'Pyydetty sivu ei ole saatavilla';

  @override
  String get pageLoadError =>
      'Sivun lataamisessa tapahtui virhe.\nPalaa sivulle 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Sivu $pageNumber ei ole saatavilla alueelle $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Sivu $pageNumber ei ole saatavilla alueelle $regionName.\nKokeile toista numeroa väliltä 100-999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Ei enempää sivuja saatavilla alueelle $regionName';
  }

  @override
  String get noMorePages => 'Ei enempää sivuja saatavilla';

  @override
  String get invalidSubpageNumber => 'Virheellinen alasivun numero';

  @override
  String subpageError(int current, int total) {
    return 'Virhe ladattaessa alasivua $current/$total';
  }

  @override
  String get swipePrevious => '← Edellinen';

  @override
  String get swipeNext => 'Seuraava →';

  @override
  String get swipeNextUp => 'Seuraava ↑';

  @override
  String get swipePreviousDown => 'Edellinen ↓';

  @override
  String get swipeRefresh => 'Päivitä ↻';

  @override
  String get pageAddedToFavorites => 'Sivu lisätty suosikkeihin';

  @override
  String get pageRemovedFromFavorites => 'Sivu poistettu suosikeista';

  @override
  String get editDescription => 'Muokkaa kuvausta';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Sivu $pageNumber - $regionName';
  }

  @override
  String get description => 'Kuvaus';

  @override
  String get enterCustomDescription => 'Syötä mukautettu kuvaus';

  @override
  String get restoreHint =>
      'Vinkki: paina pitkään \"PALAUTA\"-painiketta palataksesi oletuskuvaukseen.';

  @override
  String get restore => 'PALAUTA';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get searchHint => 'Hae sivua...';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get settings => 'Asetukset';

  @override
  String get enterPageNumber => 'Syötä sivunumero';

  @override
  String pageNumberRange(int minPage) {
    return 'Numero väliltä $minPage-999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Suosikkilista';

  @override
  String get confirmRemoval => 'Vahvista poisto';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Haluatko varmasti poistaa $description suosikeista?';
  }

  @override
  String get remove => 'Poista';

  @override
  String get edit => 'Muokkaa';

  @override
  String get close => 'Sulje';

  @override
  String get noFavorites => 'Ei suosikkeja';

  @override
  String get useFavoriteIcon =>
      'Käytä ❤️ kuvaketta lisätäksesi sivuja suosikkeihin';

  @override
  String loadingPage(int pageNumber) {
    return 'Ladataan sivua $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Ei sivua lisättäväksi suosikkeihin';

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
  String get loading => 'Ladataan...';

  @override
  String get error => 'Virhe';

  @override
  String errorWithMessage(String message) {
    return 'Virhe: $message';
  }

  @override
  String get retry => 'Yritä uudelleen';

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
      'Jos käytössä, ensimmäinen suosikki listalta ladataan sovelluksen käynnistyessä';

  @override
  String get cacheDuration =>
      'Televideo-sivukuvien välimuistin kesto (0 sekuntia poistaaksesi käytöstä)';

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
      'Näytä ohjeet aina kun avaat sovelluksen';

  @override
  String get showInstructions => 'Näytä ohjeet';

  @override
  String get showInstructionsDescription => 'Katso sovelluksen käyttöohjeet';

  @override
  String get backupFavorites => 'Varmuuskopioi suosikit';

  @override
  String get backupFavoritesDescription => 'Tallenna ja palauta suosikkisi';

  @override
  String get privacySettings => 'Yksityisyysasetukset';

  @override
  String get privacySettingsDescription =>
      'Muuta yksityisyysasetuksiasi mainoksia varten';

  @override
  String get resetPrivacySettings => 'Nollaa yksityisyysasetukset';

  @override
  String get resetPrivacySettingsDescription =>
      'Nollaa kaikki yksityisyysasetukset';

  @override
  String get resetPrivacyConfirm =>
      'Haluatko varmasti nollata yksityisyysasetukset? Sinulta pyydetään suostumus uudelleen seuraavan kerran käynnistäessäsi sovelluksen.';

  @override
  String get privacySettingsUnavailable =>
      'Yksityisyysasetukset eivät ole tällä hetkellä saatavilla';

  @override
  String get privacySettingsReset =>
      'Yksityisyysasetukset nollattu. Käynnistä sovellus uudelleen uutta suostumusta varten.';

  @override
  String get version => 'Versio';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Tervetuloa TeleRetrò Italiaan';

  @override
  String get onboardingWelcomeDescription =>
      'Sovellus RAI Televideon nopeaan ja helppoon selaamiseen';

  @override
  String get onboardingNavigation => 'Navigointi';

  @override
  String get onboardingNavigationDescription =>
      'Pyyhkäise vasemmalle tai oikealle vaihtaaksesi sivua, napauta numeroita navigoidaksesi suoraan';

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
  String get onboardingPageSelector => 'Sivunvalitsin';

  @override
  String get onboardingPageSelectorDescription =>
      'Napauta keskimmäistä numeroa syöttääksesi sivun suoraan.\n\nSyötä numero väliltä 100-999 siirtyäksesi kyseiselle sivulle.';

  @override
  String get onboardingSubpageNavigation => 'Alasivujen Navigointi';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Jos sivulla on alasivuja, näet myös ilmaisimen:\n• 1/3 tarkoittaa: ensimmäinen alasivu kolmesta saatavilla olevasta\n\nKäytä keskellä olevia nuolia navigoidaksesi alasivujen välillä:\n\n• Nuoli ylös: siirry seuraavalle alasivulle\n• Nuoli alas: siirry edelliselle alasivulle\n\nNuolet ovat aktiivisia vain, kun alasivuja on saatavilla.';

  @override
  String get onboardingSwipe => 'Pyyhkäisynavigointi';

  @override
  String get onboardingSwipeDescription =>
      'Navigoi helposti sivujen välillä yllä näytetyillä eleillä.';

  @override
  String get onboardingClickableNumbers => 'Napsautettavat Sivunumerot';

  @override
  String get onboardingClickableNumbersDescription =>
      'Napauta korostettuja sivunumeroita siirtyäksesi suoraan kyseiselle sivulle\n\nSivut 100/1 Kansallisesta Televideosta ja 300/1 Alueellisesta Televideosta eivät ole napsautettavia';

  @override
  String get onboardingShortcuts => 'Valikko Pikakuvakkeet';

  @override
  String get onboardingShortcutsDescription =>
      'Pääse nopeasti tärkeimmille Televideo-sivuille.\n\nKäytä tätä valikkoa siirtyäksesi suoraan:\n• Sivu 100: Kansallinen hakemisto\n• Sivu 200: Uutiset\n.....\nVoit myös hakea sivuja otsikon perusteella valitsemalla Hae sivu -vaihtoehdon';

  @override
  String get onboardingFavoritesList => 'Suosikkilista';

  @override
  String get onboardingFavoritesListDescription =>
      'Hallitse suosikkisivujasi:\n\n• Napauta sivua avataksesi sen\n• Pyyhkäise vasemmalle poistaaksesi sen\n• Napauta kynää muokataksesi kuvausta\n• Paina pitkään muuttaaksesi järjestystä\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Mukauta sovellus mieltymystesi mukaan:\n\n• Lataa ensimmäinen suosikki käynnistettäessä: päätä millä Televideo-sivulla aloitat\n• Teema: valitse vaalean, tumman tai automaattisen väliltä\n• Automaattinen päivitys: ota käyttöön alasivujen automaattinen lataus\n• Välimuisti: hallitse sivujen välimuistin kestoa\n• Ohjeet: katso tämä opastus milloin haluat\n• Varmuuskopioi suosikit: tallenna ja palauta suosikkisi\n• Yksityisyysasetukset ja nollaus: hallitse tai nollaa yksityisyysvalintasi';

  @override
  String get dontShowAgain => 'Älä näytä uudelleen';

  @override
  String get start => 'Aloita';

  @override
  String get reset => 'Nollaa';

  @override
  String backToPage(int pageNumber) {
    return 'Takaisin sivulle $pageNumber';
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
  String get channelSelection => 'Kanavan valinta';

  @override
  String get favoriteChannels => 'Suosikkikanavat';

  @override
  String get reorder => 'Järjestä uudelleen';

  @override
  String get searchChannelOrCountry => 'Hae kanavaa tai maata...';

  @override
  String get showAllChannels => 'Näytä kaikki kanavat';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanavaa saatavilla $countries maasta';
  }

  @override
  String get allChannels => 'Kaikki kanavat';

  @override
  String get noFavoriteChannelsFound => 'Suosikkikanavia ei löytynyt';

  @override
  String get noChannelsFound => 'Kanavia ei löytynyt';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name lisätty suosikkeihin';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name poistettu suosikeista';
  }

  @override
  String regionsAvailable(int count) {
    return '$count aluetta saatavilla';
  }

  @override
  String get reorderFavorites => 'Järjestä suosikit uudelleen';
}
