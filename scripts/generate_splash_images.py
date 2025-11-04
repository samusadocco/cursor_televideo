#!/usr/bin/env python3
"""
Script per generare le immagini di splash screen per TeleRetrò
Genera due versioni:
1. TeleRetrò Europa (per Italia)
2. Teletext Europe (per altri paesi)
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance
from pathlib import Path
import math
import random

# Configurazione
OUTPUT_DIR = Path("../assets/images/splash")
FONT_PATH = "scripts/fonts/VT323-Regular.ttf"

def create_crt_distortion(image, intensity=0.3):
    """Crea una distorsione barrel tipica dei CRT"""
    width, height = image.size
    distorted = Image.new('RGB', (width, height))
    
    for x in range(width):
        for y in range(height):
            nx = (2 * x - width) / width
            ny = (2 * y - height) / height
            r = math.sqrt(nx * nx + ny * ny)
            
            if r < 1:
                theta = math.atan2(ny, nx)
                r2 = r * (1 + intensity * r * r)
                
                sx = width * (r2 * math.cos(theta) + 1) / 2
                sy = height * (r2 * math.sin(theta) + 1) / 2
                
                if 0 <= sx < width and 0 <= sy < height:
                    distorted.putpixel((x, y), image.getpixel((int(sx), int(sy))))
                else:
                    distorted.putpixel((x, y), (0, 0, 0))
            else:
                distorted.putpixel((x, y), (0, 0, 0))
    
    return distorted

def add_chromatic_aberration(image, offset=3):
    """Aggiunge aberrazione cromatica"""
    from PIL import ImageChops
    r, g, b = image.split()
    r = ImageChops.offset(r, offset, 0)
    b = ImageChops.offset(b, -offset, 0)
    return Image.merge('RGB', (r, g, b))

def add_noise(image, intensity=10):
    """Aggiunge rumore casuale all'immagine"""
    pixels = image.load()
    width, height = image.size
    
    for x in range(width):
        for y in range(height):
            r, g, b = pixels[x, y]
            noise = random.randint(-intensity, intensity)
            pixels[x, y] = (
                max(0, min(255, r + noise)),
                max(0, min(255, g + noise)),
                max(0, min(255, b + noise))
            )
    
    return image

def create_splash_screen_image(text_line1, text_line2, size=1024):
    """
    Crea un'immagine di splash screen in stile CRT
    
    Args:
        text_line1: Prima riga di testo (es. "TeleRetrò" o "Teletext")
        text_line2: Seconda riga di testo (es. "Europa" o "Europe")
        size: Dimensione dell'immagine quadrata
    """
    # Crea un'immagine quadrata con sfondo nero
    image = Image.new('RGB', (size, size), 'black')
    draw = ImageDraw.Draw(image)
    
    # Crea l'effetto CRT (bordo più pronunciato)
    margin = size // 15
    screen_size = size - (2 * margin)
    
    # Crea un bordo sfumato per simulare la plastica del monitor
    for i in range(margin):
        color = int(40 * (1 - i/margin))
        draw.rectangle(
            [(i, i), (size-i-1, size-i-1)],
            outline=f'#{color:02x}{color:02x}{color:02x}'
        )
    
    # Carica il font in stile pixel
    text_size = int(screen_size * 0.1)
    try:
        font = ImageFont.truetype(FONT_PATH, text_size)
    except:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Courier New Bold.ttf", text_size)
        except:
            font = ImageFont.load_default()
    
    # Componi il testo con spaziatura
    text = f"{text_line1}\n  {text_line2}"
    
    # Calcola la posizione del testo per centrarlo
    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    text_x = (size - text_width) // 2
    text_y = (size - text_height) // 2
    
    # Disegna il testo principale in verde televideo brillante
    draw.text((text_x, text_y), text, font=font, fill='#50ff50')
    
    # Aggiungi un bagliore intenso al testo
    glow = image.copy()
    for _ in range(3):
        glow = glow.filter(ImageFilter.GaussianBlur(size // 30))
    enhancer = ImageEnhance.Brightness(glow)
    glow = enhancer.enhance(2.0)
    
    # Combina l'immagine originale con il bagliore
    image = Image.blend(glow, image, 0.5)
    
    # Aggiungi effetto scanlines più pronunciato
    scanlines = Image.new('RGB', (size, size), 'black')
    draw_scanlines = ImageDraw.Draw(scanlines)
    for y in range(0, size, 2):
        draw_scanlines.line([(0, y), (size, y)], fill='#111111', width=1)
    image = Image.blend(image, scanlines, 0.15)
    
    # Applica la distorsione CRT
    image = create_crt_distortion(image)
    
    # Aggiungi aberrazione cromatica
    image = add_chromatic_aberration(image)
    
    # Aggiungi rumore
    image = add_noise(image)
    
    # Applica un leggero bloom finale
    image = image.filter(ImageFilter.GaussianBlur(1))
    
    return image

def generate_ios_launch_images(base_image, destination_path):
    """
    Genera le immagini di avvio per iOS in tutte le dimensioni richieste
    
    Args:
        base_image: L'immagine base (1024x1024)
        destination_path: Path alla cartella di destinazione
    """
    # Dimensioni per i vari dispositivi iOS (formato verticale)
    ios_launch_sizes = {
        # Universale (usate da LaunchScreen.storyboard)
        'LaunchImage.png': (1024, 1024),         # 1x
        'LaunchImage@2x.png': (2048, 2048),      # 2x
        'LaunchImage@3x.png': (3072, 3072),      # 3x
        # iPhone specifici (legacy)
        'LaunchImage-iPhone@2x.png': (640, 960),      # iPhone 4/4s
        'LaunchImage-568h@2x.png': (640, 1136),       # iPhone 5/5s/SE
        'LaunchImage-667h@2x.png': (750, 1334),       # iPhone 6/6s/7/8
        'LaunchImage-736h@3x.png': (1242, 2208),      # iPhone 6+/6s+/7+/8+
        'LaunchImage-2436h@3x.png': (1125, 2436),     # iPhone X/XS
        'LaunchImage-2688h@3x.png': (1242, 2688),     # iPhone XS Max
        'LaunchImage-1792h@2x.png': (828, 1792),      # iPhone XR
        # iPad
        'LaunchImage-Portrait.png': (768, 1024),      # iPad 1/2
        'LaunchImage-Portrait@2x.png': (1536, 2048),  # iPad 3/4/Air/Mini
        'LaunchImage-Portrait-1112h@2x.png': (1668, 2224),  # iPad Pro 10.5"
        'LaunchImage-Portrait-1194h@2x.png': (1668, 2388),  # iPad Pro 11"
        'LaunchImage-Portrait-1366h@2x.png': (2048, 2732),  # iPad Pro 12.9"
    }
    
    destination_path.mkdir(parents=True, exist_ok=True)
    
    for filename, (width, height) in ios_launch_sizes.items():
        # Per immagini quadrate (universali), mantieni le dimensioni
        if width == height:
            resized = base_image.resize((width, height), Image.Resampling.LANCZOS)
            resized.save(destination_path / filename)
        else:
            # Per formati verticali, centra l'immagine quadrata su sfondo nero
            # Calcola la dimensione per riempire la larghezza
            scale = width / base_image.width
            new_size = int(base_image.width * scale)
            resized = base_image.resize((new_size, new_size), Image.Resampling.LANCZOS)
            
            # Crea un'immagine nera delle dimensioni target
            final = Image.new('RGB', (width, height), 'black')
            
            # Centra l'immagine ridimensionata
            paste_x = (width - new_size) // 2
            paste_y = (height - new_size) // 2
            final.paste(resized, (paste_x, paste_y))
            
            final.save(destination_path / filename)

def generate_splash_images():
    """Genera le immagini di splash per Italia e altri paesi"""
    # Crea la directory di output
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    print("Generazione splash screen per Italia...")
    splash_italia = create_splash_screen_image("TeleRetrò", "Europa", 1024)
    splash_italia.save(OUTPUT_DIR / "splash_italia.png")
    print(f"✅ Salvata: {OUTPUT_DIR / 'splash_italia.png'}")
    
    print("\nGenerazione splash screen per altri paesi...")
    splash_international = create_splash_screen_image("Teletext", "Europe", 1024)
    splash_international.save(OUTPUT_DIR / "splash_international.png")
    print(f"✅ Salvata: {OUTPUT_DIR / 'splash_international.png'}")
    
    # Genera anche versioni ridimensionate per diverse densità
    print("\nGenerazione immagini ottimizzate...")
    
    sizes = {
        'splash_italia_1024.png': 1024,
        'splash_italia_512.png': 512,
        'splash_italia_256.png': 256,
        'splash_international_1024.png': 1024,
        'splash_international_512.png': 512,
        'splash_international_256.png': 256,
    }
    
    for filename, size in sizes.items():
        if 'italia' in filename:
            base_image = splash_italia
        else:
            base_image = splash_international
        
        if size != 1024:
            resized = base_image.resize((size, size), Image.Resampling.LANCZOS)
            resized.save(OUTPUT_DIR / filename)
            print(f"✅ Salvata: {OUTPUT_DIR / filename}")
    
    # Genera le immagini per iOS (attualmente solo versione internazionale)
    print("\n📱 Generazione LaunchImage per iOS...")
    ios_launch_path = Path("../ios/Runner/Assets.xcassets/LaunchImage.imageset")
    
    # Per ora usiamo la versione internazionale come default per iOS
    # In futuro si può implementare la localizzazione iOS nativa
    generate_ios_launch_images(splash_international, ios_launch_path)
    print(f"✅ LaunchImage iOS generate in: {ios_launch_path.absolute()}")
    
    print("\n✨ Generazione completata!")
    print(f"\nImmagini Flutter generate in: {OUTPUT_DIR.absolute()}")
    print(f"LaunchImage iOS generate in: {ios_launch_path.absolute()}")
    print("\nUtilizzo:")
    print("  📱 Flutter (dinamico):")
    print("    - splash_italia.png → per utenti in Italia")
    print("    - splash_international.png → per utenti in altri paesi")
    print("  🍎 iOS (nativo):")
    print("    - LaunchImage → versione internazionale (default)")
    print("\n💡 Per localizzazione iOS nativa per paese, vedi README_SPLASH.md")

def main():
    try:
        # Verifica che il font esista
        if not Path(FONT_PATH).exists():
            print(f"⚠️  Font non trovato: {FONT_PATH}")
            print("Lo script proverà a usare font di sistema alternativi.")
        
        generate_splash_images()
        
    except Exception as e:
        print(f"❌ Errore durante la generazione: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()

