//+------------------------------------------------------------------+
//|                               TestWFOIntegration.mq5 |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                       AlgoWi Implementation   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"
#property script_show_inputs

// Includi le librerie standard
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

// Includi l'integrazione del Walk Forward Optimizer
#include "..\..\Include\omniea\WFOIntegration.mqh"

// Input per la configurazione del Walk Forward Optimizer
input group "=== Walk Forward Optimizer Settings ==="
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
input string WFO_OutputFile = "wfo_test_results.txt";

// Dichiarazioni globali
CWFOIntegration *g_wfoIntegration = NULL;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   // Messaggio di inizio test
   Print("=== TEST WALK FORWARD OPTIMIZER INTEGRATION ===");
   
   // Test 1: Creazione dell'istanza
   Print("Test 1: Creazione dell'istanza di CWFOIntegration");
   g_wfoIntegration = new CWFOIntegration();
   if(g_wfoIntegration == NULL)
   {
      Print("ERRORE: Impossibile creare l'istanza di CWFOIntegration");
      return;
   }
   Print("OK: Istanza di CWFOIntegration creata con successo");
   
   // Test 2: Inizializzazione
   Print("Test 2: Inizializzazione di CWFOIntegration");
   if(!g_wfoIntegration.Initialize(WFO_WindowSize, WFO_StepSize, WFO_StepOffset, WFO_CustomWindowSizeDays, WFO_CustomStepSizePercent))
   {
      Print("ERRORE: Impossibile inizializzare CWFOIntegration");
      delete g_wfoIntegration;
      return;
   }
   Print("OK: CWFOIntegration inizializzato con successo");
   
   // Test 3: Configurazione
   Print("Test 3: Configurazione di CWFOIntegration");
   g_wfoIntegration.SetEstimationMethod(WFO_Estimation, WFO_Formula);
   g_wfoIntegration.SetPFMax(WFO_PFMax);
   g_wfoIntegration.SetCloseTradesOnSeparationLine(WFO_CloseTradesOnSeparationLine);
   g_wfoIntegration.SetOutputFile(WFO_OutputFile);
   Print("OK: CWFOIntegration configurato con successo");
   
   // Test 4: Abilitazione
   Print("Test 4: Abilitazione di CWFOIntegration");
   g_wfoIntegration.Enable(EnableWFO);
   if(g_wfoIntegration.IsEnabled() != EnableWFO)
   {
      Print("ERRORE: Impossibile abilitare/disabilitare CWFOIntegration");
      delete g_wfoIntegration;
      return;
   }
   Print("OK: CWFOIntegration abilitato/disabilitato con successo");
   
   // Test 5: OnInit
   Print("Test 5: OnInit di CWFOIntegration");
   int result = g_wfoIntegration.OnInit();
   if(result != INIT_SUCCEEDED)
   {
      Print("ERRORE: OnInit di CWFOIntegration ha restituito ", result);
      delete g_wfoIntegration;
      return;
   }
   Print("OK: OnInit di CWFOIntegration eseguito con successo");
   
   // Test 6: OnTick
   Print("Test 6: OnTick di CWFOIntegration");
   int tick_result = g_wfoIntegration.OnTick();
   Print("OK: OnTick di CWFOIntegration ha restituito ", tick_result);
   
   // Test 7: OnTester
   Print("Test 7: OnTester di CWFOIntegration");
   double tester_result = g_wfoIntegration.OnTester();
   Print("OK: OnTester di CWFOIntegration ha restituito ", tester_result);
   
   // Test 8: OnTesterInit
   Print("Test 8: OnTesterInit di CWFOIntegration");
   g_wfoIntegration.OnTesterInit();
   Print("OK: OnTesterInit di CWFOIntegration eseguito");
   
   // Test 9: OnTesterDeinit
   Print("Test 9: OnTesterDeinit di CWFOIntegration");
   g_wfoIntegration.OnTesterDeinit();
   Print("OK: OnTesterDeinit di CWFOIntegration eseguito");
   
   // Test 10: OnTesterPass
   Print("Test 10: OnTesterPass di CWFOIntegration");
   g_wfoIntegration.OnTesterPass();
   Print("OK: OnTesterPass di CWFOIntegration eseguito");
   
   // Pulizia
   Print("Pulizia delle risorse");
   delete g_wfoIntegration;
   g_wfoIntegration = NULL;
   
   // Messaggio di fine test
   Print("=== TEST COMPLETATO CON SUCCESSO ===");
}
