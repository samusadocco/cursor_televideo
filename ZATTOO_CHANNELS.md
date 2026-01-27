# Come aggiungere nuovi canali Zattoo

Il sistema OCR è ora generico e può essere usato per qualsiasi canale sulla piattaforma Zattoo.

## Canali Zattoo supportati

Attualmente implementato:
- ✅ **ARTE** (DE_arte) - Germania/Francia

## Come aggiungere un nuovo canale Zattoo

### 1. Verifica URL Zattoo

L'API Zattoo usa questo formato:
```
https://zapi.zattoo.com/teletext/{CHANNEL_ID}/hd/{PAGE}/{SUBPAGE}.html
```

Esempi:
- ARTE: `https://zapi.zattoo.com/teletext/DE_arte/hd/100/1.html`
- ZDF: `https://zapi.zattoo.com/teletext/DE_zdf/hd/100/1.html`
- ARD: `https://zapi.zattoo.com/teletext/DE_ard/hd/100/1.html`

### 2. Aggiungi canale in `teletext_channels.dart`

```dart
TeletextChannel(
  id: 'zdf_zattoo',  // ID univoco
  name: 'ZDF Text (Zattoo)',
  shortName: 'ZDF',
  countryCode: 'DE',
  flagEmoji: '🇩🇪',
  broadcasterName: 'ZDF',
  type: TeletextChannelType.national,
  baseUrl: 'https://zapi.zattoo.com/teletext/DE_zdf/hd/',
  htmlBaseUrl: 'https://zapi.zattoo.com/teletext/DE_zdf/hd/100/1.html',
  supportsRegions: false,
),
```

### 3. Aggiungi factory in `zattoo_provider.dart`

```dart
/// Factory per ZDF
factory ZattooProvider.zdf() {
  return ZattooProvider(
    channelId: 'DE_zdf',
    providerId: 'zdf_zattoo',
    providerName: 'ZDF Text (Zattoo)',
    countryCode: 'DE',
  );
}
```

### 4. Aggiungi case in `provider_factory.dart`

```dart
} else if (channel.id == 'zdf_zattoo') {
  provider = ZattooProvider.zdf();
```

### 5. Verifica dimensioni immagine

Carica una pagina del nuovo canale e guarda i log:
```
[Zattoo/DE_zdf] Image decoded: XXXXX bytes
```

Poi apri il sito manualmente e verifica le dimensioni dell'immagine (ispeziona elemento).

Aggiungi in `televideo_viewer.dart` nella funzione `_onTapUp`:

```dart
} else if (widget.page.providerId == 'zdf_zattoo') {
  // Zattoo (ZDF): WIDTHxHEIGHT (verifica dimensioni reali!)
  originalWidth = 492.0;  // VERIFICA!
  originalHeight = 500.0; // VERIFICA!
```

### 6. Test

1. Avvia l'app
2. Seleziona il nuovo canale
3. Vai su una pagina con numeri (es. 100)
4. Verifica che:
   - ✅ L'immagine viene caricata
   - ✅ I link vengono riconosciuti dall'OCR
   - ✅ Tappando sui numeri naviga alle pagine
   - ✅ La cache funziona (seconda visita istantanea)

## Canali Zattoo potenziali

Cerca canali disponibili provando URL tipo:
- `https://zapi.zattoo.com/teletext/DE_{nome}/hd/100/1.html`
- `https://zapi.zattoo.com/teletext/CH_{nome}/hd/100/1.html`
- `https://zapi.zattoo.com/teletext/AT_{nome}/hd/100/1.html`

Esempi da provare:
- ZDF: `DE_zdf`
- ARD: `DE_ard`
- ORF: `AT_orf1`, `AT_orf2`
- SRF: `CH_srf1`, `CH_srf2`

## Note

- **OCR**: Funziona automaticamente per tutti i canali Zattoo
- **Cache**: Condivisa tra tutti i canali (24 ore)
- **Costi API**: ~1 richiesta per pagina nuova (cache evita chiamate ripetute)
- **Performance**: ~1.5-2s prima visita, istantaneo con cache

## Requisiti

- Google Cloud Vision API key configurata (vedi `GOOGLE_VISION_SETUP.md`)
- Tier gratuito: 1000 richieste/mese
- Con cache attiva, difficilmente supererai il limite gratuito
