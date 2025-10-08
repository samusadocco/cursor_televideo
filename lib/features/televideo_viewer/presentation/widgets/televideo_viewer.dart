import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/animations/page_transitions.dart';
import 'package:cursor_televideo/core/feedback/haptic_feedback_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/shared/widgets/error_page_view.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/auto_refresh_overlay.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

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
  Timer? _liveShowTimer;
  Timer? _refreshTimer;  // Timer per il refresh periodico
  final AdService _adService = AdService();
  StreamSubscription? _adEventSubscription;
  Offset _dragStart = Offset.zero;
  bool _isDragging = false;
  bool _isVerticalDrag = false;
  int _currentSubPage = 1;
  int _maxSubPages = 1;
  double _dragProgress = 0.0;
  bool _isRefreshing = false;
  bool _showPauseOverlay = false;
  Timer? _overlayTimer;
  DateTime? _timerStartTime;  // Quando è partito il timer corrente
  Duration _remainingTime = Duration.zero;  // Tempo rimanente quando in pausa

  @override
  void initState() {
    super.initState();

    // Ascolta gli eventi degli annunci
    _adEventSubscription = _adService.adEventStream.listen((event) {
      switch (event) {
        case AdEvent.shown:
          // Quando l'annuncio viene mostrato, salviamo il tempo rimanente e fermiamo il timer
          if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1) {
            _remainingTime = _getTimeRemaining();
            _liveShowTimer?.cancel();
            _refreshTimer?.cancel();
          }
          break;
        case AdEvent.dismissed:
          // Quando l'annuncio viene chiuso, riprendiamo dal tempo rimanente
          if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1) {
            _startLiveShowTimer();
          }
          break;
        default:
          break;
      }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
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

  void _performRefresh() {
    if (mounted && !_isDragging && !_adService.isShowingAd) {
      context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
      _timerStartTime = DateTime.now();
    }
  }

  void _startPeriodicTimer() {
    _timerStartTime = DateTime.now();
    _refreshTimer = Timer.periodic(
      Duration(seconds: AppSettings.liveShowIntervalSeconds),
      (timer) => _performRefresh()
    );
  }

  Duration _getTimeRemaining() {
    if (_timerStartTime == null) return Duration.zero;
    
    final elapsed = DateTime.now().difference(_timerStartTime!);
    final remaining = Duration(seconds: AppSettings.liveShowIntervalSeconds) - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  void dispose() {
    _controller.dispose();
    _liveShowTimer?.cancel();
    _refreshTimer?.cancel();
    _overlayTimer?.cancel();
    _adEventSubscription?.cancel();
    super.dispose();
  }

  void _startLiveShowTimer() {
    // Cancella i timer esistenti
    _liveShowTimer?.cancel();
    _refreshTimer?.cancel();

    // Verifica se il timer è in pausa
    final isPaused = context.read<TelevideoBloc>().state.maybeWhen(
      loaded: (_, __, isAutoRefreshPaused, ___) => isAutoRefreshPaused,
      orElse: () => false,
    );

    // Se è in pausa, non avviare il timer
    if (isPaused) return;

    // Avvia il timer solo se il Live Show è abilitato, ci sono sottopagine e non c'è un annuncio in corso
    if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1 && !_adService.isShowingAd) {
      if (_remainingTime > Duration.zero) {
        // Se c'è un tempo residuo dalla pausa, usa quello
        _liveShowTimer = Timer(_remainingTime, () {
          if (mounted) {
            _performRefresh();
            _remainingTime = Duration.zero;
            _startPeriodicTimer();
          }
        });
      } else {
        // Altrimenti parti subito con il timer periodico
        _startPeriodicTimer();
      }
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
            AnalyticsService().logSubpageChange(
              widget.page.pageNumber.toString(),
              (_currentSubPage - 1).toString(),
              'manual',
            );
          } else {
            // Swipe verso l'alto - sottopagina successiva
            HapticFeedbackService.success();
            context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
            AnalyticsService().logSubpageChange(
              widget.page.pageNumber.toString(),
              (_currentSubPage + 1).toString(),
              'manual',
            );
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
      }
    } else {
      if (velocity.abs() > 300 || _dragProgress.abs() > threshold) {
        if (velocity > 0 || _dragProgress > threshold) {
          // Swipe verso destra - pagina precedente
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.previousPage(currentPage: widget.page.pageNumber),
          );
          AnalyticsService().logTelevideoPageView(
            (widget.page.pageNumber - 1).toString(),
            'swipe',
          );
        } else {
          // Swipe verso sinistra - pagina successiva
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.nextPage(currentPage: widget.page.pageNumber),
          );
          AnalyticsService().logTelevideoPageView(
            (widget.page.pageNumber + 1).toString(),
            'swipe',
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

    final state = context.read<TelevideoBloc>().state;

    // Converti le coordinate del tap in coordinate relative all'immagine
    final localPosition = details.localPosition;
    
    // Con BoxFit.fill, dobbiamo calcolare il rapporto di scala per x e y separatamente
    const originalWidth = 360.0; // Larghezza originale dell'immagine del Televideo
    const originalHeight = 400.0; // Altezza originale dell'immagine del Televideo
    final scaleX = imageSize.width / originalWidth;
    final scaleY = imageSize.height / originalHeight;
    
    // Converti le coordinate del tap in coordinate dell'immagine originale
    final imageX = localPosition.dx / scaleX;
    final imageY = localPosition.dy / scaleY;
    
    // Verifica se il tap è su un'area cliccabile
    for (final area in widget.page.clickableAreas) {
      final bool isInArea = imageX >= area.x &&
          imageX <= (area.x + area.width) &&
          imageY >= area.y &&
          imageY <= (area.y + area.height);
      
      if (isInArea) {
        // Log dell'evento di navigazione tramite click
        AnalyticsService().logTelevideoPageView(
          area.targetPage.toString(),
          'link_click',
          sourcePageNumber: widget.page.pageNumber.toString(),
        );
        
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
        return; // Esce dalla funzione se è stata trovata un'area cliccabile
      }
    }

    // Se arriviamo qui, significa che il tap non è stato su un'area cliccabile
    
    // Verifica se ci sono sottopagine e se l'aggiornamento automatico è abilitato
    final hasSubPages = state.maybeWhen(
      loaded: (page, _, __, ___) => page.maxSubPages > 1,
      orElse: () => false,
    );
    if (!hasSubPages || !AppSettings.liveShowEnabled) return;

    // Invia l'evento di toggle della pausa
    context.read<TelevideoBloc>().add(const TelevideoEvent.toggleAutoRefreshPause());
    
    // Mostra l'overlay e imposta il timer per nasconderlo
    setState(() {
      _showPauseOverlay = true;
    });
    
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showPauseOverlay = false;
        });
      }
    });

    // Gestisci il timer in base allo stato di pausa
    final isPaused = state.maybeWhen(
      loaded: (_, __, isAutoRefreshPaused, ___) => !isAutoRefreshPaused, // Invertiamo perché lo stato non è ancora aggiornato
      orElse: () => false,
    );

    if (isPaused) {
      // Quando mettiamo in pausa, salviamo il tempo rimanente
      _remainingTime = _getTimeRemaining();
      _liveShowTimer?.cancel();
      _refreshTimer?.cancel();
    } else {
      _startLiveShowTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TelevideoBloc, TelevideoState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) {
            setState(() {
              _currentSubPage = currentSubPage;
              _maxSubPages = page.maxSubPages;
              _isRefreshing = false;
            });

            // Gestisci il timer in base allo stato di pausa
            if (isAutoRefreshPaused) {
              _liveShowTimer?.cancel();
            } else {
              _startLiveShowTimer();
            }
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
                          initial: (selectedChannel) => const Center(child: CircularProgressIndicator()),
                          loading: (pageNumber, selectedChannel) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.loadingPage(pageNumber),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) {
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
                                toggleAutoRefreshPause: () => transitionType = PageTransitionType.fade,
                                changeChannel: (_) => transitionType = PageTransitionType.fade,
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
                                    message: AppLocalizations.of(context)!.pageUnavailable,
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
                          error: (message, selectedChannel) => ErrorPageView(
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
                                toggleAutoRefreshPause: () {
                                  // Non fare nulla in questo caso
                                },
                                changeChannel: (channel) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.changeChannel(channel),
                                  );
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
          // Indicatore di caricamento
          if (_isRefreshing || context.watch<TelevideoBloc>().state.maybeWhen(
            loading: (_, __) => true,
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
          // Overlay di pausa/play
          BlocBuilder<TelevideoBloc, TelevideoState>(
            builder: (context, state) {
              final isPaused = state.maybeWhen(
                loaded: (_, __, isAutoRefreshPaused, ___) => isAutoRefreshPaused,
                orElse: () => false,
              );
              return AutoRefreshOverlay(
                isVisible: _showPauseOverlay,
                isPaused: isPaused,
              );
            },
          ),
        ],
      ),
    );
  }
}