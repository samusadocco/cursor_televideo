import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:cursor_televideo/core/teletext/providers/teletext_provider.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';

/// Provider per RTL Teletext (Germania)
/// 
/// RTL usa un formato XML proprietario che deve essere convertito in HTML
/// per la visualizzazione.
/// 
/// URL Structure:
/// - Pagina principale (100): http://193.16.161.100/teletext/rtl/ascentpage/99.xml (page-1)
/// - Sottopagine: http://193.16.161.100/teletext/rtl/200/2.xml
class RtlProvider implements TeletextProvider {
  static const String baseUrl = 'http://193.16.161.100/teletext/rtl';
  final Dio _dio;
  
  // Dimensioni caratteri per calcolo coordinate clickable areas
  static const double charWidth = 10.8; // Font monospace 18px
  static const double lineHeight = 23.4; // 18px * 1.3
  static const double paddingLeft = 8.0; // CSS padding
  static const double paddingTop = 8.0; // CSS padding

  RtlProvider({Dio? dio}) : _dio = dio ?? Dio();

  @override
  String get providerId => 'rtl_text';

  @override
  String get providerName => 'RTL Teletext';

  @override
  String get countryCode => 'DE';

  @override
  bool get supportsRegions => false;

  @override
  List<String> get supportedRegions => [];

  @override
  Future<TelevideoPage> fetchNationalPage(int pageNumber, {int subPage = 1}) async {
    return fetchPage(pageNumber, subPage: subPage);
  }

  @override
  Future<TelevideoPage> fetchRegionalPage(
    String regionCode,
    int pageNumber, {
    int subPage = 1,
  }) async {
    throw UnimplementedError('RTL non supporta pagine regionali');
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    try {
      await fetchPage(pageNumber);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<TelevideoPage> fetchPage(int pageNumber, {int subPage = 1}) async {
    print('[RtlProvider] Fetching page $pageNumber subpage $subPage');

    try {
      final url = _buildUrl(pageNumber, subPage);
      print('[RtlProvider] URL: $url');

      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final xmlContent = response.data as String;
        print('[RtlProvider] XML length: ${xmlContent.length} bytes');
        
        // Debug: mostra un preview dell'XML grezzo
        final xmlPreview = xmlContent.length > 1000 ? xmlContent.substring(0, 1000) : xmlContent;
        print('[RtlProvider] XML preview:\n$xmlPreview\n...');

        // Converti XML in HTML
        final htmlContent = _convertXmlToHtml(xmlContent, pageNumber);
        
        // Estrai i link cliccabili dall'XML
        final clickableAreas = _extractClickableAreas(xmlContent);
        print('[RtlProvider] Found ${clickableAreas.length} clickable areas');
        
        // Estrai il numero totale di sottopagine dall'XML
        final totalSubPages = _extractTotalSubPages(xmlContent);
        print('[RtlProvider] Total subpages: $totalSubPages');

        return TelevideoPage(
          pageNumber: pageNumber,
          subPage: subPage,
          maxSubPages: totalSubPages,
          htmlContent: htmlContent,
          clickableAreas: clickableAreas,
          providerId: 'rtl_text',
          imageUrl: '', // RTL usa HTML, non immagini
          isHtmlContent: true, // RTL usa HTML, non immagini
        );
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      print('[RtlProvider] Error fetching page: $e');
      rethrow;
    }
  }

  /// Costruisce l'URL per la pagina/sottopagina richiesta
  String _buildUrl(int pageNumber, int subPage) {
    if (subPage == 1) {
      // Per la prima sottopagina, usa il formato "ascentpage"
      final adjustedPage = pageNumber - 1; // RTL usa page-1
      return '$baseUrl/ascentpage/$adjustedPage.xml';
    } else {
      // Per le sottopagine successive, usa il formato normale
      return '$baseUrl/$pageNumber/$subPage.xml';
    }
  }

  /// Converte l'XML di RTL in HTML visualizzabile con colori teletext
  String _convertXmlToHtml(String xmlContent, int pageNumber) {
    try {
      print('[RtlProvider] Parsing RTL XML with color attributes...');
      
      // Parse XML
      final document = XmlDocument.parse(xmlContent);
      final root = document.rootElement;
      
      // RTL usa una struttura XML dove ogni carattere ha attributi per colore:
      // <r c="0"> = riga (row)
      //   <c c="0" f="#FFFFFF" b="#000000">X</c> = carattere con foreground e background
      
      // Trova tutti gli elementi <r> (righe)
      final rows = root.findAllElements('r');
      print('[RtlProvider] Found ${rows.length} rows in XML');
      
      final buffer = StringBuffer();

      buffer.writeln('<!DOCTYPE html>');
      buffer.writeln('<html>');
      buffer.writeln('<head>');
      buffer.writeln('<meta charset="UTF-8">');
      buffer.writeln('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
      buffer.writeln('<style>');
      buffer.writeln('''
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        
        body {
          background-color: #000;
          color: #fff;
          font-family: 'Courier New', 'Lucida Console', monospace;
          font-size: 18px;
          font-weight: bold;
          line-height: 1.3;
          overflow: visible;
          width: auto;
          min-width: 100%;
          height: auto;
          min-height: 100vh;
        }
        
        #content {
          width: auto;
          height: auto;
          padding: 8px;
          white-space: nowrap;
        }
        
        .line {
          font-family: 'Courier New', monospace;
          font-weight: bold;
          white-space: pre !important;
          min-height: 1.3em;
          display: block;
        }
      ''');
      buffer.writeln('</style>');
      buffer.writeln('</head>');
      buffer.writeln('<body>');
      buffer.writeln('<div id="content">');

      // Processa ogni riga XML
      int rowIndex = 0;
      for (final row in rows) {
        // Debug speciale per riga 1 (quella con i numeri strani)
        if (rowIndex == 1) {
          print('[RtlProvider] ═══ DEBUG RIGA 1 (con numeri strani) ═══');
          final chars = row.findElements('c');
          int charCount = 0;
          for (final charElement in chars) {
            if (charCount < 15) { // Prime 15 caratteri
              final col = charElement.getAttribute('c');
              final text = charElement.text;
              final fg = charElement.getAttribute('f');
              final bg = charElement.getAttribute('b');
              print('[RtlProvider]   Char[$charCount] c=$col text="$text" fg=$fg bg=$bg');
              charCount++;
            }
          }
        }
        
        final lineHtml = _parseXmlRow(row, debugRow: rowIndex == 1, rowIndex: rowIndex);
        
        // Debug: mostra le prime 3 righe processate
        if (rowIndex < 3) {
          print('[RtlProvider] Row $rowIndex HTML length: ${lineHtml.length} chars');
          final preview = lineHtml.length > 150 ? lineHtml.substring(0, 150) : lineHtml;
          print('[RtlProvider] Row $rowIndex preview: "$preview"');
        }
        
        buffer.writeln('<div class="line">$lineHtml</div>');
        rowIndex++;
      }
      
      print('[RtlProvider] Processed $rowIndex rows');

      buffer.writeln('</div>');
      buffer.writeln('</body>');
      buffer.writeln('</html>');

      return buffer.toString();
    } catch (e) {
      print('[RtlProvider] Error converting XML to HTML: $e');
      return _createErrorHtml('Errore nella conversione XML: $e');
    }
  }

  /// Parsa una riga XML (<r>) e genera l'HTML con i colori corretti
  /// 
  /// Ogni riga contiene elementi <c> (carattere) con attributi:
  /// - c="X" : posizione colonna (0-39, teletext standard è 40 colonne)
  /// - f="#RRGGBB" : colore foreground (testo)
  /// - b="#RRGGBB" : colore background (sfondo)
  /// - g="1" : Graphics Mode (caratteri mosaico G1)
  String _parseXmlRow(XmlElement row, {bool debugRow = false, int rowIndex = -1}) {
    // RTL usa più di 40 colonne (visto c="40" nell'XML)
    // Usiamo 50 per sicurezza
    const int maxColumns = 50;
    
    // Crea un array per la griglia della riga (ogni elemento deve essere un oggetto separato!)
    // Usiamo un carattere speciale '\x00' per marcare le colonne NON ancora riempite
    // Gli spazi ' ' dall'XML sono caratteri significativi e vanno mantenuti!
    final List<_TeletextChar> grid = List.generate(
      maxColumns,
      (_) => _TeletextChar(text: '\x00', fgColor: null, bgColor: null),
    );
    
    // Trova tutti gli elementi <c> (caratteri) nella riga
    final chars = row.findElements('c');
    
    // Posiziona i caratteri nella griglia usando l'attributo c
    // IMPORTANTE: 
    // 1. Stringhe multi-carattere vengono espanse su colonne consecutive
    // 2. I colori (f/b) si ereditano dall'elemento precedente se non specificati
    // 3. Se manca una colonna, viene ereditato carattere+colori dalla precedente
    
    // Traccia i colori correnti per l'ereditarietà
    String? currentFgColor;
    String? currentBgColor;
    
    // TODO: Traccia il link corrente e la sua posizione di inizio
    // I link cliccabili verranno implementati dopo che il rendering base è corretto
    String? currentLink;
    int? linkStartCol;
    // List<ClickableArea> clickableAreas = [];
    
    for (final charElement in chars) {
      final colStr = charElement.getAttribute('c');
      if (colStr == null) continue;
      
      final col = int.tryParse(colStr);
      if (col == null || col < 0 || col >= maxColumns) {
        // Debug: segnala se un carattere è fuori range
        if (col != null && col >= maxColumns) {
          print('[RtlProvider] ⚠️ Character at column $col exceeds maxColumns ($maxColumns)');
        }
        continue;
      }
      
      final text = charElement.text;
      
      // I colori possono essere specificati nell'elemento o ereditati dal precedente
      final fgColorAttr = charElement.getAttribute('f');
      final bgColorAttr = charElement.getAttribute('b');
      
      // Attributo g="1" indica Graphics Mode (caratteri mosaico G1)
      final graphicsMode = charElement.getAttribute('g') == '1';
      
      // Se il colore è specificato, aggiorna quello corrente
      // Altrimenti, usa quello corrente (ereditato)
      if (fgColorAttr != null) {
        currentFgColor = fgColorAttr;
      }
      if (bgColorAttr != null) {
        currentBgColor = bgColorAttr;
      }
      
      // Gestione link cliccabili: l="nnn/0" indica link a pagina nnn
      // Il link è valido da questa posizione fino allo spazio successivo
      final linkAttr = charElement.getAttribute('l');
      
      // Se c'è un nuovo link, chiudi quello precedente (se presente)
      if (linkAttr != null && linkAttr != currentLink) {
        // Chiudi link precedente se aperto
        if (currentLink != null && linkStartCol != null) {
          final pageMatch = RegExp(r'(\d+)/').firstMatch(currentLink);
          if (pageMatch != null) {
            final targetPage = int.tryParse(pageMatch.group(1)!);
            if (targetPage != null) {
              // TODO: Implementare clickableAreas dopo fix rendering
              // clickableAreas.add(ClickableArea(...));
              if (debugRow) {
                print('[RtlProvider]     ✓ Link detected: page $targetPage from col $linkStartCol to $col');
              }
            }
          }
        }
        
        // Apri nuovo link
        currentLink = linkAttr;
        linkStartCol = col;
        if (debugRow) {
          print('[RtlProvider]     → Link started: $linkAttr at col $col');
        }
      }
      
      // Se incontriamo uno spazio, chiudi il link corrente
      if (text == ' ' && currentLink != null && linkStartCol != null) {
        final pageMatch = RegExp(r'(\d+)/').firstMatch(currentLink);
        if (pageMatch != null) {
          final targetPage = int.tryParse(pageMatch.group(1)!);
          if (targetPage != null) {
            // TODO: Implementare clickableAreas dopo fix rendering
            // clickableAreas.add(ClickableArea(...));
            if (debugRow) {
              print('[RtlProvider]     ✓ Link closed by space: page $targetPage from col $linkStartCol to $col');
            }
          }
        }
        currentLink = null;
        linkStartCol = null;
      }
      
      if (debugRow) {
        print('[RtlProvider]   Processing c=$col text="$text" (${text.length} chars)');
        print('[RtlProvider]     XML: fg=$fgColorAttr bg=$bgColorAttr g=$graphicsMode');
        print('[RtlProvider]     Current: fg=$currentFgColor bg=$currentBgColor');
      }
      
      // Prova a convertire codici teletext bitmap in Unicode
      String textToDisplay = text;
      
      // Se siamo in Graphics Mode (g="1"), i codici vanno interpretati come G1 mosaics
      if (graphicsMode) {
        final code = int.tryParse(text);
        if (code != null) {
          // Log per debug
          print('[RtlProvider] 🎨 Graphics Mode @ row=$rowIndex col=$col: code="$text" (dec=$code, hex=0x${code.toRadixString(16)})');
          
          final convertedChar = _convertTeletextCodeToUnicode(code);
          if (convertedChar != null) {
            textToDisplay = convertedChar;
            print('[RtlProvider]   ✅ Converted "$text" → "$convertedChar" (U+${convertedChar.codeUnitAt(0).toRadixString(16).toUpperCase().padLeft(4, '0')})');
          } else {
            print('[RtlProvider]   ⚠️ NO CONVERSION for "$text"');
          }
        }
      }
      
      // Espandi stringhe multi-carattere su colonne consecutive
      // Usa i colori correnti (che possono essere ereditati)
      for (int i = 0; i < textToDisplay.length && (col + i) < maxColumns; i++) {
        final char = textToDisplay[i];
        grid[col + i] = _TeletextChar(
          text: char,
          fgColor: currentFgColor,
          bgColor: currentBgColor,
        );
        
        if (debugRow && (col + i) < 20) {
          print('[RtlProvider]     → grid[${col + i}] = "$char" (fg=$currentFgColor bg=$currentBgColor)');
        }
      }
    }
    
    // Propaga caratteri/colori per colonne mancanti
    // Se una colonna è vuota (marcata con \x00), eredita dalla precedente
    if (debugRow) {
      print('[RtlProvider]   Propagating characters for missing columns...');
    }
    
    for (int i = 1; i < maxColumns; i++) {
      // Se la colonna corrente NON è stata riempita (ha ancora \x00)
      // e la precedente è stata riempita, propaga
      if (grid[i].text == '\x00' && grid[i - 1].text != '\x00') {
        grid[i] = _TeletextChar(
          text: grid[i - 1].text,
          fgColor: grid[i - 1].fgColor,
          bgColor: grid[i - 1].bgColor,
        );
        
        if (debugRow && i < 20) {
          print('[RtlProvider]     → grid[$i] inherited from grid[${i - 1}]: "${grid[i].text}"');
        }
      }
    }
    
    // Converti \x00 rimasti in spazi (colonne mai riempite)
    for (int i = 0; i < maxColumns; i++) {
      if (grid[i].text == '\x00') {
        grid[i] = _TeletextChar(text: ' ', fgColor: null, bgColor: null);
      }
    }
    
    // Debug: mostra la griglia risultante
    if (debugRow) {
      print('[RtlProvider] Grid content (first 20 chars):');
      for (int i = 0; i < 20 && i < grid.length; i++) {
        print('[RtlProvider]   grid[$i] = "${grid[i].text}"');
      }
    }
    
    // Genera HTML dalla griglia, raggruppando caratteri con stesso stile
    final buffer = StringBuffer();
    String? htmlFgColor;
    String? htmlBgColor;
    bool inSpan = false;
    
    for (final charData in grid) {
      // Se i colori sono cambiati, chiudi lo span precedente e aprine uno nuovo
      if (charData.fgColor != htmlFgColor || charData.bgColor != htmlBgColor) {
        // Chiudi span precedente
        if (inSpan) {
          buffer.write('</span>');
          inSpan = false;
        }
        
        // Aggiorna colori correnti
        htmlFgColor = charData.fgColor;
        htmlBgColor = charData.bgColor;
        
        // Apri nuovo span con i nuovi colori
        if (charData.fgColor != null || charData.bgColor != null) {
          buffer.write('<span style="');
          if (charData.fgColor != null) {
            buffer.write('color: ${charData.fgColor};');
          }
          if (charData.bgColor != null) {
            buffer.write('background-color: ${charData.bgColor};');
          }
          buffer.write('">');
          inSpan = true;
        }
      }
      
      // Aggiungi il carattere (con escaping HTML)
      final escapedText = charData.text
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;');
      buffer.write(escapedText);
    }
    
    // Chiudi l'ultimo span se aperto
    if (inSpan) {
      buffer.write('</span>');
    }
    
    return buffer.toString();
  }

  /// Converte un codice G1 Teletext in carattere Unicode
  /// 
  /// Basato sulla tabella ufficiale Teletext ETS 300 706
  /// I codici G1 Graphics (0x20-0x7F) con g="1" sono caratteri mosaico 2x3
  /// 
  /// TODO: SISTEMARE CODICI UNICODE PARTICOLARI
  /// Alcuni codici bitmap potrebbero non corrispondere perfettamente agli Unicode Block Elements.
  /// Necessario verificare e affinare la tabella di conversione per una visualizzazione perfetta.
  /// Riferimento: ETS 300 706 - Enhanced Teletext specification
  /// Codici RTL più comuni da verificare: 32, 35, 36, 44, 48, 61, 106, 112, 117, 118
  String? _convertTeletextCodeToUnicode(int code) {
    // Tabella completa Teletext G1 Graphics → Unicode
    // Basata su: https://en.wikipedia.org/wiki/Teletext_character_set
    // e Unicode Block Elements (U+2580-U+259F)
    
    // I codici RTL più comuni: 32, 35, 36, 44, 48, 61, 106, 112, 117, 118
    
    switch (code) {
      // Spazio (0x20)
      case 32: return ' ';
      
      // Pattern superiori (0x30-0x3F)
      case 48: return '▀'; // 0x30 - Upper half block
      case 49: return '▘'; // 0x31 - Upper left quadrant  
      case 50: return '▝'; // 0x32 - Upper right quadrant
      case 51: return '▀'; // 0x33 - Upper half
      case 52: return '▖'; // 0x34 - Lower left quadrant
      case 53: return '▌'; // 0x35 - Left half
      case 54: return '▞'; // 0x36 - Upper right + lower left
      case 55: return '▛'; // 0x37 - All except lower right
      case 56: return '▗'; // 0x38 - Lower right quadrant
      case 57: return '▚'; // 0x39 - Upper left + lower right
      case 58: return '▐'; // 0x3A - Right half
      case 59: return '▜'; // 0x3B - All except lower left
      case 60: return '▄'; // 0x3C - Lower half
      case 61: return '▙'; // 0x3D - All except upper right
      case 62: return '▟'; // 0x3E - All except upper left
      case 63: return '█'; // 0x3F - Full block
      
      // Pattern medi (0x40-0x4F)  
      case 64: return '▀'; // 0x40
      case 65: return '▘'; // 0x41
      case 66: return '▝'; // 0x42
      case 67: return '▀'; // 0x43
      case 68: return '▖'; // 0x44
      case 69: return '▌'; // 0x45
      case 70: return '▞'; // 0x46
      case 71: return '▛'; // 0x47
      case 72: return '▗'; // 0x48
      case 73: return '▚'; // 0x49
      case 74: return '▐'; // 0x4A
      case 75: return '▜'; // 0x4B
      case 76: return '▄'; // 0x4C
      case 77: return '▙'; // 0x4D
      case 78: return '▟'; // 0x4E
      case 79: return '█'; // 0x4F
      
      // Pattern alti (0x60-0x7F) - includono 106, 112, 117, 118
      case 96: return '▀';  // 0x60
      case 97: return '▘';  // 0x61
      case 98: return '▝';  // 0x62
      case 99: return '▀';  // 0x63
      case 100: return '▖'; // 0x64
      case 101: return '▌'; // 0x65
      case 102: return '▞'; // 0x66
      case 103: return '▛'; // 0x67
      case 104: return '▗'; // 0x68
      case 105: return '▚'; // 0x69
      case 106: return '▐'; // 0x6A - Right half (RTL usa questo!)
      case 107: return '▜'; // 0x6B
      case 108: return '▄'; // 0x6C
      case 109: return '▙'; // 0x6D
      case 110: return '▟'; // 0x6E
      case 111: return '█'; // 0x6F
      case 112: return '▀'; // 0x70 - Upper half (RTL usa questo!)
      case 113: return '▘'; // 0x71
      case 114: return '▝'; // 0x72
      case 115: return '▀'; // 0x73
      case 116: return '▖'; // 0x74
      case 117: return '▌'; // 0x75 - Left half (RTL usa questo!)
      case 118: return '▞'; // 0x76 - Diagonal (RTL usa questo!)
      case 119: return '▛'; // 0x77
      case 120: return '▗'; // 0x78
      case 121: return '▚'; // 0x79
      case 122: return '▐'; // 0x7A
      case 123: return '▜'; // 0x7B
      case 124: return '▄'; // 0x7C
      case 125: return '▙'; // 0x7D
      case 126: return '▟'; // 0x7E
      case 127: return '█'; // 0x7F - Full block
      
      default:
        // Fallback per codici non mappati
        if (code >= 32 && code < 128) {
          return '░'; // Light shade come fallback
        }
        return null;
    }
  }

  /// Estrae le clickable areas dall'XML di RTL
  /// 
  /// I link sono indicati dall'attributo l="nnn/0" e vanno dalla posizione
  /// corrente fino al prossimo spazio o fine riga
  List<ClickableArea> _extractClickableAreas(String xmlContent) {
    final clickableAreas = <ClickableArea>[];
    
    print('[RtlProvider] 🔍 Extracting clickable areas from XML...');
    
    try {
      final document = XmlDocument.parse(xmlContent);
      final root = document.rootElement;
      final rows = root.findAllElements('r');
      
      print('[RtlProvider] Found ${rows.length} rows to scan for links');
      
      int rowIndex = 0;
      int totalLinksFound = 0;
      
      for (final row in rows) {
        final chars = row.findElements('c');
        
        String? currentLink;
        int? linkStartCol;
        
        for (final charElement in chars) {
          final colStr = charElement.getAttribute('c');
          if (colStr == null) continue;
          
          final col = int.tryParse(colStr);
          if (col == null) continue;
          
          final text = charElement.text;
          final linkAttr = charElement.getAttribute('l');
          
          // Debug: stampa TUTTI i caratteri con attributo 'l'
          if (linkAttr != null) {
            totalLinksFound++;
            if (totalLinksFound <= 5) { // Mostra solo i primi 5
              print('[RtlProvider]   📌 Link found at row=$rowIndex col=$col: l="$linkAttr" text="$text"');
            }
          }
          
          // Se c'è un nuovo link, chiudi quello precedente
          if (linkAttr != null && linkAttr != currentLink) {
            // Chiudi link precedente se aperto
            if (currentLink != null && linkStartCol != null) {
              _addClickableArea(clickableAreas, currentLink, linkStartCol, col, rowIndex);
            }
            
            // Apri nuovo link
            currentLink = linkAttr;
            linkStartCol = col;
          }
          
          // Se incontriamo uno spazio, chiudi il link corrente
          if (text == ' ' && currentLink != null && linkStartCol != null) {
            _addClickableArea(clickableAreas, currentLink, linkStartCol, col, rowIndex);
            currentLink = null;
            linkStartCol = null;
          }
        }
        
        // Chiudi eventuale link aperto alla fine della riga
        if (currentLink != null && linkStartCol != null) {
          _addClickableArea(clickableAreas, currentLink, linkStartCol, 50, rowIndex);
        }
        
        rowIndex++;
      }
    } catch (e) {
      print('[RtlProvider] Error extracting clickable areas: $e');
    }
    
    return clickableAreas;
  }
  
  /// Aggiunge un clickable area alla lista, convertendo coordinate carattere → pixel
  void _addClickableArea(
    List<ClickableArea> areas,
    String linkAttr,
    int startCol,
    int endCol,
    int row,
  ) {
    // Estrai il numero di pagina dal formato "nnn/0"
    final pageMatch = RegExp(r'(\d+)/').firstMatch(linkAttr);
    if (pageMatch == null) return;
    
    final targetPage = int.tryParse(pageMatch.group(1)!);
    if (targetPage == null) return;
    
    // Converti coordinate carattere → pixel
    final x = (paddingLeft + (startCol * charWidth)).round();
    final y = (paddingTop + (row * lineHeight)).round();
    final width = ((endCol - startCol) * charWidth).round();
    final height = lineHeight.round();
    
    areas.add(ClickableArea(
      targetPage: targetPage,
      x: x,
      y: y,
      width: width,
      height: height,
    ));
    
    print('[RtlProvider] Added clickable area: page $targetPage at ($x,$y) size ${width}x$height');
  }

  /// Estrae il numero totale di sottopagine dall'XML
  int _extractTotalSubPages(String xmlContent) {
    try {
      // Cerca pattern comuni per sottopagine nell'XML
      // RTL potrebbe indicare sottopagine in vari modi
      
      // Pattern: "1/3" o "2/5" indicano "pagina X di Y"
      final pageOfPattern = RegExp(r'(\d+)/(\d+)');
      final matches = pageOfPattern.allMatches(xmlContent);
      
      int maxSubPages = 1;
      for (final match in matches) {
        final total = int.tryParse(match.group(2) ?? '1') ?? 1;
        if (total > maxSubPages) {
          maxSubPages = total;
        }
      }
      
      return maxSubPages;
    } catch (e) {
      print('[RtlProvider] Error extracting total subpages: $e');
      return 1;
    }
  }

  /// Crea una pagina HTML di errore
  String _createErrorHtml(String message) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            background-color: #000;
            color: #f00;
            font-family: 'Courier New', monospace;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
            text-align: center;
          }
        </style>
      </head>
      <body>
        <div>$message</div>
      </body>
      </html>
    ''';
  }
}

/// Classe helper per rappresentare un carattere teletext con i suoi attributi
class _TeletextChar {
  final String text;
  final String? fgColor;
  final String? bgColor;
  
  const _TeletextChar({
    required this.text,
    this.fgColor,
    this.bgColor,
  });
}

