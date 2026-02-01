#!/bin/bash
# Script per attivare la versione ML Kit di Polsat
# Usa questo per compilare su DEVICE FISICI

set -e

echo "🚀 Attivando versione ML Kit (device fisici)..."
echo ""

# 1. Copia provider Polsat ML Kit
echo "📄 [1/5] Copiando polsat_provider.mlkit.dart..."
cp lib/core/teletext/providers/_versions/polsat_provider.mlkit.dart \
   lib/core/teletext/providers/polsat_provider.dart
echo "   ✅ Polsat Provider ML Kit attivato"

# 1b. Copia servizio OCR Zattoo ML Kit
echo "📄 [1b/5] Copiando zattoo_ocr_service.mlkit.dart..."
cp lib/core/ocr/_versions/zattoo_ocr_service.mlkit.dart \
   lib/core/ocr/google_vision_ocr_service.dart
echo "   ✅ Zattoo OCR ML Kit attivato"

# 2. Copia pubspec.yaml con ML Kit
echo "📦 [2/5] Copiando pubspec.yaml con ML Kit..."
cp _config_versions/pubspec.mlkit.yaml pubspec.yaml
echo "   ✅ pubspec.yaml ML Kit attivato"

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
echo "✅ ===== VERSIONE ML KIT ATTIVATA! ====="
echo ""
echo "📦 Provider attivati:"
echo "   - Polsat: ML Kit (veloce)"
echo "   - Zattoo (ARTE, RBB, etc.): ML Kit (veloce)"
echo ""
echo "📱 Ora puoi compilare su DEVICE FISICI:"
echo "   flutter run -d 00008101-001435943EA1001E"
echo ""
echo "🚀 Oppure da Xcode:"
echo "   open ios/Runner.xcworkspace"
echo "   Seleziona un device fisico e Run (⌘R)"
echo ""
echo "⚠️  NON usare su simulatore iOS (ML Kit non supportato)"
echo ""
