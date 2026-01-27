# Google Cloud Vision API Setup

Questo documento spiega come configurare Google Cloud Vision API per abilitare il riconoscimento automatico dei link (OCR) nelle pagine teletext basate su immagini (es. ARTE).

## Perché Google Cloud Vision?

Google Cloud Vision API offre:
- ✅ **Alta accuratezza** nel riconoscimento testo
- ✅ **Compatibilità universale** (cloud-based, nessun problema iOS/Android)
- ✅ **Tier gratuito generoso**: 1000 richieste/mese gratis
- ✅ **Costi bassi**: ~$1.50 per 1000 richieste aggiuntive

## Come ottenere l'API key

### 1. Crea un progetto Google Cloud

1. Vai su [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuovo progetto o seleziona uno esistente
3. Abilita "Cloud Vision API":
   - Vai su "API e servizi" > "Libreria"
   - Cerca "Cloud Vision API"
   - Clicca "Abilita"

### 2. Crea le credenziali

1. Vai su "API e servizi" > "Credenziali"
2. Clicca "Crea credenziali" > "Chiave API"
3. Copia la chiave API generata
4. (Consigliato) Restrizioni chiave:
   - In "Restrizioni applicazione" seleziona "App iOS" o "App Android"
   - Aggiungi il bundle ID della tua app (es. `com.example.cursor_televideo`)
   - In "Restrizioni API" seleziona "Cloud Vision API"

### 3. Configura l'API key nell'app

**Metodo 1: Tramite codice (per sviluppo)**

Nel file `main.dart` o dove inizializzi l'app, aggiungi:

```dart
import 'package:cursor_televideo/core/config/ocr_config_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura API key (solo per sviluppo/testing)
  await OcrConfigService.setGoogleVisionApiKey('YOUR_API_KEY_HERE');
  
  runApp(MyApp());
}
```

**Metodo 2: Tramite UI Settings (TODO)**

Aggiungeremo una schermata nelle impostazioni dell'app dove l'utente potrà inserire la propria API key.

## Costi stimati

Con uso normale dell'app (2-3 utenti, navigazione tipica):
- **~100-300 richieste/mese** → **GRATIS** (sotto il tier gratuito di 1000)
- Anche con uso intenso (~5000 richieste/mese) → **~$7.50/mese**

## Privacy e sicurezza

⚠️ **IMPORTANTE**: 
- L'API key con restrizioni (iOS/Android bundle ID) può essere inclusa nell'app
- Le immagini teletext vengono inviate a Google Cloud per l'OCR
- Google non memorizza le immagini (vedi [Privacy Policy](https://cloud.google.com/vision/docs/data-usage))

## Alternative

Se non vuoi usare Google Cloud Vision:
1. **Nessun OCR**: ARTE funziona come viewer semplice (già implementato come fallback)
2. **OCR locale**: Tesseract (non funziona su iOS simulator, problemi di stabilità)
3. **Altri servizi OCR**: AWS Textract, Azure Computer Vision (simili costi e setup)

## Testing

Per testare se l'OCR funziona:
1. Configura l'API key come sopra
2. Avvia l'app
3. Vai su canale ARTE
4. Apri pagina 100
5. Controlla i log per:
   ```
   [GoogleVisionOCR] API key loaded from configuration
   [ARTE] Starting Google Vision OCR...
   [GoogleVisionOCR] ✅ Found X page links
   ```

## Troubleshooting

**"API key not configured"**
- Verifica di aver chiamato `OcrConfigService.setGoogleVisionApiKey()`
- L'API key viene salvata in SharedPreferences e persiste tra riavvii

**"API error: 403"**
- Verifica di aver abilitato Cloud Vision API nel progetto
- Verifica le restrizioni della chiave (bundle ID corretto)

**"Timeout"**
- Verifica la connessione internet
- Google Vision API richiede connessione attiva

**Nessun link trovato**
- L'OCR ha funzionato ma la pagina non contiene numeri a 3 cifre
- Verifica i log per vedere il testo riconosciuto
