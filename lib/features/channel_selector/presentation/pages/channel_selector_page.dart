import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/teletext/teletext_channels.dart';
import 'package:cursor_televideo/core/teletext/favorite_channels_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

class ChannelSelectorPage extends StatefulWidget {
  const ChannelSelectorPage({super.key});

  @override
  State<ChannelSelectorPage> createState() => _ChannelSelectorPageState();
}

class _ChannelSelectorPageState extends State<ChannelSelectorPage> {
  late FavoriteChannelsService _favoritesService;
  List<TeletextChannel> _favoriteChannels = [];
  List<TeletextChannel> _allChannels = [];
  List<TeletextChannel> _filteredChannels = [];
  String _searchQuery = '';
  bool _showAll = false;
  bool _isLoading = true;
  String? _selectedChannelId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    _favoritesService = FavoriteChannelsService(prefs);
    
    _allChannels = TeletextChannels.getActiveChannels();
    _favoriteChannels = await _favoritesService.getFavoriteChannels();
    _selectedChannelId = await _favoritesService.getSelectedChannelId();
    _filteredChannels = _allChannels;
    
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredChannels = _allChannels;
      } else {
        _filteredChannels = TeletextChannels.searchChannels(query);
      }
    });
  }

  Future<void> _toggleFavorite(TeletextChannel channel) async {
    final isFavorite = await _favoritesService.toggleFavorite(channel.id);
    
    // Ricarica i preferiti
    _favoriteChannels = await _favoritesService.getFavoriteChannels();
    
    setState(() {});
    
    // Mostra un feedback all'utente
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
                ? AppLocalizations.of(context)!.addedToFavorites(channel.flagEmoji, channel.name)
                : AppLocalizations.of(context)!.removedFromFavorites(channel.flagEmoji, channel.name),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _selectChannel(TeletextChannel channel) async {
    await _favoritesService.setSelectedChannelId(channel.id);
    if (mounted) {
      Navigator.pop(context, channel);
    }
  }

  bool _isFavorite(String channelId) {
    return _favoriteChannels.any((ch) => ch.id == channelId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.channelSelection),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.channelSelection),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra di ricerca
          _buildSearchBar(theme),
          
          // Contenuto scrollabile
          Expanded(
            child: ListView(
              children: [
                // Sezione Preferiti
                if (_favoriteChannels.isNotEmpty && !_showAll) ...[
                  _buildSectionHeader(
                    AppLocalizations.of(context)!.favoriteChannels,
                    theme,
                    trailing: _favoriteChannels.length > 1
                        ? TextButton.icon(
                            icon: const Icon(Icons.edit, size: 18),
                            label: Text(AppLocalizations.of(context)!.reorder),
                            onPressed: _showReorderDialog,
                          )
                        : null,
                  ),
                  _buildFavoritesList(theme),
                  const Divider(height: 32, thickness: 1),
                ],
                
                // Toggle "Mostra tutti"
                _buildShowAllToggle(theme),
                
                // Lista completa dei canali (se attivata)
                if (_showAll) ...[
                  _buildSectionHeader(AppLocalizations.of(context)!.allChannels, theme),
                  _buildAllChannelsList(theme),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchChannelOrCountry,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _onSearchChanged('');
                    // Clear the text field
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    ThemeData theme, {
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildFavoritesList(ThemeData theme) {
    if (_searchQuery.isNotEmpty) {
      final filtered = _favoriteChannels.where((channel) {
        return channel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            channel.broadcasterName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            channel.countryName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
      
      if (filtered.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context)!.noFavoriteChannelsFound,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
      
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return _buildChannelTile(filtered[index], theme, isFavoriteSection: true);
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _favoriteChannels.length,
      itemBuilder: (context, index) {
        return _buildChannelTile(_favoriteChannels[index], theme, isFavoriteSection: true);
      },
    );
  }

  Widget _buildShowAllToggle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: SwitchListTile(
          title: Text(AppLocalizations.of(context)!.showAllChannels),
          subtitle: Text(
            AppLocalizations.of(context)!.channelsAvailableFromCountries(_allChannels.length, TeletextChannels.getAvailableCountries().length),
          ),
          value: _showAll,
          onChanged: (value) {
            setState(() {
              _showAll = value;
            });
          },
          secondary: Icon(
            _showAll ? Icons.expand_less : Icons.expand_more,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAllChannelsList(ThemeData theme) {
    final channelsToShow = _searchQuery.isEmpty ? _allChannels : _filteredChannels;
    
    if (channelsToShow.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noChannelsFound,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Raggruppa per paese
    final channelsByCountry = <String, List<TeletextChannel>>{};
    for (final channel in channelsToShow) {
      channelsByCountry.putIfAbsent(channel.countryCode, () => []).add(channel);
    }

    final sortedCountries = channelsByCountry.keys.toList()
      ..sort((a, b) {
        final channelA = channelsByCountry[a]!.first;
        final channelB = channelsByCountry[b]!.first;
        return channelA.countryName.compareTo(channelB.countryName);
      });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedCountries.length,
      itemBuilder: (context, countryIndex) {
        final countryCode = sortedCountries[countryIndex];
        final countryChannels = channelsByCountry[countryCode]!;
        final firstChannel = countryChannels.first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del paese
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[200],
              child: Text(
                '${firstChannel.flagEmoji}  ${firstChannel.countryName}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Canali del paese
            ...countryChannels.map((channel) => _buildChannelTile(channel, theme)),
          ],
        );
      },
    );
  }

  Widget _buildChannelTile(
    TeletextChannel channel,
    ThemeData theme, {
    bool isFavoriteSection = false,
  }) {
    final isFav = _isFavorite(channel.id);
    final isSelected = channel.id == _selectedChannelId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 4 : 1,
      color: isSelected
          ? theme.primaryColor.withOpacity(0.1)
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          child: Text(
            channel.flagEmoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          channel.name,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(channel.broadcasterName),
            if (channel.supportsRegions == true)
              Text(
                AppLocalizations.of(context)!.regionsAvailable(channel.regions?.length ?? 0),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.primaryColor,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.star : Icons.star_border,
            color: isFav ? Colors.amber : Colors.grey,
          ),
          onPressed: () => _toggleFavorite(channel),
        ),
        onTap: () => _selectChannel(channel),
      ),
    );
  }

  void _showReorderDialog() {
    showDialog(
      context: context,
      builder: (context) => _ReorderFavoritesDialog(
        favoriteChannels: _favoriteChannels,
        onReorder: (newOrder) async {
          await _favoritesService.reorderFavorites(
            newOrder.map((ch) => ch.id).toList(),
          );
          _favoriteChannels = newOrder;
          setState(() {});
        },
      ),
    );
  }
}

/// Dialog per riordinare i canali preferiti
class _ReorderFavoritesDialog extends StatefulWidget {
  final List<TeletextChannel> favoriteChannels;
  final Function(List<TeletextChannel>) onReorder;

  const _ReorderFavoritesDialog({
    required this.favoriteChannels,
    required this.onReorder,
  });

  @override
  State<_ReorderFavoritesDialog> createState() => _ReorderFavoritesDialogState();
}

class _ReorderFavoritesDialogState extends State<_ReorderFavoritesDialog> {
  late List<TeletextChannel> _channels;

  @override
  void initState() {
    super.initState();
    _channels = List.from(widget.favoriteChannels);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.reorderFavorites),
      content: SizedBox(
        width: double.maxFinite,
        child: ReorderableListView.builder(
          shrinkWrap: true,
          itemCount: _channels.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) {
                newIndex--;
              }
              final item = _channels.removeAt(oldIndex);
              _channels.insert(newIndex, item);
            });
          },
          itemBuilder: (context, index) {
            final channel = _channels[index];
            return ListTile(
              key: ValueKey(channel.id),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.drag_handle),
                  const SizedBox(width: 8),
                  Text(
                    channel.flagEmoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              title: Text(channel.name),
              subtitle: Text(channel.broadcasterName),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onReorder(_channels);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}

