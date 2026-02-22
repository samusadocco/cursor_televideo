# 🧪 Testing dello Stato Premium

Guida per testare l'app con l'abbonamento Premium attivo senza effettuare acquisti reali.

## 🎮 Metodo 1: Toggle nelle Impostazioni (CONSIGLIATO)

**Il modo più semplice per testare!**

### Come usare:

1. **Avvia l'app in modalità debug**
   ```bash
   flutter run
   ```

2. **Vai nelle Impostazioni** dell'app

3. **Scorri in fondo** - vedrai una sezione arancione "DEBUG MODE"

4. **Attiva lo switch** "🌟 Simula Abbonamento Premium"
   - ✅ **ON** = Abbonamento ATTIVO
   - ❌ **OFF** = Abbonamento NON attivo

5. **Riavvia l'app** per vedere la rimozione completa degli annunci

### Cosa succede:
- ✅ Gli annunci banner vengono nascosti
- ✅ Gli annunci interstitial non vengono più mostrati
- ✅ La pagina Premium mostra "Abbonamento Attivo"
- ✅ Le impostazioni mostrano il badge verde "Premium"

### ⚠️ IMPORTANTE:
- Questo toggle appare **SOLO in modalità debug** (quando compili con `flutter run`)
- In modalità release (build per store), il toggle **NON è visibile**
- Lo stato viene salvato in SharedPreferences e persiste tra sessioni

---

## 🔧 Metodo 2: Modificare SharedPreferences manualmente

### Su iOS (Simulatore):

```bash
# Trova l'app
xcrun simctl get_app_container booted it.codebysam.televideo

# Naviga nella cartella Library/Preferences
# Cerca il file .plist e modifica 'is_premium_user' = true
```

### Su Android (Emulatore):

```bash
# Accedi alla shell
adb shell

# Naviga ai dati dell'app
cd /data/data/it.codebysam.televideo/shared_prefs

# Modifica il file XML
vi FlutterSecureStorage.xml
# oppure
cat FlutterSecureStorage.xml

# Cerca la chiave 'is_premium_user' e impostala a true
```

### Metodo più semplice (Flutter DevTools):

1. Avvia l'app con `flutter run`
2. Premi `v` nella console per aprire DevTools
3. Vai su **"Inspector"**
4. Nella console, esegui:
   ```dart
   import 'package:shared_preferences/shared_preferences.dart';
   final prefs = await SharedPreferences.getInstance();
   await prefs.setBool('is_premium_user', true);
   print('Premium activated!');
   ```

---

## 🖥️ Metodo 3: Hot Reload con codice temporaneo

### Opzione A: Attiva sempre il premium in debug

Nel file `lib/main.dart`, dopo l'inizializzazione di IAP Service:

```dart
// Inizializza il servizio In-App Purchase
final iapService = IAPService(prefs);
final iapInitialized = await iapService.initialize();

// TESTING: Attiva sempre premium in debug
if (kDebugMode) {
  await iapService.setPremiumStatusForTesting(true);
  print('🌟 DEBUG: Premium mode activated!');
}
```

### Opzione B: Forza sempre isPremium() a true

Nel file `lib/core/iap/iap_service.dart`, modifica temporaneamente:

```dart
/// Verifica se l'utente è premium
bool isPremium() {
  // TESTING: Forza sempre premium in debug
  if (kDebugMode) return true;
  
  return _prefs.getBool(_isPremiumKey) ?? false;
}
```

⚠️ **RICORDA**: Rimuovi queste modifiche prima del deploy in produzione!

---

## 🔄 Metodo 4: Script per attivare/disattivare rapidamente

Crea uno script shell per attivare/disattivare velocemente:

### `toggle_premium.sh`:

```bash
#!/bin/bash

# Colori per output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Controlla stato corrente
ADB_OUTPUT=$(adb shell "run-as it.codebysam.televideo cat shared_prefs/FlutterSecureStorage.xml" 2>/dev/null | grep "is_premium_user")

if [[ $ADB_OUTPUT == *"true"* ]]; then
    echo -e "${RED}❌ Disattivazione Premium...${NC}"
    NEW_VALUE="false"
else
    echo -e "${GREEN}✅ Attivazione Premium...${NC}"
    NEW_VALUE="true"
fi

# Modifica il valore
adb shell "run-as it.codebysam.televideo sed -i 's/is_premium_user\" value=\".*\"/is_premium_user\" value=\"$NEW_VALUE\"/' shared_prefs/FlutterSecureStorage.xml"

echo -e "${GREEN}✅ Fatto! Riavvia l'app per vedere i cambiamenti.${NC}"
```

Rendi eseguibile:
```bash
chmod +x toggle_premium.sh
./toggle_premium.sh
```

---

## 🧪 Scenario di Testing Completo

### Test 1: Verifica rimozione annunci

1. ✅ Avvia l'app **senza** premium
2. ✅ Naviga tra le pagine - verifica che gli annunci appaiano:
   - Banner in fondo alla schermata
   - Interstitial ogni 10 pagine
3. ✅ Attiva premium dal toggle in Impostazioni
4. ✅ Riavvia l'app
5. ✅ Naviga tra le pagine - verifica che **non ci siano annunci**

### Test 2: Verifica UI Premium

1. ✅ Attiva premium
2. ✅ Vai su **Impostazioni** → Badge dorato diventa verde con "Abbonamento Attivo"
3. ✅ Clicca sul badge → Pagina Premium mostra "Abbonamento Attivo" con checkmark verde
4. ✅ Disattiva premium → Badge torna dorato "Abbonati a Premium"

### Test 3: Verifica persistenza stato

1. ✅ Attiva premium
2. ✅ Chiudi completamente l'app (force quit)
3. ✅ Riapri l'app
4. ✅ Verifica che lo stato premium sia ancora attivo

### Test 4: Verifica ripristino

1. ✅ Attiva premium
2. ✅ Disinstalla l'app
3. ✅ Reinstalla e avvia
4. ✅ Lo stato premium dovrebbe essere resettato (nuovo utente)

---

## 📊 Verifica Stato Premium nei Log

Quando l'app si avvia, cerca questi log nella console:

### Premium ATTIVO:
```
[AdService] IAP Service configured
[AdService] User is premium, ads disabled
[AdService] Premium user, skipping ad logic
```

### Premium NON attivo:
```
[AdService] IAP Service configured
Conteggio visualizzazioni: 1/10 | Banner refresh: 1/8
🎯 Raggiunta pagina 6, inizio caricamento annuncio...
```

---

## 🚨 Troubleshooting

### Gli annunci appaiono ancora dopo aver attivato premium

**Soluzione**: Devi **riavviare completamente l'app**
- Hot reload NON è sufficiente
- Chiudi l'app completamente e riaprila

### Il toggle non appare nelle Impostazioni

**Causa**: L'app è in modalità release
**Soluzione**: Avvia con `flutter run` (debug mode)

### Lo stato premium si perde al riavvio

**Causa**: SharedPreferences non viene salvato correttamente
**Verifica**:
```dart
final prefs = await SharedPreferences.getInstance();
print('Premium status: ${prefs.getBool('is_premium_user')}');
```

### Gli annunci non ripartono dopo aver disattivato premium

**Soluzione**: Riavvia l'app completamente

---

## 🎯 Checklist Testing Completo

Prima di rilasciare l'app, verifica:

- [ ] Gli annunci appaiono per utenti NON premium
- [ ] Gli annunci NON appaiono per utenti premium
- [ ] Il banner è nascosto per utenti premium
- [ ] Gli interstitial non vengono mostrati per utenti premium
- [ ] La pagina Premium mostra lo stato corretto
- [ ] Il badge nelle Impostazioni è corretto
- [ ] Lo stato persiste tra riavvii app
- [ ] Il toggle debug NON appare in release build
- [ ] Il ripristino acquisti funziona (con sandbox tester)
- [ ] L'acquisto reale funziona (con sandbox tester)

---

## 🚀 Dopo il Testing

**IMPORTANTE**: Prima di creare la build di produzione:

1. ✅ Rimuovi eventuali modifiche temporanee al codice
2. ✅ Non lasciare `setPremiumStatusForTesting(true)` nel codice
3. ✅ Non forzare `isPremium()` a `true` in debug
4. ✅ Verifica con `flutter build release` che il toggle debug non sia visibile
5. ✅ Testa la build release su un dispositivo fisico

```bash
# Verifica che non ci siano riferimenti di testing
grep -r "setPremiumStatusForTesting" lib/
grep -r "clearPremiumStatus" lib/

# Build release per verificare
flutter build apk --release
# oppure
flutter build ipa --release
```

---

## 💡 Tips

1. **Usa il toggle nelle Impostazioni** - È il metodo più comodo e sicuro
2. **Riavvia sempre l'app** dopo aver cambiato lo stato premium
3. **Controlla i log** per verificare che AdService rilevi correttamente lo stato
4. **Non dimenticare di rimuovere** modifiche temporanee prima del deploy!

---

**Happy Testing! 🎉**
