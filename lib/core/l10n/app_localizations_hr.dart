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
  String get cancel => 'ODUSTANI';

  @override
  String get save => 'SPREMI';

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
      'Trajanje predmemorije slika Televideo stranica (0 sekundi za onemogućavanje)';

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
  String get onboardingWelcome => 'Dobrodošli u TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacija za brzo i jednostavno konzultiranje RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigacija';

  @override
  String get onboardingNavigationDescription =>
      'Prijeđite prstom lijevo ili desno za promjenu stranice, dodirnite brojeve za izravnu navigaciju';

  @override
  String get onboardingFavorites => 'Favoriti';

  @override
  String get onboardingFavoritesDescription =>
      'Dodajte stranice u favorite za brzi pristup';

  @override
  String get onboardingRegions => 'Regionalni Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Pristupite Televideo-u svoje regije';

  @override
  String get onboardingAutoRefresh => 'Automatsko Osvježavanje';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstranice se automatski ažuriraju';

  @override
  String get onboardingPause => 'Pauziraj Osvježavanje';

  @override
  String get onboardingPauseDescription =>
      'Dodirnite prazno područje za pauziranje automatskog osvježavanja';

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
      'Dodirnite istaknute brojeve stranica za izravnu navigaciju na tu stranicu\n\nStranice 100/1 Nacionalnog Televideo-a i 300/1 Regionalnog Televideo-a nisu klikabilne';

  @override
  String get onboardingShortcuts => 'Izbornik Prečaca';

  @override
  String get onboardingShortcutsDescription =>
      'Brzi pristup najvažnijim Televideo stranicama.\n\nKoristite ovaj izbornik za izravan skok na:\n• Stranica 100: Nacionalni indeks\n• Stranica 200: Vijesti\n.....\nMožete također pretraživati stranice po naslovu odabirom opcije Pretraži stranicu';

  @override
  String get onboardingFavoritesList => 'Popis Favorita';

  @override
  String get onboardingFavoritesListDescription =>
      'Upravljajte svojim omiljenim stranicama:\n\n• Dodirnite stranicu za otvaranje\n• Prijeđite prstom ulijevo za uklanjanje\n• Dodirnite olovku za uređivanje opisa\n• Dugo pritisnite za promjenu redoslijeda\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Prilagodite aplikaciju prema svojim preferencijama:\n\n• Učitaj prvi favorit pri pokretanju: odlučite s kojom Televideo stranicom početi\n• Tema: odaberite između svijetle, tamne ili automatske\n• Automatsko osvježavanje: omogućite automatsko učitavanje podstranica\n• Predmemorija: upravljajte trajanjem predmemorije stranica\n• Upute: pregledajte ovaj vodič kad god želite\n• Sigurnosna kopija favorita: spremite i vratite svoje favorite\n• Postavke privatnosti i poništavanje: upravljajte ili poništite svoje izbore privatnosti';

  @override
  String get dontShowAgain => 'Ne prikazuj ponovno';

  @override
  String get start => 'Započni';

  @override
  String get reset => 'Poništi';

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
  String get support => 'Podrška';

  @override
  String get supportDescription => 'Kontaktirajte nas za pomoć';

  @override
  String get supportTitle => 'Tu smo da pomognemo!';

  @override
  String get supportSubtitle =>
      'Za bilo kakva pitanja ili pomoć, ne ustručavajte se kontaktirati nas';

  @override
  String get directContact => 'Izravni Kontakt';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get websiteLabel => 'Web Stranica';

  @override
  String get responseTime => 'Prosječno vrijeme odgovora: 24-48 sati';

  @override
  String get faq => 'Često Postavljena Pitanja';

  @override
  String get faqGeolocation => 'Kako funkcionira geolokacija?';

  @override
  String get faqGeolocationAnswer =>
      'Aplikacija koristi lokaciju vašeg uređaja za automatsku identifikaciju vaše regije i prikazivanje relevantnih lokalnih vijesti. Ovu funkciju možete deaktivirati u postavkama aplikacije.';

  @override
  String get faqFavorites => 'Kako spremiti stranicu u favorite?';

  @override
  String get faqFavoritesAnswer =>
      'Dok gledate stranicu, dodirnite ikonu zvijezde da je dodate u favorite. Svojim omiljenim stranicama možete pristupiti iz glavnog izbornika.';

  @override
  String get faqTheme => 'Kako promijeniti temu aplikacije?';

  @override
  String get faqThemeAnswer =>
      'Idite u postavke aplikacije i odaberite željenu temu (svijetla/tamna). Aplikacija također podržava automatsko postavljanje na temelju sistemskih postavki.';

  @override
  String get faqOffline => 'Funkcionira li aplikacija offline?';

  @override
  String get faqOfflineAnswer =>
      'Ne, aktivna internetska veza je potrebna za pristup teletekst stranicama u realnom vremenu.';

  @override
  String get faqReportProblem => 'Kako prijaviti problem?';

  @override
  String get faqReportProblemAnswer =>
      'Pošaljite detaljan e-mail na samuele@codebysam.it opisujući problem.';

  @override
  String get reportBugTitle => 'Prijavi Problem';

  @override
  String get reportBugInstructions =>
      'Prilikom prijavljivanja problema, navedite ako je moguće:';

  @override
  String get reportBugItems =>
      'Verzija aplikacije\\nModel uređaja\\nOperativni sustav\\nSnimka zaslona problema';

  @override
  String get developedBy => 'Razvijeno od CodeBySam';

  @override
  String get errorOpeningLink => 'Nije moguće otvoriti poveznicu';

  @override
  String get errorOpeningEmail => 'Nije moguće otvoriti e-mail';
}
