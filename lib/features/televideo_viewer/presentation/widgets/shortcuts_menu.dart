import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/shortcuts/shortcuts_service.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class ShortcutsMenu extends StatefulWidget {
  final bool isNational;
  final Function(int) onNationalPageSelected;
  final Function(int, Region) onRegionalPageSelected;
  final Region? selectedRegion;

  const ShortcutsMenu({
    super.key,
    required this.isNational,
    required this.onNationalPageSelected,
    required this.onRegionalPageSelected,
    required this.selectedRegion,
  });

  @override
  State<ShortcutsMenu> createState() => _ShortcutsMenuState();
}

class _ShortcutsMenuState extends State<ShortcutsMenu> {
  final MenuController _menuController = MenuController();
  late List<dynamic> _shortcuts;

  @override
  void initState() {
    super.initState();
    _updateShortcuts();
  }

  @override
  void didUpdateWidget(ShortcutsMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isNational != widget.isNational || 
        oldWidget.selectedRegion != widget.selectedRegion) {
      _updateShortcuts();
    }
  }

  void _updateShortcuts() {
    final service = ShortcutsService();
    _shortcuts = widget.selectedRegion != null ? 
      service.regionalShortcuts : 
      service.nationalShortcuts;
  }

  void _handleShortcutSelected(dynamic shortcut) {
    if (widget.selectedRegion != null) {
      widget.onRegionalPageSelected(shortcut.pageNumber, widget.selectedRegion!);
    } else {
      widget.onNationalPageSelected(shortcut.pageNumber);
    }
    _menuController.close();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      menuChildren: [
        ..._shortcuts.map((shortcut) => MenuItemButton(
          onPressed: () => _handleShortcutSelected(shortcut),
          child: Text('${shortcut.pageNumber} - ${shortcut.title}'),
        )),
      ],
      builder: (context, controller, child) {
        return IconButton(
          icon: const Icon(Icons.menu_book),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
} 