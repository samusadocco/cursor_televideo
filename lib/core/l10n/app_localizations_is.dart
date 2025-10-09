// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Icelandic (`is`).
class AppLocalizationsIs extends AppLocalizations {
  AppLocalizationsIs([String locale = 'is']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Ekki er hægt að hlaða síðumynd.\nVinsamlegast reyndu aftur eftir smástund.';

  @override
  String get pageNotAvailable => 'Umbeðin síða er ekki í boði';

  @override
  String get pageLoadError =>
      'Villa kom upp við að hlaða síðuna.\nTil baka á síðu 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Síða $pageNumber er ekki í boði fyrir $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Síða $pageNumber er ekki í boði fyrir $regionName.\nPrófaðu annað númer á milli 100 og 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Engar fleiri síður í boði fyrir $regionName';
  }

  @override
  String get noMorePages => 'Engar fleiri síður í boði';

  @override
  String get invalidSubpageNumber => 'Ógilt undirsíðunúmer';

  @override
  String subpageError(int current, int total) {
    return 'Villa við að hlaða undirsíðu $current af $total';
  }

  @override
  String get swipePrevious => '← Fyrri';

  @override
  String get swipeNext => 'Næsta →';

  @override
  String get swipeNextUp => 'Næsta ↑';

  @override
  String get swipePreviousDown => 'Fyrri ↓';

  @override
  String get swipeRefresh => 'Endurnýja ↻';

  @override
  String get pageAddedToFavorites => 'Síðu bætt við eftirlæti';

  @override
  String get pageRemovedFromFavorites => 'Síða fjarlægð úr eftirlætum';

  @override
  String get editDescription => 'Breyta lýsingu';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Síða $pageNumber - $regionName';
  }

  @override
  String get description => 'Lýsing';

  @override
  String get enterCustomDescription => 'Sláðu inn sérsniðna lýsingu';

  @override
  String get restoreHint =>
      'Ábending: ýttu lengi á \"ENDURHEIMTA\" hnappinn til að fara aftur í sjálfgefna lýsingu.';

  @override
  String get restore => 'ENDURHEIMTA';

  @override
  String get cancel => 'HÆTTA VIÐ';

  @override
  String get save => 'VISTA';

  @override
  String get searchHint => 'Leita að síðu...';

  @override
  String get noResults => 'Engar niðurstöður';

  @override
  String get settings => 'Stillingar';

  @override
  String get enterPageNumber => 'Sláðu inn síðunúmer';

  @override
  String pageNumberRange(int minPage) {
    return 'Númer frá $minPage til 999';
  }

  @override
  String get ok => 'Í lagi';

  @override
  String get favoritesList => 'Eftirlætislisti';

  @override
  String get confirmRemoval => 'Staðfesta fjarlægingu';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Viltu örugglega fjarlægja $description úr eftirlætum?';
  }

  @override
  String get remove => 'Fjarlægja';

  @override
  String get edit => 'Breyta';

  @override
  String get close => 'Loka';

  @override
  String get noFavorites => 'Engin eftirlæti';

  @override
  String get useFavoriteIcon =>
      'Notaðu ❤️ táknið til að bæta síðum við eftirlæti';

  @override
  String loadingPage(int pageNumber) {
    return 'Hleð síðu $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Engin síða til að bæta við eftirlæti';

  @override
  String get language => 'Tungumál';

  @override
  String get systemLanguage => 'Kerfisstungumál';

  @override
  String get darkMode => 'Dökkur hamur';

  @override
  String get autoRefresh => 'Sjálfvirk endurnýjun';

  @override
  String get favorites => 'Eftirlæti';

  @override
  String get search => 'Leita';

  @override
  String get regions => 'Svæði';

  @override
  String get home => 'Heim';

  @override
  String get addToFavorites => 'Bæta við eftirlæti';

  @override
  String get removeFromFavorites => 'Fjarlægja úr eftirlætum';

  @override
  String get loading => 'Hleður...';

  @override
  String get error => 'Villa';

  @override
  String errorWithMessage(String message) {
    return 'Villa: $message';
  }

  @override
  String get retry => 'Reyna aftur';

  @override
  String get next => 'Áfram';

  @override
  String get previous => 'Til baka';

  @override
  String get pageNotFound => 'Síða fannst ekki';

  @override
  String get networkError => 'Netvilla';

  @override
  String get connectionRequired => 'Tenging nauðsynleg';

  @override
  String get refreshing => 'Endurnýjar...';

  @override
  String get lastUpdate => 'Síðasta uppfærsla';

  @override
  String get theme => 'Þema';

  @override
  String get systemTheme => 'Kerfisþema';

  @override
  String get lightTheme => 'Ljóst þema';

  @override
  String get darkTheme => 'Dökkt þema';

  @override
  String get selectTheme => 'Veldu þema';

  @override
  String get loadFirstFavorite => 'Hlaða fyrsta eftirlæti við ræsingu';

  @override
  String get loadFirstFavoriteDescription =>
      'Ef virkt, verður fyrsta eftirlætissíðan á listanum hlaðin þegar forritið er ræst';

  @override
  String get cacheDuration =>
      'Skyndiminni Televideo síðumynda (0 sekúndur til að slökkva)';

  @override
  String get seconds => 'sekúndur';

  @override
  String get autoRefreshDescription => 'Endurnýja undirsíður sjálfkrafa';

  @override
  String get refreshInterval => 'Endurnýjunarbil';

  @override
  String get showOnboardingAtStartup => 'Sýna leiðbeiningar við ræsingu';

  @override
  String get showOnboardingAtStartupDescription =>
      'Sýna leiðbeiningar í hvert skipti sem þú opnar forritið';

  @override
  String get showInstructions => 'Sýna leiðbeiningar';

  @override
  String get showInstructionsDescription =>
      'Skoða notkunarleiðbeiningar forritsins';

  @override
  String get backupFavorites => 'Afrita eftirlæti';

  @override
  String get backupFavoritesDescription =>
      'Vista og endurheimta eftirlætin þín';

  @override
  String get privacySettings => 'Persónuverndstillingar';

  @override
  String get privacySettingsDescription =>
      'Breyta persónuverndarvalkostum þínum fyrir auglýsingar';

  @override
  String get resetPrivacySettings => 'Endurstilla persónuverndstillingar';

  @override
  String get resetPrivacySettingsDescription =>
      'Endurstilla allar persónuverndstillingar';

  @override
  String get resetPrivacyConfirm =>
      'Viltu örugglega endurstilla persónuverndstillingar? Þú verður beðin/n um samþykki aftur næst þegar þú ræsir forritið.';

  @override
  String get privacySettingsUnavailable =>
      'Persónuverndstillingar eru ekki í boði núna';

  @override
  String get privacySettingsReset =>
      'Persónuverndstillingar endurstilltar. Endurræstu forritið fyrir nýtt samþykki.';

  @override
  String get version => 'Útgáfa';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Velkomin í TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Forritið til að skoða RAI Televideo á fljótlegan og auðveldan hátt';

  @override
  String get onboardingNavigation => 'Leiðsögn';

  @override
  String get onboardingNavigationDescription =>
      'Strjúktu til vinstri eða hægri til að skipta um síðu, ýttu á númer fyrir beina leiðsögn';

  @override
  String get onboardingFavorites => 'Eftirlæti';

  @override
  String get onboardingFavoritesDescription =>
      'Bættu síðum við eftirlæti fyrir fljótan aðgang';

  @override
  String get onboardingRegions => 'Svæðisbundið Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Fáðu aðgang að Televideo svæðisins þíns';

  @override
  String get onboardingAutoRefresh => 'Sjálfvirk Endurnýjun';

  @override
  String get onboardingAutoRefreshDescription =>
      'Undirsíður uppfærast sjálfkrafa';

  @override
  String get onboardingPause => 'Gera hlé á Endurnýjun';

  @override
  String get onboardingPauseDescription =>
      'Ýttu á autt svæði til að gera hlé á sjálfvirkri endurnýjun';

  @override
  String get onboardingPageSelector => 'Síðuval';

  @override
  String get onboardingPageSelectorDescription =>
      'Ýttu á miðjunúmerið til að slá beint inn síðu.\n\nSláðu inn númer á milli 100 og 999 til að hoppa á þá síðu.';

  @override
  String get onboardingSubpageNavigation => 'Undirsíðuleiðsögn';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Ef síðan hefur undirsíður, muntu einnig sjá vísinn:\n• 1/3 þýðir: fyrsta undirsíða af þremur í boði\n\nNotaðu miðjuörvarnar til að fara á milli undirsíða:\n\n• Ör upp: fara á næstu undirsíðu\n• Ör niður: fara á fyrri undirsíðu\n\nÖrvarnar eru aðeins virkar þegar undirsíður eru í boði.';

  @override
  String get onboardingSwipe => 'Strjúkleiðsögn';

  @override
  String get onboardingSwipeDescription =>
      'Ferðastu auðveldlega á milli síðna með bendingunum sem sýndar eru fyrir ofan.';

  @override
  String get onboardingClickableNumbers => 'Smellanlegar Síðunúmer';

  @override
  String get onboardingClickableNumbersDescription =>
      'Ýttu á auðkennd síðunúmer til að fara beint á þá síðu\n\nSíður 100/1 af Þjóðar Televideo og 300/1 af Svæðisbundnu Televideo eru ekki smellanlegar';

  @override
  String get onboardingShortcuts => 'Valmynd Flýtileiða';

  @override
  String get onboardingShortcutsDescription =>
      'Fljótur aðgangur að mikilvægustu Televideo síðunum.\n\nNotaðu þessa valmynd til að hoppa beint á:\n• Síða 100: Þjóðaryfirlit\n• Síða 200: Fréttir\n.....\nÞú getur líka leitað að síðum eftir titli með því að velja Leita að síðu valkostinn';

  @override
  String get onboardingFavoritesList => 'Eftirlætislisti';

  @override
  String get onboardingFavoritesListDescription =>
      'Stjórnaðu eftirlætissíðunum þínum:\n\n• Ýttu á síðu til að opna hana\n• Strjúktu til vinstri til að fjarlægja hana\n• Ýttu á blýantinn til að breyta lýsingu\n• Ýttu lengi til að breyta röðun\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Sérsníðdu forritið að þínum þörfum:\n\n• Hlaða fyrsta eftirlæti við ræsingu: ákveddu hvaða Televideo síðu á að byrja á\n• Þema: veldu á milli ljóss, dökks eða sjálfvirks\n• Sjálfvirk endurnýjun: virkjaðu sjálfvirka hleðslu undirsíða\n• Skyndiminni: stjórnaðu tímalengd síðuskyndiminnis\n• Leiðbeiningar: skoðaðu þessa kennslu hvenær sem er\n• Afrita eftirlæti: vistaðu og endurheimtu eftirlætin þín\n• Persónuverndstillingar og endurstilling: stjórnaðu eða endurstilltu persónuverndarval þitt';

  @override
  String get dontShowAgain => 'Ekki sýna aftur';

  @override
  String get start => 'Byrja';

  @override
  String get reset => 'Endurstilla';

  @override
  String backToPage(int pageNumber) {
    return 'Til baka á síðu $pageNumber';
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
  String get support => 'Stuðningur';

  @override
  String get supportDescription => 'Hafðu samband fyrir aðstoð';

  @override
  String get supportTitle => 'Við erum hér til að hjálpa!';

  @override
  String get supportSubtitle =>
      'Fyrir allar spurningar eða aðstoð, ekki hika við að hafa samband við okkur';

  @override
  String get directContact => 'Beinn Tengiliður';

  @override
  String get emailLabel => 'Netfang';

  @override
  String get websiteLabel => 'Vefsíða';

  @override
  String get responseTime => 'Meðalsvörunartími: 24-48 klukkustundir';

  @override
  String get faq => 'Algengar Spurningar';

  @override
  String get faqGeolocation => 'Hvernig virkar staðsetning?';

  @override
  String get faqGeolocationAnswer =>
      'Forritið notar staðsetningu tækisins til að auðkenna sjálfkrafa svæðið þitt og sýna viðeigandi staðbundnar fréttir. Þú getur slökkt á þessari aðgerð í stillingum forritsins.';

  @override
  String get faqFavorites => 'Hvernig vista ég síðu í eftirlæti?';

  @override
  String get faqFavoritesAnswer =>
      'Þegar þú skoðar síðu skaltu ýta á stjörnutáknið til að bæta henni við eftirlæti. Þú getur nálgast eftirlætissíður þínar frá aðalvalmyndinni.';

  @override
  String get faqTheme => 'Hvernig breyti ég þema forritsins?';

  @override
  String get faqThemeAnswer =>
      'Farðu í stillingar forritsins og veldu þitt æskilega þema (ljóst/dökkt). Forritið styður einnig sjálfvirka stillingu byggða á kerfisst illum.';

  @override
  String get faqOffline => 'Virkar forritið án nettengingar?';

  @override
  String get faqOfflineAnswer =>
      'Nei, virk nettenging er nauðsynleg til að fá aðgang að texta-sjónvarps síðum í rauntíma.';

  @override
  String get faqReportProblem => 'Hvernig tilkynni ég um vandamál?';

  @override
  String get faqReportProblemAnswer =>
      'Sendu ítarlegt netfang á samuele@codebysam.it með lýsingu á vandamálinu.';

  @override
  String get reportBugTitle => 'Tilkynna Vandamál';

  @override
  String get reportBugInstructions =>
      'Þegar þú tilkynnir vandamál skaltu innihalda ef mögulegt:';

  @override
  String get reportBugItems =>
      'Útgáfa forrits\\nTæki líkan\\nStýrikerfi\\nSkjámynd af vandamáli';

  @override
  String get developedBy => 'Þróað af CodeBySam';

  @override
  String get errorOpeningLink => 'Get ekki opnað tengil';

  @override
  String get errorOpeningEmail => 'Get ekki opnað netfang';
}
