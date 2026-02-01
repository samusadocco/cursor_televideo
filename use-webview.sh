#!/bin/bash
# Script per attivare la versione WebView di Polsat
# Usa questo per compilare su SIMULATORE iOS

set -e

echo "🌐 Attivando versione WebView (simulatore iOS)..."
echo ""

# 1. Copia provider Polsat WebView
echo "📄 [1/5] Copiando polsat_provider.webview.dart..."
cp lib/core/teletext/providers/_versions/polsat_provider.webview.dart \
   lib/core/teletext/providers/polsat_provider.dart
echo "   ✅ Polsat Provider WebView attivato"

# 1b. Copia servizio OCR Zattoo Google Vision
echo "📄 [1b/5] Copiando zattoo_ocr_service.google.dart..."
cp lib/core/ocr/_versions/zattoo_ocr_service.google.dart \
   lib/core/ocr/google_vision_ocr_service.dart
echo "   ✅ Zattoo OCR Google Vision attivato"

# 2. Copia pubspec.yaml senza ML Kit
echo "📦 [2/5] Copiando pubspec.yaml senza ML Kit..."
cp _config_versions/pubspec.webview.yaml pubspec.yaml
echo "   ✅ pubspec.yaml WebView attivato"

# 3. Flutter pub get
echo "🔄 [3/5] Eseguendo flutter pub get..."
flutter pub get > /dev/null 2>&1 || {
  echo "   ⚠️  Errore durante flutter pub get"
  flutter pub get
  exit 1
}
echo "   ✅ flutter pub get completato"

# 4. Pod install (solo iOS)
if [ -d "ios" ]; then
  echo "🍎 [4/5] Eseguendo pod install..."
  cd ios
  # Rimuovi cache pod
  rm -rf Pods Podfile.lock > /dev/null 2>&1 || true
  pod install > /dev/null 2>&1 || {
    echo "   ⚠️  Errore durante pod install"
    pod install
    cd ..
    exit 1
  }
  cd ..
  echo "   ✅ pod install completato"
fi

echo ""
echo "✅ ===== VERSIONE WEBVIEW ATTIVATA! ====="
echo ""
echo "📦 Provider attivati:"
echo "   - Polsat: WebView (compatibile)"
echo "   - Zattoo (ARTE, RBB, etc.): Google Vision API (cloud)"
echo ""
echo "📱 Ora puoi compilare su SIMULATORE iOS:"
echo "   1. Apri Xcode: open ios/Runner.xcworkspace"
echo "   2. Seleziona un simulatore (iPhone 17, iPad Pro, etc.)"
echo "   3. Product → Clean Build Folder (⇧⌘K)"
echo "   4. Product → Run (⌘R)"
echo ""
echo "⚡ La versione WebView è più lenta (~2s) ma compatibile con simulatore"
echo ""
