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
  String get welcome => 'Velkomin!';

  @override
  String get welcomeSelectChannel => 'Velja sjálfgefna rás';

  @override
  String page(int pageNumber) {
    return 'Síða $pageNumber';
  }

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
  String get cancel => 'Hætta við';

  @override
  String get save => 'Vista';

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
  String get startupPageOption => 'Upphafssíða';

  @override
  String get startupPageOptionLastPage => 'Síðasta skoðaða síða (sjálfgefið)';

  @override
  String get startupPageOptionFirstFavorite => 'Fyrsta eftirlæti (ef í boði)';

  @override
  String get startupPageOptionChannelHomePage => 'Upphafssíða síðustu rásar';

  @override
  String get cacheDuration =>
      'Skyndiminni Textavarp síðumynda (0 sekúndur til að slökkva)';

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
  String get onboardingWelcome => 'Velkomin í Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Forritið til að skoða RAI Textavarp á fljótlegan og auðveldan hátt';

  @override
  String get onboardingDefaultChannel => 'Velja Sjálfgefna Rás';

  @override
  String get onboardingDefaultChannelDescription =>
      'Þegar þú ræsir appið verður þú beðinn um að velja uppáhaldsrásina þína úr öllum tiltækum rásum.\n\nÞú getur breytt sjálfgefnu rásinni hvenær sem er úr valmyndinni Stillingar.';

  @override
  String get onboardingNavigation => 'Leiðsögn';

  @override
  String get onboardingNavigationDescription =>
      'Strjúktu til vinstri eða hægri til að skipta um síðu, ýttu á númer fyrir beina leiðsögn';

  @override
  String get onboardingFavorites => 'Eftirlæti';

  @override
  String get onboardingFavoritesDescription =>
      'Vistaðu síðurnar sem þú heimsækir oftast:\n\n• Pikkaðu á tilgreinda táknið til að bæta við núverandi síðu\n• Pikkaðu aftur til að fjarlægja úr uppáhaldi\n• Táknið verður rautt þegar síðan er í uppáhaldi\n\nÞú getur vistað bæði lands- og svæðissíður.';

  @override
  String get onboardingRegions => 'Rásir frá Allri Evrópu';

  @override
  String get onboardingRegionsDescription =>
      'Veldu og skipulagðu uppáhaldsrásirnar þínar frá allri Evrópu.\n\nLeitaðu eftir nafni rásar eða nafni lands.\n\nÞú getur nálgast textavarpa frá Ítalíu, Þýskalandi, Austurríki, Sviss og mörgum öðrum Evrópulöndum!';

  @override
  String get onboardingAutoRefresh => 'Sjálfvirk Endurnýjun';

  @override
  String get onboardingAutoRefreshDescription =>
      'Þegar sjálfvirk uppfærsla er virk, fyllist hringurinn í kringum síðunúmerið smám saman:\n\nÞú getur breytt uppfærslutíma í stillingum\n\nVísirinn er aðeins sýnilegur þegar undirsíður eru tiltækar og sjálfvirk uppfærsla er virk.';

  @override
  String get onboardingPause => 'Gera hlé á Endurnýjun';

  @override
  String get onboardingPauseDescription =>
      'Þú getur gert hlé á sjálfvirkri uppfærslu undirsíðna:\n\n• Pikkaðu hvar sem er á síðunni þar sem engar smellanlegar tölur eru\n• Þú munt sjá ⏸️ táknið birtast til að gefa til kynna að uppfærsla sé í bið\n• Pikkaðu aftur til að halda áfram uppfærslu (▶️ tákn)\n\nÞessi aðgerð er gagnleg þegar þú vilt lesa undirsíðu í ró án þess að henni breytist sjálfkrafa.';

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
      'Ýttu á auðkennd síðunúmer til að fara beint á þá síðu\n\n';

  @override
  String get onboardingShortcuts => 'Valmynd Flýtileiða';

  @override
  String get onboardingShortcutsDescription =>
      'Fljótur aðgangur að mikilvægustu Textavarp síðunum.\n\nNotaðu þessa valmynd til að hoppa beint á:\n• Síða 100: Þjóðaryfirlit\n• Síða 200: Fréttir\n.....\nÞú getur líka leitað að síðum eftir titli með því að velja Leita að síðu valkostinn';

  @override
  String get onboardingFavoritesList => 'Eftirlætislisti';

  @override
  String get onboardingFavoritesListDescription =>
      'Stjórnaðu eftirlætissíðunum þínum:\n\n• Ýttu á síðu til að opna hana\n• Strjúktu til vinstri til að fjarlægja hana\n• Ýttu á blýantinn til að breyta lýsingu\n• Ýttu lengi til að breyta röðun\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Sérsníðdu forritið að þínum þörfum:\n\n• Hlaða fyrsta eftirlæti við ræsingu: ákveddu hvaða Textavarp síðu á að byrja á\n• Þema: veldu á milli ljóss, dökks eða sjálfvirks\n• Sjálfvirk endurnýjun: virkjaðu sjálfvirka hleðslu undirsíða\n• Skyndiminni: stjórnaðu tímalengd síðuskyndiminnis\n• Leiðbeiningar: skoðaðu þessa kennslu hvenær sem er\n• Afrita eftirlæti: vistaðu og endurheimtu eftirlætin þín\n• Persónuverndstillingar og endurstilling: stjórnaðu eða endurstilltu persónuverndarval þitt';

  @override
  String get dontShowAgain => 'Ekki sýna aftur';

  @override
  String get start => 'Byrja';

  @override
  String get reset => 'Endurstilla';

  @override
  String get resetInitialChannel => 'Endurstilla upphafsrás';

  @override
  String get resetInitialChannelDescription =>
      'Sýna rásarvalsgluggann aftur við næstu ræsingu';

  @override
  String get resetCompleted => 'Endurstilling lokið';

  @override
  String get resetInitialChannelMessage =>
      'Upphafsrásin hefur verið endurstillt.\n\nVið næstu ræsingu forritsins verður þú beðinn um að velja sjálfgefnu rásina þína aftur.\n\nEndurræsi forritið núna...';

  @override
  String get selectYourChannel =>
      'Veldu sjálfgefnu Textavarp rásina þína.\nÞú getur breytt henni hvenær sem er.';

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
  String get channelSelection => 'Val á rás';

  @override
  String get favoriteChannels => 'Uppáhalds rásir';

  @override
  String get reorder => 'Endurraða';

  @override
  String get searchChannelOrCountry => 'Leita að rás eða landi...';

  @override
  String get showAllChannels => 'Sýna allar rásir';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count rásir tiltækar frá $countries löndum';
  }

  @override
  String get allChannels => 'Allar rásir';

  @override
  String get noFavoriteChannelsFound => 'Engar uppáhalds rásir fundust';

  @override
  String get noChannelsFound => 'Engar rásir fundust';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name bætt við uppáhald';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name fjarlægt úr uppáhaldi';
  }

  @override
  String regionsAvailable(int count) {
    return '$count svæði tiltæk';
  }

  @override
  String get reorderFavorites => 'Endurraða uppáhaldi';

  @override
  String get countryIT => 'Ítalía';

  @override
  String get countryDE => 'Þýskaland';

  @override
  String get countryAT => 'Austurríki';

  @override
  String get countryCH => 'Sviss';

  @override
  String get countryES => 'Spánn';

  @override
  String get countryPT => 'Portúgal';

  @override
  String get countryNL => 'Holland';

  @override
  String get countrySE => 'Svíþjóð';

  @override
  String get countryFI => 'Finnland';

  @override
  String get countryDK => 'Danmörk';

  @override
  String get countryCZ => 'Tékkland';

  @override
  String get countryHR => 'Króatía';

  @override
  String get countryBA => 'Bosnía og Hersegóvína';

  @override
  String get countryHU => 'Ungverjaland';

  @override
  String get countryIS => 'Ísland';

  @override
  String get countrySI => 'Slóvenía';

  @override
  String get countryUA => 'Úkraína';
}
