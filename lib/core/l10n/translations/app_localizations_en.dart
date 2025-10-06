// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get autoRefresh => 'Auto refresh';

  @override
  String get favorites => 'Favorites';

  @override
  String get search => 'Search';

  @override
  String get regions => 'Regions';

  @override
  String get home => 'Home';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get searchHint => 'Enter page number';

  @override
  String get noResults => 'No results';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get networkError => 'Network error';

  @override
  String get connectionRequired => 'Connection required';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get lastUpdate => 'Last update';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get selectTheme => 'Select theme';

  @override
  String get loadFirstFavorite => 'Load first favorite at startup';

  @override
  String get loadFirstFavoriteDescription =>
      'If enabled, the first favorite will be loaded when the app starts';

  @override
  String get cacheDuration =>
      'Cache duration for Televideo pages (0 seconds to disable)';

  @override
  String get seconds => 'seconds';

  @override
  String get autoRefreshDescription => 'Automatically refresh subpages';

  @override
  String get refreshInterval => 'Refresh interval';

  @override
  String get showOnboardingAtStartup => 'Show instructions at startup';

  @override
  String get showOnboardingAtStartupDescription =>
      'Show instructions every time you open the app';

  @override
  String get showInstructions => 'Show instructions';

  @override
  String get showInstructionsDescription => 'Review app usage instructions';

  @override
  String get backupFavorites => 'Backup favorites';

  @override
  String get backupFavoritesDescription => 'Save and restore your favorites';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get privacySettingsDescription =>
      'Modify your privacy preferences for ads';

  @override
  String get resetPrivacySettings => 'Reset Privacy Settings';

  @override
  String get resetPrivacySettingsDescription =>
      'Completely reset privacy settings';

  @override
  String get resetPrivacyConfirm =>
      'Do you really want to reset privacy settings? You will be asked for consent again the next time you start the app.';

  @override
  String get privacySettingsUnavailable =>
      'Privacy settings are not available at the moment';

  @override
  String get privacySettingsReset =>
      'Privacy settings reset. Restart the app for new consent.';

  @override
  String get version => 'Version';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Welcome to TeleRetro Italia';

  @override
  String get onboardingWelcomeDescription =>
      'The app to browse RAI Televideo easily and quickly';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Swipe left or right to change page, tap numbers to navigate directly';

  @override
  String get onboardingFavorites => 'Favorites';

  @override
  String get onboardingFavoritesDescription =>
      'Add pages to favorites for quick access';

  @override
  String get onboardingRegions => 'Regional Televideo';

  @override
  String get onboardingRegionsDescription => 'Access your region\'s Televideo';

  @override
  String get onboardingAutoRefresh => 'Auto Refresh';

  @override
  String get onboardingAutoRefreshDescription =>
      'Subpages update automatically';

  @override
  String get onboardingPause => 'Pause Refresh';

  @override
  String get onboardingPauseDescription =>
      'Tap an empty area to pause auto refresh';

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
