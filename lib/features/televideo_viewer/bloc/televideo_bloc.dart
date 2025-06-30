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
    try {
      _currentRegion = null; // Reset della regione corrente
      final page = await _repository.getNationalPage(pageNumber);
      emit(TelevideoState.loaded(page));
    } catch (e) {
      emit(TelevideoState.error(e.toString()));
    }
  }

  Future<void> _onLoadRegionalPage(Region region, Emitter<TelevideoState> emit) async {
    emit(const TelevideoState.loading());
    try {
      _currentRegion = region; // Salva la regione corrente
      final page = await _repository.getRegionalPage(region.code);
      emit(TelevideoState.loaded(page));
    } catch (e) {
      emit(TelevideoState.error(e.toString()));
    }
  }

  Future<void> _onNextPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (_currentRegion != null) {
      // Per le pagine regionali non facciamo nulla, poiché c'è solo la pagina 300
      return;
    }
    
    final nextPage = currentPage + 1;
    if (nextPage <= 899) {
      await _onLoadNationalPage(nextPage, emit);
    }
  }

  Future<void> _onPreviousPage(int currentPage, Emitter<TelevideoState> emit) async {
    if (_currentRegion != null) {
      // Per le pagine regionali non facciamo nulla, poiché c'è solo la pagina 300
      return;
    }
    
    final previousPage = currentPage - 1;
    if (previousPage >= 100) {
      await _onLoadNationalPage(previousPage, emit);
    }
  }

  @override
  Future<void> close() {
    _adService.dispose();
    return super.close();
  }
} 