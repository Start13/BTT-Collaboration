//+------------------------------------------------------------------+
//|                                          OmniEA_UI_Test.mq5 |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                 https://www.bluetrendteam.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"

// Include necessari
#include <Trade\Trade.mqh>
#include "..\..\Include\omniea\PanelManager.mqh"  // Versione estesa

// Input parameters
input bool EnableEnhancedUI = true;          // Enable Enhanced UI
input double RiskPercent = 1.0;              // Risk Percent (%)
input int StopLossPoints = 100;              // Stop Loss (points)
input int TakeProfitPoints = 200;            // Take Profit (points)
input int MagicNumber = 123456;              // Magic Number
input int Slippage = 10;                     // Slippage (points)

// Dichiarazioni globali
CTrade trade;
CEnhancedPanelManager *g_panelManager = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione del trade
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   
   // Inizializzazione del panel manager
   g_panelManager = new CEnhancedPanelManager();
   if(!g_panelManager.Initialize(Symbol()))
   {
      Print("Error initializing panel manager");
      return INIT_FAILED;
   }
   
   // Abilita l'UI avanzata se richiesto
   if(EnableEnhancedUI)
      g_panelManager.EnableEnhancedUI();
   
   // Configura il pannello di gestione del rischio
   if(EnableEnhancedUI)
   {
      CRiskPanel *riskPanel = g_panelManager.GetRiskPanel();
      if(riskPanel != NULL)
      {
         riskPanel.SetRiskPercent(RiskPercent);
         riskPanel.SetStopLossPoints(StopLossPoints);
      }
   }
   
   // Messaggio di benvenuto
   Print("OmniEA UI Test initialized successfully");
   Print("Enhanced UI: ", (EnableEnhancedUI ? "Enabled" : "Disabled"));
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Pulizia del panel manager
   if(g_panelManager != NULL)
   {
      g_panelManager.Shutdown();
      delete g_panelManager;
      g_panelManager = NULL;
   }
   
   Print("OmniEA UI Test deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // In questa versione di test, non eseguiamo operazioni di trading automatiche
   // Il trading viene gestito tramite i pannelli UI
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Gestione eventi del panel manager
   if(g_panelManager != NULL)
      g_panelManager.ProcessEvent(id, lparam, dparam, sparam);
}

//+------------------------------------------------------------------+
//| Funzioni di trading                                              |
//+------------------------------------------------------------------+
bool OpenBuyPosition(double volume, double sl = 0, double tp = 0)
{
   // Calcola i livelli di stop loss e take profit
   double stopLoss = 0;
   double takeProfit = 0;
   
   if(sl > 0)
      stopLoss = SymbolInfoDouble(Symbol(), SYMBOL_BID) - sl * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
      
   if(tp > 0)
      takeProfit = SymbolInfoDouble(Symbol(), SYMBOL_BID) + tp * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
   
   // Apri la posizione di acquisto
   return trade.Buy(volume, Symbol(), 0, stopLoss, takeProfit, "OmniEA Buy");
}

bool OpenSellPosition(double volume, double sl = 0, double tp = 0)
{
   // Calcola i livelli di stop loss e take profit
   double stopLoss = 0;
   double takeProfit = 0;
   
   if(sl > 0)
      stopLoss = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + sl * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
      
   if(tp > 0)
      takeProfit = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - tp * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
   
   // Apri la posizione di vendita
   return trade.Sell(volume, Symbol(), 0, stopLoss, takeProfit, "OmniEA Sell");
}

bool CloseAllPositions()
{
   bool result = true;
   
   // Chiudi tutte le posizioni aperte
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == Symbol() && 
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            if(!trade.PositionClose(PositionGetTicket(i)))
               result = false;
         }
      }
   }
   
   return result;
}
