// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TeleRetrò Italia';

  @override
  String get pageUnavailable =>
      'Não é possível carregar a imagem da página.\nPor favor, tente novamente em um momento.';

  @override
  String get pageNotAvailable => 'A página solicitada não está disponível';

  @override
  String get pageLoadError =>
      'Ocorreu um erro ao carregar a página.\nVoltar à página 100';

  @override
  String pageNotAvailableForRegion(int pageNumber, String regionName) {
    return 'A página $pageNumber não está disponível para $regionName';
  }

  @override
  String pageNotAvailableForRegionWithHint(int pageNumber, String regionName) {
    return 'A página $pageNumber não está disponível para $regionName.\nTente outro número entre 100 e 999.';
  }

  @override
  String noMorePagesForRegion(String regionName) {
    return 'Não há mais páginas disponíveis para $regionName';
  }

  @override
  String get noMorePages => 'Não há mais páginas disponíveis';

  @override
  String get invalidSubpageNumber => 'Número de subpágina inválido';

  @override
  String subpageError(int current, int total) {
    return 'Erro ao carregar a subpágina $current de $total';
  }

  @override
  String get swipePrevious => '← Anterior';

  @override
  String get swipeNext => 'Próxima →';

  @override
  String get swipeNextUp => 'Próxima ↑';

  @override
  String get swipePreviousDown => 'Anterior ↓';

  @override
  String get swipeRefresh => 'Atualizar ↻';

  @override
  String get pageAddedToFavorites => 'Página adicionada aos favoritos';

  @override
  String get pageRemovedFromFavorites => 'Página removida dos favoritos';

  @override
  String get editDescription => 'Editar descrição';

  @override
  String pageAndRegion(int pageNumber, String regionName) {
    return 'Página $pageNumber - $regionName';
  }

  @override
  String get description => 'Descrição';

  @override
  String get enterCustomDescription => 'Digite uma descrição personalizada';

  @override
  String get restoreHint =>
      'Dica: pressione e segure o botão \"RESTAURAR\" para voltar à descrição padrão.';

  @override
  String get restore => 'RESTAURAR';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get searchHint => 'Pesquisar página...';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get settings => 'Configurações';

  @override
  String get enterPageNumber => 'Digite o número da página';

  @override
  String pageNumberRange(int minPage) {
    return 'Número de $minPage até 999';
  }

  @override
  String get ok => 'OK';

  @override
  String get favoritesList => 'Lista de favoritos';

  @override
  String get confirmRemoval => 'Confirmar remoção';

  @override
  String confirmRemoveFromFavorites(String description) {
    return 'Deseja realmente remover $description dos favoritos?';
  }

  @override
  String get remove => 'Remover';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Fechar';

  @override
  String get noFavorites => 'Sem favoritos';

  @override
  String get useFavoriteIcon =>
      'Use o ícone ❤️ para adicionar páginas aos favoritos';

  @override
  String loadingPage(int pageNumber) {
    return 'Carregando página $pageNumber...';
  }

  @override
  String get noPageToAddToFavorites =>
      'Nenhuma página para adicionar aos favoritos';

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
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get retry => 'Tentar novamente';

  @override
  String get next => 'Próxima';

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
  String get loadFirstFavorite => 'Carregar primeiro favorito na inicialização';

  @override
  String get loadFirstFavoriteDescription =>
      'Se ativado, o primeiro favorito da lista será carregado ao iniciar o aplicativo';

  @override
  String get cacheDuration =>
      'Duração do cache de imagens das páginas Televideo (0 segundos para desativar)';

  @override
  String get seconds => 'segundos';

  @override
  String get autoRefreshDescription => 'Atualizar subpáginas automaticamente';

  @override
  String get refreshInterval => 'Intervalo de atualização';

  @override
  String get showOnboardingAtStartup => 'Mostrar instruções na inicialização';

  @override
  String get showOnboardingAtStartupDescription =>
      'Mostrar instruções sempre que você abrir o aplicativo';

  @override
  String get showInstructions => 'Mostrar instruções';

  @override
  String get showInstructionsDescription =>
      'Revisar as instruções de uso do aplicativo';

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
      'Deseja realmente redefinir as configurações de privacidade? Você será solicitado a dar consentimento novamente na próxima vez que iniciar o aplicativo.';

  @override
  String get privacySettingsUnavailable =>
      'As configurações de privacidade não estão disponíveis no momento';

  @override
  String get privacySettingsReset =>
      'Configurações de privacidade redefinidas. Reinicie o aplicativo para novo consentimento.';

  @override
  String get version => 'Versão';

  @override
  String get build => 'build';

  @override
  String get onboardingWelcome => 'Bem-vindo ao TeleRetrò Italia';

  @override
  String get onboardingWelcomeDescription =>
      'O aplicativo para consultar o RAI Televideo de forma rápida e fácil';

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
  String get onboardingPageSelector => 'Seletor de Página';

  @override
  String get onboardingPageSelectorDescription =>
      'Toque no número central para inserir diretamente uma página.\n\nDigite um número entre 100 e 999 para pular para essa página.';

  @override
  String get onboardingSubpageNavigation => 'Navegação de Subpáginas';

  @override
  String get onboardingSubpageNavigationDescription =>
      'Se a página tiver subpáginas, você também verá o indicador:\n• 1/3 significa: primeira subpágina de três disponíveis\n\nUse as setas centrais para navegar entre subpáginas:\n\n• Seta para cima: ir para a próxima subpágina\n• Seta para baixo: ir para a subpágina anterior\n\nAs setas estão ativas apenas quando há subpáginas disponíveis.';

  @override
  String get onboardingSwipe => 'Navegação por Deslize';

  @override
  String get onboardingSwipeDescription =>
      'Navegue facilmente entre as páginas com os gestos mostrados acima.';

  @override
  String get onboardingClickableNumbers => 'Números de Página Clicáveis';

  @override
  String get onboardingClickableNumbersDescription =>
      'Toque nos números de página destacados para navegar diretamente para essa página\n\nAs páginas 100/1 do Televideo Nacional e 300/1 do Televideo Regional não são clicáveis';

  @override
  String get onboardingShortcuts => 'Menu de Atalhos';

  @override
  String get onboardingShortcutsDescription =>
      'Acesso rápido às páginas mais importantes do Televideo.\n\nUse este menu para pular diretamente para:\n• Página 100: Índice nacional\n• Página 200: Notícias\n.....\nVocê também pode pesquisar páginas por título selecionando a opção Pesquisar página';

  @override
  String get onboardingFavoritesList => 'Lista de Favoritos';

  @override
  String get onboardingFavoritesListDescription =>
      'Gerencie suas páginas favoritas:\n\n• Toque em uma página para abri-la\n• Deslize para a esquerda para removê-la\n• Toque no lápis para editar a descrição\n• Pressione e segure para alterar a ordem\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personalize o aplicativo de acordo com suas preferências:\n\n• Carregar primeiro favorito na inicialização: decida com qual página do Televideo começar\n• Tema: escolha entre claro, escuro ou automático\n• Atualização automática: ative o carregamento automático de subpáginas\n• Cache: gerencie a duração do cache das páginas\n• Instruções: revise este tutorial quando quiser\n• Backup dos favoritos: salve e restaure seus favoritos\n• Configurações de privacidade e redefinição: gerencie ou redefina suas escolhas de privacidade';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get start => 'Começar';

  @override
  String get reset => 'Redefinir';

  @override
  String backToPage(int pageNumber) {
    return 'Voltar à página $pageNumber';
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
  String get channelSelection => 'Seleção de canal';

  @override
  String get favoriteChannels => 'Canais favoritos';

  @override
  String get reorder => 'Reordenar';

  @override
  String get searchChannelOrCountry => 'Pesquisar canal ou país...';

  @override
  String get showAllChannels => 'Mostrar todos os canais';

  @override
  String channelsAvailableFromCountries(int count, int countries) {
    return '$count canais disponíveis de $countries países';
  }

  @override
  String get allChannels => 'Todos os canais';

  @override
  String get noFavoriteChannelsFound => 'Nenhum canal favorito encontrado';

  @override
  String get noChannelsFound => 'Nenhum canal encontrado';

  @override
  String addedToFavorites(String emoji, String name) {
    return '$emoji $name adicionado aos favoritos';
  }

  @override
  String removedFromFavorites(String emoji, String name) {
    return '$emoji $name removido dos favoritos';
  }

  @override
  String regionsAvailable(int count) {
    return '$count regiões disponíveis';
  }

  @override
  String get reorderFavorites => 'Reordenar favoritos';
}
