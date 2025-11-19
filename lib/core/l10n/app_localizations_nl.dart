// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Welkom!';

  @override
  String get welcomeSelectChannel => 'Standaardkanaal selecteren';

  @override
  String page(int pageNumber) {
    return 'Pagina $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Kan de paginafoto niet laden.\nProbeer het over een moment opnieuw.';

  @override
  String get pageNotAvailable => 'De gevraagde pagina is niet beschikbaar';

  @override
  String get pageLoadError =>
      'Er is een fout opgetreden bij het laden van de pagina.\nTerug naar pagina 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Pagina $pageNumber is niet beschikbaar voor $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Pagina $pageNumber is niet beschikbaar voor $regionName.\nProbeer een ander nummer tussen 100 en 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Geen pagina\'s meer beschikbaar voor $regionName';
  }

  @override
  String get noMorePages => 'Geen pagina\'s meer beschikbaar';

  @override
  String get invalidSubpageNumber => 'Ongeldig subpaginanummer';

  @override
  String subpageError(int current, int total) {
    return 'Fout bij het laden van subpagina $current van $total';
  }

  @override
  String get swipePrevious => '← Vorige';

  @override
  String get swipeNext => 'Volgende →';

  @override
  String get swipeNextUp => 'Volgende ↑';

  @override
  String get swipePreviousDown => 'Vorige ↓';

  @override
  String get swipeRefresh => 'Vernieuwen ↻';

  @override
  String get pageAddedToFavorites => 'Pagina toegevoegd aan favorieten';

  @override
  String get pageRemovedFromFavorites => 'Pagina verwijderd uit favorieten';

  @override
  String get editDescription => 'Beschrijving bewerken';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Pagina $pageNumber - $regionName';
  }

  @override
  String get description => 'Beschrijving';

  @override
  String get enterCustomDescription => 'Voer een aangepaste beschrijving in';

  @override
  String get restoreHint =>
      'Tip: houd de \"HERSTELLEN\" knop ingedrukt om terug te keren naar de standaardbeschrijving.';

  @override
  String get restore => 'HERSTELLEN';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get searchHint => 'Zoek pagina...';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get settings => 'Instellingen';

  @override
  String get enterPageNumber => 'Voer paginanummer in';

  @override
  String pageNumberRange(int minPage) {
    return 'Nummer van $minPage tot 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Favorietenlijst';

  @override
  String get confirmRemoval => 'Bevestig verwijdering';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Wilt u $description echt verwijderen uit favorieten?';
  }

  @override
  String get remove => 'Verwijderen';

  @override
  String get edit => 'Bewerken';

  @override
  String get close => 'Sluiten';

  @override
  String get noFavorites => 'Geen favorieten';

  @override
  String get useFavoriteIcon =>
      'Gebruik het ❤️ icoon om pagina\'s toe te voegen aan favorieten';

  @override
  String loadingPage(int pageNumber) {
    return 'Pagina $pageNumber laden...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Geen pagina om toe te voegen aan favorieten';

  @override
  String get language => 'Taal';

  @override
  String get systemLanguage => 'Systeemtaal';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get autoRefresh => 'Automatisch vernieuwen';

  @override
  String get favorites => 'Favorieten';

  @override
  String get search => 'Zoeken';

  @override
  String get regions => 'Regio\'s';

  @override
  String get home => 'Home';

  @override
  String get addToFavorites => 'Toevoegen aan favorieten';

  @override
  String get removeFromFavorites => 'Verwijderen uit favorieten';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fout';

  @override
  String errorWithMessage(String message) {
    return 'Fout: $message';
  }

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get next => 'Volgende';

  @override
  String get previous => 'Vorige';

  @override
  String get pageNotFound => 'Pagina niet gevonden';

  @override
  String get networkError => 'Netwerkfout';

  @override
  String get connectionRequired => 'Verbinding vereist';

  @override
  String get refreshing => 'Vernieuwen...';

  @override
  String get lastUpdate => 'Laatste update';

  @override
  String get theme => 'Thema';

  @override
  String get systemTheme => 'Systeemthema';

  @override
  String get lightTheme => 'Licht thema';

  @override
  String get darkTheme => 'Donker thema';

  @override
  String get selectTheme => 'Selecteer thema';

  @override
  String get startupPageOption => 'Startpagina';

  @override
  String get startupPageOptionLastPage => 'Laatst bekeken pagina (standaard)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Eerste favoriet (indien beschikbaar)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Startpagina van laatste kanaal';

  @override
  String get cacheDuration =>
      'Cache-duur voor Teletekst-paginafoto\'s (0 seconden om uit te schakelen)';

  @override
  String get seconds => 'seconden';

  @override
  String get autoRefreshDescription => 'Automatisch subpagina\'s vernieuwen';

  @override
  String get refreshInterval => 'Vernieuwingsinterval';

  @override
  String get showOnboardingAtStartup => 'Toon instructies bij opstarten';

  @override
  String get showOnboardingAtStartupDescription =>
      'Toon instructies elke keer dat u de app opent';

  @override
  String get showInstructions => 'Toon instructies';

  @override
  String get showInstructionsDescription =>
      'Bekijk de gebruiksinstructies van de app';

  @override
  String get backupFavorites => 'Back-up favorieten';

  @override
  String get backupFavoritesDescription => 'Sla uw favorieten op en herstel ze';

  @override
  String get support => 'Ondersteuning';

  @override
  String get supportDescription => 'Neem contact met ons op voor hulp';

  @override
  String get supportTitle => 'We zijn er om te helpen!';

  @override
  String get supportSubtitle =>
      'Voor vragen of hulp, aarzel niet om contact met ons op te nemen';

  @override
  String get directContact => 'Direct Contact';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get websiteLabel => 'Website';

  @override
  String get responseTime => 'Gemiddelde reactietijd: 24-48 uur';

  @override
  String get faq => 'Veelgestelde Vragen';

  @override
  String get faqGeolocation => 'Hoe werkt geolocatie?';

  @override
  String get faqGeolocationAnswer =>
      'De app gebruikt de locatie van uw apparaat om automatisch uw regio te identificeren en relevante lokale nieuwsitems te tonen. U kunt deze functie uitschakelen in de app-instellingen.';

  @override
  String get faqFavorites => 'Hoe bewaar ik een pagina in favorieten?';

  @override
  String get faqFavoritesAnswer =>
      'Tik tijdens het bekijken van een pagina op het sterpictogram om deze toe te voegen aan favorieten. U kunt uw favoriete pagina\'s openen vanuit het hoofdmenu.';

  @override
  String get faqTheme => 'Hoe verander ik het app-thema?';

  @override
  String get faqThemeAnswer =>
      'Ga naar de app-instellingen en selecteer het gewenste thema (licht/donker). De app ondersteunt ook automatische instelling op basis van systeeminstellingen.';

  @override
  String get faqOffline => 'Werkt de app offline?';

  @override
  String get faqOfflineAnswer =>
      'Nee, een actieve internetverbinding is vereist om real-time Teletekst-pagina\'s te openen.';

  @override
  String get faqReportProblem => 'Hoe meld ik een probleem?';

  @override
  String get faqReportProblemAnswer =>
      'Stuur een gedetailleerde e-mail naar samuele@codebysam.it met een beschrijving van het probleem.';

  @override
  String get reportBugTitle => 'Probleem melden';

  @override
  String get reportBugInstructions =>
      'Bij het melden van een probleem, vermeld indien mogelijk:';

  @override
  String get reportBugItems =>
      'App-versie\nApparaatmodel\nBesturingssysteem\nSchermafbeelding van het probleem';

  @override
  String get developedBy => 'Ontwikkeld door CodeBySam';

  @override
  String get errorOpeningLink => 'Kan link niet openen';

  @override
  String get errorOpeningEmail => 'Kan e-mail niet openen';

  @override
  String get privacySettings => 'Privacy-instellingen';

  @override
  String get privacySettingsDescription =>
      'Wijzig uw privacyvoorkeuren voor advertenties';

  @override
  String get resetPrivacySettings => 'Privacy-instellingen resetten';

  @override
  String get resetPrivacySettingsDescription =>
      'Privacy-instellingen volledig resetten';

  @override
  String get resetPrivacyConfirm =>
      'Wilt u de privacy-instellingen echt resetten? U wordt bij de volgende start van de app opnieuw om toestemming gevraagd.';

  @override
  String get privacySettingsUnavailable =>
      'Privacy-instellingen zijn momenteel niet beschikbaar';

  @override
  String get privacySettingsReset =>
      'Privacy-instellingen gereset. Start de app opnieuw voor nieuwe toestemming.';

  @override
  String get version => 'Versie';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Welkom bij Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'De app voor toegang tot alle teletekstkanalen in Europa';

  @override
  String get onboardingDefaultChannel => 'Standaardkanaal Selecteren';

  @override
  String get onboardingDefaultChannelDescription =>
      'Bij het starten van de app wordt u gevraagd uw voorkeurskanaal te selecteren uit alle beschikbare kanalen.\n\nU kunt het standaardkanaal op elk moment wijzigen via het menu Instellingen.';

  @override
  String get onboardingNavigation => 'Navigatie';

  @override
  String get onboardingNavigationDescription =>
      'Veeg naar links of rechts om van pagina te wisselen, tik op nummers om direct te navigeren';

  @override
  String get onboardingFavorites => 'Favorieten';

  @override
  String get onboardingFavoritesDescription =>
      'Bewaar de pagina\'s die u het vaakst bezoekt:\n\n• Tik op het aangegeven pictogram om de huidige pagina toe te voegen\n• Tik opnieuw om deze uit de favorieten te verwijderen\n• Het pictogram wordt rood wanneer de pagina bij de favorieten staat\n\nU kunt zowel nationale als regionale pagina\'s opslaan.';

  @override
  String get onboardingRegions => 'Kanalen uit Heel Europa';

  @override
  String get onboardingRegionsDescription =>
      'Selecteer en organiseer uw favoriete kanalen uit heel Europa.\n\nZoek op kanaalnaam of landnaam.\n\nU heeft toegang tot teletekst uit Italië, Duitsland, Oostenrijk, Zwitserland en vele andere Europese landen!';

  @override
  String get onboardingAutoRefresh => 'Automatisch Vernieuwen';

  @override
  String get onboardingAutoRefreshDescription =>
      'Wanneer automatisch vernieuwen actief is, vult de cirkel rond het paginanummer zich geleidelijk:\n\nU kunt de vernieuwingstijd wijzigen in de instellingen\n\nDe indicator is alleen zichtbaar wanneer subpagina\'s beschikbaar zijn en automatisch vernieuwen actief is.';

  @override
  String get onboardingPause => 'Vernieuwen Pauzeren';

  @override
  String get onboardingPauseDescription =>
      'U kunt het automatisch vernieuwen van subpagina\'s pauzeren:\n\n• Tik ergens op de pagina waar geen klikbare nummers zijn\n• U ziet het ⏸️ pictogram verschijnen om aan te geven dat het vernieuwen gepauzeerd is\n• Tik opnieuw om het vernieuwen te hervatten (▶️ pictogram)\n\nDeze functie is handig wanneer u een subpagina rustig wilt lezen zonder dat deze automatisch verandert.';

  @override
  String get onboardingPageSelector => 'Paginakiezer';

  @override
  String get onboardingPageSelectorDescription =>
      'Tik op het middelste nummer om direct een pagina in te voeren.\n\nVoer een nummer tussen 100 en 999 in om naar die pagina te springen.';

  @override
  String get onboardingSubpageNavigation => 'Subpagina Navigatie';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Als de pagina subpagina\'s heeft, ziet u ook de indicator:\n• 1/3 betekent: eerste subpagina van drie beschikbare\n\nGebruik de middelste pijlen om tussen subpagina\'s te navigeren:\n\n• Pijl omhoog: ga naar volgende subpagina\n• Pijl omlaag: ga naar vorige subpagina\n\nDe pijlen zijn alleen actief als er subpagina\'s beschikbaar zijn.';

  @override
  String get onboardingSwipe => 'Veeg Navigatie';

  @override
  String get onboardingSwipeDescription =>
      'Navigeer eenvoudig tussen pagina\'s met de hierboven getoonde gebaren.';

  @override
  String get onboardingClickableNumbers => 'Klikbare Paginanummers';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tik op de gemarkeerde paginanummers om direct naar die pagina te navigeren\n\n';

  @override
  String get onboardingShortcuts => 'Menu Snelkoppelingen';

  @override
  String get onboardingShortcutsDescription =>
      'Krijg snel toegang tot de belangrijkste Teletekst-pagina\'s.\n\nGebruik dit menu om direct naar:\n• Pagina 100: Nationale index\n• Pagina 200: Nieuws\n.....\nU kunt ook pagina\'s op titel zoeken door de optie Pagina zoeken te selecteren';

  @override
  String get onboardingFavoritesList => 'Favorietenlijst';

  @override
  String get onboardingFavoritesListDescription =>
      'Beheer uw favoriete pagina\'s:\n\n• Tik op een pagina om deze te openen\n• Veeg naar links om te verwijderen\n• Tik op het potlood om de beschrijving te bewerken\n• Houd ingedrukt om de volgorde te wijzigen\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Pas de app aan volgens uw voorkeuren:\n\n• Laad eerste favoriet bij opstarten: bepaal met welke Teletekst-pagina te beginnen\n• Thema: kies tussen licht, donker of automatisch\n• Automatisch vernieuwen: schakel automatisch laden van subpagina\'s in\n• Cache: beheer de cache-duur van pagina\'s\n• Instructies: bekijk deze tutorial wanneer u maar wilt\n• Back-up Favorieten: sla uw favorieten op en herstel ze\n• Privacy-instellingen en reset: beheer of reset uw privacykeuzes';

  @override
  String get dontShowAgain => 'Niet meer tonen';

  @override
  String get start => 'Starten';

  @override
  String get reset => 'Reset';

  @override
  String get resetInitialChannel => 'Reset startkanaal';

  @override
  String get resetInitialChannelDescription =>
      'Toon het kanaalselectie-dialoog opnieuw bij de volgende start';

  @override
  String get resetCompleted => 'Reset voltooid';

  @override
  String get resetInitialChannelMessage =>
      'Het startkanaal is gereset.\n\nBij de volgende app-start wordt u gevraagd om opnieuw uw standaardkanaal te selecteren.\n\nApp wordt nu opnieuw gestart...';

  @override
  String get selectYourChannel =>
      'Selecteer uw standaard Teletekst-kanaal.\nU kunt het op elk moment wijzigen.';

  @override
  String backToPage(int pageNumber) {
    return 'Terug naar pagina $pageNumber';
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
  String get channelSelection => 'Kanaalselectie';

  @override
  String get favoriteChannels => 'Favoriete kanalen';

  @override
  String get reorder => 'Herschikken';

  @override
  String get searchChannelOrCountry => 'Zoek kanaal of land...';

  @override
  String get showAllChannels => 'Toon alle kanalen';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanalen beschikbaar uit $countries landen';
  }

  @override
  String get allChannels => 'Alle kanalen';

  @override
  String get noFavoriteChannelsFound => 'Geen favoriete kanalen gevonden';

  @override
  String get noChannelsFound => 'Geen kanalen gevonden';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name toegevoegd aan favorieten';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name verwijderd uit favorieten';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regio\'s beschikbaar';
  }

  @override
  String get reorderFavorites => 'Favorieten herschikken';

  @override
  String get countryIT => 'Italië';

  @override
  String get countryDE => 'Duitsland';

  @override
  String get countryAT => 'Oostenrijk';

  @override
  String get countryCH => 'Zwitserland';

  @override
  String get countryES => 'Spanje';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Nederland';

  @override
  String get countrySE => 'Zweden';

  @override
  String get countryFI => 'Finland';

  @override
  String get countryDK => 'Denemarken';

  @override
  String get countryCZ => 'Tsjechië';

  @override
  String get countryHR => 'Kroatië';

  @override
  String get countryBA => 'Bosnië en Herzegovina';

  @override
  String get countryHU => 'Hongarije';

  @override
  String get countryIS => 'IJsland';

  @override
  String get countrySI => 'Slovenië';

  @override
  String get countryUA => 'Oekraïne';
}
