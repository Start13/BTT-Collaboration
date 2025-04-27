# VISUALIZZAZIONE BUFFER E FUNZIONALITÀ AVANZATE DI OMNIEA
*Ultimo aggiornamento: 27 aprile 2025, 13:15*

Questo documento descrive le funzionalità avanzate di OmniEA relative alla visualizzazione dei buffer degli indicatori sul grafico e alle opzioni di logica condizionale.

## VISUALIZZAZIONE DEI BUFFER SUL GRAFICO

OmniEA offre una potente funzionalità di visualizzazione dei buffer degli indicatori direttamente sul grafico di MetaTrader 5, consentendo agli utenti di analizzare visivamente i segnali generati dalla strategia.

### Funzionalità di visualizzazione

1. **Visualizzazione selettiva dei buffer**:
   - Possibilità di selezionare quali buffer visualizzare sul grafico
   - Personalizzazione del colore, dello stile e dello spessore della linea per ogni buffer
   - Opzione per visualizzare i buffer come linee, istogrammi, punti o frecce

2. **Modalità di visualizzazione**:
   - **Modalità normale**: Visualizzazione standard dei valori del buffer
   - **Modalità normalizzata**: Valori normalizzati per confrontare indicatori con scale diverse
   - **Modalità segnali**: Visualizzazione solo dei punti in cui vengono generati segnali di trading
   - **Modalità sovrapposta**: Possibilità di sovrapporre più buffer per confronto diretto

3. **Personalizzazione avanzata**:
   - Etichette personalizzate per ogni buffer
   - Livelli di riferimento orizzontali (es. livelli di overbought/oversold)
   - Annotazioni automatiche sui punti di segnale
   - Statistiche in tempo reale sulla performance dei segnali

4. **Gestione della visualizzazione**:
   - Pannello di controllo dedicato per gestire la visualizzazione
   - Preset di visualizzazione salvabili
   - Modalità di visualizzazione temporanea per analisi rapide
   - Opzione per esportare le visualizzazioni come immagini

### Implementazione tecnica

```cpp
// Esempio di implementazione della visualizzazione dei buffer
void VisualizeBuffer(int indicatorIndex, int bufferIndex, color bufferColor, ENUM_LINE_STYLE style, int width)
{
   string indicatorName = slotManager.GetIndicatorName(indicatorIndex);
   string bufferLabel = slotManager.GetBufferLabel(indicatorIndex, bufferIndex);
   
   // Crea un oggetto linea per ogni candle
   for(int i = 0; i < Bars(_Symbol, _Period); i++)
   {
      double value = slotManager.GetBufferValue(indicatorIndex, bufferIndex, i);
      
      if(value != EMPTY_VALUE)
      {
         string objName = "OmniEA_" + indicatorName + "_" + bufferLabel + "_" + IntegerToString(i);
         ObjectCreate(0, objName, OBJ_TREND, 0, Time[i], value, Time[i+1], value);
         ObjectSetInteger(0, objName, OBJPROP_COLOR, bufferColor);
         ObjectSetInteger(0, objName, OBJPROP_STYLE, style);
         ObjectSetInteger(0, objName, OBJPROP_WIDTH, width);
      }
   }
}
```

## FUNZIONI LOGICHE AND/OR E OPZIONI DINAMICHE

OmniEA implementa un sistema avanzato di logica condizionale che consente di creare strategie complesse combinando diversi indicatori e condizioni.

### Sistema di logica condizionale

1. **Operatori logici**:
   - **AND**: Tutte le condizioni devono essere soddisfatte
   - **OR**: Almeno una condizione deve essere soddisfatta
   - **XOR**: Esattamente una condizione deve essere soddisfatta
   - **NOT**: Inversione della condizione
   - **Combinazioni nidificate**: Possibilità di creare espressioni complesse (es. (A AND B) OR (C AND D))

2. **Condizioni personalizzabili per buffer**:
   - Maggiore di un valore (>)
   - Minore di un valore (<)
   - Uguale a un valore (=)
   - Attraversamento verso l'alto (crossover up)
   - Attraversamento verso il basso (crossover down)
   - Entro un intervallo (between)
   - Fuori da un intervallo (outside)

3. **Condizioni tra buffer**:
   - Buffer1 > Buffer2
   - Buffer1 < Buffer2
   - Buffer1 attraversa Buffer2 verso l'alto
   - Buffer1 attraversa Buffer2 verso il basso
   - Distanza tra Buffer1 e Buffer2 > valore
   - Distanza tra Buffer1 e Buffer2 < valore

### Opzioni dinamiche di azione

OmniEA adatta automaticamente le opzioni disponibili in base al tipo di indicatore e al numero di buffer che possiede, offrendo un'interfaccia contestuale e intuitiva.

1. **Adattamento automatico all'indicatore**:
   - Rilevamento automatico del numero di buffer dell'indicatore
   - Identificazione del tipo di indicatore (oscillatore, trend, volatilità, ecc.)
   - Suggerimento delle condizioni più appropriate per quel tipo di indicatore

2. **Personalizzazione per tipo di indicatore**:
   - **Oscillatori** (es. RSI, Stochastic):
     - Condizioni di overbought/oversold
     - Divergenze
     - Attraversamenti della linea centrale
   
   - **Indicatori di trend** (es. Moving Average, MACD):
     - Direzione del trend
     - Forza del trend
     - Attraversamenti
   
   - **Indicatori di volatilità** (es. Bollinger Bands, ATR):
     - Espansione/contrazione delle bande
     - Breakout
     - Ritorno alla media

3. **Interfaccia contestuale**:
   - Menu dinamici che mostrano solo le opzioni pertinenti
   - Suggerimenti in tempo reale basati sulle selezioni dell'utente
   - Anteprima dei risultati delle condizioni selezionate

4. **Esempi di implementazione**:

```cpp
// Esempio di implementazione di condizioni dinamiche
bool EvaluateCondition(int indicatorIndex, int bufferIndex, int conditionType, double compareValue)
{
   // Ottieni il tipo di indicatore
   ENUM_INDICATOR_TYPE indicatorType = slotManager.GetIndicatorType(indicatorIndex);
   
   // Adatta la logica in base al tipo di indicatore
   switch(indicatorType)
   {
      case INDICATOR_OSCILLATOR:
         return EvaluateOscillatorCondition(indicatorIndex, bufferIndex, conditionType, compareValue);
         
      case INDICATOR_TREND:
         return EvaluateTrendCondition(indicatorIndex, bufferIndex, conditionType, compareValue);
         
      case INDICATOR_VOLATILITY:
         return EvaluateVolatilityCondition(indicatorIndex, bufferIndex, conditionType, compareValue);
         
      default:
         return EvaluateGenericCondition(indicatorIndex, bufferIndex, conditionType, compareValue);
   }
}
```

## ESEMPI DI STRATEGIE AVANZATE

### Strategia multi-indicatore con logica complessa

```
BUY CONDITION:
(RSI(14) crosses above 30 AND Stochastic(5,3,3) < 20)
OR
(MACD(12,26,9) Signal crosses above MACD Line AND Moving Average(50) > Moving Average(200))

SELL CONDITION:
(RSI(14) crosses below 70 AND Stochastic(5,3,3) > 80)
OR
(MACD(12,26,9) Signal crosses below MACD Line AND Moving Average(50) < Moving Average(200))
```

### Strategia con visualizzazione personalizzata

1. RSI(14) visualizzato come linea blu con livelli di riferimento a 30 e 70
2. Stochastic(5,3,3) visualizzato come due linee (principale e segnale) in rosso e verde
3. MACD visualizzato come istogramma con linee di segnale
4. Punti di entrata e uscita evidenziati con frecce sul grafico

## INTEGRAZIONE CON IL SISTEMA DI PRESET

La visualizzazione dei buffer e le opzioni di logica condizionale sono completamente integrate con il sistema di preset di OmniEA, consentendo di salvare e caricare configurazioni complete che includono:

1. Indicatori selezionati e loro parametri
2. Condizioni logiche configurate
3. Impostazioni di visualizzazione dei buffer
4. Parametri di money management
5. Configurazioni di trailing stop e break-even

Questo permette agli utenti di creare, testare e ottimizzare strategie complesse e poi salvarle per un uso futuro o condividerle con altri trader.

## DISPONIBILITÀ NELLE VERSIONI

- **Ultimate**: Supporto completo per tutte le funzionalità di visualizzazione e logica condizionale
- **Pro**: Supporto per la maggior parte delle funzionalità, con alcune limitazioni nelle condizioni più complesse
- **Lite**: Supporto base per la visualizzazione e logica condizionale semplice
