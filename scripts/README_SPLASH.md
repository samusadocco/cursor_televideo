# Script per Generazione Splash Screen

## Overview

Questo documento descrive come generare le immagini di splash screen personalizzate per l'app TeleRetrò.

## File Generati

Lo script `generate_splash_images.py` genera due versioni dell'immagine di splash:

1. **`splash_italia.png`** - Per utenti in Italia
   - Testo: "TeleRetrò Europa"
   - Stile: CRT vintage con effetti scanlines, aberrazione cromatica e bagliore verde

2. **`splash_international.png`** - Per utenti in altri paesi
   - Testo: "Teletext Europe"
   - Stile: Identico a quello italiano

## Utilizzo

### Generazione delle Immagini

```bash
cd scripts
python3 generate_splash_images.py
```

Le immagini verranno generate in `assets/images/splash/`.

### Versioni Generate

Per ogni immagine vengono create tre risoluzioni:
- **1024x1024** - Versione ad alta risoluzione
- **512x512** - Versione media
- **256x256** - Versione ottimizzata per dispositivi meno potenti

## Personalizzazione

### Modifica del Testo

Per modificare il testo visualizzato, modifica la funzione `generate_splash_images()` in `generate_splash_images.py`:

```python
# Per Italia
splash_italia = create_splash_screen_image("TeleRetrò", "Europa", 1024)

# Per altri paesi
splash_international = create_splash_screen_image("Teletext", "Europe", 1024)
```

### Modifica dello Stile

Puoi personalizzare i seguenti parametri nella funzione `create_splash_screen_image()`:

- **Colore del testo**: `fill='#50ff50'` (verde fosforescente)
- **Intensità bagliore**: `enhance(2.0)` nella sezione glow
- **Intensità scanlines**: `fill='#111111'` e `Image.blend(..., 0.15)`
- **Distorsione CRT**: `intensity=0.3` in `create_crt_distortion()`
- **Aberrazione cromatica**: `offset=3` in `add_chromatic_aberration()`
- **Rumore**: `intensity=10` in `add_noise()`

### Font Personalizzato

Lo script usa il font **VT323** (stile terminal vintage). Se vuoi cambiare font:

1. Sostituisci il file `scripts/fonts/VT323-Regular.ttf`
2. Oppure modifica `FONT_PATH` nello script

## Integrazione nell'App

### iOS: LaunchScreen Nativa

iOS mostra **PRIMA** una schermata di lancio nativa (`LaunchScreen.storyboard`) che usa le immagini `LaunchImage`.

**File coinvolti:**
- `ios/Runner/Base.lproj/LaunchScreen.storyboard` - Storyboard che riferisce `LaunchImage`
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/` - Contiene tutte le immagini

**Attualmente:** Usa la versione **internazionale** ("Teletext Europe") come default.

**Per localizzare per paese (opzionale):**

1. Apri Xcode: `open ios/Runner.xcworkspace`
2. Seleziona `Runner/Assets.xcassets` nel Navigator
3. Crea una nuova cartella `LaunchImage-Italia.imageset`
4. Copia le immagini generate da `splash_italia.png`
5. In `LaunchScreen.storyboard`, aggiungi localizzazione italiana
6. Imposta `LaunchImage-Italia` per la localizzazione `it`

**Nota:** La localizzazione iOS richiede build separate per App Store per paese.

### Flutter: Transizione Diretta all'App

**NOTA IMPORTANTE:** Il Flutter SplashScreen widget è stato **rimosso** per evitare doppia splash screen.

L'app ora usa **solo** la LaunchScreen nativa iOS, che:
- ✅ È istantanea (< 0.5s)
- ✅ Mostra "Teletext Europe" (versione internazionale)
- ✅ Transizione diretta all'app dopo il caricamento

**Immagini Flutter splash disponibili ma non usate:**
Le immagini in `assets/images/splash/` (Italia + International) sono disponibili se in futuro si vuole aggiungere uno splash screen dinamico dopo il caricamento dell'app, ma attualmente **non sono utilizzate** per evitare una doppia splash screen.

**Se vuoi riabilitare lo splash Flutter dinamico:**
1. Wrappa `OnboardingWrapper` con `SplashScreen` in `main.dart`
2. La personalizzazione per paese funzionerà automaticamente
3. **Considera:** Questo mostrerà due splash consecutive (iOS + Flutter)

## Aggiunta di Nuovi Paesi

Per aggiungere immagini specifiche per altri paesi:

1. Genera una nuova immagine in `generate_splash_images()`:
   ```python
   splash_germany = create_splash_screen_image("Teletext", "Deutschland", 1024)
   splash_germany.save(OUTPUT_DIR / "splash_de.png")
   ```

2. Modifica `_detectStoreCountry()` in `splash_screen.dart`:
   ```dart
   final splashImage = switch(country.toLowerCase()) {
     'it' => 'assets/images/splash/splash_italia.png',
     'de' => 'assets/images/splash/splash_de.png',
     _ => 'assets/images/splash/splash_international.png',
   };
   ```

## Dipendenze

- Python 3
- Pillow (PIL)
- Font VT323 (scaricato automaticamente se non presente)

## Note Tecniche

### Effetti Applicati

1. **Distorsione Barrel CRT**: Simula la curvatura dei vecchi monitor CRT
2. **Scanlines**: Linee orizzontali tipiche dei monitor a tubo catodico
3. **Aberrazione Cromatica**: Leggera separazione dei canali RGB
4. **Bagliore (Glow)**: Effetto di fosforescenza del testo
5. **Rumore**: Grana tipica dei segnali analogici
6. **Blur finale**: Ammorbidisce l'immagine per un aspetto più realistico

### Performance

Le immagini generate sono ottimizzate per:
- Caricamento rapido all'avvio
- Dimensioni file ragionevoli (~ 700KB per 1024x1024)
- Qualità visiva elevata su tutti i dispositivi

## Troubleshooting

**Errore: Font non trovato**
- Lo script scaricherà automaticamente il font VT323 da GitHub
- Se fallisce, scarica manualmente da: https://github.com/phoikoi/VT323

**Errore: Pillow non installato**
```bash
pip3 install Pillow
```

**Le immagini non si vedono nell'app**
- Verifica che `assets/images/splash/` sia in `pubspec.yaml`
- Esegui `flutter clean && flutter pub get`
- Riavvia l'app

## Manutenzione

Rigenera le immagini quando:
- Cambi il nome dell'app
- Modifichi lo stile visivo dell'app
- Aggiungi supporto per nuovi paesi
- Vuoi aggiornare gli effetti visivi

