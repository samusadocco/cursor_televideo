import geopandas as gpd
import matplotlib.pyplot as plt
import os
from matplotlib.colors import to_rgba

# Directory di output
output_dir = "../assets/images/regions"
os.makedirs(output_dir, exist_ok=True)

# Colori per le regioni (con opacità 0.7)
colors = {
    "Abruzzo": "#2196F3B2",
    "Basilicata": "#1976D2B2",
    "Calabria": "#1565C0B2",
    "Campania": "#0D47A1B2",
    "Emilia-Romagna": "#64B5F6B2",
    "Friuli-Venezia Giulia": "#42A5F5B2",
    "Lazio": "#2196F3B2",
    "Liguria": "#1E88E5B2",
    "Lombardia": "#1976D2B2",
    "Marche": "#1565C0B2",
    "Molise": "#0D47A1B2",
    "Piemonte": "#82B1FFB2",
    "Puglia": "#448AFFB2",
    "Sardegna": "#2979FFB2",
    "Sicilia": "#2962FFB2",
    "Toscana": "#E3F2FDB2",
    "Trentino-Alto Adige": "#BBDEFBB2",
    "Umbria": "#90CAF9B2",
    "Valle d'Aosta": "#64B5F6B2",
    "Veneto": "#42A5F5B2"
}

def normalize_filename(name):
    """Normalizza il nome del file rimuovendo caratteri speciali e spazi"""
    # Mappa diretta per i nomi speciali
    special_names = {
        "Friuli-Venezia Giulia": "friuli_venezia_giulia",
        "Emilia-Romagna": "emilia_romagna",
        "Valle d'Aosta/Vallée d'Aoste": "valle_d_aosta",
        "Trentino-Alto Adige/Südtirol": "trentino_alto_adige"
    }
    
    # Se il nome è nella mappa speciale, usa quello
    if name in special_names:
        return special_names[name]
        
    # Altrimenti, normalizza il nome
    # Prima rimuovi la parte dopo lo slash se presente
    if "/" in name:
        name = name.split("/")[0].strip()
    return name.lower().replace(" ", "_").replace("-", "_").replace("'", "")

# Carica il GeoJSON
regions = gpd.read_file('limits_IT_regions.geojson')

# Stampa le colonne disponibili
print("Colonne disponibili nel GeoJSON:")
print(regions.columns)
print("\nNomi delle regioni:")
print(regions['reg_name'])

# Stampa i nomi dei file che verranno generati
print("\nNomi dei file che verranno generati:")
for name in regions['reg_name']:
    normalized = normalize_filename(name)
    print(f"{name} -> {normalized}.png")

# Dimensioni dell'immagine
fig_size = (10, 10)
dpi = 51.2  # Per ottenere immagini 512x512

# Per ogni regione
for idx, row in regions.iterrows():
    region_name = row['reg_name']
    filename = normalize_filename(region_name)
    
    # Crea una nuova figura
    fig, ax = plt.subplots(figsize=fig_size)
    
    # Crea un GeoDataFrame con solo la regione corrente
    region_gdf = gpd.GeoDataFrame(geometry=[row['geometry']])
    
    # Imposta i limiti della regione corrente
    bounds = row['geometry'].bounds
    ax.set_xlim(bounds[0], bounds[2])
    ax.set_ylim(bounds[1], bounds[3])
    
    # Disegna solo la regione corrente in blu semi-trasparente con bordo nero
    region_gdf.plot(ax=ax, facecolor='#2196F3B2', edgecolor='black')
    
    # Rimuovi assi e bordi
    ax.set_xticks([])
    ax.set_yticks([])
    for spine in ax.spines.values():
        spine.set_visible(False)
    
    # Salva l'immagine
    output_path = f'../assets/images/regions/{filename}.png'
    plt.savefig(output_path, dpi=dpi, bbox_inches='tight', pad_inches=0, transparent=True)
    plt.close()

print("Immagini generate con successo!") 