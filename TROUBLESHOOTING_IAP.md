# 🔧 Risoluzione Problema "Abbonamento Premium non disponibile"

## 🚨 Il Problema

Stai vedendo questo messaggio nella pagina Premium:
```
⚠️ Abbonamento Premium non disponibile al momento
```

## ❓ Causa

I prodotti IAP **non sono stati trovati** dall'app. Questo può succedere per 4 motivi principali:

---

## 🔍 Diagnosi: Controlla i Log Debug

### 1. Riavvia l'app e guarda i log

Nella console di Flutter, cerca questi messaggi:

```dart
// ✅ TUTTO OK
[IAPService] Initializing...
[IAPService] Store is available
[IAPService] Loading products...
[IAPService] Loaded 2 products
[IAPService] Product: premium_subscription_monthly - Teletext Premium - €1.49
[IAPService] Product: premium_subscription_quarterly2 - Teletext Premium - €2.99
✅ IAP Service initialized successfully

// ❌ PROBLEMA 1: Store non disponibile
[IAPService] Initializing...
[IAPService] Store not available  ← PROBLEMA!
⚠️ IAP Service initialization failed

// ❌ PROBLEMA 2: Prodotti non trovati
[IAPService] Loading products...
[IAPService] Products not found: [premium_subscription_monthly, premium_subscription_quarterly2]
[IAPService] Loaded 0 products  ← PROBLEMA!
```

### 2. Nella pagina Premium (in Debug Mode)

Ho aggiunto un pannello debug che mostra:
```
ℹ️ DEBUG INFO
Store disponibile: ✅ SI o ❌ NO
Prodotti caricati: 0
Mensile: Non trovato
Trimestrale: Non trovato

💡 Possibili cause:
• Prodotti non configurati su App/Play Store
• Simulatore iOS (usa dispositivo reale)
• Emulatore Android senza Play Store
• Product IDs non corrispondenti
```

---

## 🔧 Soluzioni per Causa

### ✅ SOLUZIONE 1: Stai Usando un Simulatore iOS?

**Problema**: Gli IAP **NON funzionano** sul Simulatore iOS.

**Soluzione**:
1. **Usa un dispositivo iOS reale** collegato al Mac
2. **Configura Sandbox Tester Account**:
   - App Store Connect → Users and Access → Sandbox Testers
   - Crea un nuovo tester con email non usata
3. **Sul dispositivo**:
   - Impostazioni → App Store → ESCI dall'Apple ID reale
   - Avvia l'app da Xcode/Flutter
   - Quando acquisti, usa le credenziali Sandbox Tester

```bash
# Avvia su dispositivo reale
flutter run -d [DEVICE_ID]

# Lista dispositivi disponibili
flutter devices
```

---

### ✅ SOLUZIONE 2: Prodotti NON Configurati su App Store Connect (iOS)

**Problema**: I prodotti con ID `premium_subscription_monthly` e `premium_subscription_quarterly2` non esistono.

**Soluzione**:

1. **Vai su [App Store Connect](https://appstoreconnect.apple.com/)**

2. **My Apps** → Seleziona "Teletext Europe"

3. **Features** → **In-App Purchases** (o **Subscriptions**)

4. **Crea Subscription Group** (se non esiste):
   - Nome: "Teletext Premium"

5. **Aggiungi Auto-Renewable Subscriptions**:

**Mensile:**
```
+ (Plus button) → Auto-Renewable Subscription
Product ID: premium_subscription_monthly
Reference Name: Premium Monthly
Subscription Duration: 1 Month
Price: Tier 3 (€1.49)
```

**Trimestrale:**
```
+ (Plus button) → Auto-Renewable Subscription
Product ID: premium_subscription_quarterly2
Reference Name: Premium Quarterly
Subscription Duration: 3 Months
Price: Tier 5 (€2.99)
```

6. **Per ogni prodotto, aggiungi localizzazione**:
   - Italiano: "Teletext Premium" + descrizione
   - English: "Teletext Premium" + descrizione

7. **Salva** (non serve inviare per revisione per testare in sandbox)

8. **Aspetta 5-15 minuti** perché i prodotti si propaghino

9. **Riavvia l'app**

---

### ✅ SOLUZIONE 3: Emulatore Android senza Google Play

**Problema**: Emulatore Android non ha Google Play Store.

**Soluzione A - Usa Emulatore con Play Store**:
```bash
# Crea nuovo emulatore con Play Store
# In Android Studio:
# AVD Manager → Create Device → Seleziona immagine con Play Store
# (icona triangolo Play colorato)
```

**Soluzione B - Usa Dispositivo Fisico**:
```bash
# Collega dispositivo Android via USB
# Abilita Debug USB nelle Impostazioni Sviluppatore

flutter devices
flutter run -d [ANDROID_DEVICE_ID]
```

---

### ✅ SOLUZIONE 4: Prodotti NON Configurati su Google Play Console (Android)

**Problema**: I prodotti non esistono su Play Console.

**Soluzione**:

1. **Vai su [Google Play Console](https://play.google.com/console/)**

2. Seleziona "Teletext Europe"

3. **Monetizzazione** → **Prodotti** → **Abbonamenti**

4. **Crea abbonamento**:
   - Product ID: Crea un nuovo subscription product
   - Nome: "Teletext Premium"

5. **Aggiungi Base Plans**:

**Mensile:**
```
+ Add base plan
Base plan ID: monthly
Billing period: 1 month (P1M)
Price: €1.49
```

**Trimestrale:**
```
+ Add base plan
Base plan ID: quarterly
Billing period: 3 months (P3M)
Price: €2.99
```

6. **Attiva** l'abbonamento

7. **Aggiungi tester**:
   - Impostazioni → License testing
   - Aggiungi il tuo account Google
   
8. **Pubblica una versione di test**:
   - Testing → Internal testing
   - Carica l'AAB

**IMPORTANTE per Android**: I prodotti DEVONO essere collegati a una versione pubblicata (anche su track di test interno).

---

### ✅ SOLUZIONE 5: Testing Rapido con Prodotti Mock

Se vuoi testare l'UI **prima** di configurare gli store:

<function_calls>
<invoke name="StrReplace">
<parameter name="path">/Users/samuele/flutter_apps/cursor_televideo/lib/core/iap/iap_service.dart