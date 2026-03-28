# Risoluzione rifiuto App Store - Marzo 2026

Guida per risolvere i 3 problemi segnalati da Apple nella revisione del 10 marzo 2026.

---

## Problema 1: Guideline 2.1 - Account demo con abbonamento scaduto

**Cosa chiede Apple:** Un account demo con abbonamento **scaduto** per testare l'intero flusso di acquisto (incluso il ripristino/win-back).

### Cosa fare (manuale in App Store Connect)

1. Vai su [App Store Connect](https://appstoreconnect.apple.com/)
2. Seleziona la tua app **Teletext Europe**
3. Vai su **App Store** → **Informazioni per la revisione dell'app**
4. Nella sezione **Informazioni per la revisione dell'app** (App Review Information):
   - **Nome utente demo**: inserisci l'email di un account Sandbox con abbonamento scaduto
   - **Password**: la password di quell'account

### Come creare l'account con abbonamento scaduto

1. In App Store Connect: **Utenti e accesso** → **Sandbox** → **Tester**
2. Crea un nuovo tester (o usa uno esistente)
3. Sul dispositivo di test (iPhone/iPad):
   - Esci dal tuo Apple ID
   - Installa l'app dalla build di test
   - Accedi con l'account Sandbox quando richiesto
   - **Abbonati** (mensile o trimestrale)
   - In Sandbox, gli abbonamenti scadono velocemente (es. 5 minuti per 1 mese)
   - Aspetta che scada
   - Oppure: Impostazioni → Apple ID → Abbonamenti → annulla il rinnovo

4. Usa le credenziali di questo account nelle "Informazioni per la revisione"

---

## Problema 2: Guideline 3.1.2(c) - Link EULA nei metadata

**Cosa chiede Apple:** Un link funzionante ai **Termini di utilizzo (EULA)** nei metadata dell'App Store.

### Cosa fare (manuale in App Store Connect)

1. Vai su **App Store Connect** → la tua app
2. Sezione **Informazioni sull'app** (o dove modifichi i metadata)

**Opzione A - EULA standard Apple (consigliata):**
- Nel campo **Descrizione dell'app** (App Description), aggiungi in fondo:
  ```
  Termini di utilizzo (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
  ```

**Opzione B - EULA personalizzata:**
- Se hai una EULA custom, caricala in App Store Connect nel campo dedicato **EULA**
- Oppure inserisci il link nella descrizione

**Verifica anche:**
- **Privacy Policy**: deve essere nel campo dedicato "URL dell'informativa sulla privacy"
- URL suggerito: `https://www.codebysam.it/teleretro/privacy.html`

---

## Problema 3: Guideline 4 - Pubblicità forzata

**Cosa chiede Apple:** Rimuovere la pubblicità "forzata" (che blocca l'uso dell'app). Usare solo pubblicità **passiva**.

### Possibili approcci (senza disabilitare gli interstitial)

1. **Rispondere ad Apple in App Store Connect** spiegando che:
   - Gli interstitial compaiono **dopo** l'uso dell'app (ogni 10 pagine visualizzate), non prima
   - L'utente può usare l'app liberamente; gli annunci non bloccano l'accesso iniziale
   - I clienti premium non vedono alcuna pubblicità

2. **Form consenso GDPR**: Se Apple si riferisce al form UMP che blocca l'avvio, valuta di mostrarlo in modo non bloccante (es. dopo il primo accesso all'app).

3. **Appeal**: Se ritieni che la segnalazione sia errata, puoi fare appello spiegando il flusso reale dell'app.

---

## Checklist prima di inviare di nuovo

- [ ] **Account demo**: Nome utente e password in "Informazioni per la revisione"
- [ ] **EULA**: Link nella descrizione o campo EULA
- [ ] **Privacy Policy**: URL nel campo dedicato
- [ ] **Build**: Nuova build (se necessario per altri fix)
- [ ] **Note per il revisore**: Spiega che hai fornito un account con abbonamento scaduto per testare il flusso completo

---

## Note per il revisore (opzionale)

Puoi aggiungere un messaggio nella sezione "Note per il revisore":

> We have provided demo account credentials with an expired subscription in the App Review Information section. This allows you to test the full purchase flow including subscription restoration.
>
> Regarding Guideline 4: Interstitial ads are shown only after the user has actively used the app (every 10 pages viewed). They do not block initial access. Users can use the app immediately. Premium subscribers see no ads.
>
> The EULA link has been added to the App Description as requested.
