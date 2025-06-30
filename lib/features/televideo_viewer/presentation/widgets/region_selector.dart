import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class RegionSelector extends StatelessWidget {
  final Region selectedRegion;
  final Function(Region) onRegionSelected;

  const RegionSelector({
    super.key,
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: Region.values.length,
      itemBuilder: (context, index) {
        final region = Region.values[index];
        return GestureDetector(
          onTap: () => onRegionSelected(region),
          child: Card(
            elevation: region == selectedRegion ? 8.0 : 2.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      region.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    region.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 