# WALK FORWARD OPTIMIZER - IMPLEMENTAZIONE

## File Header WalkForwardOptimizer.mqh

```cpp
#define DAYS_PER_WEEK    7
#define DAYS_PER_MONTH   30
#define DAYS_PER_QUARTER (DAYS_PER_MONTH*3)
#define DAYS_PER_HALF    (DAYS_PER_MONTH*6)
#define DAYS_PER_YEAR    (DAYS_PER_MONTH*12)

#define SEC_PER_DAY     (60*60*24)
#define SEC_PER_WEEK    (SEC_PER_DAY*DAYS_PER_WEEK)
#define SEC_PER_MONTH   (SEC_PER_DAY*DAYS_PER_MONTH)
#define SEC_PER_QUARTER (SEC_PER_MONTH*3)
#define SEC_PER_HALF    (SEC_PER_MONTH*6)
#define SEC_PER_YEAR    (SEC_PER_MONTH*12)

#define CUSTOM_DAYS     -1

enum WFO_TIME_PERIOD {none = 0, year = DAYS_PER_YEAR, halfyear = DAYS_PER_HALF, quarter = DAYS_PER_QUARTER, month = DAYS_PER_MONTH, week = DAYS_PER_WEEK, day = 1, custom = CUSTOM_DAYS};

enum WFO_ESTIMATION_METHOD {wfo_built_in_loose, wfo_built_in_strict, wfo_profit, wfo_sharpe, wfo_pf, wfo_drawdown, wfo_profit_by_drawdown, wfo_profit_trades_by_drawdown, wfo_average, wfo_expression};

#import "WalkForwardOptimizer MT5.ex5" // !after install must be copied into MQL5/Libraries
void wfo_setEstimationMethod(WFO_ESTIMATION_METHOD estimation, string formula);
void wfo_setPFmax(double max);
void wfo_setCloseTradesOnSeparationLine(bool b);
void wfo_OnTesterPass();
int wfo_OnInit(WFO_TIME_PERIOD optimizeOn, WFO_TIME_PERIOD optimizeStep, int optimizeStepOffset, int optimizeCustomW, int optimizeCustomS);
int wfo_OnTick();
double wfo_OnTester();
void wfo_OnTesterInit(string optimizeLog);
void wfo_OnTesterDeinit();
#import

input WFO_TIME_PERIOD wfo_windowSize = year;
input int wfo_customWindowSizeDays = 0;
input WFO_TIME_PERIOD wfo_stepSize = quarter;
input int wfo_customStepSizePercent = 0;
input int wfo_stepOffset = 0;
input string wfo_outputFile = "";
input WFO_ESTIMATION_METHOD wfo_estimation = wfo_built_in_loose;
input string wfo_formula = "";
```

## Esempio di Implementazione in OmniEA

```cpp
#include <WalkForwardOptimizer.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(void)
{
  // Codice di inizializzazione di OmniEA
  // ...

  // Configurazione del Walk Forward Optimizer
  wfo_setEstimationMethod(wfo_estimation, wfo_formula); // wfo_built_in_loose di default
  wfo_setPFmax(100); // DBL_MAX di default
  // wfo_setCloseTradesOnSeparationLine(true); // false di default
  
  // Questa è l'unica chiamata richiesta in OnInit, tutti i parametri provengono dall'header
  int r = wfo_OnInit(wfo_windowSize, wfo_stepSize, wfo_stepOffset, wfo_customWindowSizeDays, wfo_customStepSizePercent);
  
  return(r);
}

//+------------------------------------------------------------------+
//| Tester initialization function                                   |
//+------------------------------------------------------------------+
void OnTesterInit()
{
  wfo_OnTesterInit(wfo_outputFile); // richiesto
}

//+------------------------------------------------------------------+
//| Tester deinitialization function                                 |
//+------------------------------------------------------------------+
void OnTesterDeinit()
{
  wfo_OnTesterDeinit(); // richiesto
}

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
void OnTesterPass()
{
  wfo_OnTesterPass(); // richiesto
}

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
  return wfo_OnTester(); // richiesto
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(void)
{
  int wfo = wfo_OnTick();
  if(wfo == -1)
  {
    // Può eseguire operazioni non di trading, come la raccolta di statistiche su barre o tick
    return;
  }
  else if(wfo == +1)
  {
    // Può eseguire operazioni non di trading
    return;
  }

  // Codice di trading di OmniEA
  // ...
}
```

## Parametri di Configurazione

- **wfo_windowSize**: Dimensione della finestra di ottimizzazione (anno, semestre, trimestre, mese, settimana, giorno, personalizzato)
- **wfo_customWindowSizeDays**: Numero di giorni per la finestra personalizzata (se wfo_windowSize = custom)
- **wfo_stepSize**: Dimensione del passo di avanzamento (anno, semestre, trimestre, mese, settimana, giorno, personalizzato)
- **wfo_customStepSizePercent**: Percentuale della finestra per il passo personalizzato (se wfo_stepSize = custom)
- **wfo_stepOffset**: Offset del passo (in giorni)
- **wfo_outputFile**: File di output per i risultati
- **wfo_estimation**: Metodo di valutazione (loose, strict, profit, sharpe, ecc.)
- **wfo_formula**: Formula personalizzata per la valutazione (se wfo_estimation = wfo_expression)

## Metodi di Valutazione Disponibili

1. **wfo_built_in_loose**: Valutazione integrata meno stringente
2. **wfo_built_in_strict**: Valutazione integrata più stringente
3. **wfo_profit**: Basato sul profitto
4. **wfo_sharpe**: Basato sul rapporto di Sharpe
5. **wfo_pf**: Basato sul profit factor
6. **wfo_drawdown**: Basato sul drawdown
7. **wfo_profit_by_drawdown**: Rapporto profitto/drawdown
8. **wfo_profit_trades_by_drawdown**: Rapporto trade profittevoli/drawdown
9. **wfo_average**: Media dei metodi precedenti
10. **wfo_expression**: Formula personalizzata

## Note per l'Implementazione in OmniEA

1. Copiare il file WalkForwardOptimizer MT5.ex5 nella cartella MQL5/Libraries
2. Includere WalkForwardOptimizer.mqh nell'EA
3. Modificare le funzioni OnInit(), OnTick(), OnTester(), OnTesterInit(), OnTesterDeinit() e OnTesterPass()
4. Configurare i parametri appropriati per la strategia di OmniEA
5. Eseguire l'ottimizzazione utilizzando il tester di strategia di MetaTrader 5

## RISORSE MQL5 UFFICIALI

### Articoli su Walk Forward Optimization

- [Custom Walk Forward optimization in MetaTrader 5](https://www.mql5.com/en/articles/3279) - Articolo dettagliato sugli approcci che consentono una simulazione accurata della walk forward optimization utilizzando il tester integrato e le librerie ausiliarie implementate in MQL.

### Documentazione della libreria WalkForwardOptimizer

- [Walk-forward optimization library for MetaTrader: advanced options](https://www.mql5.com/en/blogs/post/754712) - Documentazione ufficiale sulle opzioni avanzate della libreria WalkForwardOptimizer, inclusi flag e funzionalità come la chiusura automatica delle posizioni, la correzione delle discrepanze e il controllo della modellazione dei tick.
- [Walk-forward optimization library for MetaTrader: pause, resume, refine](https://www.mql5.com/en/blogs/post/754713) - Documentazione sulla funzionalità di pausa, ripresa e perfezionamento dell'ottimizzazione, introdotta nella versione 1.12 della libreria WalkForwardOptimizer. Include dettagli su come utilizzare il flag WFO_FLAG_RESUME_OPTIMIZATION per continuare un'ottimizzazione interrotta.

## IMPLEMENTAZIONI IN PYTHON

### Link utili per Walk Forward Optimization in Python

- [Walk Forward Optimization in Python](https://mayerkrebs.com/walk-forward-optimization-in-python/) - Tutorial completo su come implementare la Walk Forward Optimization in Python, con esempi di codice e spiegazioni dettagliate.
