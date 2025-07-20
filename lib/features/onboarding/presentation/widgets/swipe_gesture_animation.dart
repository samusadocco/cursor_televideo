import 'package:flutter/material.dart';

class SwipeGestureAnimation extends StatefulWidget {
  final bool isHorizontal;

  const SwipeGestureAnimation({
    super.key,
    required this.isHorizontal,
  });

  @override
  State<SwipeGestureAnimation> createState() => _SwipeGestureAnimationState();
}

class _SwipeGestureAnimationState extends State<SwipeGestureAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animazione di scorrimento
    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: widget.isHorizontal ? const Offset(0.3, 0) : const Offset(0, 0.3),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: widget.isHorizontal ? const Offset(0.3, 0) : const Offset(0, 0.3),
          end: Offset.zero,
        ),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animazione di dissolvenza
    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 1.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.3),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Avvia l'animazione in loop
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Frecce di direzione
          if (widget.isHorizontal) ...[
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
          ] else ...[
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Icon(
                  Icons.arrow_upward,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
          ],
          // Dito animato
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _slideAnimation.value * 100,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.touch_app,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 