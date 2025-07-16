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
            onPressed: () => _showFavoritesDialog(context),
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
    final currentRegion = context.read<RegionBloc>().state.selectedRegion;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('Preferiti'),
            const Spacer(),
            BlocBuilder<TelevideoBloc, TelevideoState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (page, currentSubPage) {
                    final isFavorite = FavoritesService().isFavorite(
                      page.pageNumber,
                      currentRegion?.code,
                    );
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        final favoritesService = FavoritesService();
                        if (isFavorite) {
                          favoritesService.removeFavorite(
                            FavoritePage(
                              pageNumber: page.pageNumber,
                              title: 'Pagina ${page.pageNumber}',
                              regionCode: currentRegion?.code,
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
                        }
                        Navigator.pop(context);
                        _showFavoritesDialog(context);
                      },
                    );
                  },
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: favorites.map((favorite) => ListTile(
              title: Text('${favorite.pageNumber} - ${favorite.title}'),
              subtitle: favorite.regionCode != null
                ? Text('Regione: ${favorite.regionCode}')
                : const Text('Nazionale'),
              onTap: () {
                if (favorite.regionCode != null) {
                  // Prima cambiamo regione
                  final region = Region.values.firstWhere(
                    (r) => r.code == favorite.regionCode,
                  );
                  context.read<RegionBloc>().add(
                    RegionEvent.selectRegion(region),
                  );
                  context.read<TelevideoBloc>().add(
                    TelevideoEvent.loadRegionalPage(region, favorite.pageNumber),
                  );
                } else {
                  context.read<RegionBloc>().add(
                    const RegionEvent.selectRegion(null),
                  );
                  context.read<TelevideoBloc>().add(
                    TelevideoEvent.loadNationalPage(favorite.pageNumber),
                  );
                }
                Navigator.pop(context);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  FavoritesService().removeFavorite(favorite);
                  Navigator.pop(context);
                  _showFavoritesDialog(context);
                },
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
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