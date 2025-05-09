//+------------------------------------------------------------------+
//|                     TrendMasterPro.mq5                           |
//|                Expert Advisor con Trendline Dinamiche            |
//|                     Versione 10.2 - MT5 Compatibile              |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property link      "https://www.yoursite.com"
#property version   "10.2"
#property strict
#property description "EA avanzato con trendline dinamiche e gestione rischio"
#property description " "
#property description "PARAMETRI CONSIGLIATI:"
#property description "TF H1: LeftBars=12, RightBars=3, MinSlope=20"
#property description "TF H4: LeftBars=24, RightBars=5, MinSlope=15"
#property description "Risk: 1-2%, SL: 30-50pips, TP: 60-100pips"
#property description "Trailing: Distance 20-30pips, Step 10pips"
#property description " "
#property description "FILTRI: MaxSpread 20-30pips, MinATR 10-20pips"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>
CTrade Trade;
CPositionInfo PositionInfo;
COrderInfo OrderInfo;
CDealInfo DealInfo;

//+------------------------------------------------------------------+
//| Definizioni e Enum                                               |
//+------------------------------------------------------------------+
enum ENUM_TRADE_MODE {
   TRADE_MODE_BOTH,     // Buy/Sell
   TRADE_MODE_BUY_ONLY, // Solo Buy
   TRADE_MODE_SELL_ONLY // Solo Sell
};

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input group "==== IMPOSTAZIONI FONDAMENTALI ===="
input double LotSize = 0.1;                // Dimensione posizione base
input int StopLossPips = 50;               // Stop Loss (pips)
input int TakeProfitPips = 100;            // Take Profit (pips)
input int MaxSlippage = 3;                 // Slippage massimo (pips)
input int MagicNumber = 202410;            // Magic Number
input ENUM_TRADE_MODE TradeMode = TRADE_MODE_BOTH; // Modalità trading

input group "==== IMPOSTAZIONI TRENDLINE ===="
input double MinSlopeAngle = 15.0;         // Angolo minimo trendline (gradi)
input int LeftBars = 12;                   // Barre per estremo sinistro
input int RightBars = 3;                   // Barre per estremo destro

input group "==== GESTIONE RISCHIO AVANZATA ===="
input bool UseMoneyManagement = true;      // Money management automatico
input double RiskPercent = 1.5;            // Rischio per trade (% capitale)
input bool UseTrailingStop = true;         // Attiva trailing stop
input int TrailingStopDistance = 25;       // Distanza trailing (pips)
input int TrailingStep = 10;               // Step trailing (pips)

input group "==== FILTRI DI MERCATO ===="
input double MinATR = 10.0;                // Min ATR per trading (pips)
input int MaxSpread = 20;                  // Spread massimo (pips)
input int MinBarsAfterTrade = 3;           // Barre minime tra un trade e l'altro

//+------------------------------------------------------------------+
//| Variabili Globali                                                |
//+------------------------------------------------------------------+
double currentResistance = 0;
double currentSupport = 0;
datetime lastBarTime;
double dynamicLotSize = 0;
datetime lastTradeTime = 0;
int atrHandle;

//+------------------------------------------------------------------+
//| Funzioni di utilità                                              |
//+------------------------------------------------------------------+

bool IsNewBar()
{
   datetime currentTime = iTime(_Symbol, _Period, 0);
   if(lastBarTime != currentTime)
   {
      lastBarTime = currentTime;
      return true;
   }
   return false;
}

string GetDeinitReasonText(int reason)
{
   switch(reason)
   {
      case REASON_PROGRAM:        return "Terminato dall'utente";
      case REASON_REMOVE:         return "Rimosso dal grafico";
      case REASON_RECOMPILE:      return "Ricompilato";
      case REASON_CHARTCHANGE:    return "Cambiato timeframe/simbolo";
      case REASON_CHARTCLOSE:     return "Grafico chiuso";
      case REASON_PARAMETERS:     return "Parametri modificati";
      case REASON_ACCOUNT:        return "Account cambiato";
      default:                    return "Motivo sconosciuto";
   }
}

bool IsTradeTimeValid()
{
   if(MinBarsAfterTrade <= 0) return true;
   if(lastTradeTime == 0) return true;
   
   int barsSinceLastTrade = iBarShift(_Symbol, _Period, lastTradeTime);
   return (barsSinceLastTrade >= MinBarsAfterTrade);
}

//+------------------------------------------------------------------+
//| Expert Initialization Function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   Trade.SetExpertMagicNumber(MagicNumber);
   atrHandle = iATR(_Symbol, _Period, 14);
   
   //--- Verifica parametri input
   if(!ValidateInputs())
   {
      Alert("Parametri non validi! Controllare i valori inseriti.");
      return INIT_PARAMETERS_INCORRECT;
   }
   
   //--- Inizializzazione tempo
   lastBarTime = iTime(_Symbol, _Period, 0);
   
   //--- Creazione oggetti grafici
   CreateTrendLineObjects();
   
   //--- Messaggio iniziale
   Comment("TrendMasterPro v10.2\nCaricato con successo su ", _Symbol, " ", EnumToString(_Period));
   
   Print("=== INIZIALIZZAZIONE COMPLETATA ===");
   Print("Simbolo: ", _Symbol, " | Timeframe: ", EnumToString(_Period));
   Print("Modalità Trading: ", EnumToString(TradeMode));
   Print("Money Management: ", UseMoneyManagement ? "Attivo" : "Disattivo");
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert Deinitialization Function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Pulizia oggetti grafici
   ObjectsDeleteAll(0, -1, OBJ_TREND);
   
   //--- Rimuovi handle indicatori
   IndicatorRelease(atrHandle);
   
   //--- Messaggio di chiusura
   Comment("");
   Print("EA rimosso con motivo: ", GetDeinitReasonText(reason));
}

//+------------------------------------------------------------------+
//| Expert Tick Function                                            |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Verifiche preliminari
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) return;
   if(!IsNewBar()) return;
   if(!CheckMarketConditions()) return;
   
   //--- Calcolo lotto dinamico
   CalculateDynamicLotSize();
   
   //--- Aggiornamento trendline
   CalculateAndDrawTrendLines();
   
   //--- Gestione posizioni aperte
   if(UseTrailingStop && PositionsTotal() > 0)
      ManageTrailingStop();
   
   //--- Verifica condizioni trading
   if(IsNewBar() && IsTradeTimeValid())
      CheckTradingConditions();
}

//+------------------------------------------------------------------+
//| Funzioni Principali                                             |
//+------------------------------------------------------------------+

bool ValidateInputs()
{
   if(LotSize <= 0 || StopLossPips <= 0 || TakeProfitPips <= 0)
   {
      Alert("Errore: LotSize, StopLoss e TakeProfit devono essere > 0");
      return false;
   }
   
   if(LeftBars <= RightBars)
   {
      Alert("Errore: LeftBars deve essere maggiore di RightBars");
      return false;
   }
   
   if(RiskPercent <= 0 || RiskPercent > 100)
   {
      Alert("Errore: RiskPercent deve essere tra 0.1 e 100");
      return false;
   }
   
   return true;
}

void CreateTrendLineObjects()
{
   // Trendline di Supporto (rialzista)
   ObjectCreate(0, "TL_Support", OBJ_TREND, 0, 0, 0);
   ObjectSetInteger(0, "TL_Support", OBJPROP_COLOR, clrDodgerBlue);
   ObjectSetInteger(0, "TL_Support", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "TL_Support", OBJPROP_RAY_RIGHT, true);
   ObjectSetInteger(0, "TL_Support", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "TL_Support", OBJPROP_HIDDEN, true);
   
   // Trendline di Resistenza (ribassista)
   ObjectCreate(0, "TL_Resistance", OBJ_TREND, 0, 0, 0);
   ObjectSetInteger(0, "TL_Resistance", OBJPROP_COLOR, clrOrangeRed);
   ObjectSetInteger(0, "TL_Resistance", OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, "TL_Resistance", OBJPROP_RAY_RIGHT, true);
   ObjectSetInteger(0, "TL_Resistance", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, "TL_Resistance", OBJPROP_HIDDEN, true);
   
   Print("Oggetti trendline creati con successo");
}

void CalculateDynamicLotSize()
{
   if(!UseMoneyManagement)
   {
      dynamicLotSize = LotSize;
      return;
   }
   
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   if(_Digits == 3 || _Digits == 5) tickValue *= 10;
   
   double riskAmount = AccountInfoDouble(ACCOUNT_BALANCE) * RiskPercent / 100;
   double lotSize = riskAmount / (StopLossPips * tickValue);
   
   //--- Normalizza e applica limiti
   lotSize = NormalizeDouble(lotSize, 2);
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   dynamicLotSize = MathMin(MathMax(lotSize, minLot), maxLot);
   
   Print("Lotto calcolato: ", dynamicLotSize, " (Rischio: ", RiskPercent, "%)");
}

bool CheckMarketConditions()
{
   //--- Controllo spread
   double spread = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int spreadPips = (int)(spread / _Point);
   if(spreadPips > MaxSpread)
   {
      Print("Spread attuale ", spreadPips, " > massimo consentito ", MaxSpread);
      return false;
   }
   
   //--- Filtro volatilità
   if(MinATR > 0)
   {
      double atrValue[1];
      if(CopyBuffer(atrHandle, 0, 0, 1, atrValue) != 1)
      {
         Print("Errore nel calcolo ATR: ", GetLastError());
         return false;
      }
      
      if(atrValue[0] < MinATR * _Point)
      {
         Print("Volatilità insufficiente. ATR: ", NormalizeDouble(atrValue[0]/_Point, 1), " < minimo richiesto: ", MinATR);
         return false;
      }
   }
   
   return true;
}

void CalculateAndDrawTrendLines()
{
   double high[], low[];
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   
   if(CopyHigh(_Symbol, _Period, 0, LeftBars+RightBars, high) <= 0)
   {
      Print("Errore copia dati high: ", GetLastError());
      return;
   }
   
   if(CopyLow(_Symbol, _Period, 0, LeftBars+RightBars, low) <= 0)
   {
      Print("Errore copia dati low: ", GetLastError());
      return;
   }
   
   // Trova massimi per resistenza
   int maxLeftIdx = ArrayMaximum(high, RightBars, LeftBars);
   int maxRightIdx = ArrayMaximum(high, 0, RightBars);
   
   // Trova minimi per supporto
   int minLeftIdx = ArrayMinimum(low, RightBars, LeftBars);
   int minRightIdx = ArrayMinimum(low, 0, RightBars);
   
   if(maxLeftIdx == -1 || maxRightIdx == -1 || minLeftIdx == -1 || minRightIdx == -1)
   {
      Print("Impossibile trovare punti estremi validi");
      return;
   }
   
   // Calcola pendenze
   double angleFilter = tan(MinSlopeAngle * M_PI / 180.0);
   double slopeResistance = (high[maxRightIdx] - high[maxLeftIdx]) / (maxRightIdx - maxLeftIdx);
   double slopeSupport = (low[minRightIdx] - low[minLeftIdx]) / (minRightIdx - minLeftIdx);
   
   // Aggiorna trendline resistenza
   UpdateTrendLine("TL_Resistance", high[maxLeftIdx], high[maxRightIdx], 
                  maxLeftIdx, maxRightIdx, slopeResistance, -angleFilter, currentResistance);
   
   // Aggiorna trendline supporto
   UpdateTrendLine("TL_Support", low[minLeftIdx], low[minRightIdx], 
                  minLeftIdx, minRightIdx, slopeSupport, angleFilter, currentSupport);
}

void UpdateTrendLine(string name, double price1, double price2, 
                    int idx1, int idx2, double slope, double threshold, double &currentLevel)
{
   datetime time1 = iTime(_Symbol, _Period, idx1);
   datetime time2 = iTime(_Symbol, _Period, idx2);
   
   if((slope >= threshold && threshold > 0) || (slope <= threshold && threshold < 0))
   {
      ObjectMove(0, name, 0, time1, price1);
      ObjectMove(0, name, 1, time2, price2);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
      currentLevel = price2;
   }
   else
   {
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      currentLevel = 0;
   }
}

void ManageTrailingStop()
{
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket) && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
      {
         double currentStop = PositionGetDouble(POSITION_SL);
         double newStop = currentStop;
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
         
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         {
            double trailLevel = currentPrice - TrailingStopDistance * _Point;
            if(trailLevel > currentStop && (trailLevel > openPrice || currentStop <= openPrice))
               newStop = NormalizeDouble(trailLevel, _Digits);
         }
         else
         {
            double trailLevel = currentPrice + TrailingStopDistance * _Point;
            if(trailLevel < currentStop && (trailLevel < openPrice || currentStop >= openPrice))
               newStop = NormalizeDouble(trailLevel, _Digits);
         }
         
         if(newStop != currentStop)
         {
            Trade.PositionModify(ticket, newStop, PositionGetDouble(POSITION_TP));
         }
      }
   }
}

void CheckTradingConditions()
{
   if(PositionsTotal() > 0) return;
   
   MqlRates rates[];
   if(CopyRates(_Symbol, _Period, 0, 3, rates) < 3)
   {
      Print("Errore copia dati candele: ", GetLastError());
      return;
   }
   
   // Breakout resistenza (BUY)
   if((TradeMode == TRADE_MODE_BOTH || TradeMode == TRADE_MODE_BUY_ONLY) &&
      currentResistance != 0 && rates[1].close > currentResistance)
   {
      double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double sl = NormalizeDouble(entry - StopLossPips * _Point, _Digits);
      double tp = NormalizeDouble(entry + TakeProfitPips * _Point, _Digits);
      
      if(VerifyTradeLevels(entry, sl, tp))
      {
         Trade.Buy(dynamicLotSize, _Symbol, entry, sl, tp, "Breakout Resistenza");
         lastTradeTime = iTime(_Symbol, _Period, 0);
      }
   }
   
   // Breakout supporto (SELL)
   if((TradeMode == TRADE_MODE_BOTH || TradeMode == TRADE_MODE_SELL_ONLY) &&
      currentSupport != 0 && rates[1].close < currentSupport)
   {
      double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double sl = NormalizeDouble(entry + StopLossPips * _Point, _Digits);
      double tp = NormalizeDouble(entry - TakeProfitPips * _Point, _Digits);
      
      if(VerifyTradeLevels(entry, sl, tp))
      {
         Trade.Sell(dynamicLotSize, _Symbol, entry, sl, tp, "Breakout Supporto");
         lastTradeTime = iTime(_Symbol, _Period, 0);
      }
   }
}

bool VerifyTradeLevels(double entry, double sl, double tp)
{
   // Controllo distanza minima
   double minDist = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   if(MathAbs(entry - sl) < minDist)
   {
      Print("SL troppo vicino al prezzo. Distanza: ", MathAbs(entry - sl) / _Point, " pips");
      return false;
   }
   
   if(MathAbs(entry - tp) < minDist)
   {
      Print("TP troppo vicino al prezzo. Distanza: ", MathAbs(entry - tp) / _Point, " pips");
      return false;
   }
   
   // Controllo margine
   double marginCheck = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double marginRequired;
   if(!OrderCalcMargin(ORDER_TYPE_BUY, _Symbol, dynamicLotSize, entry, marginRequired))
   {
      Print("Errore nel calcolo del margine richiesto");
      return false;
   }
   
   if(marginCheck < marginRequired)
   {
      Print("Margine insufficiente per aprire posizione. Richiesto: ", marginRequired);
      return false;
   }
   
   // Controllo tempo dall'ultimo trade
   if(MinBarsAfterTrade > 0 && iBarShift(_Symbol, _Period, lastTradeTime) < MinBarsAfterTrade)
   {
      Print("Tempo insufficiente dall'ultimo trade. Barre: ", iBarShift(_Symbol, _Period, lastTradeTime));
      return false;
   }
   
   return true;
}
//+------------------------------------------------------------------+