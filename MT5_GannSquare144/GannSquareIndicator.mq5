//+------------------------------------------------------------------+
//|                                              GannSquareIndicator.mq5 |
//|                                          Copyright 2025, Cascade AI  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cascade AI"
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

//--- plot dummy buffer
#property indicator_label1  "Gann Square"
#property indicator_type1   DRAW_NONE
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- input parameters
input int      GannPeriod = 144;       // Periodo di Gann
input int      SquareSize = 100;       // Dimensione del quadrato (pixel)
input color    MainGridColor = clrWhite;    // Colore griglia principale
input color    Level25Color = clrGreen;     // Colore livello 0.25
input color    Level33Color = clrRed;       // Colore livello 0.333
input color    Level50Color = clrYellow;    // Colore livello 0.5
input color    Level66Color = clrRed;       // Colore livello 0.666
input color    Level75Color = clrGreen;     // Colore livello 0.75

//--- Global variables
string         PREFIX = "GannSq_";
datetime       startTime;
double         startPrice;
double         DummyBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                           |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, DummyBuffer, INDICATOR_CALCULATIONS);
   
   startTime = TimeCurrent();
   startPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   
   CreateGannSquare();
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                                |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Create complete Gann Square                                        |
//+------------------------------------------------------------------+
void CreateGannSquare()
{
   datetime endTime = startTime + PeriodSeconds(Period()) * GannPeriod;
   double priceRange = startPrice * 0.1; // 10% del prezzo iniziale
   double endPrice = startPrice + priceRange;
   
   // Array dei livelli di Gann
   double levels[] = {0, 0.25, 0.333, 0.5, 0.666, 0.75, 1.0};
   color  colors[] = {MainGridColor, Level25Color, Level33Color, Level50Color, Level66Color, Level75Color, MainGridColor};
   
   // Crea il quadrato principale
   CreateLine(PREFIX+"Top", startTime, endPrice, endTime, endPrice, MainGridColor);
   CreateLine(PREFIX+"Bottom", startTime, startPrice, endTime, startPrice, MainGridColor);
   CreateLine(PREFIX+"Left", startTime, startPrice, startTime, endPrice, MainGridColor);
   CreateLine(PREFIX+"Right", endTime, startPrice, endTime, endPrice, MainGridColor);
   
   // Crea linee orizzontali e verticali
   for(int i=1; i<ArraySize(levels)-1; i++)
   {
      // Linea orizzontale
      double price = startPrice + priceRange * levels[i];
      CreateLine(PREFIX+"H"+DoubleToString(levels[i],3),
                startTime, price,
                endTime, price,
                colors[i], STYLE_DOT);
                
      // Linea verticale
      datetime time = startTime + (int)((endTime - startTime) * levels[i]);
      CreateLine(PREFIX+"V"+DoubleToString(levels[i],3),
                time, startPrice,
                time, endPrice,
                colors[i], STYLE_DOT);
   }
   
   // Crea tutte le linee diagonali
   for(int i=0; i<ArraySize(levels); i++)
   {
      for(int j=0; j<ArraySize(levels); j++)
      {
         if(i == j) continue;
         
         datetime t1 = startTime + (int)((endTime - startTime) * levels[i]);
         datetime t2 = startTime + (int)((endTime - startTime) * levels[j]);
         double p1 = startPrice + priceRange * levels[i];
         double p2 = startPrice + priceRange * levels[j];
         
         CreateLine(PREFIX+"D"+DoubleToString(levels[i],3)+"_"+DoubleToString(levels[j],3),
                   t1, p1,
                   t2, p2,
                   MainGridColor);
      }
   }
}

//+------------------------------------------------------------------+
//| Create a single line object                                        |
//+------------------------------------------------------------------+
void CreateLine(string name, datetime t1, double p1, datetime t2, double p2, 
               color clr, ENUM_LINE_STYLE style=STYLE_SOLID)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, OBJ_TREND, 0, t1, p1, t2, p2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, PREFIX);
}
