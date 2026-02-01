# 🎯 Quick Start: Configurazione OCR (Polsat + Zattoo)

## ⚡ TL;DR

```bash
# Per SIMULATORE iOS:
./use-webview.sh         # Switch automatico (provider + deps + pods)
open ios/Runner.xcworkspace
# Seleziona simulatore e Run (⌘R)

# Per DEVICE FISICO:
./use-mlkit.sh          # Switch automatico (provider + deps + pods)
flutter run -d 00008101-001435943EA1001E
```

**Gli script gestiscono TUTTO automaticamente**: provider, dipendenze, pods! 🚀

---

## 📱 Compilazione su **SIMULATORE iOS**

### 1️⃣ Attiva versione WebView:
```bash
./use-webview.sh
```

**Lo script esegue automaticamente:**
- ✅ Copia `polsat_provider.webview.dart`
- ✅ Copia `pubspec.yaml` **senza ML Kit**
- ✅ Esegue `flutter pub get`
- ✅ Rimuove Pods cache + esegue `pod install`

### 2️⃣ Compila in Xcode:
```bash
open ios/Runner.xcworkspace
```

### 3️⃣ In Xcode:
1. Seleziona **iPhone 17** (o altro simulatore) dalla lista
2. **Product → Clean Build Folder** (⇧⌘K)
3. **Product → Run** (⌘R)

### ✅ Verifica nei log:
```
[Polsat] 🌐 Using WebView OCR (simulator compatible)
[WebView OCR] ⏱️ recognize() completed in 1500ms
```

---

## 📱 Compilazione su **DEVICE FISICO**

### 1️⃣ Attiva versione ML Kit:
```bash
./use-mlkit.sh
```

**Lo script esegue automaticamente:**
- ✅ Copia `polsat_provider.mlkit.dart`
- ✅ Copia `pubspec.yaml` **con ML Kit**
- ✅ Esegue `flutter pub get`
- ✅ Esegue `pod install`

### 2️⃣ Compila su device:
```bash
flutter run -d 00008101-001435943EA1001E
```

### ✅ Verifica nei log:
```
[Polsat] 🚀 Using ML Kit OCR (fast, device only)
[MLKit OCR] ⏱️ OCR completed in 300ms
```

---

## 🔄 Cosa Fanno gli Script?

### `./use-webview.sh` (Simulatore)

```
📄 [1/4] Copia polsat_provider.webview.dart
         ↓
📦 [2/4] Copia pubspec.yaml SENZA ML Kit
         ↓
🔄 [3/4] flutter pub get (rimuove dipendenze ML Kit)
         ↓
🍎 [4/4] pod install (rimuove GoogleMLKit pods)
         ↓
       ✅ Pronto per simulatore iOS (~6s)
```

### `./use-mlkit.sh` (Device)

```
📄 [1/4] Copia polsat_provider.mlkit.dart
         ↓
📦 [2/4] Copia pubspec.yaml CON ML Kit
         ↓
🔄 [3/4] flutter pub get (installa ML Kit)
         ↓
🍎 [4/4] pod install (installa GoogleMLKit pods)
         ↓
       ✅ Pronto per device fisico (~5s)
```

---

## ❓ FAQ

### Quale versione devo usare?

| Scenario | Versione | Script | Tempo |
|----------|----------|--------|-------|
| 🎨 Testing UI su simulatore | WebView | `./use-webview.sh` | ~2000ms OCR |
| 🔧 Sviluppo quotidiano | ML Kit + device | `./use-mlkit.sh` | ~500ms OCR |
| 🚀 Release build | ML Kit | `./use-mlkit.sh` | ~500ms OCR |
| 🐛 Debug simulator | WebView | `./use-webview.sh` | ~2000ms OCR |

### Posso avere entrambe attive?

❌ **NO!** Solo una configurazione può essere attiva alla volta.

Usa gli script per switchare - gestiscono automaticamente provider, dipendenze e pods.

### Perché devo switchare anche il pubspec.yaml?

ML Kit include frameworks nativi iOS che:
- ❌ Non funzionano su simulatore arm64
- ❌ Causano errori di linking
- ❌ Appesantiscono l'app inutilmente per testing

Rimuovendo ML Kit per simulatore: tutto funziona! ✅

### Come modifico il codice Polsat?

⚠️ **NON modificare:**
- `lib/core/teletext/providers/polsat_provider.dart`
- `pubspec.yaml`

✅ **Modifica i file master:**
- `lib/core/teletext/providers/_versions/polsat_provider.mlkit.dart`
- `lib/core/teletext/providers/_versions/polsat_provider.webview.dart`
- `_config_versions/pubspec.mlkit.yaml`
- `_config_versions/pubspec.webview.yaml`

Poi riesegui lo script appropriato.

### Gli script sono lenti?

No! Switch completo in **5-6 secondi**:
- Copia file: istantaneo
- `flutter pub get`: ~2-3s
- `pod install`: ~2-3s

---

## 🚀 Workflow Consigliato

### Per Sviluppo (device fisico, veloce):
```bash
./use-mlkit.sh
flutter run -d <device>
```

**Vantaggi:**
- ⚡ OCR velocissimo (~500ms)
- ✅ Hot reload veloce
- ✅ Performance reali
- ✅ Testing completo

### Per Testing UI (simulatore, multi-device):
```bash
./use-webview.sh
open ios/Runner.xcworkspace
# Test su iPhone 15, 17, iPad Pro, etc.
```

**Vantaggi:**
- ✅ Test layout diversi
- ✅ Nessun problema architettura
- ✅ Quick UI iteration
- 🐢 Più lento ma funzionale

### Per Release:
```bash
./use-mlkit.sh
flutter build ipa --release
```

---

## 🆘 Troubleshooting

### "The sandbox is not in sync with the Podfile.lock"

```bash
cd ios && pod install && cd ..
```

Oppure riesegui lo script:
```bash
./use-webview.sh  # o ./use-mlkit.sh
```

### Script fallisce durante pub get

```bash
flutter clean
./use-webview.sh  # riprova
```

### Xcode: "Unable to find a destination"

Il simulatore non è sincronizzato con Xcode.

**Soluzione:** lancia sempre da Xcode per simulatore:
1. `open ios/Runner.xcworkspace`
2. Seleziona simulatore da menu
3. Run (⌘R)

### App lenta su simulatore

È normale! WebView OCR è ~4x più lento di ML Kit:
- WebView (simulator): ~2000ms
- ML Kit (device): ~500ms

Per performance reali: usa device fisico con ML Kit.

---

## 📊 Performance Comparison

| Versione | OCR Method | Load Time | Target |
|----------|-----------|-----------|--------|
| **ML Kit** | Google ML Kit (native) | ~800ms total | Device fisico ✅ |
| **WebView** | JavaScript recognize() | ~2300ms total | Simulatore iOS ✅ |

**Breakdown dettagliato:**

### ML Kit (Device):
```
HEAD request:      300ms
Image download:    200ms
ML Kit OCR:        300ms
─────────────────────────
Total:            ~800ms  ⚡
```

### WebView (Simulator):
```
HEAD request:      300ms
WebView load:      500ms
recognize() JS:   1500ms
─────────────────────────
Total:           ~2300ms  🐢
```

---

## 📚 Documentazione Completa

Per maggiori dettagli: **[POLSAT_VERSIONI.md](POLSAT_VERSIONI.md)**

Include:
- 📂 Struttura completa file repository
- 🔧 Dettagli tecnici su pubspec.yaml e Pods
- ✅ Checklist completa prima di commit
- 🎓 Note tecniche architettura iOS
- 🆘 Troubleshooting avanzato

---

## ✅ Pronto all'Uso!

**Prossimo step:**

### Simulatore iOS (ADESSO):

```bash
# Script già eseguito! ✅
# ./use-webview.sh

# In Xcode:
open ios/Runner.xcworkspace
# 1. Product → Clean Build Folder (⇧⌘K)
# 2. Seleziona iPhone 17 simulator
# 3. Product → Run (⌘R)
```

### Device Fisico:

```bash
./use-mlkit.sh
flutter run -d 00008101-001435943EA1001E
```

---

## 🎉 Tutto Automatizzato!

Gli script gestiscono **tutto** per te:
- ✅ Provider Polsat (ML Kit o WebView)
- ✅ Dipendenze pubspec.yaml (con/senza ML Kit)
- ✅ Flutter pub get (install/remove packages)
- ✅ iOS Pods (GoogleMLKit o solo WebView)

**Un comando, zero problemi!** 🚀

---

**Ultimo aggiornamento: 30 Gennaio 2026**
