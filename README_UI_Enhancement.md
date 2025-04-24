# PROGETTO UI ENHANCEMENT PER OMNIEA - BLUETRENDTEAM

## PANORAMICA DEL PROGETTO

Questo progetto mira a migliorare l'interfaccia utente di OmniEA integrando le librerie standard MQL5 e i pannelli UI avanzati. L'approccio è non invasivo e modulare, permettendo di mantenere la compatibilità con il codice esistente.

## STRUTTURA DEL PROGETTO

```
C:\Users\Asus\CascadeProjects\BlueTrendTeam\MT5_Projects\OmniEA_UI_Enhancement\
├── Include\
│   ├── common\       # Utilità comuni
│   ├── omniea\       # File specifici per OmniEA
│   ├── ui\
│   │   ├── controls\ # Controlli UI estratti e standardizzati
│   │   ├── panels\   # Pannelli specializzati
│   │   └── themes\   # Temi visivi
│   └── indicators\   # Indicatori personalizzati
├── Experts\
│   └── OmniEA\       # Versione di test di OmniEA con UI migliorata
└── Scripts\          # Script di utilità per test e deployment
```

## LIBRERIE MQL5 UTILIZZATE

### Trade
- **Trade.mqh**: Classe `CTrade` per operazioni di trading (ordini, posizioni)
  - Metodi principali: `Buy()`, `Sell()`, `BuyLimit()`, `SellLimit()`, `BuyStop()`, `SellStop()`
  - Gestione posizioni: `PositionOpen()`, `PositionClose()`, `PositionModify()`
  - Verifica ordini: `OrderCheck()`, `OrderSend()`

### Indicatori
- **Indicators.mqh**: Wrapper per indicatori tecnici standard
  - **BillWilliams.mqh**: Indicatori di Bill Williams (Alligator, Fractals, Gator)
  - **Oscilators.mqh**: Oscillatori (RSI, Stochastic, MACD)
  - **Trend.mqh**: Indicatori di trend (ADX, Bollinger Bands, Ichimoku)
  - **Volumes.mqh**: Indicatori di volume
  - **TimeSeries.mqh**: Accesso alle serie temporali

### Algoritmi
- **MovingAverages.mqh**: Implementazione di diverse medie mobili
  - `SimpleMA()`, `ExponentialMA()`, `SmoothedMA()`, `LinearWeightedMA()`
  - Versioni ottimizzate per buffer: `SimpleMAOnBuffer()`, `ExponentialMAOnBuffer()`
- **SmoothAlgorithms.mqh**: Algoritmi avanzati di smoothing
- **TradeAlgorithms.mqh**: Algoritmi per strategie di trading

### Gestione Dati
- **Arrays/**: Classi per gestione array tipizzati
  - `CArrayDouble`, `CArrayString`, `CArrayObj`
  - Strutture dati: `CList`, `CTree`

### Interfaccia Utente
- **ChartObjects/**: Oggetti grafici per i chart
- **Controls/**: Controlli UI per pannelli personalizzati
- **EasyAndFastGUI/**: Framework UI avanzato
- **Canvas/**: Disegno avanzato su chart

## PANNELLI UI DISPONIBILI

Nella cartella `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\BlueTrendTeam\ui\panels` sono disponibili diversi esempi di pannelli:

1. **TradePad**: Sistema completo di pannelli di trading con controlli avanzati
2. **Panel Multicurrency**: Pannello per il monitoraggio e trading su più valute
3. **SimpleHedgePanel**: Pannello per strategie di hedging
4. **fatpanel-0.21_en**: Pannello completo con funzionalità avanzate
5. **mcm_control_panel**: Pannello di controllo per gestione multi-valuta
6. **panel_x**: Pannello personalizzabile con diverse funzionalità

Inoltre, sono disponibili diversi file MQ5 standalone:
- **AIS2 Trading Robot.mq5**: Robot di trading con interfaccia grafica
- **All_information_about_the_symbol.mq5**: Pannello informativo sui simboli
- **Market Watch Panel.mq5**: Pannello per il monitoraggio del mercato
- **ProfitCalculator.mq5**: Calcolatore di profitti
- **SL_Calculator.mq5**: Calcolatore di Stop Loss

## COMPONENTI IMPLEMENTATI

### Controlli UI
- **BaseControl.mqh**: Classe base per tutti i controlli UI
  - Gestione eventi, proprietà comuni, metodi virtuali
  - Sistema di coordinate e dimensioni
  - Gestione colori e visibilità

- **Button.mqh**: Implementazione di un pulsante interattivo
  - Eventi di click e hover
  - Personalizzazione dell'aspetto
  - Gestione stati (premuto, hover)

### Pannelli
- **PanelBase.mqh**: Classe base per tutti i pannelli
  - Supporto per trascinamento
  - Gestione controlli figli
  - Barra del titolo e pulsante di chiusura

- **TradingPanel.mqh**: Pannello di trading
  - Integrazione con `Trade.mqh`
  - Pulsanti Buy, Sell e Close All
  - Gestione parametri di trading (volume, stop loss, take profit)

## PIANO DI INTEGRAZIONE CON OMNIEA

### Fase 1: Implementazione di altri pannelli specializzati
- Pannello di monitoraggio multi-valuta
- Pannello di gestione del rischio
- Pannello di analisi tecnica

### Fase 2: Sviluppo di script di test
- Script per testare i controlli UI
- Script per testare i pannelli
- Script per verificare l'integrazione con OmniEA

### Fase 3: Integrazione con OmniEA
- Estensione del PanelManager esistente
```cpp
// In C:\Users\Asus\CascadeProjects\BlueTrendTeam\MT5_Projects\OmniEA_UI_Enhancement\Include\omniea\PanelManager.mqh
#include <AIWindsurf\ui\PanelManager.mqh>  // PanelManager originale
#include "..\ui\panels\TradingPanel.mqh"
#include "..\ui\panels\MultiCurrencyPanel.mqh"
#include "..\ui\panels\RiskPanel.mqh"

class CEnhancedPanelManager : public CPanelManager
{
private:
   CTradingPanel     m_tradingPanel;
   CMultiCurrencyPanel m_multiCurrencyPanel;
   CRiskPanel        m_riskPanel;
   
   bool              m_enhancedUIEnabled;
   
public:
                     CEnhancedPanelManager();
                    ~CEnhancedPanelManager();
   
   virtual bool      Initialize(const string symbol);
   virtual void      Shutdown();
   
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Gestione UI avanzata
   bool              EnableEnhancedUI(const bool enable = true);
   bool              IsEnhancedUIEnabled() const { return m_enhancedUIEnabled; }
};
```

- Integrazione con OmniEA_Lite.mq5
```cpp
// In C:\Users\Asus\CascadeProjects\BlueTrendTeam\MT5_Projects\OmniEA_UI_Enhancement\Experts\OmniEA\OmniEA_Lite.mq5
#include <Trade\Trade.mqh>
#include "..\..\Include\omniea\PanelManager.mqh"  // Versione estesa

// Dichiarazioni globali
CTrade trade;
CEnhancedPanelManager *g_panelManager = NULL;

// Input per abilitare l'UI avanzata
input bool EnableEnhancedUI = true;

int OnInit()
{
   // Inizializzazione di OmniEA
   // ...
   
   // Inizializzazione del trade
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   
   // Inizializzazione del panel manager
   g_panelManager = new CEnhancedPanelManager();
   if(!g_panelManager.Initialize(Symbol()))
   {
      Print("Errore nell'inizializzazione del panel manager");
      return INIT_FAILED;
   }
   
   // Abilita l'UI avanzata se richiesto
   if(EnableEnhancedUI)
      g_panelManager.EnableEnhancedUI();
   
   return INIT_SUCCEEDED;
}
```

### Fase 4: Test e deployment
1. Testare completamente nell'ambiente di sviluppo
2. Creare backup completo della directory MQL5 operativa
3. Preparare uno script di installazione
4. Testare l'installazione in un ambiente controllato
5. Documentare la procedura di rollback in caso di problemi

## CONSIDERAZIONI IMPORTANTI

- **Approccio non invasivo**: Tutto lo sviluppo avviene in ambiente isolato per garantire la sicurezza del codice operativo
- **Modularità**: L'architettura permette di abilitare/disabilitare singoli componenti
- **Compatibilità**: La struttura è progettata per essere compatibile con tutte le versioni di OmniEA utilizzate dalle diverse AI
- **Backup preventivo**: Prima dell'integrazione con il codice operativo, è essenziale eseguire un backup completo

## PROSSIMI PASSI IMMEDIATI

1. Implementare il pannello di monitoraggio multi-valuta basato su Panel Multicurrency
2. Implementare il pannello di gestione del rischio basato su SL_Calculator
3. Creare script di test per verificare il funzionamento dei componenti
4. Sviluppare il wrapper per integrare con il PanelManager esistente di OmniEA

## REGOLE FONDAMENTALI DA RISPETTARE

1. **Non modificare direttamente** i file nella directory MQL5 operativa
2. **Testare completamente** ogni componente prima dell'integrazione
3. **Documentare ogni passaggio** per facilitare la manutenzione futura
4. **Mantenere la compatibilità** con tutte le versioni di OmniEA
5. **Seguire le convenzioni di codice** stabilite da BlueTrendTeam
