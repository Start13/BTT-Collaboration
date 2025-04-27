# OMNIEA - DOCUMENTAZIONE MASTER
*Ultimo aggiornamento: 27 aprile 2025, 15:25*

## INDICE
1. [Panoramica del progetto](#panoramica-del-progetto)
2. [Struttura del progetto](#struttura-del-progetto)
3. [Funzionalità principali](#funzionalità-principali)
4. [Versioni del prodotto](#versioni-del-prodotto)
5. [Stato attuale e problemi risolti](#stato-attuale-e-problemi-risolti)
6. [Prossimi passi](#prossimi-passi)
7. [Strategie di monetizzazione](#strategie-di-monetizzazione)
8. [Roadmap di sviluppo](#roadmap-di-sviluppo)

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

## FUNZIONALITÀ PRINCIPALI

### 1. Supporto multivaluta
OmniEA supporta il trading su più coppie di valute contemporaneamente, consentendo agli utenti di diversificare le loro strategie di trading.

**Modalità di funzionamento**:
1. **Modalità indipendente**: Ogni istanza dell'EA opera in modo indipendente sulle diverse coppie di valute
2. **Modalità correlata**: Le decisioni di trading tengono conto delle correlazioni tra le diverse coppie di valute
3. **Modalità basket**: Gestione del rischio a livello di basket di valute, con limiti di esposizione globali

### 2. Visualizzazione dei buffer sul grafico
OmniEA offre una potente funzionalità di visualizzazione dei buffer degli indicatori direttamente sul grafico di MetaTrader 5, consentendo agli utenti di analizzare visivamente i segnali generati dalla strategia.

**Funzionalità di visualizzazione**:
- Visualizzazione selettiva dei buffer con personalizzazione di colore, stile e spessore
- Diverse modalità di visualizzazione (normale, normalizzata, segnali, sovrapposta)
- Personalizzazione avanzata con etichette, livelli di riferimento e annotazioni
- Gestione della visualizzazione tramite pannello dedicato

### 3. Funzioni logiche AND/OR e opzioni dinamiche
OmniEA implementa un sistema avanzato di logica condizionale che consente di creare strategie complesse combinando diversi indicatori e condizioni.

**Sistema di logica condizionale**:
- Operatori logici completi (AND, OR, XOR, NOT)
- Condizioni personalizzabili per ogni buffer (>, <, =, crossover, ecc.)
- Condizioni tra buffer diversi per strategie più complesse
- Adattamento automatico in base al tipo di indicatore e al numero di buffer

### 4. Sistema di preset delle configurazioni
Il sistema di preset consente agli utenti di salvare e caricare configurazioni complete dell'EA, facilitando il passaggio tra diverse strategie di trading.

**Funzionalità**:
- Salvataggio preset: L'utente può salvare la configurazione corrente con un nome personalizzato
- Caricamento preset: L'utente può caricare una configurazione salvata
- Preset predefiniti: L'EA include alcuni preset predefiniti per strategie comuni
- Importazione/Esportazione: L'utente può importare/esportare preset per condividerli

### 5. Walk Forward Optimizer (WFO)
Il Walk Forward Optimizer è un sistema avanzato per ottimizzare i parametri di trading in modo robusto, evitando l'overfitting.

**Tipi di WFO supportati**:
- **Anchored**: Un singolo periodo IS iniziale, seguito da multipli periodi OOS
- **Rolling**: Periodi IS e OOS che "rotolano" in avanti nel tempo
- **Sliding**: Simile al rolling, ma con sovrapposizione dei periodi

### 6. Supporto multilingua
OmniEA supporta più lingue per rendere l'EA accessibile a un pubblico internazionale.

**Lingue supportate**:
- Italiano (predefinito)
- Inglese
- Spagnolo (pianificato)
- Russo (pianificato)
- Cinese (pianificato)

### 7. Integrazione con servizi esterni
OmniEA integra diversi servizi esterni per migliorare l'esperienza di trading.

**Servizi integrati**:
- Calendario economico completo
- Feed di notizie in tempo reale
- Sistema di notifiche avanzato (push, email, Telegram)
- Compatibilità con VPS
- Opzioni di hedging avanzate

## VERSIONI DEL PRODOTTO

### OmniEA Ultimate
1. **Trading avanzato multi-asset**:
   - Trading su Forex, Indici, Materie prime, Criptovalute
   - Supporto per tutti i timeframe da M1 a MN
   - Strategie specifiche per ogni classe di asset

2. **Intelligenza artificiale integrata**:
   - Riconoscimento automatico dei pattern di mercato
   - Adattamento dinamico ai cambiamenti delle condizioni di mercato
   - Suggerimenti intelligenti per l'ottimizzazione dei parametri

3. **Analisi avanzata del rischio**:
   - Calcolo del Value at Risk (VaR)
   - Stress testing delle strategie
   - Simulazione Monte Carlo per la previsione dei risultati

4. **Integrazione con fonti di dati esterne**:
   - Feed di notizie economiche
   - Dati macroeconomici
   - Sentiment di mercato dai social media

5. **Reportistica professionale**:
   - Report dettagliati in formato PDF
   - Grafici avanzati delle performance
   - Esportazione dati in Excel per analisi personalizzate

### OmniEA Pro
1. **Trading multi-asset selettivo**:
   - Trading su Forex e Indici principali
   - Supporto per timeframe da M5 a D1
   - Strategie ottimizzate per il Forex

2. **Ottimizzazione semi-automatica**:
   - Suggerimenti per l'ottimizzazione dei parametri
   - Walk Forward Optimization semplificata
   - Preset pre-ottimizzati per le principali coppie di valute

3. **Gestione del rischio avanzata**:
   - Trailing stop dinamico
   - Break-even automatico
   - Chiusura parziale delle posizioni

4. **Filtri di mercato**:
   - Filtro per volatilità
   - Filtro per spread
   - Filtro per orari di trading

### OmniEA Lite
1. **Trading Forex essenziale**:
   - Trading sulle principali coppie di valute
   - Supporto per timeframe da M15 a H4
   - Strategie di base

2. **Ottimizzazione manuale**:
   - Interfaccia semplificata per la configurazione
   - Preset predefiniti non modificabili
   - Guida all'ottimizzazione manuale

3. **Gestione del rischio di base**:
   - Stop loss e take profit fissi
   - Trailing stop semplice
   - Limite di rischio per operazione

## STATO ATTUALE E PROBLEMI RISOLTI

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

## STRATEGIE DI MONETIZZAZIONE

### 1. Modello di abbonamento
- Ultimate: €199/mese o €1990/anno
- Pro: €99/mese o €990/anno
- Lite: €49/mese o €490/anno

### 2. Licenze perpetue
- Ultimate: €4990 (include 1 anno di aggiornamenti)
- Pro: €2490 (include 1 anno di aggiornamenti)
- Lite: €990 (include 1 anno di aggiornamenti)

### 3. Servizi aggiuntivi
- Configurazione personalizzata: €299
- Formazione one-to-one: €199/ora
- Sviluppo di indicatori custom: da €499
- Ottimizzazione avanzata: €399

### 4. Programma di affiliazione
- Commissione del 30% sulle vendite generate
- Dashboard per il tracking delle conversioni
- Materiali di marketing pronti all'uso
- Supporto dedicato per gli affiliati

## ROADMAP DI SVILUPPO

### Q2 2025
- Rilascio ufficiale di OmniEA Ultimate v1.0
- Rilascio di OmniEA Pro v1.0
- Rilascio di OmniEA Lite v1.0
- Lancio del sito web e della campagna di marketing

### Q3 2025
- Aggiunta del supporto per criptovalute
- Miglioramento del sistema di reportistica
- Integrazione con API esterne per dati macroeconomici
- Ottimizzazione delle performance

### Q4 2025
- Lancio della versione 2.0 con intelligenza artificiale avanzata
- Aggiunta di nuovi indicatori proprietari
- Implementazione di strategie di hedging avanzate
- Espansione del supporto multilingua

### Q1 2026
- Integrazione con piattaforme di social trading
- Sviluppo di una dashboard web per il monitoraggio remoto
- Implementazione di un sistema di alert via mobile
- Ottimizzazione per trading ad alta frequenza

---

*Questo documento integra tutte le informazioni su OmniEA e viene aggiornato regolarmente per riflettere lo stato attuale del progetto.*
