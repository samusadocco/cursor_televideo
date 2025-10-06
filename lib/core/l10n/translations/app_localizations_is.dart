// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Icelandic (`is`).
class AppLocalizationsIs extends AppLocalizations {
  AppLocalizationsIs([String locale = 'is']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Stillingar';

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
  String get removeFromFavorites => 'Fjarlægja úr eftirlæti';

  @override
  String get searchHint => 'Sláðu inn síðunúmer';

  @override
  String get noResults => 'Engar niðurstöður';

  @override
  String get loading => 'Hleður...';

  @override
  String get error => 'Villa';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Reyna aftur';

  @override
  String get ok => 'Í lagi';

  @override
  String get cancel => 'Hætta við';

  @override
  String get close => 'Loka';

  @override
  String get next => 'Næsta';

  @override
  String get previous => 'Fyrri';

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
      'Ef virkt, er fyrsta eftirlætissíðan hlaðin við ræsingu forritsins';

  @override
  String get cacheDuration =>
      'Skyndiminnisstími fyrir Televideo síður (0 sekúndur til að slökkva)';

  @override
  String get seconds => 'sekúndur';

  @override
  String get autoRefreshDescription => 'Uppfæra undirsíður sjálfkrafa';

  @override
  String get refreshInterval => 'Uppfærslutími';

  @override
  String get showOnboardingAtStartup => 'Sýna leiðbeiningar við ræsingu';

  @override
  String get showOnboardingAtStartupDescription =>
      'Sýna leiðbeiningar í hvert skipti sem þú opnar forritið';

  @override
  String get showInstructions => 'Sýna leiðbeiningar';

  @override
  String get showInstructionsDescription =>
      'Skoða notkunarleiðbeiningar forritsins aftur';

  @override
  String get backupFavorites => 'Afrita eftirlæti';

  @override
  String get backupFavoritesDescription => 'Vista og endurheimta eftirlæti þín';

  @override
  String get privacySettings => 'Persónuverndastillingar';

  @override
  String get privacySettingsDescription =>
      'Breyta persónuverndastillingum fyrir auglýsingar';

  @override
  String get resetPrivacySettings => 'Endurstilla persónuverndastillingar';

  @override
  String get resetPrivacySettingsDescription =>
      'Endurstilla allar persónuverndastillingar';

  @override
  String get resetPrivacyConfirm =>
      'Viltu örugglega endurstilla persónuverndastillingar? Þú þarft að gefa samþykki aftur við næstu ræsingu forritsins.';

  @override
  String get privacySettingsUnavailable =>
      'Persónuverndastillingar eru ekki í boði núna';

  @override
  String get privacySettingsReset =>
      'Persónuverndastillingar endurstilltar. Endurræstu forritið fyrir nýtt samþykki.';

  @override
  String get version => 'Útgáfa';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Velkomin í TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Forritið til að skoða RAI Televideo á einfaldan og fljótlegan hátt';

  @override
  String get onboardingNavigation => 'Leiðsögn';

  @override
  String get onboardingNavigationDescription =>
      'Strjúktu til vinstri eða hægri til að skipta um síðu, ýttu á tölur fyrir beina leiðsögn';

  @override
  String get onboardingFavorites => 'Eftirlæti';

  @override
  String get onboardingFavoritesDescription =>
      'Bættu síðum við eftirlæti fyrir fljótan aðgang';

  @override
  String get onboardingRegions => 'Svæðisbundið Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Fáðu aðgang að Televideo fyrir þitt svæði';

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
