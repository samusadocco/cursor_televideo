// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Vítejte!';

  @override
  String get welcomeSelectChannel => 'Vybrat výchozí kanál';

  @override
  String page(int pageNumber) {
    return 'Stránka $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Nelze načíst obrázek stránky.\nZkuste to prosím za chvíli znovu.';

  @override
  String get pageNotAvailable => 'Požadovaná stránka není k dispozici';

  @override
  String get pageLoadError =>
      'Při načítání stránky došlo k chybě.\nZpět na stránku 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Stránka $pageNumber není k dispozici pro $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Stránka $pageNumber není k dispozici pro $regionName.\nZkuste jiné číslo mezi 100 a 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Pro $regionName nejsou k dispozici žádné další stránky';
  }

  @override
  String get noMorePages => 'Nejsou k dispozici žádné další stránky';

  @override
  String get invalidSubpageNumber => 'Neplatné číslo podstránky';

  @override
  String subpageError(int current, int total) {
    return 'Chyba při načítání podstránky $current z $total';
  }

  @override
  String get swipePrevious => '← Předchozí';

  @override
  String get swipeNext => 'Další →';

  @override
  String get swipeNextUp => 'Další ↑';

  @override
  String get swipePreviousDown => 'Předchozí ↓';

  @override
  String get swipeRefresh => 'Obnovit ↻';

  @override
  String get pageAddedToFavorites => 'Stránka přidána do oblíbených';

  @override
  String get pageRemovedFromFavorites => 'Stránka odstraněna z oblíbených';

  @override
  String get editDescription => 'Upravit popis';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Stránka $pageNumber - $regionName';
  }

  @override
  String get description => 'Popis';

  @override
  String get enterCustomDescription => 'Zadejte vlastní popis';

  @override
  String get restoreHint =>
      'Tip: dlouhým stiskem tlačítka \"OBNOVIT\" se vrátíte k výchozímu popisu.';

  @override
  String get restore => 'OBNOVIT';

  @override
  String get cancel => 'Zrušit';

  @override
  String get save => 'Uložit';

  @override
  String get searchHint => 'Hledat stránku...';

  @override
  String get noResults => 'Žádné výsledky';

  @override
  String get settings => 'Nastavení';

  @override
  String get enterPageNumber => 'Zadejte číslo stránky';

  @override
  String pageNumberRange(int minPage) {
    return 'Číslo od $minPage do 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Seznam oblíbených';

  @override
  String get confirmRemoval => 'Potvrdit odstranění';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Opravdu chcete odstranit $description z oblíbených?';
  }

  @override
  String get remove => 'Odstranit';

  @override
  String get edit => 'Upravit';

  @override
  String get close => 'Zavřít';

  @override
  String get noFavorites => 'Žádné oblíbené';

  @override
  String get useFavoriteIcon =>
      'Použijte ikonu ❤️ pro přidání stránek do oblíbených';

  @override
  String loadingPage(int pageNumber) {
    return 'Načítání stránky $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Žádná stránka k přidání do oblíbených';

  @override
  String get language => 'Jazyk';

  @override
  String get systemLanguage => 'Systémový jazyk';

  @override
  String get darkMode => 'Tmavý režim';

  @override
  String get autoRefresh => 'Automatické obnovení';

  @override
  String get favorites => 'Oblíbené';

  @override
  String get search => 'Hledat';

  @override
  String get regions => 'Regiony';

  @override
  String get home => 'Domů';

  @override
  String get addToFavorites => 'Přidat do oblíbených';

  @override
  String get removeFromFavorites => 'Odstranit z oblíbených';

  @override
  String get loading => 'Načítání...';

  @override
  String get error => 'Chyba';

  @override
  String errorWithMessage(String message) {
    return 'Chyba: $message';
  }

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get next => 'Další';

  @override
  String get previous => 'Předchozí';

  @override
  String get pageNotFound => 'Stránka nenalezena';

  @override
  String get networkError => 'Chyba sítě';

  @override
  String get connectionRequired => 'Vyžadováno připojení';

  @override
  String get refreshing => 'Obnovování...';

  @override
  String get lastUpdate => 'Poslední aktualizace';

  @override
  String get theme => 'Téma';

  @override
  String get systemTheme => 'Systémové téma';

  @override
  String get lightTheme => 'Světlé téma';

  @override
  String get darkTheme => 'Tmavé téma';

  @override
  String get selectTheme => 'Vybrat téma';

  @override
  String get startupPageOption => 'Úvodní stránka';

  @override
  String get startupPageOptionLastPage =>
      'Naposledy zobrazená stránka (výchozí)';

  @override
  String get startupPageOptionFirstFavorite =>
      'První oblíbená (pokud je k dispozici)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Domovská stránka posledního kanálu';

  @override
  String get cacheDuration =>
      'Doba trvání mezipaměti obrázků stránek Teletext (0 sekund pro vypnutí)';

  @override
  String get seconds => 'sekund';

  @override
  String get autoRefreshDescription => 'Automaticky obnovovat podstránky';

  @override
  String get refreshInterval => 'Interval obnovení';

  @override
  String get showOnboardingAtStartup => 'Zobrazit pokyny při spuštění';

  @override
  String get showOnboardingAtStartupDescription =>
      'Zobrazit pokyny při každém otevření aplikace';

  @override
  String get showInstructions => 'Zobrazit pokyny';

  @override
  String get showInstructionsDescription =>
      'Prohlédnout si pokyny k použití aplikace';

  @override
  String get backupFavorites => 'Zálohovat oblíbené';

  @override
  String get backupFavoritesDescription => 'Uložit a obnovit vaše oblíbené';

  @override
  String get support => 'Podpora';

  @override
  String get supportDescription => 'Kontaktujte nás pro pomoc';

  @override
  String get supportTitle => 'Jsme tu, abychom vám pomohli!';

  @override
  String get supportSubtitle =>
      'Pro jakékoli otázky nebo pomoc nás neváhejte kontaktovat';

  @override
  String get directContact => 'Přímý Kontakt';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get websiteLabel => 'Webová stránka';

  @override
  String get responseTime => 'Průměrná doba odezvy: 24-48 hodin';

  @override
  String get faq => 'Často Kladené Otázky';

  @override
  String get faqGeolocation => 'Jak funguje geolokace?';

  @override
  String get faqGeolocationAnswer =>
      'Aplikace používá polohu vašeho zařízení k automatické identifikaci vaší oblasti a zobrazení relevantních místních zpráv. Tuto funkci můžete vypnout v nastavení aplikace.';

  @override
  String get faqFavorites => 'Jak uložit stránku do oblíbených?';

  @override
  String get faqFavoritesAnswer =>
      'Při prohlížení stránky klepněte na ikonu hvězdičky a přidejte ji do oblíbených. K oblíbeným stránkám se dostanete z hlavní nabídky.';

  @override
  String get faqTheme => 'Jak změnit motiv aplikace?';

  @override
  String get faqThemeAnswer =>
      'Přejděte do nastavení aplikace a vyberte požadovaný motiv (světlý/tmavý). Aplikace také podporuje automatické nastavení na základě systémových nastavení.';

  @override
  String get faqOffline => 'Funguje aplikace offline?';

  @override
  String get faqOfflineAnswer =>
      'Ne, pro přístup ke stránkám Teletextu v reálném čase je vyžadováno aktivní připojení k internetu.';

  @override
  String get faqReportProblem => 'Jak nahlásit problém?';

  @override
  String get faqReportProblemAnswer =>
      'Zašlete podrobný e-mail na adresu samuele@codebysam.it s popisem problému.';

  @override
  String get reportBugTitle => 'Nahlásit problém';

  @override
  String get reportBugInstructions =>
      'Při nahlašování problému uveďte pokud možno:';

  @override
  String get reportBugItems =>
      'Verze aplikace\nModel zařízení\nOperační systém\nSnímek obrazovky problému';

  @override
  String get developedBy => 'Vyvinuto společností CodeBySam';

  @override
  String get errorOpeningLink => 'Nelze otevřít odkaz';

  @override
  String get errorOpeningEmail => 'Nelze otevřít e-mail';

  @override
  String get privacySettings => 'Nastavení soukromí';

  @override
  String get privacySettingsDescription =>
      'Upravit vaše předvolby soukromí pro reklamy';

  @override
  String get resetPrivacySettings => 'Resetovat nastavení soukromí';

  @override
  String get resetPrivacySettingsDescription =>
      'Kompletně resetovat nastavení soukromí';

  @override
  String get resetPrivacyConfirm =>
      'Opravdu chcete resetovat nastavení soukromí? Při příštím spuštění aplikace budete požádáni o nový souhlas.';

  @override
  String get privacySettingsUnavailable =>
      'Nastavení soukromí není momentálně k dispozici';

  @override
  String get privacySettingsReset =>
      'Nastavení soukromí resetováno. Restartujte aplikaci pro nový souhlas.';

  @override
  String get version => 'Verze';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Vítejte v Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikace pro rychlou a snadnou konzultaci RAI Teletext';

  @override
  String get onboardingDefaultChannel => 'Vybrat Výchozí Kanál';

  @override
  String get onboardingDefaultChannelDescription =>
      'Při spuštění aplikace budete požádáni o výběr preferovaného kanálu ze všech dostupných kanálů.\n\nVýchozí kanál můžete kdykoli změnit v nabídce Nastavení.';

  @override
  String get onboardingNavigation => 'Navigace';

  @override
  String get onboardingNavigationDescription =>
      'Přejeďte doleva nebo doprava pro změnu stránky, klepněte na čísla pro přímou navigaci';

  @override
  String get onboardingFavorites => 'Oblíbené';

  @override
  String get onboardingFavoritesDescription =>
      'Uložte stránky, které navštěvujete nejčastěji:\n\n• Klepněte na uvedenou ikonu pro přidání aktuální stránky\n• Klepněte znovu pro odebrání z oblíbených\n• Ikona zčervená, když je stránka v oblíbených\n\nMůžete uložit národní i regionální stránky.';

  @override
  String get onboardingRegions => 'Kanály z Celé Evropy';

  @override
  String get onboardingRegionsDescription =>
      'Vyberte a uspořádejte své oblíbené kanály z celé Evropy.\n\nHledejte podle názvu kanálu nebo názvu země.\n\nMůžete přistupovat k teletextu z Itálie, Německa, Rakouska, Švýcarska a mnoha dalších evropských zemí!';

  @override
  String get onboardingAutoRefresh => 'Automatické Obnovení';

  @override
  String get onboardingAutoRefreshDescription =>
      'Když je aktivní automatické obnovení, kruh kolem čísla stránky se postupně plní:\n\nČas obnovení můžete změnit v nastavení\n\nIndikátor je viditelný pouze tehdy, když jsou k dispozici podstránky a automatické obnovení je aktivní.';

  @override
  String get onboardingPause => 'Pozastavit Obnovení';

  @override
  String get onboardingPauseDescription =>
      'Můžete pozastavit automatické obnovení podstránek:\n\n• Klepněte kdekoli na stránce, kde nejsou klikatelná čísla\n• Uvidíte se zobrazit ikonu ⏸️, která označuje, že obnovení je pozastaveno\n• Klepněte znovu pro pokračování obnovení (ikona ▶️)\n\nTato funkce je užitečná, když chcete číst podstránku v klidu, aniž by se automaticky měnila.';

  @override
  String get onboardingPageSelector => 'Výběr Stránky';

  @override
  String get onboardingPageSelectorDescription =>
      'Klepněte na prostřední číslo pro přímé zadání stránky.\n\nZadejte číslo mezi 100 a 999 pro přechod na danou stránku.';

  @override
  String get onboardingSubpageNavigation => 'Navigace Podstránek';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Pokud má stránka podstránky, uvidíte také indikátor:\n• 1/3 znamená: první podstránka ze tří dostupných\n\nPoužijte prostřední šipky pro navigaci mezi podstránkami:\n\n• Šipka nahoru: přejít na další podstránku\n• Šipka dolů: přejít na předchozí podstránku\n\nŠipky jsou aktivní pouze když jsou k dispozici podstránky.';

  @override
  String get onboardingSwipe => 'Navigace Přejetím';

  @override
  String get onboardingSwipeDescription =>
      'Snadno navigujte mezi stránkami pomocí gest zobrazených výše.';

  @override
  String get onboardingClickableNumbers => 'Klikatelná Čísla Stránek';

  @override
  String get onboardingClickableNumbersDescription =>
      'Klepněte na zvýrazněná čísla stránek pro přímou navigaci na danou stránku\n\n';

  @override
  String get onboardingShortcuts => 'Menu Zkratek';

  @override
  String get onboardingShortcutsDescription =>
      'Rychlý přístup k nejdůležitějším stránkám Teletext.\n\nPoužijte toto menu pro přímý přechod na:\n• Stránka 100: Národní index\n• Stránka 200: Zprávy\n.....\nMůžete také vyhledávat stránky podle názvu výběrem možnosti Hledat stránku';

  @override
  String get onboardingFavoritesList => 'Seznam Oblíbených';

  @override
  String get onboardingFavoritesListDescription =>
      'Spravujte své oblíbené stránky:\n\n• Klepněte na stránku pro její otevření\n• Přejeďte doleva pro její odstranění\n• Klepněte na tužku pro úpravu popisu\n• Dlouze podržte pro změnu pořadí\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Přizpůsobte si aplikaci podle svých preferencí:\n\n• Načíst první oblíbenou při spuštění: rozhodněte, kterou stránkou Teletext začít\n• Téma: vyberte si mezi světlým, tmavým nebo automatickým\n• Automatické obnovení: povolte automatické načítání podstránek\n• Mezipaměť: spravujte dobu trvání mezipaměti stránek\n• Pokyny: prohlédněte si tento tutoriál kdykoli chcete\n• Zálohovat oblíbené: uložte a obnovte své oblíbené\n• Nastavení soukromí a reset: spravujte nebo resetujte své volby soukromí';

  @override
  String get dontShowAgain => 'Již nezobrazovat';

  @override
  String get start => 'Začít';

  @override
  String get reset => 'Reset';

  @override
  String get resetInitialChannel => 'Obnovit počáteční kanál';

  @override
  String get resetInitialChannelDescription =>
      'Zobrazit dialog výběru kanálu znovu při příštím spuštění';

  @override
  String get resetCompleted => 'Obnovení dokončeno';

  @override
  String get resetInitialChannelMessage =>
      'Počáteční kanál byl obnoven.\n\nPři příštím spuštění aplikace budete požádáni o opětovný výběr výchozího kanálu.\n\nRestartování aplikace nyní...';

  @override
  String get selectYourChannel =>
      'Vyberte svůj výchozí kanál Teletextu.\nMůžete ho kdykoli změnit.';

  @override
  String backToPage(int pageNumber) {
    return 'Zpět na stránku $pageNumber';
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
  String get channelSelection => 'Výběr kanálu';

  @override
  String get favoriteChannels => 'Oblíbené kanály';

  @override
  String get reorder => 'Přeuspořádat';

  @override
  String get searchChannelOrCountry => 'Hledat kanál nebo zemi...';

  @override
  String get showAllChannels => 'Zobrazit všechny kanály';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanálů dostupných z $countries zemí';
  }

  @override
  String get allChannels => 'Všechny kanály';

  @override
  String get noFavoriteChannelsFound => 'Žádné oblíbené kanály nenalezeny';

  @override
  String get noChannelsFound => 'Žádné kanály nenalezeny';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name přidán do oblíbených';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name odebrán z oblíbených';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regionů dostupných';
  }

  @override
  String get reorderFavorites => 'Přeuspořádat oblíbené';

  @override
  String get countryIT => 'Itálie';

  @override
  String get countryDE => 'Německo';

  @override
  String get countryAT => 'Rakousko';

  @override
  String get countryCH => 'Švýcarsko';

  @override
  String get countryES => 'Španělsko';

  @override
  String get countryPT => 'Portugalsko';

  @override
  String get countryNL => 'Nizozemsko';

  @override
  String get countrySE => 'Švédsko';

  @override
  String get countryFI => 'Finsko';

  @override
  String get countryDK => 'Dánsko';

  @override
  String get countryCZ => 'Česko';

  @override
  String get countryHR => 'Chorvatsko';

  @override
  String get countryBA => 'Bosna a Hercegovina';

  @override
  String get countryHU => 'Maďarsko';

  @override
  String get countryIS => 'Island';

  @override
  String get countrySI => 'Slovinsko';

  @override
  String get countryUA => 'Ukrajina';
}
