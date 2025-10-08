import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';

part 'televideo_state.freezed.dart';

@freezed
class TelevideoState with _$TelevideoState {
  const factory TelevideoState.initial({TeletextChannel? selectedChannel}) = _Initial;
  const factory TelevideoState.loading({required int pageNumber, TeletextChannel? selectedChannel}) = _Loading;
  const factory TelevideoState.loaded(TelevideoPage page, {@Default(1) int currentSubPage, @Default(false) bool isAutoRefreshPaused, TeletextChannel? selectedChannel}) = _Loaded;
  const factory TelevideoState.error(String message, {TeletextChannel? selectedChannel}) = _Error;
} 