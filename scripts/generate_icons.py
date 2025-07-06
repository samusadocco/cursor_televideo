import requests
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance
import os

def download_televideo_image():
    # URL dell'immagine del Televideo
    url = "https://www.televideo.rai.it/televideo/pub/tt4web/Nazionale/16_9_page-100.png"
    
    # Scarica l'immagine
    response = requests.get(url)
    if response.status_code == 200:
        # Salva l'immagine temporaneamente
        with open("temp_televideo.png", "wb") as f:
            f.write(response.content)
        return True
    return False

def create_modern_icon():
    # Carica l'immagine del Televideo
    img = Image.open("temp_televideo.png").convert('RGBA')
    
    # Aumenta il contrasto
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.5)
    
    # Aumenta la luminosità
    enhancer = ImageEnhance.Brightness(img)
    img = enhancer.enhance(1.2)
    
    # Crea una nuova immagine quadrata con sfondo blu Televideo
    size = 1024
    icon = Image.new('RGBA', (size, size), (0, 0, 139, 255))  # Blu scuro
    
    # Calcola le dimensioni per mantenere l'aspect ratio
    ratio = img.size[0] / img.size[1]
    if ratio > 1:
        # Immagine più larga che alta
        new_width = int(size * 0.9)
        new_height = int(new_width / ratio)
    else:
        # Immagine più alta che larga
        new_height = int(size * 0.9)
        new_width = int(new_height * ratio)
    
    # Ridimensiona l'immagine del Televideo mantenendo le proporzioni
    img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Crea una maschera circolare
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, size, size), fill=255)
    
    # Applica un effetto di sfumatura ai bordi della maschera
    mask = mask.filter(ImageFilter.GaussianBlur(radius=5))
    
    # Posiziona l'immagine del Televideo al centro
    x = (size - img.size[0]) // 2
    y = (size - img.size[1]) // 2
    
    # Crea un'immagine composita
    icon.paste(img, (x, y))
    
    # Applica la maschera circolare
    icon.putalpha(mask)
    
    # Salva l'icona principale
    os.makedirs("assets/icon", exist_ok=True)
    icon.save("assets/icon/app_icon.png")
    
    # Crea una versione per l'icona adattiva di Android
    foreground = Image.new('RGBA', (size, size), (0, 0, 0, 0))  # Sfondo completamente trasparente
    
    # Per l'icona adattiva usiamo dimensioni leggermente più piccole
    if ratio > 1:
        new_width = int(size * 0.7)
        new_height = int(new_width / ratio)
    else:
        new_height = int(size * 0.7)
        new_width = int(new_height * ratio)
    
    img_resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    x = (size - new_width) // 2
    y = (size - new_height) // 2
    foreground.paste(img_resized, (x, y))
    foreground.save("assets/icon/app_icon_foreground.png")
    
    # Pulisci il file temporaneo
    os.remove("temp_televideo.png")

def main():
    print("Downloading Televideo image...")
    if download_televideo_image():
        print("Creating modern icons...")
        create_modern_icon()
        print("Icons generated successfully!")
    else:
        print("Failed to download Televideo image")

if __name__ == "__main__":
    main() 