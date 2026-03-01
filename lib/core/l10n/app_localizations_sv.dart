// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Välkommen!';

  @override
  String get welcomeSelectChannel => 'Välj standardkanal';

  @override
  String page(int pageNumber) {
    return 'Sida $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Det går inte att ladda sidbilden.\nFörsök igen om en stund.';

  @override
  String get pageNotAvailable => 'Den begärda sidan är inte tillgänglig';

  @override
  String get pageLoadError =>
      'Ett fel uppstod när sidan laddades.\nTillbaka till sida 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Sida $pageNumber är inte tillgänglig för $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Sida $pageNumber är inte tillgänglig för $regionName.\nPröva ett annat nummer mellan 100 och 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Inga fler sidor tillgängliga för $regionName';
  }

  @override
  String get noMorePages => 'Inga fler sidor tillgängliga';

  @override
  String get invalidSubpageNumber => 'Ogiltigt undersidesnummer';

  @override
  String subpageError(int current, int total) {
    return 'Fel vid laddning av undersida $current av $total';
  }

  @override
  String get swipePrevious => '← Föregående';

  @override
  String get swipeNext => 'Nästa →';

  @override
  String get swipeNextUp => 'Nästa ↑';

  @override
  String get swipePreviousDown => 'Föregående ↓';

  @override
  String get swipeRefresh => 'Uppdatera ↻';

  @override
  String get pageAddedToFavorites => 'Sidan har lagts till i favoriter';

  @override
  String get pageRemovedFromFavorites => 'Sidan har tagits bort från favoriter';

  @override
  String get editDescription => 'Redigera beskrivning';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Sida $pageNumber - $regionName';
  }

  @override
  String get description => 'Beskrivning';

  @override
  String get enterCustomDescription => 'Ange en anpassad beskrivning';

  @override
  String get restoreHint =>
      'Tips: håll knappen \"ÅTERSTÄLL\" intryckt för att återgå till standardbeskrivningen.';

  @override
  String get restore => 'ÅTERSTÄLL';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Spara';

  @override
  String get searchHint => 'Sök sida...';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get settings => 'Inställningar';

  @override
  String get enterPageNumber => 'Ange sidnummer';

  @override
  String pageNumberRange(int minPage) {
    return 'Nummer från $minPage till 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Favoritlista';

  @override
  String get confirmRemoval => 'Bekräfta borttagning';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Vill du verkligen ta bort $description från favoriter?';
  }

  @override
  String get remove => 'Ta bort';

  @override
  String get edit => 'Redigera';

  @override
  String get close => 'Stäng';

  @override
  String get noFavorites => 'Inga favoriter';

  @override
  String get useFavoriteIcon =>
      'Använd ❤️ ikonen för att lägga till sidor i favoriter';

  @override
  String loadingPage(int pageNumber) {
    return 'Laddar sida $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Ingen sida att lägga till i favoriter';

  @override
  String get language => 'Språk';

  @override
  String get systemLanguage => 'Systemspråk';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get autoRefresh => 'Automatisk uppdatering';

  @override
  String get favorites => 'Favoriter';

  @override
  String get search => 'Sök';

  @override
  String get regions => 'Regioner';

  @override
  String get home => 'Hem';

  @override
  String get addToFavorites => 'Lägg till i favoriter';

  @override
  String get removeFromFavorites => 'Ta bort från favoriter';

  @override
  String get loading => 'Laddar...';

  @override
  String get error => 'Fel';

  @override
  String errorWithMessage(String message) {
    return 'Fel: $message';
  }

  @override
  String get retry => 'Försök igen';

  @override
  String get next => 'Nästa';

  @override
  String get previous => 'Föregående';

  @override
  String get pageNotFound => 'Sidan hittades inte';

  @override
  String get networkError => 'Nätverksfel';

  @override
  String get connectionRequired => 'Anslutning krävs';

  @override
  String get refreshing => 'Uppdaterar...';

  @override
  String get lastUpdate => 'Senaste uppdatering';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Systemtema';

  @override
  String get lightTheme => 'Ljust tema';

  @override
  String get darkTheme => 'Mörkt tema';

  @override
  String get selectTheme => 'Välj tema';

  @override
  String get startupPageOption => 'Startsida';

  @override
  String get startupPageOptionLastPage => 'Senast visade sida (standard)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Första favorit (om tillgänglig)';

  @override
  String get startupPageOptionChannelHomePage => 'Startsida för senaste kanal';

  @override
  String get cacheDuration =>
      'Cache-varaktighet för Text-TV-sidbilder (0 sekunder för att inaktivera)';

  @override
  String get seconds => 'sekunder';

  @override
  String get autoRefreshDescription => 'Uppdatera undersidor automatiskt';

  @override
  String get refreshInterval => 'Uppdateringsintervall';

  @override
  String get showOnboardingAtStartup => 'Visa instruktioner vid start';

  @override
  String get showOnboardingAtStartupDescription =>
      'Visa instruktioner varje gång du öppnar appen';

  @override
  String get showInstructions => 'Visa instruktioner';

  @override
  String get showInstructionsDescription =>
      'Granska appens användningsinstruktioner';

  @override
  String get backupFavorites => 'Säkerhetskopiera favoriter';

  @override
  String get backupFavoritesDescription => 'Spara och återställ dina favoriter';

  @override
  String get support => 'Support';

  @override
  String get supportDescription => 'Kontakta oss för hjälp';

  @override
  String get supportTitle => 'Vi är här för att hjälpa!';

  @override
  String get supportSubtitle =>
      'För frågor eller hjälp, tveka inte att kontakta oss';

  @override
  String get directContact => 'Direkt Kontakt';

  @override
  String get emailLabel => 'E-post';

  @override
  String get websiteLabel => 'Webbplats';

  @override
  String get responseTime => 'Genomsnittlig svarstid: 24-48 timmar';

  @override
  String get faq => 'Vanliga Frågor';

  @override
  String get faqGeolocation => 'Hur fungerar geolokalisering?';

  @override
  String get faqGeolocationAnswer =>
      'Appen använder din enhets plats för att automatiskt identifiera din region och visa relevanta lokala nyheter. Du kan inaktivera denna funktion i appinställningarna.';

  @override
  String get faqFavorites => 'Hur sparar jag en sida i favoriter?';

  @override
  String get faqFavoritesAnswer =>
      'När du tittar på en sida, tryck på stjärnikonen för att lägga till den i favoriter. Du kan komma åt dina favoritsidor från huvudmenyn.';

  @override
  String get faqTheme => 'Hur ändrar jag appens tema?';

  @override
  String get faqThemeAnswer =>
      'Gå till appinställningarna och välj önskat tema (ljust/mörkt). Appen stöder också automatisk inställning baserad på systeminställningar.';

  @override
  String get faqOffline => 'Fungerar appen offline?';

  @override
  String get faqOfflineAnswer =>
      'Nej, en aktiv internetanslutning krävs för att få åtkomst till Text-TV-sidor i realtid.';

  @override
  String get faqReportProblem => 'Hur rapporterar jag ett problem?';

  @override
  String get faqReportProblemAnswer =>
      'Skicka ett detaljerat e-postmeddelande till samuele@codebysam.it med en beskrivning av problemet.';

  @override
  String get reportBugTitle => 'Rapportera ett problem';

  @override
  String get reportBugInstructions =>
      'När du rapporterar ett problem, inkludera om möjligt:';

  @override
  String get reportBugItems =>
      'Appversion\nEnhetsmodell\nOperativsystem\nSkärmdump av problemet';

  @override
  String get developedBy => 'Utvecklad av CodeBySam';

  @override
  String get errorOpeningLink => 'Kan inte öppna länk';

  @override
  String get errorOpeningEmail => 'Kan inte öppna e-post';

  @override
  String get privacySettings => 'Sekretessinställningar';

  @override
  String get privacySettingsDescription =>
      'Ändra dina sekretessinställningar för annonser';

  @override
  String get resetPrivacySettings => 'Återställ sekretessinställningar';

  @override
  String get resetPrivacySettingsDescription =>
      'Återställ alla sekretessinställningar';

  @override
  String get resetPrivacyConfirm =>
      'Vill du verkligen återställa sekretessinställningarna? Du kommer att bli ombedd om samtycke igen nästa gång du startar appen.';

  @override
  String get privacySettingsUnavailable =>
      'Sekretessinställningar är inte tillgängliga för tillfället';

  @override
  String get privacySettingsReset =>
      'Sekretessinställningar återställda. Starta om appen för nytt samtycke.';

  @override
  String get version => 'Version';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Välkommen till Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Appen för att snabbt och enkelt konsultera RAI Text-TV';

  @override
  String get onboardingDefaultChannel => 'Välj Standardkanal';

  @override
  String get onboardingDefaultChannelDescription =>
      'När du startar appen kommer du att bli ombedd att välja din föredragna kanal bland alla tillgängliga kanaler.\n\nDu kan ändra standardkanalen när som helst från menyn Inställningar.';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Svep åt vänster eller höger för att byta sida, tryck på siffror för att navigera direkt';

  @override
  String get onboardingFavorites => 'Favoriter';

  @override
  String get onboardingFavoritesDescription =>
      'Spara de sidor du besöker oftast:\n\n• Tryck på den angivna ikonen för att lägga till den aktuella sidan\n• Tryck igen för att ta bort den från favoriter\n• Ikonen blir röd när sidan finns bland favoriter\n\nDu kan spara både nationella och regionala sidor.';

  @override
  String get onboardingRegions => 'Kanaler från Hela Europa';

  @override
  String get onboardingRegionsDescription =>
      'Välj och organisera dina favoritkanaler från hela Europa.\n\nSök efter kanalnamn eller landsnamn.\n\nDu kan komma åt text-tv från Italien, Tyskland, Österrike, Schweiz och många andra europeiska länder!';

  @override
  String get onboardingAutoRefresh => 'Automatisk Uppdatering';

  @override
  String get onboardingAutoRefreshDescription =>
      'När automatisk uppdatering är aktiv fylls cirkeln runt sidnumret gradvis:\n\nDu kan ändra uppdateringstiden i inställningarna\n\nIndikatorn är endast synlig när undersidor är tillgängliga och automatisk uppdatering är aktiv.';

  @override
  String get onboardingPause => 'Pausa Uppdatering';

  @override
  String get onboardingPauseDescription =>
      'Du kan pausa automatisk uppdatering av undersidor:\n\n• Tryck var som helst på sidan där det inte finns klickbara nummer\n• Du kommer att se ⏸️ ikonen visas för att indikera att uppdateringen är pausad\n• Tryck igen för att återuppta uppdateringen (▶️ ikon)\n\nDenna funktion är användbar när du vill läsa en undersida lugnt utan att den ändras automatiskt.';

  @override
  String get onboardingPageSelector => 'Sidväljare';

  @override
  String get onboardingPageSelectorDescription =>
      'Tryck på det centrala numret för att direkt ange en sida.\n\nAnge ett nummer mellan 100 och 999 för att hoppa till den sidan.';

  @override
  String get onboardingSubpageNavigation => 'Undersida Navigation';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Om sidan har undersidor kommer du också att se indikatorn:\n• 1/3 betyder: första undersidan av tre tillgängliga\n\nAnvänd de centrala pilarna för att navigera mellan undersidor:\n\n• Pil upp: gå till nästa undersida\n• Pil ner: gå till föregående undersida\n\nPilarna är endast aktiva när det finns undersidor tillgängliga.';

  @override
  String get onboardingSwipe => 'Svepnavigation';

  @override
  String get onboardingSwipeDescription =>
      'Navigera enkelt mellan sidor med gesterna som visas ovan.';

  @override
  String get onboardingClickableNumbers => 'Klickbara Sidnummer';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tryck på de markerade sidnumren för att navigera direkt till den sidan\n\n';

  @override
  String get onboardingShortcuts => 'Meny Genvägar';

  @override
  String get onboardingShortcutsDescription =>
      'Snabb åtkomst till de viktigaste Text-TV-sidorna.\n\nAnvänd denna meny för att hoppa direkt till:\n• Sida 100: Nationellt index\n• Sida 200: Nyheter\n.....\nDu kan också söka sidor efter titel genom att välja alternativet Sök sida';

  @override
  String get onboardingFavoritesList => 'Favoritlista';

  @override
  String get onboardingFavoritesListDescription =>
      'Hantera dina favoritsidor:\n\n• Tryck på en sida för att öppna den\n• Svep åt vänster för att ta bort den\n• Tryck på pennan för att redigera beskrivningen\n• Tryck och håll för att ändra ordningen\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Anpassa appen efter dina preferenser:\n\n• Ladda första favoriten vid start: bestäm vilken Text-TV-sida att börja med\n• Tema: välj mellan ljust, mörkt eller automatiskt\n• Automatisk uppdatering: aktivera automatisk laddning av undersidor\n• Cache: hantera sidcachens varaktighet\n• Instruktioner: granska denna handledning när du vill\n• Säkerhetskopiera favoriter: spara och återställ dina favoriter\n• Sekretessinställningar och återställning: hantera eller återställ dina sekretessval';

  @override
  String get dontShowAgain => 'Visa inte igen';

  @override
  String get start => 'Starta';

  @override
  String get reset => 'Återställ';

  @override
  String get resetInitialChannel => 'Återställ startkanal';

  @override
  String get resetInitialChannelDescription =>
      'Visa kanalvalsdialogrutan igen vid nästa start';

  @override
  String get resetCompleted => 'Återställning slutförd';

  @override
  String get resetInitialChannelMessage =>
      'Startkanalen har återställts.\n\nVid nästa appstart kommer du att bli ombedd att välja din standardkanal igen.\n\nStartar om appen nu...';

  @override
  String get selectYourChannel =>
      'Välj din standard Text-TV-kanal.\nDu kan ändra den när som helst.';

  @override
  String backToPage(int pageNumber) {
    return 'Tillbaka till sida $pageNumber';
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
  String get channelSelection => 'Kanalval';

  @override
  String get favoriteChannels => 'Favoritkanaler';

  @override
  String get reorder => 'Ordna om';

  @override
  String get searchChannelOrCountry => 'Sök kanal eller land...';

  @override
  String get showAllChannels => 'Visa alla kanaler';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanaler tillgängliga från $countries länder';
  }

  @override
  String get allChannels => 'Alla kanaler';

  @override
  String get noFavoriteChannelsFound => 'Inga favoritkanaler hittades';

  @override
  String get noChannelsFound => 'Inga kanaler hittades';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name tillagd till favoriter';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name borttagen från favoriter';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regioner tillgängliga';
  }

  @override
  String get reorderFavorites => 'Ordna om favoriter';

  @override
  String get countryIT => 'Italien';

  @override
  String get countryDE => 'Tyskland';

  @override
  String get countryAT => 'Österrike';

  @override
  String get countryCH => 'Schweiz';

  @override
  String get countryES => 'Spanien';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Nederländerna';

  @override
  String get countryPL => 'Polen';

  @override
  String get countrySE => 'Sverige';

  @override
  String get countryFI => 'Finland';

  @override
  String get countryDK => 'Danmark';

  @override
  String get countryCZ => 'Tjeckien';

  @override
  String get countryHR => 'Kroatien';

  @override
  String get countryBA => 'Bosnien och Hercegovina';

  @override
  String get countryHU => 'Ungern';

  @override
  String get countryIS => 'Island';

  @override
  String get countrySI => 'Slovenien';

  @override
  String get countryUA => 'Ukraina';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Premium-funktioner';

  @override
  String get premiumSubtitle => 'Förbättra din Teletext Europe upplevelse';

  @override
  String get premiumNoAds => 'Inga annonser';

  @override
  String get premiumNoAdsDescription =>
      'Ta bort alla bannerannonser och interstitiella annonser';

  @override
  String get premiumFasterExperience => 'Smidigare upplevelse';

  @override
  String get premiumFasterExperienceDescription =>
      'Navigera utan reklamavbrott';

  @override
  String get premiumSupportDevelopment => 'Stöd utvecklingen';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Hjälp till att hålla appen uppdaterad med nya kanaler och funktioner';

  @override
  String get premiumActivated => 'Premium aktiverat';

  @override
  String get premiumThankYou => 'Tack för ditt stöd!';

  @override
  String get premiumOneTimePurchase => 'Kvartalsabonnemang';

  @override
  String get premiumLifetime => 'Förnyas automatiskt var 3:e månad';

  @override
  String get purchasePremium => 'Prenumerera nu';

  @override
  String get restorePurchases => 'Återställ prenumeration';

  @override
  String get premiumProductNotAvailable =>
      'Premium-prenumeration inte tillgänglig för tillfället';

  @override
  String get premiumPurchaseError => 'Fel under prenumeration. Försök igen.';

  @override
  String get premiumRestoreSuccess => 'Prenumeration återställd framgångsrikt!';

  @override
  String get premiumRestoreNoPurchases => 'Ingen aktiv prenumeration hittades';

  @override
  String get premiumRestoreError => 'Fel vid återställning av prenumeration';

  @override
  String get premiumLegalNote =>
      'Kvartalsabonnemang med automatisk förnyelse. Du kan avsluta när som helst från dina Apple/Google-kontoinställningar. Betalning debiteras vid bekräftelse. Abonnemanget förnyas automatiskt var 3:e månad.';

  @override
  String get goPremium => 'Bli Premium';

  @override
  String get premiumChoosePlan => 'Välj din plan';

  @override
  String get premiumMonthly => 'Månadsvis';

  @override
  String get premiumQuarterly => 'Kvartalsvis';

  @override
  String get premiumPerMonth => 'per månad';

  @override
  String get premiumEvery3Months => 'var 3:e månad';

  @override
  String premiumSavePercent(String percent) {
    return 'Spara $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Månadsplan';

  @override
  String get premiumQuarterlyPlan => 'Kvartalsplan';

  @override
  String get premiumSubscriptionInfo => 'Prenumerationsinformation';
}
