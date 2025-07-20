import 'package:flutter/material.dart';

class PageLinksInstruction extends StatefulWidget {
  const PageLinksInstruction({super.key});

  @override
  State<PageLinksInstruction> createState() => _PageLinksInstructionState();
}

class _PageLinksInstructionState extends State<PageLinksInstruction> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapProgress;
  late Animation<double> _opacityAnimation;
  bool _showHighlight = false;

  // Dimensioni originali dell'immagine
  static const originalWidth = 644.0;
  static const originalHeight = 400.0;
  static const scaleFactorX = 1.84; // Fattore di scala orizzontale

  // Lista delle aree cliccabili con le loro coordinate normalizzate e pagine di destinazione
  final List<({int page, double left, double top, double width, double height})> clickableAreas = [
    (page: 108, left: scaleFactorX * 27/originalWidth, top: 48/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight),   // 27,48,52,63
    (page: 109, left: scaleFactorX * 63/originalWidth, top: 48/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight),   // 63,48,88,63
    (page: 108, left: scaleFactorX * 288/originalWidth, top: 48/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight),  // 288,48,313,63
    (page: 109, left: scaleFactorX * 324/originalWidth, top: 48/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight),  // 324,48,349,63
    (page: 150, left: scaleFactorX * 333/originalWidth, top: 128/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 333,128,358,143
    (page: 120, left: scaleFactorX * 333/originalWidth, top: 208/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 333,208,358,223
    (page: 100, left: scaleFactorX * 234/originalWidth, top: 256/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 234,256,259,271
    (page: 150, left: scaleFactorX * 333/originalWidth, top: 256/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 333,256,358,271
    (page: 140, left: scaleFactorX * 333/originalWidth, top: 304/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 333,304,358,319
    (page: 150, left: scaleFactorX * 333/originalWidth, top: 352/originalHeight, width: scaleFactorX * 25/originalWidth, height: 15/originalHeight), // 333,352,358,367
  ];

  int _currentAreaIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _showHighlight = true);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _showHighlight = false;
                // Passa alla prossima area cliccabile
                _currentAreaIndex = (_currentAreaIndex + 1) % clickableAreas.length;
              });
              _controller.reset();
              _controller.forward();
            }
          });
        }
      });

    _tapProgress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
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
    return AspectRatio(
      aspectRatio: originalWidth / originalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageWidth = constraints.maxWidth;
          final imageHeight = constraints.maxHeight;

          return Stack(
            children: [
              // Immagine della pagina 103
              Image.asset(
                'assets/images/page103.png',
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
              // Overlay semi-trasparente per le aree non cliccabili
              if (_showHighlight)
                Container(
                  width: imageWidth,
                  height: imageHeight,
                  color: Colors.black.withOpacity(0.5),
                  child: Stack(
                    children: [
                      // Mostra tutte le aree cliccabili
                      for (final area in clickableAreas)
                        Positioned(
                          left: imageWidth * area.left,
                          top: imageHeight * area.top,
                          width: imageWidth * area.width,
                          height: imageHeight * area.height,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${area.page}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              // Animazione del dito che tocca
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final currentArea = clickableAreas[_currentAreaIndex];
                  
                  // Calcola la posizione del dito
                  final tapOffset = Offset(
                    imageWidth * (currentArea.left - 0.02),
                    imageHeight * (currentArea.top - 0.1 + _tapProgress.value * 0.05),
                  );

                  return Positioned(
                    left: tapOffset.dx,
                    top: tapOffset.dy,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.rotate(
                        angle: -0.5,
                        child: const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
} 