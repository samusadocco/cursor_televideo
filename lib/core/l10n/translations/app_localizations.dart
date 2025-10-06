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
/// import 'translations/app_localizations.dart';
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

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'TeleRetro Italia'**
  String get appTitle;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Option to use system language
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// Dark mode option
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// Auto refresh option
  ///
  /// In en, this message translates to:
  /// **'Auto refresh'**
  String get autoRefresh;

  /// Favorites section title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Search section title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Regions section title
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get regions;

  /// Home section title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Add to favorites button text
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Remove from favorites button text
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// Search field hint
  ///
  /// In en, this message translates to:
  /// **'Enter page number'**
  String get searchHint;

  /// Message when there are no results
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Message when a page is not found
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// Message for network errors
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// Message when a connection is required
  ///
  /// In en, this message translates to:
  /// **'Connection required'**
  String get connectionRequired;

  /// Message during refresh
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// Label for last update
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastUpdate;

  /// Theme section title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get systemTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// Theme selection title
  ///
  /// In en, this message translates to:
  /// **'Select theme'**
  String get selectTheme;

  /// Load first favorite option title
  ///
  /// In en, this message translates to:
  /// **'Load first favorite at startup'**
  String get loadFirstFavorite;

  /// Load first favorite option description
  ///
  /// In en, this message translates to:
  /// **'If enabled, the first favorite will be loaded when the app starts'**
  String get loadFirstFavoriteDescription;

  /// Cache duration title
  ///
  /// In en, this message translates to:
  /// **'Cache duration for Televideo pages (0 seconds to disable)'**
  String get cacheDuration;

  /// Seconds unit
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// Auto refresh description
  ///
  /// In en, this message translates to:
  /// **'Automatically refresh subpages'**
  String get autoRefreshDescription;

  /// Refresh interval title
  ///
  /// In en, this message translates to:
  /// **'Refresh interval'**
  String get refreshInterval;

  /// Show onboarding at startup title
  ///
  /// In en, this message translates to:
  /// **'Show instructions at startup'**
  String get showOnboardingAtStartup;

  /// Show onboarding at startup description
  ///
  /// In en, this message translates to:
  /// **'Show instructions every time you open the app'**
  String get showOnboardingAtStartupDescription;

  /// Show instructions title
  ///
  /// In en, this message translates to:
  /// **'Show instructions'**
  String get showInstructions;

  /// Show instructions description
  ///
  /// In en, this message translates to:
  /// **'Review app usage instructions'**
  String get showInstructionsDescription;

  /// Backup favorites title
  ///
  /// In en, this message translates to:
  /// **'Backup favorites'**
  String get backupFavorites;

  /// Backup favorites description
  ///
  /// In en, this message translates to:
  /// **'Save and restore your favorites'**
  String get backupFavoritesDescription;

  /// Privacy settings title
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Privacy settings description
  ///
  /// In en, this message translates to:
  /// **'Modify your privacy preferences for ads'**
  String get privacySettingsDescription;

  /// Reset privacy title
  ///
  /// In en, this message translates to:
  /// **'Reset Privacy Settings'**
  String get resetPrivacySettings;

  /// Reset privacy description
  ///
  /// In en, this message translates to:
  /// **'Completely reset privacy settings'**
  String get resetPrivacySettingsDescription;

  /// Reset privacy confirmation
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset privacy settings? You will be asked for consent again the next time you start the app.'**
  String get resetPrivacyConfirm;

  /// Privacy not available
  ///
  /// In en, this message translates to:
  /// **'Privacy settings are not available at the moment'**
  String get privacySettingsUnavailable;

  /// Privacy reset
  ///
  /// In en, this message translates to:
  /// **'Privacy settings reset. Restart the app for new consent.'**
  String get privacySettingsReset;

  /// Version title
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Build label
  ///
  /// In en, this message translates to:
  /// **'build'**
  String get build;

  /// Onboarding welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to TeleRetro Italia'**
  String get onboardingWelcome;

  /// Onboarding welcome description
  ///
  /// In en, this message translates to:
  /// **'The app to browse RAI Televideo easily and quickly'**
  String get onboardingWelcomeDescription;

  /// Onboarding navigation title
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get onboardingNavigation;

  /// Onboarding navigation description
  ///
  /// In en, this message translates to:
  /// **'Swipe left or right to change page, tap numbers to navigate directly'**
  String get onboardingNavigationDescription;

  /// Onboarding favorites title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get onboardingFavorites;

  /// Onboarding favorites description
  ///
  /// In en, this message translates to:
  /// **'Add pages to favorites for quick access'**
  String get onboardingFavoritesDescription;

  /// Onboarding regions title
  ///
  /// In en, this message translates to:
  /// **'Regional Televideo'**
  String get onboardingRegions;

  /// Onboarding regions description
  ///
  /// In en, this message translates to:
  /// **'Access your region\'s Televideo'**
  String get onboardingRegionsDescription;

  /// Onboarding autorefresh title
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get onboardingAutoRefresh;

  /// Onboarding autorefresh description
  ///
  /// In en, this message translates to:
  /// **'Subpages update automatically'**
  String get onboardingAutoRefreshDescription;

  /// Onboarding pause title
  ///
  /// In en, this message translates to:
  /// **'Pause Refresh'**
  String get onboardingPause;

  /// Onboarding pause description
  ///
  /// In en, this message translates to:
  /// **'Tap an empty area to pause auto refresh'**
  String get onboardingPauseDescription;

  /// Onboarding page selector title
  ///
  /// In en, this message translates to:
  /// **'Page Selector'**
  String get onboardingPageSelector;

  /// Onboarding page selector description
  ///
  /// In en, this message translates to:
  /// **'Tap the central number to directly enter a page.\n\nEnter a number between 100 and 999 to jump to that page.'**
  String get onboardingPageSelectorDescription;

  /// Onboarding subpage navigation title
  ///
  /// In en, this message translates to:
  /// **'Subpage Navigation'**
  String get onboardingSubpageNavigation;

  /// Onboarding subpage navigation description
  ///
  /// In en, this message translates to:
  /// **'If the page has subpages, you\'ll also see the indicator:\n• 1/3 means: first subpage of three available\n\nUse the central arrows to navigate between subpages:\n\n• Up arrow: go to next subpage\n• Down arrow: go to previous subpage\n\nThe arrows are active only when there are subpages available.'**
  String get onboardingSubpageNavigationDescription;

  /// Onboarding swipe navigation title
  ///
  /// In en, this message translates to:
  /// **'Swipe Navigation'**
  String get onboardingSwipe;

  /// Onboarding swipe navigation description
  ///
  /// In en, this message translates to:
  /// **'Navigate easily between pages with the gestures shown above.'**
  String get onboardingSwipeDescription;

  /// Onboarding clickable numbers title
  ///
  /// In en, this message translates to:
  /// **'Clickable Page Numbers'**
  String get onboardingClickableNumbers;

  /// Onboarding clickable numbers description
  ///
  /// In en, this message translates to:
  /// **'Tap the highlighted page numbers to navigate directly to that page\n\nPages 100/1 of National Televideo and 300/1 of Regional Televideo are not clickable'**
  String get onboardingClickableNumbersDescription;

  /// Onboarding shortcuts title
  ///
  /// In en, this message translates to:
  /// **'Shortcuts Menu'**
  String get onboardingShortcuts;

  /// Onboarding shortcuts description
  ///
  /// In en, this message translates to:
  /// **'Quickly access the most important Televideo pages.\n\nUse this menu to jump directly to:\n• Page 100: National index\n• Page 200: News\n.....\nYou can also search pages by title by selecting the Search page option'**
  String get onboardingShortcutsDescription;

  /// Onboarding favorites list title
  ///
  /// In en, this message translates to:
  /// **'Favorites List'**
  String get onboardingFavoritesList;

  /// Onboarding favorites list description
  ///
  /// In en, this message translates to:
  /// **'Manage your favorite pages:\n\n• Tap a page to open it\n• Swipe left to remove it\n• Tap the pencil to edit the description\n• Long press to change the order\n\n'**
  String get onboardingFavoritesListDescription;

  /// Onboarding settings description
  ///
  /// In en, this message translates to:
  /// **'Customize the app according to your preferences:\n\n• Load first favorite at startup: decide which Televideo page to start with\n• Theme: choose between light, dark or automatic\n• Auto refresh: enable automatic loading of subpages\n• Cache: manage page cache duration\n• Instructions: review this tutorial whenever you want\n• Backup Favorites: save and restore your favorites\n• Privacy Settings and reset: manage or reset your privacy choices'**
  String get onboardingSettingsDescription;

  /// Don't show again button text
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;
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
