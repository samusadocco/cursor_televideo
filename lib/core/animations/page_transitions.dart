import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slideHorizontal,
  slideVertical,
}

class AnimatedPageTransition extends StatelessWidget {
  final Widget child;
  final PageTransitionType type;
  final bool forward;
  final Duration duration;
  final Curve curve;

  const AnimatedPageTransition({
    super.key,
    required this.child,
    required this.type,
    this.forward = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: duration,
      curve: curve,
      tween: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ),
      builder: (context, double value, child) {
        switch (type) {
          case PageTransitionType.fade:
            return Opacity(
              opacity: value,
              child: child,
            );
          
          case PageTransitionType.slideHorizontal:
            return Transform.translate(
              offset: Offset(
                (forward ? 1.0 - value : value - 1.0) * MediaQuery.of(context).size.width,
                0.0,
              ),
              child: child,
            );
          
          case PageTransitionType.slideVertical:
            return Transform.translate(
              offset: Offset(
                0.0,
                (forward ? 1.0 - value : value - 1.0) * MediaQuery.of(context).size.height,
              ),
              child: child,
            );
        }
      },
      child: child,
    );
  }
} 