# Checklist: Abbonamenti non visibili nell'app (Sandbox)

Se nella pagina Premium vedi "Premium subscription not available" invece dei piani mensile/trimestrale, i prodotti non vengono caricati da App Store. Controlla questi punti.

---

## 1. Verifica in App Store Connect

### App e Bundle ID
- L'app **Teletext Europe** esiste in App Store Connect?
- Il **Bundle ID** dell'app in App Store Connect deve essere **esattamente** quello del progetto iOS
- Nel progetto: `it.codebysam.teleretro` (da `ios/Runner.xcodeproj`)

### Prodotti IAP
In **App Store Connect** → la tua app → **Monetizzazione** → **Abbonamenti**:

- [ ] Esiste il prodotto `premium_subscription_monthly`?
- [ ] Esiste il prodotto `premium_subscription_quarterly2`?
- [ ] Entrambi sono **"Pronti per l’invio"** / **"Ready to Submit"**?
- [ ] **"Disponibile per la vendita"** / **"Cleared for Sale"** è attivo?
- [ ] Sono nello stesso **Subscription Group**?
- [ ] Hanno almeno un **Base Plan** attivo con prezzo impostato?

### Contratti e pagamenti
- [ ] **Contratti, tariffazione e banking** → **Paid Applications** → accordo firmato
- [ ] Dati bancari e fiscali completati (a volte richiesti per gli IAP)

---

## 2. Come stai eseguendo l'app?

| Metodo | Sandbox attivo? |
|--------|------------------|
| `flutter run` su dispositivo | ✅ Sì |
| Xcode → Run su dispositivo | ✅ Sì |
| TestFlight | ✅ Sì |
| Build Release/IPA installata manualmente | ⚠️ Dipende dal provisioning |
| App Store (produzione) | ❌ No, usa produzione |

Per i test Sandbox usa **`flutter run`** o **Xcode → Run** sul dispositivo.

---

## 3. Provisioning e firma

- L’app deve essere firmata con un **Development** o **Ad Hoc** provisioning profile
- Il **Team** e il **Signing Certificate** devono essere corretti in Xcode
- Apri `ios/Runner.xcworkspace` in Xcode → **Signing & Capabilities** → verifica che non ci siano errori

---

## 4. Controlla i log

Con l’app in esecuzione sul dispositivo, apri la pagina Premium e guarda la console (Xcode o `flutter run`).

Cerca messaggi come:
```
[IAPService] Loaded X products
[IAPService] ✅ Product: premium_subscription_monthly - ...
[IAPService] ⚠️ Products not found: [premium_subscription_monthly, ...]
[IAPService] ❌ NESSUN PRODOTTO CARICATO!
```

- **"Products not found"** → Product ID non trovati (configurazione in App Store Connect)
- **"Error loading products"** → problema di rete, firma o configurazione
- **"Store not available"** → StoreKit non disponibile (es. simulatore)

---

## 5. Tempi di propagazione

Dopo aver creato o modificato prodotti in App Store Connect:
- Attendi **2–4 ore** (a volte fino a 24h) prima di testare
- In alcuni casi serve un **riavvio del dispositivo**

---

## 6. Test rapido con StoreKit (Xcode)

Se il Sandbox continua a non funzionare:

1. Apri il progetto in Xcode: `ios/Runner.xcworkspace`
2. **Product** → **Scheme** → **Edit Scheme**
3. **Run** → **Options**
4. In **StoreKit Configuration** seleziona o crea un file `.storekit`
5. Crea un file StoreKit con i Product ID `premium_subscription_monthly` e `premium_subscription_quarterly2`
6. Esegui l’app da Xcode: userà i prodotti locali invece del Sandbox

---

## 7. Riepilogo Product ID richiesti

L’app si aspetta esattamente questi ID:
- `premium_subscription_monthly`
- `premium_subscription_quarterly2`

Devono essere identici in App Store Connect (maiuscole/minuscole incluse).
