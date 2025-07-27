import 'package:cursor_televideo/shared/models/shortcut_page.dart';

class ShortcutsService {
  static final ShortcutsService _instance = ShortcutsService._internal();
  factory ShortcutsService() => _instance;
  ShortcutsService._internal();

  final List<ShortcutPage> _nationalShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Indice'),
    const ShortcutPage(pageNumber: 101, title: 'Ultim\'ora'),
    const ShortcutPage(pageNumber: 103, title: 'Prima'),
    //const ShortcutPage(pageNumber: 110, title: 'Primo Piano'),
    const ShortcutPage(pageNumber: 120, title: 'Politica'),
    const ShortcutPage(pageNumber: 130, title: 'Economia'),
    const ShortcutPage(pageNumber: 140, title: 'Dall\'Italia'),
    const ShortcutPage(pageNumber: 150, title: 'Dal mondo'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 400, title: 'Pubblica Utilità'),
    const ShortcutPage(pageNumber: 401, title: 'Almanacco'),
    const ShortcutPage(pageNumber: 545, title: 'Magazine'),
    const ShortcutPage(pageNumber: 613, title: 'Viabilità'),
    const ShortcutPage(pageNumber: 700, title: 'Meteo'),
  ];

  final List<ShortcutPage> regionalShortcuts = [
    const ShortcutPage(pageNumber: 300, title: 'Indice Regione'),
    const ShortcutPage(pageNumber: 301, title: 'Sport Regione'),
    const ShortcutPage(pageNumber: 401, title: 'Meteo'),
    const ShortcutPage(pageNumber: 406, title: 'Eventi-Mostre'),
    const ShortcutPage(pageNumber: 412, title: 'La regione del gusto'),
    const ShortcutPage(pageNumber: 420, title: 'In viaggio'),
    const ShortcutPage(pageNumber: 430, title: 'Cinema'),
    const ShortcutPage(pageNumber: 450, title: 'Teatri'),
    const ShortcutPage(pageNumber: 498, title: 'Istituzioni'),
    const ShortcutPage(pageNumber: 520, title: 'Società'),
    const ShortcutPage(pageNumber: 575, title: 'Culturambiente'),
    const ShortcutPage(pageNumber: 690, title: 'Farmacie'),
  ];

  /// Restituisce la lista degli shortcuts nazionali, filtrata in base alla disponibilità della pagina 100
  List<ShortcutPage> getNationalShortcuts({required bool isPage100Available}) {
    if (isPage100Available) {
      return _nationalShortcuts;
    } else {
      return _nationalShortcuts.where((shortcut) => shortcut.pageNumber != 100).toList();
    }
  }

  List<ShortcutPage> getShortcuts({required bool isNational}) {
    return isNational ? _nationalShortcuts : regionalShortcuts;
  }
} 