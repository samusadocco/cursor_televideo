// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Das Seitenbild kann nicht geladen werden.\nBitte versuchen Sie es in einem Moment erneut.';

  @override
  String get pageNotAvailable => 'Die angeforderte Seite ist nicht verfügbar';

  @override
  String get pageLoadError =>
      'Beim Laden der Seite ist ein Fehler aufgetreten.\nZurück zu Seite 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Seite $pageNumber ist für $regionName nicht verfügbar';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Seite $pageNumber ist für $regionName nicht verfügbar.\nVersuchen Sie eine andere Nummer zwischen 100 und 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Keine weiteren Seiten verfügbar für $regionName';
  }

  @override
  String get noMorePages => 'Keine weiteren Seiten verfügbar';

  @override
  String get invalidSubpageNumber => 'Ungültige Unterseitennummer';

  @override
  String subpageError(int current, int total) {
    return 'Fehler beim Laden der Unterseite $current von $total';
  }

  @override
  String get swipePrevious => '← Vorherige';

  @override
  String get swipeNext => 'Nächste →';

  @override
  String get swipeNextUp => 'Nächste ↑';

  @override
  String get swipePreviousDown => 'Vorherige ↓';

  @override
  String get swipeRefresh => 'Aktualisieren ↻';

  @override
  String get pageAddedToFavorites => 'Seite zu Favoriten hinzugefügt';

  @override
  String get pageRemovedFromFavorites => 'Seite aus Favoriten entfernt';

  @override
  String get editDescription => 'Beschreibung bearbeiten';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Seite $pageNumber - $regionName';
  }

  @override
  String get description => 'Beschreibung';

  @override
  String get enterCustomDescription =>
      'Benutzerdefinierte Beschreibung eingeben';

  @override
  String get restoreHint =>
      'Tipp: Halten Sie die Schaltfläche \"WIEDERHERSTELLEN\" gedrückt, um zur Standardbeschreibung zurückzukehren.';

  @override
  String get restore => 'WIEDERHERSTELLEN';

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get save => 'SPEICHERN';

  @override
  String get searchHint => 'Seite suchen...';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get settings => 'Einstellungen';

  @override
  String get enterPageNumber => 'Seitennummer eingeben';

  @override
  String pageNumberRange(int minPage) {
    return 'Nummer von $minPage bis 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Favoritenliste';

  @override
  String get confirmRemoval => 'Entfernen bestätigen';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Möchten Sie $description wirklich aus den Favoriten entfernen?';
  }

  @override
  String get remove => 'Entfernen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get close => 'Schließen';

  @override
  String get noFavorites => 'Keine Favoriten';

  @override
  String get useFavoriteIcon =>
      'Verwenden Sie das ❤️ Symbol, um Seiten zu den Favoriten hinzuzufügen';

  @override
  String loadingPage(int pageNumber) {
    return 'Lade Seite $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Keine Seite zum Hinzufügen zu den Favoriten';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get autoRefresh => 'Automatische Aktualisierung';

  @override
  String get favorites => 'Favoriten';

  @override
  String get search => 'Suchen';

  @override
  String get regions => 'Regionen';

  @override
  String get home => 'Startseite';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get connectionRequired => 'Verbindung erforderlich';

  @override
  String get refreshing => 'Aktualisiere...';

  @override
  String get lastUpdate => 'Letzte Aktualisierung';

  @override
  String get theme => 'Design';

  @override
  String get systemTheme => 'Systemdesign';

  @override
  String get lightTheme => 'Helles Design';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get selectTheme => 'Design auswählen';

  @override
  String get loadFirstFavorite => 'Ersten Favoriten beim Start laden';

  @override
  String get loadFirstFavoriteDescription =>
      'Wenn aktiviert, wird der erste Favorit in der Liste beim Start der App geladen';

  @override
  String get cacheDuration =>
      'Cache-Dauer für Televideo-Seitenbilder (0 Sekunden zum Deaktivieren)';

  @override
  String get seconds => 'Sekunden';

  @override
  String get autoRefreshDescription => 'Unterseiten automatisch aktualisieren';

  @override
  String get refreshInterval => 'Aktualisierungsintervall';

  @override
  String get showOnboardingAtStartup => 'Anleitung beim Start anzeigen';

  @override
  String get showOnboardingAtStartupDescription =>
      'Anleitung bei jedem Öffnen der App anzeigen';

  @override
  String get showInstructions => 'Anleitung anzeigen';

  @override
  String get showInstructionsDescription => 'App-Bedienungsanleitung ansehen';

  @override
  String get backupFavorites => 'Favoriten sichern';

  @override
  String get backupFavoritesDescription =>
      'Favoriten speichern und wiederherstellen';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get privacySettingsDescription =>
      'Datenschutzeinstellungen für Werbung ändern';

  @override
  String get resetPrivacySettings => 'Datenschutzeinstellungen zurücksetzen';

  @override
  String get resetPrivacySettingsDescription =>
      'Datenschutzeinstellungen vollständig zurücksetzen';

  @override
  String get resetPrivacyConfirm =>
      'Möchten Sie die Datenschutzeinstellungen wirklich zurücksetzen? Sie werden beim nächsten Start der App erneut um Ihre Einwilligung gebeten.';

  @override
  String get privacySettingsUnavailable =>
      'Datenschutzeinstellungen sind derzeit nicht verfügbar';

  @override
  String get privacySettingsReset =>
      'Datenschutzeinstellungen zurückgesetzt. Starten Sie die App neu für die neue Einwilligung.';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get onboardingWelcome => 'Willkommen bei TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'Die App zum schnellen und einfachen Nachschlagen von RAI Televideo';

  @override
  String get onboardingNavigation => 'Navigation';

  @override
  String get onboardingNavigationDescription =>
      'Wischen Sie nach links oder rechts, um die Seite zu wechseln, tippen Sie auf Zahlen für direkte Navigation';

  @override
  String get onboardingFavorites => 'Favoriten';

  @override
  String get onboardingFavoritesDescription =>
      'Fügen Sie Seiten zu den Favoriten hinzu für schnellen Zugriff';

  @override
  String get onboardingRegions => 'Regionales Televideo';

  @override
  String get onboardingRegionsDescription =>
      'Zugriff auf das Televideo Ihrer Region';

  @override
  String get onboardingAutoRefresh => 'Automatische Aktualisierung';

  @override
  String get onboardingAutoRefreshDescription =>
      'Unterseiten werden automatisch aktualisiert';

  @override
  String get onboardingPause => 'Aktualisierung pausieren';

  @override
  String get onboardingPauseDescription =>
      'Tippen Sie auf einen leeren Bereich, um die automatische Aktualisierung zu pausieren';

  @override
  String get onboardingPageSelector => 'Seitenauswahl';

  @override
  String get onboardingPageSelectorDescription =>
      'Tippen Sie auf die mittlere Zahl, um direkt eine Seite einzugeben.\n\nGeben Sie eine Zahl zwischen 100 und 999 ein, um zu dieser Seite zu springen.';

  @override
  String get onboardingSubpageNavigation => 'Unterseiten-Navigation';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Wenn die Seite Unterseiten hat, sehen Sie auch den Indikator:\n• 1/3 bedeutet: erste Unterseite von drei verfügbaren\n\nVerwenden Sie die mittleren Pfeile zur Navigation zwischen Unterseiten:\n\n• Pfeil nach oben: zur nächsten Unterseite\n• Pfeil nach unten: zur vorherigen Unterseite\n\nDie Pfeile sind nur aktiv, wenn Unterseiten verfügbar sind.';

  @override
  String get onboardingSwipe => 'Wisch-Navigation';

  @override
  String get onboardingSwipeDescription =>
      'Navigieren Sie einfach zwischen den Seiten mit den oben gezeigten Gesten.';

  @override
  String get onboardingClickableNumbers => 'Klickbare Seitenzahlen';

  @override
  String get onboardingClickableNumbersDescription =>
      'Tippen Sie auf die hervorgehobenen Seitenzahlen, um direkt zu dieser Seite zu navigieren\n\nDie Seiten 100/1 des nationalen Televideo und 300/1 des regionalen Televideo sind nicht klickbar';

  @override
  String get onboardingShortcuts => 'Menü Verknüpfungen';

  @override
  String get onboardingShortcutsDescription =>
      'Schneller Zugriff auf die wichtigsten Televideo-Seiten.\n\nVerwenden Sie dieses Menü für direkten Zugriff auf:\n• Seite 100: Nationaler Index\n• Seite 200: Nachrichten\n.....\nSie können auch Seiten nach Titel suchen, indem Sie die Option Seite suchen wählen';

  @override
  String get onboardingFavoritesList => 'Favoritenliste';

  @override
  String get onboardingFavoritesListDescription =>
      'Verwalten Sie Ihre Favoritenseiten:\n\n• Tippen Sie auf eine Seite, um sie zu öffnen\n• Wischen Sie nach links zum Entfernen\n• Tippen Sie auf den Stift zum Bearbeiten der Beschreibung\n• Lange drücken zum Ändern der Reihenfolge\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Passen Sie die App nach Ihren Wünschen an:\n\n• Ersten Favoriten beim Start laden: Entscheiden Sie, mit welcher Televideo-Seite gestartet wird\n• Design: Wählen Sie zwischen hell, dunkel oder automatisch\n• Automatische Aktualisierung: Aktivieren Sie das automatische Laden von Unterseiten\n• Cache: Verwalten Sie die Cache-Dauer der Seiten\n• Anleitung: Sehen Sie sich dieses Tutorial an, wann immer Sie möchten\n• Favoriten sichern: Speichern und wiederherstellen Sie Ihre Favoriten\n• Datenschutzeinstellungen und Zurücksetzen: Verwalten oder setzen Sie Ihre Datenschutzeinstellungen zurück';

  @override
  String get dontShowAgain => 'Nicht mehr anzeigen';

  @override
  String get start => 'Starten';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String backToPage(int pageNumber) {
    return 'Zurück zu Seite $pageNumber';
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
  String get support => 'Unterstützung';

  @override
  String get supportDescription => 'Kontaktieren Sie uns für Hilfe';

  @override
  String get supportTitle => 'Wir sind hier, um zu helfen!';

  @override
  String get supportSubtitle =>
      'Bei Fragen oder Hilfe zögern Sie nicht, uns zu kontaktieren';

  @override
  String get directContact => 'Direkter Kontakt';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get websiteLabel => 'Webseite';

  @override
  String get responseTime => 'Durchschnittliche Antwortzeit: 24-48 Stunden';

  @override
  String get faq => 'Häufig gestellte Fragen';

  @override
  String get faqGeolocation => 'Wie funktioniert die Geolokalisierung?';

  @override
  String get faqGeolocationAnswer =>
      'Die App verwendet den Standort Ihres Geräts, um automatisch Ihre Region zu identifizieren und Ihnen relevante lokale Nachrichten anzuzeigen. Sie können diese Funktion in den App-Einstellungen deaktivieren.';

  @override
  String get faqFavorites => 'Wie speichere ich eine Seite in Favoriten?';

  @override
  String get faqFavoritesAnswer =>
      'Während Sie eine Seite anzeigen, tippen Sie auf das Sternsymbol, um sie zu den Favoriten hinzuzufügen. Sie können über das Hauptmenü auf Ihre Favoritenseiten zugreifen.';

  @override
  String get faqTheme => 'Wie ändere ich das App-Theme?';

  @override
  String get faqThemeAnswer =>
      'Gehen Sie zu den App-Einstellungen und wählen Sie Ihr gewünschtes Theme (hell/dunkel). Die App unterstützt auch die automatische Einstellung basierend auf den Systemeinstellungen.';

  @override
  String get faqOffline => 'Funktioniert die App offline?';

  @override
  String get faqOfflineAnswer =>
      'Nein, eine aktive Internetverbindung ist erforderlich, um auf Echtzeit-Teletext-Seiten zuzugreifen.';

  @override
  String get faqReportProblem => 'Wie melde ich ein Problem?';

  @override
  String get faqReportProblemAnswer =>
      'Senden Sie eine detaillierte E-Mail an samuele@codebysam.it und beschreiben Sie das aufgetretene Problem.';

  @override
  String get reportBugTitle => 'Problem melden';

  @override
  String get reportBugInstructions =>
      'Wenn Sie ein Problem melden, geben Sie bitte wenn möglich an:';

  @override
  String get reportBugItems =>
      'App-Version\nGerätmodell\nBetriebssystem\nScreenshot des Problems';

  @override
  String get developedBy => 'Entwickelt von CodeBySam';

  @override
  String get errorOpeningLink => 'Link kann nicht geöffnet werden';

  @override
  String get errorOpeningEmail => 'E-Mail kann nicht geöffnet werden';
}
