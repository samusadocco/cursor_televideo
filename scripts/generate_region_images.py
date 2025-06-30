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
    "Friuli Venezia Giulia": "#42A5F5B2",
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
    return name.lower().replace(" ", "_").replace("-", "_").replace("'", "")

# Carica il GeoJSON
regions = gpd.read_file('limits_IT_regions.geojson')

# Dimensioni dell'immagine
fig_size = (10, 10)
dpi = 51.2  # Per ottenere immagini 512x512

for idx, row in regions.iterrows():
    region_name = str(row['reg_name'])
    if region_name not in colors:
        continue
        
    # Crea una nuova figura con sfondo trasparente
    fig, ax = plt.subplots(figsize=fig_size)
    fig.patch.set_alpha(0)
    ax.patch.set_alpha(0)
    
    # Estrai la regione corrente
    region = regions[regions['reg_name'] == region_name]
    
    # Plotta la regione
    region.plot(ax=ax,
                color=colors[region_name],
                edgecolor='black',
                linewidth=1)
    
    # Rimuovi assi e bordi
    ax.set_xticks([])
    ax.set_yticks([])
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    ax.spines['left'].set_visible(False)
    
    # Adatta i limiti alla geometria
    bounds = region.total_bounds
    ax.set_xlim(bounds[0], bounds[2])
    ax.set_ylim(bounds[1], bounds[3])
    
    # Mantieni le proporzioni
    ax.set_aspect('equal')
    
    # Salva l'immagine
    output_file = os.path.join(output_dir, f"{normalize_filename(region_name)}.png")
    plt.savefig(output_file,
                dpi=dpi,
                bbox_inches='tight',
                pad_inches=0.1,
                transparent=True)
    plt.close()

print("Immagini generate con successo!") 