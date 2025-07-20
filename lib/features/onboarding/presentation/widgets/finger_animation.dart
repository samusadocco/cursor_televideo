import 'package:flutter/material.dart';

class FingerAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final Duration duration;
  final double angle;
  final Color color;
  final double size;

  const FingerAnimation({
    super.key,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(milliseconds: 800),
    this.angle = -0.5,
    this.color = Colors.white,
    this.size = 32,
  });

  @override
  State<FingerAnimation> createState() => _FingerAnimationState();
}

class _FingerAnimationState extends State<FingerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _controller.reset();
              _controller.forward();
            }
          });
        }
      });

    // Animazione della posizione: movimento verso il basso e ritorno
    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: widget.startPosition,
          end: widget.endPosition,
        ),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: widget.endPosition,
          end: widget.endPosition,
        ),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: widget.endPosition,
          end: widget.startPosition,
        ),
        weight: 30.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animazione dell'opacità: fade in/out
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 15.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 70.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 15.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animazione della scala: piccolo effetto di pressione
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 0.9),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0),
        weight: 30.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.rotate(
              angle: widget.angle,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.touch_app,
                    color: isDarkMode ? widget.color : Colors.black87,
                    size: widget.size,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 