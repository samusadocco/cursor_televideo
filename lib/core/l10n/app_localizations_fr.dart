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
  String get welcome => 'Bienvenue!';

  @override
  String get welcomeSelectChannel => 'Sélectionner le canal par défaut';

  @override
  String page(int pageNumber) {
    return 'Page $pageNumber';
  }

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
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

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
  String get channelCheckNoConnectivity =>
      'No connection available.\nMake sure you\'re not in airplane mode and that Wi-Fi or mobile data is on.';

  @override
  String get channelCheckNoInternet =>
      'Unable to reach the internet.\nCheck your network connection and try again.';

  @override
  String get channelCheckDnsError =>
      'Unable to resolve network addresses.\nCheck your connection or try a different network.';

  @override
  String get channelCheckChannelError =>
      'The channel is having connection issues.\nThe broadcaster\'s server may be temporarily unreachable. Please try again in a few minutes.';

  @override
  String get refreshing => 'Actualisation...';

  @override
  String get lastUpdate => 'Dernière mise à jour';

  @override
  String get updateAvailable => 'Mise à jour disponible';

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
  String get startupPageOption => 'Page de démarrage';

  @override
  String get startupPageOptionLastPage =>
      'Dernière page consultée (par défaut)';

  @override
  String get startupPageOptionFirstFavorite => 'Premier favori (si disponible)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Page d\'accueil de la dernière chaîne';

  @override
  String get cacheDuration =>
      'Durée du cache des images Télétexte (0 secondes pour désactiver)';

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
  String get support => 'Assistance';

  @override
  String get supportDescription => 'Contactez-nous pour assistance';

  @override
  String get supportTitle => 'Nous sommes là pour vous aider !';

  @override
  String get supportSubtitle =>
      'Pour toute question ou assistance, n\'hésitez pas à nous contacter';

  @override
  String get directContact => 'Contact Direct';

  @override
  String get emailLabel => 'Email';

  @override
  String get websiteLabel => 'Site Web';

  @override
  String get responseTime => 'Temps de réponse moyen : 24-48 heures';

  @override
  String get faq => 'Questions Fréquentes';

  @override
  String get faqGeolocation => 'Comment fonctionne la géolocalisation ?';

  @override
  String get faqGeolocationAnswer =>
      'L\'application utilise la localisation de votre appareil pour identifier automatiquement votre région et vous montrer les actualités locales pertinentes. Vous pouvez désactiver cette fonction dans les paramètres de l\'application.';

  @override
  String get faqFavorites => 'Comment enregistrer une page dans les favoris ?';

  @override
  String get faqFavoritesAnswer =>
      'Lorsque vous consultez une page, appuyez sur l\'icône étoile pour l\'ajouter aux favoris. Vous pouvez accéder à vos pages favorites depuis le menu principal.';

  @override
  String get faqTheme => 'Comment changer le thème de l\'application ?';

  @override
  String get faqThemeAnswer =>
      'Allez dans les paramètres de l\'application et sélectionnez le thème souhaité (clair/sombre). L\'application prend également en charge le réglage automatique basé sur les paramètres système.';

  @override
  String get faqOffline => 'L\'application fonctionne-t-elle hors ligne ?';

  @override
  String get faqOfflineAnswer =>
      'Non, une connexion Internet active est nécessaire pour accéder aux pages Télétexte en temps réel.';

  @override
  String get faqReportProblem => 'Comment signaler un problème ?';

  @override
  String get faqReportProblemAnswer =>
      'Envoyez un email détaillé à samuele@codebysam.it décrivant le problème rencontré.';

  @override
  String get reportBugTitle => 'Signaler un problème';

  @override
  String get reportBugInstructions =>
      'Lorsque vous signalez un problème, veuillez inclure si possible :';

  @override
  String get reportBugItems =>
      'Version de l\'application\nModèle de l\'appareil\nSystème d\'exploitation\nCapture d\'écran du problème';

  @override
  String get developedBy => 'Développé par CodeBySam';

  @override
  String get errorOpeningLink => 'Impossible d\'ouvrir le lien';

  @override
  String get errorOpeningEmail => 'Impossible d\'ouvrir l\'email';

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
  String get onboardingWelcome => 'Bienvenue sur Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'L\'application pour accéder à toutes les chaînes télétexte en Europe';

  @override
  String get onboardingDefaultChannel => 'Sélectionner la Chaîne par Défaut';

  @override
  String get onboardingDefaultChannelDescription =>
      'Au démarrage de l\'application, il vous sera demandé de sélectionner votre chaîne préférée parmi toutes les chaînes disponibles.\n\nVous pouvez modifier la chaîne par défaut à tout moment depuis le menu Paramètres.';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Glissez à gauche ou à droite pour changer de page, touchez les numéros pour naviguer directement';

  @override
  String get onboardingFavorites => 'Favoris';

  @override
  String get onboardingFavoritesDescription =>
      'Enregistrez les pages que vous visitez le plus souvent:\n\n• Appuyez sur l\'icône indiquée pour ajouter la page actuelle\n• Appuyez à nouveau pour la retirer des favoris\n• L\'icône devient rouge lorsque la page est dans les favoris\n\nVous pouvez enregistrer des pages nationales et régionales.';

  @override
  String get onboardingRegions => 'Chaînes de Toute l\'Europe';

  @override
  String get onboardingRegionsDescription =>
      'Sélectionnez et organisez vos chaînes préférées de toute l\'Europe.\n\nRecherchez par nom de chaîne ou nom de pays.\n\nVous pouvez accéder au télétexte d\'Italie, d\'Allemagne, d\'Autriche, de Suisse et de nombreux autres pays européens !';

  @override
  String get onboardingAutoRefresh => 'Actualisation Automatique';

  @override
  String get onboardingAutoRefreshDescription =>
      'Lorsque le rafraîchissement automatique est actif, le cercle autour du numéro de page se remplit progressivement:\n\nVous pouvez modifier le temps de rafraîchissement dans les paramètres\n\nL\'indicateur n\'est visible que lorsque des sous-pages sont disponibles et que le rafraîchissement automatique est actif.';

  @override
  String get onboardingPause => 'Pause Actualisation';

  @override
  String get onboardingPauseDescription =>
      'Vous pouvez mettre en pause le rafraîchissement automatique des sous-pages:\n\n• Appuyez n\'importe où sur la page où il n\'y a pas de numéros cliquables\n• Vous verrez apparaître l\'icône ⏸️ pour indiquer que le rafraîchissement est en pause\n• Appuyez à nouveau pour reprendre le rafraîchissement (icône ▶️)\n\nCette fonction est utile lorsque vous souhaitez lire une sous-page calmement sans qu\'elle ne change automatiquement.';

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
      'Touchez les numéros de page en surbrillance pour naviguer directement vers cette page\n\n';

  @override
  String get onboardingShortcuts => 'Menu Raccourcis';

  @override
  String get onboardingShortcutsDescription =>
      'Accédez rapidement aux pages les plus importantes du Télétexte.\n\nUtilisez ce menu pour aller directement à :\n• Page 100 : Index national\n• Page 200 : Actualités\n.....\nVous pouvez aussi rechercher des pages par titre en sélectionnant l\'option Rechercher une page';

  @override
  String get onboardingFavoritesList => 'Liste des Favoris';

  @override
  String get onboardingFavoritesListDescription =>
      'Gérez vos pages favorites :\n\n• Touchez une page pour l\'ouvrir\n• Glissez vers la gauche pour la supprimer\n• Touchez le crayon pour modifier la description\n• Appuyez longuement pour changer l\'ordre\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personnalisez l\'application selon vos préférences :\n\n• Charger le premier favori au démarrage : décidez quelle page Télétexte afficher au démarrage\n• Thème : choisissez entre clair, sombre ou automatique\n• Actualisation automatique : activez le chargement automatique des sous-pages\n• Cache : gérez la durée du cache des pages\n• Instructions : revoyez ce tutoriel quand vous voulez\n• Sauvegarde des favoris : sauvegardez et restaurez vos favoris\n• Paramètres de confidentialité et réinitialisation : gérez ou réinitialisez vos choix de confidentialité';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get start => 'Commencer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetInitialChannel => 'Réinitialiser le canal initial';

  @override
  String get resetInitialChannelDescription =>
      'Afficher à nouveau le dialogue de sélection du canal au prochain démarrage';

  @override
  String get resetCompleted => 'Réinitialisation terminée';

  @override
  String get resetInitialChannelMessage =>
      'Le canal initial a été réinitialisé.\n\nAu prochain démarrage de l\'application, il vous sera demandé de sélectionner à nouveau votre canal par défaut.\n\nRedémarrage de l\'application maintenant...';

  @override
  String get selectYourChannel =>
      'Sélectionnez votre canal Télétexte par défaut.\nVous pouvez le modifier à tout moment.';

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

  @override
  String get channelSelection => 'Sélection de chaîne';

  @override
  String get favoriteChannels => 'Chaînes favorites';

  @override
  String get reorder => 'Réorganiser';

  @override
  String get searchChannelOrCountry => 'Rechercher une chaîne ou un pays...';

  @override
  String get showAllChannels => 'Afficher toutes les chaînes';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count chaînes disponibles dans $countries pays';
  }

  @override
  String get allChannels => 'Toutes les chaînes';

  @override
  String get noFavoriteChannelsFound => 'Aucune chaîne favorite trouvée';

  @override
  String get noChannelsFound => 'Aucune chaîne trouvée';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name ajouté aux favoris';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name retiré des favoris';
  }

  @override
  String regionsAvailable(int count) {
    return '$count régions disponibles';
  }

  @override
  String get reorderFavorites => 'Réorganiser les favoris';

  @override
  String get countryIT => 'Italie';

  @override
  String get countryDE => 'Allemagne';

  @override
  String get countryAT => 'Autriche';

  @override
  String get countryCH => 'Suisse';

  @override
  String get countryES => 'Espagne';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Pays-Bas';

  @override
  String get countryPL => 'Pologne';

  @override
  String get countrySE => 'Suède';

  @override
  String get countryFI => 'Finlande';

  @override
  String get countryDK => 'Danemark';

  @override
  String get countryCZ => 'République tchèque';

  @override
  String get countryHR => 'Croatie';

  @override
  String get countryBA => 'Bosnie-Herzégovine';

  @override
  String get countryHU => 'Hongrie';

  @override
  String get countryIS => 'Islande';

  @override
  String get countrySI => 'Slovénie';

  @override
  String get countryUA => 'Ukraine';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Fonctionnalités Premium';

  @override
  String get premiumSubtitle => 'Améliorez votre expérience Teletext Europe';

  @override
  String get premiumNoAds => 'Pas de publicité';

  @override
  String get premiumNoAdsDescription =>
      'Supprimez toutes les bannières publicitaires et les annonces interstitielles';

  @override
  String get premiumFasterExperience => 'Expérience plus fluide';

  @override
  String get premiumFasterExperienceDescription =>
      'Naviguez sans interruptions publicitaires';

  @override
  String get premiumSupportDevelopment => 'Soutenir le développement';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Aidez à maintenir l\'application à jour avec de nouveaux canaux et fonctionnalités';

  @override
  String get premiumActivated => 'Abonnement actif';

  @override
  String get premiumThankYou => 'Merci pour votre soutien !';

  @override
  String get premiumOneTimePurchase => 'Abonnement trimestriel';

  @override
  String get premiumLifetime => 'Renouvellement automatique tous les 3 mois';

  @override
  String get purchasePremium => 'S\'abonner maintenant';

  @override
  String get restorePurchases => 'Restaurer l\'abonnement';

  @override
  String get premiumProductNotAvailable =>
      'Abonnement Premium non disponible pour le moment';

  @override
  String get premiumPurchaseError =>
      'Erreur lors de l\'abonnement. Veuillez réessayer.';

  @override
  String get premiumRestoreSuccess => 'Abonnement restauré avec succès !';

  @override
  String get premiumRestoreNoPurchases => 'Aucun abonnement actif trouvé';

  @override
  String get premiumRestoreError =>
      'Erreur lors de la restauration de l\'abonnement';

  @override
  String get premiumLegalNote =>
      'Abonnement mensuel ou trimestriel avec renouvellement automatique. Vous pouvez annuler à tout moment depuis les paramètres de votre compte Apple/Google. Le paiement sera débité lors de la confirmation. L\'abonnement se renouvelle automatiquement (mensuellement ou tous les 3 mois selon le forfait choisi).';

  @override
  String get goPremium => 'S\'abonner à Premium';

  @override
  String get premiumChoosePlan => 'Choisissez votre forfait';

  @override
  String get premiumMonthly => 'Mensuel';

  @override
  String get premiumQuarterly => 'Trimestriel';

  @override
  String get premiumPerMonth => 'par mois';

  @override
  String get premiumEvery3Months => 'tous les 3 mois';

  @override
  String premiumSavePercent(String percent) {
    return 'Économisez $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Plan mensuel';

  @override
  String get premiumQuarterlyPlan => 'Plan trimestriel';

  @override
  String get premiumSubscriptionInfo => 'Informations sur l\'abonnement';

  @override
  String get premiumPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get premiumTermsOfUse => 'Conditions d\'utilisation (EULA)';

  @override
  String get premiumLoadingSubscriptions => 'Loading subscription options...';

  @override
  String get premiumLoadErrorRetry =>
      'Unable to load subscription options. Please try again.';
}
