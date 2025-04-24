//+------------------------------------------------------------------+
//|                                  OmniEA_WFO_Test.mq5 |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                       AlgoWi Implementation   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"

// Includi le librerie standard
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

// Includi l'integrazione del Walk Forward Optimizer
#include "..\..\Include\omniea\WFOIntegration.mqh"

// Dichiarazioni globali
CTrade trade;
CSymbolInfo symbolInfo;
CAccountInfo accountInfo;
CWFOIntegration *g_wfoIntegration = NULL;

// Input per la configurazione del Walk Forward Optimizer
input bool EnableWFO = true;
input WFO_TIME_PERIOD WFO_WindowSize = year;
input WFO_TIME_PERIOD WFO_StepSize = quarter;
input int WFO_StepOffset = 0;
input int WFO_CustomWindowSizeDays = 0;
input int WFO_CustomStepSizePercent = 0;
input WFO_ESTIMATION_METHOD WFO_Estimation = wfo_built_in_loose;
input string WFO_Formula = "";
input double WFO_PFMax = 100.0;
input bool WFO_CloseTradesOnSeparationLine = false;
input string WFO_OutputFile = "wfo_results.txt";

// Input per la configurazione del trading
input int MagicNumber = 12345;
input int Slippage = 5;
input double LotSize = 0.1;
input int StopLoss = 100;
input int TakeProfit = 200;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inizializzazione del trade
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   
   // Inizializzazione del symbolInfo
   if(!symbolInfo.Name(_Symbol))
   {
      Print("Error initializing symbol info");
      return INIT_FAILED;
   }
   
   // Inizializzazione dell'integrazione del Walk Forward Optimizer
   g_wfoIntegration = new CWFOIntegration();
   if(!g_wfoIntegration.Initialize(WFO_WindowSize, WFO_StepSize, WFO_StepOffset, WFO_CustomWindowSizeDays, WFO_CustomStepSizePercent))
   {
      Print("Error initializing WFO integration");
      return INIT_FAILED;
   }
   
   // Configurazione dell'integrazione del Walk Forward Optimizer
   g_wfoIntegration.SetEstimationMethod(WFO_Estimation, WFO_Formula);
   g_wfoIntegration.SetPFMax(WFO_PFMax);
   g_wfoIntegration.SetCloseTradesOnSeparationLine(WFO_CloseTradesOnSeparationLine);
   g_wfoIntegration.SetOutputFile(WFO_OutputFile);
   
   // Abilita l'integrazione del Walk Forward Optimizer se richiesto
   g_wfoIntegration.Enable(EnableWFO);
   
   // Inizializza l'integrazione del Walk Forward Optimizer
   int result = g_wfoIntegration.OnInit();
   if(result != INIT_SUCCEEDED)
   {
      Print("Error initializing WFO: ", result);
      return result;
   }
   
   Print("OmniEA WFO Test initialized successfully");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Pulizia dell'integrazione del Walk Forward Optimizer
   if(g_wfoIntegration != NULL)
   {
      delete g_wfoIntegration;
      g_wfoIntegration = NULL;
   }
   
   Print("OmniEA WFO Test deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Aggiorna i dati del simbolo
   symbolInfo.RefreshRates();
   
   // Verifica se il Walk Forward Optimizer consente il trading
   if(g_wfoIntegration != NULL && g_wfoIntegration.IsEnabled())
   {
      int wfo = g_wfoIntegration.OnTick();
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
   }
   
   // Logica di trading di OmniEA
   // Questo è solo un esempio semplificato, la logica reale sarebbe più complessa
   
   // Verifica se ci sono già posizioni aperte
   if(PositionsTotal() > 0)
      return;
   
   // Calcola i segnali di trading (esempio semplificato)
   double ma20 = iMA(_Symbol, PERIOD_CURRENT, 20, 0, MODE_SMA, PRICE_CLOSE);
   double ma50 = iMA(_Symbol, PERIOD_CURRENT, 50, 0, MODE_SMA, PRICE_CLOSE);
   
   // Ottieni i valori delle medie mobili
   double ma20Value[1], ma50Value[1];
   if(CopyBuffer(ma20, 0, 0, 1, ma20Value) <= 0 || CopyBuffer(ma50, 0, 0, 1, ma50Value) <= 0)
      return;
   
   // Segnali di trading
   bool buySignal = ma20Value[0] > ma50Value[0];
   bool sellSignal = ma20Value[0] < ma50Value[0];
   
   // Esegui le operazioni di trading
   if(buySignal)
   {
      double sl = (StopLoss > 0) ? symbolInfo.Ask() - StopLoss * _Point : 0;
      double tp = (TakeProfit > 0) ? symbolInfo.Ask() + TakeProfit * _Point : 0;
      trade.Buy(LotSize, _Symbol, symbolInfo.Ask(), sl, tp, "OmniEA WFO Test");
   }
   else if(sellSignal)
   {
      double sl = (StopLoss > 0) ? symbolInfo.Bid() + StopLoss * _Point : 0;
      double tp = (TakeProfit > 0) ? symbolInfo.Bid() - TakeProfit * _Point : 0;
      trade.Sell(LotSize, _Symbol, symbolInfo.Bid(), sl, tp, "OmniEA WFO Test");
   }
}

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
   // Se l'integrazione del Walk Forward Optimizer è abilitata, utilizza il suo OnTester
   if(g_wfoIntegration != NULL && g_wfoIntegration.IsEnabled())
      return g_wfoIntegration.OnTester();
   
   // Altrimenti, restituisci un valore personalizzato
   // Questo è solo un esempio, la logica reale sarebbe più complessa
   double profit = TesterStatistics(STAT_PROFIT);
   double drawdown = TesterStatistics(STAT_BALANCE_DD);
   
   if(drawdown == 0)
      return profit;
   
   return profit / drawdown;
}

//+------------------------------------------------------------------+
//| TesterInit function                                              |
//+------------------------------------------------------------------+
void OnTesterInit()
{
   // Se l'integrazione del Walk Forward Optimizer è abilitata, utilizza il suo OnTesterInit
   if(g_wfoIntegration != NULL && g_wfoIntegration.IsEnabled())
      g_wfoIntegration.OnTesterInit();
}

//+------------------------------------------------------------------+
//| TesterDeinit function                                            |
//+------------------------------------------------------------------+
void OnTesterDeinit()
{
   // Se l'integrazione del Walk Forward Optimizer è abilitata, utilizza il suo OnTesterDeinit
   if(g_wfoIntegration != NULL && g_wfoIntegration.IsEnabled())
      g_wfoIntegration.OnTesterDeinit();
}

//+------------------------------------------------------------------+
//| TesterPass function                                              |
//+------------------------------------------------------------------+
void OnTesterPass()
{
   // Se l'integrazione del Walk Forward Optimizer è abilitata, utilizza il suo OnTesterPass
   if(g_wfoIntegration != NULL && g_wfoIntegration.IsEnabled())
      g_wfoIntegration.OnTesterPass();
}
