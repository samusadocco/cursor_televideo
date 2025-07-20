import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance, ImageOps
from io import BytesIO

# Configurazione
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
                        r, g, b, a = pixels[x, y + l]
                        pixels[x, y + l] = (int(r * 0.7), int(g * 0.7), int(b * 0.7), a)
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

def generate_icons():
    """Genera tutte le icone nelle dimensioni richieste"""
    try:
        # Carica l'immagine di sfondo
        background = Image.open(BACKGROUND_IMAGE)
        
        # Crea le directory di output
        os.makedirs("ios/Runner/Assets.xcassets/AppIcon.appiconset", exist_ok=True)
        for size, filename in ANDROID_ICONS:
            os.makedirs(f"android/app/src/main/res/{os.path.dirname(filename)}", exist_ok=True)
        os.makedirs("macos/Runner/Assets.xcassets/AppIcon.appiconset", exist_ok=True)
        
        # Genera icone iOS
        print("\nGenerazione icone per iOS...")
        for size, filename in IOS_ICONS:
            print(f"Generazione icona {filename}")
            icon = create_base_icon(size, background)
            icon_with_text = add_text(icon)
            icon_with_text.save(f"ios/Runner/Assets.xcassets/AppIcon.appiconset/{filename}")
        
        # Genera icone Android
        print("\nGenerazione icone per Android...")
        for size, filename in ANDROID_ICONS:
            print(f"Generazione icona {filename}")
            icon = create_base_icon(size, background)
            icon_with_text = add_text(icon)
            icon_with_text.save(f"android/app/src/main/res/{filename}")
        
        # Genera icone macOS
        print("\nGenerazione icone per macOS...")
        for size, filename in MACOS_ICONS:
            print(f"Generazione icona {filename}")
            icon = create_base_icon(size, background)
            icon_with_text = add_text(icon)
            icon_with_text.save(f"macos/Runner/Assets.xcassets/AppIcon.appiconset/{filename}")
        
        print("\nGenerazione icone completata!")
        
    except Exception as e:
        print(f"Errore durante la generazione delle icone: {e}")

if __name__ == "__main__":
    generate_icons() 