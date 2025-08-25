import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/animations/page_transitions.dart';
import 'package:cursor_televideo/core/feedback/haptic_feedback_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/subpage_indicator.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/shared/widgets/error_page_view.dart';

class TelevideoViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int)? onPageNumberSubmitted;
  final bool showControls;
  final bool isNationalMode;

  const TelevideoViewer({
    super.key,
    required this.page,
    required this.onPageNumberSubmitted,
    required this.showControls,
    required this.isNationalMode,
  });

  @override
  State<TelevideoViewer> createState() => _TelevideoViewerState();
}

class _TelevideoViewerState extends State<TelevideoViewer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  Timer? _liveShowTimer;
  final AdService _adService = AdService();
  Offset _dragStart = Offset.zero;
  bool _isDragging = false;
  bool _isVerticalDrag = false;
  int _currentSubPage = 1;
  int _maxSubPages = 1;
  bool _wasLiveShowActive = false;
  double _dragProgress = 0.0;
  bool _isRefreshing = false;  // Nuovo stato per gestire il refresh

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
    
    // Inizializza i valori delle sottopagine
    _currentSubPage = widget.page.maxSubPages > 0 ? 1 : 0;
    _maxSubPages = widget.page.maxSubPages;

    // Avvia il timer per il Live Show se abilitato
    _startLiveShowTimer();
  }

  @override
  void didUpdateWidget(TelevideoViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      setState(() {
        _maxSubPages = widget.page.maxSubPages;
      });
      // Riavvia il timer quando cambia la pagina
      if (!_adService.isShowingAd) {
        _startLiveShowTimer();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _liveShowTimer?.cancel();
    super.dispose();
  }

  void _startLiveShowTimer() {
    // Cancella il timer esistente se presente
    _liveShowTimer?.cancel();

    // Avvia il timer solo se il Live Show è abilitato, ci sono sottopagine e non c'è un annuncio in corso
    if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1 && !_adService.isShowingAd) {
      _liveShowTimer = Timer.periodic(
        Duration(seconds: AppSettings.liveShowIntervalSeconds),
        (timer) {
          if (mounted && !_isDragging && !_adService.isShowingAd) {
            context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
          }
        }
      );
    }
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragStart = details.globalPosition;
    _dragProgress = 0.0;
    _isVerticalDrag = false;
    setState(() {});
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final dragDistance = details.globalPosition - _dragStart;
    final screenSize = MediaQuery.of(context).size;
    
    // Determina se il drag è principalmente orizzontale o verticale
    if (!_isVerticalDrag && dragDistance.distance > 10) {
      _isVerticalDrag = dragDistance.dy.abs() > dragDistance.dx.abs();
    }
    
    if (_isVerticalDrag) {
      _dragProgress = (dragDistance.dy / screenSize.height).clamp(-1.0, 1.0);
    } else {
      _dragProgress = (dragDistance.dx / screenSize.width).clamp(-1.0, 1.0);
    }
    
    setState(() {});
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    final threshold = 0.3; // Soglia per determinare se completare lo swipe
    
    if (_isVerticalDrag) {
      if (_maxSubPages > 1) {
        // Gestione normale delle sottopagine
        if (velocity.abs() > 300 || _dragProgress.abs() > threshold) {
          if (velocity > 0 || _dragProgress > threshold) {
            // Swipe verso il basso - sottopagina precedente
            HapticFeedbackService.success();
            context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage());
          } else {
            // Swipe verso l'alto - sottopagina successiva
            HapticFeedbackService.success();
            context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
          }
        }
      } else {
        // Gestione pagine senza sottopagine
        if (velocity > 0 && _dragProgress > 0) {  // Solo swipe verso il basso
          final regionState = context.read<RegionBloc>().state;
          
          // Imposta lo stato di refresh
          setState(() {
            _isRefreshing = true;
          });
          
          // Aspetta 0.5 secondi prima di ricaricare la pagina
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {  // Verifica che il widget sia ancora montato
              if (regionState.selectedRegion != null) {
                context.read<TelevideoBloc>().add(
                  TelevideoEvent.loadRegionalPage(
                    regionState.selectedRegion!,
                    widget.page.pageNumber,
                  ),
                );
              } else {
                context.read<TelevideoBloc>().add(
                  TelevideoEvent.loadNationalPage(widget.page.pageNumber),
                );
              }
              // Reset dello stato di refresh
              setState(() {
                _isRefreshing = false;
              });
            }
          });
        }
        // Ignora silenziosamente lo swipe verso l'alto
      }
    } else {
      if (velocity.abs() > 300 || _dragProgress.abs() > threshold) {
        if (velocity > 0 || _dragProgress > threshold) {
          // Swipe verso destra - pagina precedente
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.previousPage(currentPage: widget.page.pageNumber),
          );
        } else {
          // Swipe verso sinistra - pagina successiva
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.nextPage(currentPage: widget.page.pageNumber),
          );
        }
      }
    }
    
    _dragProgress = 0.0;
    _isVerticalDrag = false;
    setState(() {});

    // Riavvia il timer dopo il drag
    _startLiveShowTimer();
  }

  void _onTapUp(TapUpDetails details, Size imageSize) {
    if (_isDragging) return;

    // Converti le coordinate del tap in coordinate relative all'immagine
    final box = context.findRenderObject() as RenderBox;
    final localPosition = details.localPosition;

    print('\n=== TAP DETECTED ===');
    print('Container size: ${imageSize.width} x ${imageSize.height}');
    print('Local tap position: (${localPosition.dx}, ${localPosition.dy})');
    
    // Con BoxFit.fill, dobbiamo calcolare il rapporto di scala per x e y separatamente
    const originalWidth = 360.0; // Larghezza originale dell'immagine del Televideo
    const originalHeight = 400.0; // Altezza originale dell'immagine del Televideo
    final scaleX = imageSize.width / originalWidth;
    final scaleY = imageSize.height / originalHeight;
    
    // Converti le coordinate del tap in coordinate dell'immagine originale
    final imageX = localPosition.dx / scaleX;
    final imageY = localPosition.dy / scaleY;

    print('Scale factors: scaleX=$scaleX, scaleY=$scaleY');
    print('Converted tap coordinates on original image: ($imageX, $imageY)');
    
    print('\nAree cliccabili disponibili (${widget.page.clickableAreas.length}):');
    for (final area in widget.page.clickableAreas) {
      print('- Area per pagina ${area.targetPage}:');
      print('  Posizione: (${area.x}, ${area.y})');
      print('  Dimensioni: ${area.width} x ${area.height}');
      print('  Bounds: (${area.x},${area.y}) -> (${area.x + area.width},${area.y + area.height})');
      
      // Verifica se il tap è contenuto nell'area usando i punti estremi del rettangolo
      final bool isInArea = imageX >= area.x &&
          imageX <= (area.x + area.width) &&
          imageY >= area.y &&
          imageY <= (area.y + area.height);
      
      print('  Coordinate tap: ($imageX, $imageY)');
      print('  Area bounds: (${area.x}, ${area.y}) -> (${area.x + area.width}, ${area.y + area.height})');
      print('  Check bounds:');
      print('    X in range: ${imageX >= area.x} && ${imageX <= (area.x + area.width)}');
      print('    Y in range: ${imageY >= area.y} && ${imageY <= (area.y + area.height)}');
      print('  Tap contenuto nell\'area: ${isInArea ? 'SI' : 'NO'}');
      
      if (isInArea) {
        print('\n>>> MATCH TROVATO! Navigazione alla pagina ${area.targetPage}');
        if (widget.onPageNumberSubmitted != null) {
          if (widget.isNationalMode) {
            widget.onPageNumberSubmitted!(area.targetPage);
          } else {
            // In modalità regionale, manteniamo la regione corrente
            final regionCode = widget.page.region;
            if (regionCode != null) {
              final region = Region.values.firstWhere(
                (r) => r.code == regionCode,
                orElse: () => Region.values.first,
              );
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadRegionalPage(region, area.targetPage),
              );
            }
          }
        }
        break;
      }
    }
    print('=== FINE TAP ===\n');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TelevideoBloc, TelevideoState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (page, currentSubPage) {
            setState(() {
              _currentSubPage = currentSubPage;
              _maxSubPages = page.maxSubPages;
              _isRefreshing = false;  // Reset dello stato di refresh quando la pagina è caricata
            });
          },
          orElse: () {},
        );
      },
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapUp: (details) => _onTapUp(details, constraints.biggest),
                    child: BlocBuilder<TelevideoBloc, TelevideoState>(
                      builder: (context, state) {
                        Widget content = state.when(
                          initial: () => const Center(child: CircularProgressIndicator()),
                          loading: (pageNumber) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Caricamento pagina $pageNumber...',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loaded: (page, currentSubPage) {
                            final lastEvent = context.read<TelevideoBloc>().lastEvent;
                            var transitionType = PageTransitionType.fade;
                            var forward = true;

                            if (lastEvent != null) {
                              lastEvent.when(
                                loadNationalPage: (_) => transitionType = PageTransitionType.fade,
                                loadRegionalPage: (_, __) => transitionType = PageTransitionType.fade,
                                nextPage: (_) {
                                  transitionType = PageTransitionType.slideHorizontal;
                                  forward = true;
                                },
                                previousPage: (_) {
                                  transitionType = PageTransitionType.slideHorizontal;
                                  forward = false;
                                },
                                nextSubPage: () {
                                  transitionType = PageTransitionType.slideVertical;
                                  forward = true;
                                },
                                previousSubPage: () {
                                  transitionType = PageTransitionType.slideVertical;
                                  forward = false;
                                },
                                startLoading: () => transitionType = PageTransitionType.fade,
                              );
                            }

                            return AnimatedPageTransition(
                              type: transitionType,
                              forward: forward,
                              child: Image.network(
                                page.imageUrl,
                                headers: const {
                                  'Cache-Control': 'no-cache',
                                  'Pragma': 'no-cache',
                                },
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return ErrorPageView(
                                    message: 'Impossibile caricare l\'immagine della pagina.\nRiprova tra qualche istante.',
                                    onRetry: () {
                                      final regionState = context.read<RegionBloc>().state;
                                      if (regionState.selectedRegion != null) {
                                        context.read<TelevideoBloc>().add(
                                          TelevideoEvent.loadRegionalPage(
                                            regionState.selectedRegion!,
                                            page.pageNumber,
                                          ),
                                        );
                                      } else {
                                        context.read<TelevideoBloc>().add(
                                          TelevideoEvent.loadNationalPage(page.pageNumber),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          error: (message) => ErrorPageView(
                            message: message,
                            onRetry: () {
                              final regionState = context.read<RegionBloc>().state;
                              final lastEvent = context.read<TelevideoBloc>().lastEvent;
                              
                              lastEvent?.when(
                                loadNationalPage: (pageNumber) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.loadNationalPage(pageNumber),
                                  );
                                },
                                loadRegionalPage: (region, pageNumber) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.loadRegionalPage(region, pageNumber),
                                  );
                                },
                                nextPage: (currentPage) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.nextPage(currentPage: currentPage),
                                  );
                                },
                                previousPage: (currentPage) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.previousPage(currentPage: currentPage),
                                  );
                                },
                                nextSubPage: () {
                                  context.read<TelevideoBloc>().add(
                                    const TelevideoEvent.nextSubPage(),
                                  );
                                },
                                previousSubPage: () {
                                  context.read<TelevideoBloc>().add(
                                    const TelevideoEvent.previousSubPage(),
                                  );
                                },
                                startLoading: () {
                                  // Non fare nulla in questo caso
                                },
                              );
                            },
                          ),
                        );

                        // Applica la trasformazione durante il drag
                        if (_isDragging) {
                          return Transform.translate(
                            offset: _isVerticalDrag
                                ? Offset(0, _dragProgress * MediaQuery.of(context).size.height)
                                : Offset(_dragProgress * MediaQuery.of(context).size.width, 0),
                            child: content,
                          );
                        }

                        return content;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Indicatore delle sottopagine
          if (widget.showControls)
            Positioned(
              bottom: -8,
              left: 0,
              right: 0,
              child: Center(
                child: SubpageIndicator(
                  currentSubPage: _currentSubPage,
                  maxSubPages: _maxSubPages,
                ),
              ),
            ),
          // Indicatore di caricamento
          if (_isRefreshing || context.watch<TelevideoBloc>().state.maybeWhen(
            loading: (_) => true,
            orElse: () => false,
          ))
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 