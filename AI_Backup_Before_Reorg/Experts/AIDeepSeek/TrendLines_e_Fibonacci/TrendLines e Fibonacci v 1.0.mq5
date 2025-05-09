//+------------------------------------------------------------------+
//|                                                      TrendMaster |
//|             EA con Descrizioni Unificate e Suggerimenti TF       |
//|                     Versione 6.4 - Descrizioni Compatte          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property version   "6.4"
#property strict
#property description "Strategia di breakout basata su trendline automatiche"
#property description " "
#property description "METODI TRENDLINE:"
#property description "[Estremi+Estremi] Trova 2 punti estremi per disegnare la linea"
#property description "[Estremo+Delta] Trova 1 estremo + punto con minima deviazione"
#property description " "
#property description "SUGGERIMENTI TIMEFRAME:"
#property description "M1-M15: Left=8, Right=2, Offset=2"
#property description "M30-H1: Left=10, Right=3, Offset=3"
#property description "H4-D1: Left=15, Right=4, Offset=4"
#property description "W1-MN1: Left=20, Right=5, Offset=5"
#property description " "
#property description "IMPOSTAZIONI:"
#property description "SL/TP: Rapporto consigliato 1:2"
#property description "Magic Number: Identificativo unico operazioni"

//--- Enum senza descrizioni ridondanti
enum ENUM_TRENDLINE_TYPE {TL_EXM_EXM, TL_EXM_DELTA};
enum ENUM_TRADE_DIRECTION {TRADE_BOTH, TRADE_BUY_ONLY, TRADE_SELL_ONLY};

//--- Input compatti
input group "==== Trading Settings ===="
input double LotSize = 0.1;
input int StopLossPips = 50;
input int TakeProfitPips = 100;
input int MaxSlippage = 3;
input int MagicNumber = 202406;
input ENUM_TRADE_DIRECTION TradeDirection = TRADE_BOTH;

input group "==== Trendline Settings ===="
input ENUM_TRENDLINE_TYPE TrendlineMode = TL_EXM_DELTA;
input int LeftExtremeBars = 10;
input int RightExtremeBars = 3;
input int OffsetFromCurrent = 3;

//--- Variabili Globali
double currentResistance, currentSupport;
datetime lastBarTime;
int trendHandle = INVALID_HANDLE;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Inizializzazione e caricamento indicatore (come prima)
   // ...
   return INIT_SUCCEEDED;
}

// ... [Resto del codice identico alle versioni precedenti] ...

//+------------------------------------------------------------------+
//| Funzioni per suggerimenti basati sul timeframe                   |
//+------------------------------------------------------------------+
int GetSuggestedLeftBars()
{
   ENUM_TIMEFRAMES tf = _Period;
   if(tf <= PERIOD_M15) return 8;
   if(tf <= PERIOD_H1) return 10;
   if(tf <= PERIOD_H4) return 15;
   return 20; // Per timeframe giornalieri o superiori
}

int GetSuggestedRightBars()
{
   ENUM_TIMEFRAMES tf = _Period;
   if(tf <= PERIOD_M15) return 2;
   if(tf <= PERIOD_H1) return 3;
   if(tf <= PERIOD_H4) return 4;
   return 5;
}

int GetSuggestedOffset()
{
   ENUM_TIMEFRAMES tf = _Period;
   if(tf <= PERIOD_M15) return 2;
   if(tf <= PERIOD_H1) return 3;
   return 4;
}

// ... [Resto del codice identico alla versione 6.2] ...

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // [Implementazione identica alla versione precedente]
   // ...
}

// [Altre funzioni identiche alla versione 6.2]
// ...