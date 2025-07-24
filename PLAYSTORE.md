# Informazioni Pubblicazione Play Store

## Package Name
```
it.codebysam.televideo
```

## Keystore e Credenziali

Il keystore per la firma dell'app Android si trova in:
```
android/app/upload-keystore.jks
```

### Credenziali Keystore
- **Store password:** `televideo`
- **Key alias:** `upload`
- **Key password:** `televideo`

⚠️ **IMPORTANTE:** Conserva queste credenziali in modo sicuro. Saranno necessarie per:
1. Firmare futuri aggiornamenti dell'app
2. Caricare l'app sul Play Store
3. Gestire il ciclo di vita dell'app su Android

Se perdi queste credenziali:
- Non potrai più pubblicare aggiornamenti dell'app
- Dovrai pubblicare una nuova app con un nuovo package name
- Gli utenti esistenti non riceveranno gli aggiornamenti

## Generazione Bundle

Per generare un nuovo bundle firmato per il Play Store:

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Il bundle firmato sarà disponibile in:
```
build/app/outputs/bundle/release/app-release.aab
```

## Generazione APK

Per generare un APK firmato per test locali:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

L'APK firmato sarà disponibile in:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Note Aggiuntive

- Il bundle include la configurazione ProGuard per l'ottimizzazione del codice
- La firma viene applicata automaticamente durante la build usando le credenziali configurate in `android/app/build.gradle.kts`
- Il bundle è ottimizzato per la distribuzione attraverso il Play Store
- L'APK è utile per test locali ma non dovrebbe essere distribuito direttamente
- Il package name è stato impostato come `it.codebysam.televideo` per rispettare le linee guida del Play Store che non permettono l'uso di "com.example" 