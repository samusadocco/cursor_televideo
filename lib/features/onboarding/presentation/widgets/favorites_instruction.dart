import 'package:flutter/material.dart';

class FavoritesInstruction extends StatelessWidget {
  const FavoritesInstruction({super.key});

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
          // Preferiti (evidenziato)
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
              Icons.favorite,
              color: Colors.red,
            ),
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
    );
  }
} 