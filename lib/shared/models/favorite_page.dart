import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_page.freezed.dart';
part 'favorite_page.g.dart';

@freezed
class FavoritePage with _$FavoritePage {
  const factory FavoritePage({
    required int pageNumber,
    required String title,
    String? regionCode,
  }) = _FavoritePage;

  factory FavoritePage.fromJson(Map<String, dynamic> json) =>
      _$FavoritePageFromJson(json);
} 