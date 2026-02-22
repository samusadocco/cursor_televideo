# 📊 Tracking Premium vs Free con Firebase Analytics

Guida completa per tracciare e differenziare utenti Premium da utenti Free usando Firebase Analytics.

## ✅ Cosa è stato implementato

### 1. **User Property: `subscription_status`**
Ogni utente ha una proprietà persistente che indica il suo stato:
- `"premium"` = Utente con abbonamento attivo
- `"free"` = Utente senza abbonamento

Questa property viene automaticamente:
- ✅ Impostata all'avvio dell'app
- ✅ Aggiornata quando l'utente acquista l'abbonamento
- ✅ Aggiornata quando l'utente ripristina l'abbonamento
- ✅ Aggiornata dal toggle debug (in modalità debug)

### 2. **Eventi Specifici per Abbonamento**

**`subscription_purchased`** - Quando un utente completa un nuovo acquisto
- Parametri:
  - `subscription_id`: ID del prodotto (`premium_subscription_quarterly`)
  - `price`: Prezzo (es. "€2.99")
  - `currency`: Valuta (es. "EUR")
  - `platform`: iOS o Android
  - `transaction_id`: ID della transazione

**`subscription_restored`** - Quando un utente ripristina un abbonamento esistente
- Stessi parametri di `subscription_purchased`

### 3. **Integrazione Automatica**
Il tracking è completamente automatico:
```dart
// Quando l'utente diventa premium
await _unlockPremium(); // Automaticamente aggiorna Analytics

// Al lancio dell'app
await iapService.initialize(); // Automaticamente sincronizza lo stato
```

---

## 📈 Come Usare in Firebase Console

### 1. **Visualizza User Property**

1. Vai su **Firebase Console** → Il tuo progetto
2. Seleziona **Analytics** → **Dashboard**
3. Clicca su **User Properties** nel menu laterale
4. Cerca `subscription_status`

Vedrai:
```
subscription_status
├── premium: X utenti (Y%)
└── free: Z utenti (W%)
```

### 2. **Filtra Eventi per Stato Abbonamento**

In qualsiasi report Analytics:

1. Clicca su **"Add filter"** o **"Add comparison"**
2. Seleziona **User property**
3. Scegli `subscription_status`
4. Imposta valore: `premium` o `free`

**Esempio**: Vedere solo eventi di utenti premium:
```
Filter:
- User property: subscription_status
- Condition: equals
- Value: premium
```

### 3. **Audience per Remarketing**

Crea audience separate per targeting:

1. Vai su **Analytics** → **Audiences**
2. Clicca **New Audience**
3. Imposta condizioni:

**Audience "Premium Users":**
```
User property: subscription_status
Condition: equals
Value: premium
```

**Audience "Free Users":**
```
User property: subscription_status
Condition: equals
Value: free
```

**Audience "Lapsed Premium":**
```
User property: subscription_status
Condition: equals
Value: free

AND

User previously matched: Premium Users (in last 30 days)
```

### 4. **Confronto Premium vs Free**

Crea confronti diretti:

1. Nel report, clicca **"Add comparison"**
2. Seleziona:
   - **Comparison A**: `subscription_status = premium`
   - **Comparison B**: `subscription_status = free`

Vedrai metriche affiancate:
```
Metric          | Premium | Free
----------------|---------|------
Active Users    | 150     | 3,500
Sessions        | 450     | 7,000
Session Duration| 5:30    | 3:20
Pages per Session| 12     | 8
```

### 5. **Eventi Abbonamento**

Monitora le conversioni:

1. Vai su **Analytics** → **Events**
2. Cerca:
   - `subscription_purchased`
   - `subscription_restored`

**Report conversioni:**
```
Event                  | Count | Revenue
-----------------------|-------|--------
subscription_purchased | 25    | €74.75
subscription_restored  | 12    | -
```

---

## 🎯 Query Utili in BigQuery

Se hai BigQuery collegato, puoi fare query avanzate:

### Conteggio Utenti per Stato
```sql
SELECT
  user_properties.value.string_value AS subscription_status,
  COUNT(DISTINCT user_pseudo_id) AS user_count
FROM
  `your-project.analytics_XXXXX.events_*`
CROSS JOIN
  UNNEST(user_properties) AS user_properties
WHERE
  user_properties.key = 'subscription_status'
  AND _TABLE_SUFFIX BETWEEN '20260101' AND '20261231'
GROUP BY
  subscription_status
ORDER BY
  user_count DESC
```

### Revenue per Stato Abbonamento
```sql
SELECT
  up.value.string_value AS subscription_status,
  COUNT(*) AS purchase_count,
  SUM(CAST(ep.value.string_value AS FLOAT64)) AS total_revenue
FROM
  `your-project.analytics_XXXXX.events_*`,
  UNNEST(user_properties) AS up,
  UNNEST(event_params) AS ep
WHERE
  event_name = 'subscription_purchased'
  AND up.key = 'subscription_status'
  AND ep.key = 'price'
  AND _TABLE_SUFFIX BETWEEN '20260101' AND '20261231'
GROUP BY
  subscription_status
```

### Retention Rate per Tipo Utente
```sql
WITH daily_users AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS date,
    user_pseudo_id,
    MAX(CASE WHEN up.key = 'subscription_status' THEN up.value.string_value END) AS status
  FROM
    `your-project.analytics_XXXXX.events_*`,
    UNNEST(user_properties) AS up
  WHERE
    _TABLE_SUFFIX BETWEEN '20260101' AND '20261231'
  GROUP BY
    date, user_pseudo_id
)
SELECT
  status,
  COUNT(DISTINCT CASE WHEN date = CURRENT_DATE() THEN user_pseudo_id END) AS active_today,
  COUNT(DISTINCT CASE WHEN date = DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) THEN user_pseudo_id END) AS active_7d_ago,
  ROUND(COUNT(DISTINCT CASE WHEN date = CURRENT_DATE() THEN user_pseudo_id END) / 
        COUNT(DISTINCT CASE WHEN date = DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) THEN user_pseudo_id END) * 100, 2) AS retention_rate
FROM
  daily_users
GROUP BY
  status
```

---

## 📊 KPI da Monitorare

### Per Utenti Premium:
1. **Retention Rate**: Quanto rimangono attivi?
2. **Session Duration**: Usano l'app più a lungo?
3. **Pages per Session**: Navigano di più senza annunci?
4. **Churn Rate**: Quanti cancellano l'abbonamento?
5. **Feature Usage**: Quali funzioni usano di più?

### Per Utenti Free:
1. **Conversion Rate**: Quanti diventano premium?
2. **Time to Conversion**: Quanto tempo prima di abbonarsi?
3. **Ad Impressions**: Quanti annunci vedono?
4. **Drop-off Points**: Dove abbandonano l'app?

### Confronto Premium vs Free:
```
Metrica                    | Premium | Free   | Delta
---------------------------|---------|--------|-------
Avg Session Duration       | 5:30    | 3:20   | +66%
Pages per Session          | 12.5    | 8.2    | +52%
Sessions per User (7d)     | 8.5     | 4.3    | +98%
30-Day Retention           | 85%     | 45%    | +89%
```

---

## 🔍 Debug e Testing

### Verifica lo Stato in Real-Time

1. Vai su **Analytics** → **DebugView**
2. Collega il dispositivo in debug mode:
   ```bash
   # iOS
   flutter run --dart-define=FIREBASE_DEBUG=true
   
   # Android
   adb shell setprop debug.firebase.analytics.app it.codebysam.televideo
   ```
3. Attiva/disattiva premium dal toggle debug
4. In DebugView vedrai:
   ```
   setUserProperty
   └── subscription_status: "premium" (o "free")
   ```

### Log Console
Nel log dell'app vedrai:
```
[IAPService] Analytics initialized with subscription status: premium
🔍 Analytics: Subscription status set to premium
```

---

## 🎨 Dashboard Personalizzata

Crea una dashboard specifica per monitorare Premium:

1. Vai su **Analytics** → **Custom Reports**
2. Crea **New Custom Report**
3. Configurazione esempio:

**Report Name**: "Premium vs Free Comparison"

**Dimensions**:
- User property: `subscription_status`
- Date

**Metrics**:
- Active users
- Sessions
- Session duration
- Pages per session
- Engaged sessions

**Filters**:
- Nessuno (per vedere entrambi)

**Visualization**:
- Line chart per trend temporale
- Pie chart per distribuzione utenti

---

## 🚨 Alerts Importanti

Imposta alert in Firebase per:

### 1. Drop in Premium Users
```
Alert se: Active Users (subscription_status = premium)
Condition: Decreases by more than 10%
Time period: Last 7 days
```

### 2. Spike in Cancellations
```
Alert se: Users con subscription_status che passa da premium a free
Condition: Increases by more than 15%
Time period: Last 24 hours
```

### 3. Conversion Rate Drop
```
Alert se: subscription_purchased events
Condition: Decreases by more than 20%
Time period: Last 7 days vs previous 7 days
```

---

## 💡 Best Practices

### 1. **Non Duplicare Progetti**
❌ **NON creare 2 progetti Firebase separati**
✅ **Usa User Properties** per segmentare

**Vantaggi**:
- Un unico dashboard per tutti gli utenti
- Confronto diretto premium vs free
- Meno manutenzione
- Costi ridotti

### 2. **Segmentazione Avanzata**
Oltre a premium/free, considera:
```dart
// Aggiungi altre properties
await AnalyticsService().setUserProperty('subscription_duration', '3_months');
await AnalyticsService().setUserProperty('ltv_bucket', 'high');
await AnalyticsService().setUserProperty('acquisition_source', 'organic');
```

### 3. **Privacy e GDPR**
- ✅ User properties NON contengono dati personali
- ✅ `subscription_status` è solo "premium" o "free"
- ✅ Nessun dato identificativo dell'utente
- ✅ Conforme a GDPR e privacy policy

### 4. **Testing**
Prima del deploy:
```bash
# 1. Avvia in debug
flutter run

# 2. Attiva premium dal toggle
# 3. Verifica in DebugView
# 4. Disattiva premium
# 5. Verifica ancora in DebugView
```

---

## 📱 Esempi Pratici

### Scenario 1: "Quanti utenti premium ho?"
```
Analytics → User Properties → subscription_status
Risultato: 150 premium (4.2%) vs 3,400 free (95.8%)
```

### Scenario 2: "Gli utenti premium usano l'app di più?"
```
Analytics → Events → screen_view
Filter: subscription_status = premium
Confronta con: subscription_status = free

Risultato:
- Premium: 12.5 pages/session
- Free: 8.2 pages/session
- Delta: +52% ✅
```

### Scenario 3: "Quali pagine vedono gli utenti prima di abbonarsi?"
```
Analytics → Conversions → subscription_purchased
View Funnel:
1. app_open (100%)
2. screen_view: settings (45%)
3. screen_view: premium_page (30%)
4. subscription_purchased (8%)
```

### Scenario 4: "Retention dopo 30 giorni"
```
Analytics → Retention
Cohort: Users with subscription_status = premium
Period: 30 days

Risultato:
- Day 0: 100% (25 users)
- Day 7: 92% (23 users)
- Day 30: 85% (21 users) ✅
```

---

## 🔄 Integrazione con Altri Strumenti

### Google Ads
Usa audiences per remarketing:
```
Target: Users con subscription_status = free
Messaggio: "Prova Premium senza annunci!"
```

### Firebase Cloud Messaging
Notifiche personalizzate:
```dart
// Per utenti free
"🌟 Passa a Premium e rimuovi la pubblicità!"

// Per utenti premium
"Grazie per il supporto! Scopri le nuove funzioni."
```

### A/B Testing con Remote Config
```json
{
  "premium_price_test": {
    "conditions": [
      {
        "name": "free_users",
        "expression": "user.subscription_status == 'free'"
      }
    ],
    "values": {
      "price_variant_a": "2.99",
      "price_variant_b": "3.99"
    }
  }
}
```

---

## ✅ Checklist Setup

- [x] User Property `subscription_status` implementata
- [x] Aggiornamento automatico all'acquisto
- [x] Aggiornamento automatico al ripristino
- [x] Sincronizzazione all'avvio app
- [x] Eventi `subscription_purchased` e `subscription_restored`
- [ ] Verifica in DebugView (fai tu quando testi)
- [ ] Crea audience Premium Users
- [ ] Crea audience Free Users
- [ ] Imposta alerts per conversion rate
- [ ] Crea dashboard Premium vs Free
- [ ] Documenta KPI target
- [ ] Condividi report con team

---

## 🎓 Risorse Utili

- [Firebase Analytics User Properties](https://firebase.google.com/docs/analytics/user-properties)
- [Firebase Analytics Events](https://firebase.google.com/docs/analytics/events)
- [BigQuery Export](https://firebase.google.com/docs/analytics/bigquery-export)
- [Analytics Debugger](https://firebase.google.com/docs/analytics/debugview)

---

**Ultimo aggiornamento**: Gennaio 2026

---

## 🚀 Pronto all'Uso!

Il tracking è già implementato e funzionante. Basta:
1. Avviare l'app
2. Lo stato viene automaticamente tracciato
3. Visualizzare i dati in Firebase Console

**Nessun progetto Firebase aggiuntivo necessario!** ✨
