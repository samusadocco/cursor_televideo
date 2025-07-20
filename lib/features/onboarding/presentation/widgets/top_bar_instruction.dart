import 'package:flutter/material.dart';

enum TopBarHighlight {
  favorites,
  favoritesList,
  settings,
}

class TopBarInstruction extends StatelessWidget {
  final TopBarHighlight highlight;

  const TopBarInstruction({
    super.key,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Menu Shortcuts (opaco)
          const Opacity(
            opacity: 0.3,
            child: Icon(Icons.menu_book),
          ),
          // Selettore Regioni (opaco)
          Opacity(
            opacity: 0.3,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/italy.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Preferiti
          _buildHighlightedIcon(
            context,
            Icons.favorite,
            isHighlighted: highlight == TopBarHighlight.favorites,
            description: 'Aggiungi o rimuovi\nla pagina dai preferiti',
          ),
          // Lista preferiti
          _buildHighlightedIcon(
            context,
            Icons.list,
            isHighlighted: highlight == TopBarHighlight.favoritesList,
            description: 'Visualizza e gestisci\nle pagine preferite',
          ),
          // Impostazioni
          _buildHighlightedIcon(
            context,
            Icons.settings,
            isHighlighted: highlight == TopBarHighlight.settings,
            description: 'Accedi alle\nimpostazioni dell\'app',
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedIcon(
    BuildContext context,
    IconData icon, {
    required bool isHighlighted,
    required String description,
  }) {
    final iconWidget = Container(
      width: 40,
      height: 40,
      decoration: isHighlighted
          ? BoxDecoration(
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
            )
          : null,
      child: Icon(
        icon,
        color: Colors.white.withOpacity(isHighlighted ? 1.0 : 0.3),
      ),
    );

    if (!isHighlighted) return iconWidget;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        const SizedBox(height: 8),
        // Freccia che punta all'icona
        CustomPaint(
          size: const Size(20, 30),
          painter: ArrowPainter(),
        ),
        const SizedBox(height: 8),
        // Descrizione
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
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