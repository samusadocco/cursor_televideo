// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Nastavení';

  @override
  String get language => 'Jazyk';

  @override
  String get systemLanguage => 'Systémový jazyk';

  @override
  String get darkMode => 'Tmavý režim';

  @override
  String get autoRefresh => 'Automatická aktualizace';

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
  String get removeFromFavorites => 'Odebrat z oblíbených';

  @override
  String get searchHint => 'Zadejte číslo stránky';

  @override
  String get noResults => 'Žádné výsledky';

  @override
  String get loading => 'Načítání...';

  @override
  String get error => 'Chyba';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Zrušit';

  @override
  String get close => 'Zavřít';

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
  String get refreshing => 'Aktualizace...';

  @override
  String get lastUpdate => 'Poslední aktualizace';

  @override
  String get theme => 'Motiv';

  @override
  String get systemTheme => 'Systémový motiv';

  @override
  String get lightTheme => 'Světlý motiv';

  @override
  String get darkTheme => 'Tmavý motiv';

  @override
  String get selectTheme => 'Vybrat motiv';

  @override
  String get loadFirstFavorite => 'Načíst první oblíbenou při spuštění';

  @override
  String get loadFirstFavoriteDescription =>
      'Pokud je povoleno, první oblíbená stránka se načte při spuštění aplikace';

  @override
  String get cacheDuration =>
      'Doba ukládání stránek Televideo do mezipaměti (0 sekund pro vypnutí)';

  @override
  String get seconds => 'sekund';

  @override
  String get autoRefreshDescription => 'Automaticky aktualizovat podstránky';

  @override
  String get refreshInterval => 'Interval aktualizace';

  @override
  String get showOnboardingAtStartup => 'Zobrazit instrukce při spuštění';

  @override
  String get showOnboardingAtStartupDescription =>
      'Zobrazit instrukce při každém spuštění aplikace';

  @override
  String get showInstructions => 'Zobrazit instrukce';

  @override
  String get showInstructionsDescription =>
      'Znovu zobrazit instrukce k používání aplikace';

  @override
  String get backupFavorites => 'Zálohovat oblíbené';

  @override
  String get backupFavoritesDescription => 'Uložit a obnovit vaše oblíbené';

  @override
  String get privacySettings => 'Nastavení soukromí';

  @override
  String get privacySettingsDescription =>
      'Upravit nastavení soukromí pro reklamy';

  @override
  String get resetPrivacySettings => 'Obnovit nastavení soukromí';

  @override
  String get resetPrivacySettingsDescription =>
      'Kompletně obnovit nastavení soukromí';

  @override
  String get resetPrivacyConfirm =>
      'Opravdu chcete obnovit nastavení soukromí? Při příštím spuštění aplikace budete muset znovu udělit souhlas.';

  @override
  String get privacySettingsUnavailable =>
      'Nastavení soukromí není momentálně dostupné';

  @override
  String get privacySettingsReset =>
      'Nastavení soukromí obnoveno. Restartujte aplikaci pro nový souhlas.';

  @override
  String get version => 'Verze';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Vítejte v TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikace pro snadné a rychlé prohlížení RAI Televideo';

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
  String get onboardingAutoRefresh => 'Automatická Aktualizace';

  @override
  String get onboardingAutoRefreshDescription =>
      'Podstránky se automaticky aktualizují';

  @override
  String get onboardingPause => 'Pozastavit Aktualizaci';

  @override
  String get onboardingPauseDescription =>
      'Klepněte na prázdnou oblast pro pozastavení automatické aktualizace';

  @override
  String get onboardingPageSelector => 'Page Selector';

  @override
  String get onboardingPageSelectorDescription =>
      'Tap the central number to directly enter a page.\n\nEnter a number between 100 and 999 to jump to that page.';

  @override
  String get onboardingSubpageNavigation => 'Subpage Navigation';

  @override
  String get onboardingSubpageNavigationDescription =>
      'If the page has subpages, you\'ll also see the indicator:\n• 1/3 means: first subpage of three available\n\nUse the central arrows to navigate between subpages:\n\n• Up arrow: go to next subpage\n• Down arrow: go to previous subpage\n\nThe arrows are active only when there are subpages available.';

  @override
  String get onboardingSwipe => 'Swipe Navigation';

  @override
  String get onboardingSwipeDescription =>
      'Navigate easily between pages with the gestures shown above.';

  @override
  String get onboardingClickableNumbers => 'Clickable Page Numbers';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tap the highlighted page numbers to navigate directly to that page\n\nPages 100/1 of National Televideo and 300/1 of Regional Televideo are not clickable';

  @override
  String get onboardingShortcuts => 'Shortcuts Menu';

  @override
  String get onboardingShortcutsDescription =>
      'Quickly access the most important Televideo pages.\n\nUse this menu to jump directly to:\n• Page 100: National index\n• Page 200: News\n.....\nYou can also search pages by title by selecting the Search page option';

  @override
  String get onboardingFavoritesList => 'Favorites List';

  @override
  String get onboardingFavoritesListDescription =>
      'Manage your favorite pages:\n\n• Tap a page to open it\n• Swipe left to remove it\n• Tap the pencil to edit the description\n• Long press to change the order\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Customize the app according to your preferences:\n\n• Load first favorite at startup: decide which Televideo page to start with\n• Theme: choose between light, dark or automatic\n• Auto refresh: enable automatic loading of subpages\n• Cache: manage page cache duration\n• Instructions: review this tutorial whenever you want\n• Backup Favorites: save and restore your favorites\n• Privacy Settings and reset: manage or reset your privacy choices';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get start => 'Start';
}
