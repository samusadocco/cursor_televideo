import 'package:flutter/material.dart';
import 'package:cursor_televideo/features/onboarding/presentation/widgets/channel_badge_widget.dart';

class FavoritesListInstruction extends StatelessWidget {
  final String channelFlag;
  final String channelName;
  
  const FavoritesListInstruction({
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
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
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
          // Lista preferiti (evidenziato)
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
              Icons.list,
              color: Colors.white,
            ),
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