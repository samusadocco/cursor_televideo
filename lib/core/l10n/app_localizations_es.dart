// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'No se puede cargar la imagen de la página.\nPor favor, inténtelo de nuevo en un momento.';

  @override
  String get pageNotAvailable => 'La página solicitada no está disponible';

  @override
  String get pageLoadError =>
      'Se produjo un error al cargar la página.\nVolver a la página 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'La página $pageNumber no está disponible para $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'La página $pageNumber no está disponible para $regionName.\nPrueba con otro número entre 100 y 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'No hay más páginas disponibles para $regionName';
  }

  @override
  String get noMorePages => 'No hay más páginas disponibles';

  @override
  String get invalidSubpageNumber => 'Número de subpágina no válido';

  @override
  String subpageError(int current, int total) {
    return 'Error al cargar la subpágina $current de $total';
  }

  @override
  String get swipePrevious => '← Anterior';

  @override
  String get swipeNext => 'Siguiente →';

  @override
  String get swipeNextUp => 'Siguiente ↑';

  @override
  String get swipePreviousDown => 'Anterior ↓';

  @override
  String get swipeRefresh => 'Actualizar ↻';

  @override
  String get pageAddedToFavorites => 'Página añadida a favoritos';

  @override
  String get pageRemovedFromFavorites => 'Página eliminada de favoritos';

  @override
  String get editDescription => 'Editar descripción';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Página $pageNumber - $regionName';
  }

  @override
  String get description => 'Descripción';

  @override
  String get enterCustomDescription =>
      'Introduzca una descripción personalizada';

  @override
  String get restoreHint =>
      'Consejo: mantenga pulsado el botón \"RESTAURAR\" para volver a la descripción predeterminada.';

  @override
  String get restore => 'RESTAURAR';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get searchHint => 'Buscar página...';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get settings => 'Ajustes';

  @override
  String get enterPageNumber => 'Introduzca el número de página';

  @override
  String pageNumberRange(int minPage) {
    return 'Número desde $minPage hasta 999';
  }

  @override
  String get ok => 'Aceptar';

  @override
  String get favoritesList => 'Lista de favoritos';

  @override
  String get confirmRemoval => 'Confirmar eliminación';

  @override
  String confirmRemoveFromFavorites(String description) {
    return '¿Realmente desea eliminar $description de favoritos?';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Cerrar';

  @override
  String get noFavorites => 'Sin favoritos';

  @override
  String get useFavoriteIcon =>
      'Use el icono ❤️ para añadir páginas a favoritos';

  @override
  String loadingPage(int pageNumber) {
    return 'Cargando página $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites => 'No hay página para añadir a favoritos';

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
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get networkError => 'Error de red';

  @override
  String get connectionRequired => 'Se requiere conexión';

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
  String get loadFirstFavorite => 'Cargar primer favorito al inicio';

  @override
  String get loadFirstFavoriteDescription =>
      'Si está habilitado, se cargará el primer favorito de la lista al iniciar la aplicación';

  @override
  String get cacheDuration =>
      'Duración de caché de imágenes de páginas Televideo (0 segundos para deshabilitar)';

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
      'Mostrar instrucciones cada vez que abres la aplicación';

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
      '¿Realmente desea restablecer los ajustes de privacidad? Se le pedirá consentimiento nuevamente la próxima vez que inicie la aplicación.';

  @override
  String get privacySettingsUnavailable =>
      'Los ajustes de privacidad no están disponibles en este momento';

  @override
  String get privacySettingsReset =>
      'Ajustes de privacidad restablecidos. Reinicie la aplicación para nuevo consentimiento.';

  @override
  String get version => 'Versión';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Bienvenido a TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'La aplicación para consultar RAI Televideo de forma rápida y sencilla';

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
  String get onboardingPageSelector => 'Selector de Página';

  @override
  String get onboardingPageSelectorDescription =>
      'Toca el número central para introducir directamente una página.\n\nIntroduce un número entre 100 y 999 para saltar a esa página.';

  @override
  String get onboardingSubpageNavigation => 'Navegación de Subpáginas';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Si la página tiene subpáginas, también verás el indicador:\n• 1/3 significa: primera subpágina de tres disponibles\n\nUsa las flechas centrales para navegar entre subpáginas:\n\n• Flecha arriba: ir a la siguiente subpágina\n• Flecha abajo: ir a la subpágina anterior\n\nLas flechas están activas solo cuando hay subpáginas disponibles.';

  @override
  String get onboardingSwipe => 'Navegación por Deslizamiento';

  @override
  String get onboardingSwipeDescription =>
      'Navega fácilmente entre páginas con los gestos mostrados arriba.';

  @override
  String get onboardingClickableNumbers => 'Números de Página Clicables';

  @override
  String get onboardingClickableNumbersDescription =>
      'Toca los números de página resaltados para navegar directamente a esa página\n\nLas páginas 100/1 del Televideo Nacional y 300/1 del Televideo Regional no son clicables';

  @override
  String get onboardingShortcuts => 'Menú de Accesos Directos';

  @override
  String get onboardingShortcutsDescription =>
      'Acceso rápido a las páginas más importantes de Televideo.\n\nUsa este menú para saltar directamente a:\n• Página 100: Índice nacional\n• Página 200: Noticias\n.....\nTambién puedes buscar páginas por título seleccionando la opción Buscar página';

  @override
  String get onboardingFavoritesList => 'Lista de Favoritos';

  @override
  String get onboardingFavoritesListDescription =>
      'Gestiona tus páginas favoritas:\n\n• Toca una página para abrirla\n• Desliza a la izquierda para eliminarla\n• Toca el lápiz para editar la descripción\n• Mantén pulsado para cambiar el orden\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personaliza la aplicación según tus preferencias:\n\n• Cargar primer favorito al inicio: decide con qué página de Televideo empezar\n• Tema: elige entre claro, oscuro o automático\n• Actualización automática: habilita la carga automática de subpáginas\n• Caché: gestiona la duración de la caché de páginas\n• Instrucciones: revisa este tutorial cuando quieras\n• Copia de seguridad de favoritos: guarda y restaura tus favoritos\n• Ajustes de privacidad y restablecimiento: gestiona o restablece tus elecciones de privacidad';

  @override
  String get dontShowAgain => 'No mostrar de nuevo';

  @override
  String get start => 'Comenzar';

  @override
  String get reset => 'Restablecer';

  @override
  String backToPage(int pageNumber) {
    return 'Volver a la página $pageNumber';
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
  String get channelSelection => 'Selección de canal';

  @override
  String get favoriteChannels => 'Canales favoritos';

  @override
  String get reorder => 'Reordenar';

  @override
  String get searchChannelOrCountry => 'Buscar canal o país...';

  @override
  String get showAllChannels => 'Mostrar todos los canales';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count canales disponibles de $countries países';
  }

  @override
  String get allChannels => 'Todos los canales';

  @override
  String get noFavoriteChannelsFound => 'No se encontraron canales favoritos';

  @override
  String get noChannelsFound => 'No se encontraron canales';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name añadido a favoritos';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name eliminado de favoritos';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regiones disponibles';
  }

  @override
  String get reorderFavorites => 'Reordenar favoritos';
}
