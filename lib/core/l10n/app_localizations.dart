import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bs.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_is.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bs'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('hr'),
    Locale('hu'),
    Locale('is'),
    Locale('it'),
    Locale('nl'),
    Locale('pt'),
    Locale('sl'),
    Locale('sv')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TeleRetrò Italia'**
  String get appTitle;

  /// No description provided for @pageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the page image.\nPlease try again in a moment.'**
  String get pageUnavailable;

  /// No description provided for @pageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'The requested page is not available'**
  String get pageNotAvailable;

  /// No description provided for @pageLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the page.\nReturn to page 100'**
  String get pageLoadError;

  /// Error message when a page is not available for a specific region
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber} is not available for {regionName}'**
  String pageNotAvailableForRegion(int pageNumber, String regionName);

  /// Error message when a page is not available for a region, with hint
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber} is not available for {regionName}.\nTry another number between 100 and 999.'**
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName);

  /// Error message when there are no more pages for a region
  ///
  /// In en, this message translates to:
  /// **'No more pages available for {regionName}'**
  String noMorePagesForRegion(String regionName);

  /// No description provided for @noMorePages.
  ///
  /// In en, this message translates to:
  /// **'No more pages available'**
  String get noMorePages;

  /// No description provided for @invalidSubpageNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid subpage number'**
  String get invalidSubpageNumber;

  /// Error message when a subpage fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading subpage {current} of {total}'**
  String subpageError(int current, int total);

  /// No description provided for @swipePrevious.
  ///
  /// In en, this message translates to:
  /// **'← Previous'**
  String get swipePrevious;

  /// No description provided for @swipeNext.
  ///
  /// In en, this message translates to:
  /// **'Next →'**
  String get swipeNext;

  /// No description provided for @swipeNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next ↑'**
  String get swipeNextUp;

  /// No description provided for @swipePreviousDown.
  ///
  /// In en, this message translates to:
  /// **'Previous ↓'**
  String get swipePreviousDown;

  /// No description provided for @swipeRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh ↻'**
  String get swipeRefresh;

  /// No description provided for @pageAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Page added to favorites'**
  String get pageAddedToFavorites;

  /// No description provided for @pageRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Page removed from favorites'**
  String get pageRemovedFromFavorites;

  /// No description provided for @editDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit description'**
  String get editDescription;

  /// Page number and region name
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber} - {regionName}'**
  String pageAndRegion(int pageNumber, String regionName);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterCustomDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a custom description'**
  String get enterCustomDescription;

  /// No description provided for @restoreHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: long press the \"RESTORE\" button to return to the default description.'**
  String get restoreHint;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get restore;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search page...'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @enterPageNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter page number'**
  String get enterPageNumber;

  /// Hint text for page number input
  ///
  /// In en, this message translates to:
  /// **'Number from {minPage} to 999'**
  String pageNumberRange(int minPage);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @favoritesList.
  ///
  /// In en, this message translates to:
  /// **'Favorites list'**
  String get favoritesList;

  /// No description provided for @confirmRemoval.
  ///
  /// In en, this message translates to:
  /// **'Confirm removal'**
  String get confirmRemoval;

  /// Confirmation message when removing a page from favorites
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove {description} from favorites?'**
  String confirmRemoveFromFavorites(String description);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get noFavorites;

  /// No description provided for @useFavoriteIcon.
  ///
  /// In en, this message translates to:
  /// **'Use the ❤️ icon to add pages to favorites'**
  String get useFavoriteIcon;

  /// Loading message when loading a page
  ///
  /// In en, this message translates to:
  /// **'Loading page {pageNumber}...'**
  String loadingPage(int pageNumber);

  /// No description provided for @noPageToAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'No page to add to favorites'**
  String get noPageToAddToFavorites;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @autoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto refresh'**
  String get autoRefresh;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @regions.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @connectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Connection required'**
  String get connectionRequired;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastUpdate;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select theme'**
  String get selectTheme;

  /// No description provided for @loadFirstFavorite.
  ///
  /// In en, this message translates to:
  /// **'Load first favorite at startup'**
  String get loadFirstFavorite;

  /// No description provided for @loadFirstFavoriteDescription.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the first favorite in the list will be loaded when the app starts'**
  String get loadFirstFavoriteDescription;

  /// No description provided for @cacheDuration.
  ///
  /// In en, this message translates to:
  /// **'Televideo page images cache duration (0 seconds to disable)'**
  String get cacheDuration;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @autoRefreshDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically refresh subpages'**
  String get autoRefreshDescription;

  /// No description provided for @refreshInterval.
  ///
  /// In en, this message translates to:
  /// **'Refresh interval'**
  String get refreshInterval;

  /// No description provided for @showOnboardingAtStartup.
  ///
  /// In en, this message translates to:
  /// **'Show instructions at startup'**
  String get showOnboardingAtStartup;

  /// No description provided for @showOnboardingAtStartupDescription.
  ///
  /// In en, this message translates to:
  /// **'Show instructions every time you open the app'**
  String get showOnboardingAtStartupDescription;

  /// No description provided for @showInstructions.
  ///
  /// In en, this message translates to:
  /// **'Show instructions'**
  String get showInstructions;

  /// No description provided for @showInstructionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the app usage instructions'**
  String get showInstructionsDescription;

  /// No description provided for @backupFavorites.
  ///
  /// In en, this message translates to:
  /// **'Backup favorites'**
  String get backupFavorites;

  /// No description provided for @backupFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Save and restore your favorites'**
  String get backupFavoritesDescription;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @privacySettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Modify your privacy preferences for ads'**
  String get privacySettingsDescription;

  /// No description provided for @resetPrivacySettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Privacy Settings'**
  String get resetPrivacySettings;

  /// No description provided for @resetPrivacySettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Completely reset privacy settings'**
  String get resetPrivacySettingsDescription;

  /// No description provided for @resetPrivacyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset privacy settings? You will be asked for consent again the next time you start the app.'**
  String get resetPrivacyConfirm;

  /// No description provided for @privacySettingsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings are not available at the moment'**
  String get privacySettingsUnavailable;

  /// No description provided for @privacySettingsReset.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings reset. Restart the app for new consent.'**
  String get privacySettingsReset;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'build'**
  String get build;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to TeleRetrò Italia'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'The app to consult RAI Televideo quickly and easily'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get onboardingNavigation;

  /// No description provided for @onboardingNavigationDescription.
  ///
  /// In en, this message translates to:
  /// **'Swipe left or right to change page, tap numbers to navigate directly'**
  String get onboardingNavigationDescription;

  /// No description provided for @onboardingFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get onboardingFavorites;

  /// No description provided for @onboardingFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add pages to favorites for quick access'**
  String get onboardingFavoritesDescription;

  /// No description provided for @onboardingRegions.
  ///
  /// In en, this message translates to:
  /// **'Regional Televideo'**
  String get onboardingRegions;

  /// No description provided for @onboardingRegionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Access your region\'s Televideo'**
  String get onboardingRegionsDescription;

  /// No description provided for @onboardingAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get onboardingAutoRefresh;

  /// No description provided for @onboardingAutoRefreshDescription.
  ///
  /// In en, this message translates to:
  /// **'Subpages update automatically'**
  String get onboardingAutoRefreshDescription;

  /// No description provided for @onboardingPause.
  ///
  /// In en, this message translates to:
  /// **'Pause Update'**
  String get onboardingPause;

  /// No description provided for @onboardingPauseDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap an empty area to pause automatic refresh'**
  String get onboardingPauseDescription;

  /// No description provided for @onboardingPageSelector.
  ///
  /// In en, this message translates to:
  /// **'Page Selector'**
  String get onboardingPageSelector;

  /// No description provided for @onboardingPageSelectorDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap the central number to directly enter a page.\n\nEnter a number between 100 and 999 to jump to that page.'**
  String get onboardingPageSelectorDescription;

  /// No description provided for @onboardingSubpageNavigation.
  ///
  /// In en, this message translates to:
  /// **'Subpage Navigation'**
  String get onboardingSubpageNavigation;

  /// No description provided for @onboardingSubpageNavigationDescription.
  ///
  /// In en, this message translates to:
  /// **'If the page has subpages, you\'ll also see the indicator:\n• 1/3 means: first subpage of three available\n\nUse the central arrows to navigate between subpages:\n\n• Up arrow: go to next subpage\n• Down arrow: go to previous subpage\n\nThe arrows are active only when there are subpages available.'**
  String get onboardingSubpageNavigationDescription;

  /// No description provided for @onboardingSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe Navigation'**
  String get onboardingSwipe;

  /// No description provided for @onboardingSwipeDescription.
  ///
  /// In en, this message translates to:
  /// **'Navigate easily between pages with the gestures shown above.'**
  String get onboardingSwipeDescription;

  /// No description provided for @onboardingClickableNumbers.
  ///
  /// In en, this message translates to:
  /// **'Clickable Page Numbers'**
  String get onboardingClickableNumbers;

  /// No description provided for @onboardingClickableNumbersDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap the highlighted page numbers to navigate directly to that page\n\nPages 100/1 of National Televideo and 300/1 of Regional Televideo are not clickable'**
  String get onboardingClickableNumbersDescription;

  /// No description provided for @onboardingShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Menu Shortcuts'**
  String get onboardingShortcuts;

  /// No description provided for @onboardingShortcutsDescription.
  ///
  /// In en, this message translates to:
  /// **'Quickly access the most important Televideo pages.\n\nUse this menu to jump directly to:\n• Page 100: National index\n• Page 200: News\n.....\nYou can also search pages by title by selecting the Search page option'**
  String get onboardingShortcutsDescription;

  /// No description provided for @onboardingFavoritesList.
  ///
  /// In en, this message translates to:
  /// **'Favorites List'**
  String get onboardingFavoritesList;

  /// No description provided for @onboardingFavoritesListDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your favorite pages:\n\n• Tap a page to open it\n• Swipe left to remove it\n• Tap the pencil to edit the description\n• Long press to change the order\n\n'**
  String get onboardingFavoritesListDescription;

  /// No description provided for @onboardingSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize the app according to your preferences:\n\n• Load first favorite at startup: decide which Televideo page to start with\n• Theme: choose between light, dark or automatic\n• Auto refresh: enable automatic loading of subpages\n• Cache: manage page cache duration\n• Instructions: review this tutorial whenever you want\n• Backup Favorites: save and restore your favorites\n• Privacy Settings and reset: manage or reset your privacy choices'**
  String get onboardingSettingsDescription;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Button text to go back to a specific page
  ///
  /// In en, this message translates to:
  /// **'Back to page {pageNumber}'**
  String backToPage(int pageNumber);

  /// Error message when a page is not available, with hint
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber} is not available.\nTry another number between {minPage} and 999.\nBack to {backPage}'**
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage);

  /// Error message when page loading fails, with hint
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the page.\nBack to {minPage}'**
  String pageLoadErrorWithHint(int minPage);

  /// No description provided for @channelSelection.
  ///
  /// In en, this message translates to:
  /// **'Channel Selection'**
  String get channelSelection;

  /// No description provided for @favoriteChannels.
  ///
  /// In en, this message translates to:
  /// **'Favorite Channels'**
  String get favoriteChannels;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @searchChannelOrCountry.
  ///
  /// In en, this message translates to:
  /// **'Search channel or country...'**
  String get searchChannelOrCountry;

  /// No description provided for @showAllChannels.
  ///
  /// In en, this message translates to:
  /// **'Show all channels'**
  String get showAllChannels;

  /// Number of channels available from countries
  ///
  /// In en, this message translates to:
  /// **'{count} channels available from {countries} countries'**
  String channelsAvailableFromCountries(int count, int countries);

  /// No description provided for @allChannels.
  ///
  /// In en, this message translates to:
  /// **'All Channels'**
  String get allChannels;

  /// No description provided for @noFavoriteChannelsFound.
  ///
  /// In en, this message translates to:
  /// **'No favorite channels found'**
  String get noFavoriteChannelsFound;

  /// No description provided for @noChannelsFound.
  ///
  /// In en, this message translates to:
  /// **'No channels found'**
  String get noChannelsFound;

  /// Message when a channel is added to favorites
  ///
  /// In en, this message translates to:
  /// **'{emoji} {name} added to favorites'**
  String addedToFavorites(String emoji, String name);

  /// Message when a channel is removed from favorites
  ///
  /// In en, this message translates to:
  /// **'{emoji} {name} removed from favorites'**
  String removedFromFavorites(String emoji, String name);

  /// Number of regions available for a channel
  ///
  /// In en, this message translates to:
  /// **'{count} regions available'**
  String regionsAvailable(int count);

  /// No description provided for @reorderFavorites.
  ///
  /// In en, this message translates to:
  /// **'Reorder Favorites'**
  String get reorderFavorites;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bs',
        'cs',
        'da',
        'de',
        'en',
        'es',
        'fi',
        'fr',
        'hr',
        'hu',
        'is',
        'it',
        'nl',
        'pt',
        'sl',
        'sv'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bs':
      return AppLocalizationsBs();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'is':
      return AppLocalizationsIs();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
