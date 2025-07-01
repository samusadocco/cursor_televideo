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

  TelevideoBloc({required TelevideoRepository repository})
      : _repository = repository,
        super(const TelevideoState.initial()) {
    on<TelevideoEvent>((event, emit) async {
      await event.when(
        loadNationalPage: (pageNumber) => _onLoadNationalPage(pageNumber, emit),
        loadRegionalPage: (region) => _onLoadRegionalPage(region, emit),
        nextPage: (currentPage) => _onNextPage(currentPage, emit),
        previousPage: (currentPage) => _onPreviousPage(currentPage, emit),
      );
    });
  }

  Future<void> _onLoadNationalPage(int pageNumber, Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
    _currentRegion = null;
    _currentPage = pageNumber;

    try {
      final page = await _repository.getNationalPage(pageNumber);
      emit(TelevideoState.loaded(TelevideoPage(
        pageNumber: pageNumber,
        imageUrl: page.imageUrl,
        region: null,
      )));
    } catch (e) {
      emit(TelevideoState.error(e.toString()));
    }
  }

  Future<void> _onLoadRegionalPage(Region region, Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
    try {
      final bool wasNational = _currentRegion == null;
      _currentRegion = region;
      
      // Impostiamo la pagina 300 solo se veniamo dalla modalità nazionale
      if (wasNational) {
        _currentPage = 300;
      }
      
      final page = await _repository.getRegionalPage(region.code, pageNumber: _currentPage);
      emit(TelevideoState.loaded(page));
    } catch (e) {
      // Se la pagina non è disponibile, cerca la prossima disponibile
      await _findNextAvailablePage(_currentPage, emit);
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
          emit(TelevideoState.loaded(page));
          return;
        } else {
          final page = await _repository.getNationalPage(currentPage);
          _currentPage = currentPage;
          emit(TelevideoState.loaded(page));
          return;
        }
      } catch (e) {
        if (currentPage >= 899) {
          emit(TelevideoState.error('Nessuna pagina disponibile'));
          return;
        }
        currentPage++;
        attempts++;
      }
    }
    emit(TelevideoState.error('Nessuna pagina disponibile'));
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
          emit(TelevideoState.loaded(page));
          return;
        } else {
          final page = await _repository.getNationalPage(currentPage);
          _currentPage = currentPage;
          emit(TelevideoState.loaded(page));
          return;
        }
      } catch (e) {
        if (currentPage <= 100) {
          emit(TelevideoState.error('Nessuna pagina disponibile'));
          return;
        }
        currentPage--;
        attempts++;
      }
    }
    emit(TelevideoState.error('Nessuna pagina disponibile'));
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

  @override
  Future<void> close() {
    _adService.dispose();
    return super.close();
  }
} 