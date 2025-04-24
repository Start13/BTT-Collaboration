# ISTRUZIONI PER L'UTILIZZO DEL WALK FORWARD OPTIMIZER IN OMNIEA

## Prerequisiti

Prima di poter utilizzare il Walk Forward Optimizer con OmniEA, è necessario:

1. **Installare la libreria WFO**:
   - Scaricare il file `WalkForwardOptimizer MT5.ex5` dal Market di MQL5
   - Copiarlo nella cartella `MQL5/Libraries` del terminale MetaTrader 5
   - Assicurarsi che il file `WalkForwardOptimizer.mqh` sia presente nella cartella `MQL5/Include`

2. **Verificare l'installazione di OmniEA**:
   - OmniEA deve essere correttamente installato e funzionante
   - La classe `COmniEA` deve essere accessibile tramite `#include <AIWindsurf\omniea\OmniEA.mqh>`

## Configurazione

L'Expert Advisor `OmniEA_WFO.mq5` include i seguenti parametri di configurazione:

### Parametri del Walk Forward Optimizer

- **EnableWFO**: Abilita o disabilita l'integrazione del Walk Forward Optimizer
- **WFO_WindowSize**: Dimensione della finestra di ottimizzazione
  - `year`: 1 anno (default)
  - `half_year`: 6 mesi
  - `quarter`: 3 mesi
  - `month`: 1 mese
  - `week`: 1 settimana
  - `day`: 1 giorno
  - `custom`: Dimensione personalizzata in giorni
- **WFO_StepSize**: Dimensione del passo di avanzamento
  - `year`: 1 anno
  - `half_year`: 6 mesi
  - `quarter`: 3 mesi (default)
  - `month`: 1 mese
  - `week`: 1 settimana
  - `day`: 1 giorno
  - `custom`: Dimensione personalizzata in percentuale della finestra
- **WFO_StepOffset**: Offset del passo (in giorni)
- **WFO_CustomWindowSizeDays**: Numero di giorni per la finestra personalizzata (se WFO_WindowSize = custom)
- **WFO_CustomStepSizePercent**: Percentuale della finestra per il passo personalizzato (se WFO_StepSize = custom)
- **WFO_Estimation**: Metodo di valutazione
  - `wfo_built_in_loose`: Valutazione integrata loose (default)
  - `wfo_built_in_strict`: Valutazione integrata strict
  - `wfo_profit`: Valutazione basata sul profitto
  - `wfo_profit_factor`: Valutazione basata sul profit factor
  - `wfo_sharpe_ratio`: Valutazione basata sul rapporto di Sharpe
  - `wfo_expression`: Valutazione basata su una formula personalizzata
- **WFO_Formula**: Formula personalizzata per la valutazione (se WFO_Estimation = wfo_expression)
- **WFO_PFMax**: Valore massimo del profit factor
- **WFO_CloseTradesOnSeparationLine**: Chiude i trade sulla linea di separazione
- **WFO_OutputFile**: File di output per i risultati

## Utilizzo nel Tester di Strategia

Per eseguire un'ottimizzazione walk-forward con OmniEA:

1. **Aprire il Tester di Strategia**:
   - Premere F6 in MetaTrader 5
   - Selezionare `OmniEA_WFO.mq5` dall'elenco degli Expert Advisor

2. **Configurare il test**:
   - Selezionare "Optimization" come modalità di test
   - Configurare il periodo di test (deve essere sufficientemente lungo per contenere più finestre di ottimizzazione)
   - Selezionare il simbolo e il timeframe desiderati
   - Configurare i parametri di ottimizzazione di OmniEA
   - Configurare i parametri del Walk Forward Optimizer

3. **Eseguire l'ottimizzazione**:
   - Fare clic su "Start" per avviare l'ottimizzazione
   - Il processo può richiedere molto tempo, a seconda della complessità della strategia e della quantità di dati

4. **Analizzare i risultati**:
   - I risultati dell'ottimizzazione walk-forward saranno salvati nel file specificato in `WFO_OutputFile`
   - Il file conterrà informazioni dettagliate su ciascuna finestra di ottimizzazione e test
   - Analizzare i risultati per verificare la robustezza della strategia

## Interpretazione dei Risultati

I risultati dell'ottimizzazione walk-forward possono essere interpretati come segue:

1. **Robustezza della strategia**:
   - Se la strategia ottimizzata mantiene prestazioni simili nelle finestre di test, è considerata robusta
   - Se le prestazioni variano significativamente tra le finestre di ottimizzazione e test, la strategia potrebbe essere soggetta a overfitting

2. **Stabilità dei parametri**:
   - Se i parametri ottimali variano significativamente tra le diverse finestre di ottimizzazione, la strategia potrebbe non essere stabile
   - Se i parametri ottimali sono simili tra le diverse finestre, la strategia è considerata stabile

3. **Valutazione complessiva**:
   - Il Walk Forward Optimizer fornisce una valutazione complessiva della strategia basata sul metodo di valutazione selezionato
   - Un valore più alto indica una strategia più robusta

## Consigli per l'Uso Efficace

1. **Selezione della finestra di ottimizzazione**:
   - La finestra di ottimizzazione dovrebbe essere sufficientemente lunga da catturare diversi cicli di mercato
   - Una finestra di 1 anno è generalmente un buon punto di partenza

2. **Selezione del passo di avanzamento**:
   - Il passo di avanzamento dovrebbe essere sufficientemente lungo da fornire dati significativi per il test
   - Un passo di 3 mesi (trimestre) è generalmente un buon punto di partenza

3. **Metodo di valutazione**:
   - Il metodo di valutazione dovrebbe essere scelto in base agli obiettivi della strategia
   - Per strategie di trading generali, `wfo_built_in_loose` è un buon punto di partenza
   - Per strategie più specifiche, considerare metodi di valutazione personalizzati

4. **Ottimizzazione dei parametri**:
   - Limitare il numero di parametri da ottimizzare per ridurre il rischio di overfitting
   - Concentrarsi sui parametri più importanti per la strategia

## Risoluzione dei Problemi

1. **Errore "WFO Integration not initialized"**:
   - Verificare che la libreria WFO sia correttamente installata
   - Verificare che i parametri di configurazione siano validi

2. **Errore "Error initializing OmniEA"**:
   - Verificare che OmniEA sia correttamente installato
   - Verificare che la classe `COmniEA` sia accessibile

3. **Nessun risultato nel file di output**:
   - Verificare che il file di output sia specificato correttamente
   - Verificare che il periodo di test sia sufficientemente lungo
   - Verificare che l'ottimizzazione sia configurata correttamente

4. **Prestazioni scarse nelle finestre di test**:
   - La strategia potrebbe essere soggetta a overfitting
   - Considerare di ridurre il numero di parametri da ottimizzare
   - Considerare di aumentare la dimensione della finestra di ottimizzazione
