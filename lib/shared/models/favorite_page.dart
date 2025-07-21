import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_page.freezed.dart';
part 'favorite_page.g.dart';

@freezed
class FavoritePage with _$FavoritePage {
  const FavoritePage._();  // Aggiungo un costruttore privato per i metodi di utility

  const factory FavoritePage({
    required int pageNumber,
    required String title,
    String? description,
    String? regionCode,
    @Default(0) int order,
  }) = _FavoritePage;

  // Getter per ottenere una descrizione sicura
  String get displayDescription => description ?? 'Pagina $pageNumber';

  factory FavoritePage.fromJson(Map<String, dynamic> json) =>
      _$FavoritePageFromJson(json);
} 