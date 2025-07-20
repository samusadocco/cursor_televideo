from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance, ImageChops
import os
from pathlib import Path
import math
import random

def create_crt_distortion(image, intensity=0.3):
    # Crea una distorsione barrel tipica dei CRT
    width, height = image.size
    
    # Crea una nuova immagine per la distorsione
    distorted = Image.new('RGB', (width, height))
    
    for x in range(width):
        for y in range(height):
            # Calcola la distanza dal centro normalizzata
            nx = (2 * x - width) / width
            ny = (2 * y - height) / height
            r = math.sqrt(nx * nx + ny * ny)
            
            # Applica la distorsione barrel
            if r < 1:
                # Aumenta l'effetto barrel
                theta = math.atan2(ny, nx)
                r2 = r * (1 + intensity * r * r)
                
                # Converti di nuovo in coordinate cartesiane
                sx = width * (r2 * math.cos(theta) + 1) / 2
                sy = height * (r2 * math.sin(theta) + 1) / 2
                
                # Assicurati che le coordinate siano valide
                if 0 <= sx < width and 0 <= sy < height:
                    distorted.putpixel((x, y), image.getpixel((int(sx), int(sy))))
                else:
                    distorted.putpixel((x, y), (0, 0, 0))
            else:
                distorted.putpixel((x, y), (0, 0, 0))
    
    return distorted

def add_chromatic_aberration(image, offset=3):
    # Separa i canali RGB
    r, g, b = image.split()
    
    # Sposta leggermente il canale rosso e blu
    r = ImageChops.offset(r, offset, 0)
    b = ImageChops.offset(b, -offset, 0)
    
    # Ricombina i canali
    return Image.merge('RGB', (r, g, b))

def add_noise(image, intensity=10):
    # Aggiungi rumore casuale all'immagine
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

def create_base_icon(size=1024):
    # Crea un'immagine quadrata con sfondo nero
    image = Image.new('RGB', (size, size), 'black')
    draw = ImageDraw.Draw(image)
    
    # Crea l'effetto CRT (bordo più pronunciato)
    margin = size // 15  # Bordo più spesso
    screen_size = size - (2 * margin)
    
    # Crea un bordo sfumato per simulare la plastica del monitor
    for i in range(margin):
        color = int(40 * (1 - i/margin))  # Sfumatura da grigio scuro a nero
        draw.rectangle(
            [(i, i), (size-i-1, size-i-1)],
            outline=f'#{color:02x}{color:02x}{color:02x}'
        )
    
    # Crea il testo "100" in stile pixel
    text_size = int(screen_size * 0.6)
    try:
        font = ImageFont.truetype("scripts/fonts/VT323-Regular.ttf", text_size)
    except:
        font = ImageFont.load_default()
    
    # Calcola la posizione del testo per centrarlo
    text = "100"
    text_bbox = draw.textbbox((0, 0), text, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]
    text_x = (size - text_width) // 2
    text_y = (size - text_height) // 2
    
    # Disegna il testo principale in verde televideo più brillante
    draw.text((text_x, text_y), text, font=font, fill='#50ff50')
    
    # Aggiungi un bagliore più intenso al testo
    glow = image.copy()
    # Applica più passaggi di blur per un bagliore più realistico
    for _ in range(3):
        glow = glow.filter(ImageFilter.GaussianBlur(size // 30))
    enhancer = ImageEnhance.Brightness(glow)
    glow = enhancer.enhance(2.0)  # Aumenta l'intensità del bagliore
    
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

def generate_ios_icons(base_icon):
    ios_sizes = {
        'Icon-App-20x20@1x.png': 20,
        'Icon-App-20x20@2x.png': 40,
        'Icon-App-20x20@3x.png': 60,
        'Icon-App-29x29@1x.png': 29,
        'Icon-App-29x29@2x.png': 58,
        'Icon-App-29x29@3x.png': 87,
        'Icon-App-40x40@1x.png': 40,
        'Icon-App-40x40@2x.png': 80,
        'Icon-App-40x40@3x.png': 120,
        'Icon-App-60x60@2x.png': 120,
        'Icon-App-60x60@3x.png': 180,
        'Icon-App-76x76@1x.png': 76,
        'Icon-App-76x76@2x.png': 152,
        'Icon-App-83.5x83.5@2x.png': 167,
        'Icon-App-1024x1024@1x.png': 1024,
    }
    
    ios_path = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    if not os.path.exists(ios_path):
        os.makedirs(ios_path)
    
    for name, size in ios_sizes.items():
        resized = base_icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(ios_path, name))

def generate_android_icons(base_icon):
    android_sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }
    
    for folder, size in android_sizes.items():
        folder_path = f'android/app/src/main/res/{folder}'
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
        
        resized = base_icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(folder_path, 'ic_launcher.png'))

def generate_macos_icons(base_icon):
    macos_sizes = {
        'app_icon_16.png': 16,
        'app_icon_32.png': 32,
        'app_icon_64.png': 64,
        'app_icon_128.png': 128,
        'app_icon_256.png': 256,
        'app_icon_512.png': 512,
        'app_icon_1024.png': 1024,
    }
    
    macos_path = 'macos/Runner/Assets.xcassets/AppIcon.appiconset'
    if not os.path.exists(macos_path):
        os.makedirs(macos_path)
    
    for name, size in macos_sizes.items():
        resized = base_icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(macos_path, name))

def main():
    # Crea la directory fonts se non esiste
    fonts_dir = Path("scripts/fonts")
    fonts_dir.mkdir(parents=True, exist_ok=True)
    
    # Scarica il font VT323 se non esiste
    font_path = fonts_dir / "VT323-Regular.ttf"
    if not font_path.exists():
        import requests
        font_url = "https://github.com/phoikoi/VT323/raw/master/fonts/ttf/VT323-Regular.ttf"
        response = requests.get(font_url)
        font_path.write_bytes(response.content)
    
    # Genera l'icona base
    base_icon = create_base_icon(1024)
    
    # Genera le icone per tutte le piattaforme
    generate_ios_icons(base_icon)
    generate_android_icons(base_icon)
    generate_macos_icons(base_icon)
    
    print("Icone generate con successo!")

if __name__ == "__main__":
    main() 