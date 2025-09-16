import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';

class PageNumberIndicator extends StatefulWidget {
  final int pageNumber;
  final int? subPage;
  final int? maxSubPages;
  final Duration duration;
  final bool isAutoRefreshEnabled;
  final bool isAutoRefreshPaused;
  final VoidCallback? onTap;

  const PageNumberIndicator({
    super.key,
    required this.pageNumber,
    this.subPage,
    this.maxSubPages,
    required this.duration,
    required this.isAutoRefreshEnabled,
    this.isAutoRefreshPaused = false,
    this.onTap,
  });

  @override
  State<PageNumberIndicator> createState() => _PageNumberIndicatorState();
}

class _PageNumberIndicatorState extends State<PageNumberIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _lastSubPage;
  StreamSubscription? _adEventSubscription;
  double _savedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Ascolta gli eventi degli annunci
    _adEventSubscription = AdService().adEventStream.listen((event) {
      switch (event) {
        case AdEvent.shown:
          // Quando l'annuncio viene mostrato, salviamo il progresso e fermiamo l'animazione
          if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused && widget.subPage != null) {
            _savedProgress = _controller.value;
            _controller.stop();
          }
          break;
        case AdEvent.dismissed:
          // Quando l'annuncio viene chiuso, riprendiamo dal punto salvato
          if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused && widget.subPage != null) {
            _controller.forward(from: _savedProgress);
          }
          break;
        default:
          break;
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _lastSubPage = widget.subPage;
    
    _animation.addListener(() {
      if (_animation.isCompleted) {
        // Non resettare subito l'animazione, aspetta che la pagina sia stata aggiornata
        if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused) {
          // Log del cambio automatico di sottopagina
          if (widget.subPage != null && widget.maxSubPages != null) {
            final nextSubPage = widget.subPage! >= widget.maxSubPages! ? 1 : widget.subPage! + 1;
            AnalyticsService().logSubpageChange(
              widget.pageNumber.toString(),
              nextSubPage.toString(),
              'auto_refresh',
            );
          }
        }
      }
    });

    if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused && widget.subPage != null) {
      _controller.forward();
    }
  }


  void _resetAndStart() {
    _controller.reset();
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(PageNumberIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Aggiorna la durata se necessario
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    // Se è cambiata la sottopagina, resetta e riavvia l'animazione
    if (widget.subPage != _lastSubPage) {
      _lastSubPage = widget.subPage;
      if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused && widget.subPage != null) {
        _resetAndStart();
      }
    }

    // Gestisci l'animazione in base allo stato di auto-refresh e pausa
    if (widget.isAutoRefreshEnabled && !widget.isAutoRefreshPaused && widget.subPage != null) {
      if (!_controller.isAnimating) {
        // Se l'animazione si è fermata (es. dopo un annuncio), riprendiamo dal punto salvato
        _controller.forward(from: _savedProgress);
      }
    } else {
      _controller.stop();
      if (!widget.isAutoRefreshEnabled) {
        _controller.reset();
      }
    }

    // Se lo stato di pausa è cambiato
    if (oldWidget.isAutoRefreshPaused != widget.isAutoRefreshPaused) {
      if (widget.isAutoRefreshPaused) {
        // Salva il progresso quando mettiamo in pausa
        _savedProgress = _controller.value;
        _controller.stop();
      } else if (widget.isAutoRefreshEnabled && widget.subPage != null) {
        // Quando usciamo dalla pausa, riprendiamo dal punto salvato
        _controller.forward(from: _savedProgress);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _adEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 50,  // Ridotto da 60 a 50
            height: 50, // Ridotto da 60 a 50
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Stack(
              children: [
                // Cerchio di sfondo
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      width: 1.5, // Ridotto da 2 a 1.5
                    ),
                  ),
                ),
                // Cerchio di progresso
                if (widget.isAutoRefreshEnabled && widget.subPage != null)
                  CustomPaint(
                    size: const Size(50, 50), // Ridotto da 60 a 50
                    painter: CircleProgressPainter(
                      progress: _animation.value,
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 1.5, // Ridotto da 2 a 1.5
                    ),
                  ),
                // Testo centrale
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.pageNumber.toString(),
                        style: const TextStyle(
                          fontSize: 20, // Mantenuto a 20
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.subPage != null && widget.maxSubPages != null)
                        Text(
                          '${widget.subPage}/${widget.maxSubPages}',
                          style: const TextStyle(
                            fontSize: 10, // Mantenuto a 10
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 1.5, // Ridotto da 2 a 1.5
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      -1.5708, // Inizia da -90 gradi (in alto)
      progress * 6.2832, // 2 * pi * progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}