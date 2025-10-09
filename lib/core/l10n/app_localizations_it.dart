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
  String get pageUnavailable =>
      'Impossibile caricare l\'immagine della pagina.\nRiprova tra qualche istante.';

  @override
  String get pageNotAvailable => 'La pagina richiesta non è disponibile';

  @override
  String get pageLoadError =>
      'Si è verificato un errore durante il caricamento della pagina.\nTorna alla pagina 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'La pagina $pageNumber non è disponibile per $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'La pagina $pageNumber non è disponibile per $regionName.\nProva con un altro numero tra 100 e 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Non ci sono altre pagine disponibili per $regionName';
  }

  @override
  String get noMorePages => 'Non ci sono altre pagine disponibili';

  @override
  String get invalidSubpageNumber => 'Numero di sottopagina non valido';

  @override
  String subpageError(int current, int total) {
    return 'Errore nel caricamento della sottopagina $current di $total';
  }

  @override
  String get swipePrevious => '← Precedente';

  @override
  String get swipeNext => 'Successiva →';

  @override
  String get swipeNextUp => 'Successiva ↑';

  @override
  String get swipePreviousDown => 'Precedente ↓';

  @override
  String get swipeRefresh => 'Aggiorna ↻';

  @override
  String get pageAddedToFavorites => 'Pagina aggiunta ai preferiti';

  @override
  String get pageRemovedFromFavorites => 'Pagina rimossa dai preferiti';

  @override
  String get editDescription => 'Modifica descrizione';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Pagina $pageNumber - $regionName';
  }

  @override
  String get description => 'Descrizione';

  @override
  String get enterCustomDescription =>
      'Inserisci una descrizione personalizzata';

  @override
  String get restoreHint =>
      'Suggerimento: tieni premuto il pulsante \"RIPRISTINA\" per tornare alla descrizione predefinita.';

  @override
  String get restore => 'RIPRISTINA';

  @override
  String get cancel => 'ANNULLA';

  @override
  String get save => 'SALVA';

  @override
  String get searchHint => 'Cerca pagina...';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get settings => 'Impostazioni';

  @override
  String get enterPageNumber => 'Inserisci il numero della pagina';

  @override
  String pageNumberRange(int minPage) {
    return 'Numero da $minPage a 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Lista preferiti';

  @override
  String get confirmRemoval => 'Conferma rimozione';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Vuoi davvero rimuovere $description dai preferiti?';
  }

  @override
  String get remove => 'Rimuovi';

  @override
  String get edit => 'Modifica';

  @override
  String get close => 'Chiudi';

  @override
  String get noFavorites => 'Nessun preferito';

  @override
  String get useFavoriteIcon =>
      'Usa l\'icona ❤️ per aggiungere pagine ai preferiti';

  @override
  String loadingPage(int pageNumber) {
    return 'Caricamento pagina $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Nessuna pagina da aggiungere ai preferiti';

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
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String errorWithMessage(String message) {
    return 'Errore: $message';
  }

  @override
  String get retry => 'Riprova';

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
      'Scopri tutte le funzionalità dell\'app\'';

  @override
  String get onboardingNavigation => 'Navigazione Pagine';

  @override
  String get onboardingNavigationDescription =>
      'Usa le frecce laterali per navigare tra le pagine:\n\n• Freccia sinistra: vai alla pagina precedente\n• Freccia destra: vai alla pagina successiva\n\nPuoi anche usare lo swipe orizzontale per lo stesso effetto.';

  @override
  String get onboardingFavorites => 'Preferiti';

  @override
  String get onboardingFavoritesDescription =>
      'Salva le pagine che visiti più spesso:\n\n• Tocca l\'icona indicata per aggiungere la pagina corrente\n• Tocca di nuovo per rimuoverla dai preferiti\n• L\'icona diventa rossa quando la pagina è tra i preferiti\n\nPuoi salvare sia pagine nazionali che regionali.';

  @override
  String get onboardingRegions => 'Televideo Regionale';

  @override
  String get onboardingRegionsDescription =>
      'Accedi al Televideo della tua regione\n\nLa tua posizione verrà rilevata automaticamente per suggerirti la regione corretta.';

  @override
  String get onboardingAutoRefresh => 'Autocaricamento Sottopagine';

  @override
  String get onboardingAutoRefreshDescription =>
      'Quando l\'aggiornamento automatico è attivo, il cerchio intorno al numero di pagina si riempie progressivamente:\n\nModifica il tempo di aggiornamento nelle impostazioni\n\nL\'indicatore è visibile solo quando ci sono sottopagine disponibili e l\'aggiornamento automatico è attivo.';

  @override
  String get onboardingPause => 'Pausa Autocaricamento';

  @override
  String get onboardingPauseDescription =>
      'Puoi mettere in pausa l\'aggiornamento automatico delle sottopagine:\n\n• Tocca in un punto qualsiasi della pagina dove non ci sono numeri cliccabili\n• Vedrai apparire l\'icona ⏸️ per indicare che l\'aggiornamento è in pausa\n• Tocca di nuovo per riprendere l\'aggiornamento (icona ▶️)\n\nQuesta funzione è utile quando vuoi leggere con calma una sottopagina senza che cambi automaticamente.';

  @override
  String get onboardingPageSelector => 'Selettore Pagina';

  @override
  String get onboardingPageSelectorDescription =>
      'Tocca il numero centrale per inserire direttamente una pagina.\n\nInserisci un numero tra 100 e 999 per saltare a quella pagina.';

  @override
  String get onboardingSubpageNavigation => 'Navigazione Sottopagine';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Se la pagina ha sottopagine, vedrai anche l\'indicatore:\n• 1/3 significa: prima sottopagina di tre disponibili\n\nUsa le frecce centrali per navigare tra le sottopagine:\n\n• Freccia su: vai alla sottopagina successiva\n• Freccia giù: vai alla sottopagina precedente\n\nLe frecce sono attive solo quando ci sono sottopagine disponibili.';

  @override
  String get onboardingSwipe => 'Navigazione Swipe';

  @override
  String get onboardingSwipeDescription =>
      'Naviga facilmente tra le pagine con i gesti mostrati sopra.';

  @override
  String get onboardingClickableNumbers => 'Numeri di Pagina Cliccabili';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tocca i numeri di pagina evidenziati per navigare direttamente a quella pagina\n\nLe pagine 100/1 del Televideo Nazionale e 300/1 del Televideo Regionale non sono cliccabili';

  @override
  String get onboardingShortcuts => 'Menu Shortcuts';

  @override
  String get onboardingShortcutsDescription =>
      'Accedi rapidamente alle pagine più importanti del Televideo.\n\nUsa questo menu per saltare direttamente a:\n• Pagina 100: Indice nazionale\n• Pagina 200: Notizie\n.....\nPuoi anche cercare le pagine per titolo selezionando l\'opzione Cerca pagina';

  @override
  String get onboardingFavoritesList => 'Lista Preferiti';

  @override
  String get onboardingFavoritesListDescription =>
      'Gestisci le tue pagine preferite:\n\n• Tocca una pagina per aprirla\n• Scorri a sinistra per rimuoverla\n• Tocca la matita per modificare la descrizione\n• Tieni premuto per cambiare l\'ordine\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personalizza l\'app secondo le tue preferenze:\n\n• Carica primo preferito all\'avvio: decidi con quale pagina Televideo iniziare\n• Tema: scegli tra chiaro, scuro o automatico\n• Aggiornamento automatico: abilita il caricamento automatico delle sottopagine\n• Cache: gestisci la durata della cache delle pagine\n• Istruzioni: rivedi questo tutorial quando vuoi\n• Backup Preferiti: salva e ripristina i tuoi preferiti\n• Impostazioni Privacy e reset: gestisci o resetta le tue scelte sulla privacy';

  @override
  String get dontShowAgain => 'Non mostrare più';

  @override
  String get start => 'Inizia';

  @override
  String get reset => 'Reset';

  @override
  String backToPage(int pageNumber) {
    return 'Torna alla pagina $pageNumber';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'La pagina $pageNumber non è disponibile.\nProva con un altro numero tra $minPage e 999.\nTorna a $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'Si è verificato un errore durante il caricamento della pagina.\nTorna a $minPage';
  }

  @override
  String get support => 'Supporto';

  @override
  String get supportDescription => 'Contattaci per assistenza';

  @override
  String get supportTitle => 'Siamo qui per aiutarti!';

  @override
  String get supportSubtitle =>
      'Per qualsiasi domanda o assistenza, non esitare a contattarci';

  @override
  String get directContact => 'Contatto Diretto';

  @override
  String get emailLabel => 'Email';

  @override
  String get websiteLabel => 'Sito Web';

  @override
  String get responseTime => 'Tempo di risposta medio: 24-48 ore';

  @override
  String get faq => 'Domande Frequenti';

  @override
  String get faqGeolocation => 'Come funziona la geolocalizzazione?';

  @override
  String get faqGeolocationAnswer =>
      'L\'app utilizza la posizione del dispositivo per identificare automaticamente la tua regione e mostrarti le notizie locali pertinenti. Puoi disattivare questa funzione nelle impostazioni dell\'app.';

  @override
  String get faqFavorites => 'Come salvare una pagina nei preferiti?';

  @override
  String get faqFavoritesAnswer =>
      'Mentre visualizzi una pagina, tocca l\'icona della stella per aggiungerla ai preferiti. Puoi accedere alle tue pagine preferite dal menu principale.';

  @override
  String get faqTheme => 'Come cambiare il tema dell\'app?';

  @override
  String get faqThemeAnswer =>
      'Vai nelle impostazioni dell\'app e seleziona il tema desiderato (chiaro/scuro). L\'app supporta anche l\'impostazione automatica basata sul tema di sistema.';

  @override
  String get faqOffline => 'L\'app funziona offline?';

  @override
  String get faqOfflineAnswer =>
      'No, è necessaria una connessione internet attiva per accedere alle pagine del Televideo in tempo reale.';

  @override
  String get faqReportProblem => 'Come segnalare un problema?';

  @override
  String get faqReportProblemAnswer =>
      'Invia una email dettagliata a samuele@codebysam.it descrivendo il problema riscontrato.';

  @override
  String get reportBugTitle => 'Segnala un problema';

  @override
  String get reportBugInstructions =>
      'Quando segnali un problema, includi se possibile:';

  @override
  String get reportBugItems =>
      'Versione dell\'app\nModello del dispositivo\nSistema operativo\nScreenshot del problema';

  @override
  String get developedBy => 'Sviluppato da CodeBySam';

  @override
  String get errorOpeningLink => 'Impossibile aprire il link';

  @override
  String get errorOpeningEmail => 'Impossibile aprire l\'email';
}
