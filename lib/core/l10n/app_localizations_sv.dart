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
  String get cancel => 'AVBRYT';

  @override
  String get save => 'SPARA';

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
  String get loadFirstFavorite => 'Ladda första favoriten vid start';

  @override
  String get loadFirstFavoriteDescription =>
      'Om aktiverad kommer den första favoriten i listan att laddas när appen startar';

  @override
  String get cacheDuration =>
      'Cache-varaktighet för Televideo-sidbilder (0 sekunder för att inaktivera)';

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
  String get onboardingWelcome => 'Välkommen till TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Appen för att snabbt och enkelt konsultera RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Svep åt vänster eller höger för att byta sida, tryck på siffror för att navigera direkt';

  @override
  String get onboardingFavorites => 'Favoriter';

  @override
  String get onboardingFavoritesDescription =>
      'Lägg till sidor i favoriter för snabb åtkomst';

  @override
  String get onboardingRegions => 'Regional Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Få tillgång till din regions Televideo';

  @override
  String get onboardingAutoRefresh => 'Automatisk Uppdatering';

  @override
  String get onboardingAutoRefreshDescription =>
      'Undersidor uppdateras automatiskt';

  @override
  String get onboardingPause => 'Pausa Uppdatering';

  @override
  String get onboardingPauseDescription =>
      'Tryck på ett tomt område för att pausa automatisk uppdatering';

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
      'Tryck på de markerade sidnumren för att navigera direkt till den sidan\n\nSidorna 100/1 av National Televideo och 300/1 av Regional Televideo är inte klickbara';

  @override
  String get onboardingShortcuts => 'Meny Genvägar';

  @override
  String get onboardingShortcutsDescription =>
      'Snabb åtkomst till de viktigaste Televideo-sidorna.\n\nAnvänd denna meny för att hoppa direkt till:\n• Sida 100: Nationellt index\n• Sida 200: Nyheter\n.....\nDu kan också söka sidor efter titel genom att välja alternativet Sök sida';

  @override
  String get onboardingFavoritesList => 'Favoritlista';

  @override
  String get onboardingFavoritesListDescription =>
      'Hantera dina favoritsidor:\n\n• Tryck på en sida för att öppna den\n• Svep åt vänster för att ta bort den\n• Tryck på pennan för att redigera beskrivningen\n• Tryck och håll för att ändra ordningen\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Anpassa appen efter dina preferenser:\n\n• Ladda första favoriten vid start: bestäm vilken Televideo-sida att börja med\n• Tema: välj mellan ljust, mörkt eller automatiskt\n• Automatisk uppdatering: aktivera automatisk laddning av undersidor\n• Cache: hantera sidcachens varaktighet\n• Instruktioner: granska denna handledning när du vill\n• Säkerhetskopiera favoriter: spara och återställ dina favoriter\n• Sekretessinställningar och återställning: hantera eller återställ dina sekretessval';

  @override
  String get dontShowAgain => 'Visa inte igen';

  @override
  String get start => 'Starta';

  @override
  String get reset => 'Återställ';

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
}
