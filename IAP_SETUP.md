# Configurazione In-App Purchase per Teletext Europe

Questa guida ti aiuterà a configurare gli In-App Purchase (IAP) per l'app Teletext Europe su App Store Connect (iOS) e Google Play Console (Android).

## 📱 Configurazione iOS (App Store Connect)

### 1. Accedi ad App Store Connect
1. Vai su [App Store Connect](https://appstoreconnect.apple.com/)
2. Seleziona "My Apps"
3. Seleziona la tua app "Teletext Europe"

### 2. Crea il prodotto IAP
1. Vai alla sezione **"In-App Purchases"**
2. Clicca sul pulsante **"+"** per creare un nuovo prodotto
3. Seleziona **"Non-Consumable"** (acquisto permanente)
4. Compila i seguenti campi:

#### Informazioni di base
- **Product ID**: `remove_ads_premium`
  - ⚠️ IMPORTANTE: Questo ID deve corrispondere esattamente a quello nel codice
  - Non può essere modificato dopo la creazione
- **Reference Name**: "Premium - Remove Ads"
  - Questo è solo per la tua gestione interna
- **Cleared for Sale**: Attiva questa opzione

#### Prezzi e disponibilità
1. Clicca su **"Add Pricing"**
2. Seleziona il **Tier di prezzo** appropriato:
   - **Tier 2** (€2.99) - Prezzo consigliato per entry-level premium
   - **Tier 3** (€3.49)
   - **Tier 4** (€4.49)
   - **Tier 5** (€5.49) - Prezzo più alto
3. Conferma i prezzi automatici per tutti i paesi

#### Localizzazioni
Per ogni lingua supportata dall'app, aggiungi una localizzazione:

**Italiano (it)**
- **Display Name**: "Teletext Premium"
- **Description**: "Rimuovi tutta la pubblicità e supporta lo sviluppo dell'app. Acquisto unico, valido per sempre su tutti i tuoi dispositivi."

**English (en)**
- **Display Name**: "Teletext Premium"
- **Description**: "Remove all ads and support the app development. One-time purchase, valid forever on all your devices."

**Deutsch (de)**
- **Display Name**: "Teletext Premium"
- **Description**: "Entfernen Sie alle Werbung und unterstützen Sie die App-Entwicklung. Einmaliger Kauf, für immer gültig auf allen Ihren Geräten."

**Français (fr)**
- **Display Name**: "Teletext Premium"
- **Description**: "Supprimez toutes les publicités et soutenez le développement de l'application. Achat unique, valide pour toujours sur tous vos appareils."

**Español (es)**
- **Display Name**: "Teletext Premium"
- **Description**: "Elimina toda la publicidad y apoya el desarrollo de la aplicación. Compra única, válida para siempre en todos tus dispositivos."

**Altri**: Aggiungi le altre lingue seguendo lo stesso schema

#### Screenshot (richiesto)
- Carica uno screenshot dell'interfaccia di acquisto Premium (640x920 px minimo)
- Puoi fare uno screenshot della `PremiumPage` implementata nell'app

### 3. Invia per revisione
1. Salva il prodotto IAP
2. Invia il prodotto per la revisione Apple (lo farai insieme all'app)

### 4. Testing
**Importante**: Per testare gli IAP su iOS, devi creare un **Sandbox Tester Account**:

1. In App Store Connect, vai su **"Users and Access"**
2. Clicca su **"Sandbox Testers"**
3. Clicca sul **"+"** per aggiungere un tester
4. Compila i campi:
   - Email (usa un email che NON è già un Apple ID)
   - Password
   - Paese
5. Conferma l'email del tester
6. Sul dispositivo di test:
   - **Non** fare login con l'Apple ID reale
   - Quando fai un acquisto di test, l'app ti chiederà di fare login
   - Usa le credenziali del Sandbox Tester

---

## 🤖 Configurazione Android (Google Play Console)

### 1. Accedi a Google Play Console
1. Vai su [Google Play Console](https://play.google.com/console/)
2. Seleziona la tua app "Teletext Europe"

### 2. Configura l'account commerciante (se necessario)
Prima di poter vendere IAP, devi configurare un account commerciante Google:
1. Vai su **"Monetizzazione" > "Configurazione monetizzazione"**
2. Segui le istruzioni per creare o collegare un account Google Merchant
3. Completa la verifica dell'identità e le informazioni fiscali

### 3. Crea il prodotto IAP
1. Vai su **"Monetizzazione" > "Prodotti" > "Prodotti in-app"**
2. Clicca su **"Crea prodotto"**
3. Compila i seguenti campi:

#### Informazioni di base
- **Product ID**: `remove_ads_premium`
  - ⚠️ IMPORTANTE: Questo ID deve corrispondere esattamente a quello nel codice
  - Non può essere modificato dopo la creazione
- **Nome**: "Teletext Premium"
- **Descrizione**: Breve descrizione interna (non visibile agli utenti)

#### Dettagli del prodotto
- **Status**: Attivo
- **Tipo**: **Prodotto gestito** (Non consumabile)

#### Prezzi
1. Clicca su **"Imposta prezzo"**
2. Hai due opzioni:
   
   **Opzione A - Prezzo base unico:**
   - Seleziona un paese base (es. Italia)
   - Imposta il prezzo base (es. €2.99, €3.49, €4.49)
   - Google convertirà automaticamente il prezzo per tutti gli altri paesi
   
   **Opzione B - Prezzi per paese:**
   - Imposta prezzi diversi per ogni paese/regione
   - Prezzi suggeriti:
     - Italia: €2.99 - €4.99
     - Germania: €2.99 - €4.99
     - Francia: €2.99 - €4.99
     - UK: £2.49 - £3.99
     - USA: $2.99 - $4.99
     - Altri paesi: utilizza l'equivalente in valuta locale

#### Descrizioni localizzate
Per ogni lingua supportata, aggiungi una localizzazione:

**Italiano (it-IT)**
- **Titolo**: "Teletext Premium"
- **Descrizione**: "Rimuovi tutta la pubblicità (banner e interstitial) e supporta lo sviluppo dell'app. Acquisto unico, valido per sempre su tutti i tuoi dispositivi."

**English (en-US)**
- **Titolo**: "Teletext Premium"
- **Descrizione**: "Remove all ads (banners and interstitials) and support app development. One-time purchase, valid forever on all your devices."

**Deutsch (de-DE)**
- **Titolo**: "Teletext Premium"
- **Descrizione**: "Entfernen Sie alle Werbung (Banner und Interstitials) und unterstützen Sie die App-Entwicklung. Einmaliger Kauf, für immer gültig auf allen Ihren Geräten."

**Aggiungi le altre lingue seguendo lo stesso schema**

### 4. Attiva il prodotto
1. Rivedi tutti i dettagli
2. Clicca su **"Attiva"**
3. Il prodotto sarà disponibile immediatamente per i test

### 5. Testing
Per testare gli IAP su Android:

1. **Aggiungi tester tramite track di test (consigliato)**:
   - Vai su **"Test" > "Test interno"** (o "Test chiuso")
   - Crea una lista di tester con le email dei tuoi account Google
   - Distribuisci una build di test
   - I tester potranno fare acquisti reali a prezzo ridotto (€0.99) o gratuiti

2. **Oppure usa License Testing**:
   - Vai su **"Impostazioni" > "Testing delle licenze"**
   - Aggiungi gli account Google dei tester
   - Questi account potranno fare acquisti di test senza essere addebitati

---

## 🔧 Configurazione Tecnica nel Codice

### ID del Prodotto
L'ID del prodotto è definito in:
```dart
// lib/core/iap/iap_service.dart
static const String _premiumProductId = 'remove_ads_premium';
```

Se vuoi cambiare l'ID del prodotto:
1. Modifica questa costante nel codice
2. Crea nuovi prodotti IAP su App Store Connect e Google Play Console con il nuovo ID
3. Aggiorna e ridistribuisci l'app

### Verifica Server-Side (Raccomandato per Produzione)
Attualmente l'app accetta tutti gli acquisti come validi. Per la sicurezza in produzione, dovresti:

1. Implementare un backend che verifichi i receipt/token
2. Modificare il metodo `_verifyPurchase` in `iap_service.dart`:

```dart
Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
  // Invia il receipt al tuo server
  final response = await http.post(
    Uri.parse('https://your-backend.com/verify-purchase'),
    body: {
      'receipt': purchaseDetails.verificationData.serverVerificationData,
      'platform': Platform.isIOS ? 'ios' : 'android',
    },
  );
  
  // Il server verifica con Apple/Google e risponde
  return response.statusCode == 200;
}
```

3. Il server deve:
   - **iOS**: Verificare il receipt con Apple usando `verifyReceipt` API
   - **Android**: Verificare il purchase token con Google Play Developer API

---

## 🧪 Testing dell'implementazione

### Test su dispositivo reale
1. **iOS**:
   - Esci dal tuo Apple ID nelle Impostazioni > App Store
   - Avvia l'app
   - Vai su Impostazioni > Premium
   - Clicca su "Acquista Premium"
   - Quando richiesto, usa le credenziali del Sandbox Tester
   - Completa l'acquisto (non verrai addebitato)
   - Verifica che:
     - Gli annunci scompaiano
     - Lo stato Premium sia salvato
     - Il ripristino funzioni dopo reinstallazione

2. **Android**:
   - Assicurati di essere loggato con un account Google di test
   - Avvia l'app
   - Vai su Impostazioni > Premium
   - Clicca su "Acquista Premium"
   - Completa l'acquisto di test
   - Verifica che:
     - Gli annunci scompaiano
     - Lo stato Premium sia salvato
     - Il ripristino funzioni dopo reinstallazione

### Debug dei problemi comuni

#### "Prodotto non trovato"
- Verifica che il Product ID nel codice corrisponda esattamente a quello negli store
- Su iOS, aspetta qualche minuto dopo aver creato il prodotto
- Su Android, assicurati che il prodotto sia "Attivo"

#### "Acquisto fallito"
- iOS: Verifica di essere loggato con un Sandbox Tester account
- Android: Verifica di essere nella lista dei tester
- Controlla i log per messaggi di errore specifici

#### "Lo stato Premium non viene salvato"
- Verifica che SharedPreferences sia inizializzato correttamente
- Controlla i log per vedere se `_unlockPremium()` viene chiamato
- Prova a disinstallare e reinstallare l'app

---

## 📊 Monitoraggio delle vendite

### iOS (App Store Connect)
- Vai su **"Sales and Trends"**
- Seleziona "In-App Purchases" per vedere le vendite
- Puoi filtrare per prodotto, data, paese

### Android (Google Play Console)
- Vai su **"Monetizzazione" > "Panoramica"**
- Vedi statistiche dettagliate su:
  - Entrate per prodotto
  - Conversioni
  - Utenti attivi con acquisti

---

## 🎯 Prezzi Consigliati per Paese

| Paese | Prezzo Consigliato |
|-------|-------------------|
| Italia | €2.99 - €4.99 |
| Germania | €2.99 - €4.99 |
| Francia | €2.99 - €4.99 |
| Spagna | €2.99 - €4.99 |
| Regno Unito | £2.49 - £3.99 |
| USA | $2.99 - $4.99 |
| Polonia | 12-20 PLN |
| Paesi Bassi | €2.99 - €4.99 |
| Paesi Nordici | 29-49 NOK/SEK/DKK |

**Nota**: Questi sono solo suggerimenti. Puoi sperimentare con prezzi diversi per ottimizzare le conversioni.

---

## 📝 Note Finali

1. **Privacy Policy**: Assicurati che la tua privacy policy menzioni gli In-App Purchase
2. **Refunds**: Sia Apple che Google gestiscono i rimborsi direttamente
3. **Tasse**: Le tasse sono gestite automaticamente da Apple/Google
4. **Commissioni**:
   - Apple: 30% (15% dopo il primo anno con un abbonamento)
   - Google: 30% (15% dopo il primo anno con un abbonamento)
   - Per acquisti non ricorrenti come questo: 30% sempre

---

## 🆘 Supporto

Se incontri problemi:
- **iOS**: Consulta la [documentazione Apple StoreKit](https://developer.apple.com/documentation/storekit/in-app_purchase)
- **Android**: Consulta la [documentazione Google Play Billing](https://developer.android.com/google/play/billing)
- **Flutter**: Consulta la [documentazione in_app_purchase](https://pub.dev/packages/in_app_purchase)

---

**Ultimo aggiornamento**: Gennaio 2026
