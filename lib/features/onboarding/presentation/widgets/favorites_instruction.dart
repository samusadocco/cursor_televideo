import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/channel_badge_widget.dart';

class FavoritesInstruction extends StatelessWidget {
  final String channelFlag;
  final String channelName;
  
  const FavoritesInstruction({
    super.key,
    this.channelFlag = '🇮🇹',
    this.channelName = 'RAI',
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