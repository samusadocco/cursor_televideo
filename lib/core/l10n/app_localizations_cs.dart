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
  String get cancel => 'ZRUŠIT';

  @override
  String get save => 'ULOŽIT';

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
  String get loadFirstFavorite => 'Načíst první oblíbenou při spuštění';

  @override
  String get loadFirstFavoriteDescription =>
      'Pokud je povoleno, při spuštění aplikace se načte první oblíbená stránka ze seznamu';

  @override
  String get cacheDuration =>
      'Doba trvání mezipaměti obrázků stránek Televideo (0 sekund pro vypnutí)';

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
  String get onboardingWelcome => 'Vítejte v TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikace pro rychlou a snadnou konzultaci RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigace';

  @override
  String get onboardingNavigationDescription =>
      'Přejeďte doleva nebo doprava pro změnu stránky, klepněte na čísla pro přímou navigaci';

  @override
  String get onboardingFavorites => 'Oblíbené';

  @override
  String get onboardingFavoritesDescription =>
      'Přidejte stránky do oblíbených pro rychlý přístup';

  @override
  String get onboardingRegions => 'Regionální Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Přístup k Televideo vašeho regionu';

  @override
  String get onboardingAutoRefresh => 'Automatické Obnovení';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstránky se automaticky aktualizují';

  @override
  String get onboardingPause => 'Pozastavit Obnovení';

  @override
  String get onboardingPauseDescription =>
      'Klepněte na prázdnou oblast pro pozastavení automatického obnovení';

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
      'Klepněte na zvýrazněná čísla stránek pro přímou navigaci na danou stránku\n\nStránky 100/1 Národního Televideo a 300/1 Regionálního Televideo nejsou klikatelné';

  @override
  String get onboardingShortcuts => 'Menu Zkratek';

  @override
  String get onboardingShortcutsDescription =>
      'Rychlý přístup k nejdůležitějším stránkám Televideo.\n\nPoužijte toto menu pro přímý přechod na:\n• Stránka 100: Národní index\n• Stránka 200: Zprávy\n.....\nMůžete také vyhledávat stránky podle názvu výběrem možnosti Hledat stránku';

  @override
  String get onboardingFavoritesList => 'Seznam Oblíbených';

  @override
  String get onboardingFavoritesListDescription =>
      'Spravujte své oblíbené stránky:\n\n• Klepněte na stránku pro její otevření\n• Přejeďte doleva pro její odstranění\n• Klepněte na tužku pro úpravu popisu\n• Dlouze podržte pro změnu pořadí\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Přizpůsobte si aplikaci podle svých preferencí:\n\n• Načíst první oblíbenou při spuštění: rozhodněte, kterou stránkou Televideo začít\n• Téma: vyberte si mezi světlým, tmavým nebo automatickým\n• Automatické obnovení: povolte automatické načítání podstránek\n• Mezipaměť: spravujte dobu trvání mezipaměti stránek\n• Pokyny: prohlédněte si tento tutoriál kdykoli chcete\n• Zálohovat oblíbené: uložte a obnovte své oblíbené\n• Nastavení soukromí a reset: spravujte nebo resetujte své volby soukromí';

  @override
  String get dontShowAgain => 'Již nezobrazovat';

  @override
  String get start => 'Začít';

  @override
  String get reset => 'Reset';

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
  String get support => 'Podpora';

  @override
  String get supportDescription => 'Kontaktujte nás pro pomoc';

  @override
  String get supportTitle => 'Jsme tu, abychom vám pomohli!';

  @override
  String get supportSubtitle =>
      'V případě jakýchkoli dotazů nebo pomoci nás neváhejte kontaktovat';

  @override
  String get directContact => 'Přímý Kontakt';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get websiteLabel => 'Webová Stránka';

  @override
  String get responseTime => 'Průměrná doba odezvy: 24-48 hodin';

  @override
  String get faq => 'Často Kladené Otázky';

  @override
  String get faqGeolocation => 'Jak funguje geolokace?';

  @override
  String get faqGeolocationAnswer =>
      'Aplikace používá polohu vašeho zařízení k automatické identifikaci vašeho regionu a zobrazování relevantních místních zpráv. Tuto funkci můžete deaktivovat v nastavení aplikace.';

  @override
  String get faqFavorites => 'Jak uložit stránku do oblíbených?';

  @override
  String get faqFavoritesAnswer =>
      'Při prohlížení stránky klepněte na ikonu hvězdičky a přidejte ji do oblíbených. K oblíbeným stránkám máte přístup z hlavní nabídky.';

  @override
  String get faqTheme => 'Jak změnit motiv aplikace?';

  @override
  String get faqThemeAnswer =>
      'Přejděte do nastavení aplikace a vyberte požadovaný motiv (světlý/tmavý). Aplikace také podporuje automatické nastavení na základě systémových nastavení.';

  @override
  String get faqOffline => 'Funguje aplikace offline?';

  @override
  String get faqOfflineAnswer =>
      'Ne, pro přístup k real-time teletextovým stránkám je vyžadováno aktivní připojení k internetu.';

  @override
  String get faqReportProblem => 'Jak nahlásit problém?';

  @override
  String get faqReportProblemAnswer =>
      'Pošlete podrobný e-mail na samuele@codebysam.it s popisem problému.';

  @override
  String get reportBugTitle => 'Nahlásit Problém';

  @override
  String get reportBugInstructions =>
      'Při hlášení problému uveďte pokud možno:';

  @override
  String get reportBugItems =>
      'Verze aplikace\\nModel zařízení\\nOperační systém\\nSnímek obrazovky problému';

  @override
  String get developedBy => 'Vyvinuto CodeBySam';

  @override
  String get errorOpeningLink => 'Nelze otevřít odkaz';

  @override
  String get errorOpeningEmail => 'Nelze otevřít e-mail';
}
