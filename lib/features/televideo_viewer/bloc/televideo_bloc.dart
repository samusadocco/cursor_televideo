import 'package:bloc/bloc.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class TelevideoBloc extends Bloc<TelevideoEvent, TelevideoState> {
  final TelevideoRepository _repository;
  final AdService _adService = AdService();
  final int defaultPage = 100;
  Region? _currentRegion;
  int _currentPage = 100;
  TelevideoEvent? _lastEvent;

  /// L'ultimo evento ricevuto dal bloc
  TelevideoEvent? get lastEvent => _lastEvent;

  TelevideoBloc({required TelevideoRepository repository})
      : _repository = repository,
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
      );
    });
  }

  Future<void> _onStartLoading(Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
  }

  Future<void> _onLoadNationalPage(int pageNumber, Emitter<TelevideoState> emit) async {
    print('[TelevideoBloc] Loading national page: $pageNumber'); // Debug print
    emit(const TelevideoState.loading());
    _currentPage = pageNumber;
    _currentRegion = null; // Reset della regione quando si carica una pagina nazionale

    try {
      print('[TelevideoBloc] Fetching national page from repository'); // Debug print
      final page = await _repository.getNationalPage(pageNumber);
      _adService.incrementPageView();
      print('[TelevideoBloc] National page loaded successfully'); // Debug print
      emit(TelevideoState.loaded(page, currentSubPage: 1));
    } catch (e) {
      print('[TelevideoBloc] Error loading national page: $e'); // Debug print
      final message = e.toString().contains('404') || e.toString().contains('non trovata')
        ? 'La pagina $pageNumber non è disponibile.\nProva con un altro numero tra 100 e 999.'
        : 'Si è verificato un errore durante il caricamento della pagina.\nRiprova tra qualche istante.';
      emit(TelevideoState.error(message));
    }
  }

  Future<void> _onLoadRegionalPage(Region region, int pageNumber, Emitter<TelevideoState> emit) async {
    print('[TelevideoBloc] Loading regional page: $pageNumber for region ${region.code}'); // Debug print
    emit(const TelevideoState.loading());
    try {
      _currentRegion = region;
      _currentPage = pageNumber;
      
      print('[TelevideoBloc] Fetching regional page from repository'); // Debug print
      final page = await _repository.getRegionalPage(region.code, pageNumber: pageNumber);
      _adService.incrementPageView();
      print('[TelevideoBloc] Regional page loaded successfully'); // Debug print
      emit(TelevideoState.loaded(page, currentSubPage: 1));
    } catch (e) {
      print('[TelevideoBloc] Error loading regional page: $e'); // Debug print
      final message = e.toString().contains('404') || e.toString().contains('non trovata')
        ? 'La pagina $pageNumber non è disponibile per la regione ${region.name}.\nProva con un altro numero tra 100 e 999.'
        : 'Si è verificato un errore durante il caricamento della pagina.\nRiprova tra qualche istante.';
      emit(TelevideoState.error(message));
    }
  }

  Future<void> _onNextPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (currentPage < 899) {
      await _findNextAvailablePage(currentPage + 1, emit);
    }
  }

  Future<void> _onPreviousPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (currentPage > 100) {
      await _findPreviousAvailablePage(currentPage - 1, emit);
    }
  }

  Future<void> _findNextAvailablePage(int startPage, Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
    int currentPage = startPage;
    int maxAttempts = 100; // Limita il numero di tentativi per evitare loop infiniti
    int attempts = 0;

    while (currentPage <= 899 && attempts < maxAttempts) {
      try {
        if (_currentRegion != null) {
          final page = await _repository.getRegionalPage(_currentRegion!.code, pageNumber: currentPage);
          _currentPage = currentPage;
          _adService.incrementPageView();
          emit(TelevideoState.loaded(page));
          return;
        } else {
          final page = await _repository.getNationalPage(currentPage);
          _currentPage = currentPage;
          _adService.incrementPageView();
          emit(TelevideoState.loaded(page));
          return;
        }
      } catch (e) {
        if (currentPage >= 899) {
          final message = _currentRegion != null
            ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
            : 'Non sono disponibili altre pagine.';
          emit(TelevideoState.error(message));
          return;
        }
        currentPage++;
        attempts++;
      }
    }
    final message = _currentRegion != null
      ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
      : 'Non sono disponibili altre pagine.';
    emit(TelevideoState.error(message));
  }

  Future<void> _findPreviousAvailablePage(int startPage, Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
    int currentPage = startPage;
    int maxAttempts = 100; // Limita il numero di tentativi per evitare loop infiniti
    int attempts = 0;

    while (currentPage >= 100 && attempts < maxAttempts) {
      try {
        if (_currentRegion != null) {
          final page = await _repository.getRegionalPage(_currentRegion!.code, pageNumber: currentPage);
          _currentPage = currentPage;
          _adService.incrementPageView();
          emit(TelevideoState.loaded(page));
          return;
        } else {
          final page = await _repository.getNationalPage(currentPage);
          _currentPage = currentPage;
          _adService.incrementPageView();
          emit(TelevideoState.loaded(page));
          return;
        }
      } catch (e) {
        if (currentPage <= 100) {
          final message = _currentRegion != null
            ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
            : 'Non sono disponibili altre pagine.';
          emit(TelevideoState.error(message));
          return;
        }
        currentPage--;
        attempts++;
      }
    }
    final message = _currentRegion != null
      ? 'Non sono disponibili altre pagine per la regione ${_currentRegion!.name}.'
      : 'Non sono disponibili altre pagine.';
    emit(TelevideoState.error(message));
  }

  Future<void> _onNextSubPage(Emitter<TelevideoState> emit) async {
    await state.maybeWhen(
      loaded: (page, currentSubPage) async {
        if (page.maxSubPages <= 1) return; // Non fare nulla se non ci sono sottopagine
        
        final nextSubPage = currentSubPage + 1;
        final maxSubPages = page.maxSubPages;
        final newSubPage = nextSubPage > maxSubPages ? 1 : nextSubPage;
        
        try {
          final newPage = await _currentRegion != null
              ? await _repository.getRegionalPage(_currentRegion!.code, pageNumber: page.pageNumber, subPage: newSubPage)
              : await _repository.getNationalPage(page.pageNumber, subPage: newSubPage);
          
          // Usa il maxSubPages della nuova pagina per validare la sottopagina
          final validSubPage = newSubPage <= newPage.maxSubPages ? newSubPage : 1;
          if (!emit.isDone) {
            _adService.incrementPageView(isSubPage: true);
            emit(TelevideoState.loaded(newPage, currentSubPage: validSubPage));
          }
        } catch (e) {
          // Se la sottopagina non esiste, torniamo alla prima
          if (!emit.isDone) {
            final fallbackPage = await _currentRegion != null
                ? await _repository.getRegionalPage(_currentRegion!.code, pageNumber: page.pageNumber)
                : await _repository.getNationalPage(page.pageNumber);
            
            emit(TelevideoState.loaded(fallbackPage, currentSubPage: 1));
          }
        }
      },
      orElse: () async {},
    );
  }

  Future<void> _onPreviousSubPage(Emitter<TelevideoState> emit) async {
    await state.maybeWhen(
      loaded: (page, currentSubPage) async {
        if (page.maxSubPages <= 1) return; // Non fare nulla se non ci sono sottopagine
        
        final prevSubPage = currentSubPage - 1;
        final maxSubPages = page.maxSubPages;
        final newSubPage = prevSubPage < 1 ? maxSubPages : prevSubPage;
        
        try {
          final newPage = await _currentRegion != null
              ? await _repository.getRegionalPage(_currentRegion!.code, pageNumber: page.pageNumber, subPage: newSubPage)
              : await _repository.getNationalPage(page.pageNumber, subPage: newSubPage);
          
          // Usa il maxSubPages della nuova pagina per validare la sottopagina
          final validSubPage = newSubPage <= newPage.maxSubPages ? newSubPage : 1;
          if (!emit.isDone) {
            _adService.incrementPageView(isSubPage: true);
            emit(TelevideoState.loaded(newPage, currentSubPage: validSubPage));
          }
        } catch (e) {
          // Se la sottopagina non esiste, torniamo alla prima
          if (!emit.isDone) {
            final fallbackPage = await _currentRegion != null
                ? await _repository.getRegionalPage(_currentRegion!.code, pageNumber: page.pageNumber)
                : await _repository.getNationalPage(page.pageNumber);
            
            emit(TelevideoState.loaded(fallbackPage, currentSubPage: 1));
          }
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
} 