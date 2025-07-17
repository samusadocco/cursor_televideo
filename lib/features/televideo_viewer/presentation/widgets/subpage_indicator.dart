import 'package:flutter/material.dart';

class SubpageIndicator extends StatelessWidget {
  final int currentSubPage;
  final int maxSubPages;
  final double size;

  const SubpageIndicator({
    super.key,
    required this.currentSubPage,
    required this.maxSubPages,
    this.size = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (maxSubPages <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxSubPages, (index) {
          final isActive = index + 1 == currentSubPage;
          return Container(
            width: size,
            height: size,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }
} 