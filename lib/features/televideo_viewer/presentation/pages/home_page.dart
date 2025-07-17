import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/televideo_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/region_selector.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/shortcuts_menu.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/settings_page.dart';
import 'package:cursor_televideo/shared/widgets/ad_banner.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/shortcuts/shortcuts_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showControls = true;
  late TelevideoBloc _televideoBloc;
  late RegionBloc _regionBloc;
  final TextEditingController _pageNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _televideoBloc = TelevideoBloc(repository: TelevideoRepository())
      ..add(const TelevideoEvent.loadNationalPage(100));
    _regionBloc = RegionBloc();
  }

  @override
  void dispose() {
    _televideoBloc.close();
    _regionBloc.close();
    _pageNumberController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  Future<void> _showPageNumberDialog(BuildContext context, bool isNationalMode, Region? selectedRegion) async {
    _pageNumberController.clear();
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Inserisci numero pagina'),
        content: TextField(
          controller: _pageNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: const InputDecoration(
            hintText: 'Numero da 100 a 999',
            border: OutlineInputBorder(),
            errorMaxLines: 2,
          ),
          autofocus: true,
          onSubmitted: (value) {
            final pageNumber = int.tryParse(value);
            if (pageNumber != null && pageNumber >= 100 && pageNumber <= 999) {
              Navigator.of(dialogContext).pop();
              _televideoBloc.add(TelevideoEvent.loadNationalPage(pageNumber));
              if (!isNationalMode && selectedRegion != null) {
                _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion, pageNumber));
              }
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              final pageNumber = int.tryParse(_pageNumberController.text);
              if (pageNumber != null && pageNumber >= 100 && pageNumber <= 999) {
                Navigator.of(dialogContext).pop();
                _televideoBloc.add(TelevideoEvent.loadNationalPage(pageNumber));
                if (!isNationalMode && selectedRegion != null) {
                  _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion, pageNumber));
                }
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!_showControls) return null;

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Shortcuts
          BlocBuilder<RegionBloc, RegionState>(
            builder: (context, regionState) {
              return ShortcutsMenu(
                isNational: regionState.selectedRegion == null,
                selectedRegion: regionState.selectedRegion,
                onNationalPageSelected: (pageNumber) {
                  _televideoBloc.add(TelevideoEvent.loadNationalPage(pageNumber));
                },
                onRegionalPageSelected: (pageNumber, region) {
                  _televideoBloc.add(TelevideoEvent.loadRegionalPage(region, pageNumber));
                },
              );
            },
          ),
          // Selezione Nazionale/Regionale
          BlocBuilder<RegionBloc, RegionState>(
            builder: (context, regionState) {
              return UnifiedSelector(
                selectedRegion: regionState.selectedRegion,
                onSelectionChanged: (region) {
                  if (region == null) {
                    _regionBloc.add(const RegionEvent.selectRegion(null));
                    _televideoBloc.add(const TelevideoEvent.loadNationalPage(100));
                  } else {
                    _regionBloc.add(RegionEvent.selectRegion(region));
                    _televideoBloc
                      ..add(const TelevideoEvent.loadNationalPage(300))
                      ..add(TelevideoEvent.loadRegionalPage(region, 300));
                  }
                },
              );
            },
          ),
          // Preferiti
          Row(
            children: [
              IconButton(
                icon: BlocBuilder<TelevideoBloc, TelevideoState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (page, currentSubPage) {
                        final isFavorite = FavoritesService().isFavorite(
                          page.pageNumber,
                          _regionBloc.state.selectedRegion?.code,
                        );
                        return Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        );
                      },
                      orElse: () => const Icon(Icons.favorite_border),
                    );
                  },
                ),
                onPressed: () {
                  final state = _televideoBloc.state;
                  final currentRegion = _regionBloc.state.selectedRegion;
                  
                  state.maybeWhen(
                    loaded: (page, currentSubPage) {
                      final favoritesService = FavoritesService();
                      final isFavorite = favoritesService.isFavorite(
                        page.pageNumber,
                        currentRegion?.code,
                      );

                      if (isFavorite) {
                        favoritesService.removeFavorite(
                          FavoritePage(
                            pageNumber: page.pageNumber,
                            title: 'Pagina ${page.pageNumber}',
                            regionCode: currentRegion?.code,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pagina rimossa dai preferiti'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        favoritesService.addFavorite(
                          FavoritePage(
                            pageNumber: page.pageNumber,
                            title: 'Pagina ${page.pageNumber}',
                            regionCode: currentRegion?.code,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pagina aggiunta ai preferiti'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                      setState(() {}); // Forza l'aggiornamento dell'icona
                    },
                    orElse: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nessuna pagina da aggiungere ai preferiti'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: 'Lista preferiti',
                onPressed: () => _showFavoritesDialog(context),
              ),
            ],
          ),
          // Impostazioni
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context) {
    final favorites = FavoritesService().getFavorites();
    // Otteniamo i bloc prima di mostrare il dialog
    final regionBloc = context.read<RegionBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Preferiti'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: favorites.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nessun preferito salvato',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Usa l\'icona ❤️ per aggiungere pagine ai preferiti',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: favorites.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    final region = favorite.regionCode != null
                        ? Region.values.firstWhere(
                            (r) => r.code == favorite.regionCode,
                            orElse: () => Region.values.first,
                          )
                        : null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          region != null ? Icons.location_on : Icons.public,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(
                        'Pagina ${favorite.pageNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        region?.name ?? 'Nazionale',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Rimuovi dai preferiti',
                        onPressed: () {
                          showDialog(
                            context: dialogContext,
                            builder: (confirmContext) => AlertDialog(
                              title: const Text('Conferma rimozione'),
                              content: Text(
                                'Vuoi davvero rimuovere la pagina ${favorite.pageNumber} dai preferiti?'
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(confirmContext).pop(),
                                  child: const Text('ANNULLA'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(confirmContext).pop();
                                    FavoritesService().removeFavorite(favorite);
                                    Navigator.of(dialogContext).pop();
                                    _showFavoritesDialog(context);
                                  },
                                  child: const Text('RIMUOVI'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () async {
                        Navigator.of(dialogContext).pop();
                        if (region != null) {
                          // Se è una pagina regionale
                          regionBloc.add(RegionEvent.selectRegion(region));
                          // Aspettiamo che il RegionBloc si aggiorni
                          await Future.delayed(const Duration(milliseconds: 100));
                          if (!mounted) return;
                          _televideoBloc.add(TelevideoEvent.loadRegionalPage(region, favorite.pageNumber));
                        } else {
                          // Se è una pagina nazionale
                          regionBloc.add(const RegionEvent.selectRegion(null));
                          // Aspettiamo che il RegionBloc si aggiorni
                          await Future.delayed(const Duration(milliseconds: 100));
                          if (!mounted) return;
                          _televideoBloc.add(TelevideoEvent.loadNationalPage(favorite.pageNumber));
                        }
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('CHIUDI'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      height: 60,
      child: AppBar(
        leading: BlocBuilder<TelevideoBloc, TelevideoState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (page, currentSubPage) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, size: 40),
                    onPressed: () {
                      context.read<TelevideoBloc>().add(TelevideoEvent.previousPage(currentPage: page.pageNumber));
                    },
                  ),
                ],
              ),
              orElse: () => const SizedBox(),
            );
          },
        ),
        actions: [
          BlocBuilder<TelevideoBloc, TelevideoState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (page, currentSubPage) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_next, size: 40),
                      onPressed: () {
                        context.read<TelevideoBloc>().add(TelevideoEvent.nextPage(currentPage: page.pageNumber));
                      },
                    ),
                  ],
                ),
                orElse: () => const SizedBox(),
              );
            },
          ),
        ],
        title: BlocBuilder<RegionBloc, RegionState>(
          builder: (context, regionState) {
            final isNationalMode = regionState.selectedRegion == null;
            return BlocBuilder<TelevideoBloc, TelevideoState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox(),
                  loading: () => Text(
                    'Caricamento...',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  loaded: (page, currentSubPage) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_downward, size: 40),
                              onPressed: page.maxSubPages > 1 
                                ? () => context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage())
                                : null,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _showPageNumberDialog(context, isNationalMode, regionState.selectedRegion),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Pagina ${page.pageNumber}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (page.maxSubPages > 1) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '/ $currentSubPage/${page.maxSubPages}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              const SizedBox(width: 4),
                              Icon(
                                Icons.edit,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_upward, size: 40),
                              onPressed: page.maxSubPages > 1 
                                ? () => context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage())
                                : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  error: (message) => Text(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _televideoBloc),
        BlocProvider.value(value: _regionBloc),
      ],
      child: Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _toggleControls,
                  child: BlocBuilder<RegionBloc, RegionState>(
                    builder: (context, regionState) {
                      return BlocBuilder<TelevideoBloc, TelevideoState>(
                        builder: (context, state) {
                          return state.when(
                            initial: () => const Center(child: CircularProgressIndicator()),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            loaded: (page, currentSubPage) => TelevideoViewer(
                              page: page,
                              onPageNumberSubmitted: (pageNumber) {
                                context.read<TelevideoBloc>().add(TelevideoEvent.loadNationalPage(pageNumber));
                              },
                              showControls: _showControls,
                              isNationalMode: regionState.selectedRegion == null,
                            ),
                            error: (message) => Center(
                              child: Text(message),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              if (_showControls) _buildBottomAppBar(),
              const AdBanner(),
            ],
          ),
        ),
    );
  }
} 