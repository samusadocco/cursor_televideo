# Versione 1.0.9+11 - Changelog

## Data: 08 Ottobre 2025

### 🎯 Obiettivo
Conformità alle norme di Google Play per le app di news e completamento del supporto multilingua.

---

## 📋 Modifiche Principali

### 1. ✅ **Pagina di Supporto**
- **File**: `lib/features/settings/presentation/pages/support_page.dart`
- Aggiunta pagina completa di supporto accessibile dalle Impostazioni
- Contiene:
  - Email di contatto: samuele@codebysam.it
  - Sito web di supporto: www.codebysam.it/teleretro/support.html
  - FAQ complete (geolocalizzazione, preferiti, tema, offline, segnalazione problemi)
  - Informazioni versione app
  - Istruzioni per segnalare bug

### 2. 🌍 **Localizzazione Completa (16 Lingue)**
- **File modificati**: 
  - `lib/core/l10n/translations/app_*.arb` (16 file)
  - `lib/core/l10n/app_localizations_*.dart` (16 file generati)

#### Lingue Supportate:
✅ Italiano (it)
✅ Inglese (en)
✅ Tedesco (de)
✅ Francese (fr)
✅ Spagnolo (es)
✅ Portoghese (pt)
✅ Olandese (nl)
✅ Danese (da)
✅ Svedese (sv)
✅ Finlandese (fi)
✅ Ceco (cs)
✅ Croato (hr)
✅ Sloveno (sl)
✅ Ungherese (hu)
✅ Islandese (is)
✅ Bosniaco (bs)

#### Nuove Stringhe Aggiunte (25 per lingua):
- `support` - Titolo "Supporto"
- `supportDescription` - "Contattaci per assistenza"
- `supportTitle` - Titolo pagina supporto
- `supportSubtitle` - Sottotitolo
- `directContact` - "Contatto Diretto"
- `emailLabel` - "Email"
- `websiteLabel` - "Sito Web"
- `responseTime` - Tempo di risposta
- `faq` - "Domande Frequenti"
- `faqGeolocation` + Answer
- `faqFavorites` + Answer
- `faqTheme` + Answer
- `faqOffline` + Answer
- `faqReportProblem` + Answer
- `reportBugTitle`
- `reportBugInstructions`
- `reportBugItems`
- `developedBy`
- `errorOpeningLink`
- `errorOpeningEmail`

**Totale stringhe tradotte**: 400+ (25 stringhe × 16 lingue)

### 3. 📱 **Versioning iOS & Android**
- **pubspec.yaml**: `version: 1.0.9+11`
- **iOS** (`pubspec.yaml`):
  - `buildNumber: 11`
- **Android** (`android/app/build.gradle.kts`):
  - `versionCode = 11`
  - `versionName = "1.0.9"`

### 4. 📝 **Version History (16 lingue)**
- **File modificati**: `lib/core/version_history_*.json` (16 file)
- Changelog aggiunto per versione 1.0.9:
  - Italiano: "Aggiunta la sezione Supporto all'interno delle Impostazioni", "Supporto completo per 16 lingue europee", "Migliorata l'esperienza utente"
  - Inglese: "Added Support section in Settings", "Full support for 16 European languages", "Improved user experience"
  - (+ traduzioni equivalenti per tutte le altre 14 lingue)

### 5. ⚙️ **Settings Page**
- **File**: `lib/features/settings/presentation/pages/settings_page.dart`
- Aggiunto ListTile "Supporto" in fondo alla lista (prima delle info versione)
- Naviga a `SupportPage` al tap
- Icona: `Icons.support_agent`
- Descrizione localizzata

---

## 🔧 File Modificati

### File Principali
1. `pubspec.yaml` - Versione aggiornata
2. `android/app/build.gradle.kts` - versionCode e versionName
3. `lib/features/settings/presentation/pages/settings_page.dart` - Menu Supporto
4. **NUOVO**: `lib/features/settings/presentation/pages/support_page.dart`

### File di Localizzazione (34 file)
- 16 file `.arb` (traduzioni)
- 18 file `.dart` generati (AppLocalizations)

### File Version History (16 file)
- `lib/core/version_history_*.json`

---

## ✅ Conformità Google Play

### Requisiti Soddisfatti:
✅ **Email di contatto**: samuele@codebysam.it
✅ **Sito web di supporto**: www.codebysam.it/teleretro/support.html
✅ **Pagina in-app facilmente accessibile**: Impostazioni → Supporto
✅ **Informazioni chiare e visibili**
✅ **FAQ per assistenza utenti**

---

## 📊 Statistiche

- **File modificati totali**: 52
- **Lingue supportate**: 16
- **Stringhe tradotte**: 400+
- **Dimensione implementazione**: ~2500 righe di codice

---

## 🚀 Prossimi Passi

1. ✅ Testare su iOS Simulator
2. ⏳ Testare su dispositivo iOS reale
3. ⏳ Build release per Android
4. ⏳ Build release per iOS
5. ⏳ Submit a Google Play Store
6. ⏳ Submit a Apple App Store

---

## 📌 Note

- La pagina Supporto utilizza `url_launcher` per aprire email e link web
- Tutte le traduzioni sono state verificate per accuratezza
- Il version history è sincronizzato su tutte le lingue
- La versione è incrementata sia per iOS che per Android

---

**Compilato e testato**: ✅ iOS Simulator (iPhone 17)
**Branch**: `main`
**Commit pronto**: Sì

