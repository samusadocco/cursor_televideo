# Messaggi remoti temporanei

Sistema per mostrare messaggi all'utente in base a:
- **Lingua** dell'app
- **Paese** (store/dispositivo)
- **Versione** dell'app (es. messaggio solo se versione < 2.2.0)

## Configurazione URL

L'URL è impostato in `main.dart`:
```dart
messagesUrl: 'https://www.codebysam.it/teleretro/messages.json'
```

Per usare il PHP:
```dart
messagesUrl: 'https://www.codebysam.it/teleretro/api/messages.php?lang=it&country=IT&version=2.1.1'
```
> Nota: con PHP l'app passa comunque i parametri; il backend può filtrare lato server.

## Formato JSON (file statico)

```json
{
  "messages": [
    {
      "id": "univoco",
      "content": {
        "it": "Testo in italiano",
        "en": "Text in English",
        "de": "Text auf Deutsch"
      },
      "fallbackContent": "Testo se lingua mancante",
      "countries": ["IT", "DE"],
      "channels": ["rai_nazionale", "ard_text"],
      "languages": ["it", "en"],
      "maxVersion": "2.2.0",
      "minVersion": "2.0.0",
      "priority": 1,
      "type": "snackbar",
      "actionUrl": "https://...",
      "actionLabel": "Apri"
    }
  ]
}
```

### Campi
- **id**: identificativo univoco
- **content**: mappa lingua → testo
- **fallbackContent**: usato se la lingua non è in content
- **countries**: lista codici paese (IT, DE, ...); null = tutti
- **languages**: lista lingue (it, en, ...); null = tutte
- **channels**: lista ID canale preferito (rai_nazionale, ard_text, ...); null o [] = tutti i canali
- **maxVersion**: messaggio solo se versione app < questa
- **minVersion**: messaggio solo se versione app >= questa
- **isUpdateNotification**: true = messaggio evidenziato (icona, colore amber, rimando App Store)
- **priority**: ordine (maggiore = prima)
- **type**: `snackbar` | `banner`
- **actionUrl** / **actionLabel**: pulsante opzionale (per aggiornamenti: link App Store)
- **isUpdateNotification**: evidenzia come messaggio di aggiornamento (stile distintivo)

## Backend PHP (Aruba)

Carica `messages.php` in `teleretro/api/` sul tuo spazio web.
L'endpoint accetta `?lang=it&country=IT&version=2.1.1` e restituisce JSON con `messages` filtrati.

Per usare il PHP dall'app, modifica il service per passare i parametri nell'URL.
