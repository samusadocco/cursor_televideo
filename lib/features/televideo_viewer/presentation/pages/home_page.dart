import 'package:flutter/material.dart';
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
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    if (!_showControls) return null;

    return AppBar(
      title: BlocBuilder<RegionBloc, RegionState>(
        builder: (context, regionState) {
          return Row(
            children: [
              UnifiedSelector(
                selectedRegion: regionState.selectedRegion,
                onSelectionChanged: (region) {
                  // Prima aggiorniamo lo stato della regione
                  context.read<RegionBloc>().add(RegionEvent.selectRegion(region));
                  
                  // Poi carichiamo la pagina appropriata
                  if (region != null) {
                    context.read<TelevideoBloc>().add(TelevideoEvent.loadRegionalPage(region));
                  } else {
                    context.read<TelevideoBloc>().add(const TelevideoEvent.loadNationalPage(100));
                  }
                },
              ),
              const SizedBox(width: 16),
              BlocBuilder<TelevideoBloc, TelevideoState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox(),
                    loading: () => const SizedBox(),
                    loaded: (page) => Text(
                      'Pag. ${page.pageNumber}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    error: (_) => const SizedBox(),
                  );
                },
              ),
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
                    loaded: (page) => TelevideoViewer(
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