import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' show lerpDouble;
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/televideo_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/region_selector.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/shortcuts_menu.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/settings_page.dart';
import 'package:cursor_televideo/shared/widgets/ad_banner.dart';
import 'package:cursor_televideo/shared/widgets/error_page_view.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';
import 'package:cursor_televideo/core/shortcuts/shortcuts_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/edit_description_dialog.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/page_number_indicator.dart';

// Funzione per determinare se il dispositivo è un tablet
bool isTablet(BuildContext context) {
  final data = MediaQuery.of(context);
  final shortestSide = data.size.shortestSide;
  return shortestSide >= 600;
}

// Funzione per configurare l'orientamento in base al tipo di dispositivo
void configureOrientation(BuildContext context) {
  if (isTablet(context)) {
    // Tablet: permetti entrambi gli orientamenti
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Telefono: solo orientamento verticale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _showControls = true;  // Sempre true, non più modificabile
  late TelevideoBloc _televideoBloc;
  late RegionBloc _regionBloc;
  final TextEditingController _pageNumberController = TextEditingController();
  final ValueNotifier<List<FavoritePage>> _favoritesNotifier = ValueNotifier<List<FavoritePage>>([]);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _televideoBloc = context.read<TelevideoBloc>()
      ..add(const TelevideoEvent.loadNationalPage(100));
    _regionBloc = RegionBloc();
    _favoritesNotifier.value = FavoritesService().getFavorites();
  }

  @override
  void dispose() {
    _televideoBloc.close();
    _regionBloc.close();
    _pageNumberController.dispose();
    _favoritesNotifier.dispose();
    super.dispose();
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
              if (!isNationalMode && selectedRegion != null) {
                // Se siamo in modalità regionale, carica direttamente la pagina regionale
                _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion, pageNumber));
              } else {
                // Se siamo in modalità nazionale, carica la pagina nazionale
                _televideoBloc.add(TelevideoEvent.loadNationalPage(pageNumber));
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
                if (!isNationalMode && selectedRegion != null) {
                  // Se siamo in modalità regionale, carica direttamente la pagina regionale
                  _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion, pageNumber));
                } else {
                  // Se siamo in modalità nazionale, carica la pagina nazionale
                  _televideoBloc.add(TelevideoEvent.loadNationalPage(pageNumber));
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      page.pageNumber,
                      regionCode: currentRegion?.code,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pagina rimossa dai preferiti'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    favoritesService.addFavorite(
                      page.pageNumber,
                      regionCode: currentRegion?.code,
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
          // Lista preferiti
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Lista preferiti',
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

  Widget _buildFavoriteItem(FavoritePage favorite, Animation<double> animation, BuildContext dialogContext) {
    final region = favorite.regionCode != null
        ? Region.values.firstWhere(
            (r) => r.code == favorite.regionCode,
            orElse: () => Region.values.first,
          )
        : null;

    return Container(
      key: ValueKey('${favorite.pageNumber}_${favorite.regionCode ?? "national"}'),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Dismissible(
            key: ValueKey('dismissible_${favorite.pageNumber}_${favorite.regionCode ?? "national"}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: dialogContext,
                builder: (confirmContext) => AlertDialog(
                  title: const Text('Conferma rimozione'),
                  content: Text(
                    'Vuoi davvero rimuovere ${favorite.displayDescription} dai preferiti?'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(confirmContext).pop(false),
                      child: const Text('ANNULLA'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(confirmContext).pop(true),
                      child: const Text('RIMUOVI'),
                    ),
                  ],
                ),
              ) ?? false;
            },
            onDismissed: (direction) async {
              await FavoritesService().removeFavorite(
                favorite.pageNumber,
                regionCode: favorite.regionCode,
              );
              _favoritesNotifier.value = FavoritesService().getFavorites();
            },
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.drag_handle),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset(
                          region?.imagePath ?? 'assets/images/italy.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${favorite.pageNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              title: Text(
                favorite.displayDescription,
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
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Modifica descrizione',
                onPressed: () {
                  showDialog<bool>(
                    context: dialogContext,
                    builder: (editContext) => EditDescriptionDialog(
                      pageNumber: favorite.pageNumber,
                      regionCode: favorite.regionCode,
                      initialDescription: favorite.description,
                      regionName: region?.name ?? 'Nazionale',
                    ),
                  ).then((saved) async {
                    if (saved == true) {
                      _favoritesNotifier.value = FavoritesService().getFavorites();
                    }
                  });
                },
              ),
              onTap: () {
                Navigator.of(dialogContext).pop();
                if (region != null) {
                  // Se è una pagina regionale
                  _regionBloc.add(RegionEvent.selectRegion(region));
                  // Carica direttamente la pagina regionale
                  _televideoBloc.add(TelevideoEvent.loadRegionalPage(region, favorite.pageNumber));
                } else {
                  // Se è una pagina nazionale
                  _regionBloc.add(const RegionEvent.selectRegion(null));
                  _televideoBloc.add(TelevideoEvent.loadNationalPage(favorite.pageNumber));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context) {
    _favoritesNotifier.value = FavoritesService().getFavorites();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        title: Row(
          children: [
            const Icon(Icons.favorite),
            const SizedBox(width: 8),
            const Text('Preferiti'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(dialogContext).pop(),
              tooltip: 'Chiudi',
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ValueListenableBuilder<List<FavoritePage>>(
            valueListenable: _favoritesNotifier,
            builder: (context, favorites, child) {
              return favorites.isEmpty
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
                  : ReorderableListView.builder(
                      buildDefaultDragHandles: true,
                      shrinkWrap: true,
                      proxyDecorator: (child, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            final double scale = lerpDouble(1, 1.02, animation.value)!;
                            final double elevation = lerpDouble(0, 8, animation.value)!;
                            return Transform.scale(
                              scale: scale,
                              child: Material(
                                elevation: elevation,
                                color: Theme.of(context).cardColor.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8),
                                child: child,
                              ),
                            );
                          },
                          child: child,
                        );
                      },
                      onReorderStart: (index) {
                        HapticFeedback.mediumImpact();
                      },
                      onReorderEnd: (index) {
                        HapticFeedback.lightImpact();
                      },
                      onReorder: (oldIndex, newIndex) async {
                        await FavoritesService().reorderFavorites(oldIndex, newIndex);
                        _favoritesNotifier.value = FavoritesService().getFavorites();
                      },
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = favorites[index];
                        return _buildFavoriteItem(
                          favorite,
                          const AlwaysStoppedAnimation(1.0),
                          dialogContext,
                        );
                      },
                    );
            },
          ),
        ),
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
                    icon: Icon(Icons.skip_previous, size: 32),
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
                      icon: Icon(Icons.skip_next, size: 32),
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
                              icon: Icon(Icons.arrow_downward, size: 32),
                              padding: EdgeInsets.zero,
                              onPressed: page.maxSubPages > 1 
                                ? () => context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage())
                                : null,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (page.maxSubPages > 1)
                              PageNumberIndicator(
                                pageNumber: page.pageNumber,
                                subPage: currentSubPage,
                                maxSubPages: page.maxSubPages,
                                duration: Duration(seconds: AppSettings.liveShowIntervalSeconds),
                                isAutoRefreshEnabled: AppSettings.liveShowEnabled,
                                onTap: () => _showPageNumberDialog(context, isNationalMode, regionState.selectedRegion),
                              ),
                            if (page.maxSubPages <= 1)
                              GestureDetector(
                                onTap: () => _showPageNumberDialog(context, isNationalMode, regionState.selectedRegion),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${page.pageNumber}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_upward, size: 32),
                              padding: EdgeInsets.zero,
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
    return OrientationBuilder(
      builder: (context, orientation) {
        // Riconfigura l'orientamento quando cambia l'orientamento dello schermo
        configureOrientation(context);
        
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
                            error: (message) => ErrorPageView(message: message),
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildBottomAppBar(),
                const AdBanner(),
              ],
            ),
          ),
        );
      },
    );
  }
} 