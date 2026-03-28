# Configurazione In-App Purchase Android (Google Play)

Guida per configurare gli abbonamenti **mensile** e **trimestrale** su Google Play Console per Teletext Europe.

## 💰 Tasse e IVA sui prezzi

**Comportamento di Google Play**: Il prezzo che inserisci è considerato **netto (senza IVA)**. Google aggiunge automaticamente le tasse in base al paese dell’utente.

- **Italia (IVA 22%)**: Se imposti €2.99 → l’utente vede ~€3.65
- **Per mostrare €2.99 all’utente**: imposta **€2,45** (2.99 ÷ 1,22)

**Verifica in Play Console**: Cerca l’opzione **"Il prezzo predefinito include le tasse"** / **"Default price includes tax"** nella sezione prezzi. Se è disponibile e la attivi, puoi inserire direttamente il prezzo finale (es. €2.99) e Google non aggiungerà tasse.

---

## ✅ La versione funziona su Android?

**Sì.** L'app usa il package `in_app_purchase` che supporta sia iOS che Android con lo stesso codice. I Product ID sono gli stessi su entrambe le piattaforme:
- `premium_subscription_monthly`
- `premium_subscription_quarterly2`

L'app funzionerà su Android **non appena** avrai creato questi due prodotti in Google Play Console.

---

## 📋 Prerequisiti

1. App pubblicata almeno una volta su Google Play (anche in test interno)
2. Account sviluppatore Google Play attivo
3. Account commerciante Google configurato (per ricevere i pagamenti)

---

## 🛒 Procedimento passo-passo

### 1. Accedi a Google Play Console

1. Vai su [Google Play Console](https://play.google.com/console/)
2. Seleziona l'app **Teletext Europe**

---

### 2. Configura l'account commerciante (se non fatto)

1. **Monetizzazione** → **Configurazione monetizzazione**
2. Segui il wizard per creare/collegare un account Google Merchant
3. Completa verifica identità e dati fiscali
4. Collega un metodo di pagamento per ricevere i ricavi

---

### 3. Crea l'abbonamento MENSILE

1. **Monetizzazione** → **Prodotti** → **Abbonamenti**
2. Clicca **Crea abbonamento**

#### Informazioni di base
| Campo | Valore |
|-------|--------|
| **Product ID** | `premium_subscription_monthly` |
| **Nome** | Teletext Premium - Monthly |
| **Descrizione** | Abbonamento mensile (solo uso interno) |

⚠️ **IMPORTANTE**: Il Product ID deve essere **esattamente** `premium_subscription_monthly` (come nel codice).

#### Piano base (Base Plan)
1. Clicca **Aggiungi piano base**
2. **Base Plan ID**: `monthly-standard` (o simile)
3. **Periodo di fatturazione**: 1 mese (P1M)
4. **Rinnovo**: Automatico

#### Prezzi e tasse (IVA)
**Importante**: Google Play considera il prezzo che inserisci come **prezzo netto (senza tasse)** e aggiunge l’IVA in automatico. Se imposti €2.99, l’utente vedrà circa €3.65 in Italia (22% IVA).

**Per far pagare all’utente esattamente €2.99** (prezzo finale con tasse incluse):
- Imposta il prezzo **netto** = €2.99 ÷ 1,22 ≈ **€2,45**
- In Italia l’utente vedrà e pagherà €2.99

**Tabella di conversione (prezzo finale → prezzo da impostare):**
| Vuoi che l'utente paghi | Prezzo da impostare (netto) |
|-------------------------|----------------------------|
| €1.49 | €1,22 |
| €2.99 | €2,45 |
| €3.99 | €3,27 |

- **USA**: $1.49/mese (le tasse variano per stato)
- Oppure usa "Imposta prezzo in tutti i paesi" per conversione automatica

#### Periodo di prova (opzionale, consigliato)
- **7 giorni** gratuiti per nuovi abbonati

#### Localizzazioni
Per ogni lingua supportata dall'app:

**Italiano (it-IT)**
- **Titolo**: Teletext Premium
- **Descrizione**: Abbonamento mensile che rimuove tutta la pubblicità. Si rinnova automaticamente ogni mese. Annulla quando vuoi dalle impostazioni Google Play.

**English (en-US)**
- **Titolo**: Teletext Premium
- **Descrizione**: Monthly subscription that removes all ads. Automatically renews every month. Cancel anytime from Google Play settings.

#### Attivazione
- Clicca **Attiva** per rendere il prodotto disponibile

---

### 4. Crea l'abbonamento TRIMESTRALE

1. **Monetizzazione** → **Prodotti** → **Abbonaamenti**
2. Clicca **Crea abbonamento**

#### Informazioni di base
| Campo | Valore |
|-------|--------|
| **Product ID** | `premium_subscription_quarterly2` |
| **Nome** | Teletext Premium - Quarterly |
| **Descrizione** | Abbonamento trimestrale (solo uso interno) |

⚠️ **IMPORTANTE**: Il Product ID deve essere **esattamente** `premium_subscription_quarterly2`.

#### Piano base (Base Plan)
1. Clicca **Aggiungi piano base**
2. **Base Plan ID**: `quarterly-standard`
3. **Periodo di fatturazione**: 3 mesi (P3M)
4. **Rinnovo**: Automatico

#### Prezzi (stessa logica tasse del mensile)
- **Italia**: Per far pagare €2.99 → imposta **€2,45** (netto)
- **USA**: $2.99 ogni 3 mesi

#### Periodo di prova (opzionale)
- **7 giorni** gratuiti

#### Localizzazioni
Stesse lingue dell'abbonamento mensile, con descrizione adattata per "ogni 3 mesi".

#### Attivazione
- Clicca **Attiva**

---

### 5. Informazioni obbligatorie per abbonamenti

Google Play richiede (come Apple):

1. **Privacy Policy**: URL della tua privacy policy  
   Es: `https://www.codebysam.it/teleretro/privacy.html`

2. **Termini di utilizzo**: URL dell'EULA  
   Es: `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/` (se usi quella standard)

Configurazione:
- **Monetizzazione** → **Configurazione monetizzazione** → **Abbonamenti**
- Inserisci gli URL nei campi richiesti

---

### 6. Testing

#### License Testing (consigliato per sviluppo)
1. **Configurazione** → **Testing delle licenze**
2. Aggiungi gli account Google dei tester (email)
3. Questi account potranno acquistare **senza essere addebitati**
4. Gli abbonamenti si comportano come reali ma non c'è pagamento

#### Test interno
1. **Test** → **Test interno**
2. Crea una lista di tester
3. Carica una build (AAB) nella track "Test interno"
4. I tester ricevono l'aggiornamento e possono testare gli acquisti

**Nota**: Su Android gli abbonamenti di test durano il periodo reale (1 mese, 3 mesi). Con License Testing non paghi.

---

## 🔧 Verifica che funzioni

1. **Build di test**:
   ```bash
   flutter build appbundle
   ```

2. **Carica** su Test interno in Play Console

3. **Installa** l'app dal link di test su un dispositivo Android reale

4. **Controlla i log** quando apri la pagina Premium:
   ```
   [IAPService] Loaded 2 products
   [IAPService] ✅ Product: premium_subscription_monthly - ...
   [IAPService] ✅ Product: premium_subscription_quarterly2 - ...
   ```

5. Se vedi `Products not found: [premium_subscription_monthly, ...]`:
   - I prodotti non sono ancora attivi (attendi qualche minuto)
   - L'app non è nella stessa track dei prodotti (devono essere nella stessa app)
   - Stai usando un emulatore (serve dispositivo reale con Google Play)

---

## 📱 Requisiti tecnici

- **Dispositivo reale**: Gli IAP non funzionano su emulatore
- **Stesso account**: L'app deve essere firmata con la stessa chiave usata per il rilascio
- **Stato "Attivo"**: I prodotti devono essere attivati in Play Console
- **App pubblicata**: Almeno una versione deve essere stata caricata (anche in test)

---

## ✅ Checklist finale

- [ ] Account commerciante configurato
- [ ] Prodotto `premium_subscription_monthly` creato e attivo
- [ ] Prodotto `premium_subscription_quarterly2` creato e attivo
- [ ] Prezzi impostati per i paesi target
- [ ] Localizzazioni aggiunte (it, en minimo)
- [ ] Privacy Policy e Terms of Use configurati
- [ ] License Testing: account tester aggiunti
- [ ] Build AAB caricata su Test interno
- [ ] Test acquisto su dispositivo reale

---

## 🆘 Risoluzione problemi

| Problema | Soluzione |
|---------|-----------|
| "Products not found" | Verifica Product ID esatti, attendi 2-4 ore dopo creazione, usa dispositivo reale |
| "Billing not available" | Verifica che il dispositivo abbia Google Play Services aggiornato |
| Nessun prodotto caricato | L'app deve essere nella stessa console e firmata correttamente |
| Acquisto non completa | Controlla i log, verifica License Testing se in test |

Vedi anche `TROUBLESHOOTING_IAP.md` per altri dettagli.
