// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get autoRefresh => 'Actualización automática';

  @override
  String get favorites => 'Favoritos';

  @override
  String get search => 'Buscar';

  @override
  String get regions => 'Regiones';

  @override
  String get home => 'Inicio';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Eliminar de favoritos';

  @override
  String get searchHint => 'Introduce el número de página';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get ok => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get networkError => 'Error de red';

  @override
  String get connectionRequired => 'Conexión requerida';

  @override
  String get refreshing => 'Actualizando...';

  @override
  String get lastUpdate => 'Última actualización';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Tema del sistema';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get selectTheme => 'Seleccionar tema';

  @override
  String get loadFirstFavorite => 'Cargar el primer favorito al inicio';

  @override
  String get loadFirstFavoriteDescription =>
      'Si está activado, se cargará el primer favorito al iniciar la aplicación';

  @override
  String get cacheDuration =>
      'Duración de caché de páginas Televideo (0 segundos para desactivar)';

  @override
  String get seconds => 'segundos';

  @override
  String get autoRefreshDescription =>
      'Actualizar automáticamente las subpáginas';

  @override
  String get refreshInterval => 'Intervalo de actualización';

  @override
  String get showOnboardingAtStartup => 'Mostrar instrucciones al inicio';

  @override
  String get showOnboardingAtStartupDescription =>
      'Mostrar las instrucciones cada vez que abres la aplicación';

  @override
  String get showInstructions => 'Mostrar instrucciones';

  @override
  String get showInstructionsDescription =>
      'Revisar las instrucciones de uso de la aplicación';

  @override
  String get backupFavorites => 'Copia de seguridad de favoritos';

  @override
  String get backupFavoritesDescription => 'Guardar y restaurar tus favoritos';

  @override
  String get privacySettings => 'Ajustes de privacidad';

  @override
  String get privacySettingsDescription =>
      'Modificar tus preferencias de privacidad para anuncios';

  @override
  String get resetPrivacySettings => 'Restablecer ajustes de privacidad';

  @override
  String get resetPrivacySettingsDescription =>
      'Restablecer completamente los ajustes de privacidad';

  @override
  String get resetPrivacyConfirm =>
      '¿Realmente quieres restablecer los ajustes de privacidad? Se te pedirá consentimiento nuevamente al próximo inicio de la aplicación.';

  @override
  String get privacySettingsUnavailable =>
      'Los ajustes de privacidad no están disponibles en este momento';

  @override
  String get privacySettingsReset =>
      'Ajustes de privacidad restablecidos. Reinicia la aplicación para el nuevo consentimiento.';

  @override
  String get version => 'Versión';

  @override
  String get build => 'compilación';

  @override
  String get onboardingWelcome => 'Bienvenido a TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'La aplicación para consultar el Televideo RAI de forma fácil y rápida';

  @override
  String get onboardingNavigation => 'Navegación';

  @override
  String get onboardingNavigationDescription =>
      'Desliza a la izquierda o derecha para cambiar de página, toca los números para navegar directamente';

  @override
  String get onboardingFavorites => 'Favoritos';

  @override
  String get onboardingFavoritesDescription =>
      'Añade páginas a favoritos para acceso rápido';

  @override
  String get onboardingRegions => 'Televideo Regional';

  @override
  String get onboardingRegionsDescription => 'Accede al Televideo de tu región';

  @override
  String get onboardingAutoRefresh => 'Actualización Automática';

  @override
  String get onboardingAutoRefreshDescription =>
      'Las subpáginas se actualizan automáticamente';

  @override
  String get onboardingPause => 'Pausar Actualización';

  @override
  String get onboardingPauseDescription =>
      'Toca un área vacía para pausar la actualización automática';

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
