# BlueTrendTeam

Repository principale per il progetto BlueTrendTeam, una collaborazione tra diverse AI su un piano di parità.

## Punto di Ripresa del Lavoro

📅 **Data ultimo aggiornamento**: 24 aprile 2025, 09:03

📊 **Stato attuale del progetto**:
- Migrazione di tutte le cartelle AI nelle nuove strutture standardizzate
- Aggiunta dei pannelli UI da Panel MT5 alla cartella Include\AIWindsurf\panels
- Creazione del gestore messaggi Telegram (TelegramManager.mqh)

🔄

🔄 **Prossima attività**:
- Implementazione dettagliata del sistema di etichette "Buff XX" per l'identificazione visiva dei buffer
- Sviluppo di OmniEA Lite per renderlo vendibile su mql5.com entro fine settimana

🔍 **Contesto attuale**:
Stiamo lavorando all'implementazione del sistema BuffXXLabels.mqh per OmniEA Lite, che permetterà di visualizzare i valori dei buffer degli indicatori direttamente sul grafico.

## Progetti

- **OmniEA**: Expert Advisor per MetaTrader 5 che permette di combinare indicatori tecnici in strategie personalizzate
- **Argonaut**: Expert Advisor per il trading basato su gap con capacità di auto-apprendimento

## Struttura del Repository

- **docs/**: Documentazione del progetto
  - **core/**: Regole fondamentali, percorsi e stato del progetto
  - **projects/**: Documentazione di OmniEA e Argonaut
  - **tools/**: Strumenti per la collaborazione tra AI
  - **marketing/**: Strategie e analisi concorrenza
  - **scripts/**: Script di automazione per la collaborazione tra AI

- **src/**: Codice sorgente
  - **omniea/**: Codice sorgente di OmniEA
  - **argonaut/**: Codice sorgente di Argonaut
  - **common/**: Componenti comuni utilizzati da entrambi i progetti

## Struttura di Collaborazione

### Principio di Parità
Tutte le AI collaborano su un piano di parità senza gerarchie.

### Permessi di Accesso
1. **Lettura**: Tutte le AI possono leggere i file di tutte le altre AI
2. **Scrittura**: Ogni AI può scrivere SOLO nelle proprie cartelle e sui propri file

### Struttura Standardizzata
Ogni AI mantiene la stessa struttura di cartelle:
- Experts/[NomeAI]/OmniEA/ - Per gli Expert Advisor OmniEA
- Experts/[NomeAI]/Indicators/ - Per gli indicatori personalizzati
- Include/[NomeAI]/common/ - Per le utilità comuni
- Include/[NomeAI]/omniea/ - Per i file specifici di OmniEA
- Include/[NomeAI]/ui/ - Per i componenti dell'interfaccia utente
- Include/[NomeAI]/indicators/ - Per i file di supporto agli indicatori

## Procedura Operativa per la Continuità del Lavoro

### Setup con GitHub
- Repository GitHub pubblico "MQL5-Backup" con struttura completa MQL5
- Script di sincronizzazione automatica integrato nella dashboard
- README dettagliato che spiega la struttura e le convenzioni

### Flusso di Lavoro per Continuare un Progetto
1. **Accesso ai file**: Tramite la dashboard o il repository GitHub
2. **Copia selettiva**: Utilizzare gli script forniti per copiare i file necessari
3. **Adattamento**: Aggiornare i percorsi di inclusione nei file copiati

### Flusso di Lavoro per Correzione Errori
1. **Lettura del file problematico**: Tramite la dashboard o GitHub
2. **Copia selettiva**: Copiare solo il file specifico che necessita di correzione
3. **Correzione e test**: Proporre modifiche e testare la compilazione

## File e Script Importanti

- `C:\Users\Asus\CascadeProjects\BlueTrendTeam\BTT_Dashboard.html`: Dashboard principale
- `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\btt_dashboard_server.ps1`: Server web per la dashboard
- `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\auto_sync_github.ps1`: Script per la sincronizzazione GitHub
- `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\copy_ai_files.ps1`: Script per copiare file tra AI
- `C:\Users\Asus\BTT_Secure\github_config.json`: Configurazione del token GitHub

## Regole Fondamentali

Le Regole Fondamentali di BlueTrendTeam sono descritte nel documento [docs/core/regole_fondamentali.md](docs/core/regole_fondamentali.md).

---

*Ultimo aggiornamento: 24 aprile 2025, 09:03*


