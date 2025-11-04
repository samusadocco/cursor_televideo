import 'package:flutter/material.dart';

/// Widget riutilizzabile per mostrare bandiera + nome canale
class ChannelBadgeWidget extends StatelessWidget {
  final String channelFlag;
  final String channelName;
  final double flagSize;
  final double fontSize;
  
  const ChannelBadgeWidget({
    super.key,
    this.channelFlag = '🇮🇹',
    this.channelName = 'RAI',
    this.flagSize = 16.0,
    this.fontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          channelFlag,
          style: TextStyle(fontSize: flagSize),
        ),
        const SizedBox(width: 4),
        Text(
          channelName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

