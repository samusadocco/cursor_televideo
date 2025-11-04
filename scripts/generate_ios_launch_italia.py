#!/usr/bin/env python3
"""
Script per generare le LaunchImage iOS specifiche per l'Italia
Usa questo script se vuoi implementare la localizzazione iOS nativa
"""

from PIL import Image
from pathlib import Path
import sys

# Importa le funzioni dallo script principale
sys.path.append(str(Path(__file__).parent))
from generate_splash_images import create_splash_screen_image, generate_ios_launch_images

def main():
    print("🇮🇹 Generazione LaunchImage iOS per Italia\n")
    
    # Genera l'immagine splash per l'Italia
    print("Generazione immagine splash Italia...")
    splash_italia = create_splash_screen_image("TeleRetrò", "Europa", 1024)
    
    # Percorso di output (cartella separata per evitare di sovrascrivere)
    output_path = Path("../ios/Runner/Assets.xcassets/LaunchImage-Italia.imageset")
    
    # Genera tutte le dimensioni per iOS
    print(f"Generazione LaunchImage in tutte le dimensioni...")
    generate_ios_launch_images(splash_italia, output_path)
    
    # Genera anche il Contents.json
    contents_json = """{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "LaunchImage.png",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "filename" : "LaunchImage@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "filename" : "LaunchImage@3x.png",
      "scale" : "3x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
"""
    
    (output_path / "Contents.json").write_text(contents_json)
    
    print(f"\n✅ LaunchImage Italia generate in: {output_path.absolute()}")
    
    print("\n📝 Prossimi passi per implementare la localizzazione iOS:")
    print("   1. Apri Xcode: open ios/Runner.xcworkspace")
    print("   2. Seleziona 'Runner' nel Project Navigator")
    print("   3. Vai in 'Info' tab")
    print("   4. In 'Localizations', aggiungi 'Italian (it)'")
    print("   5. Seleziona 'LaunchScreen.storyboard' nel Navigator")
    print("   6. In File Inspector, abilita 'Localize...' e seleziona 'Italian'")
    print("   7. Modifica il storyboard italiano per usare 'LaunchImage-Italia'")
    print("\n💡 Questo richiede una build separata per l'App Store italiano")

if __name__ == "__main__":
    main()

