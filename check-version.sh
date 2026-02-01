#!/bin/bash
# Script per verificare quale versione Polsat è attualmente attiva

echo "🔍 Verifica versione Polsat attiva..."
echo ""

# Check provider
if grep -q "VERSIONE ML KIT" lib/core/teletext/providers/polsat_provider.dart 2>/dev/null; then
    echo "📄 Provider: 🚀 ML KIT (device fisico)"
    PROVIDER_VERSION="mlkit"
elif grep -q "VERSIONE WEBVIEW" lib/core/teletext/providers/polsat_provider.dart 2>/dev/null; then
    echo "📄 Provider: 🌐 WEBVIEW (simulatore)"
    PROVIDER_VERSION="webview"
else
    echo "📄 Provider: ❓ SCONOSCIUTA"
    PROVIDER_VERSION="unknown"
fi

# Check OCR service for Zattoo
if grep -q "Servizio OCR per canali Zattoo usando ML Kit" lib/core/ocr/google_vision_ocr_service.dart 2>/dev/null; then
    echo "🔍 Zattoo OCR: 🚀 ML KIT (veloce, device)"
    OCR_VERSION="mlkit"
elif grep -q "Servizio OCR basato su Google Cloud Vision API" lib/core/ocr/google_vision_ocr_service.dart 2>/dev/null; then
    echo "🔍 Zattoo OCR: ☁️  GOOGLE VISION (cloud, simulator)"
    OCR_VERSION="google"
else
    echo "🔍 Zattoo OCR: ❓ SCONOSCIUTA"
    OCR_VERSION="unknown"
fi

# Check pubspec.yaml (cerca nel commento di intestazione per distinguere le versioni)
if grep -q "# VERSIONE ML KIT" pubspec.yaml 2>/dev/null; then
    echo "📦 pubspec.yaml: 🚀 ML KIT (con google_mlkit_text_recognition)"
    PUBSPEC_VERSION="mlkit"
elif grep -q "# VERSIONE WEBVIEW" pubspec.yaml 2>/dev/null; then
    echo "📦 pubspec.yaml: 🌐 WEBVIEW (senza ML Kit)"
    PUBSPEC_VERSION="webview"
else
    echo "📦 pubspec.yaml: ❓ SCONOSCIUTA"
    PUBSPEC_VERSION="unknown"
fi

echo ""

# Check consistency
# WebView config: provider=webview, ocr=google, pubspec=webview (coerente)
# MLKit config: provider=mlkit, ocr=mlkit, pubspec=mlkit (coerente)
if ([ "$PROVIDER_VERSION" = "mlkit" ] && [ "$OCR_VERSION" = "mlkit" ] && [ "$PUBSPEC_VERSION" = "mlkit" ]) || \
   ([ "$PROVIDER_VERSION" = "webview" ] && [ "$OCR_VERSION" = "google" ] && [ "$PUBSPEC_VERSION" = "webview" ]); then
    if [ "$PROVIDER_VERSION" = "mlkit" ]; then
        echo "✅ Configurazione COERENTE: ML KIT (device fisico)"
        echo "   - Polsat: ML Kit"
        echo "   - Zattoo: ML Kit"
        echo "   Pronto per: flutter run -d <device-id>"
    elif [ "$PROVIDER_VERSION" = "webview" ]; then
        echo "✅ Configurazione COERENTE: WEBVIEW/GOOGLE (simulatore iOS)"
        echo "   - Polsat: WebView"
        echo "   - Zattoo: Google Vision API"
        echo "   Pronto per: open ios/Runner.xcworkspace + Run"
    else
        echo "❓ Configurazione sconosciuta"
    fi
else
    echo "⚠️  ATTENZIONE: Configurazione NON COERENTE!"
    echo "   Polsat Provider: $PROVIDER_VERSION"
    echo "   Zattoo OCR: $OCR_VERSION"
    echo "   pubspec.yaml: $PUBSPEC_VERSION"
    echo ""
    echo "   Esegui uno script per sincronizzare:"
    echo "   ./use-mlkit.sh   (device fisico)"
    echo "   ./use-webview.sh (simulatore)"
fi

echo ""
echo "💡 Per switchare:"
echo "   Device fisico:  ./use-mlkit.sh"
echo "   Simulatore iOS: ./use-webview.sh"
echo ""
