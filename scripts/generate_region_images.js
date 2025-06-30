import fs from 'fs';
import path from 'path';
import * as d3 from 'd3';
import * as topojson from 'topojson-client';
import { createCanvas } from 'canvas';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Configurazione
const width = 512;
const height = 512;
const regionColor = '#2196F3'; // Blu material design
const strokeColor = '#000000';
const strokeWidth = 1;

// Crea la directory di output se non esiste
const outputDir = path.join(__dirname, '../assets/images/regions');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Funzione per generare l'immagine di una regione
async function generateRegionImage(regionName, geoData) {
  // Crea un canvas
  const canvas = createCanvas(width, height);
  const context = canvas.getContext('2d');

  // Pulisci il canvas con sfondo trasparente
  context.clearRect(0, 0, width, height);

  // Configura il path D3
  const projection = d3.geoMercator()
    .fitSize([width - strokeWidth * 2, height - strokeWidth * 2], geoData);
  
  const path = d3.geoPath()
    .projection(projection)
    .context(context);

  // Disegna la regione
  context.translate(strokeWidth, strokeWidth);
  context.beginPath();
  path(geoData);
  context.fillStyle = regionColor;
  context.fill();
  context.strokeStyle = strokeColor;
  context.lineWidth = strokeWidth;
  context.stroke();

  // Salva l'immagine come PNG
  const buffer = canvas.toBuffer('image/png');
  const outputPath = path.join(outputDir, `${regionName.toLowerCase().replace(/ /g, '_')}.png`);
  fs.writeFileSync(outputPath, buffer);
  
  console.log(`Generated ${outputPath}`);
}

// Mappa dei nomi delle regioni dal file TopoJSON ai nomi che vogliamo usare
const regionNameMap = {
  'Piemonte': 'Piemonte',
  'Valle d\'Aosta': 'Valle d\'Aosta',
  'Lombardia': 'Lombardia',
  'Trentino-Alto Adige': 'Trentino Alto Adige',
  'Veneto': 'Veneto',
  'Friuli-Venezia Giulia': 'Friuli Venezia Giulia',
  'Liguria': 'Liguria',
  'Emilia-Romagna': 'Emilia Romagna',
  'Toscana': 'Toscana',
  'Umbria': 'Umbria',
  'Marche': 'Marche',
  'Lazio': 'Lazio',
  'Abruzzo': 'Abruzzo',
  'Molise': 'Molise',
  'Campania': 'Campania',
  'Puglia': 'Puglia',
  'Basilicata': 'Basilicata',
  'Calabria': 'Calabria',
  'Sicilia': 'Sicilia',
  'Sardegna': 'Sardegna'
};

// Genera le immagini per tutte le regioni
async function generateAllImages() {
  try {
    // Carica il file TopoJSON dell'Italia
    const italyData = JSON.parse(fs.readFileSync(path.join(__dirname, 'italy_reg.json'), 'utf8'));
    
    // Estrai tutte le regioni dal TopoJSON
    const regions = topojson.feature(italyData, italyData.objects.regions);
    
    for (const region of regions.features) {
      const topoJsonName = region.properties.REGIONE;
      const regionName = regionNameMap[topoJsonName];
      
      if (!regionName) {
        console.warn(`Warning: No mapping found for region "${topoJsonName}"`);
        continue;
      }

      // Crea un FeatureCollection con solo questa regione
      const regionFeature = {
        type: "FeatureCollection",
        features: [region]
      };

      await generateRegionImage(regionName, regionFeature);
    }
    
    console.log('All region images generated successfully!');
  } catch (error) {
    console.error('Error generating images:', error);
  }
}

generateAllImages(); 