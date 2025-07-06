import 'package:freezed_annotation/freezed_annotation.dart';

part 'televideo_page.freezed.dart';
part 'televideo_page.g.dart';

/// Rappresenta un'area cliccabile sulla pagina del Televideo
@freezed
class ClickableArea with _$ClickableArea {
  const factory ClickableArea({
    required int targetPage,
    required int x,
    required int y,
    required int width,
    required int height,
  }) = _ClickableArea;

  factory ClickableArea.fromJson(Map<String, dynamic> json) =>
      _$ClickableAreaFromJson(json);
}

@freezed
class TelevideoPage with _$TelevideoPage {
  const factory TelevideoPage({
    required int pageNumber,
    required String imageUrl,
    String? region,
    @Default([]) List<ClickableArea> clickableAreas,
    @Default(1) int maxSubPages,
  }) = _TelevideoPage;

  factory TelevideoPage.fromJson(Map<String, dynamic> json) =>
      _$TelevideoPageFromJson(json);
} 