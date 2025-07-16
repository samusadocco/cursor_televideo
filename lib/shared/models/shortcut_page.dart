import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortcut_page.freezed.dart';
part 'shortcut_page.g.dart';

@freezed
class ShortcutPage with _$ShortcutPage {
  const factory ShortcutPage({
    required int pageNumber,
    required String title,
  }) = _ShortcutPage;

  factory ShortcutPage.fromJson(Map<String, dynamic> json) =>
      _$ShortcutPageFromJson(json);
} 