import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/bottom_bar_instruction.dart';

class BottomBarInstructionWithTimer extends StatelessWidget {
  final BottomBarHighlight highlight;
  final bool showPauseOverlay;

  const BottomBarInstructionWithTimer({
    super.key,
    required this.highlight,
    this.showPauseOverlay = false,
  });

  Widget _buildHighlightedContainer({
    required Widget child,
    required bool isHighlighted,
  }) {
    return Container(
      decoration: isHighlighted
          ? BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            )
          : null,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarTheme.color,
      ),
      child: Row(
        children: [
          // Freccia sinistra
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHighlightedContainer(
                  isHighlighted: highlight == BottomBarHighlight.horizontalNavigation,
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      size: 32,
                      color: highlight == BottomBarHighlight.horizontalNavigation
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color?.withOpacity(0.3),
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
          // Frecce verticali e numero pagina
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildHighlightedContainer(
                        isHighlighted: highlight == BottomBarHighlight.verticalNavigation,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_downward,
                            size: 32,
                            color: highlight == BottomBarHighlight.verticalNavigation
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color?.withOpacity(0.3),
                          ),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildHighlightedContainer(
                    isHighlighted: highlight == BottomBarHighlight.pageSelector,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Cerchio di sfondo
                        Stack(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            if (showPauseOverlay)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // Cerchio di progresso
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: 0.7,
                            strokeWidth: 1.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        // Testo centrale
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '103',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: highlight == BottomBarHighlight.pageSelector
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              '1/2',
                              style: TextStyle(
                                fontSize: 10,
                                color: highlight == BottomBarHighlight.pageSelector
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildHighlightedContainer(
                        isHighlighted: highlight == BottomBarHighlight.verticalNavigation,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_upward,
                            size: 32,
                            color: highlight == BottomBarHighlight.verticalNavigation
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color?.withOpacity(0.3),
                          ),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Freccia destra
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildHighlightedContainer(
                  isHighlighted: highlight == BottomBarHighlight.horizontalNavigation,
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      size: 32,
                      color: highlight == BottomBarHighlight.horizontalNavigation
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color?.withOpacity(0.3),
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 