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
            final descriptions = _descriptionsService.getDescriptionsForChannel(
              channelId: favorite.channelId,
              isRegional: favorite.regionCode != null,
            );
            return FavoritePage(
              pageNumber: favorite.pageNumber,
              title: favorite.title,
              description: descriptions[favorite.pageNumber] ?? 'Pagina ${favorite.pageNumber}',
              regionCode: favorite.regionCode,
              channelId: favorite.channelId,
              order: favorite.order,
            );
          }
          return favorite;
        })
        .toList();
    
    // Ordina i preferiti in base all'ordine
    _favorites.sort((a, b) => a.order.compareTo(b.order));
    
    // Salviamo subito per aggiornare i preferiti con le descrizioni
    await _saveFavorites();
  }

  Future<void> addFavorite(int pageNumber, {String? regionCode, String? channelId}) async {
    if (!_favorites.any((f) => f.pageNumber == pageNumber && f.regionCode == regionCode && f.channelId == channelId)) {
      final descriptions = _descriptionsService.getDescriptionsForChannel(
        channelId: channelId,
        isRegional: regionCode != null,
      );
      final description = descriptions[pageNumber] ?? 'Pagina $pageNumber';
      
      final favorite = FavoritePage(
        pageNumber: pageNumber,
        title: 'Pagina $pageNumber',
        description: description,
        regionCode: regionCode,
        channelId: channelId,
        order: _favorites.length, // Aggiungi alla fine della lista
      );
      
      _favorites.add(favorite);
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(int pageNumber, {String? regionCode, String? channelId}) async {
    _favorites.removeWhere(
        (f) => f.pageNumber == pageNumber && f.regionCode == regionCode && f.channelId == channelId);
    // Riordina gli indici dopo la rimozione
    _reorderIndexes();
    await _saveFavorites();
  }

  Future<void> updateDescription(int pageNumber, String? regionCode, String? channelId, String newDescription) async {
    final index = _favorites.indexWhere(
      (f) => f.pageNumber == pageNumber && f.regionCode == regionCode && f.channelId == channelId
    );
    
    if (index != -1) {
      _favorites[index] = FavoritePage(
        pageNumber: _favorites[index].pageNumber,
        title: _favorites[index].title,
        description: newDescription,
        regionCode: _favorites[index].regionCode,
        channelId: _favorites[index].channelId,
        order: _favorites[index].order,
      );
      await _saveFavorites();
    }
  }

  Future<void> reorderFavorites(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    // Quando si sposta verso il basso, Flutter fornisce l'indice dopo la rimozione
    // dell'elemento, quindi dobbiamo decrementare newIndex
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Rimuovi l'elemento dalla vecchia posizione
    final item = _favorites.removeAt(oldIndex);
    
    // Inserisci l'elemento nella nuova posizione
    _favorites.insert(newIndex, item);
    
    // Aggiorna gli indici di tutti gli elementi
    for (var i = 0; i < _favorites.length; i++) {
      final favorite = _favorites[i];
      _favorites[i] = FavoritePage(
        pageNumber: favorite.pageNumber,
        title: favorite.title,
        description: favorite.description,
        regionCode: favorite.regionCode,
        channelId: favorite.channelId,
        order: i,
      );
    }
    
    // Salva immediatamente il nuovo ordine
    await _saveFavorites();
  }

  void _reorderIndexes() {
    for (var i = 0; i < _favorites.length; i++) {
      final favorite = _favorites[i];
      _favorites[i] = FavoritePage(
        pageNumber: favorite.pageNumber,
        title: favorite.title,
        description: favorite.description,
        regionCode: favorite.regionCode,
        channelId: favorite.channelId,
        order: i,
      );
    }
  }

  bool isFavorite(int pageNumber, String? regionCode, {String? channelId}) {
    return _favorites.any(
        (f) => f.pageNumber == pageNumber && f.regionCode == regionCode && f.channelId == channelId);
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

  Future<void> restoreFromBackup(List<FavoritePage> favorites) async {
    _favorites = favorites.map((favorite) {
      // Aggiorna la descrizione se mancante
      if (favorite.description == null) {
        return FavoritePage(
          pageNumber: favorite.pageNumber,
          title: favorite.title,
          description: _descriptionsService.getDescription(
            favorite.pageNumber,
            isRegional: favorite.regionCode != null,
          ),
          regionCode: favorite.regionCode,
          channelId: favorite.channelId,
          order: favorite.order,
        );
      }
      return favorite;
    }).toList();
    
    // Ordina i preferiti in base all'ordine
    _favorites.sort((a, b) => a.order.compareTo(b.order));
    
    await _saveFavorites();
  }
} 