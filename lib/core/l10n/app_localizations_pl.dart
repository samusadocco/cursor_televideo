// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Witaj!';

  @override
  String get welcomeSelectChannel => 'Wybierz domyślny kanał';

  @override
  String page(int pageNumber) {
    return 'Strona $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Nie można załadować obrazu strony.\nSpróbuj ponownie za chwilę.';

  @override
  String get pageNotAvailable => 'Żądana strona jest niedostępna';

  @override
  String get pageLoadError =>
      'Wystąpił błąd podczas ładowania strony.\nWróć do strony 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Strona $pageNumber nie jest dostępna dla $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Strona $pageNumber nie jest dostępna dla $regionName.\nSpróbuj innego numeru między 100 a 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Nie ma więcej dostępnych stron dla $regionName';
  }

  @override
  String get noMorePages => 'Nie ma więcej dostępnych stron';

  @override
  String get invalidSubpageNumber => 'Nieprawidłowy numer podstrony';

  @override
  String subpageError(int current, int total) {
    return 'Błąd ładowania podstrony $current z $total';
  }

  @override
  String get swipePrevious => '← Poprzednia';

  @override
  String get swipeNext => 'Następna →';

  @override
  String get swipeNextUp => 'Następna ↑';

  @override
  String get swipePreviousDown => 'Poprzednia ↓';

  @override
  String get swipeRefresh => 'Odśwież ↻';

  @override
  String get pageAddedToFavorites => 'Strona dodana do ulubionych';

  @override
  String get pageRemovedFromFavorites => 'Strona usunięta z ulubionych';

  @override
  String get editDescription => 'Edytuj opis';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Strona $pageNumber - $regionName';
  }

  @override
  String get description => 'Opis';

  @override
  String get enterCustomDescription => 'Wprowadź własny opis';

  @override
  String get restoreHint =>
      'Wskazówka: przytrzymaj przycisk \"PRZYWRÓĆ\", aby wrócić do domyślnego opisu.';

  @override
  String get restore => 'PRZYWRÓĆ';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get searchHint => 'Szukaj strony...';

  @override
  String get noResults => 'Brak wyników';

  @override
  String get settings => 'Ustawienia';

  @override
  String get enterPageNumber => 'Wprowadź numer strony';

  @override
  String pageNumberRange(int minPage) {
    return 'Numer od $minPage do 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Lista ulubionych';

  @override
  String get confirmRemoval => 'Potwierdź usunięcie';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Czy na pewno chcesz usunąć $description z ulubionych?';
  }

  @override
  String get remove => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get close => 'Zamknij';

  @override
  String get noFavorites => 'Brak ulubionych';

  @override
  String get useFavoriteIcon => 'Użyj ikony ❤️, aby dodać strony do ulubionych';

  @override
  String loadingPage(int pageNumber) {
    return 'Ładowanie strony $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'Brak strony do dodania do ulubionych';

  @override
  String get language => 'Język';

  @override
  String get systemLanguage => 'Język systemowy';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get autoRefresh => 'Automatyczne odświeżanie';

  @override
  String get favorites => 'Ulubione';

  @override
  String get search => 'Szukaj';

  @override
  String get regions => 'Regiony';

  @override
  String get home => 'Strona główna';

  @override
  String get addToFavorites => 'Dodaj do ulubionych';

  @override
  String get removeFromFavorites => 'Usuń z ulubionych';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String errorWithMessage(String message) {
    return 'Błąd: $message';
  }

  @override
  String get retry => 'Ponów próbę';

  @override
  String get next => 'Dalej';

  @override
  String get previous => 'Wstecz';

  @override
  String get pageNotFound => 'Strona nie znaleziona';

  @override
  String get networkError => 'Błąd sieci';

  @override
  String get connectionRequired => 'Wymagane połączenie';

  @override
  String get refreshing => 'Odświeżanie...';

  @override
  String get lastUpdate => 'Ostatnia aktualizacja';

  @override
  String get theme => 'Motyw';

  @override
  String get systemTheme => 'Motyw systemowy';

  @override
  String get lightTheme => 'Jasny motyw';

  @override
  String get darkTheme => 'Ciemny motyw';

  @override
  String get selectTheme => 'Wybierz motyw';

  @override
  String get startupPageOption => 'Strona startowa';

  @override
  String get startupPageOptionLastPage =>
      'Ostatnio oglądana strona (domyślnie)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Pierwszy ulubiony (jeśli dostępny)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Strona główna ostatniego kanału';

  @override
  String get cacheDuration =>
      'Czas przechowywania obrazów stron Teletekstu w pamięci podręcznej (0 sekund, aby wyłączyć)';

  @override
  String get seconds => 'sekund';

  @override
  String get autoRefreshDescription => 'Automatycznie odświeżaj podstrony';

  @override
  String get refreshInterval => 'Interwał odświeżania';

  @override
  String get showOnboardingAtStartup => 'Pokaż instrukcje przy uruchomieniu';

  @override
  String get showOnboardingAtStartupDescription =>
      'Pokazuj instrukcje za każdym razem, gdy otwierasz aplikację';

  @override
  String get showInstructions => 'Pokaż instrukcje';

  @override
  String get showInstructionsDescription =>
      'Przejrzyj instrukcje użytkowania aplikacji';

  @override
  String get backupFavorites => 'Kopia zapasowa ulubionych';

  @override
  String get backupFavoritesDescription => 'Zapisz i przywróć swoje ulubione';

  @override
  String get support => 'Wsparcie';

  @override
  String get supportDescription => 'Skontaktuj się z nami, aby uzyskać pomoc';

  @override
  String get supportTitle => 'Jesteśmy tu, aby pomóc!';

  @override
  String get supportSubtitle =>
      'W przypadku jakichkolwiek pytań lub pomocy nie wahaj się z nami skontaktować';

  @override
  String get directContact => 'Bezpośredni kontakt';

  @override
  String get emailLabel => 'Email';

  @override
  String get websiteLabel => 'Strona internetowa';

  @override
  String get responseTime => 'Średni czas odpowiedzi: 24-48 godzin';

  @override
  String get faq => 'Najczęściej zadawane pytania';

  @override
  String get faqGeolocation => 'Jak działa geolokalizacja?';

  @override
  String get faqGeolocationAnswer =>
      'Aplikacja wykorzystuje lokalizację Twojego urządzenia do automatycznej identyfikacji Twojego regionu i wyświetlania odpowiednich lokalnych wiadomości. Możesz wyłączyć tę funkcję w ustawieniach aplikacji.';

  @override
  String get faqFavorites => 'Jak zapisać stronę w ulubionych?';

  @override
  String get faqFavoritesAnswer =>
      'Podczas przeglądania strony dotknij ikony gwiazdki, aby dodać ją do ulubionych. Możesz uzyskać dostęp do swoich ulubionych stron z menu głównego.';

  @override
  String get faqTheme => 'Jak zmienić motyw aplikacji?';

  @override
  String get faqThemeAnswer =>
      'Przejdź do ustawień aplikacji i wybierz żądany motyw (jasny/ciemny). Aplikacja obsługuje również automatyczny motyw oparty na ustawieniach systemowych.';

  @override
  String get faqOffline => 'Czy aplikacja działa offline?';

  @override
  String get faqOfflineAnswer =>
      'Nie, wymagane jest aktywne połączenie internetowe, aby uzyskać dostęp do stron Teletekstu w czasie rzeczywistym.';

  @override
  String get faqReportProblem => 'Jak zgłosić problem?';

  @override
  String get faqReportProblemAnswer =>
      'Wyślij szczegółowy email na adres samuele@codebysam.it opisujący napotkany problem.';

  @override
  String get reportBugTitle => 'Zgłoś problem';

  @override
  String get reportBugInstructions =>
      'Zgłaszając problem, podaj jeśli to możliwe:';

  @override
  String get reportBugItems =>
      'Wersja aplikacji\nModel urządzenia\nSystem operacyjny\nZrzut ekranu problemu';

  @override
  String get developedBy => 'Opracowane przez CodeBySam';

  @override
  String get errorOpeningLink => 'Nie można otworzyć linku';

  @override
  String get errorOpeningEmail => 'Nie można otworzyć emaila';

  @override
  String get privacySettings => 'Ustawienia prywatności';

  @override
  String get privacySettingsDescription =>
      'Modyfikuj swoje preferencje prywatności dotyczące reklam';

  @override
  String get resetPrivacySettings => 'Resetuj ustawienia prywatności';

  @override
  String get resetPrivacySettingsDescription =>
      'Całkowicie zresetuj ustawienia prywatności';

  @override
  String get resetPrivacyConfirm =>
      'Czy na pewno chcesz zresetować ustawienia prywatności? Przy następnym uruchomieniu aplikacji zostaniesz ponownie poproszony o zgodę.';

  @override
  String get privacySettingsUnavailable =>
      'Ustawienia prywatności są obecnie niedostępne';

  @override
  String get privacySettingsReset =>
      'Ustawienia prywatności zresetowane. Uruchom ponownie aplikację, aby wyrazić nową zgodę.';

  @override
  String get version => 'Wersja';

  @override
  String get build => 'kompilacja';

  @override
  String get onboardingWelcome => 'Witaj w Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Aplikacja do przeglądania wszystkich kanałów teletekstu w Europie';

  @override
  String get onboardingDefaultChannel => 'Wybierz domyślny kanał';

  @override
  String get onboardingDefaultChannelDescription =>
      'Przy uruchomieniu aplikacji zostaniesz poproszony o wybranie preferowanego kanału spośród wszystkich dostępnych kanałów.\n\nMożesz zmienić domyślny kanał w dowolnym momencie z menu Ustawienia.';

  @override
  String get onboardingNavigation => 'Nawigacja po stronach';

  @override
  String get onboardingNavigationDescription =>
      'Użyj strzałek bocznych, aby poruszać się między stronami:\n\n• Strzałka w lewo: przejdź do poprzedniej strony\n• Strzałka w prawo: przejdź do następnej strony\n\nMożesz również użyć poziomego przeciągnięcia do tego samego efektu.';

  @override
  String get onboardingFavorites => 'Ulubione';

  @override
  String get onboardingFavoritesDescription =>
      'Zapisz strony, które odwiedzasz najczęściej:\n\n• Dotknij wskazanej ikony, aby dodać bieżącą stronę\n• Dotknij ponownie, aby usunąć ją z ulubionych\n• Ikona zmienia kolor na czerwony, gdy strona jest w ulubionych\n\nMożesz zapisać zarówno strony krajowe, jak i regionalne.';

  @override
  String get onboardingRegions => 'Kanały z całej Europy';

  @override
  String get onboardingRegionsDescription =>
      'Wybierz i organizuj swoje ulubione kanały z całej Europy.\n\nSzukaj według nazwy kanału lub nazwy kraju.\n\nMożesz uzyskać dostęp do teletekstu z Włoch, Niemiec, Austrii, Szwajcarii i wielu innych krajów europejskich!';

  @override
  String get onboardingAutoRefresh => 'Automatyczne odświeżanie podstron';

  @override
  String get onboardingAutoRefreshDescription =>
      'Gdy automatyczne odświeżanie jest aktywne, okrąg wokół numeru strony wypełnia się stopniowo:\n\nMożesz zmienić czas odświeżania w ustawieniach\n\nWskaźnik jest widoczny tylko wtedy, gdy dostępne są podstrony, a automatyczne odświeżanie jest aktywne.';

  @override
  String get onboardingPause => 'Wstrzymaj automatyczne ładowanie';

  @override
  String get onboardingPauseDescription =>
      'Możesz wstrzymać automatyczne odświeżanie podstron:\n\n• Dotknij dowolnego miejsca na stronie, gdzie nie ma klikalnych numerów\n• Zobaczysz ikonę ⏸️, która wskazuje, że odświeżanie jest wstrzymane\n• Dotknij ponownie, aby wznowić odświeżanie (ikona ▶️)\n\nTa funkcja jest przydatna, gdy chcesz spokojnie przeczytać podstronę bez automatycznej zmiany.';

  @override
  String get onboardingPageSelector => 'Selektor strony';

  @override
  String get onboardingPageSelectorDescription =>
      'Dotknij centralnego numeru, aby bezpośrednio wprowadzić stronę.\n\nWprowadź numer między 100 a 999, aby przeskoczyć do tej strony.';

  @override
  String get onboardingSubpageNavigation => 'Nawigacja po podstronach';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Jeśli strona ma podstrony, zobaczysz również wskaźnik:\n• 1/3 oznacza: pierwsza podstrona z trzech dostępnych\n\nUżyj centralnych strzałek, aby poruszać się między podstronami:\n\n• Strzałka w górę: przejdź do następnej podstrony\n• Strzałka w dół: przejdź do poprzedniej podstrony\n\nStrzałki są aktywne tylko wtedy, gdy dostępne są podstrony.';

  @override
  String get onboardingSwipe => 'Nawigacja przeciąganiem';

  @override
  String get onboardingSwipeDescription =>
      'Poruszaj się łatwo między stronami za pomocą gestów pokazanych powyżej.';

  @override
  String get onboardingClickableNumbers => 'Klikalne numery stron';

  @override
  String get onboardingClickableNumbersDescription =>
      'Dotknij wyróżnionych numerów stron, aby przejść bezpośrednio do tej strony\n\n';

  @override
  String get onboardingShortcuts => 'Menu skrótów';

  @override
  String get onboardingShortcutsDescription =>
      'Szybki dostęp do najważniejszych stron Teletekstu.\n\nUżyj tego menu, aby przeskoczyć bezpośrednio do:\n• Strona 100: Indeks krajowy\n• Strona 200: Wiadomości\n.....\nMożesz również wyszukiwać strony według tytułu, wybierając opcję Szukaj strony';

  @override
  String get onboardingFavoritesList => 'Lista ulubionych';

  @override
  String get onboardingFavoritesListDescription =>
      'Zarządzaj swoimi ulubionymi stronami:\n\n• Dotknij strony, aby ją otworzyć\n• Przesuń w lewo, aby ją usunąć\n• Dotknij ołówka, aby edytować opis\n• Przytrzymaj, aby zmienić kolejność\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Dostosuj aplikację zgodnie ze swoimi preferencjami:\n\n• Załaduj pierwszy ulubiony przy uruchomieniu: zdecyduj, od której strony Teletekstu zacząć\n• Motyw: wybierz między jasnym, ciemnym lub automatycznym\n• Automatyczne odświeżanie: włącz automatyczne ładowanie podstron\n• Pamięć podręczna: zarządzaj czasem przechowywania stron w pamięci podręcznej\n• Instrukcje: przeglądaj ten samouczek, kiedy chcesz\n• Kopia zapasowa ulubionych: zapisz i przywróć swoje ulubione\n• Ustawienia prywatności i resetowanie: zarządzaj lub resetuj swoje wybory dotyczące prywatności';

  @override
  String get dontShowAgain => 'Nie pokazuj ponownie';

  @override
  String get start => 'Start';

  @override
  String get reset => 'Reset';

  @override
  String get resetInitialChannel => 'Resetuj kanał początkowy';

  @override
  String get resetInitialChannelDescription =>
      'Pokaż ponownie okno dialogowe wyboru kanału przy następnym uruchomieniu';

  @override
  String get resetCompleted => 'Reset zakończony';

  @override
  String get resetInitialChannelMessage =>
      'Kanał początkowy został zresetowany.\n\nPrzy następnym uruchomieniu aplikacji zostaniesz poproszony o ponowny wybór domyślnego kanału.\n\nUruchamianie aplikacji teraz...';

  @override
  String get selectYourChannel =>
      'Wybierz swój domyślny kanał Teletekstu.\nMożesz go zmienić w dowolnym momencie.';

  @override
  String backToPage(int pageNumber) {
    return 'Wróć do strony $pageNumber';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'Strona $pageNumber jest niedostępna.\nSpróbuj innego numeru między $minPage a 999.\nWróć do $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'Wystąpił błąd podczas ładowania strony.\nWróć do $minPage';
  }

  @override
  String get channelSelection => 'Wybór kanału';

  @override
  String get favoriteChannels => 'Ulubione kanały';

  @override
  String get reorder => 'Zmień kolejność';

  @override
  String get searchChannelOrCountry => 'Szukaj kanału lub kraju...';

  @override
  String get showAllChannels => 'Pokaż wszystkie kanały';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count kanałów dostępnych z $countries krajów';
  }

  @override
  String get allChannels => 'Wszystkie kanały';

  @override
  String get noFavoriteChannelsFound => 'Nie znaleziono ulubionych kanałów';

  @override
  String get noChannelsFound => 'Nie znaleziono kanałów';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name dodany do ulubionych';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name usunięty z ulubionych';
  }

  @override
  String regionsAvailable(int count) {
    return '$count dostępnych regionów';
  }

  @override
  String get reorderFavorites => 'Zmień kolejność ulubionych';

  @override
  String get countryIT => 'Włochy';

  @override
  String get countryDE => 'Niemcy';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Szwajcaria';

  @override
  String get countryES => 'Hiszpania';

  @override
  String get countryPT => 'Portugalia';

  @override
  String get countryNL => 'Holandia';

  @override
  String get countryPL => 'Polska';

  @override
  String get countrySE => 'Szwecja';

  @override
  String get countryFI => 'Finlandia';

  @override
  String get countryDK => 'Dania';

  @override
  String get countryCZ => 'Czechy';

  @override
  String get countryHR => 'Chorwacja';

  @override
  String get countryBA => 'Bośnia i Hercegowina';

  @override
  String get countryHU => 'Węgry';

  @override
  String get countryIS => 'Islandia';

  @override
  String get countrySI => 'Słowenia';

  @override
  String get countryUA => 'Ukraina';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Funkcje Premium';

  @override
  String get premiumSubtitle => 'Popraw swoje doświadczenie z Teletext Europe';

  @override
  String get premiumNoAds => 'Bez reklam';

  @override
  String get premiumNoAdsDescription =>
      'Usuń wszystkie bannery reklamowe i reklamy pełnoekranowe';

  @override
  String get premiumFasterExperience => 'Płynniejsze doświadczenie';

  @override
  String get premiumFasterExperienceDescription =>
      'Nawiguj bez przerw reklamowych';

  @override
  String get premiumSupportDevelopment => 'Wspieraj rozwój';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Pomóż utrzymać aplikację zaktualizowaną nowymi kanałami i funkcjami';

  @override
  String get premiumActivated => 'Premium aktywowane';

  @override
  String get premiumThankYou => 'Dziękujemy za wsparcie!';

  @override
  String get premiumOneTimePurchase => 'Subskrypcja kwartalna';

  @override
  String get premiumLifetime => 'Automatyczne odnowienie co 3 miesiące';

  @override
  String get purchasePremium => 'Subskrybuj teraz';

  @override
  String get restorePurchases => 'Przywróć subskrypcję';

  @override
  String get premiumProductNotAvailable =>
      'Subskrypcja Premium obecnie niedostępna';

  @override
  String get premiumPurchaseError =>
      'Błąd podczas subskrypcji. Spróbuj ponownie.';

  @override
  String get premiumRestoreSuccess => 'Subskrypcja przywrócona pomyślnie!';

  @override
  String get premiumRestoreNoPurchases => 'Nie znaleziono aktywnej subskrypcji';

  @override
  String get premiumRestoreError => 'Błąd podczas przywracania subskrypcji';

  @override
  String get premiumLegalNote =>
      'Subskrypcja kwartalna z automatycznym odnowieniem. Możesz anulować w dowolnym momencie w ustawieniach konta Apple/Google. Płatność zostanie pobrana po potwierdzeniu. Subskrypcja odnawia się automatycznie co 3 miesiące.';

  @override
  String get goPremium => 'Zostań Premium';

  @override
  String get premiumChoosePlan => 'Wybierz plan';

  @override
  String get premiumMonthly => 'Miesięcznie';

  @override
  String get premiumQuarterly => 'Kwartalnie';

  @override
  String get premiumPerMonth => 'miesięcznie';

  @override
  String get premiumEvery3Months => 'co 3 miesiące';

  @override
  String premiumSavePercent(String percent) {
    return 'Oszczędź $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Plan miesięczny';

  @override
  String get premiumQuarterlyPlan => 'Plan kwartalny';

  @override
  String get premiumSubscriptionInfo => 'Informacje o subskrypcji';
}
