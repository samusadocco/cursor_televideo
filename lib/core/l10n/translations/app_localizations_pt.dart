// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TeleRetro Italia';

  @override
  String get settings => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma do sistema';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get autoRefresh => 'Atualização automática';

  @override
  String get favorites => 'Favoritos';

  @override
  String get search => 'Pesquisar';

  @override
  String get regions => 'Regiões';

  @override
  String get home => 'Início';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get searchHint => 'Digite o número da página';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get retry => 'Tentar novamente';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get pageNotFound => 'Página não encontrada';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get connectionRequired => 'Conexão necessária';

  @override
  String get refreshing => 'Atualizando...';

  @override
  String get lastUpdate => 'Última atualização';

  @override
  String get theme => 'Tema';

  @override
  String get systemTheme => 'Tema do sistema';

  @override
  String get lightTheme => 'Tema claro';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get selectTheme => 'Selecionar tema';

  @override
  String get loadFirstFavorite => 'Carregar primeiro favorito ao iniciar';

  @override
  String get loadFirstFavoriteDescription =>
      'Se ativado, o primeiro favorito será carregado ao iniciar o aplicativo';

  @override
  String get cacheDuration =>
      'Duração do cache das páginas Televideo (0 segundos para desativar)';

  @override
  String get seconds => 'segundos';

  @override
  String get autoRefreshDescription => 'Atualizar subpáginas automaticamente';

  @override
  String get refreshInterval => 'Intervalo de atualização';

  @override
  String get showOnboardingAtStartup => 'Mostrar instruções ao iniciar';

  @override
  String get showOnboardingAtStartupDescription =>
      'Mostrar as instruções cada vez que abrir o aplicativo';

  @override
  String get showInstructions => 'Mostrar instruções';

  @override
  String get showInstructionsDescription =>
      'Rever as instruções de uso do aplicativo';

  @override
  String get backupFavorites => 'Backup dos favoritos';

  @override
  String get backupFavoritesDescription => 'Salvar e restaurar seus favoritos';

  @override
  String get privacySettings => 'Configurações de privacidade';

  @override
  String get privacySettingsDescription =>
      'Modificar suas preferências de privacidade para anúncios';

  @override
  String get resetPrivacySettings => 'Redefinir configurações de privacidade';

  @override
  String get resetPrivacySettingsDescription =>
      'Redefinir completamente as configurações de privacidade';

  @override
  String get resetPrivacyConfirm =>
      'Deseja realmente redefinir as configurações de privacidade? Você precisará dar seu consentimento novamente na próxima inicialização do aplicativo.';

  @override
  String get privacySettingsUnavailable =>
      'As configurações de privacidade não estão disponíveis no momento';

  @override
  String get privacySettingsReset =>
      'Configurações de privacidade redefinidas. Reinicie o aplicativo para o novo consentimento.';

  @override
  String get version => 'Versão';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Bem-vindo ao TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'O aplicativo para consultar o Televideo RAI de forma fácil e rápida';

  @override
  String get onboardingNavigation => 'Navegação';

  @override
  String get onboardingNavigationDescription =>
      'Deslize para a esquerda ou direita para mudar de página, toque nos números para navegar diretamente';

  @override
  String get onboardingFavorites => 'Favoritos';

  @override
  String get onboardingFavoritesDescription =>
      'Adicione páginas aos favoritos para acesso rápido';

  @override
  String get onboardingRegions => 'Televideo Regional';

  @override
  String get onboardingRegionsDescription => 'Acesse o Televideo da sua região';

  @override
  String get onboardingAutoRefresh => 'Atualização Automática';

  @override
  String get onboardingAutoRefreshDescription =>
      'As subpáginas são atualizadas automaticamente';

  @override
  String get onboardingPause => 'Pausar Atualização';

  @override
  String get onboardingPauseDescription =>
      'Toque em uma área vazia para pausar a atualização automática';

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
