import 'package:flutter/material.dart';

class RegionSelectorInstruction extends StatelessWidget {
  final String channelFlag;
  final String channelName;
  
  const RegionSelectorInstruction({
    super.key,
    this.channelFlag = '🇮🇹',
    this.channelName = 'RAI',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Riproduzione fedele dell'app bar
        AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Menu Shortcuts (opaco)
              const Opacity(
                opacity: 0.3,
                child: Icon(Icons.menu_book),
              ),
              // Selettore Canali (evidenziato con bandiera e nome)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      channelFlag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      channelName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Preferiti (opaco)
              const Opacity(
                opacity: 0.3,
                child: Icon(Icons.favorite_border),
              ),
              // Lista preferiti (opaco)
              const Opacity(
                opacity: 0.3,
                child: Icon(Icons.list),
              ),
              // Impostazioni (opaco)
              const Opacity(
                opacity: 0.3,
                child: Icon(Icons.settings),
              ),
            ],
          ),
        ),
        // Freccia che punta al selettore
        Positioned(
          right: MediaQuery.of(context).size.width / 2 - 10,
          top: kToolbarHeight + 4,
          child: CustomPaint(
            size: const Size(20, 30),
            painter: ArrowPainter(),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.6, size.height)
      ..lineTo(size.width * 0.4, size.height)
      ..lineTo(size.width * 0.4, size.height * 0.3)
      ..lineTo(0, size.height * 0.3)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 