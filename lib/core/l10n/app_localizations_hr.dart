// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

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
      'Nije moguće učitati sliku stranice.\nPokušajte ponovno za trenutak.';

  @override
  String get pageNotAvailable => 'Tražena stranica nije dostupna';

  @override
  String get pageLoadError =>
      'Došlo je do pogreške prilikom učitavanja stranice.\nPovratak na stranicu 100';

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
    return 'Pogreška pri učitavanju podstranice $current od $total';
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
      'Savjet: dugo pritisnite gumb \"VRATI\" za povratak na zadani opis.';

  @override
  String get restore => 'VRATI';

  @override
  String get cancel => 'Otkaži';

  @override
  String get save => 'Spremi';

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
  String get favoritesList => 'Popis favorita';

  @override
  String get confirmRemoval => 'Potvrdi uklanjanje';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Želite li stvarno ukloniti $description iz favorita?';
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
  String get error => 'Pogreška';

  @override
  String errorWithMessage(String message) {
    return 'Pogreška: $message';
  }

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get next => 'Sljedeća';

  @override
  String get previous => 'Prethodna';

  @override
  String get pageNotFound => 'Stranica nije pronađena';

  @override
  String get networkError => 'Mrežna pogreška';

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
      'Ako je omogućeno, prvi favorit s popisa će se učitati pri pokretanju aplikacije';

  @override
  String get cacheDuration =>
      'Trajanje predmemorije slika Teletekst stranica (0 sekundi za onemogućavanje)';

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
      'Pregledajte upute za korištenje aplikacije';

  @override
  String get backupFavorites => 'Sigurnosna kopija favorita';

  @override
  String get backupFavoritesDescription => 'Spremite i vratite svoje favorite';

  @override
  String get privacySettings => 'Postavke privatnosti';

  @override
  String get privacySettingsDescription =>
      'Izmijenite svoje postavke privatnosti za oglase';

  @override
  String get resetPrivacySettings => 'Poništi postavke privatnosti';

  @override
  String get resetPrivacySettingsDescription =>
      'Potpuno poništi postavke privatnosti';

  @override
  String get resetPrivacyConfirm =>
      'Želite li stvarno poništiti postavke privatnosti? Bit ćete ponovno upitani za pristanak pri sljedećem pokretanju aplikacije.';

  @override
  String get privacySettingsUnavailable =>
      'Postavke privatnosti trenutno nisu dostupne';

  @override
  String get privacySettingsReset =>
      'Postavke privatnosti su poništene. Ponovno pokrenite aplikaciju za novi pristanak.';

  @override
  String get version => 'Verzija';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Dobrodošli u Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za brzo i jednostavno konzultiranje RAI Teletekst';

  @override
  String get onboardingDefaultChannel => 'Odaberi Zadani Kanal';

  @override
  String get onboardingDefaultChannelDescription =>
      'Prilikom pokretanja aplikacije bit ćete zamoljeni da odaberete svoj preferirani kanal među svim dostupnim kanalima.\n\nMožete promijeniti zadani kanal u bilo kojem trenutku iz izbornika Postavke.';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Prijeđite prstom lijevo ili desno za promjenu stranice, dodirnite brojeve za izravnu navigaciju';

  @override
  String get onboardingFavorites => 'Favoriti';

  @override
  String get onboardingFavoritesDescription =>
      'Spremite stranice koje najčešće posjećujete:\n\n• Dodirnite označenu ikonu za dodavanje trenutne stranice\n• Dodirnite ponovno za uklanjanje iz favorita\n• Ikona postaje crvena kada je stranica u favoritima\n\nMožete spremiti i nacionalne i regionalne stranice.';

  @override
  String get onboardingRegions => 'Kanali iz Cijele Europe';

  @override
  String get onboardingRegionsDescription =>
      'Odaberite i organizirajte svoje omiljene kanale iz cijele Europe.\n\nPretražujte prema nazivu kanala ili nazivu zemlje.\n\nMožete pristupiti teletekstu iz Italije, Njemačke, Austrije, Švicarske i mnogih drugih europskih zemalja!';

  @override
  String get onboardingAutoRefresh => 'Automatsko Osvježavanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Kada je automatsko osvježavanje aktivno, krug oko broja stranice se postupno puni:\n\nMožete promijeniti vrijeme osvježavanja u postavkama\n\nIndikator je vidljiv samo kada su podstranice dostupne i automatsko osvježavanje je aktivno.';

  @override
  String get onboardingPause => 'Pauziraj Osvježavanje';

  @override
  String get onboardingPauseDescription =>
      'Možete pauzirati automatsko osvježavanje podstranica:\n\n• Dodirnite bilo gdje na stranici gdje nema klikabilnih brojeva\n• Vidjet ćete ikonu ⏸️ koja označava da je osvježavanje pauzirano\n• Dodirnite ponovno za nastavak osvježavanja (ikona ▶️)\n\nOva funkcija je korisna kada želite mirno čitati podstranicu bez da se automatski mijenja.';

  @override
  String get onboardingPageSelector => 'Odabir Stranice';

  @override
  String get onboardingPageSelectorDescription =>
      'Dodirnite središnji broj za izravan unos stranice.\n\nUnesite broj između 100 i 999 za skok na tu stranicu.';

  @override
  String get onboardingSubpageNavigation => 'Navigacija Podstranica';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Ako stranica ima podstranice, vidjet ćete i indikator:\n• 1/3 znači: prva podstranica od tri dostupne\n\nKoristite središnje strelice za navigaciju između podstranica:\n\n• Strelica gore: idi na sljedeću podstranicu\n• Strelica dolje: idi na prethodnu podstranicu\n\nStrelice su aktivne samo kada su dostupne podstranice.';

  @override
  String get onboardingSwipe => 'Navigacija Prelaskom';

  @override
  String get onboardingSwipeDescription =>
      'Jednostavno se krećite između stranica pomoću gore prikazanih gesti.';

  @override
  String get onboardingClickableNumbers => 'Brojevi Stranica na Klik';

  @override
  String get onboardingClickableNumbersDescription =>
      'Dodirnite istaknute brojeve stranica za izravnu navigaciju na tu stranicu\n\n';

  @override
  String get onboardingShortcuts => 'Izbornik Prečaca';

  @override
  String get onboardingShortcutsDescription =>
      'Brzi pristup najvažnijim Teletekst stranicama.\n\nKoristite ovaj izbornik za izravan skok na:\n• Stranica 100: Nacionalni indeks\n• Stranica 200: Vijesti\n.....\nMožete također pretraživati stranice po naslovu odabirom opcije Pretraži stranicu';

  @override
  String get onboardingFavoritesList => 'Popis Favorita';

  @override
  String get onboardingFavoritesListDescription =>
      'Upravljajte svojim omiljenim stranicama:\n\n• Dodirnite stranicu za otvaranje\n• Prijeđite prstom ulijevo za uklanjanje\n• Dodirnite olovku za uređivanje opisa\n• Dugo pritisnite za promjenu redoslijeda\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Prilagodite aplikaciju prema svojim preferencijama:\n\n• Učitaj prvi favorit pri pokretanju: odlučite s kojom Teletekst stranicom početi\n• Tema: odaberite između svijetle, tamne ili automatske\n• Automatsko osvježavanje: omogućite automatsko učitavanje podstranica\n• Predmemorija: upravljajte trajanjem predmemorije stranica\n• Upute: pregledajte ovaj vodič kad god želite\n• Sigurnosna kopija favorita: spremite i vratite svoje favorite\n• Postavke privatnosti i poništavanje: upravljajte ili poništite svoje izbore privatnosti';

  @override
  String get dontShowAgain => 'Ne prikazuj ponovno';

  @override
  String get start => 'Započni';

  @override
  String get reset => 'Poništi';

  @override
  String get resetInitialChannel => 'Ponovno postavi početni kanal';

  @override
  String get resetInitialChannelDescription =>
      'Prikaži dijalog za odabir kanala ponovno pri sljedećem pokretanju';

  @override
  String get resetCompleted => 'Ponovno postavljanje dovršeno';

  @override
  String get resetInitialChannelMessage =>
      'Početni kanal je ponovno postavljen.\n\nPri sljedećem pokretanju aplikacije bit ćete zamoljeni da ponovno odaberete zadani kanal.\n\nPonovni pokretanje aplikacije sada...';

  @override
  String get selectYourChannel =>
      'Odaberite svoj zadani kanal Teleteksta.\nMožete ga promijeniti u bilo kojem trenutku.';

  @override
  String backToPage(int pageNumber) {
    return 'Natrag na stranicu $pageNumber';
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
  String get channelSelection => 'Odabir kanala';

  @override
  String get favoriteChannels => 'Omiljeni kanali';

  @override
  String get reorder => 'Preuredi';

  @override
  String get searchChannelOrCountry => 'Traži kanal ili zemlju...';

  @override
  String get showAllChannels => 'Prikaži sve kanale';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanala dostupno iz $countries zemalja';
  }

  @override
  String get allChannels => 'Svi kanali';

  @override
  String get noFavoriteChannelsFound => 'Nema omiljenih kanala';

  @override
  String get noChannelsFound => 'Nema pronađenih kanala';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name dodano u omiljene';
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
  String get reorderFavorites => 'Preuredi omiljene';

  @override
  String get countryIT => 'Italija';

  @override
  String get countryDE => 'Njemačka';

  @override
  String get countryAT => 'Austrija';

  @override
  String get countryCH => 'Švicarska';

  @override
  String get countryES => 'Španjolska';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Nizozemska';

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
}
