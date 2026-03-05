  # 📊 Guida ai Piani di Abbonamento Multipli

Implementazione e strategia per offrire piani Mensile + Trimestrale (e opzionalmente Annuale).

## ✅ Cosa È Stato Implementato

### 1. **Supporto Multi-Prodotto nel Codice**
```dart
// Product IDs configurati
- premium_subscription_monthly (Mensile)
- premium_subscription_quarterly2 (Trimestrale)
```

### 2. **UI con Selettore di Piano**
- Card interattive per ogni piano
- Badge "Risparmia X%" sul piano migliore
- Selezione visuale con radio button
- Prezzo chiaro e confronto immediato

### 3. **Sistema di Acquisto Flessibile**
```dart
// L'utente seleziona il piano e clicca acquista
await iapService.purchasePremium(productId: productId);
```

---

## 💡 Perché Offrire Più Piani?

### ✅ Aumenta le Conversioni del 40-60%

**Scenario 1: Solo Trimestrale**
```
100 utenti interessati
├── 30% trova il prezzo troppo alto → PERDUTI
├── 20% non vuole commitment lungo → PERDUTI
└── 50% si abbona ✅
= 50 conversioni
```

**Scenario 2: Mensile + Trimestrale**
```
100 utenti interessati
├── 30% sceglie mensile (barriera bassa) ✅
├── 55% sceglie trimestrale (miglior valore) ✅
└── 15% non si abbona comunque
= 85 conversioni (+70% conversioni!)
```

### ✅ Effetto Psicologico dell'"Ancoraggio"

```
Opzione A: €2.99/trimestre
→ Reazione: "Mah, non so..."

Opzione B: €1.49/mese O €2.99/trimestre
→ Reazione: "€2.99 risparmio quasi €2! È un affare!" 🎯
```

Il mensile "ancora" il prezzo e fa sembrare il trimestrale un ottimo affare.

### ✅ Segmentazione Naturale

| Tipo Utente | Piano Preferito | Motivazione |
|-------------|----------------|-------------|
| **Incerto** | Mensile | "Voglio provare prima di impegnarmi" |
| **Convinto** | Trimestrale | "Sono sicuro, voglio risparmiare" |
| **Budget limitato** | Mensile | "€1.49 è accessibile" |
| **Super fan** | Annuale | "Massimo risparmio, uso intensivo" |

---

## 💰 Strategie di Pricing

### Opzione 1: **STANDARD** (Consigliata)
```
Mensile:     €1.49/mese  (€17.88/anno)
Trimestrale: €2.99/3 mesi (€11.96/anno) ← BEST VALUE
             ↑ Risparmio: 33%
```

**Pro:**
- Differenza significativa (€6/anno di risparmio)
- Mensile accessibile come "prova"
- Trimestrale diventa chiara convenienza

**Conversioni attese:**
- 30% Mensile
- 55% Trimestrale
- 15% No acquisto

**Revenue annuo medio**: €13.20/utente pagante

---

### Opzione 2: **CON ANNUALE** (Massimizza Revenue)
```
Mensile:     €1.49/mese   (€17.88/anno)
Trimestrale: €2.99/3 mesi  (€11.96/anno) ← MOST POPULAR
Annuale:     €8.99/anno              ← BEST VALUE
             ↑ Risparmi: 50% vs mensile
```

**Pro:**
- L'annuale diventa il "super deal"
- Il trimestrale diventa il "compromesso perfetto"
- Effetto "decoy" psicologico

**Conversioni attese:**
- 25% Mensile
- 50% Trimestrale ← Più persone scelgono questo
- 20% Annuale
- 5% No acquisto

**Revenue annuo medio**: €11.70/utente pagante
**Ma**: Revenue immediato più alto (annuale in una volta)

---

### Opzione 3: **AGGRESSIVA** (Volume Alto)
```
Mensile:     €0.99/mese  (€11.88/anno)
Trimestrale: €1.99/3 mesi (€7.96/anno)
             ↑ Risparmio: 33%
```

**Pro:**
- Barriera d'ingresso bassissima
- Massima acquisizione utenti
- Ottimo per mercati competitivi

**Contro:**
- Revenue per utente più basso
- Può svalutare il prodotto

**Conversioni attese:**
- 35% Mensile
- 60% Trimestrale
- 5% No acquisto

**Revenue annuo medio**: €8.80/utente pagante

---

### Opzione 4: **PREMIUM** (Alta Qualità)
```
Mensile:     €2.49/mese  (€29.88/anno)
Trimestrale: €4.99/3 mesi (€19.96/anno)
Annuale:     €14.99/anno
```

**Quando usarla:**
- App con valore molto alto
- Funzionalità premium esclusive
- Target professionale/business

---

## 📊 Calcolo Revenue Ottimale

### Scenario Esempio: 1000 Utenti Free

**Con Solo Trimestrale (€2.99):**
```
Conversione: 5% = 50 abbonati
Revenue anno 1: 50 × €11.96 = €598
Commissione -30% = €418.60
```

**Con Mensile (€1.49) + Trimestrale (€2.99):**
```
Conversione: 8.5% = 85 abbonati
├── 30% Mensile (26): 26 × €17.88 = €464.88
└── 70% Trimestrale (59): 59 × €11.96 = €705.64
Total revenue: €1,170.52
Commissione -30% = €819.36 (+96% revenue!)
```

**Con 3 Piani (€1.49 / €2.99 / €8.99):**
```
Conversione: 9.5% = 95 abbonati
├── 25% Mensile (24): 24 × €17.88 = €429.12
├── 50% Trimestrale (48): 48 × €11.96 = €574.08
└── 25% Annuale (23): 23 × €8.99 = €206.77
Total revenue: €1,209.97
Commissione -30% = €846.98 (+103% revenue!)
```

---

## 🎯 Presentazione Ottimale nell'UI

### Layout Consigliato

```
┌─────────────────────────────────────┐
│      Scegli il tuo piano            │
├─────────────────────────────────────┤
│                                      │
│  ○  Mensile           €1.49/mese    │
│     Prova senza impegno             │
│                                      │
├─────────────────────────────────────┤
│  [RISPARMIA 33%]                    │
│  ●  Trimestrale       €2.99         │
│     ≈ €1.00/mese      ogni 3 mesi   │
│     ✨ MIGLIOR VALORE                │
├─────────────────────────────────────┤
│                                      │
│  ○  Annuale           €8.99/anno    │
│     ≈ €0.75/mese                    │
│     💎 MASSIMO RISPARMIO             │
│                                      │
└─────────────────────────────────────┘

        [Abbonati Ora]
```

### Design Tips

1. **Default Selection**: Trimestrale (miglior valore)
2. **Badge Visibili**: "Risparmia 33%", "Best Value"
3. **Prezzo Mensile Equivalente**: Sempre visibile
4. **Colore Differente**: Piano selezionato in evidenza (oro/giallo)
5. **Checkmark Chiaro**: Radio button ben visibile

---

## 🛒 Configurazione negli Store

### iOS (App Store Connect)

1. **Crea Subscription Group**: "Teletext Premium"

2. **Crea 2 (o 3) Auto-Renewable Subscriptions:**

**Mensile:**
```
Product ID: premium_subscription_monthly
Duration: 1 month
Price: €1.49 (Tier 3)
Reference Name: Premium Monthly
```

**Trimestrale:**
```
Product ID: premium_subscription_quarterly2
Duration: 3 months
Price: €2.99 (Tier 5)
Reference Name: Premium Quarterly
```

**Annuale (opzionale):**
```
Product ID: premium_subscription_yearly
Duration: 1 year
Price: €8.99 (Tier 9)
Reference Name: Premium Yearly
```

3. **Subscription Group Settings:**
   - Ordine visualizzazione: Annuale → Trimestrale → Mensile
   - Upgrade/Downgrade Policy: Immediate billing

### Android (Google Play Console)

1. **Crea Abbonamento**: "Teletext Premium"

2. **Aggiungi Base Plans:**

**Mensile:**
```
Base Plan ID: monthly
Billing period: 1 month (P1M)
Price: €1.49
```

**Trimestrale:**
```
Base Plan ID: quarterly
Billing period: 3 months (P3M)
Price: €2.99
```

**Annuale:**
```
Base Plan ID: yearly
Billing period: 1 year (P1Y)
Price: €8.99
```

---

## 🧪 A/B Testing Consigliato

### Test 1: Numero di Piani
- **Gruppo A**: Solo trimestrale
- **Gruppo B**: Mensile + Trimestrale
- **Metrica**: Tasso di conversione

### Test 2: Piano Default
- **Gruppo A**: Default mensile
- **Gruppo B**: Default trimestrale
- **Metrica**: Revenue medio per utente

### Test 3: Pricing Mensile
- **Gruppo A**: €0.99/mese
- **Gruppo B**: €1.49/mese
- **Gruppo C**: €1.99/mese
- **Metrica**: Conversione × Revenue

### Test 4: Badge e Messaging
- **Gruppo A**: "Risparmia 33%"
- **Gruppo B**: "Risparmia €6/anno"
- **Gruppo C**: "Miglior valore"
- **Metrica**: Click-through su trimestrale

---

## 📈 Metriche da Monitorare

### 1. **Distribution Mix**
```
Quale piano scelgono?
├── Mensile: 30%
├── Trimestrale: 60%
└── Annuale: 10%
```

### 2. **Lifetime Value (LTV)**
```
Mensile:
├── Retention 6 mesi: 40%
├── Average lifetime: 4 mesi
└── LTV: €5.96

Trimestrale:
├── Retention 6 mesi: 65%
├── Average lifetime: 9 mesi
└── LTV: €8.97 (+50%)

Annuale:
├── Retention 12 mesi: 85%
├── Average lifetime: 18 mesi
└── LTV: €13.49 (+126%)
```

### 3. **Churn Rate per Piano**
```
Mensile: 15%/mese (più alta)
Trimestrale: 8%/trimestre (media)
Annuale: 5%/anno (più bassa)
```

### 4. **Conversion Funnel**
```
1000 visitatori pagina Premium
├── 800 vedono i piani (80%)
├── 650 selezionano un piano (81%)
├── 550 cliccano "Abbonati" (85%)
└── 85 completano acquisto (15%)
    ├── 26 Mensile (30%)
    ├── 47 Trimestrale (55%)
    └── 12 Annuale (15%)
```

---

## 🎮 Upgrade/Downgrade Flow

### iOS: Automatico
- Upgrade (mensile → trimestrale): Immediato
- Downgrade (trimestrale → mensile): A fine periodo

### Android: Da Configurare
```kotlin
// Nel Base Plan settings
Replacement mode: 
- DEFERRED (downgrade a fine periodo)
- IMMEDIATE_WITH_PRORATION (upgrade immediato)
```

### Implementazione App
```dart
// Permettere cambio piano
if (userHasMonthly && wantsQuarterly) {
  await iapService.purchasePremium(
    productId: 'premium_subscription_quarterly2'
  );
  // Lo store gestisce automaticamente la migrazione
}
```

---

## 💡 Strategia Free Trial

### Trial Differenziati
```
Mensile: 3 giorni gratis (breve, per provare)
Trimestrale: 7 giorni gratis (più tempo per convincersi)
Annuale: 14 giorni gratis (massima prova)
```

**Effetto**: Incentiva piani più lunghi per trial più lunghi

---

## 🔥 Offerte Speciali

### Introductory Offer (Prima Volta)
```
Mensile: €0.49 primo mese (-67%)
Trimestrale: €0.99 primo trimestre (-67%)
Annuale: €2.99 primo anno (-67%)
```

### Promotional Offer (Win-Back)
```
Per utenti che hanno cancellato:
"Torna con 50% di sconto per 3 mesi!"
```

---

## 📊 Raccomandazione Finale

### Per Iniziare (Prima Settimana)
**Opzione 1: Solo Trimestrale**
- Più semplice da gestire
- Testa il mercato
- Raccogli feedback

### Dopo Validazione (Settimana 2+)
**Opzione 2: Mensile + Trimestrale**
- Default: Trimestrale
- Prezzi: €1.49/mese, €2.99/3 mesi
- Badge: "Risparmia 33%" sul trimestrale
- Free trial: 7 giorni su entrambi

### Per Massimizzare Revenue (Mese 2+)
**Opzione 3: Tutti e 3**
- Mensile €1.49
- Trimestrale €2.99 (Most Popular)
- Annuale €8.99 (Best Value)
- Free trial: 3/7/14 giorni rispettivamente

---

## ✅ Checklist Implementazione

### Codice
- [x] Support per multiple product IDs
- [x] Metodi getMonthlyProduct() / getQuarterlyProduct()
- [x] UI con selettore piani
- [x] Badge "Risparmia X%"
- [x] Analytics tracking per plan_type
- [ ] Supporto annuale (opzionale)

### Store Setup
- [ ] Crea subscription group (iOS)
- [ ] Crea product "monthly" con ID corretto
- [ ] Crea product "quarterly" con ID corretto
- [ ] Imposta prezzi per ogni paese
- [ ] Configura free trial (opzionale)
- [ ] Localizza descrizioni
- [ ] Test con sandbox accounts

### Testing
- [ ] Verifica caricamento prodotti
- [ ] Test acquisto mensile
- [ ] Test acquisto trimestrale
- [ ] Test selezione piano
- [ ] Test calcolo risparmio
- [ ] Verifica analytics events
- [ ] Test upgrade/downgrade

---

## 🎯 Risultato Atteso

Con implementazione corretta:
- ✅ +40-60% conversioni vs piano singolo
- ✅ +50-100% revenue medio per utente
- ✅ Migliore segmentazione utenti
- ✅ Maggiore flessibilità pricing
- ✅ Upgrade path naturale

**ROI implementazione**: 2-4 settimane

---

**Ultimo aggiornamento**: Gennaio 2026
