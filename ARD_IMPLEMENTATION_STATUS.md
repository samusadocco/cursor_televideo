# 🇩🇪 Implementazione ARD Text - Stato Avanzamento

## ✅ Completato

### 1. Architettura Provider
- ✅ Creato `TeletextProvider` astratto (`lib/core/teletext/providers/teletext_provider.dart`)
- ✅ Implementato `ARDProvider` concreto (`lib/core/teletext/providers/ard_provider.dart`)
- ✅ Definito pattern per supportare diversi formati teletext

### 2. Modello Dati
- ✅ Esteso `TelevideoPage` con supporto HTML:
  - `isHtmlContent`: flag per distinguere HTML da immagini
  - `htmlContent`: contenuto HTML grezzo
  - `providerId`: identificativo provider
  - `subPage`/`totalSubPages`: gestione sottopagine migliorata
  - `timestamp`: timestamp caricamento
- ✅ Esteso `ClickableArea` con `description` per i link

### 3. ARD Provider Features
- ✅ Fetch pagine nazionali via `https://www.ard-text.de/page_only.php?page=XXX&sub=Y`
- ✅ Parsing HTML con estrazione link cliccabili
- ✅ Estrazione informazioni sottopagine
- ✅ Supporto regioni tedesche (BR, HR, MDR, NDR, RBB, SR, SWR, WDR)

### 4. Ricerca API
- ✅ Identificato formato ARD: HTML con span e immagini per caratteri
- ✅ Identificato endpoint: `/page_only.php`
- ✅ Compresa struttura sottopagine

## 🔄 In Corso

### 5. Generazione Codice
- 🔄 `flutter pub run build_runner build` in esecuzione per rigenerare:
  - `televideo_page.freezed.dart`
  - `televideo_page.g.dart`

## ⏳ Da Fare

### 6. Integrazione nel Bloc
- ❌ Creare factory per selezionare il provider corretto:
  ```dart
  TeletextProvider _getProviderForChannel(TeletextChannel channel) {
    switch (channel.id) {
      case 'ard_text':
        return ARDProvider();
      case 'rai_nazionale':
      case String _ when channel.id.startsWith('rai_'):
        return RAIProvider(); // Da creare
      default:
        throw UnimplementedError('Provider for ${channel.id} not implemented');
    }
  }
  ```

- ❌ Modificare `_onChangeChannel` in `TelevideoBloc`:
  ```dart
  Future<void> _onChangeChannel(TeletextChannel channel, Emitter<TelevideoState> emit) async {
    final provider = _getProviderForChannel(channel);
    
    try {
      final page = await provider.fetchNationalPage(100);
      emit(TelevideoState.loaded(page, selectedChannel: channel));
    } catch (e) {
      emit(TelevideoState.error(e.toString(), selectedChannel: channel));
    }
  }
  ```

### 7. Widget per Rendering HTML
- ❌ Creare `HtmlTeletextViewer` widget per renderizzare HTML ARD
- ❌ Usare package `flutter_html` o `webview_flutter` per rendering
- ❌ Gestire click sui link HTML per navigazione

### 8. Refactoring RAI
- ❌ Creare `RAIProvider` implementando `TeletextProvider`
- ❌ Migrare logica da `TelevideoRepository` a `RAIProvider`
- ❌ Mantenere retrocompatibilità con codice esistente

### 9. Testing
- ❌ Test unitari per `ARDProvider`
- ❌ Test integrazione con `TelevideoBloc`
- ❌ Test su device reale (iOS/Android)

### 10. UI Updates
- ❌ Aggiornare `TelevideoViewer` per gestire `isHtmlContent`
- ❌ Mostrare HTML quando `isHtmlContent == true`
- ❌ Mostrare PNG quando `isHtmlContent == false`

---

## 📝 Note Tecniche

### Differenze Formato RAI vs ARD

| Aspetto | RAI | ARD |
|---------|-----|-----|
| **Formato** | PNG (immagini) | HTML (span + immagini caratteri) |
| **URL Base** | televideo.rai.it | ard-text.de |
| **Endpoint** | tt4web + pagina.jsp | page_only.php |
| **Sottopagine** | URL: page-XXX.N.png | URL param: &sub=N |
| **Link** | HTML map con coordinate | Tag `<a>` con href |
| **Regioni** | 20 regioni italiane | 8 broadcaster tedeschi |

### Struttura URL ARD
```
Nazionale: https://www.ard-text.de/page_only.php?page=100&sub=1
Regionale: https://www.ard-text.de/page_only.php?page=100&sub=1 
           (stesso endpoint, pagine diverse per broadcaster)
```

### HTML ARD Sample
```html
<div id='page_1'>
  <div>
    <span class='fgw bgw'><nobr>Testo...</nobr></span>
    <span class='fgbl bgw'>
      <a href='/index.php?page=104'>104</a>
    </span>
  </div>
</div>
```

---

## 🚀 Prossimi Passi

1. ✅ Attendere completamento `build_runner`
2. ⏭️ Verificare errori di compilazione
3. ⏭️ Implementare factory provider nel Bloc
4. ⏭️ Creare widget HTML viewer
5. ⏭️ Testare caricamento pagina ARD 100
6. ⏭️ Testare navigazione tra pagine ARD

---

## 📦 Dipendenze Aggiuntive Necessarie

```yaml
dependencies:
  flutter_html: ^3.0.0-beta.2  # Per rendering HTML ARD
  # oppure
  webview_flutter: ^4.4.2      # Alternativa con WebView
```

---

**Ultimo aggiornamento**: 2025-10-09 00:15
**Branch**: feature/multi-channel-europe
**Status**: 🟡 In Progress (60% completato)


