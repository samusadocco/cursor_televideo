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
  String get welcome => '¡Bienvenido!';

  @override
  String get welcomeSelectChannel => 'Seleccionar canal predeterminado';

  @override
  String page(int pageNumber) {
    return 'Página $pageNumber';
  }

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
  String get startupPageOption => 'Página de inicio';

  @override
  String get startupPageOptionLastPage =>
      'Última página vista (predeterminado)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Primer favorito (si está disponible)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Página de inicio del último canal';

  @override
  String get cacheDuration =>
      'Duración de caché de imágenes de páginas Teletexto (0 segundos para deshabilitar)';

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
  String get support => 'Soporte';

  @override
  String get supportDescription => 'Contáctenos para asistencia';

  @override
  String get supportTitle => '¡Estamos aquí para ayudarte!';

  @override
  String get supportSubtitle =>
      'Para cualquier pregunta o asistencia, no dudes en contactarnos';

  @override
  String get directContact => 'Contacto Directo';

  @override
  String get emailLabel => 'Email';

  @override
  String get websiteLabel => 'Sitio Web';

  @override
  String get responseTime => 'Tiempo de respuesta promedio: 24-48 horas';

  @override
  String get faq => 'Preguntas Frecuentes';

  @override
  String get faqGeolocation => '¿Cómo funciona la geolocalización?';

  @override
  String get faqGeolocationAnswer =>
      'La aplicación utiliza la ubicación de tu dispositivo para identificar automáticamente tu región y mostrarte noticias locales relevantes. Puedes desactivar esta función en los ajustes de la aplicación.';

  @override
  String get faqFavorites => '¿Cómo guardar una página en favoritos?';

  @override
  String get faqFavoritesAnswer =>
      'Mientras visualizas una página, toca el ícono de estrella para agregarla a favoritos. Puedes acceder a tus páginas favoritas desde el menú principal.';

  @override
  String get faqTheme => '¿Cómo cambiar el tema de la aplicación?';

  @override
  String get faqThemeAnswer =>
      'Ve a los ajustes de la aplicación y selecciona el tema deseado (claro/oscuro). La aplicación también admite la configuración automática basada en los ajustes del sistema.';

  @override
  String get faqOffline => '¿La aplicación funciona sin conexión?';

  @override
  String get faqOfflineAnswer =>
      'No, se requiere una conexión a Internet activa para acceder a las páginas de Teletexto en tiempo real.';

  @override
  String get faqReportProblem => '¿Cómo reportar un problema?';

  @override
  String get faqReportProblemAnswer =>
      'Envía un email detallado a samuele@codebysam.it describiendo el problema encontrado.';

  @override
  String get reportBugTitle => 'Reportar un problema';

  @override
  String get reportBugInstructions =>
      'Al reportar un problema, incluye si es posible:';

  @override
  String get reportBugItems =>
      'Versión de la aplicación\nModelo del dispositivo\nSistema operativo\nCaptura de pantalla del problema';

  @override
  String get developedBy => 'Desarrollado por CodeBySam';

  @override
  String get errorOpeningLink => 'No se puede abrir el enlace';

  @override
  String get errorOpeningEmail => 'No se puede abrir el email';

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
  String get onboardingWelcome => 'Bienvenido a Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'La aplicación para acceder a todos los canales de teletexto en Europa';

  @override
  String get onboardingDefaultChannel => 'Seleccionar Canal Predeterminado';

  @override
  String get onboardingDefaultChannelDescription =>
      'Al iniciar la aplicación, se te pedirá que selecciones tu canal preferido entre todos los canales disponibles.\n\nPuedes cambiar el canal predeterminado en cualquier momento desde el menú Ajustes.';

  @override
  String get onboardingNavigation => 'Navegación';

  @override
  String get onboardingNavigationDescription =>
      'Desliza a la izquierda o derecha para cambiar de página, toca los números para navegar directamente';

  @override
  String get onboardingFavorites => 'Favoritos';

  @override
  String get onboardingFavoritesDescription =>
      'Guarda las páginas que visitas más a menudo:\n\n• Toca el icono indicado para añadir la página actual\n• Toca de nuevo para quitarla de favoritos\n• El icono se vuelve rojo cuando la página está en favoritos\n\nPuedes guardar tanto páginas nacionales como regionales.';

  @override
  String get onboardingRegions => 'Canales de Toda Europa';

  @override
  String get onboardingRegionsDescription =>
      'Selecciona y organiza tus canales favoritos de toda Europa.\n\nBusca por nombre de canal o nombre de país.\n\n¡Puedes acceder al teletexto de Italia, Alemania, Austria, Suiza y muchos otros países europeos!';

  @override
  String get onboardingAutoRefresh => 'Actualización Automática';

  @override
  String get onboardingAutoRefreshDescription =>
      'Cuando la actualización automática está activa, el círculo alrededor del número de página se llena progresivamente:\n\nPuedes cambiar el tiempo de actualización en la configuración\n\nEl indicador solo es visible cuando hay subpáginas disponibles y la actualización automática está activa.';

  @override
  String get onboardingPause => 'Pausar Actualización';

  @override
  String get onboardingPauseDescription =>
      'Puedes pausar la actualización automática de las subpáginas:\n\n• Toca en cualquier lugar de la página donde no haya números clicables\n• Verás aparecer el icono ⏸️ para indicar que la actualización está en pausa\n• Toca de nuevo para reanudar la actualización (icono ▶️)\n\nEsta función es útil cuando quieres leer una subpágina con calma sin que cambie automáticamente.';

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
      'Toca los números de página resaltados para navegar directamente a esa página\n\n';

  @override
  String get onboardingShortcuts => 'Menú de Accesos Directos';

  @override
  String get onboardingShortcutsDescription =>
      'Acceso rápido a las páginas más importantes de Teletexto.\n\nUsa este menú para saltar directamente a:\n• Página 100: Índice nacional\n• Página 200: Noticias\n.....\nTambién puedes buscar páginas por título seleccionando la opción Buscar página';

  @override
  String get onboardingFavoritesList => 'Lista de Favoritos';

  @override
  String get onboardingFavoritesListDescription =>
      'Gestiona tus páginas favoritas:\n\n• Toca una página para abrirla\n• Desliza a la izquierda para eliminarla\n• Toca el lápiz para editar la descripción\n• Mantén pulsado para cambiar el orden\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personaliza la aplicación según tus preferencias:\n\n• Cargar primer favorito al inicio: decide con qué página de Teletexto empezar\n• Tema: elige entre claro, oscuro o automático\n• Actualización automática: habilita la carga automática de subpáginas\n• Caché: gestiona la duración de la caché de páginas\n• Instrucciones: revisa este tutorial cuando quieras\n• Copia de seguridad de favoritos: guarda y restaura tus favoritos\n• Ajustes de privacidad y restablecimiento: gestiona o restablece tus elecciones de privacidad';

  @override
  String get dontShowAgain => 'No mostrar de nuevo';

  @override
  String get start => 'Comenzar';

  @override
  String get reset => 'Restablecer';

  @override
  String get resetInitialChannel => 'Restablecer canal inicial';

  @override
  String get resetInitialChannelDescription =>
      'Mostrar el diálogo de selección de canal nuevamente en el próximo inicio';

  @override
  String get resetCompleted => 'Restablecimiento completado';

  @override
  String get resetInitialChannelMessage =>
      'El canal inicial se ha restablecido.\n\nEn el próximo inicio de la aplicación se le pedirá que seleccione su canal predeterminado nuevamente.\n\nReiniciando la aplicación ahora...';

  @override
  String get selectYourChannel =>
      'Seleccione su canal de Teletexto predeterminado.\nPuede cambiarlo en cualquier momento.';

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

  @override
  String get countryIT => 'Italia';

  @override
  String get countryDE => 'Alemania';

  @override
  String get countryAT => 'Austria';

  @override
  String get countryCH => 'Suiza';

  @override
  String get countryES => 'España';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Países Bajos';

  @override
  String get countryPL => 'Polonia';

  @override
  String get countrySE => 'Suecia';

  @override
  String get countryFI => 'Finlandia';

  @override
  String get countryDK => 'Dinamarca';

  @override
  String get countryCZ => 'República Checa';

  @override
  String get countryHR => 'Croacia';

  @override
  String get countryBA => 'Bosnia y Herzegovina';

  @override
  String get countryHU => 'Hungría';

  @override
  String get countryIS => 'Islandia';

  @override
  String get countrySI => 'Eslovenia';

  @override
  String get countryUA => 'Ucrania';
}
