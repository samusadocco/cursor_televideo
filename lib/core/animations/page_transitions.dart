import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slideHorizontal,
  slideVertical,
}

class AnimatedPageTransition extends StatefulWidget {
  final Widget child;
  final PageTransitionType type;
  final bool forward;
  final Object contentKey;
  final Duration duration;
  final Curve curve;

  const AnimatedPageTransition({
    super.key,
    required this.child,
    required this.type,
    required this.contentKey,
    this.forward = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedPageTransition> createState() => _AnimatedPageTransitionState();
}

class _AnimatedPageTransitionState extends State<AnimatedPageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Object? _animatedContentKey;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _animatedContentKey = widget.contentKey;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }

    if (widget.contentKey != _animatedContentKey) {
      _animatedContentKey = widget.contentKey;
      _controller.forward(from: 0);
      return;
    }

    // Stesso contenuto (es. aggiornamento OCR): niente re-animazione.
    if (_controller.status != AnimationStatus.completed) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTransitionChild(double value, Widget? child) {
    switch (widget.type) {
      case PageTransitionType.fade:
        return Opacity(
          opacity: value,
          child: child,
        );
      case PageTransitionType.slideHorizontal:
        return Transform.translate(
          offset: Offset(
            (widget.forward ? 1.0 - value : value - 1.0) *
                MediaQuery.of(context).size.width,
            0.0,
          ),
          child: child,
        );
      case PageTransitionType.slideVertical:
        return Transform.translate(
          offset: Offset(
            0.0,
            (widget.forward ? 1.0 - value : value - 1.0) *
                MediaQuery.of(context).size.height,
          ),
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => _buildTransitionChild(_animation.value, child),
    );
  }
}
