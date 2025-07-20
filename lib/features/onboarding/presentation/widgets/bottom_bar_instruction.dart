import 'package:flutter/material.dart';

enum BottomBarHighlight {
  horizontalNavigation,
  verticalNavigation,
  pageSelector,
}

class BottomBarInstruction extends StatelessWidget {
  final BottomBarHighlight highlight;

  const BottomBarInstruction({
    super.key,
    required this.highlight,
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
                      Icons.arrow_back,
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
                            Icons.arrow_upward,
                            size: 32,
                            color: highlight == BottomBarHighlight.verticalNavigation
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color?.withOpacity(0.3),
                          ),
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildHighlightedContainer(
                    isHighlighted: highlight == BottomBarHighlight.pageSelector,
                    child: GestureDetector(
                      onTap: null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '103',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: highlight == BottomBarHighlight.pageSelector
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3),
                            ),
                          ),
                          Text(
                            '1/2',
                            style: TextStyle(
                              fontSize: 12,
                              color: highlight == BottomBarHighlight.pageSelector
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
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
                            Icons.arrow_downward,
                            size: 32,
                            color: highlight == BottomBarHighlight.verticalNavigation
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
                      Icons.arrow_forward,
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