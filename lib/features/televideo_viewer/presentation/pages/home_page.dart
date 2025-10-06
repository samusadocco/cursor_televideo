import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' show lerpDouble;
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
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
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/shared/models/favorite_page.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/edit_description_dialog.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/page_number_indicator.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';

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
  List<FavoritePage> _favorites = [];

  @override
  void initState() {
    super.initState();
    _regionBloc = RegionBloc();
    _televideoBloc = context.read<TelevideoBloc>()..setRegionBloc(_regionBloc);
    
    // Log dell'apertura dell'app
    AnalyticsService().logAppOpen();
    AnalyticsService().logPageView('HomePage');
  }

  @override
  void dispose() {
    _regionBloc.close();
    _pageNumberController.dispose();
    super.dispose();
  }

  Future<void> _showPageNumberDialog(BuildContext context, bool isNationalMode, Region? selectedRegion) async {
    final minPage = context.read<TelevideoBloc>().minPage;
    _pageNumberController.clear();
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.enterPageNumber ?? 'Enter page number'),
        content: TextField(
          controller: _pageNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.pageNumberRange(minPage) ?? 'Number from $minPage to 999',
            border: OutlineInputBorder(),
            errorMaxLines: 2,
          ),
          autofocus: true,
          onSubmitted: (value) {
            final pageNumber = int.tryParse(value);
            if (pageNumber != null && pageNumber >= minPage && pageNumber <= 999) {
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
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              final pageNumber = int.tryParse(_pageNumberController.text);
              if (pageNumber != null && pageNumber >= minPage && pageNumber <= 999) {
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
            child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
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
                    final minPage = context.read<TelevideoBloc>().minPage;
                    _televideoBloc.add(TelevideoEvent.loadNationalPage(minPage));
                  } else {
                    _regionBloc.add(RegionEvent.selectRegion(region));
                    _televideoBloc.add(TelevideoEvent.loadRegionalPage(region, 300));
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
                  loaded: (page, currentSubPage, isAutoRefreshPaused) {
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
                loaded: (page, currentSubPage, isAutoRefreshPaused) {
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
                      SnackBar(
                        content: Text(AppLocalizations.of(context)?.pageRemovedFromFavorites ?? 'Page removed from favorites'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    favoritesService.addFavorite(
                      page.pageNumber,
                      regionCode: currentRegion?.code,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)?.pageAddedToFavorites ?? 'Page added to favorites'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  setState(() {}); // Forza l'aggiornamento dell'icona
                },
                orElse: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)?.noPageToAddToFavorites ?? 'No page to add to favorites'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
          // Lista preferiti
          IconButton(
            icon: const Icon(Icons.list),
              tooltip: AppLocalizations.of(context)?.favoritesList ?? 'Favorites list',
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

  Widget _buildFavoriteItem(
    FavoritePage favorite,
    Animation<double> animation,
    BuildContext dialogContext,
    StateSetter setDialogState,
  ) {
    final region = favorite.regionCode != null
        ? Region.values.firstWhere(
            (r) => r.code == favorite.regionCode,
            orElse: () => Region.values.first,
          )
        : null;

    // Creiamo una chiave univoca per l'elemento che non cambia durante il riordino
    final itemKey = ObjectKey(favorite);

    return Container(
      key: itemKey, // Usiamo la stessa chiave per il Container
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Dismissible(
            key: itemKey, // Riusiamo la stessa chiave per il Dismissible
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
                  title: Text(AppLocalizations.of(context)?.confirmRemoval ?? 'Confirm removal'),
                  content: Text(
                    AppLocalizations.of(context)?.confirmRemoveFromFavorites(favorite.displayDescription) ?? 'Do you really want to remove ${favorite.displayDescription} from favorites?'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(confirmContext).pop(false),
                      child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(confirmContext).pop(true),
                      child: Text(AppLocalizations.of(context)?.remove ?? 'Remove'),
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
              setDialogState(() {
                _favorites = FavoritesService().getFavorites();
              });
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
                tooltip: AppLocalizations.of(context)?.edit ?? 'Edit',
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
                      setDialogState(() {
                        _favorites = FavoritesService().getFavorites();
                      });
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
    _favorites = FavoritesService().getFavorites();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          title: Row(
            children: [
              const Icon(Icons.favorite),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)?.favoritesList ?? 'Favorites list'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
                tooltip: AppLocalizations.of(context)?.close ?? 'Close',
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7, // Limitiamo l'altezza al 70% dello schermo
            child: _favorites.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)?.noFavorites ?? 'No favorites',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)?.useFavoriteIcon ?? 'Use the ❤️ icon to add pages to favorites',
                            style: const TextStyle(
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
                    key: const ValueKey('favorites_list'),
                    buildDefaultDragHandles: true,
                    physics: const AlwaysScrollableScrollPhysics(), // Abilitiamo lo scroll
                    shrinkWrap: false, // Disabilitiamo shrinkWrap
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
                      setDialogState(() {
                        _favorites = FavoritesService().getFavorites();
                      });
                    },
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = _favorites[index];
                      return _buildFavoriteItem(
                        favorite,
                        const AlwaysStoppedAnimation(1.0),
                        dialogContext,
                        setDialogState,
                      );
                    },
                  ),
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
                loaded: (page, currentSubPage, isAutoRefreshPaused) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous, size: 32),
                    onPressed: () {
                      context.read<TelevideoBloc>().add(TelevideoEvent.previousPage(currentPage: page.pageNumber));
                      AnalyticsService().logTelevideoPageView(
                        (page.pageNumber - 1).toString(),
                        'button',
                      );
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
                loaded: (page, currentSubPage, isAutoRefreshPaused) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_next, size: 32),
                      onPressed: () {
                        context.read<TelevideoBloc>().add(TelevideoEvent.nextPage(currentPage: page.pageNumber));
                        AnalyticsService().logTelevideoPageView(
                          (page.pageNumber + 1).toString(),
                          'button',
                        );
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
                  loading: (pageNumber) => Text(
                    '...$pageNumber...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  loaded: (page, currentSubPage, isAutoRefreshPaused) => Row(
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
                                ? () {
                                    context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage());
                                    AnalyticsService().logSubpageChange(
                                      page.pageNumber.toString(),
                                      (currentSubPage - 1).toString(),
                                      'manual',
                                    );
                                  }
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
                                isAutoRefreshPaused: isAutoRefreshPaused,
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
                                ? () {
                                    context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
                                    AnalyticsService().logSubpageChange(
                                      page.pageNumber.toString(),
                                      (currentSubPage + 1).toString(),
                                      'manual',
                                    );
                                  }
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
                            loading: (pageNumber) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)?.loadingPage(pageNumber) ?? 'Loading page $pageNumber...',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loaded: (page, currentSubPage, isAutoRefreshPaused) => TelevideoViewer(
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