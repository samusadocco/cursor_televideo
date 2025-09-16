import 'package:flutter/material.dart';

class AutoRefreshOverlay extends StatelessWidget {
  final bool isVisible;
  final bool isPaused;

  const AutoRefreshOverlay({
    super.key,
    required this.isVisible,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Center(
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(
            isPaused ? Icons.pause : Icons.play_arrow,
            size: 48.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
