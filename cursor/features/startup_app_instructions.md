Ciao. Voglio creare un app in Flutter.
Questa permette di visualizzare e navigare le immagini del Televideo RAI.

Setup Instructions:
- Devi creare una app seguendo i principi di flutter state management senza usare setState ma usare metodi più performanti come Bloc e cubit
- Devi creare un tema dark e light  che userai per i pulsanti, elementi e vari schermi
- La UI e UX devono essere belle  con gradevoli animazioni

Istruzioni per l' app:
- L' app deve permettere di scegliere tra Televideo Nazionale e Regionale. La scelta delle regioni deve essere fatta con un elenco dove le regioni presenti su Televideo riportano nome e immagine stilizzata della regione stessa 
- Si devono poter salvare le pagine preferite (pulsante a forma di più e cuore). 
- Si deve poter cambiare pagina digitando il numero della pagina stessa
- Se si esegue uno swipe verso sinistra ci si posizionerà alla pagina successiva. Se la pagina non esiste il programma cercherà la successiva
- Se si esegue uno swipe verso destra ci si posizionerà alla pagina precedente. Se la pagina non esiste il programma cercherà la successiva
- Per le pagine che hanno delle sottopagine uno swipe verso l' alto permetterà di scorrere sulla sottopagina successiva

Piano di Implementazione:
- [x] 1. Setup Iniziale
  - [ ] Configurazione del progetto Flutter
  - [ ] Implementazione dei temi dark/light
  - [ ] Setup delle dipendenze (bloc, http, shared_preferences, etc.)
  - [ ] Configurazione della struttura delle cartelle (features, shared, core)

- [x] 2. Implementazione Core
  - [ ] Creazione dei modelli dati (TelevideoPage, Region, Favorites)
  - [ ] Implementazione del repository per le chiamate API
  - [ ] Setup del BLoC/Cubit per la gestione dello stato
  - [ ] Implementazione della logica di navigazione delle pagine

- [x] 3. Feature: Selezione Televideo
  - [ ] UI per la selezione Nazionale/Regionale
  - [ ] Implementazione della lista delle regioni con immagini
  - [ ] BLoC/Cubit per la gestione della selezione
  - [ ] Animazioni di transizione

- [x] 4. Feature: Visualizzazione Pagina
  - [ ] UI per la visualizzazione della pagina Televideo
  - [ ] Implementazione della navigazione gesture-based
  - [ ] Gestione delle sottopagine
  - [ ] Input numerico per selezione diretta della pagina

- [x] 5. Feature: Gestione Preferiti
  - [ ] UI per aggiungere/rimuovere dai preferiti
  - [ ] Persistenza locale dei preferiti
  - [ ] BLoC/Cubit per la gestione dei preferiti
  - [ ] Lista delle pagine preferite

- [x] 6. UI/UX Enhancement
  - [ ] Implementazione delle animazioni di transizione
  - [ ] Ottimizzazione della responsività
  - [ ] Gestione degli errori e stati di caricamento
  - [ ] Testing e debugging

- [x] 7. Testing e Finalizzazione
  - [ ] Unit testing dei BLoC/Cubit
  - [ ] Widget testing delle componenti principali
  - [ ] Integration testing dei flussi principali
  - [ ] Ottimizzazione delle performance
