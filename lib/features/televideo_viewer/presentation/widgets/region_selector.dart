import 'package:flutter/material.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class UnifiedSelector extends StatelessWidget {
  final Region? selectedRegion;
  final Function(Region?) onSelectionChanged;

  const UnifiedSelector({
    super.key,
    required this.selectedRegion,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Region?>(
      initialValue: selectedRegion,
      onSelected: onSelectionChanged,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Region?>(
          value: null,
          onTap: () => onSelectionChanged(null),
          child: const Row(
            children: [
              Icon(Icons.home),
              SizedBox(width: 8),
              Text('Nazionale'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        ...Region.values.map((region) => PopupMenuItem<Region?>(
          value: region,
          onTap: () => onSelectionChanged(region),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  region.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8),
              Text(region.name),
            ],
          ),
        )),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedRegion != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                selectedRegion!.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Text(selectedRegion!.name),
          ] else ...[
            const Icon(Icons.home),
            const SizedBox(width: 8),
            const Text('Nazionale'),
          ],
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
} 