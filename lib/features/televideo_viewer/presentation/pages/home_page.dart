import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showControls = true;
  Region _selectedRegion = Region.values.first;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      title: BlocBuilder<TelevideoBloc, TelevideoState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Text('Televideo RAI'),
            loading: () => const Text('Televideo RAI'),
            loaded: (page) => Row(
              children: [
                const Text('Televideo RAI'),
                const SizedBox(width: 10),
                Text(
                  '- Pag. ${page.pageNumber}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  '(${page.region ?? 'Nazionale'})',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            error: (_) => const Text('Televideo RAI'),
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
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Nazionale'),
          Tab(text: 'Regionale'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TelevideoBloc(repository: TelevideoRepository())
        ..add(const TelevideoEvent.loadNationalPage(100)),
      child: Scaffold(
        appBar: _showControls
            ? AppBar(
                title: const Text('Televideo RAI'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Nazionale'),
                    Tab(text: 'Regionale'),
                  ],
                ),
              )
            : null,
        body: GestureDetector(
          onTap: _toggleControls,
          child: TabBarView(
            controller: _tabController,
            children: [
              BlocBuilder<TelevideoBloc, TelevideoState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(child: CircularProgressIndicator()),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (page) => TelevideoViewer(
                      page: page,
                      onPageNumberSubmitted: (pageNumber) {
                        context
                            .read<TelevideoBloc>()
                            .add(TelevideoEvent.loadNationalPage(pageNumber));
                      },
                      showControls: _showControls,
                    ),
                    error: (message) => Center(
                      child: Text(message),
                    ),
                  );
                },
              ),
              RegionSelector(
                selectedRegion: _selectedRegion,
                onRegionSelected: (region) {
                  setState(() {
                    _selectedRegion = region;
                  });
                  context.read<TelevideoBloc>().add(TelevideoEvent.loadRegionalPage(region));
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AdBanner(),
      ),
    );
  }
} 