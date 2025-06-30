import 'package:freezed_annotation/freezed_annotation.dart';

part 'televideo_page.freezed.dart';
part 'televideo_page.g.dart';

@freezed
class TelevideoPage with _$TelevideoPage {
  const factory TelevideoPage({
    required int pageNumber,
    required String imageUrl,
    String? region,
  }) = _TelevideoPage;

  factory TelevideoPage.fromJson(Map<String, dynamic> json) =>
      _$TelevideoPageFromJson(json);
} 