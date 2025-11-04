import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/channel_badge_widget.dart';

class ShortcutsMenuInstruction extends StatelessWidget {
  final String channelFlag;
  final String channelName;
  
  const ShortcutsMenuInstruction({
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
              // Menu Shortcuts (evidenziato)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
                child: const Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
              ),
              // Selettore Canali (opaco)
              Opacity(
                opacity: 0.3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ChannelBadgeWidget(
                    channelFlag: channelFlag,
                    channelName: channelName,
                  ),
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
        // Freccia che punta al menu shortcuts
        Positioned(
          left: 20,
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