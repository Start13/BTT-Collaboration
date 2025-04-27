# PROGETTO OMNIEA - DOCUMENTAZIONE COMPLETA
*Ultimo aggiornamento: 27 aprile 2025, 12:40*

## PANORAMICA DEL PROGETTO

OmniEA è un Expert Advisor avanzato per MetaTrader 5 sviluppato da BlueTrendTeam. Il progetto prevede tre versioni:

1. **OmniEA Ultimate** - Versione completa con tutte le funzionalità (attualmente in sviluppo)
2. **OmniEA Pro** - Versione intermedia con funzionalità selezionate (pianificata)
3. **OmniEA Lite** - Versione base con funzionalità essenziali (pianificata)

> **NOTA IMPORTANTE**: Attualmente stiamo lavorando sulla versione Ultimate, anche se i nomi dei file fanno riferimento alla versione Lite. Questa discrepanza verrà risolta in seguito.

## STRUTTURA DEL PROGETTO

### Directory principali
- **Directory principale MQL5**: `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5`
- **Expert Advisor**: `MQL5\Experts\AIWindsurf\OmniEA\OmniEA_Lite.mq5`
- **Include principali**: `MQL5\Include\AIWindsurf\omniea\` e `MQL5\Include\AIWindsurf\ui\`
- **Editor MetaEditor64**: `C:\Program Files\RoboForex MT5 Terminal2\MetaEditor64.exe`

### Componenti principali
1. **SlotManager** - Gestisce gli slot degli indicatori per le strategie di trading
2. **PanelManager** - Gestisce l'interfaccia utente dell'EA
3. **PresetManager** - Gestisce il salvataggio e il caricamento dei preset
4. **ReportGenerator** - Genera report sulle performance di trading
5. **DragDropManager** - Gestisce le funzionalità di drag-and-drop nell'interfaccia
6. **LocalizationManager** - Gestisce il supporto multilingua dell'interfaccia
7. **WFOManager** - Gestisce l'ottimizzazione Walk Forward

### Interfaccia utente
L'interfaccia di OmniEA è composta da tre pannelli:

1. **Pannello Grande (Ultimate)**
   - Pannello completo con tutte le funzionalità
   - Dimensioni: 800x600 pixel
   - Componenti:
     - Slot per indicatori di acquisto (fino a 10)
     - Slot per indicatori di vendita (fino a 10)
     - Slot per filtri (fino a 5)
     - Configurazione completa del money management
     - Configurazione del trailing stop e break-even
     - Gestione preset completa
     - Statistiche di trading dettagliate
     - Configurazione WFO
     - Supporto drag-and-drop per gli indicatori
     - Selezione della lingua

2. **Pannello Medio (Pro)**
   - Versione ridotta con funzionalità selezionate
   - Dimensioni: 600x400 pixel
   - Componenti:
     - Slot per indicatori di acquisto (fino a 5)
     - Slot per indicatori di vendita (fino a 5)
     - Slot per filtri (fino a 3)
     - Configurazione base del money management
     - Gestione preset semplificata
     - Statistiche di trading essenziali

3. **Pannello Piccolo (Lite)**
   - Versione minima con funzionalità essenziali
   - Dimensioni: 400x300 pixel
   - Componenti:
     - Slot per indicatori di acquisto (fino a 3)
     - Slot per indicatori di vendita (fino a 3)
     - Slot per filtri (fino a 1)
     - Configurazione minima del money management
     - Preset predefiniti non modificabili

## STATO ATTUALE DEL PROGETTO

### Funzionalità implementate
- ✅ Sistema di gestione degli slot degli indicatori
- ✅ Interfaccia utente base con pannello principale
- ✅ Sistema di gestione dei preset (recentemente risolto)
- ✅ Sistema di reporting delle performance
- ✅ Logica di trading di base
- ✅ Sistema Drag&Drop di base per gli indicatori
- ✅ Supporto multilingua parziale (italiano e inglese)

### Problemi risolti recentemente
1. **Problema del PresetManager**:
   - Risolto problema critico che impediva il caricamento dell'EA sui grafici
   - Implementato un sistema di gestione preset più robusto basato su file TXT
   - Aggiunto sistema di fallback per le directory
   - Rimosso l'uso della classe CJAVal che causava errori di compilazione

2. **Problema di visualizzazione del pannello**:
   - Corretto l'ordine di inizializzazione in OnInit()
   - Aggiunto il collegamento corretto tra i gestori
   - Risolti i problemi di riferimenti circolari

### Problemi attuali
1. **Interfaccia utente**:
   - Difetti grafici nell'interfaccia (mancano alcuni pulsanti)
   - I pulsanti esistenti non funzionano correttamente

2. **Integrazione Walk Forward Optimizer (WFO)**:
   - In corso: Integrazione UI del Walk Forward Optimizer
   - In corso: Implementazione della logica WFO

## FUNZIONALITÀ DETTAGLIATE

### 1. Sistema Drag&Drop
Il sistema Drag&Drop di OmniEA consente agli utenti di trascinare gli indicatori direttamente dalla finestra "Navigator" di MetaTrader 5 agli slot dell'EA. Questo semplifica notevolmente la configurazione delle strategie di trading.

**Implementazione**:
- La classe `CDragDropManager` gestisce gli eventi di drag&drop
- Intercetta gli eventi `CHARTEVENT_DRAG_START` e `CHARTEVENT_DRAG_END`
- Identifica il tipo di indicatore trascinato
- Assegna l'indicatore allo slot appropriato in base alla posizione di rilascio
- Aggiorna automaticamente la configurazione dello slot

**Flusso di lavoro**:
1. L'utente trascina un indicatore dalla finestra Navigator
2. Il DragDropManager rileva l'evento e identifica l'indicatore
3. L'indicatore viene assegnato allo slot appropriato
4. La configurazione dello slot viene aggiornata con i parametri predefiniti dell'indicatore
5. L'utente può quindi personalizzare i parametri dell'indicatore

**Stato attuale**:
- Implementazione di base completata
- Supporto per i principali tipi di indicatori
- Da migliorare: gestione degli errori e feedback visivo

### 2. Aggregazione dei dati degli indicatori
OmniEA aggrega i dati degli indicatori per consentire all'utente di utilizzarli nei backtest e nell'ottimizzazione. Questo è un aspetto fondamentale per la valutazione delle strategie di trading.

**Processo di aggregazione**:
1. **Raccolta dati**: Gli indicatori assegnati agli slot forniscono i loro valori ad ogni tick
2. **Normalizzazione**: I valori vengono normalizzati per consentire confronti tra indicatori diversi
3. **Applicazione delle condizioni**: Le condizioni configurate dall'utente vengono applicate ai valori normalizzati
4. **Generazione dei segnali**: In base alle condizioni, vengono generati segnali di acquisto, vendita o filtro
5. **Registrazione**: I dati vengono registrati per l'analisi nei backtest

**Utilizzo nei backtest**:
- I dati aggregati vengono salvati in un formato compatibile con il tester di strategia di MT5
- Durante i backtest, l'EA carica questi dati e simula le decisioni di trading
- I risultati vengono visualizzati nel report di backtest standard di MT5
- Statistiche aggiuntive vengono generate dal ReportGenerator di OmniEA

**Utilizzo nell'ottimizzazione**:
- L'utente può selezionare quali parametri ottimizzare
- Il WFOManager divide i dati in periodi di training e testing
- I parametri vengono ottimizzati sui dati di training
- I risultati vengono validati sui dati di testing
- Il processo viene ripetuto per diversi periodi per garantire la robustezza della strategia

### 3. Sistema di preset delle configurazioni
Il sistema di preset consente agli utenti di salvare e caricare configurazioni complete dell'EA, facilitando il passaggio tra diverse strategie di trading.

**Struttura dei preset**:
```
Preset
├── Nome
├── Descrizione
├── Autore
├── Versione
├── Data creazione
├── Data modifica
├── Simbolo
├── Parametri di money management
│   ├── Rischio percentuale
│   ├── Stop loss
│   ├── Take profit
│   ├── Break-even
│   └── Trailing stop
├── Slot indicatori acquisto
├── Slot indicatori vendita
├── Slot filtri
└── Parametri aggiuntivi
```

**Funzionalità**:
- Salvataggio preset: L'utente può salvare la configurazione corrente con un nome personalizzato
- Caricamento preset: L'utente può caricare una configurazione salvata
- Preset predefiniti: L'EA include alcuni preset predefiniti per strategie comuni
- Importazione/Esportazione: L'utente può importare/esportare preset per condividerli

**Implementazione tecnica**:
- I preset vengono salvati come file TXT nella cartella `MQL5\Files\OmniEA\Presets`
- Il formato è stato semplificato per garantire la massima compatibilità
- Un sistema di fallback garantisce il funzionamento anche in caso di problemi di permessi

### 4. Supporto multilingua
OmniEA supporta più lingue per rendere l'EA accessibile a un pubblico internazionale.

**Lingue supportate**:
- Italiano (predefinito)
- Inglese
- Spagnolo (pianificato)
- Russo (pianificato)
- Cinese (pianificato)

**Implementazione**:
- La classe `CLocalizationManager` gestisce le traduzioni
- I testi sono memorizzati in file di risorse separati per ogni lingua
- L'utente può selezionare la lingua dall'interfaccia
- La lingua viene salvata nelle impostazioni e caricata all'avvio

**Struttura delle traduzioni**:
```cpp
// Esempio di implementazione delle traduzioni
string GetLocalizedText(string key, int languageId = 0)
{
   string translations[][2] = {
      // Italiano
      {"buy", "Acquisto"},
      {"sell", "Vendita"},
      {"filter", "Filtro"},
      // Inglese
      {"buy", "Buy"},
      {"sell", "Sell"},
      {"filter", "Filter"},
      // Altre lingue...
   };
   
   // Logica per selezionare la traduzione corretta
   return translatedText;
}
```

### 5. Walk Forward Optimizer (WFO)
Il Walk Forward Optimizer è un sistema avanzato per ottimizzare i parametri di trading in modo robusto, evitando l'overfitting.

**Principio di funzionamento**:
1. I dati storici vengono divisi in segmenti consecutivi
2. Per ogni segmento:
   - I parametri vengono ottimizzati sulla parte "in-sample" (IS)
   - I parametri ottimizzati vengono testati sulla parte "out-of-sample" (OOS)
3. I risultati OOS vengono aggregati per valutare la robustezza della strategia

**Tipi di WFO supportati**:
- **Anchored**: Un singolo periodo IS iniziale, seguito da multipli periodi OOS
- **Rolling**: Periodi IS e OOS che "rotolano" in avanti nel tempo
- **Sliding**: Simile al rolling, ma con sovrapposizione dei periodi

**Configurazione WFO**:
- Lunghezza del periodo IS (es. 6 mesi)
- Lunghezza del periodo OOS (es. 2 mesi)
- Tipo di WFO (anchored, rolling, sliding)
- Parametri da ottimizzare
- Metrica di ottimizzazione (profit factor, drawdown, ecc.)

**Visualizzazione dei risultati**:
- Grafico delle performance IS vs OOS
- Tabella dei parametri ottimizzati per ogni periodo
- Statistiche di robustezza (stabilità dei parametri)
- Report dettagliato esportabile

## SOLUZIONI TECNICHE IMPLEMENTATE

### 1. Sistema di gestione preset robusto
- Utilizzo della cartella `MQL5\Files` che è sempre accessibile in scrittura
- Formato TXT per i preset invece di JSON per maggiore robustezza
- Sistema di fallback per le directory che tenta percorsi alternativi
- Creazione automatica del preset Default se non esiste

```cpp
// Esempio di implementazione del sistema di fallback
string basePaths[] = {
   "OmniEA\\Presets",
   "OmniEA",
   ""
};

bool success = false;
for(int i = 0; i < ArraySize(basePaths); i++)
{
   m_presetDirectory = basePaths[i];
   if(Init())
   {
      success = true;
      break;
   }
}
```

### 2. Corretta inizializzazione dei manager
- Inizializzazione di PresetManager prima di PanelManager
- Collegamento corretto tra i manager per garantire il funzionamento dell'interfaccia

```cpp
// Esempio di inizializzazione corretta in OnInit()
presetManager.Init();
presetManager.SetSlotManager(&slotManager);
presetManager.SetPanelManager(&panelManager);

panelManager.SetSlotManager(&slotManager);
panelManager.SetPresetManager(&presetManager);
panelManager.SetReportGenerator(&reportGenerator);
```

### 3. Dichiarazioni anticipate per evitare riferimenti circolari
- Uso di dichiarazioni anticipate per le classi che si riferiscono l'una all'altra
- Implementazione dei metodi fuori dalla dichiarazione della classe

```cpp
// Dichiarazioni anticipate
class CSlotManager;
class CPanelManager;

// Implementazione dei metodi fuori dalla classe
void CPresetManager::SetSlotManager(CSlotManager *slotMgr)
{
   m_slotManager = slotMgr;
}

void CPresetManager::SetPanelManager(CPanelManager *panelMgr)
{
   m_panelManager = panelMgr;
}
```

## FILE MODIFICATI RECENTEMENTE

1. `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\omniea\PresetManager.mqh`
   - Implementato un nuovo sistema di gestione preset basato su file TXT
   - Aggiunto sistema di fallback per le directory
   - Aggiunti riferimenti a SlotManager e PanelManager
   - Corretti problemi di compilazione

2. `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Experts\AIWindsurf\OmniEA\OmniEA_Lite.mq5`
   - Modificato l'ordine di inizializzazione in OnInit()
   - Aggiunto il collegamento corretto tra i gestori

## PROSSIMI PASSI

1. **Risolvere i problemi dell'interfaccia grafica**:
   - Analizzare il codice di PanelUI.mqh e PanelEvents.mqh
   - Identificare perché alcuni pulsanti non vengono visualizzati
   - Correggere la funzionalità dei pulsanti

2. **Completare l'integrazione UI del Walk Forward Optimizer**:
   - Aggiungere pannello di configurazione WFO nell'interfaccia di OmniEA
   - Implementare visualizzazione dei risultati dell'ottimizzazione

3. **Implementare la logica WFO**:
   - Integrare la libreria WFO con la logica di trading di OmniEA
   - Implementare il salvataggio e il caricamento dei parametri ottimizzati

4. **Sviluppare completamente il Pannello Grande**:
   - Implementare tutte le funzionalità previste per la versione Ultimate
   - Testare a fondo tutte le funzionalità

5. **Creare le versioni Pro e Lite**:
   - Derivare le versioni Pro e Lite dalla versione Ultimate
   - Rinominare i file in modo appropriato

6. **Completare il supporto multilingua**:
   - Aggiungere le lingue pianificate (spagnolo, russo, cinese)
   - Testare l'interfaccia in tutte le lingue

7. **Migliorare il sistema Drag&Drop**:
   - Aggiungere feedback visivo durante il trascinamento
   - Supportare più tipi di indicatori
   - Migliorare la gestione degli errori

## MARKETING E ASSISTENZA

### Strategia di marketing
OmniEA sarà commercializzato attraverso diversi canali:

1. **MQL5 Market**:
   - Pubblicazione delle tre versioni (Ultimate, Pro, Lite)
   - Prezzi differenziati per ogni versione
   - Periodo di prova gratuito per la versione Lite

2. **Sito web dedicato**:
   - Presentazione dettagliata delle funzionalità
   - Video tutorial
   - Testimonianze degli utenti
   - Blog con articoli su strategie di trading

3. **Social media**:
   - Pagina Facebook
   - Canale YouTube con tutorial
   - Profilo Twitter per aggiornamenti
   - Gruppo Telegram per la community

4. **Email marketing**:
   - Newsletter mensile con aggiornamenti
   - Offerte speciali per gli abbonati
   - Contenuti educativi

### Assistenza clienti
L'assistenza per OmniEA sarà fornita attraverso:

1. **Supporto via email**:
   - Tempo di risposta garantito entro 24 ore
   - Supporto in italiano e inglese

2. **Gruppo Telegram**:
   - Community di utenti
   - Supporto peer-to-peer
   - Annunci di aggiornamenti

3. **Documentazione**:
   - Manuale utente dettagliato
   - FAQ
   - Video tutorial

4. **Aggiornamenti**:
   - Aggiornamenti regolari con nuove funzionalità
   - Correzioni di bug tempestive
   - Roadmap pubblica degli sviluppi futuri

## REGOLE FONDAMENTALI DEL PROGETTO

1. **Memorizzazione fisica obbligatoria (Regola 17)**:
   - Tutti i dati importanti devono essere memorizzati fisicamente in file
   - Ogni AI deve creare file di riepilogo per garantire la continuità
   - La memorizzazione fisica garantisce che le informazioni siano sempre disponibili

2. **Continuità del lavoro tra diverse AI (Regola 16)**:
   - Le AI devono poter riprendere il lavoro l'una dell'altra senza perdita di informazioni
   - I file di riepilogo sono lo strumento principale per garantire questa continuità
   - Il passaggio di lavoro tra AI deve essere fluido e senza perdita di contesto

3. **Comunicazione in italiano (Regola 13)**:
   - Tutte le comunicazioni e documentazioni devono essere in lingua italiana
   - Questo garantisce una comunicazione chiara e senza ambiguità

4. **Qualità prodotti (Regola 7)**:
   - Creare sempre prodotti di alta qualità
   - Utilizzare principi di psicologia per migliorare l'esperienza utente
   - Applicare regole di marketing efficaci

5. **Ottimizzazione token (Regola 2)**:
   - Il consumo dei token AI deve essere ottimizzato al massimo
   - Evitare ripetizioni inutili e generazione di codice non necessario

6. **Backup (Regola 5)**:
   - Il backup di BlueTrendTeam deve essere sicuro, aggiornato e organizzato
   - Strutturato per lettura semplice e veloce
   - Protetto da cancellazioni accidentali

7. **Automazione (Regola 9)**:
   - Sbrigare automaticamente il più possibile delle attività
   - Ridurre la necessità di intervento manuale dell'utente

8. **Proattività (Regola 10)**:
   - Fornire suggerimenti ottimali
   - Memorizzare tutte le informazioni rilevanti

9. **Supervisione (Regola 12)**:
   - La supervisione di BTT è affidata ad AI Windsurf
   - AI Windsurf ha autorità di coordinamento su tutte le attività

## LINK UTILI

### Repository e risorse
- **Repository GitHub**: [https://github.com/Start13/MQL5-Backup](https://github.com/Start13/MQL5-Backup)
- **Dashboard BTT**: [http://localhost:8080/](http://localhost:8080/)
- **MQL5 Market**: [https://www.mql5.com/en/market](https://www.mql5.com/en/market)
- **Documentazione MQL5**: [https://www.mql5.com/en/docs](https://www.mql5.com/en/docs)

### Documentazione interna
- [Soluzione_Finale_PresetManager.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\Soluzione_Finale_PresetManager.md) - Dettagli sulla soluzione implementata per il PresetManager
- [Analisi_Soluzioni_PresetManager.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\Analisi_Soluzioni_PresetManager.md) - Analisi delle possibili soluzioni per il PresetManager
- [OmniEA_PresetManager_Error_Report.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\OmniEA_PresetManager_Error_Report.md) - Report degli errori riscontrati con il PresetManager
- [BBTT_2025-04-27_0026.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\BBTT_2025-04-27_0026.md) - Riepilogo del lavoro più recente
- [Integrazione_WFO_OmniEA.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\Integrazione_WFO_OmniEA.md) - Dettagli sull'integrazione del Walk Forward Optimizer
- [Riepilogo_WFO_UI_Integration.md](C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\Riepilogo_WFO_UI_Integration.md) - Riepilogo dell'integrazione UI del WFO

### Strumenti di sviluppo
- **MetaEditor64**: `C:\Program Files\RoboForex MT5 Terminal2\MetaEditor64.exe`
- **Visual Studio Code**: Per l'editing dei file di documentazione e script
- **Git**: Per la gestione del controllo versione
- **PowerShell**: Per l'automazione e gli script di supporto

## CONSIDERAZIONI FINALI

OmniEA è un progetto ambizioso che mira a creare un Expert Advisor completo e versatile per MetaTrader 5. Attualmente, stiamo concentrando gli sforzi sullo sviluppo della versione Ultimate con tutte le funzionalità, per poi derivare le versioni Pro e Lite.

I recenti progressi nella risoluzione dei problemi del PresetManager hanno permesso di superare un ostacolo critico che impediva il corretto funzionamento dell'EA. Tuttavia, rimangono ancora problemi con l'interfaccia utente che dovranno essere risolti nelle prossime fasi di sviluppo.

L'integrazione del Walk Forward Optimizer rappresenta un'importante evoluzione del progetto, che permetterà di ottimizzare automaticamente i parametri di trading in base alle condizioni di mercato.

La collaborazione tra diverse AI (Windsurf, Grok, ecc.) è fondamentale per il successo del progetto e richiede una documentazione chiara e completa, che questo documento cerca di fornire.

## APPENDICE: GLOSSARIO

- **EA (Expert Advisor)**: Programma di trading automatico per MetaTrader
- **MT5**: MetaTrader 5, piattaforma di trading
- **Slot**: Contenitore per un indicatore nella strategia di trading
- **Preset**: Configurazione salvata dell'EA
- **WFO (Walk Forward Optimization)**: Metodo di ottimizzazione che divide i dati in periodi di training e testing
- **IS (In-Sample)**: Dati utilizzati per l'ottimizzazione dei parametri
- **OOS (Out-of-Sample)**: Dati utilizzati per la validazione dei parametri ottimizzati
- **Drag&Drop**: Funzionalità che permette di trascinare gli indicatori negli slot
- **Money Management**: Sistema di gestione del rischio e del capitale
- **Trailing Stop**: Tecnica per spostare lo stop loss in direzione favorevole al trade
- **Break-Even**: Punto in cui un trade non genera né profitto né perdita
