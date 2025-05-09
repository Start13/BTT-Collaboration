//+------------------------------------------------------------------+
//|                                      Gann Pivot v 1.01.mq5       |
//|                                    Corrado Bruni Copyright @2023 |
//|                                      https://www.cbalgotrade.com |
//+------------------------------------------------------------------+
#property copyright "Corrado Bruni"
#property link      "https://www.cbalgotrade.com"
#property version   "1.01"
#property strict

#include <Trade\Trade.mqh>

enum ENUM_TRADE_MODE { TRADE_BOTH = 0, TRADE_BUY_ONLY = 1, TRADE_SELL_ONLY = 2 };
enum ENUM_LINE_STYLE_GANN { GANN_STYLE_SOLID = STYLE_SOLID, GANN_STYLE_DASH = STYLE_DASH, GANN_STYLE_DOT = STYLE_DOT, GANN_STYLE_DASHDOT = STYLE_DASHDOT, GANN_STYLE_DASHDOTDOT = STYLE_DASHDOTDOT };
enum ENUM_LINE_STYLE_TREND { TREND_STYLE_SOLID = STYLE_SOLID, TREND_STYLE_DASH = STYLE_DASH, TREND_STYLE_DOT = STYLE_DOT, TREND_STYLE_DASHDOT = STYLE_DASHDOT, TREND_STYLE_DASHDOTDOT = STYLE_DASHDOTDOT };

// Input Parametri
input int LevelsToShow = 4;                  // Numero di livelli Gann da visualizzare
input color PivotColor = C'255,255,255';     // Colore del Pivot Daily
input color UpperLevelColor = C'0,255,0';    // Colore livelli superiori
input color LowerLevelColor = C'0,255,0';    // Colore livelli inferiori
input ENUM_LINE_STYLE_GANN GannLineStyle = GANN_STYLE_DOT;
input color TrendUpColor = C'0,255,0';       // Colore trend rialzista
input color TrendDownColor = C'255,0,0';     // Colore trend ribassista
input int LookbackBars = 50;                 // Barre per massimi/minimi
input int PivotWindow = 5;                   // Finestra per pivot
input ENUM_TIMEFRAMES TrendTimeframe = PERIOD_H1;
input ENUM_LINE_STYLE_TREND TrendLineStyle = TREND_STYLE_SOLID;
input color DemandColor = C'0,0,255';        // Colore zone demand
input color SupplyColor = C'255,0,0';        // Colore zone supply
input double ZoneHeight = 0.0020;            // Altezza zone
input ENUM_TIMEFRAMES ZoneTimeframe = PERIOD_H1;
input int LineWidth = 1;                     // Spessore linee
input ENUM_TRADE_MODE TradeMode = TRADE_BOTH;
input double RiskPercent = 1.0;              // Percentuale rischio
input int TrailingStartPips = 50;            // Pips per trailing start
input int TrailingStopPips = 20;             // Pips per trailing stop
input int InitialStopLossPips = 50;          // Pips stop loss iniziale
input int TakeProfitPips = 100;              // Pips take profit
input int BreakoutCandles = 2;               // Candele per breakout
input double MinATR = 0.5;                   // ATR minimo per breakout
input bool AvoidNews = true;                 // Evitare trading durante notizie
input int ZigZagDepth = 12;                  // Profondità ZigZag
input int ZigZagDeviation = 5;               // Deviazione ZigZag (%)
input int ZigZagBackstep = 3;                // Backstep ZigZag
input color ZigZagColor = C'255,215,0';      // Colore linee ZigZag
input color ZigZagChannelColor = C'255,165,0'; // Colore canali ZigZag

// Costanti
const int MIN_BARS_FOR_CALC = 5;
const int ZONE_CHECK_RANGE = 11;
const int ADX_PERIOD = 14;

// Variabili globali
double GannLevels[];
string LineNames[];
double PivotPrice;
string TrendUpName = "TrendUp", TrendUpUpperName = "TrendUpUpper";
string TrendDownName = "TrendDown", TrendDownLowerName = "TrendDownLower";
string DemandZoneName = "DemandZone_", SupplyZoneName = "SupplyZone_";
string ZigZagLineName = "ZigZagLine_", ZigZagChannelName = "ZigZagChannel_";
double FastDnPts[], FastUpPts[], SlowDnPts[], SlowUpPts[];
double ZoneHi[1000], ZoneLo[1000];
int ZoneStart[1000], ZoneHits[1000], ZoneType[1000], ZoneStrength[1000], ZoneCount = 0;
bool ZoneTurn[1000];
double ATR[];
int iATR_handle, iADX_handle, iZigZag_handle;
CTrade trade;

#define ZONE_SUPPORT 1
#define ZONE_RESIST  2
#define ZONE_WEAK      0
#define ZONE_TURNCOAT  1
#define ZONE_UNTESTED  2
#define ZONE_VERIFIED  3
#define ZONE_PROVEN    4
#define UP_POINT 1
#define DN_POINT -1

//+------------------------------------------------------------------+
int OnInit()
{
   ArrayResize(GannLevels, LevelsToShow * 2 + 1);
   ArrayResize(LineNames, LevelsToShow * 2 + 1);
   
   iATR_handle = iATR(_Symbol, TrendTimeframe, 7);
   iADX_handle = iADX(_Symbol, TrendTimeframe, ADX_PERIOD);
   iZigZag_handle = iCustom(_Symbol, TrendTimeframe, "Examples\\ZigZag", ZigZagDepth, ZigZagDeviation, ZigZagBackstep);
   if(iATR_handle == INVALID_HANDLE || iADX_handle == INVALID_HANDLE || iZigZag_handle == INVALID_HANDLE) {
      Print("Errore creazione indicatori");
      return(INIT_FAILED);
   }
   
   ArraySetAsSeries(FastDnPts, true);
   ArraySetAsSeries(FastUpPts, true);
   ArraySetAsSeries(SlowDnPts, true);
   ArraySetAsSeries(SlowUpPts, true);
   ArraySetAsSeries(ATR, true);
   
   CalculateDailyPivot();
   CalculateGannLevels();
   DrawGannLevels();
   ShowLevelsAsComment();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   for(int i = 0; i < ArraySize(LineNames); i++) ObjectDelete(0, LineNames[i]);
   ObjectDelete(0, TrendUpName);
   ObjectDelete(0, TrendUpUpperName);
   ObjectDelete(0, TrendDownName);
   ObjectDelete(0, TrendDownLowerName);
   DeleteZones();
   DeleteZigZagLines();
   Comment("");
   if(iATR_handle != INVALID_HANDLE) IndicatorRelease(iATR_handle);
   if(iADX_handle != INVALID_HANDLE) IndicatorRelease(iADX_handle);
   if(iZigZag_handle != INVALID_HANDLE) IndicatorRelease(iZigZag_handle);
}

//+------------------------------------------------------------------+
void OnTick()
{
   datetime currentDay = iTime(_Symbol, PERIOD_D1, 0);
   static datetime lastDay = 0;
   
   int bars = iBars(_Symbol, TrendTimeframe);
   double high[], low[], close[], zigzag[];
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(zigzag, true);
   CopyHigh(_Symbol, TrendTimeframe, 0, bars, high);
   CopyLow(_Symbol, TrendTimeframe, 0, bars, low);
   CopyClose(_Symbol, TrendTimeframe, 0, bars, close);
   CopyBuffer(iZigZag_handle, 0, 0, bars, zigzag);
   
   ArrayResize(ATR, 1);
   if(CopyBuffer(iATR_handle, 0, 0, 1, ATR) <= 0) return;
   
   if(currentDay != lastDay) {
      lastDay = currentDay;
      CalculateDailyPivot();
      CalculateGannLevels();
      DrawGannLevels();
      DrawTrendLines(high, low, close);
      DrawSupplyDemandZones(high, low, close);
      DrawZigZagLines(high, low, zigzag);
      ShowLevelsAsComment();
   } else {
      DrawTrendLines(high, low, close);
      DrawSupplyDemandZones(high, low, close);
      DrawZigZagLines(high, low, zigzag);
   }
   ManageTrailingStop();
}

//+------------------------------------------------------------------+
void CalculateDailyPivot()
{
   double high = iHigh(_Symbol, PERIOD_D1, 1);
   double low = iLow(_Symbol, PERIOD_D1, 1);
   double close = iClose(_Symbol, PERIOD_D1, 1);
   PivotPrice = NormalizeDouble((high + low + close) / 3, _Digits);
}

//+------------------------------------------------------------------+
void CalculateGannLevels()
{
   ArrayResize(GannLevels, LevelsToShow * 2 + 1);
   double priceFactor = MathPow(10, _Digits);
   double normalizedPivot = PivotPrice * priceFactor;
   double sqrtPivot = MathSqrt(normalizedPivot);
   double pivotRoot = MathFloor(sqrtPivot);
   
   GannLevels[LevelsToShow] = PivotPrice;
   for(int i = 1; i <= LevelsToShow; i++) {
      double upperRoot = pivotRoot + i;
      GannLevels[LevelsToShow + i] = NormalizeDouble(MathPow(upperRoot, 2) / priceFactor, _Digits);
      double lowerRoot = pivotRoot - i;
      GannLevels[LevelsToShow - i] = NormalizeDouble(MathPow(lowerRoot, 2) / priceFactor, _Digits);
   }
}

//+------------------------------------------------------------------+
void DrawGannLevels()
{
   for(int i = 0; i < ArraySize(GannLevels); i++) {
      if(GannLevels[i] <= 0) continue;
      string lineName = "GannLevel_" + DoubleToString(GannLevels[i], _Digits);
      LineNames[i] = lineName;
      if(ObjectFind(0, lineName) < 0) {
         ObjectCreate(0, lineName, OBJ_HLINE, 0, 0, GannLevels[i]);
         ObjectSetInteger(0, lineName, OBJPROP_COLOR, i == LevelsToShow ? PivotColor : (i > LevelsToShow ? UpperLevelColor : LowerLevelColor));
         ObjectSetInteger(0, lineName, OBJPROP_STYLE, GannLineStyle);
         ObjectSetInteger(0, lineName, OBJPROP_WIDTH, LineWidth);
         ObjectSetInteger(0, lineName, OBJPROP_BACK, false);
      } else {
         double currentPrice = ObjectGetDouble(0, lineName, OBJPROP_PRICE);
         if(currentPrice != GannLevels[i]) ObjectSetDouble(0, lineName, OBJPROP_PRICE, GannLevels[i]);
      }
   }
}

//+------------------------------------------------------------------+
void DrawTrendLines(double &high[], double &low[], double &close[])
{
   static datetime lastTrendTime = 0;
   datetime currentTime = iTime(_Symbol, TrendTimeframe, 0);
   if(currentTime == lastTrendTime) return;
   lastTrendTime = currentTime;
   
   int bars = iBars(_Symbol, TrendTimeframe);
   if(bars < LookbackBars + PivotWindow + 1) return;
   
   FindPivots(high, low);
   DrawUpTrend(high, low);
   DrawDownTrend(high, low);
   
   if(TradeMode != TRADE_SELL_ONLY) CheckBreakoutDown(high, low, close);
   if(TradeMode != TRADE_BUY_ONLY) CheckBreakoutUp(high, low, close);
}

//+------------------------------------------------------------------+
void FindPivots(double &high[], double &low[])
{
   int bars = iBars(_Symbol, TrendTimeframe); // Dichiarazione di 'bars'
   datetime timeLow1 = 0, timeLow2 = 0, timeHigh1 = 0, timeHigh2 = 0;
   double priceLow1 = 0, priceLow2 = 0, priceHigh1 = 0, priceHigh2 = 0;
   int lowCount = 0, highCount = 0;
   
   for(int i = PivotWindow; i < LookbackBars && (lowCount < 2 || highCount < 2); i++) {
      bool isLow = true, isHigh = true;
      double currentLow = low[i];
      double currentHigh = high[i];
      
      for(int j = 1; j <= PivotWindow; j++) {
         if(i - j < 0 || i + j >= bars) continue; // Controllo limiti array
         if(low[i - j] <= currentLow || low[i + j] <= currentLow) isLow = false;
         if(high[i - j] >= currentHigh || high[i + j] >= currentHigh) isHigh = false;
      }
      
      if(isLow && lowCount < 2) {
         if(lowCount == 0) { timeLow1 = iTime(_Symbol, TrendTimeframe, i); priceLow1 = currentLow; }
         else { timeLow2 = iTime(_Symbol, TrendTimeframe, i); priceLow2 = currentLow; }
         lowCount++;
      }
      if(isHigh && highCount < 2) {
         if(highCount == 0) { timeHigh1 = iTime(_Symbol, TrendTimeframe, i); priceHigh1 = currentHigh; }
         else { timeHigh2 = iTime(_Symbol, TrendTimeframe, i); priceHigh2 = currentHigh; }
         highCount++;
      }
   }
   
   if(lowCount == 2 && timeLow2 > timeLow1) { Swap(timeLow1, timeLow2); Swap(priceLow1, priceLow2); }
   if(highCount == 2 && timeHigh2 > timeHigh1) { Swap(timeHigh1, timeHigh2); Swap(priceHigh1, priceHigh2); }
   
   // Memorizza i pivot globalmente
   static datetime storedTimeLow1, storedTimeLow2, storedTimeHigh1, storedTimeHigh2;
   static double storedPriceLow1, storedPriceLow2, storedPriceHigh1, storedPriceHigh2;
   storedTimeLow1 = timeLow1; storedTimeLow2 = timeLow2;
   storedPriceLow1 = priceLow1; storedPriceLow2 = priceLow2;
   storedTimeHigh1 = timeHigh1; storedTimeHigh2 = timeHigh2;
   storedPriceHigh1 = priceHigh1; storedPriceHigh2 = priceHigh2;
}

//+------------------------------------------------------------------+
void DrawUpTrend(double &high[], double &low[])
{
   static datetime timeLow1, timeLow2;
   static double priceLow1, priceLow2;
   int bars = iBars(_Symbol, TrendTimeframe);
   
   if(timeLow1 == 0 || timeLow2 == 0) return; // Nessun pivot trovato
   
   double slopeUp = (priceLow1 - priceLow2) / ((timeLow1 - timeLow2) / PeriodSeconds(TrendTimeframe));
   if(slopeUp > 0) {
      int barStartUp = iBarShift(_Symbol, TrendTimeframe, timeLow2);
      int barEndUp = iBarShift(_Symbol, TrendTimeframe, timeLow1);
      double highestUp = priceLow1;
      datetime timeHighestUp = timeLow1;
      
      for(int i = barStartUp; i >= barEndUp && i >= 0; i--) {
         bool isHigh = true;
         double currentHigh = high[i];
         for(int j = 1; j <= PivotWindow; j++) {
            if(i + j >= bars || i - j < 0) { isHigh = false; break; }
            if(high[i - j] >= currentHigh || high[i + j] >= currentHigh) isHigh = false;
         }
         if(isHigh && currentHigh > highestUp) {
            highestUp = currentHigh;
            timeHighestUp = iTime(_Symbol, TrendTimeframe, i);
         }
      }
      
      double priceUpStart = highestUp - slopeUp * ((timeHighestUp - timeLow2) / PeriodSeconds(TrendTimeframe));
      double priceUpEnd = highestUp + slopeUp * ((timeLow1 - timeHighestUp) / PeriodSeconds(TrendTimeframe));
      
      if(ObjectFind(0, TrendUpName) < 0) {
         ObjectCreate(0, TrendUpName, OBJ_TREND, 0, timeLow2, priceLow2, timeLow1, priceLow1);
         ObjectSetInteger(0, TrendUpName, OBJPROP_COLOR, TrendUpColor);
         ObjectSetInteger(0, TrendUpName, OBJPROP_STYLE, TrendLineStyle);
         ObjectSetInteger(0, TrendUpName, OBJPROP_WIDTH, LineWidth + 1);
         ObjectSetInteger(0, TrendUpName, OBJPROP_BACK, false);
         ObjectSetInteger(0, TrendUpName, OBJPROP_RAY_RIGHT, true);
      } else {
         ObjectSetDouble(0, TrendUpName, OBJPROP_PRICE, 0, priceLow2);
         ObjectSetInteger(0, TrendUpName, OBJPROP_TIME, 0, timeLow2);
         ObjectSetDouble(0, TrendUpName, OBJPROP_PRICE, 1, priceLow1);
         ObjectSetInteger(0, TrendUpName, OBJPROP_TIME, 1, timeLow1);
      }
      
      if(ObjectFind(0, TrendUpUpperName) < 0) {
         ObjectCreate(0, TrendUpUpperName, OBJ_TREND, 0, timeLow2, priceUpStart, timeLow1, priceUpEnd);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_COLOR, TrendUpColor);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_STYLE, TrendLineStyle);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_WIDTH, LineWidth);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_BACK, false);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_RAY_RIGHT, true);
      } else {
         ObjectSetDouble(0, TrendUpUpperName, OBJPROP_PRICE, 0, priceUpStart);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_TIME, 0, timeLow2);
         ObjectSetDouble(0, TrendUpUpperName, OBJPROP_PRICE, 1, priceUpEnd);
         ObjectSetInteger(0, TrendUpUpperName, OBJPROP_TIME, 1, timeLow1);
      }
   } else {
      ObjectDelete(0, TrendUpName);
      ObjectDelete(0, TrendUpUpperName);
   }
}

//+------------------------------------------------------------------+
void DrawDownTrend(double &high[], double &low[])
{
   static datetime timeHigh1, timeHigh2;
   static double priceHigh1, priceHigh2;
   int bars = iBars(_Symbol, TrendTimeframe);
   
   if(timeHigh1 == 0 || timeHigh2 == 0) return; // Nessun pivot trovato
   
   double slopeDown = (priceHigh1 - priceHigh2) / ((timeHigh1 - timeHigh2) / PeriodSeconds(TrendTimeframe));
   if(slopeDown < 0) {
      int barStartDown = iBarShift(_Symbol, TrendTimeframe, timeHigh2);
      int barEndDown = iBarShift(_Symbol, TrendTimeframe, timeHigh1);
      double lowestDown = priceHigh1;
      datetime timeLowestDown = timeHigh1;
      
      for(int i = barStartDown; i >= barEndDown && i >= 0; i--) {
         bool isLow = true;
         double currentLow = low[i];
         for(int j = 1; j <= PivotWindow; j++) {
            if(i + j >= bars || i - j < 0) { isLow = false; break; }
            if(low[i - j] <= currentLow || low[i + j] <= currentLow) isLow = false;
         }
         if(isLow && currentLow < lowestDown) {
            lowestDown = currentLow;
            timeLowestDown = iTime(_Symbol, TrendTimeframe, i);
         }
      }
      
      double priceLowStart = lowestDown - slopeDown * ((timeLowestDown - timeHigh2) / PeriodSeconds(TrendTimeframe));
      double priceLowEnd = lowestDown + slopeDown * ((timeHigh1 - timeLowestDown) / PeriodSeconds(TrendTimeframe));
      
      if(ObjectFind(0, TrendDownName) < 0) {
         ObjectCreate(0, TrendDownName, OBJ_TREND, 0, timeHigh2, priceHigh2, timeHigh1, priceHigh1);
         ObjectSetInteger(0, TrendDownName, OBJPROP_COLOR, TrendDownColor);
         ObjectSetInteger(0, TrendDownName, OBJPROP_STYLE, TrendLineStyle);
         ObjectSetInteger(0, TrendDownName, OBJPROP_WIDTH, LineWidth + 1);
         ObjectSetInteger(0, TrendDownName, OBJPROP_BACK, false);
         ObjectSetInteger(0, TrendDownName, OBJPROP_RAY_RIGHT, true);
      } else {
         ObjectSetDouble(0, TrendDownName, OBJPROP_PRICE, 0, priceHigh2);
         ObjectSetInteger(0, TrendDownName, OBJPROP_TIME, 0, timeHigh2);
         ObjectSetDouble(0, TrendDownName, OBJPROP_PRICE, 1, priceHigh1);
         ObjectSetInteger(0, TrendDownName, OBJPROP_TIME, 1, timeHigh1);
      }
      
      if(ObjectFind(0, TrendDownLowerName) < 0) {
         ObjectCreate(0, TrendDownLowerName, OBJ_TREND, 0, timeHigh2, priceLowStart, timeHigh1, priceLowEnd);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_COLOR, TrendDownColor);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_STYLE, TrendLineStyle);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_WIDTH, LineWidth);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_BACK, false);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_RAY_RIGHT, true);
      } else {
         ObjectSetDouble(0, TrendDownLowerName, OBJPROP_PRICE, 0, priceLowStart);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_TIME, 0, timeHigh2);
         ObjectSetDouble(0, TrendDownLowerName, OBJPROP_PRICE, 1, priceLowEnd);
         ObjectSetInteger(0, TrendDownLowerName, OBJPROP_TIME, 1, timeHigh1);
      }
   } else {
      ObjectDelete(0, TrendDownName);
      ObjectDelete(0, TrendDownLowerName);
   }
}

//+------------------------------------------------------------------+
void DrawZigZagLines(double &high[], double &low[], double &zigzag[])
{
   static datetime lastZigZagTime = 0;
   datetime currentTime = iTime(_Symbol, TrendTimeframe, 0);
   if(currentTime == lastZigZagTime) return;
   lastZigZagTime = currentTime;
   
   int bars = iBars(_Symbol, TrendTimeframe);
   if(bars < LookbackBars) return;
   
   DeleteZigZagLines(); // Pulisci linee precedenti
   
   int lineCount = 0;
   datetime prevTime = 0, currTime = 0;
   double prevPrice = 0, currPrice = 0;
   
   for(int i = LookbackBars - 1; i >= 0; i--) {
      if(zigzag[i] > 0) { // Punto ZigZag valido
         currTime = iTime(_Symbol, TrendTimeframe, i);
         currPrice = zigzag[i];
         
         if(prevTime != 0) {
            string lineName = ZigZagLineName + IntegerToString(lineCount);
            string channelName = ZigZagChannelName + IntegerToString(lineCount);
            
            // Crea la linea ZigZag principale
            ObjectCreate(0, lineName, OBJ_TREND, 0, prevTime, prevPrice, currTime, currPrice);
            ObjectSetInteger(0, lineName, OBJPROP_COLOR, ZigZagColor);
            ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0, lineName, OBJPROP_WIDTH, LineWidth + 1);
            ObjectSetInteger(0, lineName, OBJPROP_BACK, false);
            ObjectSetInteger(0, lineName, OBJPROP_RAY_RIGHT, false);
            
            // Calcola e disegna il canale
            double slope = (currPrice - prevPrice) / ((currTime - prevTime) / PeriodSeconds(TrendTimeframe));
            int barStart = iBarShift(_Symbol, TrendTimeframe, prevTime);
            int barEnd = iBarShift(_Symbol, TrendTimeframe, currTime);
            
            if(slope > 0) { // Segmento rialzista
               double highest = MathMax(prevPrice, currPrice);
               datetime timeHighest = (prevPrice > currPrice) ? prevTime : currTime;
               for(int j = barStart; j >= barEnd && j >= 0; j--) {
                  if(high[j] > highest) {
                     highest = high[j];
                     timeHighest = iTime(_Symbol, TrendTimeframe, j);
                  }
               }
               double channelStart = highest - slope * ((timeHighest - prevTime) / PeriodSeconds(TrendTimeframe));
               double channelEnd = highest + slope * ((currTime - timeHighest) / PeriodSeconds(TrendTimeframe));
               
               ObjectCreate(0, channelName, OBJ_TREND, 0, prevTime, channelStart, currTime, channelEnd);
               ObjectSetInteger(0, channelName, OBJPROP_COLOR, ZigZagChannelColor);
               ObjectSetInteger(0, channelName, OBJPROP_STYLE, STYLE_SOLID);
               ObjectSetInteger(0, channelName, OBJPROP_WIDTH, LineWidth);
               ObjectSetInteger(0, channelName, OBJPROP_BACK, false);
               ObjectSetInteger(0, channelName, OBJPROP_RAY_RIGHT, false);
            } else if(slope < 0) { // Segmento ribassista
               double lowest = MathMin(prevPrice, currPrice);
               datetime timeLowest = (prevPrice < currPrice) ? prevTime : currTime;
               for(int j = barStart; j >= barEnd && j >= 0; j--) {
                  if(low[j] < lowest) {
                     lowest = low[j];
                     timeLowest = iTime(_Symbol, TrendTimeframe, j);
                  }
               }
               double channelStart = lowest - slope * ((timeLowest - prevTime) / PeriodSeconds(TrendTimeframe));
               double channelEnd = lowest + slope * ((currTime - timeLowest) / PeriodSeconds(TrendTimeframe));
               
               ObjectCreate(0, channelName, OBJ_TREND, 0, prevTime, channelStart, currTime, channelEnd);
               ObjectSetInteger(0, channelName, OBJPROP_COLOR, ZigZagChannelColor);
               ObjectSetInteger(0, channelName, OBJPROP_STYLE, STYLE_SOLID);
               ObjectSetInteger(0, channelName, OBJPROP_WIDTH, LineWidth);
               ObjectSetInteger(0, channelName, OBJPROP_BACK, false);
               ObjectSetInteger(0, channelName, OBJPROP_RAY_RIGHT, false);
            }
            
            lineCount++;
         }
         
         prevTime = currTime;
         prevPrice = currPrice;
      }
   }
}

//+------------------------------------------------------------------+
void DeleteZigZagLines()
{
   for(int i = 0; i < 1000; i++) {
      ObjectDelete(0, ZigZagLineName + IntegerToString(i));
      ObjectDelete(0, ZigZagChannelName + IntegerToString(i));
   }
}

//+------------------------------------------------------------------+
void CheckBreakoutDown(double &high[], double &low[], double &close[])
{
   if(ObjectFind(0, TrendDownName) < 0) return;
   
   datetime time1 = (datetime)ObjectGetInteger(0, TrendDownName, OBJPROP_TIME, 0);
   double price1 = ObjectGetDouble(0, TrendDownName, OBJPROP_PRICE, 0);
   datetime time2 = (datetime)ObjectGetInteger(0, TrendDownName, OBJPROP_TIME, 1);
   double price2 = ObjectGetDouble(0, TrendDownName, OBJPROP_PRICE, 1);
   double slope = (price2 - price1) / ((time2 - time1) / PeriodSeconds(TrendTimeframe));
   
   int breakoutCount = 0;
   for(int i = 0; i < BreakoutCandles; i++) {
      datetime time = iTime(_Symbol, TrendTimeframe, i);
      double trendPrice = price1 + slope * ((time - time1) / PeriodSeconds(TrendTimeframe));
      if(close[i] > trendPrice) breakoutCount++; else break;
   }
   
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double adx[];
   ArraySetAsSeries(adx, true);
   CopyBuffer(iADX_handle, 0, 0, 1, adx);
   
   if(breakoutCount == BreakoutCandles && PositionsTotal() == 0 && ATR[0] > MinATR && adx[0] > 25 && (!AvoidNews || !IsHighImpactNews()) && IsNearStrongZone(askPrice)) {
      double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 10;
      double slPrice = NormalizeDouble(askPrice - (InitialStopLossPips * pipValue), _Digits);
      double tpPrice = NormalizeDouble(askPrice + (TakeProfitPips * pipValue), _Digits);
      double lotSize = CalculateLotSize(InitialStopLossPips);
      if(trade.Buy(lotSize, _Symbol, askPrice, slPrice, tpPrice, "Breakout Buy"))
         Print("Buy order opened: Ticket #", trade.ResultOrder());
   }
}

//+------------------------------------------------------------------+
void CheckBreakoutUp(double &high[], double &low[], double &close[])
{
   if(ObjectFind(0, TrendUpName) < 0) return;
   
   datetime time1 = (datetime)ObjectGetInteger(0, TrendUpName, OBJPROP_TIME, 0);
   double price1 = ObjectGetDouble(0, TrendUpName, OBJPROP_PRICE, 0);
   datetime time2 = (datetime)ObjectGetInteger(0, TrendUpName, OBJPROP_TIME, 1);
   double price2 = ObjectGetDouble(0, TrendUpName, OBJPROP_PRICE, 1);
   double slope = (price2 - price1) / ((time2 - time1) / PeriodSeconds(TrendTimeframe));
   
   int breakoutCount = 0;
   for(int i = 0; i < BreakoutCandles; i++) {
      datetime time = iTime(_Symbol, TrendTimeframe, i);
      double trendPrice = price1 + slope * ((time - time1) / PeriodSeconds(TrendTimeframe));
      if(close[i] < trendPrice) breakoutCount++; else break;
   }
   
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double adx[];
   ArraySetAsSeries(adx, true);
   CopyBuffer(iADX_handle, 0, 0, 1, adx);
   
   if(breakoutCount == BreakoutCandles && PositionsTotal() == 0 && ATR[0] > MinATR && adx[0] > 25 && (!AvoidNews || !IsHighImpactNews()) && IsNearStrongZone(bidPrice)) {
      double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 10;
      double slPrice = NormalizeDouble(bidPrice + (InitialStopLossPips * pipValue), _Digits);
      double tpPrice = NormalizeDouble(bidPrice - (TakeProfitPips * pipValue), _Digits);
      double lotSize = CalculateLotSize(InitialStopLossPips);
      if(trade.Sell(lotSize, _Symbol, bidPrice, slPrice, tpPrice, "Breakout Sell"))
         Print("Sell order opened: Ticket #", trade.ResultOrder());
   }
}

//+------------------------------------------------------------------+
void ManageTrailingStop()
{
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 10;
   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket) || PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      
      double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
      double currentSL = PositionGetDouble(POSITION_SL);
      double profitPips = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? (currentPrice - openPrice) / pipValue : (openPrice - currentPrice) / pipValue;
      
      if(profitPips >= TrailingStartPips) {
         double newSL = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 
                        NormalizeDouble(currentPrice - (TrailingStopPips * pipValue), _Digits) : 
                        NormalizeDouble(currentPrice + (TrailingStopPips * pipValue), _Digits);
         if((newSL > currentSL && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) || (newSL < currentSL && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) || currentSL == 0) {
            trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP));
         }
      }
   }
}

//+------------------------------------------------------------------+
double CalculateLotSize(double slPips)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   if(balance <= 0) return 0.01;
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) * 10;
   double riskAmount = balance * (RiskPercent / 100.0) * (ATR[0] / MinATR);
   double lotSize = riskAmount / (slPips * pipValue);
   return NormalizeDouble(MathMax(lotSize, 0.01), 2);
}

//+------------------------------------------------------------------+
bool IsNearStrongZone(double price)
{
   for(int i = 0; i < ZoneCount; i++) {
      if(ZoneStrength[i] >= ZONE_VERIFIED && price >= ZoneLo[i] && price <= ZoneHi[i]) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
bool IsHighImpactNews()
{
   return false; // Placeholder
}

//+------------------------------------------------------------------+
void DrawSupplyDemandZones(double &high[], double &low[], double &close[])
{
   static datetime lastZoneTime = 0;
   datetime currentTime = iTime(_Symbol, ZoneTimeframe, 0);
   if(currentTime == lastZoneTime) return;
   lastZoneTime = currentTime;
   
   if(iBars(_Symbol, ZoneTimeframe) < LookbackBars + MIN_BARS_FOR_CALC) return;
   
   FastFractals(high, low);
   SlowFractals(high, low);
   FindZones(high, low, close);
   UpdateZones();
}

//+------------------------------------------------------------------+
void FastFractals(double &high[], double &low[])
{
   int limit = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   int P1 = (int)(PeriodSeconds(ZoneTimeframe) / 60 * 3.0);
   ArrayResize(FastUpPts, limit + 1);
   ArrayResize(FastDnPts, limit + 1);
   
   for(int shift = limit; shift > MIN_BARS_FOR_CALC; shift--) {
      if(Fractal(UP_POINT, P1, shift, high, low)) FastUpPts[shift] = high[shift]; else FastUpPts[shift] = 0.0;
      if(Fractal(DN_POINT, P1, shift, high, low)) FastDnPts[shift] = low[shift]; else FastDnPts[shift] = 0.0;
   }
}

//+------------------------------------------------------------------+
void SlowFractals(double &high[], double &low[])
{
   int limit = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   int P2 = (int)(PeriodSeconds(ZoneTimeframe) / 60 * 6.0);
   ArrayResize(SlowUpPts, limit + 1);
   ArrayResize(SlowDnPts, limit + 1);
   
   for(int shift = limit; shift > MIN_BARS_FOR_CALC; shift--) {
      if(Fractal(UP_POINT, P2, shift, high, low)) SlowUpPts[shift] = high[shift]; else SlowUpPts[shift] = 0.0;
      if(Fractal(DN_POINT, P2, shift, high, low)) SlowDnPts[shift] = low[shift]; else SlowDnPts[shift] = 0.0;
   }
}

//+------------------------------------------------------------------+
bool Fractal(int M, int P, int shift, double &high[], double &low[])
{
   int bars = iBars(_Symbol, ZoneTimeframe);
   if(shift < P || shift > bars - P - 1) return false;
   
   for(int i = 1; i <= P; i++) {
      if(M == UP_POINT && (high[shift + i] > high[shift] || high[shift - i] >= high[shift])) return false;
      if(M == DN_POINT && (low[shift + i] < low[shift] || low[shift - i] <= low[shift])) return false;
   }
   return true;
}

//+------------------------------------------------------------------+
void FindZones(double &high[], double &low[], double &close[])
{
   int shift = MathMin(iBars(_Symbol, ZoneTimeframe) - 1, LookbackBars);
   ArrayResize(ATR, shift + 1);
   if(CopyBuffer(iATR_handle, 0, 0, shift + 1, ATR) <= 0) return;
   
   ZoneCount = 0;
   for(int i = shift; i > MIN_BARS_FOR_CALC && ZoneCount < 1000; i--) {
      double atr = ATR[i];
      double fu = atr / 2 * 0.75;
      bool isWeak, isBust = false;
      int bustcount = 0, testcount = 0;
      double hival, loval;
      bool turned = false, hasturned = false;
      
      if(FastUpPts[i] > 0.001) {
         isWeak = (SlowUpPts[i] <= 0.001);
         hival = high[i] + fu;
         loval = MathMax(MathMin(close[i], high[i] - fu), high[i] - fu * 2);
         
         for(int j = i - 1; j >= 0; j--) {
            if((turned == false && high[j] > hival) || (turned == true && low[j] < loval)) {
               bustcount++;
               if(bustcount > 1 || isWeak) { isBust = true; break; }
               turned = !turned;
               hasturned = true;
               testcount = 0;
            }
            if((turned == false && FastUpPts[j] >= loval && FastUpPts[j] <= hival) ||
               (turned == true && FastDnPts[j] <= hival && FastDnPts[j] >= loval)) {
               bool touchOk = true;
               for(int k = j + 1; k < j + ZONE_CHECK_RANGE && k < shift; k++) {
                  if((turned == false && FastUpPts[k] >= loval && FastUpPts[k] <= hival) ||
                     (turned == true && FastDnPts[k] <= hival && FastDnPts[k] >= loval)) {
                     touchOk = false;
                     break;
                  }
               }
               if(touchOk) { bustcount = 0; testcount++; }
            }
         }
         
         if(!isBust) {
            ZoneHi[ZoneCount] = hival;
            ZoneLo[ZoneCount] = loval;
            ZoneHits[ZoneCount] = testcount;
            ZoneTurn[ZoneCount] = hasturned;
            ZoneStart[ZoneCount] = i;
            ZoneType[ZoneCount] = (ZoneLo[ZoneCount] > close[0]) ? ZONE_RESIST : ZONE_SUPPORT;
            ZoneStrength[ZoneCount] = (testcount > 3) ? ZONE_PROVEN : 
                                      (testcount > 0) ? ZONE_VERIFIED : 
                                      (hasturned) ? ZONE_TURNCOAT : 
                                      (!isWeak) ? ZONE_UNTESTED : ZONE_WEAK;
            ZoneCount++;
         }
      } else if(FastDnPts[i] > 0.001) {
         isWeak = (SlowDnPts[i] <= 0.001);
         loval = low[i] - fu;
         hival = MathMin(MathMax(close[i], low[i] + fu), low[i] + fu * 2);
         
         for(int j = i - 1; j >= 0; j--) {
            if((turned == false && low[j] < loval) || (turned == true && high[j] > hival)) {
               bustcount++;
               if(bustcount > 1 || isWeak) { isBust = true; break; }
               turned = !turned;
               hasturned = true;
               testcount = 0;
            }
            if((turned == false && FastDnPts[j] <= hival && FastDnPts[j] >= loval) ||
               (turned == true && FastUpPts[j] >= loval && FastUpPts[j] <= hival)) {
               bool touchOk = true;
               for(int k = j + 1; k < j + ZONE_CHECK_RANGE && k < shift; k++) {
                  if((turned == false && FastDnPts[k] <= hival && FastDnPts[k] >= loval) ||
                     (turned == true && FastUpPts[k] >= loval && FastUpPts[k] <= hival)) {
                     touchOk = false;
                     break;
                  }
               }
               if(touchOk) { bustcount = 0; testcount++; }
            }
         }
         
         if(!isBust) {
            ZoneHi[ZoneCount] = hival;
            ZoneLo[ZoneCount] = loval;
            ZoneHits[ZoneCount] = testcount;
            ZoneTurn[ZoneCount] = hasturned;
            ZoneStart[ZoneCount] = i;
            ZoneType[ZoneCount] = (ZoneLo[ZoneCount] > close[0]) ? ZONE_RESIST : ZONE_SUPPORT;
            ZoneStrength[ZoneCount] = (testcount > 3) ? ZONE_PROVEN : 
                                      (testcount > 0) ? ZONE_VERIFIED : 
                                      (hasturned) ? ZONE_TURNCOAT : 
                                      (!isWeak) ? ZONE_UNTESTED : ZONE_WEAK;
            ZoneCount++;
         }
      }
   }
   MergeZones();
}

//+------------------------------------------------------------------+
void MergeZones()
{
   int merge_count = 1, iterations = 0;
   bool temp_merge[];
   ArrayResize(temp_merge, ZoneCount);
   int merge1[], merge2[];
   ArrayResize(merge1, ZoneCount);
   ArrayResize(merge2, ZoneCount);
   
   while(merge_count > 0 && iterations < 3) {
      merge_count = 0;
      iterations++;
      for(int i = 0; i < ZoneCount; i++) temp_merge[i] = false;
      
      for(int i = 0; i < ZoneCount - 1; i++) {
         if(temp_merge[i]) continue;
         for(int j = i + 1; j < ZoneCount; j++) {
            if(temp_merge[j]) continue;
            if((ZoneHi[i] >= ZoneLo[j] && ZoneHi[i] <= ZoneHi[j]) ||
               (ZoneLo[i] <= ZoneHi[j] && ZoneLo[i] >= ZoneLo[j]) ||
               (ZoneHi[j] >= ZoneLo[i] && ZoneHi[j] <= ZoneHi[i]) ||
               (ZoneLo[j] <= ZoneHi[i] && ZoneLo[j] >= ZoneLo[i])) {
               merge1[merge_count] = i;
               merge2[merge_count] = j;
               temp_merge[i] = true;
               temp_merge[j] = true;
               merge_count++;
            }
         }
      }
      
      for(int i = 0; i < merge_count; i++) {
         int target = merge1[i], source = merge2[i];
         ZoneHi[target] = MathMax(ZoneHi[target], ZoneHi[source]);
         ZoneLo[target] = MathMin(ZoneLo[target], ZoneLo[source]);
         ZoneHits[target] += ZoneHits[source];
         ZoneStart[target] = MathMax(ZoneStart[target], ZoneStart[source]);
         ZoneStrength[target] = MathMax(ZoneStrength[target], ZoneStrength[source]);
         if(ZoneHits[target] > 3) ZoneStrength[target] = ZONE_PROVEN;
         else if(ZoneHits[target] > 0) ZoneStrength[target] = ZONE_VERIFIED;
         else if(ZoneTurn[target]) ZoneStrength[target] = ZONE_TURNCOAT;
         ZoneTurn[target] = ZoneTurn[target] || ZoneTurn[source];
         ZoneType[target] = (ZoneLo[target] > iClose(_Symbol, ZoneTimeframe, 0)) ? ZONE_RESIST : ZONE_SUPPORT;
         ZoneHi[source] = 0;
      }
   }
   
   int newCount = 0;
   for(int i = 0; i < ZoneCount; i++) {
      if(ZoneHi[i] > 0) {
         if(newCount != i) {
            ZoneHi[newCount] = ZoneHi[i];
            ZoneLo[newCount] = ZoneLo[i];
            ZoneHits[newCount] = ZoneHits[i];
            ZoneTurn[newCount] = ZoneTurn[i];
            ZoneStart[newCount] = ZoneStart[i];
            ZoneType[newCount] = ZoneType[i];
            ZoneStrength[newCount] = ZoneStrength[i];
         }
         newCount++;
      }
   }
   ZoneCount = newCount;
}

//+------------------------------------------------------------------+
void UpdateZones()
{
   datetime timeEnd = iTime(_Symbol, PERIOD_CURRENT, 0);
   for(int i = 0; i < ZoneCount; i++) {
      if(ZoneStrength[i] == ZONE_WEAK) continue;
      string name = (ZoneType[i] == ZONE_SUPPORT) ? DemandZoneName + IntegerToString(i) : SupplyZoneName + IntegerToString(i);
      datetime startTime = iTime(_Symbol, ZoneTimeframe, ZoneStart[i]);
      
      if(ObjectFind(0, name) < 0) {
         ObjectCreate(0, name, OBJ_RECTANGLE, 0, startTime, ZoneLo[i], timeEnd, ZoneHi[i]);
         ObjectSetInteger(0, name, OBJPROP_COLOR, (ZoneType[i] == ZONE_SUPPORT) ? DemandColor : SupplyColor);
         ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, name, OBJPROP_BACK, true);
         ObjectSetInteger(0, name, OBJPROP_FILL, true);
      } else {
         ObjectSetDouble(0, name, OBJPROP_PRICE, 0, ZoneLo[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 0, startTime);
         ObjectSetDouble(0, name, OBJPROP_PRICE, 1, ZoneHi[i]);
         ObjectSetInteger(0, name, OBJPROP_TIME, 1, timeEnd);
      }
   }
}

//+------------------------------------------------------------------+
void DeleteZones()
{
   for(int i = 0; i < 1000; i++) {
      ObjectDelete(0, DemandZoneName + IntegerToString(i));
      ObjectDelete(0, SupplyZoneName + IntegerToString(i));
   }
}

//+------------------------------------------------------------------+
void ShowLevelsAsComment()
{
   string commentText = "Gann Square of 9 Levels (Pivot: " + DoubleToString(PivotPrice, _Digits) + "):\n";
   for(int i = 0; i < ArraySize(GannLevels); i++) {
      if(GannLevels[i] > 0) commentText += DoubleToString(GannLevels[i], _Digits) + "\n";
   }
   Comment(commentText);
}

//+------------------------------------------------------------------+
void Swap(datetime &a, datetime &b) { datetime temp = a; a = b; b = temp; }
void Swap(double &a, double &b) { double temp = a; a = b; b = temp; }
//+------------------------------------------------------------------+