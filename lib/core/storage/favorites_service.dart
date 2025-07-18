import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _favoritesKey = 'favorites';
  List<FavoritePage> _favorites = [];
  final PageDescriptionsService _descriptionsService = PageDescriptionsService();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = favoritesJson
        .map((json) {
          final favorite = FavoritePage.fromJson(jsonDecode(json));
          // Se non c'è descrizione, la aggiungiamo
          if (favorite.description == null) {
            return FavoritePage(
              pageNumber: favorite.pageNumber,
              title: favorite.title,
              description: _descriptionsService.getDescription(
                favorite.pageNumber,
                isRegional: favorite.regionCode != null,
              ),
              regionCode: favorite.regionCode,
            );
          }
          return favorite;
        })
        .toList();
    
    // Salviamo subito per aggiornare i preferiti con le descrizioni
    await _saveFavorites();
  }

  Future<void> addFavorite(int pageNumber, {String? regionCode}) async {
    if (!_favorites.any((f) => f.pageNumber == pageNumber && f.regionCode == regionCode)) {
      final description = _descriptionsService.getDescription(
        pageNumber, 
        isRegional: regionCode != null,
      );
      
      final favorite = FavoritePage(
        pageNumber: pageNumber,
        title: 'Pagina $pageNumber',
        description: description,
        regionCode: regionCode,
      );
      
      _favorites.add(favorite);
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(int pageNumber, {String? regionCode}) async {
    _favorites.removeWhere(
        (f) => f.pageNumber == pageNumber && f.regionCode == regionCode);
    await _saveFavorites();
  }

  Future<void> updateDescription(int pageNumber, String? regionCode, String newDescription) async {
    final index = _favorites.indexWhere(
      (f) => f.pageNumber == pageNumber && f.regionCode == regionCode
    );
    
    if (index != -1) {
      _favorites[index] = FavoritePage(
        pageNumber: _favorites[index].pageNumber,
        title: _favorites[index].title,
        description: newDescription,
        regionCode: _favorites[index].regionCode,
      );
      await _saveFavorites();
    }
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