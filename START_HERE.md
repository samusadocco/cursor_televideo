# 🚀 START HERE - Polsat Provider

## ✅ Situazione Attuale

```
🔍 Versione attiva: WEBVIEW (simulatore iOS)
📱 Pronto per compilare su: SIMULATORE iOS
```

---

## 🎯 PROSSIMO PASSO: Compila su Simulatore

### In Xcode (già configurato):

```bash
open ios/Runner.xcworkspace
```

**Poi in Xcode:**
1. Seleziona **iPhone 17** (o altro simulatore) dal menu dispositivi
2. **Product → Clean Build Folder** (⇧⌘K)
3. **Product → Run** (⌘R)

**L'app dovrebbe compilare e avviarsi sul simulatore! 🎉**

---

## 🔄 Per Switchare Versione

### ✅ Script Automatici (RACCOMANDATO)

**Per simulatore iOS:**
```bash
./use-webview.sh    # ✅ GIÀ ATTIVO
```

**Per device fisico:**
```bash
./use-mlkit.sh
flutter run -d 00008101-001435943EA1001E
```

### 🔍 Verifica Versione Attiva

```bash
./check-version.sh
```

---

## 📊 Cosa Fanno gli Script?

Gli script gestiscono **automaticamente**:

1. ✅ **Provider Polsat** (ML Kit o WebView)
2. ✅ **pubspec.yaml** (con/senza google_mlkit_text_recognition)
3. ✅ **flutter pub get** (installa/rimuove dipendenze)
4. ✅ **pod install** (configura pods iOS)

**Tempo totale: ~5-6 secondi** per switch completo!

---

## 📁 Struttura Repository

```
Project Root/
├── _config_versions/              # 📦 Configurazioni master
│   ├── pubspec.mlkit.yaml        # Con ML Kit
│   └── pubspec.webview.yaml      # Senza ML Kit
│
├── lib/core/teletext/providers/
│   ├── _versions/                 # 📄 Provider master
│   │   ├── polsat_provider.mlkit.dart
│   │   └── polsat_provider.webview.dart
│   └── polsat_provider.dart       # ⚡ ATTIVO (webview)
│
├── pubspec.yaml                   # ⚡ ATTIVO (webview)
│
├── use-mlkit.sh                   # Switch a ML Kit
├── use-webview.sh                 # Switch a WebView
└── check-version.sh               # Verifica versione
```

---

## 💡 Regole Importanti

### ❌ NON Modificare Direttamente:
- `lib/core/teletext/providers/polsat_provider.dart`
- `pubspec.yaml`

**Questi file vengono sovrascritti dagli script!**

### ✅ Modifica i File Master:
- `lib/core/teletext/providers/_versions/*.dart`
- `_config_versions/pubspec.*.yaml`

**Poi riesegui lo script appropriato.**

---

## 📚 Documentazione Completa

- **[README_POLSAT.md](README_POLSAT.md)** - Quick start e FAQ
- **[POLSAT_VERSIONI.md](POLSAT_VERSIONI.md)** - Documentazione tecnica completa

---

## 🎯 Quick Commands

```bash
# Verifica versione attiva
./check-version.sh

# Switch a WebView (simulatore)
./use-webview.sh

# Switch a ML Kit (device)
./use-mlkit.sh

# Compila su simulatore
open ios/Runner.xcworkspace
# Poi Run in Xcode

# Compila su device
flutter run -d 00008101-001435943EA1001E
```

---

## 🆘 Problemi Comuni

### "Sandbox not in sync"
```bash
cd ios && pod install && cd ..
```

### Xcode non trova simulatore
**Usa sempre Xcode per simulatore** (non `flutter run -d`):
1. `open ios/Runner.xcworkspace`
2. Seleziona simulatore dal menu
3. Run (⌘R)

### App lenta su simulatore
È normale! WebView è ~4x più lento di ML Kit:
- WebView (simulator): ~2000ms
- ML Kit (device): ~500ms

**Per performance reali: usa device fisico**

---

## ✅ Tutto Pronto!

**Configurazione attuale:**
- ✅ Provider WebView attivo
- ✅ pubspec.yaml senza ML Kit
- ✅ Pods sincronizzati
- ✅ Pronto per simulatore iOS

**Vai in Xcode e compila! 🚀**

```bash
open ios/Runner.xcworkspace
```

---

**Ultimo aggiornamento: 30 Gennaio 2026, ore 19:40**
