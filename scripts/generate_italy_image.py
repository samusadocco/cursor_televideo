import geopandas as gpd
import matplotlib.pyplot as plt
import os

# Directory di output
output_dir = "../assets/images"
os.makedirs(output_dir, exist_ok=True)

# Carica il GeoJSON
regions = gpd.read_file('limits_IT_regions.geojson')

# Dimensioni dell'immagine
fig_size = (10, 10)
dpi = 51.2  # Per ottenere immagini 512x512

# Crea una nuova figura con sfondo trasparente
fig, ax = plt.subplots(figsize=fig_size)
fig.patch.set_alpha(0)
ax.patch.set_alpha(0)

# Plotta tutte le regioni con lo stesso colore
regions.plot(ax=ax,
            color='#2196F3B2',  # Blu con opacità 0.7
            edgecolor='black',
            linewidth=1)

# Rimuovi assi e bordi
ax.set_xticks([])
ax.set_yticks([])
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['bottom'].set_visible(False)
ax.spines['left'].set_visible(False)

# Adatta i limiti alla geometria dell'Italia intera
bounds = regions.total_bounds
ax.set_xlim(bounds[0], bounds[2])
ax.set_ylim(bounds[1], bounds[3])

# Mantieni le proporzioni
ax.set_aspect('equal')

# Salva l'immagine
output_file = os.path.join(output_dir, "italy.png")
plt.savefig(output_file,
            dpi=dpi,
            bbox_inches='tight',
            pad_inches=0.1,
            transparent=True)
plt.close()

print("Immagine dell'Italia generata con successo!") 