import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';

/// Service per gestire i canali preferiti
class FavoriteChannelsService {
  static const String _favoritesKey = 'favorite_channels';
  static const String _selectedChannelKey = 'selected_channel';
  
  final SharedPreferences _prefs;

  FavoriteChannelsService(this._prefs);

  /// Ottiene la lista dei canali preferiti
  Future<List<String>> getFavoriteChannelIds() async {
    final favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson == null) {
      // Default: RAI Nazionale come preferito iniziale
      return ['rai_nazionale'];
    }
    
    try {
      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.cast<String>();
    } catch (e) {
      print('Errore nel caricamento dei preferiti: $e');
      return ['rai_nazionale'];
    }
  }

  /// Ottiene i canali preferiti completi
  Future<List<TeletextChannel>> getFavoriteChannels() async {
    final favoriteIds = await getFavoriteChannelIds();
    final channels = <TeletextChannel>[];
    
    for (final id in favoriteIds) {
      final channel = TeletextChannels.getChannelById(id);
      if (channel != null) {
        channels.add(channel);
      }
    }
    
    return channels;
  }

  /// Salva la lista dei canali preferiti
  Future<void> saveFavoriteChannels(List<String> channelIds) async {
    final favoritesJson = json.encode(channelIds);
    await _prefs.setString(_favoritesKey, favoritesJson);
  }

  /// Aggiunge un canale ai preferiti
  Future<void> addFavorite(String channelId) async {
    final favorites = await getFavoriteChannelIds();
    if (!favorites.contains(channelId)) {
      favorites.add(channelId);
      await saveFavoriteChannels(favorites);
    }
  }

  /// Rimuove un canale dai preferiti
  Future<void> removeFavorite(String channelId) async {
    final favorites = await getFavoriteChannelIds();
    favorites.remove(channelId);
    
    // Assicurati che ci sia sempre almeno un preferito
    if (favorites.isEmpty) {
      favorites.add('rai_nazionale');
    }
    
    await saveFavoriteChannels(favorites);
  }

  /// Verifica se un canale è nei preferiti
  Future<bool> isFavorite(String channelId) async {
    final favorites = await getFavoriteChannelIds();
    return favorites.contains(channelId);
  }

  /// Riordina i canali preferiti
  Future<void> reorderFavorites(List<String> newOrder) async {
    await saveFavoriteChannels(newOrder);
  }

  /// Toggle stato preferito di un canale
  Future<bool> toggleFavorite(String channelId) async {
    final isFav = await isFavorite(channelId);
    
    if (isFav) {
      await removeFavorite(channelId);
      return false;
    } else {
      await addFavorite(channelId);
      return true;
    }
  }

  /// Ottiene il canale selezionato correntemente
  Future<String> getSelectedChannelId() async {
    return _prefs.getString(_selectedChannelKey) ?? 'rai_nazionale';
  }

  /// Salva il canale selezionato
  Future<void> setSelectedChannelId(String channelId) async {
    await _prefs.setString(_selectedChannelKey, channelId);
  }

  /// Ottiene il canale selezionato completo
  Future<TeletextChannel?> getSelectedChannel() async {
    final channelId = await getSelectedChannelId();
    return TeletextChannels.getChannelById(channelId);
  }

  /// Reset ai preferiti di default
  Future<void> resetToDefaults() async {
    await saveFavoriteChannels(['rai_nazionale']);
    await setSelectedChannelId('rai_nazionale');
  }
}

