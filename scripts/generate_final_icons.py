import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance, ImageOps, ImageChops
from io import BytesIO
import requests
from pathlib import Path
import math
import random

# Configurazione esatta da generate_app_icons.py
BACKGROUND_IMAGE = "assets/images/televideo_100.png"  # Immagine della pagina 100 del Televideo
OUTPUT_DIR = "app_icons"
BLUR_RADIUS = 2  # Ridotto per mantenere più dettagli
TEXT_BLUR_RADIUS = 0.8  # Ridotto al minimo per mantenere i pixel netti
TEXT_COLOR = (0, 255, 80)  # Verde fosforescente tipico dei vecchi monitor
BACKGROUND_BRIGHTNESS = 0.3  # Ridotto ulteriormente per far risaltare di più il testo
BACKGROUND_SATURATION = 1.4  # Aumentato per colori più vividi
BACKGROUND_CONTRAST = 1.5  # Aumentato per far risaltare di più i dettagli
PIXEL_SIZE = 4  # Aumentato per pixel più evidenti
GLOW_COLOR = (0, 100, 0)  # Verde più scuro per il bagliore
GLOW_INTENSITY = 0.7  # Intensità del bagliore (0-1)

# Dimensioni delle icone richieste per le varie piattaforme
IOS_ICONS = [
    # iPhone Notification
    (20, "Icon-App-20x20@1x.png"),
    (40, "Icon-App-20x20@2x.png"),
    (60, "Icon-App-20x20@3x.png"),
    # iPhone Settings
    (29, "Icon-App-29x29@1x.png"),
    (58, "Icon-App-29x29@2x.png"),
    (87, "Icon-App-29x29@3x.png"),
    # iPhone Spotlight
    (40, "Icon-App-40x40@1x.png"),
    (80, "Icon-App-40x40@2x.png"),
    (120, "Icon-App-40x40@3x.png"),
    # iPhone App
    (120, "Icon-App-60x60@2x.png"),
    (180, "Icon-App-60x60@3x.png"),
    # iPad App
    (76, "Icon-App-76x76@1x.png"),
    (152, "Icon-App-76x76@2x.png"),
    # iPad Pro App
    (167, "Icon-App-83.5x83.5@2x.png"),
    # App Store
    (1024, "Icon-App-1024x1024@1x.png"),
    # Legacy sizes
    (50, "Icon-App-50x50@1x.png"),
    (100, "Icon-App-50x50@2x.png"),
    (57, "Icon-App-57x57@1x.png"),
    (114, "Icon-App-57x57@2x.png"),
    (72, "Icon-App-72x72@1x.png"),
    (144, "Icon-App-72x72@2x.png"),
    # Alternative naming
    (20, "icon_20@1x.png"),
    (29, "icon_29@1x.png"),
    (40, "icon_40@1x.png"),
    (40, "icon_40@2x.png"),
    (58, "icon_58@2x.png"),
    (60, "icon_60@3x.png"),
    (76, "icon_76@1x.png"),
    (80, "icon_80@2x.png"),
    (87, "icon_87@3x.png"),
    (120, "icon_120@2x.png"),
    (120, "icon_120@3x.png"),
    (152, "icon_152@2x.png"),
    (167, "icon_167@2x.png"),
    (180, "icon_180@3x.png"),
    (1024, "icon_1024@1x.png"),
]

ANDROID_ICONS = [
    (48, "mipmap-mdpi/ic_launcher.png"),
    (72, "mipmap-hdpi/ic_launcher.png"),
    (96, "mipmap-xhdpi/ic_launcher.png"),
    (144, "mipmap-xxhdpi/ic_launcher.png"),
    (192, "mipmap-xxxhdpi/ic_launcher.png"),
]

MACOS_ICONS = [
    (16, "app_icon_16.png"),
    (32, "app_icon_32.png"),
    (64, "app_icon_64.png"),
    (128, "app_icon_128.png"),
    (256, "app_icon_256.png"),
    (512, "app_icon_512.png"),
    (1024, "app_icon_1024.png"),
]

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

def pixelate(image, pixel_size):
    """Applica un effetto di pixelatura all'immagine"""
    # Assicurati che le dimensioni siano divisibili per pixel_size
    new_width = (image.width // pixel_size) * pixel_size
    new_height = (image.height // pixel_size) * pixel_size
    
    # Ridimensiona l'immagine per creare l'effetto pixel
    small = image.resize((new_width // pixel_size, new_height // pixel_size), Image.Resampling.NEAREST)
    result = small.resize((new_width, new_height), Image.Resampling.NEAREST)
    
    # Ridimensiona al formato originale mantenendo l'effetto pixel
    if result.size != image.size:
        result = result.resize(image.size, Image.Resampling.NEAREST)
    
    return result

def create_scanlines(image, line_height=2):
    """Aggiunge l'effetto scanlines tipico dei vecchi monitor"""
    result = image.copy()
    pixels = result.load()
    for y in range(0, image.height, line_height * 2):
        for x in range(image.width):
            for l in range(line_height):
                if y + l < image.height:
                    if isinstance(pixels[x, y + l], int):
                        pixels[x, y + l] = int(pixels[x, y + l] * 0.7)
                    else:
                        r, g, b = pixels[x, y + l][:3]
                        if len(pixels[x, y + l]) > 3:
                            a = pixels[x, y + l][3]
                            pixels[x, y + l] = (int(r * 0.7), int(g * 0.7), int(b * 0.7), a)
                        else:
                            pixels[x, y + l] = (int(r * 0.7), int(g * 0.7), int(b * 0.7))
    return result

def create_base_icon(size, background_image):
    """Crea l'icona base con lo sfondo sfocato"""
    # Converti in RGBA
    background_image = background_image.convert('RGBA')
    
    # Aumenta il contrasto
    enhancer = ImageEnhance.Contrast(background_image)
    background_image = enhancer.enhance(BACKGROUND_CONTRAST)
    
    # Ridimensiona e ritaglia l'immagine di sfondo
    aspect_ratio = background_image.width / background_image.height
    if aspect_ratio > 1:
        new_width = int(size * aspect_ratio)
        new_height = size
    else:
        new_width = size
        new_height = int(size / aspect_ratio)
    
    resized = background_image.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Ritaglia al centro
    left = (resized.width - size) // 2
    top = (resized.height - size) // 2
    cropped = resized.crop((left, top, left + size, top + size))
    
    # Applica sfocatura
    blurred = cropped.filter(ImageFilter.GaussianBlur(BLUR_RADIUS))
    
    # Regola saturazione
    enhancer = ImageEnhance.Color(blurred)
    enhanced = enhancer.enhance(BACKGROUND_SATURATION)
    
    # Regola luminosità
    darkener = ImageEnhance.Brightness(enhanced)
    darkened = darkener.enhance(BACKGROUND_BRIGHTNESS)
    
    return darkened

def create_glow_effect(image, glow_color=GLOW_COLOR, blur_radius=8):
    """Crea un effetto di bagliore intorno al testo"""
    # Crea una maschera dal canale alpha
    mask = Image.new('L', image.size, 0)
    mask.paste(image.split()[3], (0, 0))
    
    # Applica sfocatura alla maschera
    glowing = mask.filter(ImageFilter.GaussianBlur(blur_radius))
    
    # Crea l'immagine del bagliore
    glow = Image.new('RGBA', image.size, (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    
    # Usa la maschera sfocata per disegnare il bagliore
    for x in range(image.width):
        for y in range(image.height):
            alpha = int(glowing.getpixel((x, y)) * GLOW_INTENSITY)
            if alpha > 0:
                glow_draw.point((x, y), (*glow_color, alpha))
    
    return glow

def add_text(image, text="100"):
    """Aggiunge il testo sfocato all'immagine con effetto bagliore"""
    # Crea un'immagine temporanea per il testo
    txt = Image.new('RGBA', image.size, (255, 255, 255, 0))
    draw = ImageDraw.Draw(txt)
    
    # Calcola la dimensione del font
    font_size = int(image.width * 0.45)  # Ridotto leggermente per bilanciare la nuova posizione
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", font_size)
        except:
            font = ImageFont.load_default()
    
    # Calcola le dimensioni del testo
    text_width = draw.textlength(text, font=font)
    text_height = font_size
    
    # Posiziona il testo in basso a destra con un margine del 10%
    margin = int(image.width * 0.10)
    x = image.width - text_width - margin
    y = image.height - text_height - margin
    
    # Disegna il testo
    draw.text((x, y), text, font=font, fill=TEXT_COLOR)
    
    # Applica effetto pixelato
    txt = pixelate(txt, PIXEL_SIZE)
    
    # Applica una leggera sfocatura per ammorbidire i pixel
    txt = txt.filter(ImageFilter.GaussianBlur(TEXT_BLUR_RADIUS))
    
    # Aggiungi scanlines
    txt = create_scanlines(txt)
    
    # Crea l'effetto bagliore
    glow = create_glow_effect(txt)
    
    # Combina le immagini: sfondo + bagliore + testo
    result = Image.alpha_composite(image, glow)
    result = Image.alpha_composite(result, txt)
    
    return result

def create_launch_screen_image(size=1024):
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
    
    # Crea il testo "TeleRetrò" in stile pixel
    text_size = int(screen_size * 0.1)
    try:
        font = ImageFont.truetype("scripts/fonts/VT323-Regular.ttf", text_size)
    except:
        font = ImageFont.load_default()
    
    # Calcola la posizione del testo per centrarlo
    text = "TeleRetrò\n  Italia"
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

def generate_ios_icons(background):
    """Genera le icone per iOS"""
    print("\nGenerazione icone per iOS...")
    for size, filename in IOS_ICONS:
        print(f"Generazione icona {filename}")
        icon = create_base_icon(size, background)
        icon_with_text = add_text(icon)
        icon_with_text.save(f"ios/Runner/Assets.xcassets/AppIcon.appiconset/{filename}")

def generate_android_icons(background):
    """Genera le icone per Android"""
    print("\nGenerazione icone per Android...")
    for size, filename in ANDROID_ICONS:
        print(f"Generazione icona {filename}")
        icon = create_base_icon(size, background)
        icon_with_text = add_text(icon)
        icon_with_text.save(f"android/app/src/main/res/{filename}")

def generate_macos_icons(background):
    """Genera le icone per macOS"""
    print("\nGenerazione icone per macOS...")
    for size, filename in MACOS_ICONS:
        print(f"Generazione icona {filename}")
        icon = create_base_icon(size, background)
        icon_with_text = add_text(icon)
        icon_with_text.save(f"macos/Runner/Assets.xcassets/AppIcon.appiconset/{filename}")

def generate_android_launch_images(base_image):
    """Genera le immagini di avvio per Android"""
    densities = {
        'mdpi': 320,    # 1x
        'hdpi': 480,    # 1.5x
        'xhdpi': 640,   # 2x
        'xxhdpi': 960,  # 3x
        'xxxhdpi': 1280 # 4x
    }
    
    for density, size in densities.items():
        resized = base_image.resize((size, size), Image.Resampling.LANCZOS)
        folder_path = f'android/app/src/main/res/drawable-{density}'
        os.makedirs(folder_path, exist_ok=True)
        resized.save(os.path.join(folder_path, 'launch_image.png'))

def generate_ios_launch_images(base_image):
    """Genera le immagini di avvio per iOS"""
    # Dimensioni per i vari dispositivi iOS
    ios_launch_sizes = {
        # iPhone
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
    
    launch_path = 'ios/Runner/Assets.xcassets/LaunchImage.imageset'
    os.makedirs(launch_path, exist_ok=True)
    
    for filename, (width, height) in ios_launch_sizes.items():
        # Ridimensiona mantenendo l'aspect ratio e centrando
        aspect = width / height
        if aspect > 1:
            new_width = width
            new_height = int(width / aspect)
        else:
            new_height = height
            new_width = int(height * aspect)
            
        resized = base_image.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # Crea un'immagine nera delle dimensioni target
        final = Image.new('RGB', (width, height), 'black')
        
        # Centra l'immagine ridimensionata
        paste_x = (width - new_width) // 2
        paste_y = (height - new_height) // 2
        final.paste(resized, (paste_x, paste_y))
        
        final.save(os.path.join(launch_path, filename))

def main():
    try:
        # Crea la directory fonts se non esiste
        fonts_dir = Path("scripts/fonts")
        fonts_dir.mkdir(parents=True, exist_ok=True)
        
        # Scarica il font VT323 se non esiste
        font_path = fonts_dir / "VT323-Regular.ttf"
        if not font_path.exists():
            print("Downloading VT323 font...")
            font_url = "https://github.com/phoikoi/VT323/raw/master/fonts/ttf/VT323-Regular.ttf"
            response = requests.get(font_url)
            font_path.write_bytes(response.content)
        
        # Carica l'immagine di sfondo
        print("Loading background image...")
        background = Image.open(BACKGROUND_IMAGE)
        
        # Genera le icone per tutte le piattaforme
        print("\nGenerazione icone per iOS...")
        generate_ios_icons(background)
        
        print("\nGenerazione icone per Android...")
        generate_android_icons(background)
        
        print("\nGenerazione icone per macOS...")
        generate_macos_icons(background)
        
        # Genera le immagini di avvio
        print("\nGenerazione immagini di avvio...")
        launch_image = create_launch_screen_image(1024)
        generate_android_launch_images(launch_image)
        generate_ios_launch_images(launch_image)
        
        print("\nGenerazione icone e immagini di avvio completata!")
        
    except Exception as e:
        print(f"Errore durante la generazione delle icone: {e}")

if __name__ == "__main__":
    main()