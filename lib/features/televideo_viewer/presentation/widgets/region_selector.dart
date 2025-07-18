import 'package:flutter/material.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/core/location/location_service.dart';

class UnifiedSelector extends StatefulWidget {
  final Region? selectedRegion;
  final Function(Region?) onSelectionChanged;

  const UnifiedSelector({
    super.key,
    required this.selectedRegion,
    required this.onSelectionChanged,
  });

  @override
  State<UnifiedSelector> createState() => _UnifiedSelectorState();
}

class _UnifiedSelectorState extends State<UnifiedSelector> {
  final MenuController _menuController = MenuController();
  Region? _currentRegion;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentRegion();
  }

  Future<void> _getCurrentRegion() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final region = await LocationService.getCurrentRegion();
      if (!mounted) return;
      setState(() {
        _currentRegion = region;
      });
    } catch (e) {
      print('Errore nel recupero della regione: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      menuChildren: [
        // Spazio all'inizio del menu
        const MenuItemButton(
          child: SizedBox(height: 8),
        ),
        // Opzione Nazionale
        MenuItemButton(
          onPressed: () {
            widget.onSelectionChanged(null);
            _menuController.close();
          },
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  'assets/images/italy.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Nazionale'),
            ],
          ),
        ),
        if (_currentRegion != null) ...[
          const MenuItemButton(
            child: Divider(),
          ),
          // Regione corrente
          MenuItemButton(
            onPressed: () {
              widget.onSelectionChanged(_currentRegion);
              _menuController.close();
            },
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    _currentRegion!.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_currentRegion!.name} (Posizione attuale)'),
              ],
            ),
          ),
        ],
        const MenuItemButton(
          child: Divider(),
        ),
        // Lista delle regioni
        ...Region.values.map((region) => MenuItemButton(
          onPressed: () {
            widget.onSelectionChanged(region);
            _menuController.close();
          },
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
              const SizedBox(width: 8),
              Text(region.name),
            ],
          ),
        )),
        // Spazio alla fine del menu
        const MenuItemButton(
          child: SizedBox(height: 8),
        ),
      ],
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoadingLocation)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else if (widget.selectedRegion != null)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      widget.selectedRegion!.imagePath,
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      'assets/images/italy.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 