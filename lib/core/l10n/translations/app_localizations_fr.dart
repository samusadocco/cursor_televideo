// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get autoRefresh => 'Actualisation automatique';

  @override
  String get favorites => 'Favoris';

  @override
  String get search => 'Rechercher';

  @override
  String get regions => 'Régions';

  @override
  String get home => 'Accueil';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get searchHint => 'Entrez le numéro de page';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get connectionRequired => 'Connexion requise';

  @override
  String get refreshing => 'Actualisation...';

  @override
  String get lastUpdate => 'Dernière mise à jour';

  @override
  String get theme => 'Thème';

  @override
  String get systemTheme => 'Thème système';

  @override
  String get lightTheme => 'Thème clair';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get selectTheme => 'Sélectionner le thème';

  @override
  String get loadFirstFavorite => 'Charger le premier favori au démarrage';

  @override
  String get loadFirstFavoriteDescription =>
      'Si activé, le premier favori sera chargé au démarrage de l\'application';

  @override
  String get cacheDuration =>
      'Durée du cache des pages Televideo (0 secondes pour désactiver)';

  @override
  String get seconds => 'secondes';

  @override
  String get autoRefreshDescription =>
      'Actualiser automatiquement les sous-pages';

  @override
  String get refreshInterval => 'Intervalle d\'actualisation';

  @override
  String get showOnboardingAtStartup =>
      'Afficher les instructions au démarrage';

  @override
  String get showOnboardingAtStartupDescription =>
      'Afficher les instructions à chaque ouverture de l\'application';

  @override
  String get showInstructions => 'Afficher les instructions';

  @override
  String get showInstructionsDescription =>
      'Revoir les instructions d\'utilisation de l\'application';

  @override
  String get backupFavorites => 'Sauvegarder les favoris';

  @override
  String get backupFavoritesDescription =>
      'Sauvegarder et restaurer vos favoris';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get privacySettingsDescription =>
      'Modifier vos préférences de confidentialité pour les publicités';

  @override
  String get resetPrivacySettings =>
      'Réinitialiser les paramètres de confidentialité';

  @override
  String get resetPrivacySettingsDescription =>
      'Réinitialiser complètement les paramètres de confidentialité';

  @override
  String get resetPrivacyConfirm =>
      'Voulez-vous vraiment réinitialiser les paramètres de confidentialité ? Vous devrez donner votre consentement à nouveau au prochain démarrage de l\'application.';

  @override
  String get privacySettingsUnavailable =>
      'Les paramètres de confidentialité ne sont pas disponibles pour le moment';

  @override
  String get privacySettingsReset =>
      'Paramètres de confidentialité réinitialisés. Redémarrez l\'application pour le nouveau consentement.';

  @override
  String get version => 'Version';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Bienvenue sur TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'L\'application pour consulter le Televideo RAI facilement et rapidement';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Glissez à gauche ou à droite pour changer de page, touchez les numéros pour naviguer directement';

  @override
  String get onboardingFavorites => 'Favoris';

  @override
  String get onboardingFavoritesDescription =>
      'Ajoutez des pages aux favoris pour un accès rapide';

  @override
  String get onboardingRegions => 'Televideo Régional';

  @override
  String get onboardingRegionsDescription =>
      'Accédez au Televideo de votre région';

  @override
  String get onboardingAutoRefresh => 'Actualisation Automatique';

  @override
  String get onboardingAutoRefreshDescription =>
      'Les sous-pages s\'actualisent automatiquement';

  @override
  String get onboardingPause => 'Pause Actualisation';

  @override
  String get onboardingPauseDescription =>
      'Touchez une zone vide pour mettre en pause l\'actualisation automatique';

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
