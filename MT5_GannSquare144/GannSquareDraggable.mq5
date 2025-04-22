//+------------------------------------------------------------------+
//|                                             GannSquareDraggable.mq5 |
//|                                          Copyright 2025, Cascade AI  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cascade AI"
#property link      ""
#property version   "1.00"
#property script_show_inputs

#include <Object.mqh>

//--- input parameters
input color    MainGridColor = clrWhite;    // Colore griglia principale
input color    Level25Color = clrGreen;     // Colore livello 0.25
input color    Level33Color = clrRed;       // Colore livello 0.333
input color    Level50Color = clrYellow;    // Colore livello 0.5
input color    Level66Color = clrRed;       // Colore livello 0.666
input color    Level75Color = clrGreen;     // Colore livello 0.75
input color    ControlPointsColor = clrRed; // Colore punti di controllo

//--- global variables
string         PREFIX = "GannSq_";

//+------------------------------------------------------------------+
//| Script program start function                                      |
//+------------------------------------------------------------------+
void OnStart()
{
   // Calcola coordinate iniziali
   datetime time1 = TimeCurrent();
   datetime time2 = time1 + PeriodSeconds(Period()) * 144;
   double price1 = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double price2 = price1 + (price1 * 0.1); // 10% dell'altezza
   
   CreateGannSquare(time1, time2, price1, price2);
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Create Gann Square with control points                             |
//+------------------------------------------------------------------+
void CreateGannSquare(datetime time1, datetime time2, double price1, double price2)
{
   // Crea il rettangolo principale
   CreateRectangle(PREFIX+"Rect", time1, price1, time2, price2);
   
   // Crea i punti di controllo
   datetime timeMid = time1 + (time2 - time1) / 2;
   double priceMid = price1 + (price2 - price1) / 2;
   
   // Punto centrale per spostamento
   CreateControlPoint(PREFIX+"Center", timeMid, priceMid, ControlPointsColor);
   
   // Punti agli angoli per ridimensionamento diagonale
   CreateControlPoint(PREFIX+"TL", time1, price2, ControlPointsColor); // Top-Left
   CreateControlPoint(PREFIX+"TR", time2, price2, ControlPointsColor); // Top-Right
   CreateControlPoint(PREFIX+"BL", time1, price1, ControlPointsColor); // Bottom-Left
   CreateControlPoint(PREFIX+"BR", time2, price1, ControlPointsColor); // Bottom-Right
   
   // Punti centrali dei lati per ridimensionamento orizzontale/verticale
   CreateControlPoint(PREFIX+"TC", timeMid, price2, ControlPointsColor); // Top-Center
   CreateControlPoint(PREFIX+"BC", timeMid, price1, ControlPointsColor); // Bottom-Center
   CreateControlPoint(PREFIX+"LC", time1, priceMid, ControlPointsColor); // Left-Center
   CreateControlPoint(PREFIX+"RC", time2, priceMid, ControlPointsColor); // Right-Center
   
   // Crea le linee interne
   UpdateInternalLines();
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
   
   // Crea/aggiorna tutte le diagonali
   for(int i=0; i<ArraySize(levels); i++)
   {
      for(int j=0; j<ArraySize(levels); j++)
      {
         if(i == j) continue;
         
         datetime t1 = time1 + (int)(timeRange * levels[i]);
         datetime t2 = time1 + (int)(timeRange * levels[j]);
         double p1 = price1 + priceRange * levels[i];
         double p2 = price1 + priceRange * levels[j];
         
         CreateLine(PREFIX+"D"+DoubleToString(levels[i],3)+"_"+DoubleToString(levels[j],3),
                   t1, p1, t2, p2,
                   MainGridColor);
      }
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
void CreateControlPoint(string name, datetime time, double price, color clr)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);
      
   ObjectCreate(0, name, OBJ_ARROW, 0, time, price);
   ObjectSetInteger(0, name, OBJPROP_ARROWCODE, 251);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 1);
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
   // Aggiorna le linee interne quando si muove un oggetto
   if(id == CHARTEVENT_OBJECT_DRAG)
   {
      if(StringFind(sparam, PREFIX) == 0)
      {
         UpdateInternalLines();
         ChartRedraw();
      }
   }
}
