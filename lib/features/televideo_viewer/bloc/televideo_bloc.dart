import 'package:bloc/bloc.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/providers/provider_factory.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelevideoBloc extends Bloc<TelevideoEvent, TelevideoState> {
  final TelevideoRepository _repository;
  final AdService _adService = AdService();
  RegionBloc? _regionBloc;
  late final int _minPage; // Minima pagina disponibile (100 o 101)
  bool _isPage100Available = true; // Inizialmente assumiamo che sia disponibile
  Region? _currentRegion;
  int _currentPage = 100;
  TelevideoEvent? _lastEvent;
  
  // Tracciamento ultima pagina caricata con successo
  int? _lastSuccessfulPage;
  int? _lastSuccessfulSubPage;
  Region? _lastSuccessfulRegion;

  /// L'ultimo evento ricevuto dal bloc
  TelevideoEvent? get lastEvent => _lastEvent;

  /// La minima pagina disponibile (100 o 101)
  int get minPage => _minPage;

  /// Indica se la pagina 100 è disponibile
  bool get isPage100Available => _isPage100Available;
  
  /// L'ultima pagina caricata con successo
  int? get lastSuccessfulPage => _lastSuccessfulPage;
  
  /// L'ultima sottopagina caricata con successo
  int? get lastSuccessfulSubPage => _lastSuccessfulSubPage;
  
  /// L'ultima regione caricata con successo (null se modalità nazionale)
  Region? get lastSuccessfulRegion => _lastSuccessfulRegion;

  /// Imposta il RegionBloc da utilizzare per la sincronizzazione dello stato
  void setRegionBloc(RegionBloc regionBloc) {
    _regionBloc = regionBloc;
  }

  /// Salva l'ultima pagina caricata con successo
  void _updateLastSuccessfulPage(int pageNumber, int subPage, {Region? region}) {
    _lastSuccessfulPage = pageNumber;
    _lastSuccessfulSubPage = subPage;
    _lastSuccessfulRegion = region;
    print('[TelevideoBloc] Updated last successful page: $pageNumber/$subPage, region: ${region?.code ?? "national"}');
  }

  /// Salva lo stato corrente nelle preferenze
  Future<void> _saveCurrentState(TelevideoPage page, int currentSubPage, TeletextChannel? channel) async {
    try {
      await AppSettings.saveLastState(
        pageNumber: page.pageNumber,
        subPage: currentSubPage,
        isNationalMode: _currentRegion == null,
        regionCode: _currentRegion?.code,
        channelId: channel?.id,
      );
      print('[TelevideoBloc] State saved - page: ${page.pageNumber}, subPage: $currentSubPage, channel: ${channel?.id}, region: ${_currentRegion?.code}');
    } catch (e) {
      print('[TelevideoBloc] Error saving state: $e');
    }
  }

  Future<TelevideoPage> _loadPageWithContext(int pageNumber, {
    bool isRegional = false,
    Region? region,
    int subPage = 1,
    bool updateContext = true,
    bool forceRefresh = false
  }) async {
      final page = isRegional && region != null
        ? await _repository.getRegionalPage(region.code, pageNumber: pageNumber, subPage: subPage, forceRefresh: forceRefresh)
        : await _repository.getNationalPage(pageNumber, subPage: subPage, forceRefresh: forceRefresh);
    
    if (updateContext) {
      final currentChannel = state.selectedChannel;
      _updateAdContext(pageNumber, isRegional: isRegional, region: region, channel: currentChannel);
      _adService.incrementPageView(isSubPage: subPage > 1);
    }
    return page;
  }

  Future<TelevideoPage?> _tryLoadPage(int pageNumber, {bool isRegional = false, bool forceRefresh = false}) async {
    try {
      final currentChannel = state.selectedChannel;
      
      // Se il canale corrente è RAI o null, usa il repository normale
      if (currentChannel == null || currentChannel.id == 'rai_nazionale' || currentChannel.id.startsWith('rai_')) {
        return await _loadPageWithContext(
          pageNumber,
          isRegional: isRegional,
          region: _currentRegion,
          updateContext: true,
          forceRefresh: forceRefresh
        );
      } else {
        // Per altri canali, usa il provider specifico
        final provider = TeletextProviderFactory.getProvider(currentChannel);
        final page = await provider.fetchNationalPage(pageNumber);
        
        // Incrementa il conteggio per gli interstitial
        _adService.incrementPageView(isSubPage: false);
        
        return page;
      }
    } catch (e) {
      return null;
    }
  }

  void _updateAdContext(int pageNumber, {bool isRegional = false, Region? region, TeletextChannel? channel}) {
    print('[TelevideoBloc] _updateAdContext called - page: $pageNumber, channel: ${channel?.id}, country: ${channel?.countryCode}');
    
    // Ottieni la descrizione della pagina per TUTTI i canali (non solo RAI)
    String? description;
    if (channel != null) {
      final descriptions = PageDescriptionsService().getDescriptionsForChannel(
        channelId: channel.id,
        isRegional: isRegional,
      );
      description = descriptions[pageNumber];
      print('[TelevideoBloc] Page description for channel ${channel.id}: $description');
    }

    print('[TelevideoBloc] Calling setContext with - channelId: ${channel?.id}, countryCode: ${channel?.countryCode}, language: ${channel?.countryCode.toLowerCase()}');
    _adService.setContext(
      pageNumber: pageNumber.toString(),
      section: description,
      isRegional: isRegional,
      region: region,
      channelId: channel?.id,
      countryCode: channel?.countryCode,
      language: channel?.countryCode.toLowerCase(), // Usa il country code come lingua base
    );
  }

  TelevideoBloc({
    required TelevideoRepository repository,
    RegionBloc? regionBloc,
  })  : _repository = repository,
        _regionBloc = regionBloc,
        super(const TelevideoState.initial()) {
    on<TelevideoEvent>((event, emit) async {
      _lastEvent = event;
      print('[TelevideoBloc] Received event: $event'); // Debug print
      await event.when(
        loadNationalPage: (pageNumber) => _onLoadNationalPage(pageNumber, emit),
        loadRegionalPage: (region, pageNumber) => _onLoadRegionalPage(region, pageNumber, emit),
        nextPage: (currentPage) => _onNextPage(currentPage, emit),
        previousPage: (currentPage) => _onPreviousPage(currentPage, emit),
        nextSubPage: () => _onNextSubPage(emit),
        previousSubPage: () => _onPreviousSubPage(emit),
        startLoading: () => _onStartLoading(emit),
        toggleAutoRefreshPause: () => _onToggleAutoRefreshPause(emit),
        changeChannel: (channel) => _onChangeChannel(channel, emit),
      );
    });

    // Verifica la disponibilità della pagina 100 all'avvio
    _initializeBloc();
  }

  Future<void> _initializeBloc() async {
    await _checkPage100Availability();
    
    // Gestisci l'avvio in base alla preferenza dell'utente
    switch (AppSettings.startupPageOption) {
      case StartupPageOption.lastPage:
        // Carica l'ultima pagina visualizzata
        if (AppSettings.lastPageNumber != null) {
          print('[TelevideoBloc] 📄 Caricamento ultima pagina visualizzata: ${AppSettings.lastPageNumber}, sottopagina: ${AppSettings.lastSubPage}');
          
          final lastPage = AppSettings.lastPageNumber!;
          final isNationalMode = AppSettings.lastIsNationalMode ?? true;
          
          if (!isNationalMode && AppSettings.lastRegionCode != null) {
            // Carica pagina regionale
            final region = Region.fromCode(AppSettings.lastRegionCode!);
            add(TelevideoEvent.loadRegionalPage(region, lastPage));
          } else {
            // Carica pagina nazionale
            add(TelevideoEvent.loadNationalPage(lastPage));
          }
          return;
        }
        break;
        
      case StartupPageOption.firstFavorite:
        // Carica il primo preferito, se disponibile
        final favorites = FavoritesService().getFavorites();
        if (favorites.isNotEmpty) {
          final firstFavorite = favorites.first;
          print('[TelevideoBloc] ⭐ Caricamento primo preferito: pagina ${firstFavorite.pageNumber}');
          
          // Se ha un channelId, cambia prima il canale
          if (firstFavorite.channelId != null) {
            final channel = TeletextChannels.getChannelById(firstFavorite.channelId!);
            if (channel != null) {
              // Cambia il canale e carica la pagina del preferito
              add(TelevideoEvent.changeChannel(channel));
              // Il cambio canale caricherà automaticamente la pagina 100 del canale
              // Quindi dobbiamo aspettare e poi caricare la pagina desiderata
              Future.delayed(const Duration(milliseconds: 300), () {
                add(TelevideoEvent.loadNationalPage(firstFavorite.pageNumber));
              });
              return;
            }
          }
          
          // Se è una pagina RAI regionale
          if (firstFavorite.regionCode != null) {
            final region = Region.fromCode(firstFavorite.regionCode!);
            add(TelevideoEvent.loadRegionalPage(region, firstFavorite.pageNumber));
            return;
          }
          
          // Se è una pagina RAI nazionale
          add(TelevideoEvent.loadNationalPage(firstFavorite.pageNumber));
          return;
        }
        
        // Se non ci sono preferiti, fallback all'ultima pagina visualizzata
        print('[TelevideoBloc] ⚠️ Nessun preferito trovato, fallback all\'ultima pagina');
        if (AppSettings.lastPageNumber != null) {
          final lastPage = AppSettings.lastPageNumber!;
          final isNationalMode = AppSettings.lastIsNationalMode ?? true;
          
          if (!isNationalMode && AppSettings.lastRegionCode != null) {
            final region = Region.fromCode(AppSettings.lastRegionCode!);
            add(TelevideoEvent.loadRegionalPage(region, lastPage));
          } else {
            add(TelevideoEvent.loadNationalPage(lastPage));
          }
          return;
        }
        break;
        
      case StartupPageOption.channelHomePage:
        // Carica la pagina iniziale dell'ultimo canale visualizzato
        if (AppSettings.lastChannelId != null) {
          final channel = TeletextChannels.getChannelById(AppSettings.lastChannelId!);
          if (channel != null) {
            print('[TelevideoBloc] 🏠 Caricamento pagina iniziale del canale: ${channel.name}');
            
            // Cambia il canale (questo caricherà automaticamente la pagina 100)
            add(TelevideoEvent.changeChannel(channel));
            return;
          }
        }
        
        // Se non c'è un canale salvato, fallback all'ultima pagina visualizzata
        print('[TelevideoBloc] ⚠️ Nessun canale salvato, fallback all\'ultima pagina');
        if (AppSettings.lastPageNumber != null) {
          final lastPage = AppSettings.lastPageNumber!;
          final isNationalMode = AppSettings.lastIsNationalMode ?? true;
          
          if (!isNationalMode && AppSettings.lastRegionCode != null) {
            final region = Region.fromCode(AppSettings.lastRegionCode!);
            add(TelevideoEvent.loadRegionalPage(region, lastPage));
          } else {
            add(TelevideoEvent.loadNationalPage(lastPage));
          }
          return;
        }
        break;
    }
    
    // Se nessuna delle opzioni sopra ha funzionato, 
    // carica il primo canale dalla lista dei canali selezionati
    try {
      final prefs = await SharedPreferences.getInstance();
      final channelService = FavoriteChannelsService(prefs);
      final favoriteChannels = await channelService.getFavoriteChannels();
      
      // Se ci sono canali selezionati, carica il primo
      if (favoriteChannels.isNotEmpty) {
        final firstChannel = favoriteChannels.first;
        add(TelevideoEvent.changeChannel(firstChannel));
        return;
      }
    } catch (e) {
      print('[TelevideoBloc] Errore nel caricamento dei canali preferiti: $e');
    }
    
    // Fallback: se non ci sono canali selezionati o errore, carica RAI Nazionale
    final raiNazionale = TeletextChannels.getChannelById('rai_nazionale');
    if (raiNazionale != null) {
      add(TelevideoEvent.changeChannel(raiNazionale));
    } else {
      // Ultimo fallback: carica la pagina predefinita senza cambiare canale
      add(TelevideoEvent.loadNationalPage(_minPage));
    }
  }

  Future<void> _checkPage100Availability() async {
    try {
      _isPage100Available = await _repository.isPage100Available();
      _minPage = _isPage100Available ? 100 : 101;
      _currentPage = _minPage;
    } catch (e) {
      // In caso di errore, assumiamo che la pagina 100 non sia disponibile
      _isPage100Available = false;
      _minPage = 101;
      _currentPage = 101;
    }
  }

  Future<void> _onStartLoading(Emitter<TelevideoState> emit) async {
    final currentChannel = state.selectedChannel;
    emit(TelevideoState.loading(pageNumber: _currentPage, selectedChannel: currentChannel));
  }

  Future<void> _onLoadNationalPage(int pageNumber, Emitter<TelevideoState> emit) async {
    // Verifica se il bloc è già stato chiuso
    if (isClosed) {
      print('[TelevideoBloc] Bloc already closed, skipping loadNationalPage');
      return;
    }
    
    print('[TelevideoBloc] Loading national page: $pageNumber'); // Debug print
    
    // Ricarica il canale dalle preferenze per assicurarci di avere il canale più aggiornato
    TeletextChannel? currentChannel = state.selectedChannel;
    try {
      final prefs = await SharedPreferences.getInstance();
      final channelService = FavoriteChannelsService(prefs);
      final savedChannelId = await channelService.getSelectedChannelId();
      if (savedChannelId.isNotEmpty) {
        final savedChannel = TeletextChannels.getChannelById(savedChannelId);
        if (savedChannel != null) {
          print('[TelevideoBloc] Using saved channel from preferences: ${savedChannel.id}');
          currentChannel = savedChannel;
        }
      }
    } catch (e) {
      print('[TelevideoBloc] Error loading channel from preferences: $e');
    }
    _currentPage = pageNumber;
    print('[TelevideoBloc] 🔄 Emitting loading state for page $pageNumber');
    emit(TelevideoState.loading(pageNumber: pageNumber, selectedChannel: currentChannel));
    print('[TelevideoBloc] ✅ Loading state emitted, starting fetch...');
    _currentRegion = null; // Reset della regione quando si carica una pagina nazionale
    
    // Aggiorna il RegionBloc se disponibile
    _regionBloc?.add(const RegionEvent.selectRegion(null));

    final startTime = DateTime.now();
    bool isError = false;

    try {
      print('[TelevideoBloc] Fetching national page from repository'); // Debug print
      
      // Workaround: pagina 100 sottopagina 1 ha link non cliccabili per canali RAI
      // Quindi carichiamo direttamente la sottopagina 2
      int targetSubPage = 1;
      if (pageNumber == 100 && (currentChannel == null || currentChannel.id == 'rai_nazionale' || currentChannel.id.startsWith('rai_'))) {
        targetSubPage = 2;
        print('[TelevideoBloc] Page 100 detected for RAI channel, loading subpage 2 instead of 1 (workaround for non-clickable links)');
      }
      
      TelevideoPage page;
      // Se il canale corrente è RAI o null, usa il repository normale
      if (currentChannel == null || currentChannel.id == 'rai_nazionale' || currentChannel.id.startsWith('rai_')) {
        page = await _loadPageWithContext(pageNumber, subPage: targetSubPage, forceRefresh: true);
      } else {
        // Per altri canali, usa il provider specifico
        final provider = TeletextProviderFactory.getProvider(currentChannel);
        print('[TelevideoBloc] Using provider: ${provider.providerId} for page $pageNumber');
        print('[TelevideoBloc] Current channel info - ID: ${currentChannel.id}, Country: ${currentChannel.countryCode}, Name: ${currentChannel.name}');
        page = await provider.fetchNationalPage(pageNumber);
        
        // Aggiorna il contesto AdMob
        print('[TelevideoBloc] Updating AdMob context with channel: ${currentChannel.id}');
        _updateAdContext(pageNumber, channel: currentChannel);
        
        // Incrementa il conteggio per gli interstitial
        _adService.incrementPageView(isSubPage: false);
      }
      
      final fetchDuration = DateTime.now().difference(startTime).inMilliseconds;
      print('[TelevideoBloc] ✅ National page loaded successfully in ${fetchDuration}ms'); // Debug print
      print('[TelevideoBloc] Page info - number: ${page.pageNumber}, maxSubPages: ${page.maxSubPages}, isHtmlContent: ${page.isHtmlContent}');
      print('[TelevideoBloc] 🎨 Emitting loaded state...');
      if (!emit.isDone) {
        // Aggiorna ultima pagina caricata con successo
        _updateLastSuccessfulPage(pageNumber, targetSubPage);
        
        emit(TelevideoState.loaded(page, currentSubPage: targetSubPage, isAutoRefreshPaused: false, selectedChannel: currentChannel));
        // Salva lo stato
        await _saveCurrentState(page, targetSubPage, currentChannel);
      }
    } catch (e) {
      isError = true;
      print('[TelevideoBloc] Error loading national page: $e'); // Debug print
      final message = e.toString().contains('404') || e.toString().contains('non trovata')
        ? 'La pagina $pageNumber non è disponibile.\nProva con un altro numero tra $_minPage e 999.\nTorna a $_minPage'
        : 'Si è verificato un errore durante il caricamento della pagina.\nTorna a $_minPage';
      if (!emit.isDone) {
        emit(TelevideoState.error(message, selectedChannel: currentChannel));
      }
    } finally {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      await AnalyticsService().logLoadTime(
        pageNumber.toString(),
        channelId: currentChannel?.id,
        durationMillis: duration,
        isError: isError,
      );
    }
  }

  Future<void> _onLoadRegionalPage(Region region, int pageNumber, Emitter<TelevideoState> emit) async {
    // Verifica se il bloc è già stato chiuso
    if (isClosed) {
      print('[TelevideoBloc] Bloc already closed, skipping loadRegionalPage');
      return;
    }
    
    print('[TelevideoBloc] Loading regional page: $pageNumber for region ${region.code}'); // Debug print
    
    // Ricarica il canale dalle preferenze per assicurarci di avere il canale più aggiornato
    TeletextChannel? currentChannel = state.selectedChannel;
    try {
      final prefs = await SharedPreferences.getInstance();
      final channelService = FavoriteChannelsService(prefs);
      final savedChannelId = await channelService.getSelectedChannelId();
      if (savedChannelId.isNotEmpty) {
        final savedChannel = TeletextChannels.getChannelById(savedChannelId);
        if (savedChannel != null && savedChannel.id.startsWith('rai_') && savedChannel.regions != null) {
          print('[TelevideoBloc] Using saved regional channel from preferences: ${savedChannel.id}');
          currentChannel = savedChannel;
        }
      }
    } catch (e) {
      print('[TelevideoBloc] Error loading channel from preferences: $e');
    }
    final startTime = DateTime.now();
    bool isError = false;
    
    try {
      // Workaround: pagina 300 sottopagina 1 ha link non cliccabili per canali regionali RAI
      // Quindi carichiamo direttamente la sottopagina 2
      int targetSubPage = 1;
      if (pageNumber == 300) {
        targetSubPage = 2;
        print('[TelevideoBloc] Page 300 detected for regional channel, loading subpage 2 instead of 1 (workaround for non-clickable links)');
      }
      
      // Prima carichiamo la pagina regionale
      print('[TelevideoBloc] Fetching regional page from repository'); // Debug print
      final page = await _loadPageWithContext(pageNumber, isRegional: true, region: region, subPage: targetSubPage, forceRefresh: true);
      
      // Solo dopo un caricamento riuscito, aggiorniamo lo stato e le variabili
      _currentRegion = region;
      _currentPage = pageNumber;
      emit(TelevideoState.loading(pageNumber: pageNumber, selectedChannel: currentChannel));
      
      // Aggiorna il RegionBloc se disponibile
      _regionBloc?.add(RegionEvent.selectRegion(region));
      
      print('[TelevideoBloc] Regional page loaded successfully'); // Debug print
      if (!emit.isDone) {
        // Aggiorna ultima pagina caricata con successo (modalità regionale)
        _updateLastSuccessfulPage(pageNumber, targetSubPage, region: region);
        
        emit(TelevideoState.loaded(page, currentSubPage: targetSubPage, isAutoRefreshPaused: false, selectedChannel: currentChannel));
        // Salva lo stato
        await _saveCurrentState(page, targetSubPage, currentChannel);
      }
    } catch (e) {
      isError = true;
      print('[TelevideoBloc] Error loading regional page: $e'); // Debug print
      final message = e.toString().contains('404') || e.toString().contains('non trovata')
        ? 'La pagina $pageNumber non è disponibile per la regione ${region.name}.\nProva con un altro numero tra 100 e 999.'
        : 'Si è verificato un errore durante il caricamento della pagina';
      if (!emit.isDone) {
        emit(TelevideoState.error(message, selectedChannel: currentChannel));
      }
    } finally {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      await AnalyticsService().logLoadTime(
        pageNumber.toString(),
        channelId: currentChannel?.id,
        durationMillis: duration,
        isError: isError,
      );
    }
  }

  Future<void> _onNextPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (currentPage < 899) {
      // Per ZDF e Swiss, controlla se abbiamo il link di navigazione nei metadata
      int? suggestedNextPage;
      state.maybeWhen(
        loaded: (page, _, __, ___) {
          if (page.metadata != null) {
            // ZDF usa 'next', Swiss usa 'nextPage', SVT usa 'nextPage' (String)
            final nextPageValue = page.metadata!['next'] ?? page.metadata!['nextPage'];
            int? nextPage;
            
            // Gestisci sia int che String
            if (nextPageValue is int) {
              nextPage = nextPageValue;
            } else if (nextPageValue is String) {
              nextPage = int.tryParse(nextPageValue);
            }
            
            // Verifica che nextPage sia valido (nel range 100-899)
            if (nextPage != null && nextPage >= 100 && nextPage <= 899) {
              print('[TelevideoBloc] Navigation metadata suggests next=$nextPage');
              suggestedNextPage = nextPage;
            } else if (nextPage != null) {
              print('[TelevideoBloc] Invalid nextPage in metadata: $nextPage (out of range)');
            }
          }
        },
        orElse: () {},
      );
      
      // Se abbiamo un suggerimento dai metadata, prova prima quello
      if (suggestedNextPage != null) {
        print('[TelevideoBloc] Attempting to load suggested page: $suggestedNextPage');
        final currentChannel = state.selectedChannel;
        
        // Emetti loading PRIMA del test (importante per canali HTML lenti)
        emit(TelevideoState.loading(pageNumber: suggestedNextPage!, selectedChannel: currentChannel));
        
        try {
          // Prova a caricare la pagina suggerita
          final provider = TeletextProviderFactory.getProvider(currentChannel!);
          await provider.fetchNationalPage(suggestedNextPage!);
          
          // Se il caricamento ha successo, usa loadNationalPage
          print('[TelevideoBloc] ✅ Suggested page exists, loading it');
          add(TelevideoEvent.loadNationalPage(suggestedNextPage!));
        } catch (e) {
          // Se fallisce (404), usa la ricerca sequenziale
          print('[TelevideoBloc] ⚠️ Suggested page $suggestedNextPage does not exist, falling back to sequential search');
          await _findNextAvailablePage(currentPage + 1, emit);
        }
      } else {
        // Nessun suggerimento, usa ricerca sequenziale
        await _findNextAvailablePage(currentPage + 1, emit);
      }
    }
  }

  Future<void> _onPreviousPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (currentPage > _minPage) {
      // Per ZDF e Swiss, controlla se abbiamo il link di navigazione nei metadata
      int? suggestedPrevPage;
      state.maybeWhen(
        loaded: (page, _, __, ___) {
          if (page.metadata != null) {
            // ZDF usa 'prev', Swiss usa 'previousPage', SVT usa 'prevPage' (String)
            final prevPageValue = page.metadata!['prev'] ?? page.metadata!['previousPage'] ?? page.metadata!['prevPage'];
            int? prevPage;
            
            // Gestisci sia int che String
            if (prevPageValue is int) {
              prevPage = prevPageValue;
            } else if (prevPageValue is String) {
              prevPage = int.tryParse(prevPageValue);
            }
            
            // Verifica che prevPage sia valido (nel range 100-899)
            if (prevPage != null && prevPage >= 100 && prevPage <= 899) {
              print('[TelevideoBloc] Navigation metadata suggests prev=$prevPage');
              suggestedPrevPage = prevPage;
            } else if (prevPage != null) {
              print('[TelevideoBloc] Invalid previousPage in metadata: $prevPage (out of range)');
            }
          }
        },
        orElse: () {},
      );
      
      // Se abbiamo un suggerimento dai metadata, prova prima quello
      if (suggestedPrevPage != null) {
        print('[TelevideoBloc] Attempting to load suggested page: $suggestedPrevPage');
        final currentChannel = state.selectedChannel;
        
        // Emetti loading PRIMA del test (importante per canali HTML lenti)
        emit(TelevideoState.loading(pageNumber: suggestedPrevPage!, selectedChannel: currentChannel));
        
        try {
          // Prova a caricare la pagina suggerita
          final provider = TeletextProviderFactory.getProvider(currentChannel!);
          await provider.fetchNationalPage(suggestedPrevPage!);
          
          // Se il caricamento ha successo, usa loadNationalPage
          print('[TelevideoBloc] ✅ Suggested page exists, loading it');
          add(TelevideoEvent.loadNationalPage(suggestedPrevPage!));
        } catch (e) {
          // Se fallisce (404), usa la ricerca sequenziale
          print('[TelevideoBloc] ⚠️ Suggested page $suggestedPrevPage does not exist, falling back to sequential search');
          await _findPreviousAvailablePage(currentPage - 1, emit);
        }
      } else {
        // Nessun suggerimento, usa ricerca sequenziale
        await _findPreviousAvailablePage(currentPage - 1, emit);
      }
    }
  }

  Future<void> _findNextAvailablePage(int startPage, Emitter<TelevideoState> emit) async {
    final currentChannel = state.selectedChannel;
    int currentPage = startPage;
    int maxAttempts = 100; // Limita il numero di tentativi per evitare loop infiniti
    int attempts = 0;

    while (currentPage <= 899 && attempts < maxAttempts) {
      // Emetti lo stato di loading con la pagina corrente che stiamo provando
      emit(TelevideoState.loading(pageNumber: currentPage, selectedChannel: currentChannel));
      final page = await _tryLoadPage(currentPage, isRegional: _currentRegion != null);
      if (page != null) {
        _currentPage = currentPage;
        
        // Aggiorna ultima pagina caricata con successo
        _updateLastSuccessfulPage(currentPage, 1, region: _currentRegion);
        
        emit(TelevideoState.loaded(page, currentSubPage: 1, isAutoRefreshPaused: false, selectedChannel: currentChannel));
        // Salva lo stato
        await _saveCurrentState(page, 1, currentChannel);
        return;
      }
      
      if (currentPage >= 899) {
      final message = _currentRegion != null
          ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
          : 'Non sono disponibili altre pagine.';
        emit(TelevideoState.error(message, selectedChannel: currentChannel));
        return;
      }
      currentPage++;
      attempts++;
    }
      final message = _currentRegion != null
          ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
          : 'Non sono disponibili altre pagine.';
    emit(TelevideoState.error(message, selectedChannel: currentChannel));
  }

  Future<void> _findPreviousAvailablePage(int startPage, Emitter<TelevideoState> emit) async {
    final currentChannel = state.selectedChannel;
    int currentPage = startPage;
    int maxAttempts = 100; // Limita il numero di tentativi per evitare loop infiniti
    int attempts = 0;

    while (currentPage >= _minPage && attempts < maxAttempts) {
      // Emetti lo stato di loading con la pagina corrente che stiamo provando
      emit(TelevideoState.loading(pageNumber: currentPage, selectedChannel: currentChannel));
      final page = await _tryLoadPage(currentPage, isRegional: _currentRegion != null);
      if (page != null) {
        _currentPage = currentPage;
        
        // Aggiorna ultima pagina caricata con successo
        _updateLastSuccessfulPage(currentPage, 1, region: _currentRegion);
        
        emit(TelevideoState.loaded(page, currentSubPage: 1, isAutoRefreshPaused: false, selectedChannel: currentChannel));
        // Salva lo stato
        await _saveCurrentState(page, 1, currentChannel);
        return;
      }
      
      if (currentPage <= _minPage) {
      final message = _currentRegion != null
          ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
          : 'Non sono disponibili altre pagine.';
        emit(TelevideoState.error(message, selectedChannel: currentChannel));
        return;
      }
      currentPage--;
      attempts++;
    }
      final message = _currentRegion != null
          ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
          : 'Non sono disponibili altre pagine.';
    emit(TelevideoState.error(message, selectedChannel: currentChannel));
  }

  Future<void> _onNextSubPage(Emitter<TelevideoState> emit) async {
    // Verifica se il bloc è già stato chiuso
    if (isClosed) {
      print('[TelevideoBloc] Bloc already closed, skipping nextSubPage');
      return;
    }
    
    await state.maybeWhen(
      loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) async {
        print('[TelevideoBloc] _onNextSubPage called - current: $currentSubPage/${page.maxSubPages}, channel: ${selectedChannel?.id}');
        
        if (page.maxSubPages <= 1) return; // Non fare nulla se non ci sono sottopagine
        
        final nextSubPage = currentSubPage + 1;
        final maxSubPages = page.maxSubPages;
        final newSubPage = nextSubPage > maxSubPages ? 1 : nextSubPage;
        
        print('[TelevideoBloc] Will load subpage $newSubPage for page ${page.pageNumber}');
        
        final startTime = DateTime.now();
        bool isError = false;
        
        try {
          TelevideoPage newPage;
          
          // Verifica se stiamo usando RAI o un altro provider
          if (selectedChannel == null || selectedChannel.id == 'rai_nazionale' || selectedChannel.id.startsWith('rai_')) {
            print('[TelevideoBloc] Using RAI repository for subpage');
            // Per RAI usa il repository
            newPage = await _currentRegion != null
                ? await _repository.getRegionalPage(
                    _currentRegion!.code,
                    pageNumber: page.pageNumber,
                    subPage: newSubPage,
                  )
                : await _repository.getNationalPage(
                    page.pageNumber,
                    subPage: newSubPage,
                  );
          } else {
            // Per altri canali (ARD, ZDF, ecc.) usa il provider specifico
            final provider = TeletextProviderFactory.getProvider(selectedChannel);
            print('[TelevideoBloc] Loading subpage $newSubPage using provider: ${provider.providerId}');
            newPage = await provider.fetchNationalPage(page.pageNumber, subPage: newSubPage);
          }
          
          // Usa il maxSubPages della nuova pagina per validare la sottopagina
          final validSubPage = newSubPage <= newPage.maxSubPages ? newSubPage : 1;
          if (!emit.isDone) {
            _adService.incrementPageView(isSubPage: true);
            // Aggiorna ultima pagina caricata con successo
            _updateLastSuccessfulPage(newPage.pageNumber, validSubPage, region: _currentRegion);
            
            emit(TelevideoState.loaded(newPage, currentSubPage: validSubPage, isAutoRefreshPaused: isAutoRefreshPaused, selectedChannel: selectedChannel));
            // Salva lo stato
            await _saveCurrentState(newPage, validSubPage, selectedChannel);
          }
        } catch (e) {
          isError = true;
          print('[TelevideoBloc] Error loading subpage: $e');
          // Se c'è un errore nel caricamento della sottopagina, mantieni la pagina corrente
          if (!emit.isDone) {
            emit(TelevideoState.loaded(page, currentSubPage: currentSubPage, isAutoRefreshPaused: isAutoRefreshPaused, selectedChannel: selectedChannel));
          }
        } finally {
          final duration = DateTime.now().difference(startTime).inMilliseconds;
          await AnalyticsService().logLoadTime(
            page.pageNumber.toString(),
            subPage: newSubPage.toString(),
            channelId: selectedChannel?.id,
            durationMillis: duration,
            isError: isError,
          );
        }
      },
      orElse: () async {},
    );
  }

  Future<void> _onPreviousSubPage(Emitter<TelevideoState> emit) async {
    // Verifica se il bloc è già stato chiuso
    if (isClosed) {
      print('[TelevideoBloc] Bloc already closed, skipping previousSubPage');
      return;
    }
    
    await state.maybeWhen(
      loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) async {
        if (page.maxSubPages <= 1) return; // Non fare nulla se non ci sono sottopagine
        
        final prevSubPage = currentSubPage - 1;
        final maxSubPages = page.maxSubPages;
        final newSubPage = prevSubPage < 1 ? maxSubPages : prevSubPage;
        
        final startTime = DateTime.now();
        bool isError = false;
        
        try {
          TelevideoPage newPage;
          
          // Verifica se stiamo usando RAI o un altro provider
          if (selectedChannel == null || selectedChannel.id == 'rai_nazionale' || selectedChannel.id.startsWith('rai_')) {
            // Per RAI usa il repository
            newPage = await _currentRegion != null
                ? await _repository.getRegionalPage(
                    _currentRegion!.code,
                    pageNumber: page.pageNumber,
                    subPage: newSubPage,
                  )
                : await _repository.getNationalPage(
                    page.pageNumber,
                    subPage: newSubPage,
                  );
          } else {
            // Per altri canali (ARD, ZDF, ecc.) usa il provider specifico
            final provider = TeletextProviderFactory.getProvider(selectedChannel);
            print('[TelevideoBloc] Loading subpage $newSubPage using provider: ${provider.providerId}');
            newPage = await provider.fetchNationalPage(page.pageNumber, subPage: newSubPage);
          }
          
          // Usa il maxSubPages della nuova pagina per validare la sottopagina
          final validSubPage = newSubPage <= newPage.maxSubPages ? newSubPage : 1;
          if (!emit.isDone) {
            _adService.incrementPageView(isSubPage: true);
            // Aggiorna ultima pagina caricata con successo
            _updateLastSuccessfulPage(newPage.pageNumber, validSubPage, region: _currentRegion);
            
            emit(TelevideoState.loaded(newPage, currentSubPage: validSubPage, isAutoRefreshPaused: isAutoRefreshPaused, selectedChannel: selectedChannel));
            // Salva lo stato
            await _saveCurrentState(newPage, validSubPage, selectedChannel);
          }
        } catch (e) {
          isError = true;
          print('[TelevideoBloc] Error loading subpage: $e');
          // Se c'è un errore nel caricamento della sottopagina, mantieni la pagina corrente
          if (!emit.isDone) {
            emit(TelevideoState.loaded(page, currentSubPage: currentSubPage, isAutoRefreshPaused: isAutoRefreshPaused, selectedChannel: selectedChannel));
          }
        } finally {
          final duration = DateTime.now().difference(startTime).inMilliseconds;
          await AnalyticsService().logLoadTime(
            page.pageNumber.toString(),
            subPage: newSubPage.toString(),
            channelId: selectedChannel?.id,
            durationMillis: duration,
            isError: isError,
          );
        }
      },
      orElse: () async {},
    );
  }

  @override
  Future<void> close() {
    _adService.dispose();
    return super.close();
  }

  Future<void> _onToggleAutoRefreshPause(Emitter<TelevideoState> emit) async {
    await state.maybeWhen(
      loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) async {
        // Logga l'evento di pausa/play
        AnalyticsService().logSubpageChange(
          page.pageNumber.toString(),
          currentSubPage.toString(),
          isAutoRefreshPaused ? 'auto_refresh_resume' : 'auto_refresh_pause',
        );
        
        // Emetti il nuovo stato con lo stato di pausa invertito
        emit(TelevideoState.loaded(
          page,
          currentSubPage: currentSubPage,
          isAutoRefreshPaused: !isAutoRefreshPaused,
          selectedChannel: selectedChannel,
        ));
      },
      orElse: () async {},
    );
  }

  Future<void> _onChangeChannel(TeletextChannel channel, Emitter<TelevideoState> emit) async {
    // Verifica se il bloc è già stato chiuso
    if (isClosed) {
      print('[TelevideoBloc] Bloc already closed, skipping changeChannel');
      return;
    }
    
    print('[TelevideoBloc] Cambiamento canale: ${channel.name}');
    
    // TODO: Aggiungere analytics per cambio canale quando il metodo sarà disponibile
    // AnalyticsService().logChannelChange(channel.id, channel.name, channel.countryCode);

    // Emetti stato di caricamento con il nuovo canale
    emit(TelevideoState.loading(pageNumber: 100, selectedChannel: channel));

    // Verifica se il provider è disponibile
    if (!TeletextProviderFactory.isProviderAvailable(channel)) {
      emit(TelevideoState.error(
        'Il canale ${channel.name} non è ancora supportato.\n'
        'Canali disponibili: ${TeletextProviderFactory.getAvailableProviders().join(", ")}',
        selectedChannel: channel,
      ));
      
      // Dopo 3 secondi torna al canale RAI
      await Future.delayed(const Duration(seconds: 3));
      final raiChannel = TeletextChannels.getChannelById('rai_nazionale');
      if (raiChannel != null && !emit.isDone) {
        add(TelevideoEvent.changeChannel(raiChannel));
      }
      return;
    }

    try {
      // Ottieni il provider per il canale
      final provider = TeletextProviderFactory.getProvider(channel);
      print('[TelevideoBloc] Using provider: ${provider.providerId}');
      
      // Determina quale pagina caricare
      if (channel.id == 'rai_nazionale') {
        // RAI Nazionale
        _currentRegion = null;
        add(TelevideoEvent.loadNationalPage(_minPage));
      } else if (channel.id.startsWith('rai_') && channel.regions != null && channel.regions!.isNotEmpty) {
        // RAI Regionale
        try {
          final region = Region.fromCode(channel.regions!.first);
          _currentRegion = region;
          
          // Sincronizza con RegionBloc se disponibile
          if (_regionBloc != null) {
            _regionBloc!.add(RegionEvent.selectRegion(region));
          }

          add(TelevideoEvent.loadRegionalPage(region, 300));
        } catch (e) {
          print('[TelevideoBloc] Errore nel trovare la regione per il codice ${channel.regions!.first}: $e');
          emit(TelevideoState.error(
            'Errore nel caricare la regione per il canale ${channel.name}.',
            selectedChannel: channel,
          ));
        }
      } else {
        // Altri canali (ARD, ZDF, ecc.) - carica pagina 100
        _currentRegion = null;
        
        final startTime = DateTime.now();
        final page = await provider.fetchNationalPage(100);
        final loadTime = DateTime.now().difference(startTime).inMilliseconds;
        
        print('[TelevideoBloc] Page loaded in ${loadTime}ms');
        print('[TelevideoBloc] Page isHtmlContent: ${page.isHtmlContent}');
        print('[TelevideoBloc] Page info - number: ${page.pageNumber}, maxSubPages: ${page.maxSubPages}, totalSubPages: ${page.totalSubPages}');
        
        // Log analytics
        await AnalyticsService().logLoadTime(
          page.pageNumber.toString(),
          channelId: channel.id,
          durationMillis: loadTime,
        );
        
        _currentPage = page.pageNumber;
        _updateAdContext(page.pageNumber, channel: channel);

        emit(TelevideoState.loaded(
          page,
          currentSubPage: page.subPage,
          selectedChannel: channel,
        ));
      }
    } catch (e, stackTrace) {
      print('[TelevideoBloc] Error changing channel: $e');
      print('[TelevideoBloc] Stack trace: $stackTrace');
      
      emit(TelevideoState.error(
        'Errore nel caricare il canale ${channel.name}:\n$e',
        selectedChannel: channel,
      ));
      
      // Log error
      await AnalyticsService().logError('channel_change_error', e.toString());
    }
  }
}