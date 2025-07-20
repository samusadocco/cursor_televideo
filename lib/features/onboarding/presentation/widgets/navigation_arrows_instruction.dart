import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/finger_animation.dart';

class NavigationArrowsInstruction extends StatelessWidget {
  const NavigationArrowsInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    final fingerColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Animazione tap sulla freccia sinistra
          FingerAnimation(
            startPosition: const Offset(40, 20),
            endPosition: const Offset(40, 30),
            angle: -0.3,
            duration: const Duration(milliseconds: 800),
            color: fingerColor,
          ),
          // Animazione tap sulla freccia destra (con ritardo)
          FingerAnimation(
            startPosition: const Offset(260, 20),
            endPosition: const Offset(260, 30),
            angle: -0.3,
            duration: const Duration(milliseconds: 800),
            color: fingerColor,
          ),
        ],
      ),
    );
  }
} 