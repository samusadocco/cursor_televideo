import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

class TelevideoViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int) onPageNumberSubmitted;
  final bool showControls;

  const TelevideoViewer({
    super.key,
    required this.page,
    required this.onPageNumberSubmitted,
    required this.showControls,
  });

  @override
  State<TelevideoViewer> createState() => _TelevideoViewerState();
}

class _TelevideoViewerState extends State<TelevideoViewer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Offset _dragStart = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final dragDistance = details.globalPosition.dx - _dragStart.dx;
    final screenWidth = MediaQuery.of(context).size.width;
    final normalizedOffset = dragDistance / screenWidth;
    
    setState(() {
      _slideAnimation = Tween<Offset>(
        begin: Offset(normalizedOffset, 0),
        end: Offset(normalizedOffset > 0 ? 1 : -1, 0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 300) {
      if (velocity > 0) {
        // Swipe verso destra - pagina precedente
        context.read<TelevideoBloc>().add(
          TelevideoEvent.previousPage(currentPage: widget.page.pageNumber),
        );
      } else {
        // Swipe verso sinistra - pagina successiva
        context.read<TelevideoBloc>().add(
          TelevideoEvent.nextPage(currentPage: widget.page.pageNumber),
        );
      }
    }
    
    _controller.forward().then((_) {
      _controller.reset();
      setState(() {
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showControls)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Numero Pagina',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                final pageNumber = int.tryParse(value);
                if (pageNumber != null) {
                  widget.onPageNumberSubmitted(pageNumber);
                }
              },
            ),
          ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: AppSettings.cacheDurationInSeconds > 0
                    ? CachedNetworkImage(
                        imageUrl: widget.page.imageUrl,
                        fit: BoxFit.fill,
                        cacheManager: CacheManager(
                          Config(
                            'televideo_cache',
                            stalePeriod: Duration(seconds: AppSettings.cacheDurationInSeconds),
                            maxNrOfCacheObjects: 100,
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Errore nel caricamento della pagina ${widget.page.pageNumber}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Image.network(
                        widget.page.imageUrl,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'Errore nel caricamento della pagina ${widget.page.pageNumber}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 