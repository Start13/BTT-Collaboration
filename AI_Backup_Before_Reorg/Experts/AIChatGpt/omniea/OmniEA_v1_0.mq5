//+------------------------------------------------------------------+
//|                                                      OmniEA.mq5 |
//|        OmniEA Lite v1.0 - by BlueTrendTeam                      |
//+------------------------------------------------------------------+
#property copyright   "BlueTrendTeam"
#property version     "1.00"
#property strict

#include <AIChatGpt\omniea\TradeExecutor.mqh>


string g_lang = "it";  // Variabile globale lingua

int OnInit()
  {
   Print("[OmniEA] Inizializzazione completata");
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   Print("[OmniEA] EA terminato. Codice: ", reason);
  }

void OnTick()
  {
   DrawNotification("Benvenuto in OmniEA", clrAqua);
  }

void DrawNotification(string testo, color c = clrWhite)
  {
   Print("[NOTIFICA]: ", testo);
  }

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   // In futuro: gestire eventi click UI qui
  }
