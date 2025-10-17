import 'package:cursor_televideo/shared/models/shortcut_page.dart';

class ShortcutsService {
  static final ShortcutsService _instance = ShortcutsService._internal();
  factory ShortcutsService() => _instance;
  ShortcutsService._internal();

  // RAI Nazionale
  final List<ShortcutPage> _raiNationalShortcuts = [
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

  // RAI Regionale
  final List<ShortcutPage> _raiRegionalShortcuts = [
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

  // ARD Text (Germania)
  final List<ShortcutPage> _ardShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Inhalt (Indice)'),
    const ShortcutPage(pageNumber: 101, title: 'Nachrichten (Notizie)'),
    const ShortcutPage(pageNumber: 102, title: 'Weitere Schlagzeilen'),
    const ShortcutPage(pageNumber: 104, title: 'Wetter'),
    const ShortcutPage(pageNumber: 109, title: 'Ukraine'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm (TV)'),
    const ShortcutPage(pageNumber: 400, title: 'Kultur'),
    const ShortcutPage(pageNumber: 500, title: 'Ratgeber'),
    const ShortcutPage(pageNumber: 700, title: 'Börse'),
    const ShortcutPage(pageNumber: 790, title: 'Service A-Z'),
  ];

  // ZDF Text (Germania)
  final List<ShortcutPage> _zdfShortcuts = [
    const ShortcutPage(pageNumber: 100, title: 'Übersicht (Indice)'),
    const ShortcutPage(pageNumber: 112, title: 'Nachrichten'),
    const ShortcutPage(pageNumber: 170, title: 'Wetter'),
    const ShortcutPage(pageNumber: 200, title: 'Sport'),
    const ShortcutPage(pageNumber: 300, title: 'Programm (TV)'),
    const ShortcutPage(pageNumber: 400, title: 'Sport II'),
    const ShortcutPage(pageNumber: 500, title: 'Kultur'),
    const ShortcutPage(pageNumber: 600, title: 'Ratgeber'),
    const ShortcutPage(pageNumber: 700, title: 'Service'),
  ];

  /// Restituisce gli shortcuts in base al channelId
  List<ShortcutPage> getShortcutsForChannel({
    required String? channelId,
    required bool isRegional,
    bool isPage100Available = true,
  }) {
    // Se channelId è null o inizia con 'rai', usa le shortcuts RAI
    if (channelId == null || channelId.startsWith('rai')) {
      if (isRegional) {
        return _raiRegionalShortcuts;
      } else {
        if (isPage100Available) {
          return _raiNationalShortcuts;
        } else {
          return _raiNationalShortcuts.where((s) => s.pageNumber != 100).toList();
        }
      }
    }
    
    // ARD Text
    if (channelId == 'ard_text') {
      return _ardShortcuts;
    }
    
    // ZDF Text (tutti i canali ZDF usano gli stessi shortcuts)
    if (channelId == 'zdf_text' || 
        channelId == 'zdfinfo_text' || 
        channelId == 'zdfneo_text' || 
        channelId == '3sat_text') {
      return _zdfShortcuts;
    }
    
    // Default: RAI nazionale
    return _raiNationalShortcuts;
  }

  // Metodi legacy per retrocompatibilità
  @Deprecated('Use getShortcutsForChannel instead')
  final List<ShortcutPage> regionalShortcuts = const [
    ShortcutPage(pageNumber: 300, title: 'Indice Regione'),
    ShortcutPage(pageNumber: 301, title: 'Sport Regione'),
    ShortcutPage(pageNumber: 401, title: 'Meteo'),
    ShortcutPage(pageNumber: 406, title: 'Eventi-Mostre'),
    ShortcutPage(pageNumber: 412, title: 'La regione del gusto'),
    ShortcutPage(pageNumber: 420, title: 'In viaggio'),
    ShortcutPage(pageNumber: 430, title: 'Cinema'),
    ShortcutPage(pageNumber: 450, title: 'Teatri'),
    ShortcutPage(pageNumber: 498, title: 'Istituzioni'),
    ShortcutPage(pageNumber: 520, title: 'Società'),
    ShortcutPage(pageNumber: 575, title: 'Culturambiente'),
    ShortcutPage(pageNumber: 690, title: 'Farmacie'),
  ];

  @Deprecated('Use getShortcutsForChannel instead')
  List<ShortcutPage> getNationalShortcuts({required bool isPage100Available}) {
    if (isPage100Available) {
      return _raiNationalShortcuts;
    } else {
      return _raiNationalShortcuts.where((shortcut) => shortcut.pageNumber != 100).toList();
    }
  }

  @Deprecated('Use getShortcutsForChannel instead')
  List<ShortcutPage> getShortcuts({required bool isNational}) {
    return isNational ? _raiNationalShortcuts : _raiRegionalShortcuts;
  }
} 