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
  String get welcome => 'Tervetuloa!';

  @override
  String get welcomeSelectChannel => 'Valitse oletuskanava';

  @override
  String page(int pageNumber) {
    return 'Sivu $pageNumber';
  }

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
  String get channelCheckNoConnectivity =>
      'No connection available.\nMake sure you\'re not in airplane mode and that Wi-Fi or mobile data is on.';

  @override
  String get channelCheckNoInternet =>
      'Unable to reach the internet.\nCheck your network connection and try again.';

  @override
  String get channelCheckDnsError =>
      'Unable to resolve network addresses.\nCheck your connection or try a different network.';

  @override
  String get channelCheckChannelError =>
      'The channel is having connection issues.\nThe broadcaster\'s server may be temporarily unreachable. Please try again in a few minutes.';

  @override
  String get refreshing => 'Päivitetään...';

  @override
  String get lastUpdate => 'Viimeisin päivitys';

  @override
  String get updateAvailable => 'Päivitys saatavilla';

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
  String get startupPageOption => 'Aloitussivu';

  @override
  String get startupPageOptionLastPage => 'Viimeksi katsottu sivu (oletus)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Ensimmäinen suosikki (jos saatavilla)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Viimeisen kanavan aloitussivu';

  @override
  String get cacheDuration =>
      'Teksti-TV-sivukuvien välimuistin kesto (0 sekuntia poistaaksesi käytöstä)';

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
  String get support => 'Tuki';

  @override
  String get supportDescription => 'Ota yhteyttä apua varten';

  @override
  String get supportTitle => 'Olemme täällä auttamassa!';

  @override
  String get supportSubtitle =>
      'Kysymyksissä tai avun tarpeessa, älä epäröi ottaa yhteyttä';

  @override
  String get directContact => 'Suora Yhteys';

  @override
  String get emailLabel => 'Sähköposti';

  @override
  String get websiteLabel => 'Verkkosivusto';

  @override
  String get responseTime => 'Keskimääräinen vastausaika: 24-48 tuntia';

  @override
  String get faq => 'Usein Kysytyt Kysymykset';

  @override
  String get faqGeolocation => 'Miten paikannus toimii?';

  @override
  String get faqGeolocationAnswer =>
      'Sovellus käyttää laitteesi sijaintia tunnistaakseen automaattisesti alueesi ja näyttääkseen asiaankuuluvat paikalliset uutiset. Voit poistaa tämän toiminnon käytöstä sovelluksen asetuksista.';

  @override
  String get faqFavorites => 'Miten tallennan sivun suosikkeihin?';

  @override
  String get faqFavoritesAnswer =>
      'Katsellessasi sivua napauta tähtikuvaketta lisätäksesi sen suosikkeihin. Voit käyttää suosikkisivujasi päävalikosta.';

  @override
  String get faqTheme => 'Miten vaihdan sovelluksen teemaa?';

  @override
  String get faqThemeAnswer =>
      'Siirry sovelluksen asetuksiin ja valitse haluamasi teema (vaalea/tumma). Sovellus tukee myös automaattista asetusta järjestelmäasetusten perusteella.';

  @override
  String get faqOffline => 'Toimiiko sovellus offline-tilassa?';

  @override
  String get faqOfflineAnswer =>
      'Ei, aktiivinen internetyhteys vaaditaan reaaliaikaisten Teksti-TV-sivujen käyttämiseen.';

  @override
  String get faqReportProblem => 'Miten ilmoitan ongelmasta?';

  @override
  String get faqReportProblemAnswer =>
      'Lähetä yksityiskohtainen sähköposti osoitteeseen samuele@codebysam.it kuvaten kohtaamasi ongelma.';

  @override
  String get reportBugTitle => 'Ilmoita ongelmasta';

  @override
  String get reportBugInstructions =>
      'Ilmoittaessasi ongelmasta, sisällytä jos mahdollista:';

  @override
  String get reportBugItems =>
      'Sovelluksen versio\nLaitteen malli\nKäyttöjärjestelmä\nKuvakaappaus ongelmasta';

  @override
  String get developedBy => 'Kehittänyt CodeBySam';

  @override
  String get errorOpeningLink => 'Linkkiä ei voi avata';

  @override
  String get errorOpeningEmail => 'Sähköpostia ei voi avata';

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
  String get onboardingWelcome => 'Tervetuloa Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Sovellus RAI Teksti-TVn nopeaan ja helppoon selaamiseen';

  @override
  String get onboardingDefaultChannel => 'Valitse Oletuskanava';

  @override
  String get onboardingDefaultChannelDescription =>
      'Sovelluksen käynnistyessä sinua pyydetään valitsemaan suosikkikanavasi kaikista saatavilla olevista kanavista.\n\nVoit vaihtaa oletuskanavan milloin tahansa Asetukset-valikosta.';

  @override
  String get onboardingNavigation => 'Navigointi';

  @override
  String get onboardingNavigationDescription =>
      'Pyyhkäise vasemmalle tai oikealle vaihtaaksesi sivua, napauta numeroita navigoidaksesi suoraan';

  @override
  String get onboardingFavorites => 'Suosikit';

  @override
  String get onboardingFavoritesDescription =>
      'Tallenna useimmin vierailemasi sivut:\n\n• Napauta osoitettua kuvaketta lisätäksesi nykyisen sivun\n• Napauta uudelleen poistaaksesi sen suosikeista\n• Kuvake muuttuu punaiseksi, kun sivu on suosikeissa\n\nVoit tallentaa sekä kansallisia että alueellisia sivuja.';

  @override
  String get onboardingRegions => 'Kanavat Kaikkialta Euroopasta';

  @override
  String get onboardingRegionsDescription =>
      'Valitse ja järjestä suosikkikanavasi kaikkialta Euroopasta.\n\nEtsi kanavan nimen tai maan nimen mukaan.\n\nVoit käyttää teksti-tv:tä Italiasta, Saksasta, Itävallasta, Sveitsistä ja monista muista Euroopan maista!';

  @override
  String get onboardingAutoRefresh => 'Automaattinen Päivitys';

  @override
  String get onboardingAutoRefreshDescription =>
      'Kun automaattinen päivitys on aktiivinen, sivunumeron ympärillä oleva ympyrä täyttyy asteittain:\n\nVoit muuttaa päivitysaikaa asetuksissa\n\nIlmaisin näkyy vain, kun alasivuja on saatavilla ja automaattinen päivitys on aktiivinen.';

  @override
  String get onboardingPause => 'Keskeytä Päivitys';

  @override
  String get onboardingPauseDescription =>
      'Voit keskeyttää alasivujen automaattisen päivityksen:\n\n• Napauta missä tahansa sivulla, jossa ei ole napsautettavia numeroita\n• Näet ⏸️ kuvakkeen ilmestyvän osoittamaan, että päivitys on keskeytetty\n• Napauta uudelleen jatkaaksesi päivitystä (▶️ kuvake)\n\nTämä toiminto on hyödyllinen, kun haluat lukea alasivua rauhassa ilman, että se vaihtuu automaattisesti.';

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
      'Napauta korostettuja sivunumeroita siirtyäksesi suoraan kyseiselle sivulle\n\n';

  @override
  String get onboardingShortcuts => 'Valikko Pikakuvakkeet';

  @override
  String get onboardingShortcutsDescription =>
      'Pääse nopeasti tärkeimmille Teksti-TV-sivuille.\n\nKäytä tätä valikkoa siirtyäksesi suoraan:\n• Sivu 100: Kansallinen hakemisto\n• Sivu 200: Uutiset\n.....\nVoit myös hakea sivuja otsikon perusteella valitsemalla Hae sivu -vaihtoehdon';

  @override
  String get onboardingFavoritesList => 'Suosikkilista';

  @override
  String get onboardingFavoritesListDescription =>
      'Hallitse suosikkisivujasi:\n\n• Napauta sivua avataksesi sen\n• Pyyhkäise vasemmalle poistaaksesi sen\n• Napauta kynää muokataksesi kuvausta\n• Paina pitkään muuttaaksesi järjestystä\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Mukauta sovellus mieltymystesi mukaan:\n\n• Lataa ensimmäinen suosikki käynnistettäessä: päätä millä Teksti-TV-sivulla aloitat\n• Teema: valitse vaalean, tumman tai automaattisen väliltä\n• Automaattinen päivitys: ota käyttöön alasivujen automaattinen lataus\n• Välimuisti: hallitse sivujen välimuistin kestoa\n• Ohjeet: katso tämä opastus milloin haluat\n• Varmuuskopioi suosikit: tallenna ja palauta suosikkisi\n• Yksityisyysasetukset ja nollaus: hallitse tai nollaa yksityisyysvalintasi';

  @override
  String get dontShowAgain => 'Älä näytä uudelleen';

  @override
  String get start => 'Aloita';

  @override
  String get reset => 'Nollaa';

  @override
  String get resetInitialChannel => 'Nollaa alkukanava';

  @override
  String get resetInitialChannelDescription =>
      'Näytä kanavan valintaikkuna uudelleen seuraavalla käynnistyskerralla';

  @override
  String get resetCompleted => 'Nollaus valmis';

  @override
  String get resetInitialChannelMessage =>
      'Alkukanava on nollattu.\n\nSeuraavalla sovelluksen käynnistyskerralla sinua pyydetään valitsemaan oletuskanavasi uudelleen.\n\nKäynnistetään sovellus uudelleen nyt...';

  @override
  String get selectYourChannel =>
      'Valitse oletus tekstitelevisiokanavasi.\nVoit vaihtaa sen milloin tahansa.';

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

  @override
  String get countryIT => 'Italia';

  @override
  String get countryDE => 'Saksa';

  @override
  String get countryAT => 'Itävalta';

  @override
  String get countryCH => 'Sveitsi';

  @override
  String get countryES => 'Espanja';

  @override
  String get countryPT => 'Portugali';

  @override
  String get countryNL => 'Alankomaat';

  @override
  String get countryPL => 'Puola';

  @override
  String get countrySE => 'Ruotsi';

  @override
  String get countryFI => 'Suomi';

  @override
  String get countryDK => 'Tanska';

  @override
  String get countryCZ => 'Tšekki';

  @override
  String get countryHR => 'Kroatia';

  @override
  String get countryBA => 'Bosnia ja Hertsegovina';

  @override
  String get countryHU => 'Unkari';

  @override
  String get countryIS => 'Islanti';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countryUA => 'Ukraina';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Premium-ominaisuudet';

  @override
  String get premiumSubtitle => 'Paranna Teletext Europe -kokemustasi';

  @override
  String get premiumNoAds => 'Ei mainoksia';

  @override
  String get premiumNoAdsDescription =>
      'Poista kaikki bannerimainokset ja välisivumainokset';

  @override
  String get premiumFasterExperience => 'Sujuvampi kokemus';

  @override
  String get premiumFasterExperienceDescription =>
      'Navigoi ilman mainoskatkosia';

  @override
  String get premiumSupportDevelopment => 'Tue kehitystä';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Auta pitämään sovellus ajan tasalla uusilla kanavilla ja ominaisuuksilla';

  @override
  String get premiumActivated => 'Premium aktivoitu';

  @override
  String get premiumThankYou => 'Kiitos tuestasi!';

  @override
  String get premiumOneTimePurchase => 'Neljännesvuositilaus';

  @override
  String get premiumLifetime => 'Uusiutuu automaattisesti 3 kuukauden välein';

  @override
  String get purchasePremium => 'Tilaa nyt';

  @override
  String get restorePurchases => 'Palauta tilaus';

  @override
  String get premiumProductNotAvailable =>
      'Premium-tilaus ei ole tällä hetkellä saatavilla';

  @override
  String get premiumPurchaseError => 'Virhe tilauksessa. Yritä uudelleen.';

  @override
  String get premiumRestoreSuccess => 'Tilaus palautettu onnistuneesti!';

  @override
  String get premiumRestoreNoPurchases => 'Aktiivista tilausta ei löytynyt';

  @override
  String get premiumRestoreError => 'Virhe tilauksen palauttamisessa';

  @override
  String get premiumLegalNote =>
      'Kuukausi- tai neljännesvuositilaus, joka uusiutuu automaattisesti. Voit peruuttaa milloin tahansa Apple/Google-tilin asetuksista. Maksu veloitetaan vahvistuksen yhteydessä. Tilaus uusiutuu automaattisesti (kuukausittain tai 3 kuukauden välein valitusta suunnasta riippuen).';

  @override
  String get goPremium => 'Hanki Premium';

  @override
  String get premiumChoosePlan => 'Valitse suunnitelmasi';

  @override
  String get premiumMonthly => 'Kuukausittain';

  @override
  String get premiumQuarterly => 'Neljännesvuosittain';

  @override
  String get premiumPerMonth => 'kuukaudessa';

  @override
  String get premiumEvery3Months => '3 kuukauden välein';

  @override
  String premiumSavePercent(String percent) {
    return 'Säästä $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Kuukausisuunnitelma';

  @override
  String get premiumQuarterlyPlan => 'Kvartaalisuunnitelma';

  @override
  String get premiumSubscriptionInfo => 'Tilauksen tiedot';

  @override
  String get premiumPrivacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get premiumTermsOfUse => 'Käyttöehdot (EULA)';

  @override
  String get premiumLoadingSubscriptions => 'Loading subscription options...';

  @override
  String get premiumLoadErrorRetry =>
      'Unable to load subscription options. Please try again.';
}
