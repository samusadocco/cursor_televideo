import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _favoritesKey = 'favorites';
  List<FavoritePage> _favorites = [];

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoritesJson
        .map((json) => FavoritePage.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addFavorite(FavoritePage page) async {
    if (!_favorites.any((f) => f.pageNumber == page.pageNumber && f.regionCode == page.regionCode)) {
      _favorites.add(page);
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(FavoritePage page) async {
    _favorites.removeWhere(
        (f) => f.pageNumber == page.pageNumber && f.regionCode == page.regionCode);
    await _saveFavorites();
  }

  bool isFavorite(int pageNumber, String? regionCode) {
    return _favorites.any(
        (f) => f.pageNumber == pageNumber && f.regionCode == regionCode);
  }

  List<FavoritePage> getFavorites() {
    return List.unmodifiable(_favorites);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites
        .map((favorite) => jsonEncode(favorite.toJson()))
        .toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }
} 