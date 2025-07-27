import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/shortcuts/shortcuts_service.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/page_search_dialog.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';

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
    final isPage100Available = context.read<TelevideoBloc>().isPage100Available;
    _shortcuts = widget.selectedRegion != null ? 
      service.regionalShortcuts : 
      service.getNationalShortcuts(isPage100Available: isPage100Available);
  }

  void _handleShortcutSelected(dynamic shortcut) {
    if (widget.selectedRegion != null) {
      widget.onRegionalPageSelected(shortcut.pageNumber, widget.selectedRegion!);
    } else {
      widget.onNationalPageSelected(shortcut.pageNumber);
    }
    _menuController.close();
  }

  void _showSearchDialog() {
    _menuController.close();
    showDialog(
      context: context,
      builder: (context) => PageSearchDialog(
        isNational: widget.isNational,
        onNationalPageSelected: widget.onNationalPageSelected,
        onRegionalPageSelected: widget.onRegionalPageSelected,
        selectedRegion: widget.selectedRegion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TelevideoBloc, TelevideoState>(
      builder: (context, state) {
        _updateShortcuts(); // Aggiorna gli shortcuts quando cambia lo stato del bloc
        return MenuAnchor(
          controller: _menuController,
          menuChildren: [
            // Pulsante di ricerca in cima al menu
            MenuItemButton(
              onPressed: _showSearchDialog,
              leadingIcon: const Icon(Icons.search),
              child: const Text(
                'Cerca pagina...',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const PopupMenuDivider(),
            // Scorciatoie
            ..._shortcuts.map<MenuItemButton>((shortcut) {
              return MenuItemButton(
                onPressed: () => _handleShortcutSelected(shortcut),
                child: Text(
                  '${shortcut.pageNumber} - ${shortcut.title}',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ],
          builder: (context, controller, child) {
            return IconButton(
              icon: const Icon(Icons.menu_book),
              tooltip: 'Menu Shortcuts',
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
      },
    );
  }
} 