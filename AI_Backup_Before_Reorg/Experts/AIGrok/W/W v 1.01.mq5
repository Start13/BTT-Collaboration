#property copyright "xAI"
#property link      "https://www.xai.com"
#property version   "1.01"
#property description "EA che mostra trend line con minimi e massimi durante lateralizzazione"

// Input parameters
input int Lookback = 50;          // Periodo di lookback per trovare massimi/minimi
input int FractalSize = 5;        // Numero di barre per identificare un frattale (deve essere dispari)
input int LateralPeriod = 10;     // Numero di candele per identificare la lateralizzazione
input double LateralThreshold = 0.0005; // Soglia di prezzo per considerare lateralizzazione

// Global variables
string eaName = "W";

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   if(FractalSize % 2 == 0)
   {
      Print("FractalSize deve essere un numero dispari!");
      return(INIT_PARAMETERS_INCORRECT);
   }
   ObjectsDeleteAll(0, eaName);
   DrawTrendLinesWithLateralPoints();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, eaName);
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
   DrawTrendLinesWithLateralPoints();
}

//+------------------------------------------------------------------+
//| Funzione per disegnare trend line e punti di lateralizzazione      |
//+------------------------------------------------------------------+
void DrawTrendLinesWithLateralPoints()
{
   ObjectsDeleteAll(0, eaName);
   
   // Trend line rialzista
   datetime time1Up, time2Up;
   double price1Up, price2Up;
   FindUptrendPoints(time1Up, price1Up, time2Up, price2Up);
   if(time1Up != 0 && time2Up != 0)
   {
      ObjectCreate(0, eaName + "_Uptrend", OBJ_TREND, 0, time1Up, price1Up, time2Up, price2Up);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_COLOR, clrGreen);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, eaName + "_Uptrend", OBJPROP_RAY_RIGHT, true);
      MarkLateralPointsAlongTrend(time1Up, price1Up, time2Up, price2Up, true);
   }
   
   // Trend line ribassista
   datetime time1Down, time2Down;
   double price1Down, price2Down;
   FindDowntrendPoints(time1Down, price1Down, time2Down, price2Down);
   if(time1Down != 0 && time2Down != 0)
   {
      ObjectCreate(0, eaName + "_Downtrend", OBJ_TREND, 0, time1Down, price1Down, time2Down, price2Down);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_COLOR, clrRed);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, eaName + "_Downtrend", OBJPROP_RAY_RIGHT, true);
      MarkLateralPointsAlongTrend(time1Down, price1Down, time2Down, price2Down, false);
   }
}

//+------------------------------------------------------------------+
//| Trova punti per trend rialzista (minimi relativi)                  |
//+------------------------------------------------------------------+
void FindUptrendPoints(datetime &time1, double &price1, datetime &time2, double &price2)
{
   int shift1 = 0, shift2 = 0;
   int halfFractal = FractalSize / 2;
   
   for(int i = Lookback - 1; i >= halfFractal; i--)
   {
      if(IsLocalLow(i))
      {
         shift1 = i;
         time1 = iTime(NULL, 0, i);
         price1 = iLow(NULL, 0, i);
         break;
      }
   }
   
   for(int i = shift1 - halfFractal; i >= halfFractal; i--)
   {
      if(IsLocalLow(i) && iLow(NULL, 0, i) > price1)
      {
         shift2 = i;
         time2 = iTime(NULL, 0, i);
         price2 = iLow(NULL, 0, i);
         break;
      }
   }
   
   if(shift2 == 0 || price2 <= price1)
   {
      time1 = 0;
      time2 = 0;
   }
}

//+------------------------------------------------------------------+
//| Trova punti per trend ribassista (massimi relativi)                |
//+------------------------------------------------------------------+
void FindDowntrendPoints(datetime &time1, double &price1, datetime &time2, double &price2)
{
   int shift1 = 0, shift2 = 0;
   int halfFractal = FractalSize / 2;
   
   for(int i = Lookback - 1; i >= halfFractal; i--)
   {
      if(IsLocalHigh(i))
      {
         shift1 = i;
         time1 = iTime(NULL, 0, i);
         price1 = iHigh(NULL, 0, i);
         break;
      }
   }
   
   for(int i = shift1 - halfFractal; i >= halfFractal; i--)
   {
      if(IsLocalHigh(i) && iHigh(NULL, 0, i) < price1)
      {
         shift2 = i;
         time2 = iTime(NULL, 0, i);
         price2 = iHigh(NULL, 0, i);
         break;
      }
   }
   
   if(shift2 == 0 || price2 >= price1)
   {
      time1 = 0;
      time2 = 0;
   }
}

//+------------------------------------------------------------------+
//| Verifica se è un minimo locale                                     |
//+------------------------------------------------------------------+
bool IsLocalLow(int shift)
{
   int halfFractal = FractalSize / 2;
   double center = iLow(NULL, 0, shift);
   
   for(int i = 1; i <= halfFractal; i++)
   {
      if(iLow(NULL, 0, shift - i) <= center || iLow(NULL, 0, shift + i) <= center)
         return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Verifica se è un massimo locale                                    |
//+------------------------------------------------------------------+
bool IsLocalHigh(int shift)
{
   int halfFractal = FractalSize / 2;
   double center = iHigh(NULL, 0, shift);
   
   for(int i = 1; i <= halfFractal; i++)
   {
      if(iHigh(NULL, 0, shift - i) >= center || iHigh(NULL, 0, shift + i) >= center)
         return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Segna minimi e massimi lungo la trend line durante lateralizzazione|
//+------------------------------------------------------------------+
void MarkLateralPointsAlongTrend(datetime time1, double price1, datetime time2, double price2, bool isUptrend)
{
   double slope = (price2 - price1) / (time2 - time1);
   int startBar = iBarShift(NULL, 0, time1);
   int endBar = 0; // Fino all'ultima barra disponibile
   
   for(int i = startBar - LateralPeriod; i >= endBar; i--)
   {
      double high = iHighest(NULL, 0, MODE_HIGH, LateralPeriod, i);
      double low = iLowest(NULL, 0, MODE_LOW, LateralPeriod, i);
      double range = high - low;
      
      if(range <= LateralThreshold)
      {
         datetime timeStart = iTime(NULL, 0, i + LateralPeriod - 1);
         double trendPriceStart = price1 + slope * (timeStart - time1);
         
         // Verifica che il range sia vicino alla trend line
         if(MathAbs(high - trendPriceStart) <= LateralThreshold || MathAbs(low - trendPriceStart) <= LateralThreshold)
         {
            // Segna il massimo
            string maxName = eaName + (isUptrend ? "_UpMax_" : "_DownMax_") + IntegerToString(i);
            ObjectCreate(0, maxName, OBJ_ARROW_UP, 0, timeStart, high);
            ObjectSetInteger(0, maxName, OBJPROP_COLOR, clrYellow);
            ObjectSetInteger(0, maxName, OBJPROP_WIDTH, 2);
            
            // Segna il minimo
            string minName = eaName + (isUptrend ? "_UpMin_" : "_DownMin_") + IntegerToString(i);
            ObjectCreate(0, minName, OBJ_ARROW_DOWN, 0, timeStart, low);
            ObjectSetInteger(0, minName, OBJPROP_COLOR, clrYellow);
            ObjectSetInteger(0, minName, OBJPROP_WIDTH, 2);
         }
      }
   }
}
//+------------------------------------------------------------------+