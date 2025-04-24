# BlueTrendTeam - Librerie Include

Questa cartella contiene le librerie e i componenti riutilizzabili per i progetti BlueTrendTeam.

## 📑 Struttura della Cartella

```
AIChatGpt/
├── common/             # Utility comuni
│   └── UIUtils.mqh    # Funzioni di utilità per l'interfaccia utente
├── omniea/             # Componenti specifici per OmniEA
│   └── SlotLogic.mqh  # Gestione degli slot per indicatori
├── argonaut/           # Componenti specifici per Argonaut
├── ui/                 # Componenti dell'interfaccia utente
│   └── PanelManager.mqh # Gestione dei pannelli UI
└── OptimizerGenerator.mqh # Generatore di configurazioni per ottimizzazione
```

## 🚩 Componenti Principali

### OptimizerGenerator.mqh
Componente strategico per la generazione di configurazioni di ottimizzazione. Utilizzato sia da OmniEA che da Argonaut per:
- Generazione programmatica di configurazioni di ottimizzazione
- Supporto per la creazione di preset basati su diverse strategie
- Test di ottimizzazione su diversi timeframe e asset
- Integrazione con il sistema di preset JSON

### common/UIUtils.mqh
Funzioni di utilità per la creazione e gestione di elementi dell'interfaccia utente:
- Creazione di etichette, pulsanti, campi di testo e rettangoli
- Gestione degli oggetti grafici
- Funzioni di supporto per l'interfaccia utente

### omniea/SlotLogic.mqh
Sistema di gestione degli slot per indicatori in OmniEA:
- Struttura `IndicatorSlot` per gestire lo stato degli indicatori
- Classe `CSlotManager` per la gestione degli slot
- Funzioni per la verifica delle condizioni di trading
- Supporto per operatori logici tra indicatori

### ui/PanelManager.mqh
Gestione dei pannelli dell'interfaccia utente:
- Creazione del pannello principale
- Gestione delle sezioni (informazioni, segnali, filtri, rischio)
- Aggiornamento dinamico dello stato
- Gestione degli eventi del grafico

## 🔄 Utilizzo dei Componenti

### OptimizerGenerator
```cpp
#include <AIChatGpt\OptimizerGenerator.mqh>

// Esempio di utilizzo
void GenerateOptimizationFile()
{
   OptimizerGenerator optimizer;
   
   // Aggiungi parametri da ottimizzare
   optimizer.Add("StopLoss", 20.0, 10.0, 100.0);
   optimizer.Add("TakeProfit", 40.0, 10.0, 200.0);
   optimizer.Add("TrailingStop", 30.0, 10.0, 100.0);
   
   // Salva la configurazione in un file .set
   optimizer.SaveToFile("MyStrategy_Optimization.set");
}
```

### SlotLogic
```cpp
#include <AIChatGpt\omniea\SlotLogic.mqh>

// Esempio di utilizzo
CSlotManager slotManager;

void InitializeSlots()
{
   // Inizializza gli slot
   int maHandle = iMA(_Symbol, PERIOD_CURRENT, 20, 0, MODE_SMA, PRICE_CLOSE);
   int rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
   
   // Configura uno slot di acquisto (MA > 0)
   slotManager.SetBuySlot(0, "MA", maHandle, 0, 0.0, 0);
   
   // Configura uno slot di vendita (RSI < 30)
   slotManager.SetSellSlot(0, "RSI", rsiHandle, 0, 30.0, 1);
}

bool CheckBuySignal()
{
   return slotManager.CheckBuyConditions();
}

bool CheckSellSignal()
{
   return slotManager.CheckSellConditions();
}
```

### PanelManager
```cpp
#include <AIChatGpt\ui\PanelManager.mqh>

// Esempio di utilizzo
CPanelManager panelManager;

int OnInit()
{
   // Inizializza il pannello
   panelManager.Initialize("OmniEA Lite");
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   // Pulisci il pannello
   panelManager.Cleanup();
}

void OnTick()
{
   // Aggiorna il pannello
   panelManager.Update();
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // Gestisci gli eventi del grafico
   panelManager.OnChartEvent(id, lparam, dparam, sparam);
}
```

## 📊 Linee Guida di Sviluppo

In conformità con le Regole Fondamentali di BlueTrendTeam:

1. **Memorizzazione completa** (Regola #1): Documentare ogni componente in modo dettagliato
2. **Ottimizzazione token** (Regola #2): Mantenere il codice efficiente e ben strutturato
3. **Collaborazione tra AI** (Regola #3): Strutturare i componenti per facilitare la collaborazione
4. **Comunicazione in italiano** (Regola #11): Commentare il codice in italiano
5. **Supervisione** (Regola #12): Seguire le direttive di AI Windsurf per lo sviluppo

---

*Ultimo aggiornamento: 2025-04-22*  
*© 2025 BlueTrendTeam - Tutti i diritti riservati*
