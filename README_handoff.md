# BlueTrendTeam - Handoff

Questo documento contiene le informazioni necessarie per continuare il lavoro sul progetto BlueTrendTeam, con particolare focus su OmniEA Lite.

## Stato Attuale del Progetto (22 aprile 2025)

📊 **Completato**:
- Migrazione di tutte le cartelle AI nelle nuove strutture standardizzate
- Aggiunta dei pannelli UI da Panel MT5 alla cartella Include\AIWindsurf\panels
- Creazione del gestore messaggi Telegram (TelegramManager.mqh)

🔄 **Prossima attività**:
- Implementazione dettagliata del sistema di etichette "Buff XX" per l'identificazione visiva dei buffer
- Sviluppo di OmniEA Lite per renderlo vendibile su mql5.com entro fine settimana

## Struttura del Progetto

### Repository GitHub

Repository principale per il progetto BlueTrendTeam, supervisionato da AI Windsurf.

#### Progetti

- **OmniEA**: Expert Advisor per MetaTrader 5 che permette di combinare indicatori tecnici in strategie personalizzate
- **Argonaut**: Expert Advisor per il trading basato su gap con capacità di auto-apprendimento

#### Struttura del Repository

- **docs/**: Documentazione del progetto
  - **core/**: Regole fondamentali, percorsi e stato del progetto
  - **projects/**: Documentazione di OmniEA e Argonaut
  - **tools/**: Strumenti per la collaborazione tra AI
  - **marketing/**: Strategie e analisi concorrenza
  - **scripts/**: Script di automazione

- **src/**: Codice sorgente
  - **omniea/**: Codice sorgente di OmniEA
  - **argonaut/**: Codice sorgente di Argonaut
  - **common/**: Componenti comuni utilizzati da entrambi i progetti

- **ai_*/**: Cartelle dedicate per ogni AI collaboratrice
  - **ai_AIWindsurf/**: Contributi di AI Windsurf (supervisore)

### Struttura MQL5

La struttura delle cartelle in MQL5 è stata standardizzata come segue:

- **Experts/**: Contiene gli Expert Advisor
  - **AIWindsurf/**: EA sviluppati da AIWindsurf
  - **AIChatGpt/**: EA sviluppati da AIChatGpt
  - **AIDeepSeek/**: EA sviluppati da AIDeepSeek
  - **AIGemini/**: EA sviluppati da AIGemini
  - **AIGrok/**: EA sviluppati da AIGrok

- **Include/**: Contiene le librerie e i file di inclusione
  - **AIWindsurf/**: Librerie sviluppate da AIWindsurf
    - **panels/**: Pannelli UI per migliorare l'interfaccia degli EA
  - **AIDeepSeek/**: Librerie sviluppate da AIDeepSeek
    - **BuffXXLabels.mqh**: Sistema per l'identificazione visiva dei buffer
    - **ReportGenerator.mqh**: Generatore di report per trading
  - **MyInclude/**: Librerie personalizzate esistenti
  - **MyLibrary/**: Librerie personalizzate esistenti

## Risorse Disponibili per OmniEA Lite

- **Pannelli UI**: Include\AIWindsurf\panels
- **Sistema BuffXXLabels**: Include\AIDeepSeek\BuffXXLabels.mqh
- **Generatore di report**: Include\AIDeepSeek\ReportGenerator.mqh
- **Librerie personalizzate**: MyInclude e MyLibrary
- **Gestore messaggi Telegram**: Include\AIWindsurf\TelegramManager.mqh

## Collaborazione tra AI

Questo repository implementa un sistema di collaborazione tra diverse AI, dove:

1. Ogni AI lavora sul proprio branch dedicato (`dev_[nome_ai]`)
2. Le modifiche vengono proposte tramite pull request
3. AI Windsurf revisiona e approva le modifiche, in conformità con la Regola Fondamentale #12 sulla supervisione

## Istruzioni per Continuare il Lavoro

### Per iniziare una nuova chat:
1. Carica questo file README_handoff.md nella nuova chat
2. Segui le istruzioni in questo documento per continuare il lavoro

### Se continui con un'altra AI:
1. Carica questo file README_handoff.md
2. L'AI troverà tutte le istruzioni necessarie per continuare il lavoro

### Se AI Windsurf finisce i token:
1. La supervisione passa ad un'altra AI (preferibilmente ChatGPT) oppure
2. Procedi senza supervisione, seguendo le Regole Fondamentali

## Regole Fondamentali

Le Regole Fondamentali di BlueTrendTeam sono descritte nel documento [docs/core/regole_fondamentali.md](docs/core/regole_fondamentali.md).

## Priorità per OmniEA Lite

Per completare OmniEA Lite e renderlo vendibile su mql5.com entro fine settimana, concentrarsi su:

1. Integrare uno dei pannelli UI per migliorare l'interfaccia utente
2. Completare l'implementazione del sistema BuffXXLabels per la visualizzazione dei buffer
3. Ottimizzare le prestazioni e la stabilità
4. Preparare la documentazione per la pubblicazione sul market

---

*Ultimo aggiornamento: 22 aprile 2025, 18:50*
