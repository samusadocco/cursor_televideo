# 🌍 Strategia di Internazionalizzazione TeleRetrò

## 📋 Sommario Esecutivo

**Decisione:** Evolvere l'app esistente anziché crearne una nuova.

**Nome App:**
- **Device/In-app:** `TeleRetrò` (generico, già implementato ✅)
- **Store Listings:** Personalizzato per paese (vedi sotto)

**Bundle ID/Package:** Manteniamo quello attuale
- iOS: `it.codebysam.teleretroitalia`
- Android: `it.codebysam.televideo`

---

## 🎯 Strategia "Smart Branding"

### Nomi negli Store per Paese

#### Google Play Store (Android)
| Paese | Store Listing Name | Sottotitolo |
|-------|-------------------|-------------|
| 🇮🇹 Italia | TeleRetrò Italia | RAI Televideo Retrò |
| 🇬🇧 UK | TeleRetrò UK | BBC Ceefax & Teletext |
| 🇩🇪 Germania | TeleRetrò Deutschland | ARD Text & Videotext |
| 🇫🇷 Francia | TeleRetrò France | Télétexte France TV |
| 🇦🇹 Austria | TeleRetrò Austria | ORF Teletext |
| 🇨🇭 Svizzera | TeleRetrò Schweiz | SRF Text & Teletext |
| 🇳🇱 Olanda | TeleRetrò Nederland | NOS Teletekst |
| 🇧🇪 Belgio | TeleRetrò België | VRT & RTBF Télétexte |
| 🇪🇸 Spagna | TeleRetrò España | Teletexto TVE |

#### Apple App Store (iOS)
**Nome globale:** `TeleRetrò Europe`

**Sottotitoli localizzati:**
- 🇮🇹 Italiano: "RAI Televideo e Teletext Europei"
- 🇬🇧 English: "European Teletext & BBC Ceefax"
- 🇩🇪 Deutsch: "Europäisches Teletext & ARD Text"
- 🇫🇷 Français: "Télétexte Européen & France TV"
- 🇪🇸 Español: "Teletexto Europeo & TVE"

---

## 🏗️ Architettura Tecnica

### Sistema Multi-Provider

```dart
// 1. Provider astratto base
abstract class TeletextProvider {
  String get countryCode;
  String get broadcasterName;
  String get flagEmoji;
  Future<TeletextPage> getPage(int pageNumber, {int subPage});
  bool get supportsRegions;
  List<String> get availableRegions;
}

// 2. Implementazioni specifiche
class RAITeletextProvider extends TeletextProvider {
  @override
  String get countryCode => 'IT';
  @override
  String get broadcasterName => 'RAI Televideo';
  @override
  String get flagEmoji => '🇮🇹';
  @override
  bool get supportsRegions => true;
  // ... implementazione
}

class BBCCeefaxProvider extends TeletextProvider {
  @override
  String get countryCode => 'UK';
  @override
  String get broadcasterName => 'BBC Ceefax';
  @override
  String get flagEmoji => '🇬🇧';
  @override
  bool get supportsRegions => false;
  // ... implementazione
}

// 3. Registry dei provider
class TeletextProviderRegistry {
  static final Map<String, TeletextProvider> providers = {
    'IT': RAITeletextProvider(),
    'UK': BBCCeefaxProvider(),
    'DE': ARDTeletextProvider(),
    'FR': FranceTVTeletextProvider(),
    'AT': ORFTeletextProvider(),
    'CH': SRFTeletextProvider(),
    'NL': NOSTeletextProvider(),
    'BE': VRTTeletextProvider(),
    'ES': TVETeletextProvider(),
  };
  
  static TeletextProvider getProvider(String countryCode) {
    return providers[countryCode] ?? providers['IT']!;
  }
}
```

---

## 🌍 Servizi Teletext Europei

### Fase 1 - Lancio Iniziale
| Paese | Broadcaster | URL/API | Priorità | Status |
|-------|-------------|---------|----------|--------|
| 🇮🇹 Italia | RAI Televideo | `televideo.rai.it` | Alta | ✅ Implementato |
| 🇬🇧 UK | BBC Ceefax/Red Button | `bbc.co.uk/ceefax` | Alta | 📋 TODO |
| 🇩🇪 Germania | ARD Text | `ard-text.de` | Alta | 📋 TODO |

### Fase 2 - Espansione
| Paese | Broadcaster | URL/API | Priorità | Status |
|-------|-------------|---------|----------|--------|
| 🇫🇷 Francia | France TV Télétexte | `france.tv/teletexte` | Media | 📋 TODO |
| 🇦🇹 Austria | ORF Teletext | `teletext.orf.at` | Media | 📋 TODO |
| 🇨🇭 Svizzera | SRF Text | `srf.ch/teletext` | Media | 📋 TODO |
| 🇳🇱 Olanda | NOS Teletekst | `nos.nl/teletekst` | Media | 📋 TODO |
| 🇧🇪 Belgio | VRT/RTBF | `vrt.be/teletekst` | Bassa | 📋 TODO |
| 🇪🇸 Spagna | TVE Teletexto | `rtve.es/teletexto` | Bassa | 📋 TODO |

---

## 📱 UI/UX Modifiche

### Selettore Paese nella Home

```dart
// Posizione: Homepage, drawer o settings
Widget _buildCountrySelector() {
  return DropdownButton<String>(
    value: currentProvider.countryCode,
    items: TeletextProviderRegistry.providers.entries.map((e) {
      return DropdownMenuItem(
        value: e.key,
        child: Row(
          children: [
            Text(e.value.flagEmoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(e.value.broadcasterName),
          ],
        ),
      );
    }).toList(),
    onChanged: (countryCode) {
      if (countryCode != null) {
        context.read<TelevideoBloc>().add(
          TelevideoEvent.changeProvider(countryCode),
        );
      }
    },
  );
}
```

### Salvare la Preferenza Utente

```dart
// Salvare nel SharedPreferences
class TeletextSettings {
  static const _selectedCountryKey = 'selected_country';
  
  static Future<void> saveCountry(String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCountryKey, countryCode);
  }
  
  static Future<String> getSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    // Default: paese del dispositivo o Italia
    return prefs.getString(_selectedCountryKey) ?? _getDeviceCountry();
  }
  
  static String _getDeviceCountry() {
    final locale = PlatformDispatcher.instance.locale;
    final countryCode = locale.countryCode?.toUpperCase() ?? 'IT';
    // Verifica se supportato, altrimenti default IT
    return TeletextProviderRegistry.providers.containsKey(countryCode) 
        ? countryCode 
        : 'IT';
  }
}
```

---

## 📅 Timeline di Sviluppo

### Sprint 1-2 (2 settimane) - Architettura
- [x] Rebrand nome app a "TeleRetrò"
- [ ] Creare abstract class `TeletextProvider`
- [ ] Refactoring `TelevideoRepository` → `RAITeletextProvider`
- [ ] Implementare `TeletextProviderRegistry`
- [ ] Test unitari per il sistema provider

### Sprint 3-4 (2 settimane) - Provider Principali
- [ ] Ricerca API BBC Ceefax/Red Button
- [ ] Implementare `BBCCeefaxProvider`
- [ ] Ricerca API ARD Text
- [ ] Implementare `ARDTeletextProvider`
- [ ] Test integrazione UK e DE

### Sprint 5 (1 settimana) - UI
- [ ] Widget selettore paese
- [ ] Integrazione con `TelevideoBloc`
- [ ] Persistenza preferenza utente
- [ ] Schermata onboarding per selezione paese iniziale
- [ ] Test UI/UX

### Sprint 6 (1 settimana) - Localizzazione Store
- [ ] Preparare testi Play Store per IT, UK, DE
- [ ] Preparare screenshot per ogni paese
- [ ] Preparare testi App Store
- [ ] Video promo multilingua

### Sprint 7+ - Espansione
- [ ] Implementare Francia, Austria, Svizzera
- [ ] Implementare Olanda, Belgio
- [ ] Implementare Spagna

---

## 💰 Considerazioni di Business

### Vantaggi Unica App
✅ **Base utenti consolidata** - mantieni rating e recensioni
✅ **Costi ridotti** - una sola codebase da mantenere
✅ **Marketing semplificato** - un solo brand da promuovere
✅ **Analytics unificati** - dati centralizzati
✅ **Update simultanei** - tutti gli utenti aggiornati insieme

### Monetizzazione
- **Ads esistenti** mantengono revenue da utenti italiani
- **Espansione mercato** → più utenti → più impressions
- **Potenziale Premium** → versione a pagamento senza ads per paese

---

## 🚀 Deployment Strategy

### Fase 1: Soft Launch Beta
1. **Italia:** Aggiornamento graduale (mantieni utenti esistenti)
2. **UK:** Beta chiusa con TestFlight/Internal Testing
3. **Germania:** Beta chiusa

### Fase 2: Public Release
1. Release simultaneo su tutti gli store
2. Monitoraggio crash/feedback per paese
3. Hotfix rapidi se necessario

### Fase 3: Marketing
1. Press release per ogni paese
2. Social media campaign localizzata
3. Collaborazione con blog/siti nostalgici

---

## 📊 KPI e Metriche

### Metriche da Monitorare
- **Adozione per paese:** % download per nazione
- **Retention:** Utenti attivi giornalmente/mensilmente per paese
- **Feature Usage:** Quale provider è più usato
- **Crash Rate:** Per provider e versione OS
- **Revenue:** Ad impressions per paese

### Target Q1 2025
- 🇮🇹 Italia: Mantieni 1,000+ utenti attivi
- 🇬🇧 UK: 500+ nuovi utenti
- 🇩🇪 Germania: 300+ nuovi utenti

---

## ⚠️ Rischi e Mitigazioni

| Rischio | Impatto | Probabilità | Mitigazione |
|---------|---------|-------------|-------------|
| API provider non pubbliche | Alto | Media | Contattare broadcaster per partnership |
| CORS issues per web scraping | Alto | Alta | Implementare proxy server se necessario |
| Differenze formato pagine | Medio | Alta | Parsing flessibile, test su dataset reale |
| Diritti d'autore contenuti | Alto | Bassa | Uso fair use, link a fonti ufficiali |
| Performace multi-provider | Medio | Bassa | Cache aggressiva, lazy loading |

---

## 📝 Note Tecniche

### File Modificati (già fatto ✅)
- ✅ `android/app/src/main/AndroidManifest.xml` - Nome generico "TeleRetrò"
- ✅ `ios/Runner/Info.plist` - Nome generico "TeleRetrò"
- ✅ `pubspec.yaml` - Descrizione generalizzata
- ✅ `macos/Runner/Configs/AppInfo.xcconfig` - Nome generico

### Prossimi File da Creare
- [ ] `lib/core/teletext/teletext_provider.dart` - Abstract class
- [ ] `lib/core/teletext/providers/rai_provider.dart` - RAI implementation
- [ ] `lib/core/teletext/providers/bbc_provider.dart` - BBC implementation
- [ ] `lib/core/teletext/providers/ard_provider.dart` - ARD implementation
- [ ] `lib/core/teletext/teletext_registry.dart` - Provider registry
- [ ] `lib/features/settings/presentation/widgets/country_selector.dart` - UI widget

---

## 🔗 Risorse Utili

### API Documentation
- RAI Televideo: https://www.televideo.rai.it
- BBC Red Button: https://www.bbc.co.uk/iplayer/help/questions/technical-questions/red-button
- ARD Text: https://www.ard-text.de
- Teletext Archive: http://www.teletextmuseum.com/

### Community
- Reddit: r/teletext
- GitHub: Teletext-related projects

---

## 📞 Contatti e Support

Per domande tecniche sull'internazionalizzazione:
- Developer: Samuele (samu.sadocco@gmail.com)
- Project: cursor_televideo

---

**Ultimo aggiornamento:** 2025-01-07
**Versione documento:** 1.0

