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
  String get welcome => 'Bem-vindo!';

  @override
  String get welcomeSelectChannel => 'Selecionar canal padrão';

  @override
  String page(int pageNumber) {
    return 'Página $pageNumber';
  }

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
  String get channelCheckNoConnectivity =>
      'No connection available.\nMake sure you\'re not in airplane mode and that Wi-Fi or mobile data is on.';

  @override
  String get channelCheckNoInternet =>
      'Unable to reach the internet.\nCheck your network connection and try again.';

  @override
  String get channelCheckDnsError =>
      'Unable to resolve network addresses.\nCheck your connection or try a different network.';

  @override
  String get channelCheckChannelError =>
      'The channel is having connection issues.\nThe broadcaster\'s server may be temporarily unreachable. Please try again in a few minutes.';

  @override
  String get refreshing => 'Atualizando...';

  @override
  String get lastUpdate => 'Última atualização';

  @override
  String get updateAvailable => 'Atualização disponível';

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
  String get startupPageOption => 'Página de inicialização';

  @override
  String get startupPageOptionLastPage => 'Última página visualizada (padrão)';

  @override
  String get startupPageOptionFirstFavorite =>
      'Primeiro favorito (se disponível)';

  @override
  String get startupPageOptionChannelHomePage =>
      'Página inicial do último canal';

  @override
  String get cacheDuration =>
      'Duração do cache de imagens das páginas Teletexto (0 segundos para desativar)';

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
  String get support => 'Suporte';

  @override
  String get supportDescription => 'Contacte-nos para assistência';

  @override
  String get supportTitle => 'Estamos aqui para ajudar!';

  @override
  String get supportSubtitle =>
      'Para qualquer dúvida ou assistência, não hesite em nos contactar';

  @override
  String get directContact => 'Contacto Direto';

  @override
  String get emailLabel => 'Email';

  @override
  String get websiteLabel => 'Website';

  @override
  String get responseTime => 'Tempo médio de resposta: 24-48 horas';

  @override
  String get faq => 'Perguntas Frequentes';

  @override
  String get faqGeolocation => 'Como funciona a geolocalização?';

  @override
  String get faqGeolocationAnswer =>
      'A aplicação utiliza a localização do seu dispositivo para identificar automaticamente a sua região e mostrar-lhe notícias locais relevantes. Pode desativar esta função nas definições da aplicação.';

  @override
  String get faqFavorites => 'Como guardar uma página nos favoritos?';

  @override
  String get faqFavoritesAnswer =>
      'Enquanto visualiza uma página, toque no ícone da estrela para a adicionar aos favoritos. Pode aceder às suas páginas favoritas a partir do menu principal.';

  @override
  String get faqTheme => 'Como alterar o tema da aplicação?';

  @override
  String get faqThemeAnswer =>
      'Vá às definições da aplicação e selecione o tema desejado (claro/escuro). A aplicação também suporta a configuração automática baseada nas definições do sistema.';

  @override
  String get faqOffline => 'A aplicação funciona offline?';

  @override
  String get faqOfflineAnswer =>
      'Não, é necessária uma ligação à Internet ativa para aceder às páginas de Teletexto em tempo real.';

  @override
  String get faqReportProblem => 'Como reportar um problema?';

  @override
  String get faqReportProblemAnswer =>
      'Envie um email detalhado para samuele@codebysam.it descrevendo o problema encontrado.';

  @override
  String get reportBugTitle => 'Reportar um problema';

  @override
  String get reportBugInstructions =>
      'Ao reportar um problema, inclua se possível:';

  @override
  String get reportBugItems =>
      'Versão da aplicação\nModelo do dispositivo\nSistema operativo\nCaptura de ecrã do problema';

  @override
  String get developedBy => 'Desenvolvido por CodeBySam';

  @override
  String get errorOpeningLink => 'Não é possível abrir o link';

  @override
  String get errorOpeningEmail => 'Não é possível abrir o email';

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
  String get onboardingWelcome => 'Bem-vindo ao Teletext Europe';

  @override
  String get onboardingWelcomeDescription =>
      'A aplicação para aceder a todos os canais de teletexto na Europa';

  @override
  String get onboardingDefaultChannel => 'Selecionar Canal Padrão';

  @override
  String get onboardingDefaultChannelDescription =>
      'Ao iniciar a aplicação, ser-lhe-á pedido que selecione o seu canal preferido entre todos os canais disponíveis.\n\nPode alterar o canal padrão a qualquer momento no menu Definições.';

  @override
  String get onboardingNavigation => 'Navegação';

  @override
  String get onboardingNavigationDescription =>
      'Deslize para a esquerda ou direita para mudar de página, toque nos números para navegar diretamente';

  @override
  String get onboardingFavorites => 'Favoritos';

  @override
  String get onboardingFavoritesDescription =>
      'Guarde as páginas que visita mais frequentemente:\n\n• Toque no ícone indicado para adicionar a página atual\n• Toque novamente para removê-la dos favoritos\n• O ícone fica vermelho quando a página está nos favoritos\n\nPode guardar páginas nacionais e regionais.';

  @override
  String get onboardingRegions => 'Canais de Toda a Europa';

  @override
  String get onboardingRegionsDescription =>
      'Selecione e organize os seus canais favoritos de toda a Europa.\n\nPesquise por nome de canal ou nome de país.\n\nPode aceder ao teletexto de Itália, Alemanha, Áustria, Suíça e muitos outros países europeus!';

  @override
  String get onboardingAutoRefresh => 'Atualização Automática';

  @override
  String get onboardingAutoRefreshDescription =>
      'Quando a atualização automática está ativa, o círculo ao redor do número da página preenche-se progressivamente:\n\nPode alterar o tempo de atualização nas definições\n\nO indicador só é visível quando há subpáginas disponíveis e a atualização automática está ativa.';

  @override
  String get onboardingPause => 'Pausar Atualização';

  @override
  String get onboardingPauseDescription =>
      'Pode pausar a atualização automática das subpáginas:\n\n• Toque em qualquer lugar da página onde não há números clicáveis\n• Verá aparecer o ícone ⏸️ para indicar que a atualização está pausada\n• Toque novamente para retomar a atualização (ícone ▶️)\n\nEsta função é útil quando quer ler uma subpágina com calma sem que mude automaticamente.';

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
      'Toque nos números de página destacados para navegar diretamente para essa página\n\n';

  @override
  String get onboardingShortcuts => 'Menu de Atalhos';

  @override
  String get onboardingShortcutsDescription =>
      'Acesso rápido às páginas mais importantes do Teletexto.\n\nUse este menu para pular diretamente para:\n• Página 100: Índice nacional\n• Página 200: Notícias\n.....\nVocê também pode pesquisar páginas por título selecionando a opção Pesquisar página';

  @override
  String get onboardingFavoritesList => 'Lista de Favoritos';

  @override
  String get onboardingFavoritesListDescription =>
      'Gerencie suas páginas favoritas:\n\n• Toque em uma página para abri-la\n• Deslize para a esquerda para removê-la\n• Toque no lápis para editar a descrição\n• Pressione e segure para alterar a ordem\n\n';

  @override
  String get onboardingSettingsDescription =>
      'Personalize o aplicativo de acordo com suas preferências:\n\n• Carregar primeiro favorito na inicialização: decida com qual página do Teletexto começar\n• Tema: escolha entre claro, escuro ou automático\n• Atualização automática: ative o carregamento automático de subpáginas\n• Cache: gerencie a duração do cache das páginas\n• Instruções: revise este tutorial quando quiser\n• Backup dos favoritos: salve e restaure seus favoritos\n• Configurações de privacidade e redefinição: gerencie ou redefina suas escolhas de privacidade';

  @override
  String get dontShowAgain => 'Não mostrar novamente';

  @override
  String get start => 'Começar';

  @override
  String get reset => 'Redefinir';

  @override
  String get resetInitialChannel => 'Redefinir canal inicial';

  @override
  String get resetInitialChannelDescription =>
      'Mostrar novamente o diálogo de seleção de canal na próxima inicialização';

  @override
  String get resetCompleted => 'Redefinição concluída';

  @override
  String get resetInitialChannelMessage =>
      'O canal inicial foi redefinido.\n\nNa próxima inicialização do aplicativo, será solicitado que você selecione seu canal padrão novamente.\n\nReiniciando o aplicativo agora...';

  @override
  String get selectYourChannel =>
      'Selecione o seu canal de Teletexto padrão.\nVocê pode alterá-lo a qualquer momento.';

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

  @override
  String get countryIT => 'Itália';

  @override
  String get countryDE => 'Alemanha';

  @override
  String get countryAT => 'Áustria';

  @override
  String get countryCH => 'Suíça';

  @override
  String get countryES => 'Espanha';

  @override
  String get countryPT => 'Portugal';

  @override
  String get countryNL => 'Países Baixos';

  @override
  String get countryPL => 'Polónia';

  @override
  String get countrySE => 'Suécia';

  @override
  String get countryFI => 'Finlândia';

  @override
  String get countryDK => 'Dinamarca';

  @override
  String get countryCZ => 'República Checa';

  @override
  String get countryHR => 'Croácia';

  @override
  String get countryBA => 'Bósnia e Herzegovina';

  @override
  String get countryHU => 'Hungria';

  @override
  String get countryIS => 'Islândia';

  @override
  String get countrySI => 'Eslovénia';

  @override
  String get countryUA => 'Ucrânia';

  @override
  String get premiumTitle => 'Teletext Premium';

  @override
  String get premiumFeatures => 'Recursos Premium';

  @override
  String get premiumSubtitle => 'Melhore sua experiência com Teletext Europe';

  @override
  String get premiumNoAds => 'Sem publicidade';

  @override
  String get premiumNoAdsDescription =>
      'Remova todos os banners publicitários e anúncios intersticiais';

  @override
  String get premiumFasterExperience => 'Experiência mais fluida';

  @override
  String get premiumFasterExperienceDescription =>
      'Navegue sem interrupções publicitárias';

  @override
  String get premiumSupportDevelopment => 'Apoiar o desenvolvimento';

  @override
  String get premiumSupportDevelopmentDescription =>
      'Ajude a manter a aplicação atualizada com novos canais e funcionalidades';

  @override
  String get premiumActivated => 'Premium ativado';

  @override
  String get premiumThankYou => 'Obrigado pelo seu apoio!';

  @override
  String get premiumOneTimePurchase => 'Assinatura trimestral';

  @override
  String get premiumLifetime => 'Renovação automática a cada 3 meses';

  @override
  String get purchasePremium => 'Assinar agora';

  @override
  String get restorePurchases => 'Restaurar assinatura';

  @override
  String get premiumProductNotAvailable =>
      'Assinatura Premium não disponível no momento';

  @override
  String get premiumPurchaseError =>
      'Erro durante a assinatura. Tente novamente.';

  @override
  String get premiumRestoreSuccess => 'Assinatura restaurada com sucesso!';

  @override
  String get premiumRestoreNoPurchases => 'Nenhuma assinatura ativa encontrada';

  @override
  String get premiumRestoreError => 'Erro ao restaurar a assinatura';

  @override
  String get premiumLegalNote =>
      'Assinatura mensal ou trimestral com renovação automática. Pode cancelar a qualquer momento nas configurações da sua conta Apple/Google. O pagamento será cobrado na confirmação. A assinatura renova-se automaticamente (mensalmente ou a cada 3 meses consoante o plano selecionado).';

  @override
  String get goPremium => 'Tornar-se Premium';

  @override
  String get premiumChoosePlan => 'Escolha o seu plano';

  @override
  String get premiumMonthly => 'Mensal';

  @override
  String get premiumQuarterly => 'Trimestral';

  @override
  String get premiumPerMonth => 'por mês';

  @override
  String get premiumEvery3Months => 'a cada 3 meses';

  @override
  String premiumSavePercent(String percent) {
    return 'Poupe $percent';
  }

  @override
  String get premiumMonthlyPlan => 'Plano mensal';

  @override
  String get premiumQuarterlyPlan => 'Plano trimestral';

  @override
  String get premiumSubscriptionInfo => 'Informações de subscrição';

  @override
  String get premiumPrivacyPolicy => 'Política de privacidade';

  @override
  String get premiumTermsOfUse => 'Termos de utilização (EULA)';

  @override
  String get premiumLoadingSubscriptions => 'Loading subscription options...';

  @override
  String get premiumLoadErrorRetry =>
      'Unable to load subscription options. Please try again.';
}
