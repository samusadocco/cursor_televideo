# 📱 Gestione Versioni Polsat Provider

## 🎯 Problema

ML Kit non funziona su **simulatore iOS** (problemi di architettura), ma è velocissimo su **device fisici**.

## ✅ Soluzione: Due Versioni Complete

Il repository contiene **due configurazioni complete** separate:

### 📦 Versione ML Kit (Device Fisici)
- **Provider**: `polsat_provider.mlkit.dart`
- **Dipendenze**: `pubspec.mlkit.yaml` (con `google_mlkit_text_recognition`)
- **Pods**: Include GoogleMLKit
- **Performance**: ⚡ ~500ms
- **Target**: iPhone/iPad fisici, Android

### 🌐 Versione WebView (Simulatore iOS)
- **Provider**: `polsat_provider.webview.dart`
- **Dipendenze**: `pubspec.webview.yaml` (senza ML Kit)
- **Pods**: Solo WebView
- **Performance**: 🐢 ~2000ms
- **Target**: Simulatori iOS

---

## 🔄 Come Switchare

### Per Compilare su **Device Fisico** (veloce):

```bash
./use-mlkit.sh
```

**Lo script esegue automaticamente:**
1. ✅ Copia `polsat_provider.mlkit.dart` → `polsat_provider.dart`
2. ✅ Copia `pubspec.mlkit.yaml` → `pubspec.yaml`
3. ✅ Esegue `flutter pub get`
4. ✅ Esegue `cd ios && pod install`

Poi:
```bash
flutter run -d 00008101-001435943EA1001E
```

### Per Compilare su **Simulatore iOS** (compatibile):

```bash
./use-webview.sh
```

**Lo script esegue automaticamente:**
1. ✅ Copia `polsat_provider.webview.dart` → `polsat_provider.dart`
2. ✅ Copia `pubspec.webview.yaml` → `pubspec.yaml`
3. ✅ Esegue `flutter pub get`
4. ✅ Rimuove Pods cache e esegue `pod install`

Poi in Xcode:
1. `open ios/Runner.xcworkspace`
2. Seleziona simulatore
3. Product → Clean Build Folder (⇧⌘K)
4. Product → Run (⌘R)

---

## 📂 Struttura File Repository

```
Project Root/
├── _config_versions/                    # 📁 Repository configurazioni master
│   ├── pubspec.mlkit.yaml              # Con google_mlkit_text_recognition
│   └── pubspec.webview.yaml            # Senza ML Kit
│
├── lib/core/teletext/providers/
│   ├── _versions/                       # 📁 Repository provider master
│   │   ├── polsat_provider.mlkit.dart  # 🚀 ML Kit (device)
│   │   └── polsat_provider.webview.dart # 🌐 WebView (simulator)
│   └── polsat_provider.dart             # ⚡ File ATTIVO (copiato da _versions/)
│
├── pubspec.yaml                         # ⚡ File ATTIVO (copiato da _config_versions/)
│
├── use-mlkit.sh                         # Script switch ML Kit
└── use-webview.sh                       # Script switch WebView
```

---

## 🔧 Cosa Fa Ogni Script

### `use-mlkit.sh` (Device Fisici)

```bash
[1/4] Copia polsat_provider.mlkit.dart
      ↓
[2/4] Copia pubspec.mlkit.yaml (con ML Kit)
      ↓
[3/4] flutter pub get (installa dipendenze)
      ↓
[4/4] pod install (ios/)
      ↓
    ✅ Pronto per device fisico
```

### `use-webview.sh` (Simulatore)

```bash
[1/4] Copia polsat_provider.webview.dart
      ↓
[2/4] Copia pubspec.webview.yaml (senza ML Kit)
      ↓
[3/4] flutter pub get (rimuove ML Kit)
      ↓
[4/4] Rimuove Pods cache + pod install
      ↓
    ✅ Pronto per simulatore iOS
```

---

## ⚠️ IMPORTANTE: File da Modificare

### ❌ NON modificare direttamente:
- `lib/core/teletext/providers/polsat_provider.dart`
- `pubspec.yaml`

**Questi file vengono sovrascritti dagli script!**

### ✅ Modifica i file MASTER:

**Per modificare il provider:**
- `lib/core/teletext/providers/_versions/polsat_provider.mlkit.dart`
- `lib/core/teletext/providers/_versions/polsat_provider.webview.dart`

**Per modificare dipendenze:**
- `_config_versions/pubspec.mlkit.yaml`
- `_config_versions/pubspec.webview.yaml`

**Poi riesegui lo script appropriato:**
```bash
./use-mlkit.sh    # o use-webview.sh
```

---

## 📊 Differenze tra le Versioni

| Aspetto | ML Kit | WebView |
|---------|--------|---------|
| **Provider** | MLKitPolsatOcrService | WebViewPolsatOcrService |
| **OCR Method** | Google ML Kit (native) | JavaScript recognize() |
| **pubspec.yaml** | Include `google_mlkit_text_recognition` | Solo `webview_flutter` + `html` |
| **Pods iOS** | GoogleMLKit frameworks | Solo WebView |
| **Architettura** | arm64 device | arm64/x86_64 simulator |
| **Performance** | ⚡ ~500ms | 🐢 ~2000ms |
| **Target** | Device fisici | Simulatori iOS |

---

## 🚀 Workflow Consigliato

### 1. Sviluppo Quotidiano → Device Fisico (veloce)

```bash
./use-mlkit.sh
flutter run -d 00008101-001435943EA1001E
```

**Vantaggi:**
- ✅ Performance reali (~500ms)
- ✅ Hot reload velocissimo
- ✅ Testing completo features
- ✅ Esperienza utente reale

### 2. Testing UI → Simulatore (multi-device)

```bash
./use-webview.sh
open ios/Runner.xcworkspace
# Seleziona simulatore e Run
```

**Vantaggi:**
- ✅ Test su iPhone/iPad diversi
- ✅ Nessun problema architettura
- ✅ Quick UI testing
- 🐢 Più lento ma funzionale

### 3. Release Build → ML Kit (production)

```bash
./use-mlkit.sh
flutter build ipa --release
```

---

## 🎯 Quale Usare?

| Scenario | Comando | Tempo Switch | Note |
|----------|---------|--------------|------|
| 🔧 Sviluppo quotidiano | `./use-mlkit.sh` | ~5s | Device fisico, veloce |
| 🎨 Testing UI layout | `./use-webview.sh` | ~6s | Simulatore, multi-device |
| 🐛 Debug su simulator | `./use-webview.sh` | ~6s | Simulatore compatibile |
| 🚀 Release build | `./use-mlkit.sh` | ~5s | ML Kit per production |

---

## ✅ Checklist Prima di Commit

Prima di committare modifiche a Polsat:

1. ✅ **Modifica i file master** in `_versions/` e `_config_versions/`
2. ✅ **Testa versione ML Kit:**
   ```bash
   ./use-mlkit.sh
   flutter run -d <device-id>
   # Verifica che OCR funzioni (~500ms)
   ```
3. ✅ **Testa versione WebView:**
   ```bash
   ./use-webview.sh
   open ios/Runner.xcworkspace
   # Run su simulatore, verifica OCR (~2000ms)
   ```
4. ✅ **Lascia attiva versione ML Kit** (default per production):
   ```bash
   ./use-mlkit.sh
   git add .
   git commit -m "Update Polsat provider"
   ```

---

## 📊 Performance Log Examples

### ML Kit (Device):
```
[Polsat] 🚀 Using ML Kit OCR (fast, device only)
[Polsat] ⏱️ HEAD request: 300ms
[MLKit OCR] ⏱️ Image downloaded: 200ms
[MLKit OCR] ⏱️ OCR completed: 300ms
[Polsat] ✅ Total: ~800ms
```

### WebView (Simulator):
```
[Polsat] 🌐 Using WebView OCR (simulator compatible)
[Polsat] ⏱️ HEAD request: 300ms
[WebView OCR] ⏱️ Page loaded: 500ms
[WebView OCR] ⏱️ recognize() completed: 1500ms
[Polsat] ✅ Total: ~2300ms
```

---

## 🎉 Vantaggi della Soluzione

- ✅ **Switch automatico completo** - Provider + dipendenze + Pods
- ✅ **Zero conflitti** - Una sola configurazione attiva
- ✅ **Nessun problema architettura** - Configurazioni separate ottimizzate
- ✅ **Performance ottimali** - ML Kit su device, WebView su simulator
- ✅ **Manutenzione facile** - File master separati e ben documentati
- ✅ **Veloce** - Switch completo in ~5-6 secondi
- ✅ **Sicuro** - Script gestiscono tutto automaticamente

---

## 🆘 Troubleshooting

### Script fallisce su "flutter pub get"
```bash
# Manuale:
flutter clean
flutter pub get
```

### Script fallisce su "pod install"
```bash
# Manuale:
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

### Xcode dice "Sandbox not in sync"
```bash
# Riesegui pod install:
cd ios && pod install && cd ..
```

### Dipendenza non trovata
Assicurati di usare lo script giusto:
- ML Kit non compila su simulator → `./use-webview.sh`
- WebView più lento su device → `./use-mlkit.sh`

---

## 🎓 Note Tecniche

### Perché Due pubspec.yaml?

ML Kit (`google_mlkit_text_recognition`) include frameworks nativi che:
1. Non supportano arm64 simulator su iOS
2. Causano errori di linking su simulatore
3. Aumentano dimensione app inutilmente per testing UI

Rimuovendo ML Kit dal pubspec.yaml per simulatore:
- ✅ Compilazione funziona su arm64 simulator
- ✅ Pods più leggeri e veloci
- ✅ Nessun problema di architettura

### Perché Pod Install Ogni Volta?

Il pod install è necessario perché:
- ML Kit aggiunge ~15 pods (GoogleMLKit, MLKitTextRecognition, etc.)
- WebView ha molti meno pods
- Il `Podfile.lock` deve essere rigenerato con i pod corretti

Lo script rimuove la cache Pods per garantire una pulizia completa.

---

**Documentazione aggiornata: 30 Gennaio 2026**
