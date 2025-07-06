import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

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
  StreamSubscription? _adEventSubscription;
  final AdService _adService = AdService();
  Offset _dragStart = Offset.zero;
  bool _isDragging = false;
  bool _isVerticalDrag = false;
  int _currentSubPage = 1;
  int _maxSubPages = 1;
  bool _wasLiveShowActive = false;

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

    // Sottoscrizione agli eventi degli annunci
    _adEventSubscription = _adService.adEventStream.listen((event) {
      switch (event) {
        case AdEvent.shown:
          // Salva lo stato del Live Show e lo ferma
          _wasLiveShowActive = _liveShowTimer != null;
          _liveShowTimer?.cancel();
          _liveShowTimer = null;
          break;
        case AdEvent.dismissed:
        case AdEvent.failed:
          // Ripristina il Live Show se era attivo
          if (_wasLiveShowActive) {
            _startLiveShowTimer();
          }
          break;
      }
    });

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
    _adEventSubscription?.cancel();
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
      final normalizedOffset = dragDistance.dy / screenSize.height;
      setState(() {
        _slideAnimation = Tween<Offset>(
          begin: Offset(0, normalizedOffset),
          end: Offset(0, normalizedOffset > 0 ? 1 : -1),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
      });
    } else {
      final normalizedOffset = dragDistance.dx / screenSize.width;
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
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    
    if (_isVerticalDrag) {
      if (velocity.abs() > 300) {
        if (velocity > 0) {
          // Swipe verso il basso - sottopagina precedente
          context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage());
        } else {
          // Swipe verso l'alto - sottopagina successiva
          context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
        }
      }
    } else {
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
      _isVerticalDrag = false;
    });

    // Riavvia il timer dopo il drag
    _startLiveShowTimer();
  }

  void _onTapUp(TapUpDetails details, Size imageSize) {
    if (_isDragging || !widget.isNationalMode) return;

    // Converti le coordinate del tap in coordinate relative all'immagine
    final box = context.findRenderObject() as RenderBox;
    //final localPosition = box.globalToLocal(details.globalPosition);
    final localPosition = details.localPosition;

    print('\n=== TAP DETECTED ===');
    print('Container size: ${imageSize.width} x ${imageSize.height}');
    print('Local tap position: (${localPosition.dx}, ${localPosition.dy})');
    
    // Con BoxFit.fill, dobbiamo calcolare il rapporto di scala per x e y separatamente
    //const originalWidth = 644.0; // Larghezza originale dell'immagine del Televideo
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
          widget.onPageNumberSubmitted!(area.targetPage);
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
            });
          },
          orElse: () {},
        );
      },
      child: GestureDetector(
        onVerticalDragStart: _onDragStart,
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragEnd: _onDragEnd,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: SlideTransition(
          position: _slideAnimation,
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
                      return state.maybeWhen(
                        loaded: (page, currentSubPage) => Image.network(
                          widget.page.imageUrl,
                          headers: const {
                            'Cache-Control': 'no-cache',
                            'Pragma': 'no-cache',
                          },
                          fit: BoxFit.fill,
                        ),
                        orElse: () => Image.network(
                          widget.page.imageUrl,
                          headers: const {
                            'Cache-Control': 'no-cache',
                            'Pragma': 'no-cache',
                          },
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 