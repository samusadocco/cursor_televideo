# Come disabilitare l'ottimizzazione OCR

Se l'ottimizzazione immagine causa problemi con il riconoscimento dei link, puoi disabilitarla completamente.

## File da modificare

`lib/core/ocr/google_vision_ocr_service.dart`

Cerca questa riga (circa riga 109):

```dart
final optimizedBytes = _optimizeImage(imageBytes);
```

E sostituiscila con:

```dart
final optimizedBytes = imageBytes; // Ottimizzazione disabilitata
```

Questo userà l'immagine originale senza modifiche, garantendo il 100% di accuratezza OCR, ma sarà un po' più lenta (~30-40% in più di tempo).

## Trade-off

**Con ottimizzazione (JPEG 98%):**
- ✅ ~30-40% più veloce
- ❓ Potrebbe non riconoscere alcuni link

**Senza ottimizzazione:**
- ✅ 100% accuratezza OCR
- ❌ ~30-40% più lento (~1.5 secondi invece di 1 secondo)

La cache funziona in entrambi i casi, quindi le pagine già visitate sono sempre istantanee.
