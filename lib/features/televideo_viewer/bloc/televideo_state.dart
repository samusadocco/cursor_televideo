import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

part 'televideo_state.freezed.dart';

@freezed
class TelevideoState with _$TelevideoState {
  const factory TelevideoState.initial() = _Initial;
  const factory TelevideoState.loading() = _Loading;
  const factory TelevideoState.loaded(TelevideoPage page) = _Loaded;
  const factory TelevideoState.error(String message) = _Error;
} 