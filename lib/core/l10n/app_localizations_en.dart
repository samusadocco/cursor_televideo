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
  String get welcome => 'Welcome!';

  @override
  String get welcomeSelectChannel => 'Select default channel';

  @override
  String page(int pageNumber) {
    return 'Page $pageNumber';
  }

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
  String get startupPageOption => 'Startup page';

  @override
  String get startupPageOptionLastPage => 'Last viewed page (default)';

  @override
  String get startupPageOptionFirstFavorite => 'First favorite (if available)';

  @override
  String get startupPageOptionChannelHomePage => 'Last channel home page';

  @override
  String get cacheDuration =>
      'Teletext page images cache duration (0 seconds to disable)';

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
  String get onboardingWelcome => 'Welcome to Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'The app to access all teletext channels in Europe';

  @override
  String get onboardingDefaultChannel => 'Select Default Channel';

  @override
  String get onboardingDefaultChannelDescription =>
      'When you start the app, you\'ll be asked to select your preferred channel from all available channels.\n\nYou can change the default channel at any time from the Settings menu.';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Swipe left or right to change page, tap numbers to navigate directly';

  @override
  String get onboardingFavorites => 'Favorites';

  @override
  String get onboardingFavoritesDescription =>
      'Save the pages you visit most often:\n\n• Tap the indicated icon to add the current page\n• Tap again to remove it from favorites\n• The icon turns red when the page is in favorites\n\nYou can save both national and regional pages.';

  @override
  String get onboardingRegions => 'Channels from All Over Europe';

  @override
  String get onboardingRegionsDescription =>
      'Select and organize your favorite channels from all over Europe.\n\nSearch by channel name or country name.\n\nYou can access teletext from Italy, Germany, Austria, Switzerland and many other European countries!';

  @override
  String get onboardingAutoRefresh => 'Auto Refresh';

  @override
  String get onboardingAutoRefreshDescription =>
      'When automatic refresh is active, the circle around the page number fills progressively:\n\nYou can change the refresh time in settings\n\nThe indicator is only visible when subpages are available and automatic refresh is active.';

  @override
  String get onboardingPause => 'Pause Update';

  @override
  String get onboardingPauseDescription =>
      'You can pause the automatic refresh of subpages:\n\n• Tap anywhere on the page where there are no clickable numbers\n• You will see the ⏸️ icon appear to indicate that the refresh is paused\n• Tap again to resume the refresh (▶️ icon)\n\nThis feature is useful when you want to read a subpage calmly without it changing automatically.';

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
      'Tap the highlighted page numbers to navigate directly to that page\n\n';

  @override
  String get onboardingShortcuts => 'Menu Shortcuts';

  @override
  String get onboardingShortcutsDescription =>
      'Quickly access the most important Teletext pages.\n\nUse this menu to jump directly to:\n• Page 100: National index\n• Page 200: News\n.....\nYou can also search pages by title by selecting the Search page option';

  @override
  String get onboardingFavoritesList => 'Favorites List';

  @override
  String get onboardingFavoritesListDescription =>
      'Manage your favorite pages:\n\n• Tap a page to open it\n• Swipe left to remove it\n• Tap the pencil to edit the description\n• Long press to change the order\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Customize the app according to your preferences:\n\n• Load first favorite at startup: decide which Teletext page to start with\n• Theme: choose between light, dark or automatic\n• Auto refresh: enable automatic loading of subpages\n• Cache: manage page cache duration\n• Instructions: review this tutorial whenever you want\n• Backup Favorites: save and restore your favorites\n• Privacy Settings and reset: manage or reset your privacy choices';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get start => 'Start';

  @override
  String get reset => 'Reset';

  @override
  String get resetInitialChannel => 'Reset initial channel';

  @override
  String get resetInitialChannelDescription =>
      'Show the channel selection dialog again at next startup';

  @override
  String get resetCompleted => 'Reset completed';

  @override
  String get resetInitialChannelMessage =>
      'The initial channel has been reset.\n\nAt the next app startup you will be asked to select your default channel again.\n\nRestarting the app now...';

  @override
  String get selectYourChannel =>
      'Select your default Teletext channel.\nYou can change it at any time.';

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

  @override
  String get countryIT => 'Italy';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Switzerland';

  @override
  String get countryES => 'Spain';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Netherlands';

  @override
  String get countrySE => 'Sweden';

  @override
  String get countryFI => 'Finland';

  @override
  String get countryDK => 'Denmark';

  @override
  String get countryCZ => 'Czech Republic';

  @override
  String get countryHR => 'Croatia';

  @override
  String get countryBA => 'Bosnia and Herzegovina';

  @override
  String get countryHU => 'Hungary';

  @override
  String get countryIS => 'Iceland';

  @override
  String get countrySI => 'Slovenia';

  @override
  String get countryUA => 'Ukraine';
}
