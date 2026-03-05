// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bosnian (`bs`).
class AppLocalizationsBs extends AppLocalizations {
  AppLocalizationsBs([String locale = 'bs']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Dobrodošli!';

  @override
  String get welcomeSelectChannel => 'Odaberite zadani kanal';

  @override
  String page(int pageNumber) {
    return 'Stranica $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Nije moguće učitati sliku stranice.\nPokušajte ponovo za trenutak.';

  @override
  String get pageNotAvailable => 'Tražena stranica nije dostupna';

  @override
  String get pageLoadError =>
      'Došlo je do greške prilikom učitavanja stranice.\nPovratak na stranicu 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Stranica $pageNumber nije dostupna za $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Stranica $pageNumber nije dostupna za $regionName.\nPokušajte s drugim brojem između 100 i 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Nema više dostupnih stranica za $regionName';
  }

  @override
  String get noMorePages => 'Nema više dostupnih stranica';

  @override
  String get invalidSubpageNumber => 'Nevažeći broj podstranice';

  @override
  String subpageError(int current, int total) {
    return 'Greška pri učitavanju podstranice $current od $total';
  }

  @override
  String get swipePrevious => '← Prethodna';

  @override
  String get swipeNext => 'Sljedeća →';

  @override
  String get swipeNextUp => 'Sljedeća ↑';

  @override
  String get swipePreviousDown => 'Prethodna ↓';

  @override
  String get swipeRefresh => 'Osvježi ↻';

  @override
  String get pageAddedToFavorites => 'Stranica dodana u favorite';

  @override
  String get pageRemovedFromFavorites => 'Stranica uklonjena iz favorita';

  @override
  String get editDescription => 'Uredi opis';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Stranica $pageNumber - $regionName';
  }

  @override
  String get description => 'Opis';

  @override
  String get enterCustomDescription => 'Unesite prilagođeni opis';

  @override
  String get restoreHint =>
      'Savjet: dugo pritisnite dugme \"VRATI\" za povratak na zadani opis.';

  @override
  String get restore => 'VRATI';

  @override
  String get cancel => 'Otkaži';

  @override
  String get save => 'Sačuvaj';

  @override
  String get searchHint => 'Pretraži stranicu...';

  @override
  String get noResults => 'Nema rezultata';

  @override
  String get settings => 'Postavke';

  @override
  String get enterPageNumber => 'Unesite broj stranice';

  @override
  String pageNumberRange(int minPage) {
    return 'Broj od $minPage do 999';
  }

  @override
  String get ok => 'U redu';

  @override
  String get favoritesList => 'Lista favorita';

  @override
  String get confirmRemoval => 'Potvrdi uklanjanje';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Da li stvarno želite ukloniti $description iz favorita?';
  }

  @override
  String get remove => 'Ukloni';

  @override
  String get edit => 'Uredi';

  @override
  String get close => 'Zatvori';

  @override
  String get noFavorites => 'Nema favorita';

  @override
  String get useFavoriteIcon =>
      'Koristite ikonu ❤️ za dodavanje stranica u favorite';

  @override
  String loadingPage(int pageNumber) {
    return 'Učitavanje stranice $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Nema stranice za dodavanje u favorite';

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
  String get loading => 'Učitavanje...';

  @override
  String get error => 'Greška';

  @override
  String errorWithMessage(String message) {
    return 'Greška: $message';
  }

  @override
  String get retry => 'Pokušaj ponovo';

  @override
  String get next => 'Sljedeća';

  @override
  String get previous => 'Prethodna';

  @override
  String get pageNotFound => 'Stranica nije pronađena';

  @override
  String get networkError => 'Mrežna greška';

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
  String get startupPageOption => 'Početna stranica';

  @override
  String get startupPageOptionLastPage =>
      'Posljednja pregledana stranica (zadano)';

  @override
  String get startupPageOptionFirstFavorite => 'Prvi favorit (ako je dostupan)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Početna stranica zadnjeg kanala';

  @override
  String get cacheDuration =>
      'Trajanje keša slika Teletekst stranica (0 sekundi za onemogućavanje)';

  @override
  String get seconds => 'sekundi';

  @override
  String get autoRefreshDescription => 'Automatski osvježi podstranice';

  @override
  String get refreshInterval => 'Interval osvježavanja';

  @override
  String get showOnboardingAtStartup => 'Prikaži uputstva pri pokretanju';

  @override
  String get showOnboardingAtStartupDescription =>
      'Prikaži uputstva svaki put kada otvorite aplikaciju';

  @override
  String get showInstructions => 'Prikaži uputstva';

  @override
  String get showInstructionsDescription =>
      'Pregledajte uputstva za korištenje aplikacije';

  @override
  String get backupFavorites => 'Backup favorita';

  @override
  String get backupFavoritesDescription => 'Sačuvajte i vratite svoje favorite';

  @override
  String get support => 'Podrška';

  @override
  String get supportDescription => 'Kontaktirajte nas za pomoć';

  @override
  String get supportTitle => 'Tu smo da pomognemo!';

  @override
  String get supportSubtitle =>
      'Za bilo kakva pitanja ili pomoć, ne ustručavajte se kontaktirati nas';

  @override
  String get directContact => 'Direktan Kontakt';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get websiteLabel => 'Web stranica';

  @override
  String get responseTime => 'Prosječno vrijeme odgovora: 24-48 sati';

  @override
  String get faq => 'Često Postavljana Pitanja';

  @override
  String get faqGeolocation => 'Kako funkcionira geolokacija?';

  @override
  String get faqGeolocationAnswer =>
      'Aplikacija koristi lokaciju vašeg uređaja za automatsku identifikaciju vaše regije i prikaz relevantnih lokalnih vijesti. Ovu funkciju možete onemogućiti u postavkama aplikacije.';

  @override
  String get faqFavorites => 'Kako spremiti stranicu u favorite?';

  @override
  String get faqFavoritesAnswer =>
      'Dok gledate stranicu, dodirnite ikonu zvijezde da je dodate u favorite. Možete pristupiti svojim omiljenim stranicama iz glavnog izbornika.';

  @override
  String get faqTheme => 'Kako promijeniti temu aplikacije?';

  @override
  String get faqThemeAnswer =>
      'Idite u postavke aplikacije i odaberite željenu temu (svijetla/tamna). Aplikacija također podržava automatsko postavljanje na osnovu postavki sistema.';

  @override
  String get faqOffline => 'Radi li aplikacija offline?';

  @override
  String get faqOfflineAnswer =>
      'Ne, aktivna internet veza je potrebna za pristup stranicama Teleteksta u stvarnom vremenu.';

  @override
  String get faqReportProblem => 'Kako prijaviti problem?';

  @override
  String get faqReportProblemAnswer =>
      'Pošaljite detaljnu e-poruku na samuele@codebysam.it opisujući problem.';

  @override
  String get reportBugTitle => 'Prijavite problem';

  @override
  String get reportBugInstructions =>
      'Prilikom prijavljivanja problema, uključite ako je moguće:';

  @override
  String get reportBugItems =>
      'Verzija aplikacije\nModel uređaja\nOperativni sistem\nSnimak ekrana problema';

  @override
  String get developedBy => 'Razvio CodeBySam';

  @override
  String get errorOpeningLink => 'Nije moguće otvoriti vezu';

  @override
  String get errorOpeningEmail => 'Nije moguće otvoriti e-poštu';

  @override
  String get privacySettings => 'Postavke privatnosti';

  @override
  String get privacySettingsDescription =>
      'Izmijenite svoje postavke privatnosti za oglase';

  @override
  String get resetPrivacySettings => 'Resetuj postavke privatnosti';

  @override
  String get resetPrivacySettingsDescription =>
      'Potpuno resetuj postavke privatnosti';

  @override
  String get resetPrivacyConfirm =>
      'Da li stvarno želite resetovati postavke privatnosti? Bit ćete ponovo upitani za pristanak pri sljedećem pokretanju aplikacije.';

  @override
  String get privacySettingsUnavailable =>
      'Postavke privatnosti trenutno nisu dostupne';

  @override
  String get privacySettingsReset =>
      'Postavke privatnosti su resetovane. Ponovo pokrenite aplikaciju za novi pristanak.';

  @override
  String get version => 'Verzija';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Dobrodošli u Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za brzo i jednostavno konsultovanje RAI Teletekst';

  @override
  String get onboardingDefaultChannel => 'Odaberi Zadani Kanal';

  @override
  String get onboardingDefaultChannelDescription =>
      'Prilikom pokretanja aplikacije bit ćete zamoljeni da odaberete svoj preferirani kanal među svim dostupnim kanalima.\n\nMožete promijeniti zadani kanal u bilo kojem trenutku iz izbornika Postavke.';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Prevucite lijevo ili desno za promjenu stranice, dodirnite brojeve za direktnu navigaciju';

  @override
  String get onboardingFavorites => 'Favoriti';

  @override
  String get onboardingFavoritesDescription =>
      'Spremite stranice koje najčešće posjećujete:\n\n• Dodirnite označenu ikonu za dodavanje trenutne stranice\n• Dodirnite ponovno za uklanjanje iz favorita\n• Ikona postaje crvena kada je stranica u favoritima\n\nMožete spremiti i nacionalne i regionalne stranice.';

  @override
  String get onboardingRegions => 'Kanali iz Cijele Evrope';

  @override
  String get onboardingRegionsDescription =>
      'Odaberite i organizujte svoje omiljene kanale iz cijele Evrope.\n\nPretražujte prema nazivu kanala ili nazivu zemlje.\n\nMožete pristupiti teletekstu iz Italije, Njemačke, Austrije, Švicarske i mnogih drugih evropskih zemalja!';

  @override
  String get onboardingAutoRefresh => 'Automatsko Osvježavanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Kada je automatsko osvježavanje aktivno, krug oko broja stranice se postepeno puni:\n\nMožete promijeniti vrijeme osvježavanja u postavkama\n\nIndikator je vidljiv samo kada su podstranice dostupne i automatsko osvježavanje je aktivno.';

  @override
  String get onboardingPause => 'Pauziraj Osvježavanje';

  @override
  String get onboardingPauseDescription =>
      'Možete pauzirati automatsko osvježavanje podstranica:\n\n• Dodirnite bilo gdje na stranici gdje nema klikabilnih brojeva\n• Vidjet ćete ikonu ⏸️ koja označava da je osvježavanje pauzirano\n• Dodirnite ponovno za nastavak osvježavanja (ikona ▶️)\n\nOva funkcija je korisna kada želite mirno čitati podstranicu bez da se automatski mijenja.';

  @override
  String get onboardingPageSelector => 'Odabir Stranice';

  @override
  String get onboardingPageSelectorDescription =>
      'Dodirnite središnji broj za direktan unos stranice.\n\nUnesite broj između 100 i 999 za skok na tu stranicu.';

  @override
  String get onboardingSubpageNavigation => 'Navigacija Podstranica';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Ako stranica ima podstranice, vidjet ćete i indikator:\n• 1/3 znači: prva podstranica od tri dostupne\n\nKoristite središnje strelice za navigaciju između podstranica:\n\n• Strelica gore: idi na sljedeću podstranicu\n• Strelica dole: idi na prethodnu podstranicu\n\nStrelice su aktivne samo kada su dostupne podstranice.';

  @override
  String get onboardingSwipe => 'Navigacija Prevlačenjem';

  @override
  String get onboardingSwipeDescription =>
      'Jednostavno se krećite između stranica pomoću gore prikazanih gestova.';

  @override
  String get onboardingClickableNumbers => 'Brojevi Stranica na Klik';

  @override
  String get onboardingClickableNumbersDescription =>
      'Dodirnite istaknute brojeve stranica za direktnu navigaciju na tu stranicu\n\n';

  @override
  String get onboardingShortcuts => 'Meni Prečica';

  @override
  String get onboardingShortcutsDescription =>
      'Brzi pristup najvažnijim Teletekst stranicama.\n\nKoristite ovaj meni za direktan skok na:\n• Stranica 100: Nacionalni indeks\n• Stranica 200: Vijesti\n.....\nMožete također pretraživati stranice po naslovu odabirom opcije Pretraži stranicu';

  @override
  String get onboardingFavoritesList => 'Lista Favorita';

  @override
  String get onboardingFavoritesListDescription =>
      'Upravljajte svojim omiljenim stranicama:\n\n• Dodirnite stranicu za otvaranje\n• Prevucite ulijevo za uklanjanje\n• Dodirnite olovku za uređivanje opisa\n• Dugo pritisnite za promjenu redoslijeda\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Prilagodite aplikaciju prema svojim preferencama:\n\n• Učitaj prvi favorit pri pokretanju: odlučite s kojom Teletekst stranicom početi\n• Tema: odaberite između svijetle, tamne ili automatske\n• Automatsko osvježavanje: omogućite automatsko učitavanje podstranica\n• Keš: upravljajte trajanjem keša stranica\n• Uputstva: pregledajte ovaj vodič kad god želite\n• Backup favorita: sačuvajte i vratite svoje favorite\n• Postavke privatnosti i resetovanje: upravljajte ili resetujte svoje izbore privatnosti';

  @override
  String get dontShowAgain => 'Ne prikazuj ponovo';

  @override
  String get start => 'Započni';

  @override
  String get reset => 'Resetuj';

  @override
  String get resetInitialChannel => 'Resetuj početni kanal';

  @override
  String get resetInitialChannelDescription =>
      'Prikaži dijalog za odabir kanala ponovo pri sljedećem pokretanju';

  @override
  String get resetCompleted => 'Resetovanje završeno';

  @override
  String get resetInitialChannelMessage =>
      'Početni kanal je resetovan.\n\nPri sljedećem pokretanju aplikacije bit ćete zamoljeni da ponovo odaberete zadani kanal.\n\nRestartovanje aplikacije sada...';

  @override
  String get selectYourChannel =>
      'Odaberite svoj zadani kanal Teleteksta.\nMožete ga promijeniti u bilo kom trenutku.';

  @override
  String backToPage(int pageNumber) {
    return 'Nazad na stranicu $pageNumber';
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
  String get channelSelection => 'Izbor kanala';

  @override
  String get favoriteChannels => 'Omiljeni kanali';

  @override
  String get reorder => 'Promijeni redoslijed';

  @override
  String get searchChannelOrCountry => 'Pretraži kanal ili zemlju...';

  @override
  String get showAllChannels => 'Prikaži sve kanale';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanala dostupno iz $countries zemalja';
  }

  @override
  String get allChannels => 'Svi kanali';

  @override
  String get noFavoriteChannelsFound => 'Nema pronađenih omiljenih kanala';

  @override
  String get noChannelsFound => 'Nema pronađenih kanala';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name dodato u omiljene';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name uklonjeno iz omiljenih';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regija dostupno';
  }

  @override
  String get reorderFavorites => 'Promijeni redoslijed omiljenih';

  @override
  String get countryIT => 'Italija';

  @override
  String get countryDE => 'Njemačka';

  @override
  String get countryAT => 'Austrija';

  @override
  String get countryCH => 'Švicarska';

  @override
  String get countryES => 'Španija';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Nizozemska';

  @override
  String get countryPL => 'Poljska';

  @override
  String get countrySE => 'Švedska';

  @override
  String get countryFI => 'Finska';

  @override
  String get countryDK => 'Danska';

  @override
  String get countryCZ => 'Češka';

  @override
  String get countryHR => 'Hrvatska';

  @override
  String get countryBA => 'Bosna i Hercegovina';

  @override
  String get countryHU => 'Mađarska';

  @override
  String get countryIS => 'Island';

  @override
  String get countrySI => 'Slovenija';

  @override
  String get countryUA => 'Ukrajina';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Premium funkcije';

  @override
  String get premiumSubtitle => 'Poboljšajte svoje Teletext Europe iskustvo';

  @override
  String get premiumNoAds => 'Bez oglasa';

  @override
  String get premiumNoAdsDescription =>
      'Uklonite sve oglasne bannere i interstitial oglase';

  @override
  String get premiumFasterExperience => 'Ugodnije iskustvo';

  @override
  String get premiumFasterExperienceDescription =>
      'Navigirajte bez prekida zbog oglasa';

  @override
  String get premiumSupportDevelopment => 'Podržite razvoj';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Pomozite održavati aplikaciju ažurnom s novim kanalima i funkcijama';

  @override
  String get premiumActivated => 'Premium aktiviran';

  @override
  String get premiumThankYou => 'Hvala vam na podršci!';

  @override
  String get premiumOneTimePurchase => 'Tromjesečna pretplata';

  @override
  String get premiumLifetime => 'Automatska obnova svakih 3 mjeseca';

  @override
  String get purchasePremium => 'Pretplati se sada';

  @override
  String get restorePurchases => 'Vrati pretplatu';

  @override
  String get premiumProductNotAvailable =>
      'Premium pretplata trenutno nije dostupna';

  @override
  String get premiumPurchaseError =>
      'Greška tokom pretplate. Pokušajte ponovo.';

  @override
  String get premiumRestoreSuccess => 'Pretplata uspješno vraćena!';

  @override
  String get premiumRestoreNoPurchases => 'Nije pronađena aktivna pretplata';

  @override
  String get premiumRestoreError => 'Greška pri vraćanju pretplate';

  @override
  String get premiumLegalNote =>
      'Mjesečna ili tromjesečna pretplata s automatskom obnovom. Možete otkazati bilo kada iz postavki vašeg Apple/Google računa. Naplata će se izvršiti pri potvrdi. Pretplata se automatski obnavlja (mjesečno ili svakih 3 mjeseca ovisno o odabranom planu).';

  @override
  String get goPremium => 'Postani Premium';

  @override
  String get premiumChoosePlan => 'Odaberite plan';

  @override
  String get premiumMonthly => 'Mjesečno';

  @override
  String get premiumQuarterly => 'Tromjesečno';

  @override
  String get premiumPerMonth => 'po mjesecu';

  @override
  String get premiumEvery3Months => 'svakih 3 mjeseca';

  @override
  String premiumSavePercent(String percent) {
    return 'Uštedite $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Mjesečni plan';

  @override
  String get premiumQuarterlyPlan => 'Tromjesečni plan';

  @override
  String get premiumSubscriptionInfo => 'Informacije o pretplati';

  @override
  String get premiumPrivacyPolicy => 'Pravila o privatnosti';

  @override
  String get premiumTermsOfUse => 'Uslovi korištenja (EULA)';
}
