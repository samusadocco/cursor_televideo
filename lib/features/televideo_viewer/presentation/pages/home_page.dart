import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/televideo_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/region_selector.dart';
import 'package:cursor_televideo/features/settings/presentation/pages/settings_page.dart';
import 'package:cursor_televideo/shared/widgets/ad_banner.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/network/televideo_repository.dart';

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
                _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion));
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
                  _televideoBloc.add(TelevideoEvent.loadRegionalPage(selectedRegion));
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
      title: BlocBuilder<RegionBloc, RegionState>(
        builder: (context, regionState) {
          final isNationalMode = regionState.selectedRegion == null;
          return Row(
            children: [
              UnifiedSelector(
                selectedRegion: regionState.selectedRegion,
                onSelectionChanged: (region) {
                  print('[HomePage] onSelectionChanged called with region: $region');
                  
                  // Prima aggiorniamo lo stato della regione
                  print('[HomePage] Dispatching RegionEvent.selectRegion');
                  context.read<RegionBloc>().add(RegionEvent.selectRegion(region));
                  
                  // Poi carichiamo la pagina appropriata
                  if (region != null) {
                    print('[HomePage] Loading regional page for: $region');
                    // Se selezioniamo una regione, carichiamo direttamente la pagina regionale
                    context.read<TelevideoBloc>().add(TelevideoEvent.loadRegionalPage(region));
                  } else {
                    print('[HomePage] Loading national page 100');
                    // Se torniamo alla modalità nazionale, carichiamo sempre la pagina 100
                    context.read<TelevideoBloc>().add(const TelevideoEvent.loadNationalPage(100));
                  }
                },
              ),
              Expanded(
                child: BlocBuilder<TelevideoBloc, TelevideoState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox(),
                      loading: () => const Center(
                        child: Text(
                          'Caricamento...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      loaded: (page, currentSubPage) => Center(
                        child: GestureDetector(
                          onTap: () => _showPageNumberDialog(context, isNationalMode, regionState.selectedRegion),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Pag. ${page.pageNumber}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                if (page.maxSubPages > 1) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '($currentSubPage/${page.maxSubPages})',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 3.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      error: (message) => const Center(
                        child: Text(
                          'Errore',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Aggiungiamo un SizedBox della stessa larghezza del selettore per bilanciare
              SizedBox(width: 56), // Larghezza approssimativa del UnifiedSelector
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
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
        body: GestureDetector(
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
        bottomNavigationBar: const AdBanner(),
      ),
    );
  }
} 