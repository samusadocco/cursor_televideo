// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Impossible de charger l\'image de la page.\nVeuillez réessayer dans un instant.';

  @override
  String get pageNotAvailable => 'La page demandée n\'est pas disponible';

  @override
  String get pageLoadError =>
      'Une erreur s\'est produite lors du chargement de la page.\nRetour à la page 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'La page $pageNumber n\'est pas disponible pour $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'La page $pageNumber n\'est pas disponible pour $regionName.\nEssayez un autre numéro entre 100 et 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Plus de pages disponibles pour $regionName';
  }

  @override
  String get noMorePages => 'Plus de pages disponibles';

  @override
  String get invalidSubpageNumber => 'Numéro de sous-page invalide';

  @override
  String subpageError(int current, int total) {
    return 'Erreur lors du chargement de la sous-page $current sur $total';
  }

  @override
  String get swipePrevious => '← Précédente';

  @override
  String get swipeNext => 'Suivante →';

  @override
  String get swipeNextUp => 'Suivante ↑';

  @override
  String get swipePreviousDown => 'Précédente ↓';

  @override
  String get swipeRefresh => 'Actualiser ↻';

  @override
  String get pageAddedToFavorites => 'Page ajoutée aux favoris';

  @override
  String get pageRemovedFromFavorites => 'Page retirée des favoris';

  @override
  String get editDescription => 'Modifier la description';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Page $pageNumber - $regionName';
  }

  @override
  String get description => 'Description';

  @override
  String get enterCustomDescription => 'Entrez une description personnalisée';

  @override
  String get restoreHint =>
      'Astuce : appuyez longuement sur le bouton \"RESTAURER\" pour revenir à la description par défaut.';

  @override
  String get restore => 'RESTAURER';

  @override
  String get cancel => 'ANNULER';

  @override
  String get save => 'ENREGISTRER';

  @override
  String get searchHint => 'Rechercher une page...';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get settings => 'Paramètres';

  @override
  String get enterPageNumber => 'Entrez le numéro de page';

  @override
  String pageNumberRange(int minPage) {
    return 'Numéro de $minPage à 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Liste des favoris';

  @override
  String get confirmRemoval => 'Confirmer la suppression';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Voulez-vous vraiment retirer $description des favoris ?';
  }

  @override
  String get remove => 'Retirer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get noFavorites => 'Aucun favori';

  @override
  String get useFavoriteIcon =>
      'Utilisez l\'icône ❤️ pour ajouter des pages aux favoris';

  @override
  String loadingPage(int pageNumber) {
    return 'Chargement de la page $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Aucune page à ajouter aux favoris';

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
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get retry => 'Réessayer';

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
  String get systemTheme => 'Thème du système';

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
      'Si activé, le premier favori de la liste sera chargé au démarrage de l\'application';

  @override
  String get cacheDuration =>
      'Durée du cache des images Televideo (0 secondes pour désactiver)';

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
      'L\'application pour consulter RAI Televideo rapidement et facilement';

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
      'Les sous-pages se mettent à jour automatiquement';

  @override
  String get onboardingPause => 'Pause Actualisation';

  @override
  String get onboardingPauseDescription =>
      'Touchez une zone vide pour mettre en pause l\'actualisation automatique';

  @override
  String get onboardingPageSelector => 'Sélecteur de Page';

  @override
  String get onboardingPageSelectorDescription =>
      'Touchez le numéro central pour entrer directement une page.\n\nEntrez un numéro entre 100 et 999 pour aller à cette page.';

  @override
  String get onboardingSubpageNavigation => 'Navigation Sous-pages';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Si la page a des sous-pages, vous verrez aussi l\'indicateur :\n• 1/3 signifie : première sous-page sur trois disponibles\n\nUtilisez les flèches centrales pour naviguer entre les sous-pages :\n\n• Flèche haut : aller à la sous-page suivante\n• Flèche bas : aller à la sous-page précédente\n\nLes flèches sont actives uniquement lorsqu\'il y a des sous-pages disponibles.';

  @override
  String get onboardingSwipe => 'Navigation par Glissement';

  @override
  String get onboardingSwipeDescription =>
      'Naviguez facilement entre les pages avec les gestes montrés ci-dessus.';

  @override
  String get onboardingClickableNumbers => 'Numéros de Page Cliquables';

  @override
  String get onboardingClickableNumbersDescription =>
      'Touchez les numéros de page en surbrillance pour naviguer directement vers cette page\n\nLes pages 100/1 du Televideo National et 300/1 du Televideo Régional ne sont pas cliquables';

  @override
  String get onboardingShortcuts => 'Menu Raccourcis';

  @override
  String get onboardingShortcutsDescription =>
      'Accédez rapidement aux pages les plus importantes du Televideo.\n\nUtilisez ce menu pour aller directement à :\n• Page 100 : Index national\n• Page 200 : Actualités\n.....\nVous pouvez aussi rechercher des pages par titre en sélectionnant l\'option Rechercher une page';

  @override
  String get onboardingFavoritesList => 'Liste des Favoris';

  @override
  String get onboardingFavoritesListDescription =>
      'Gérez vos pages favorites :\n\n• Touchez une page pour l\'ouvrir\n• Glissez vers la gauche pour la supprimer\n• Touchez le crayon pour modifier la description\n• Appuyez longuement pour changer l\'ordre\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personnalisez l\'application selon vos préférences :\n\n• Charger le premier favori au démarrage : décidez quelle page Televideo afficher au démarrage\n• Thème : choisissez entre clair, sombre ou automatique\n• Actualisation automatique : activez le chargement automatique des sous-pages\n• Cache : gérez la durée du cache des pages\n• Instructions : revoyez ce tutoriel quand vous voulez\n• Sauvegarde des favoris : sauvegardez et restaurez vos favoris\n• Paramètres de confidentialité et réinitialisation : gérez ou réinitialisez vos choix de confidentialité';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get start => 'Commencer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String backToPage(int pageNumber) {
    return 'Retour à la page $pageNumber';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'Page $pageNumber is not available.\nTry another number between $minPage and 999.\nBack to $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'An error occurred while loading the page.\nBack to $minPage';
  }
}
