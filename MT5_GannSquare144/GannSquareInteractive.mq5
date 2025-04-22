//+------------------------------------------------------------------+
//|                                           GannSquareInteractive.mq5 |
//|                                          Copyright 2025, Cascade AI |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cascade AI"
#property link      ""
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

#include <Object.mqh>
#include <ChartObjects\ChartObject.mqh>

//--- plot dummy buffer
#property indicator_label1  "Gann Square"
#property indicator_type1   DRAW_NONE
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

//--- input parameters
input int      GannPeriod = 144;       // Periodo di Gann
input int      NumFanLines = 8;        // Numero di linee del ventaglio
input color    MainGridColor = clrWhite;    // Colore griglia principale
input color    Level25Color = clrGreen;     // Colore livello 0.25
input color    Level33Color = clrRed;       // Colore livello 0.333
input color    Level50Color = clrYellow;    // Colore livello 0.5
input color    Level66Color = clrRed;       // Colore livello 0.666
input color    Level75Color = clrGreen;     // Colore livello 0.75
input color    ControlPointsColor = clrRed; // Colore punti di controllo
input color    FanLinesColor = clrYellow;   // Colore linee ventaglio

//--- global variables
string         PREFIX = "GannSq_";
double         DummyBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                           |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, DummyBuffer, INDICATOR_CALCULATIONS);
   
   // Calcola coordinate iniziali
   datetime time1 = TimeCurrent();
   datetime time2 = time1 + PeriodSeconds(Period()) * GannPeriod;
   double price1 = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double price2 = price1 + (price1 * 0.1); // 10% dell'altezza
   
   // Rimuovi oggetti esistenti
   ObjectsDeleteAll(0, PREFIX);
   
   CreateGannSquare(time1, time2, price1, price2);
   ChartRedraw();
   
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
//| Create Gann Square with control points                             |
//+------------------------------------------------------------------+
void CreateGannSquare(datetime time1, datetime time2, double price1, double price2)
{
   // Crea il rettangolo principale
   CreateRectangle(PREFIX+"Rect", time1, price1, time2, price2);
   
   // Crea solo il punto centrale per lo spostamento
   datetime timeMid = time1 + (time2 - time1) / 2;
   double priceMid = price1 + (price2 - price1) / 2;
   
   // Punto centrale per spostamento
   CreateControlPoint(PREFIX+"Center", timeMid, priceMid, ControlPointsColor, OBJ_ARROW_THUMB_UP);
   
   // Crea le linee interne
   UpdateInternalLines();
   
   // Crea il ventaglio
   CreateFanLines(time1, time2, price1, price2);
}

//+------------------------------------------------------------------+
//| Create fan lines from bottom-left corner                          |
//+------------------------------------------------------------------+
void CreateFanLines(datetime time1, datetime time2, double price1, double price2)
{
   double priceRange = price2 - price1;
   double timeRange = double(time2 - time1);
   
   // Crea le linee del ventaglio
   for(int i=1; i <= NumFanLines; i++)
   {
      double angle = (M_PI/2) * (double(i) / NumFanLines);
      double endTime = time1 + timeRange * cos(angle);
      double endPrice = price1 + priceRange * sin(angle);
      
      CreateLine(PREFIX+"Fan"+IntegerToString(i),
                time1, price1,           // punto iniziale (angolo basso/sx)
                endTime, endPrice,       // punto finale
                FanLinesColor);
   }
}

//+------------------------------------------------------------------+
//| Update internal lines based on square boundaries                   |
//+------------------------------------------------------------------+
void UpdateInternalLines()
{
   // Ottieni coordinate del quadrato
   double price1, price2;
   datetime time1, time2;
   if(!GetSquareCoordinates(time1, time2, price1, price2)) return;
   
   double priceRange = price2 - price1;
   datetime timeRange = time2 - time1;
   
   // Array dei livelli di Gann
   double levels[] = {0.25, 0.333, 0.5, 0.666, 0.75};
   color colors[] = {Level25Color, Level33Color, Level50Color, Level66Color, Level75Color};
   
   // Crea/aggiorna linee orizzontali e verticali
   for(int i=0; i<ArraySize(levels); i++)
   {
      // Linea orizzontale
      double price = price1 + priceRange * levels[i];
      CreateLine(PREFIX+"H"+DoubleToString(levels[i],3),
                time1, price, time2, price,
                colors[i], STYLE_DOT);
                
      // Linea verticale
      datetime time = time1 + (int)(timeRange * levels[i]);
      CreateLine(PREFIX+"V"+DoubleToString(levels[i],3),
                time, price1, time, price2,
                colors[i], STYLE_DOT);
   }
   
   // Crea le diagonali principali
   CreateLine(PREFIX+"D1", time1, price1, time2, price2, MainGridColor); // Diagonale 0-1
   CreateLine(PREFIX+"D2", time1, price2, time2, price1, MainGridColor); // Diagonale 1-0
   
   // Crea le diagonali intermedie
   for(int i=0; i<ArraySize(levels); i++)
   {
      // Diagonali dal basso verso l'alto
      datetime t = time1 + (int)(timeRange * levels[i]);
      CreateLine(PREFIX+"DU"+DoubleToString(levels[i],3),
                t, price1, time2, price2,
                MainGridColor);
                
      // Diagonali dall'alto verso il basso
      CreateLine(PREFIX+"DD"+DoubleToString(levels[i],3),
                t, price2, time2, price1,
                MainGridColor);
                
      // Diagonali dal lato sinistro
      double p = price1 + priceRange * levels[i];
      CreateLine(PREFIX+"DL"+DoubleToString(levels[i],3),
                time1, p, time2, price2,
                MainGridColor);
                
      // Diagonali dal lato destro
      CreateLine(PREFIX+"DR"+DoubleToString(levels[i],3),
                time1, price2, time2, p,
                MainGridColor);
   }
}

//+------------------------------------------------------------------+
//| Get square coordinates from rectangle object                       |
//+------------------------------------------------------------------+
bool GetSquareCoordinates(datetime &time1, datetime &time2, double &price1, double &price2)
{
   long t1, t2;
   if(!ObjectGetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 0, t1)) return false;
   if(!ObjectGetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 1, t2)) return false;
   time1 = (datetime)t1;
   time2 = (datetime)t2;
   
   if(!ObjectGetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 0, price1)) return false;
   if(!ObjectGetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 1, price2)) return false;
   return true;
}

//+------------------------------------------------------------------+
//| Create rectangle object                                            |
//+------------------------------------------------------------------+
void CreateRectangle(string name, datetime t1, double p1, datetime t2, double p2)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, OBJ_RECTANGLE, 0, t1, p1, t2, p2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, MainGridColor);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_FILL, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
}

//+------------------------------------------------------------------+
//| Create control point                                               |
//+------------------------------------------------------------------+
void CreateControlPoint(string name, datetime time, double price, color clr, ENUM_OBJECT type)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, type, 0, time, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
   
   // Imposta il codice della freccia
   if(type == OBJ_ARROW)
      ObjectSetInteger(0, name, OBJPROP_ARROWCODE, 251); // Piccolo punto
}

//+------------------------------------------------------------------+
//| Create line object                                                 |
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
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                               |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // Gestione del trascinamento del quadrato
   if(id == CHARTEVENT_OBJECT_DRAG)
   {
      if(sparam == PREFIX+"Center")
      {
         // Ottieni le coordinate attuali del quadrato
         datetime time1, time2;
         double price1, price2;
         if(!GetSquareCoordinates(time1, time2, price1, price2))
            return;
            
         // Calcola le dimensioni del quadrato
         datetime timeSize = time2 - time1;
         double priceSize = price2 - price1;
         
         // Ottieni la nuova posizione del centro
         datetime newTimeMid;
         double newPriceMid;
         if(!ObjectGetInteger(0, PREFIX+"Center", OBJPROP_TIME, 0, newTimeMid) ||
            !ObjectGetDouble(0, PREFIX+"Center", OBJPROP_PRICE, 0, newPriceMid))
            return;
            
         // Calcola le nuove coordinate del quadrato
         datetime newTime1 = newTimeMid - timeSize/2;
         datetime newTime2 = newTimeMid + timeSize/2;
         double newPrice1 = newPriceMid - priceSize/2;
         double newPrice2 = newPriceMid + priceSize/2;
         
         // Aggiorna il quadrato
         ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 0, newTime1);
         ObjectSetInteger(0, PREFIX+"Rect", OBJPROP_TIME, 1, newTime2);
         ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 0, newPrice1);
         ObjectSetDouble(0, PREFIX+"Rect", OBJPROP_PRICE, 1, newPrice2);
         
         // Aggiorna tutte le linee
         UpdateInternalLines();
         CreateFanLines(newTime1, newTime2, newPrice1, newPrice2);
      }
   }
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, PREFIX);
}
