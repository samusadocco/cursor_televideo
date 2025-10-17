// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Unable to load the page image.\nPlease try again in a moment.';

  @override
  String get pageNotAvailable => 'The requested page is not available';

  @override
  String get pageLoadError =>
      'An error occurred while loading the page.\nReturn to page 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Page $pageNumber is not available for $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Page $pageNumber is not available for $regionName.\nTry another number between 100 and 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'No more pages available for $regionName';
  }

  @override
  String get noMorePages => 'No more pages available';

  @override
  String get invalidSubpageNumber => 'Invalid subpage number';

  @override
  String subpageError(int current, int total) {
    return 'Error loading subpage $current of $total';
  }

  @override
  String get swipePrevious => '← Previous';

  @override
  String get swipeNext => 'Next →';

  @override
  String get swipeNextUp => 'Next ↑';

  @override
  String get swipePreviousDown => 'Previous ↓';

  @override
  String get swipeRefresh => 'Refresh ↻';

  @override
  String get pageAddedToFavorites => 'Page added to favorites';

  @override
  String get pageRemovedFromFavorites => 'Page removed from favorites';

  @override
  String get editDescription => 'Edit description';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Page $pageNumber - $regionName';
  }

  @override
  String get description => 'Description';

  @override
  String get enterCustomDescription => 'Enter a custom description';

  @override
  String get restoreHint =>
      'Tip: long press the \"RESTORE\" button to return to the default description.';

  @override
  String get restore => 'RESTORE';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get searchHint => 'Search page...';

  @override
  String get noResults => 'No results';

  @override
  String get settings => 'Settings';

  @override
  String get enterPageNumber => 'Enter page number';

  @override
  String pageNumberRange(int minPage) {
    return 'Number from $minPage to 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Favorites list';

  @override
  String get confirmRemoval => 'Confirm removal';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Do you really want to remove $description from favorites?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get noFavorites => 'No favorites';

  @override
  String get useFavoriteIcon => 'Use the ❤️ icon to add pages to favorites';

  @override
  String loadingPage(int pageNumber) {
    return 'Loading page $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'No page to add to favorites';

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
      'If enabled, the first favorite in the list will be loaded when the app starts';

  @override
  String get cacheDuration =>
      'Televideo page images cache duration (0 seconds to disable)';

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
  String get showInstructionsDescription => 'Review the app usage instructions';

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
  String get onboardingWelcome => 'Welcome to TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'The app to consult RAI Televideo quickly and easily';

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
  String get onboardingPause => 'Pause Update';

  @override
  String get onboardingPauseDescription =>
      'Tap an empty area to pause automatic refresh';

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
  String get onboardingShortcuts => 'Menu Shortcuts';

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

  @override
  String get reset => 'Reset';

  @override
  String backToPage(int pageNumber) {
    return 'Back to page $pageNumber';
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
  String get channelSelection => 'Channel Selection';

  @override
  String get favoriteChannels => 'Favorite Channels';

  @override
  String get reorder => 'Reorder';

  @override
  String get searchChannelOrCountry => 'Search channel or country...';

  @override
  String get showAllChannels => 'Show all channels';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count channels available from $countries countries';
  }

  @override
  String get allChannels => 'All Channels';

  @override
  String get noFavoriteChannelsFound => 'No favorite channels found';

  @override
  String get noChannelsFound => 'No channels found';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name added to favorites';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name removed from favorites';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regions available';
  }

  @override
  String get reorderFavorites => 'Reorder Favorites';
}
