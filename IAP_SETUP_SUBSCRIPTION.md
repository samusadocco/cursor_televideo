# Configurazione Abbonamento Trimestrale per Teletext Europe

Questa guida ti aiuterà a configurare l'**abbonamento trimestrale ricorrente** per l'app Teletext Europe su App Store Connect (iOS) e Google Play Console (Android).

## 📱 Configurazione iOS (App Store Connect)

### 1. Accedi ad App Store Connect
1. Vai su [App Store Connect](https://appstoreconnect.apple.com/)
2. Seleziona "My Apps"
3. Seleziona la tua app "Teletext Europe"

### 2. Crea l'abbonamento
1. Vai alla sezione **"Subscriptions"** (o "In-App Purchases" > "Auto-Renewable Subscriptions")
2. Se è il primo abbonamento, crea prima un **Subscription Group**:
   - Nome: "Teletext Premium"
   - Group ID: lascia quello generato automaticamente
3. All'interno del gruppo, clicca sul **"+"** per creare un nuovo abbonamento
4. Seleziona **"Auto-Renewable Subscription"**

#### Informazioni di base
- **Product ID**: `premium_subscription_quarterly2`
  - ⚠️ IMPORTANTE: Questo ID deve corrispondere esattamente a quello nel codice
  - Non può essere modificato dopo la creazione
- **Reference Name**: "Premium Quarterly Subscription"
  - Questo è solo per la tua gestione interna
- **Subscription Duration**: **3 Months** (trimestrale)

#### Prezzi
1. Clicca su **"Add Subscription Pricing"**
2. Seleziona il prezzo appropriato per ogni paese:
   - **Italia**: €2.99, €3.99, o €4.99 ogni 3 mesi
   - **Stati Uniti**: $2.99, $3.99, o $4.99 ogni 3 mesi
   - **Germania**: €2.99, €3.99, o €4.99 ogni 3 mesi
   - Altri paesi: equivalente locale

**Consiglio**: Inizia con €2.99-€3.99 per massimizzare le conversioni.

#### Free Trial (Opzionale ma Consigliato)
Per aumentare le conversioni, puoi offrire un periodo di prova gratuito:
1. Vai su **"Free Trial"**
2. Seleziona la durata: **7 giorni** o **14 giorni** (consigliati)
3. Gli utenti non verranno addebitati durante il periodo di prova
4. L'abbonamento inizia automaticamente dopo il periodo di prova

#### Introductory Offer (Opzionale)
Puoi offrire uno sconto per i primi 3 mesi:
1. Vai su **"Introductory Offer"**
2. Seleziona **"Pay As You Go"** o **"Pay Up Front"**
3. Esempio: €0.99 per il primo trimestre, poi €2.99

#### Localizzazioni
Per ogni lingua supportata, aggiungi una localizzazione:

**Italiano (it)**
- **Display Name**: "Teletext Premium"
- **Description**: "Abbonamento trimestrale che rimuove tutta la pubblicità e supporta lo sviluppo dell'app. Si rinnova automaticamente ogni 3 mesi. Puoi annullare in qualsiasi momento."

**English (en)**
- **Display Name**: "Teletext Premium"
- **Description**: "Quarterly subscription that removes all ads and supports app development. Automatically renews every 3 months. Cancel anytime."

**Deutsch (de)**
- **Display Name**: "Teletext Premium"
- **Description**: "Quartalsabonnement, das alle Werbung entfernt und die App-Entwicklung unterstützt. Verlängert sich automatisch alle 3 Monate. Jederzeit kündbar."

**Français (fr)**
- **Display Name**: "Teletext Premium"
- **Description**: "Abonnement trimestriel qui supprime toutes les publicités et soutient le développement de l'application. Se renouvelle automatiquement tous les 3 mois. Annulation possible à tout moment."

**Altri**: Aggiungi le altre lingue seguendo lo stesso schema

#### Screenshot
- Carica uno screenshot dell'interfaccia di abbonamento Premium (640x920 px minimo)

### 3. Configura le App Store Subscription Information
Prima di inviare per revisione, devi configurare:

1. **Privacy Policy URL**: URL della tua privacy policy
2. **Subscription Terms URL** (opzionale): Termini specifici dell'abbonamento

### 4. Invia per revisione
1. Salva l'abbonamento
2. Invia l'abbonamento per la revisione Apple (insieme all'app)

### 5. Testing
Per testare l'abbonamento su iOS:

1. Crea un **Sandbox Tester Account**:
   - In App Store Connect, vai su **"Users and Access"**
   - Clicca su **"Sandbox Testers"**
   - Aggiungi un nuovo tester con email non già usata per Apple ID
   
2. Sul dispositivo di test:
   - **Esci** dal tuo Apple ID reale
   - Avvia l'app e prova ad abbonarti
   - Usa le credenziali del Sandbox Tester quando richiesto
   - L'abbonamento di test verrà accelerato:
     - 3 mesi reali = 5 minuti nel sandbox
     - Potrai testare anche i rinnovi automatici
     - Non verrai mai addebitato

---

## 🤖 Configurazione Android (Google Play Console)

### 1. Accedi a Google Play Console
1. Vai su [Google Play Console](https://play.google.com/console/)
2. Seleziona la tua app "Teletext Europe"

### 2. Configura l'account commerciante
Prima di vendere abbonamenti, devi configurare un account commerciante Google:
1. Vai su **"Monetizzazione" > "Configurazione monetizzazione"**
2. Segui le istruzioni per creare o collegare un account Google Merchant
3. Completa la verifica dell'identità e le informazioni fiscali

### 3. Crea l'abbonamento
1. Vai su **"Monetizzazione" > "Prodotti" > "Abbonamenti"**
2. Clicca su **"Crea abbonamento"**

#### Informazioni di base
- **Product ID**: `premium_subscription_quarterly2`
  - ⚠️ IMPORTANTE: Questo ID deve corrispondere esattamente a quello nel codice
  - Non può essere modificato dopo la creazione
- **Nome**: "Teletext Premium - Quarterly"
- **Descrizione**: Breve descrizione interna (non visibile agli utenti)

#### Stato e tipo
- **Status**: Attivo
- **Tipo**: Abbonamento

#### Piano di base (Base Plan)
Google Play richiede almeno un "Base Plan":

1. Clicca su **"Aggiungi piano base"**
2. **Base Plan ID**: `quarterly-standard` (o altro nome descrittivo)
3. **Periodo di fatturazione**:
   - **Durata**: 3 mesi (P3M in formato ISO 8601)
   - **Tipo rinnovo**: Automatico
4. **Periodo di prova gratuito** (opzionale, consigliato):
   - Durata: 7 giorni o 14 giorni
   - Disponibilità: Solo per nuovi abbonati

#### Prezzi per il piano base
1. Clicca su **"Imposta prezzo"**
2. Hai due opzioni:
   
   **Opzione A - Prezzo base unico:**
   - Seleziona un paese base (es. Italia)
   - Imposta il prezzo trimestrale: €2.99, €3.99, o €4.99
   - Google convertirà automaticamente per altri paesi
   
   **Opzione B - Prezzi per paese:**
   - Imposta prezzi diversi per ogni paese/regione
   - Prezzi suggeriti (ogni 3 mesi):
     - Italia: €2.99 - €4.99
     - Germania: €2.99 - €4.99
     - Francia: €2.99 - €4.99
     - UK: £2.49 - £3.99
     - USA: $2.99 - $4.99
     - Polonia: 12-18 PLN
     - Altri paesi: equivalente locale

#### Offerte speciali (opzionale)
Puoi creare offerte promozionali:
1. **Offerta di lancio**: Primo trimestre a prezzo ridotto (es. €0.99)
2. **Offerta sviluppatore**: Per utenti specifici
3. **Offerta promozionale**: Con codice promozionale

#### Descrizioni localizzate
Per ogni lingua, aggiungi:

**Italiano (it-IT)**
- **Titolo**: "Teletext Premium"
- **Descrizione**: "Abbonamento trimestrale che rimuove tutta la pubblicità (banner e interstitial) e supporta lo sviluppo dell'app. Si rinnova automaticamente ogni 3 mesi. Puoi annullare in qualsiasi momento dalle impostazioni del tuo account Google Play."
- **Benefici**: "Nessuna pubblicità, esperienza fluida, supporto continuo"

**English (en-US)**
- **Titolo**: "Teletext Premium"
- **Descrizione**: "Quarterly subscription that removes all ads (banners and interstitials) and supports app development. Automatically renews every 3 months. Cancel anytime from your Google Play account settings."
- **Benefici**: "No ads, smooth experience, ongoing support"

**Aggiungi le altre lingue seguendo lo stesso schema**

### 4. Attiva l'abbonamento
1. Rivedi tutti i dettagli
2. Clicca su **"Attiva"**
3. L'abbonamento sarà disponibile immediatamente per i test

### 5. Testing
Per testare l'abbonamento su Android:

1. **License Testing** (metodo veloce):
   - Vai su **"Configurazione" > "Testing delle licenze"**
   - Aggiungi gli account Google dei tester
   - Questi account potranno abbonarsi gratuitamente
   - L'abbonamento si comporterà come reale ma senza pagamenti

2. **Track di test** (metodo completo):
   - Vai su **"Test" > "Test interno"** o **"Test chiuso"**
   - Crea una lista di tester
   - Distribuisci una build di test
   - I tester vedranno l'abbonamento ma non verranno addebitati

**Nota**: Gli abbonamenti di test su Android durano normalmente (3 mesi reali). Per testing accelerato, usa License Testing.

---

## 🔧 Configurazione Tecnica nel Codice

Il codice è già stato aggiornato per gestire abbonamenti:

### Product ID
```dart
// lib/core/iap/iap_service.dart
static const String _premiumProductId = 'premium_subscription_quarterly2';
```

### Tipo di acquisto
L'abbonamento usa `buyNonConsumable()` che funziona sia per acquisti singoli che per abbonamenti su entrambe le piattaforme.

### Gestione del rinnovo
Lo store (Apple/Google) gestisce automaticamente:
- ✅ Rinnovi automatici
- ✅ Pagamenti ricorrenti
- ✅ Notifiche di rinnovo agli utenti
- ✅ Annullamenti
- ✅ Fatturazione

### Verifica stato abbonamento
L'app controlla lo stato premium tramite:
1. Eventi di acquisto/rinnovo dallo store
2. Ripristino abbonamenti al lancio
3. Persistenza locale dello stato in SharedPreferences

---

## 💰 Gestione Fatturazione e Rinnovi

### Ciclo di vita dell'abbonamento

**Nuova sottoscrizione:**
1. Utente clicca "Abbonati Ora"
2. Store mostra il prezzo e i termini
3. Utente conferma (con Face ID/Touch ID/Password)
4. Pagamento immediato (se no trial)
5. App sblocca funzionalità premium

**Rinnovo automatico (dopo 3 mesi):**
1. Store tenta il rinnovo 24h prima della scadenza
2. Se pagamento OK → Abbonamento rinnovato automaticamente
3. Se pagamento fallito → Periodo di grazia (opzionale)
4. Notifica all'utente via email/push

**Annullamento:**
- Utente può annullare dalle impostazioni dell'account
- L'abbonamento rimane attivo fino alla fine del periodo pagato
- Non vengono fatti nuovi addebiti
- L'app deve rispettare la data di scadenza

### Commissioni Store
- **Apple**: 30% per il primo anno, poi 15% se l'utente rimane abbonato
- **Google**: 30% per i primi 12 mesi, poi 15%

**Esempio di guadagni con €2.99/trimestre:**
- Anno 1: €2.09/trimestre × 4 = €8.36/anno (70% di €11.96)
- Anno 2+: €2.54/trimestre × 4 = €10.16/anno (85% di €11.96)

---

## 📊 Monitoraggio Abbonamenti

### iOS (App Store Connect)
1. Vai su **"Sales and Trends"**
2. Seleziona **"Subscriptions"**
3. Metriche disponibili:
   - Nuovi abbonati
   - Abbonati attivi
   - Tasso di rinnovo
   - Tasso di cancellazione (churn)
   - Entrate mensili/annuali
   - Trial conversions

### Android (Google Play Console)
1. Vai su **"Monetizzazione" > "Dashboard abbonamenti"**
2. Metriche disponibili:
   - Abbonati attivi
   - Nuove sottoscrizioni
   - Cancellazioni
   - Rinnovi
   - Entrate per periodo
   - Retention rate

---

## 🎯 Prezzi Consigliati per Abbonamento Trimestrale

| Paese | Prezzo Consigliato (ogni 3 mesi) | Equivalente Mensile |
|-------|-----------------------------------|---------------------|
| Italia | €2.99 - €4.99 | €1.00 - €1.66 |
| Germania | €2.99 - €4.99 | €1.00 - €1.66 |
| Francia | €2.99 - €4.99 | €1.00 - €1.66 |
| Spagna | €2.99 - €4.99 | €1.00 - €1.66 |
| Regno Unito | £2.49 - £3.99 | £0.83 - £1.33 |
| USA | $2.99 - $4.99 | $1.00 - $1.66 |
| Polonia | 12-18 PLN | 4-6 PLN |
| Paesi Bassi | €2.99 - €4.99 | €1.00 - €1.66 |
| Paesi Nordici | 29-49 SEK/NOK/DKK | ~10-16 |

**Consiglio**: Inizia con il prezzo più basso (€2.99) per massimizzare le conversioni, poi aumenta gradualmente se vedi buoni risultati.

---

## 🎁 Strategie per Aumentare le Conversioni

### 1. Free Trial (Altamente consigliato)
- Offri 7-14 giorni di prova gratuita
- Aumenta le conversioni del 30-50%
- Gli utenti possono provare senza rischio

### 2. Introductory Offer
- Primo trimestre a €0.99 invece di €2.99
- Ottimo per acquisizione utenti

### 3. Comunicazione chiara
- Mostra chiaramente il prezzo mensile equivalente
- Enfatizza "Cancella quando vuoi"
- Mostra i benefici prima del prezzo

### 4. Timing
- Mostra l'offerta Premium dopo alcune sessioni
- Non interrompere l'esperienza iniziale
- Mostra dopo aver visto 2-3 annunci

---

## ⚠️ Note Legali Importanti

### Informazioni Obbligatorie da Mostrare
Secondo le linee guida Apple e Google, devi comunicare:
- ✅ Prezzo e frequenza di fatturazione
- ✅ Durata dell'abbonamento (3 mesi)
- ✅ Rinnovo automatico
- ✅ Come annullare
- ✅ Termini e condizioni
- ✅ Privacy policy

Questi elementi sono già inclusi nell'UI implementata.

### Gestione Rimborsi
- Apple e Google gestiscono i rimborsi direttamente
- Gli utenti richiedono rimborso tramite lo store
- Tu riceverai una notifica server-to-server (se configurato)
- L'app deve rimuovere l'accesso premium se l'abbonamento è rimborsato

### GDPR e Privacy
- Assicurati che la privacy policy menzioni gli abbonamenti
- Non devi salvare informazioni di pagamento (gestite dagli store)
- Puoi salvare solo lo stato dell'abbonamento (attivo/non attivo)

---

## 🧪 Checklist Pre-Launch

Prima di lanciare l'abbonamento in produzione:

### iOS
- [ ] Abbonamento creato e approvato in App Store Connect
- [ ] Product ID corretto: `premium_subscription_quarterly2`
- [ ] Prezzo impostato per tutti i paesi target
- [ ] Localizzazioni complete
- [ ] Screenshot caricato
- [ ] Privacy Policy URL configurato
- [ ] Testato con Sandbox Tester account
- [ ] Verificato rinnovo automatico in sandbox
- [ ] Verificato annullamento e ripristino

### Android
- [ ] Abbonamento creato e attivo in Google Play Console
- [ ] Product ID corretto: `premium_subscription_quarterly2`
- [ ] Base plan configurato con periodo 3 mesi
- [ ] Prezzi impostati per tutti i paesi target
- [ ] Descrizioni localizzate complete
- [ ] Account commerciante configurato
- [ ] Testato con License Testing
- [ ] Verificato che l'abbonamento appaia nell'app

### App
- [ ] Codice aggiornato con nuovo Product ID
- [ ] Traduzioni aggiornate per "abbonamento"
- [ ] UI mostra chiaramente che è ricorrente
- [ ] Termini di annullamento visibili
- [ ] Funzionalità premium disabilitate per utenti non abbonati
- [ ] Ripristino abbonamenti funzionante

---

## 🆘 Problemi Comuni e Soluzioni

### "Abbonamento non trovato"
- Verifica che il Product ID sia identico nel codice e negli store
- Su iOS, aspetta 10-15 minuti dopo la creazione
- Su Android, assicurati che sia "Attivo"
- Verifica di essere in modalità test corretta

### "Pagamento fallito" in test
- iOS: Assicurati di usare un Sandbox Tester account
- iOS: Non essere loggato con Apple ID reale
- Android: Verifica di essere nella lista License Testers
- Android: Assicurati che l'account merchant sia configurato

### "L'abbonamento non si rinnova"
- In sandbox, i rinnovi sono accelerati (verifica i timing)
- iOS: 3 mesi reali = 5 minuti in sandbox
- Android: Con License Testing, rinnovi sono immediati
- Verifica che il servizio IAP ascolti gli eventi di rinnovo

### "Lo stato premium si perde dopo riavvio app"
- Verifica che SharedPreferences salvi correttamente
- Implementa `restorePurchases()` all'avvio dell'app
- Controlla i log per vedere se l'abbonamento viene rilevato

---

## 📈 Metriche da Monitorare

Dopo il lancio, monitora:

1. **Conversion Rate**: % di utenti che si abbonano
   - Target: 2-5% degli utenti attivi
   
2. **Trial Conversion**: % di trial che diventano abbonamenti paganti
   - Target: 20-40%
   
3. **Churn Rate**: % di abbonamenti cancellati
   - Target: < 10% al mese
   
4. **LTV (Lifetime Value)**: Valore medio per abbonato
   - Calcolo: Prezzo × (1 / Churn Rate)
   
5. **MRR (Monthly Recurring Revenue)**: Entrate ricorrenti mensili
   - Importante per pianificazione finanziaria

---

**Buona fortuna con il lancio dell'abbonamento Premium! 🚀**

**Ultimo aggiornamento**: Gennaio 2026
