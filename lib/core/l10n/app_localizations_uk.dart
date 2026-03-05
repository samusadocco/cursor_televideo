// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get welcome => 'Ласкаво просимо!';

  @override
  String get welcomeSelectChannel => 'Виберіть канал за замовчуванням';

  @override
  String page(int pageNumber) {
    return 'Сторінка $pageNumber';
  }

  @override
  String get pageUnavailable =>
      'Не вдалося завантажити зображення сторінки.\nСпробуйте ще раз через мить.';

  @override
  String get pageNotAvailable => 'Запитувана сторінка недоступна';

  @override
  String get pageLoadError =>
      'Виникла помилка під час завантаження сторінки.\nПовернутися на сторінку 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'Сторінка $pageNumber недоступна для $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'Сторінка $pageNumber недоступна для $regionName.\nСпробуйте інший номер між 100 і 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Більше немає доступних сторінок для $regionName';
  }

  @override
  String get noMorePages => 'Більше немає доступних сторінок';

  @override
  String get invalidSubpageNumber => 'Недійсний номер підсторінки';

  @override
  String subpageError(int current, int total) {
    return 'Помилка завантаження підсторінки $current з $total';
  }

  @override
  String get swipePrevious => '← Попередня';

  @override
  String get swipeNext => 'Наступна →';

  @override
  String get swipeNextUp => 'Наступна ↑';

  @override
  String get swipePreviousDown => 'Попередня ↓';

  @override
  String get swipeRefresh => 'Оновити ↻';

  @override
  String get pageAddedToFavorites => 'Сторінка додана до обраного';

  @override
  String get pageRemovedFromFavorites => 'Сторінка видалена з обраного';

  @override
  String get editDescription => 'Редагувати опис';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Сторінка $pageNumber - $regionName';
  }

  @override
  String get description => 'Опис';

  @override
  String get enterCustomDescription => 'Введіть власний опис';

  @override
  String get restoreHint =>
      'Порада: довго натисніть кнопку \"ВІДНОВИТИ\", щоб повернутися до опису за замовчуванням.';

  @override
  String get restore => 'ВІДНОВИТИ';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get searchHint => 'Шукати сторінку...';

  @override
  String get noResults => 'Немає результатів';

  @override
  String get settings => 'Налаштування';

  @override
  String get enterPageNumber => 'Введіть номер сторінки';

  @override
  String pageNumberRange(int minPage) {
    return 'Номер від $minPage до 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Список обраного';

  @override
  String get confirmRemoval => 'Підтвердити видалення';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Ви дійсно хочете видалити $description з обраного?';
  }

  @override
  String get remove => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get close => 'Закрити';

  @override
  String get noFavorites => 'Немає обраного';

  @override
  String get useFavoriteIcon =>
      'Використовуйте значок ❤️, щоб додати сторінки до обраного';

  @override
  String loadingPage(int pageNumber) {
    return 'Завантаження сторінки $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Немає сторінки для додавання до обраного';

  @override
  String get language => 'Мова';

  @override
  String get systemLanguage => 'Системна мова';

  @override
  String get darkMode => 'Темний режим';

  @override
  String get autoRefresh => 'Автоматичне оновлення';

  @override
  String get favorites => 'Обране';

  @override
  String get search => 'Пошук';

  @override
  String get regions => 'Регіони';

  @override
  String get home => 'Головна';

  @override
  String get addToFavorites => 'Додати до обраного';

  @override
  String get removeFromFavorites => 'Видалити з обраного';

  @override
  String get loading => 'Завантаження...';

  @override
  String get error => 'Помилка';

  @override
  String errorWithMessage(String message) {
    return 'Помилка: $message';
  }

  @override
  String get retry => 'Спробувати знову';

  @override
  String get next => 'Далі';

  @override
  String get previous => 'Назад';

  @override
  String get pageNotFound => 'Сторінка не знайдена';

  @override
  String get networkError => 'Помилка мережі';

  @override
  String get connectionRequired => 'Потрібне з\'єднання';

  @override
  String get refreshing => 'Оновлення...';

  @override
  String get lastUpdate => 'Останнє оновлення';

  @override
  String get theme => 'Тема';

  @override
  String get systemTheme => 'Системна тема';

  @override
  String get lightTheme => 'Світла тема';

  @override
  String get darkTheme => 'Темна тема';

  @override
  String get selectTheme => 'Виберіть тему';

  @override
  String get startupPageOption => 'Стартова сторінка';

  @override
  String get startupPageOptionLastPage =>
      'Остання переглянута сторінка (за замовчуванням)';

  @override
  String get startupPageOptionFirstFavorite => 'Перше обране (якщо доступно)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Головна сторінка останнього каналу';

  @override
  String get cacheDuration =>
      'Тривалість зберігання зображень сторінок Телетексту в кеші (0 секунд для вимкнення)';

  @override
  String get seconds => 'секунд';

  @override
  String get autoRefreshDescription => 'Автоматично оновлювати підсторінки';

  @override
  String get refreshInterval => 'Інтервал оновлення';

  @override
  String get showOnboardingAtStartup => 'Показувати інструкції при запуску';

  @override
  String get showOnboardingAtStartupDescription =>
      'Показувати інструкції щоразу, коли ви відкриваєте програму';

  @override
  String get showInstructions => 'Показати інструкції';

  @override
  String get showInstructionsDescription =>
      'Переглянути інструкції з використання програми';

  @override
  String get backupFavorites => 'Резервна копія обраного';

  @override
  String get backupFavoritesDescription => 'Зберегти та відновити ваше обране';

  @override
  String get support => 'Підтримка';

  @override
  String get supportDescription => 'Зв\'яжіться з нами для отримання допомоги';

  @override
  String get supportTitle => 'Ми тут, щоб допомогти!';

  @override
  String get supportSubtitle =>
      'З будь-яких питань чи допомоги не соромтеся звертатися до нас';

  @override
  String get directContact => 'Прямий контакт';

  @override
  String get emailLabel => 'Електронна пошта';

  @override
  String get websiteLabel => 'Веб-сайт';

  @override
  String get responseTime => 'Середній час відповіді: 24-48 годин';

  @override
  String get faq => 'Часті запитання';

  @override
  String get faqGeolocation => 'Як працює геолокація?';

  @override
  String get faqGeolocationAnswer =>
      'Програма використовує місцезнаходження вашого пристрою для автоматичної ідентифікації вашого регіону та відображення відповідних місцевих новин. Ви можете вимкнути цю функцію в налаштуваннях програми.';

  @override
  String get faqFavorites => 'Як зберегти сторінку в обраному?';

  @override
  String get faqFavoritesAnswer =>
      'Під час перегляду сторінки торкніться значка зірки, щоб додати її до обраного. Ви можете отримати доступ до обраних сторінок з головного меню.';

  @override
  String get faqTheme => 'Як змінити тему програми?';

  @override
  String get faqThemeAnswer =>
      'Перейдіть до налаштувань програми та виберіть бажану тему (світлу/темну). Програма також підтримує автоматичну тему на основі системних налаштувань.';

  @override
  String get faqOffline => 'Чи працює програма офлайн?';

  @override
  String get faqOfflineAnswer =>
      'Ні, для доступу до сторінок Телетексту в реальному часі потрібне активне підключення до Інтернету.';

  @override
  String get faqReportProblem => 'Як повідомити про проблему?';

  @override
  String get faqReportProblemAnswer =>
      'Надішліть детальний електронний лист на адресу samuele@codebysam.it з описом проблеми, яку ви зіткнулися.';

  @override
  String get reportBugTitle => 'Повідомити про проблему';

  @override
  String get reportBugInstructions =>
      'Повідомляючи про проблему, вкажіть, якщо можливо:';

  @override
  String get reportBugItems =>
      'Версія програми\nМодель пристрою\nОперційна система\nСкріншот проблеми';

  @override
  String get developedBy => 'Розроблено CodeBySam';

  @override
  String get errorOpeningLink => 'Не вдалося відкрити посилання';

  @override
  String get errorOpeningEmail => 'Не вдалося відкрити електронну пошту';

  @override
  String get privacySettings => 'Налаштування конфіденційності';

  @override
  String get privacySettingsDescription =>
      'Змініть свої налаштування конфіденційності для реклами';

  @override
  String get resetPrivacySettings => 'Скинути налаштування конфіденційності';

  @override
  String get resetPrivacySettingsDescription =>
      'Повністю скинути налаштування конфіденційності';

  @override
  String get resetPrivacyConfirm =>
      'Ви дійсно хочете скинути налаштування конфіденційності? При наступному запуску програми вас знову попросять дати згоду.';

  @override
  String get privacySettingsUnavailable =>
      'Налаштування конфіденційності наразі недоступні';

  @override
  String get privacySettingsReset =>
      'Налаштування конфіденційності скинуто. Перезапустіть програму для нової згоди.';

  @override
  String get version => 'Версія';

  @override
  String get build => 'збірка';

  @override
  String get onboardingWelcome => 'Ласкаво просимо до Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'Програма для перегляду всіх телетекстових каналів в Європі';

  @override
  String get onboardingDefaultChannel => 'Виберіть канал за замовчуванням';

  @override
  String get onboardingDefaultChannelDescription =>
      'При запуску програми вас попросять вибрати бажаний канал з усіх доступних каналів.\n\nВи можете змінити канал за замовчуванням у будь-який час з меню Налаштування.';

  @override
  String get onboardingNavigation => 'Навігація сторінками';

  @override
  String get onboardingNavigationDescription =>
      'Використовуйте бічні стрілки для переміщення між сторінками:\n\n• Стрілка вліво: перейти до попередньої сторінки\n• Стрілка вправо: перейти до наступної сторінки\n\nВи також можете використовувати горизонтальне перетягування для того ж ефекту.';

  @override
  String get onboardingFavorites => 'Обране';

  @override
  String get onboardingFavoritesDescription =>
      'Збережіть сторінки, які ви відвідуєте найчастіше:\n\n• Торкніться вказаного значка, щоб додати поточну сторінку\n• Торкніться знову, щоб видалити її з обраного\n• Значок стає червоним, коли сторінка в обраному\n\nВи можете зберігати як національні, так і регіональні сторінки.';

  @override
  String get onboardingRegions => 'Канали з усієї Європи';

  @override
  String get onboardingRegionsDescription =>
      'Виберіть та організуйте свої улюблені канали з усієї Європи.\n\nШукайте за назвою каналу або назвою країни.\n\nВи можете отримати доступ до телетексту з Італії, Німеччини, Австрії, Швейцарії та багатьох інших європейських країн!';

  @override
  String get onboardingAutoRefresh => 'Автоматичне оновлення підсторінок';

  @override
  String get onboardingAutoRefreshDescription =>
      'Коли автоматичне оновлення активне, коло навколо номера сторінки поступово заповнюється:\n\nВи можете змінити час оновлення в налаштуваннях\n\nІндикатор видимий лише тоді, коли доступні підсторінки та активне автоматичне оновлення.';

  @override
  String get onboardingPause => 'Призупинити автоматичне завантаження';

  @override
  String get onboardingPauseDescription =>
      'Ви можете призупинити автоматичне оновлення підсторінок:\n\n• Торкніться будь-якого місця на сторінці, де немає клікабельних номерів\n• Ви побачите значок ⏸️, який вказує, що оновлення призупинено\n• Торкніться знову, щоб відновити оновлення (значок ▶️)\n\nЦя функція корисна, коли ви хочете спокійно прочитати підсторінку без автоматичної зміни.';

  @override
  String get onboardingPageSelector => 'Селектор сторінки';

  @override
  String get onboardingPageSelectorDescription =>
      'Торкніться центрального номера, щоб безпосередньо ввести сторінку.\n\nВведіть номер між 100 і 999, щоб перейти до цієї сторінки.';

  @override
  String get onboardingSubpageNavigation => 'Навігація підсторінками';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Якщо сторінка має підсторінки, ви також побачите індикатор:\n• 1/3 означає: перша підсторінка з трьох доступних\n\nВикористовуйте центральні стрілки для переміщення між підсторінками:\n\n• Стрілка вгору: перейти до наступної підсторінки\n• Стрілка вниз: перейти до попередньої підсторінки\n\nСтрілки активні лише тоді, коли доступні підсторінки.';

  @override
  String get onboardingSwipe => 'Навігація свайпом';

  @override
  String get onboardingSwipeDescription =>
      'Легко переміщуйтеся між сторінками за допомогою жестів, показаних вище.';

  @override
  String get onboardingClickableNumbers => 'Клікабельні номери сторінок';

  @override
  String get onboardingClickableNumbersDescription =>
      'Торкніться виділених номерів сторінок, щоб перейти безпосередньо до цієї сторінки\n\n';

  @override
  String get onboardingShortcuts => 'Меню ярликів';

  @override
  String get onboardingShortcutsDescription =>
      'Швидкий доступ до найважливіших сторінок Телетексту.\n\nВикористовуйте це меню, щоб перейти безпосередньо до:\n• Сторінка 100: Національний індекс\n• Сторінка 200: Новини\n.....\nВи також можете шукати сторінки за назвою, вибравши опцію Пошук сторінки';

  @override
  String get onboardingFavoritesList => 'Список обраного';

  @override
  String get onboardingFavoritesListDescription =>
      'Керуйте своїми улюбленими сторінками:\n\n• Торкніться сторінки, щоб відкрити її\n• Проведіть пальцем вліво, щоб видалити її\n• Торкніться олівця, щоб редагувати опис\n• Довго натисніть, щоб змінити порядок\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Налаштуйте програму відповідно до ваших уподобань:\n\n• Завантажити перше обране при запуску: вирішіть, з якої сторінки Телетексту почати\n• Тема: виберіть між світлою, темною або автоматичною\n• Автоматичне оновлення: увімкніть автоматичне завантаження підсторінок\n• Кеш: керуйте тривалістю зберігання сторінок у кеші\n• Інструкції: переглядайте цей посібник, коли захочете\n• Резервна копія обраного: збережіть та відновіть своє обране\n• Налаштування конфіденційності та скидання: керуйте або скиньте свої вибори конфіденційності';

  @override
  String get dontShowAgain => 'Більше не показувати';

  @override
  String get start => 'Почати';

  @override
  String get reset => 'Скинути';

  @override
  String get resetInitialChannel => 'Скинути початковий канал';

  @override
  String get resetInitialChannelDescription =>
      'Показати діалогове вікно вибору каналу знову при наступному запуску';

  @override
  String get resetCompleted => 'Скидання завершено';

  @override
  String get resetInitialChannelMessage =>
      'Початковий канал було скинуто.\n\nПри наступному запуску програми вас попросять знову вибрати канал за замовчуванням.\n\nПерезапуск програми зараз...';

  @override
  String get selectYourChannel =>
      'Виберіть свій канал Телетексту за замовчуванням.\nВи можете змінити його в будь-який час.';

  @override
  String backToPage(int pageNumber) {
    return 'Повернутися до сторінки $pageNumber';
  }

  @override
  String pageUnavailableWithHint(int pageNumber, int minPage, int backPage) {
    return 'Сторінка $pageNumber недоступна.\nСпробуйте інший номер між $minPage і 999.\nПовернутися до $backPage';
  }

  @override
  String pageLoadErrorWithHint(int minPage) {
    return 'Виникла помилка під час завантаження сторінки.\nПовернутися до $minPage';
  }

  @override
  String get channelSelection => 'Вибір каналу';

  @override
  String get favoriteChannels => 'Обрані канали';

  @override
  String get reorder => 'Змінити порядок';

  @override
  String get searchChannelOrCountry => 'Шукати канал або країну...';

  @override
  String get showAllChannels => 'Показати всі канали';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count каналів доступно з $countries країн';
  }

  @override
  String get allChannels => 'Усі канали';

  @override
  String get noFavoriteChannelsFound => 'Обраних каналів не знайдено';

  @override
  String get noChannelsFound => 'Каналів не знайдено';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name додано до обраного';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name видалено з обраного';
  }

  @override
  String regionsAvailable(int count) {
    return '$count доступних регіонів';
  }

  @override
  String get reorderFavorites => 'Змінити порядок обраного';

  @override
  String get countryIT => 'Італія';

  @override
  String get countryDE => 'Німеччина';

  @override
  String get countryAT => 'Австрія';

  @override
  String get countryCH => 'Швейцарія';

  @override
  String get countryES => 'Іспанія';

  @override
  String get countryPT => 'Португалія';

  @override
  String get countryNL => 'Нідерланди';

  @override
  String get countryPL => 'Польща';

  @override
  String get countrySE => 'Швеція';

  @override
  String get countryFI => 'Фінляндія';

  @override
  String get countryDK => 'Данія';

  @override
  String get countryCZ => 'Чехія';

  @override
  String get countryHR => 'Хорватія';

  @override
  String get countryBA => 'Боснія і Герцеговина';

  @override
  String get countryHU => 'Угорщина';

  @override
  String get countryIS => 'Ісландія';

  @override
  String get countrySI => 'Словенія';

  @override
  String get countryUA => 'Україна';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Преміум-функції';

  @override
  String get premiumSubtitle => 'Покращте свій досвід роботи з Teletext Europe';

  @override
  String get premiumNoAds => 'Без реклами';

  @override
  String get premiumNoAdsDescription =>
      'Видаліть всі банерні та повноекранні оголошення';

  @override
  String get premiumFasterExperience => 'Більш плавний досвід';

  @override
  String get premiumFasterExperienceDescription =>
      'Навігація без рекламних переривань';

  @override
  String get premiumSupportDevelopment => 'Підтримати розробку';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Допоможіть підтримувати програму з новими каналами та функціями';

  @override
  String get premiumActivated => 'Premium активовано';

  @override
  String get premiumThankYou => 'Дякуємо за вашу підтримку!';

  @override
  String get premiumOneTimePurchase => 'Квартальна підписка';

  @override
  String get premiumLifetime => 'Автоматичне поновлення кожні 3 місяці';

  @override
  String get purchasePremium => 'Підписатися зараз';

  @override
  String get restorePurchases => 'Відновити підписку';

  @override
  String get premiumProductNotAvailable => 'Преміум-підписка наразі недоступна';

  @override
  String get premiumPurchaseError =>
      'Помилка під час підписки. Спробуйте ще раз.';

  @override
  String get premiumRestoreSuccess => 'Підписку успішно відновлено!';

  @override
  String get premiumRestoreNoPurchases => 'Активної підписки не знайдено';

  @override
  String get premiumRestoreError => 'Помилка відновлення підписки';

  @override
  String get premiumLegalNote =>
      'Місячна або квартальна підписка з автоматичним поновленням. Ви можете скасувати в будь-який час у налаштуваннях облікового запису Apple/Google. Оплата стягується при підтвердженні. Підписка автоматично поновлюється (щомісяця або кожні 3 місяці залежно від обраного плану).';

  @override
  String get goPremium => 'Стати Premium';

  @override
  String get premiumChoosePlan => 'Виберіть свій план';

  @override
  String get premiumMonthly => 'Щомісячно';

  @override
  String get premiumQuarterly => 'Щоквартально';

  @override
  String get premiumPerMonth => 'на місяць';

  @override
  String get premiumEvery3Months => 'кожні 3 місяці';

  @override
  String premiumSavePercent(String percent) {
    return 'Заощаджуйте $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Місячний план';

  @override
  String get premiumQuarterlyPlan => 'Квартальний план';

  @override
  String get premiumSubscriptionInfo => 'Інформація про підписку';

  @override
  String get premiumPrivacyPolicy => 'Політика конфіденційності';

  @override
  String get premiumTermsOfUse => 'Умови використання (EULA)';
}
