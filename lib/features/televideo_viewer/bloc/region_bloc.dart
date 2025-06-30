import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/shared/models/region.dart';

part 'region_bloc.freezed.dart';

@freezed
sealed class RegionEvent with _$RegionEvent {
  const factory RegionEvent.selectRegion(Region? region) = _SelectRegion;
}

@freezed
sealed class RegionState with _$RegionState {
  const factory RegionState({
    required Region? selectedRegion,
  }) = _RegionState;

  factory RegionState.initial() => const RegionState(selectedRegion: null);
}

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  RegionBloc() : super(RegionState.initial()) {
    on<RegionEvent>((event, emit) async {
      switch (event) {
        case _SelectRegion(:final region):
          emit(RegionState(selectedRegion: region));
      }
    });
  }
} 