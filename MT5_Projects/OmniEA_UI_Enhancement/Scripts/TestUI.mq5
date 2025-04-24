//+------------------------------------------------------------------+
//|                                                    TestUI.mq5 |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                 https://www.bluetrendteam.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"
#property version   "1.00"
#property script_show_inputs

#include "..\Include\ui\panels\TradingPanel.mqh"
#include "..\Include\ui\panels\MultiCurrencyPanel.mqh"
#include "..\Include\ui\panels\RiskPanel.mqh"

// Input parameters
input bool ShowTradingPanel = true;       // Show Trading Panel
input bool ShowMultiCurrencyPanel = true; // Show Multi-Currency Panel
input bool ShowRiskPanel = true;          // Show Risk Panel

// Global variables
CTradingPanel *g_tradingPanel = NULL;
CMultiCurrencyPanel *g_multiCurrencyPanel = NULL;
CRiskPanel *g_riskPanel = NULL;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   // Create panels
   if(ShowTradingPanel)
   {
      g_tradingPanel = new CTradingPanel();
      if(!g_tradingPanel.Create("TestTradingPanel"))
      {
         Print("Error creating Trading Panel");
         return;
      }
      
      // Position the panel
      g_tradingPanel.SetBounds(20, 20, 300, 400);
   }
   
   if(ShowMultiCurrencyPanel)
   {
      g_multiCurrencyPanel = new CMultiCurrencyPanel();
      if(!g_multiCurrencyPanel.Create("TestMultiCurrencyPanel"))
      {
         Print("Error creating Multi-Currency Panel");
         return;
      }
      
      // Position the panel
      g_multiCurrencyPanel.SetBounds(330, 20, 600, 400);
   }
   
   if(ShowRiskPanel)
   {
      g_riskPanel = new CRiskPanel();
      if(!g_riskPanel.Create("TestRiskPanel"))
      {
         Print("Error creating Risk Panel");
         return;
      }
      
      // Position the panel
      g_riskPanel.SetBounds(20, 430, 300, 250);
   }
   
   // Display message
   Print("UI Test started. Press ESC to exit.");
   
   // Wait for user to close the script
   while(!IsStopped())
   {
      // Process events
      ChartRedraw();
      Sleep(100);
   }
   
   // Cleanup
   if(g_tradingPanel != NULL)
   {
      delete g_tradingPanel;
      g_tradingPanel = NULL;
   }
   
   if(g_multiCurrencyPanel != NULL)
   {
      delete g_multiCurrencyPanel;
      g_multiCurrencyPanel = NULL;
   }
   
   if(g_riskPanel != NULL)
   {
      delete g_riskPanel;
      g_riskPanel = NULL;
   }
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Pass events to panels
   if(g_tradingPanel != NULL)
      g_tradingPanel.ProcessEvent(id, lparam, dparam, sparam);
      
   if(g_multiCurrencyPanel != NULL)
      g_multiCurrencyPanel.ProcessEvent(id, lparam, dparam, sparam);
      
   if(g_riskPanel != NULL)
      g_riskPanel.ProcessEvent(id, lparam, dparam, sparam);
}
