// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Lingua di sistema';

  @override
  String get darkMode => 'Tema scuro';

  @override
  String get autoRefresh => 'Aggiornamento automatico';

  @override
  String get favorites => 'Preferiti';

  @override
  String get search => 'Cerca';

  @override
  String get regions => 'Regioni';

  @override
  String get home => 'Home';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get searchHint => 'Cerca pagina...';

  @override
  String get noResults => 'Nessuna pagina trovata';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get close => 'Chiudi';

  @override
  String get next => 'Avanti';

  @override
  String get previous => 'Indietro';

  @override
  String get pageNotFound => 'Pagina non trovata';

  @override
  String get networkError => 'Errore di rete';

  @override
  String get connectionRequired => 'Connessione richiesta';

  @override
  String get refreshing => 'Aggiornamento...';

  @override
  String get lastUpdate => 'Ultimo aggiornamento';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Tema di sistema';

  @override
  String get lightTheme => 'Tema chiaro';

  @override
  String get darkTheme => 'Tema scuro';

  @override
  String get selectTheme => 'Seleziona tema';

  @override
  String get loadFirstFavorite => 'Carica il primo preferito all\'avvio';

  @override
  String get loadFirstFavoriteDescription =>
      'Se abilitato, all\'avvio dell\'app verrà caricato il primo preferito della lista';

  @override
  String get cacheDuration =>
      'Durata cache immagini pagine Televideo (0 secondi per disabilitare)';

  @override
  String get seconds => 'secondi';

  @override
  String get autoRefreshDescription =>
      'Aggiorna automaticamente le sottopagine';

  @override
  String get refreshInterval => 'Intervallo aggiornamento';

  @override
  String get showOnboardingAtStartup => 'Mostra istruzioni all\'avvio';

  @override
  String get showOnboardingAtStartupDescription =>
      'Mostra le istruzioni ogni volta che apri l\'app';

  @override
  String get showInstructions => 'Mostra istruzioni';

  @override
  String get showInstructionsDescription =>
      'Rivedi le istruzioni per l\'utilizzo dell\'app';

  @override
  String get backupFavorites => 'Backup preferiti';

  @override
  String get backupFavoritesDescription =>
      'Salva e ripristina i tuoi preferiti';

  @override
  String get privacySettings => 'Impostazioni Privacy';

  @override
  String get privacySettingsDescription =>
      'Modifica le tue preferenze sulla privacy per gli annunci';

  @override
  String get resetPrivacySettings => 'Reset Impostazioni Privacy';

  @override
  String get resetPrivacySettingsDescription =>
      'Resetta completamente le impostazioni sulla privacy';

  @override
  String get resetPrivacyConfirm =>
      'Vuoi davvero resettare le impostazioni sulla privacy? Ti verrà richiesto nuovamente il consenso al prossimo avvio dell\'app.';

  @override
  String get privacySettingsUnavailable =>
      'Le impostazioni sulla privacy non sono disponibili al momento';

  @override
  String get privacySettingsReset =>
      'Impostazioni privacy resettate. Riavvia l\'app per il nuovo consenso.';

  @override
  String get version => 'Versione';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Benvenuto in TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'L\'app per consultare il Televideo RAI in modo semplice e veloce';

  @override
  String get onboardingNavigation => 'Navigazione';

  @override
  String get onboardingNavigationDescription =>
      'Scorri a destra o sinistra per cambiare pagina, tocca i numeri per navigare direttamente';

  @override
  String get onboardingFavorites => 'Preferiti';

  @override
  String get onboardingFavoritesDescription =>
      'Aggiungi le pagine ai preferiti per accedervi rapidamente';

  @override
  String get onboardingRegions => 'Televideo Regionale';

  @override
  String get onboardingRegionsDescription =>
      'Accedi al Televideo della tua regione';

  @override
  String get onboardingAutoRefresh => 'Aggiornamento Automatico';

  @override
  String get onboardingAutoRefreshDescription =>
      'Le sottopagine si aggiornano automaticamente';

  @override
  String get onboardingPause => 'Pausa Aggiornamento';

  @override
  String get onboardingPauseDescription =>
      'Tocca un\'area vuota per mettere in pausa l\'aggiornamento automatico';

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
