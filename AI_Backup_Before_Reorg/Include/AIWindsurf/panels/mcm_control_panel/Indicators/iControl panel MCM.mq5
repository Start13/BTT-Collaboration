//+------------------------------------------------------------------+
//|                                           iControl panel MCM.mq5 |
//|                                            Copyright 2010, Lizar |
//|                            https://login.mql5.com/ru/users/Lizar |
//+------------------------------------------------------------------+
#define VERSION       "1.00 Build 2 (09 Dec 2010)"

#property copyright   "Copyright 2010, Lizar"
#property link        "https://login.mql5.com/ru/users/Lizar"
#property version     VERSION
#property description "MCM Control Panel Engine"

//---- Indicator properties:
// #property indicator_separate_window          // in separate window
#property indicator_chart_window

input color bg_color=Gray;          // Menu color
input color font_color=Gainsboro;   // Text color
input color select_color=Yellow;    // Selected color
input int   font_size=10;           // Font size

#include <Control panel MCM.mqh> //<--- include file "Control panel MCM.mqh"

string  buttom_name[]={"MCM Control panel","˂"," Chart "," Event "," Help ","˅"};
string  lebel_help[]={" MCM Control panel "+VERSION,
                      " (MultiCurrency Panel mode)",
                      " ",
                      " See Codebase for the details         ",
                      " http://www.mql5.com/en/code/215", 
                      " _____________________________________",
                      " Copyright 2010, Konstantin G. (Lizar)",
                      " https://login.mql5.com/en/users/Lizar"};
string  lebel_tools[]={ " Balance/Equity chart ",
                              " Place orders ",
                              " Ticks/bars collector ",
                              " Multitimer ",
                              " Events log "};
string  buttom_name_symbol[];
string  buttom_name_period[]={"Current period","1 minute","2 minutes","3 minutes","4 minutes","5 minutes","6 minutes","10 minutes","12 minutes","15 minutes","20 minutes","30 minutes","1 hour","2 hours","3 hours","4 hours","6 hours","8 hours","12 hours","Daily","Weekly","Monthly"};
string  buttom_name_event[]={"\"new tick\"",
                             "\"new bar\" on M1 chart",
                             "\"new bar\" on M2 chart",
                             "\"new bar\" on M3 chart",
                             "\"new bar\" on M4 chart",
                             "\"new bar\" on M5 chart",
                             "\"new bar\" on M6 chart",
                             "\"new bar\" on M10 chart",
                             "\"new bar\" on M12 chart",
                             "\"new bar\" on M15 chart",
                             "\"new bar\" on M20 chart",
                             "\"new bar\" on M30 chart",
                             "\"new bar\" on H1 chart",
                             "\"new bar\" on H2 chart",
                             "\"new bar\" on H3 chart",
                             "\"new bar\" on H4 chart",
                             "\"new bar\" on H6 chart",
                             "\"new bar\" on H8 chart",
                             "\"new bar\" on H12 chart",
                             "\"new bar\" on daily chart",
                             "\"new bar\" on weekly chart",
                             "\"new bar\" on monthly chart"};

int quantity_buttons;
int symbols_total=0, symbols_market=0;
uint flag_event=0;
long Chart_ID=0;

CMenuHorizontal menu_control_panel;
CVertical_scrolled_menus chart_symbol, chart_period, event_symbol,event_event, menu_tools, menu_help; 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//   if(chartid==0) Chart_ID=chartid;
   Chart_ID=ChartID();
   
   //---- indicator short name
      IndicatorSetString(INDICATOR_SHORTNAME,"Control panel MCM");
   //----

   if(!EventSetTimer(1))
      { Print("Error in setting of timer of MCM Control panel "); return(1);}
 
   quantity_buttons=ArraySize(buttom_name);

   menu_control_panel.Create(buttom_name,bg_color,font_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);
   CControlElement *element;
   element=menu_control_panel.GetNodeAtIndex(1);
   int coord_x=element.Coord_x();
   int coord_y=element.Coord_y();
   menu_tools.Create("  Symbols","Enable/disable",lebel_tools,coord_x,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);    
   
   symbols_total=SymbolsTotal(false);
   symbols_market=SymbolsTotal(true);
   ArrayResize(buttom_name_symbol,symbols_total);
   for(int pos=0;pos<symbols_total;pos++) // loop on all symbols
      buttom_name_symbol[pos]=SymbolName(pos,false); // get symbol name
   StatusRestoration();
  
   menu_control_panel.StatusMessage(MSG_SYMBOL_CHANGE+IntegerToString(symbols_total));
   
   element=menu_control_panel.GetNodeAtIndex(3);
   coord_x=element.Coord_x();
   coord_y=element.Coord_y();
   chart_symbol.Create("  Symbols","Change",buttom_name_symbol,coord_x,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);      
   
   chart_symbol.SynchronizationTradingTools();   
     
   chart_symbol.SelectOneElement(ChartSymbol(Chart_ID));
   chart_symbol.ChangeStateSelect();
   
   chart_period.Create("  Timeframes","Change timeframe",buttom_name_period,coord_x+chart_symbol.GetMenuWidth()+1,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);      
   chart_period.SelectOneElement(PeriodToString(ChartPeriod(Chart_ID)));
   chart_period.ChangeStateSelect();

   element=menu_control_panel.GetNodeAtIndex(1);
   coord_x=element.Coord_x();
   coord_y=element.Coord_y();
   
   element=menu_control_panel.GetNodeAtIndex(4);
   coord_x=element.Coord_x();
   coord_y=element.Coord_y();
   event_symbol.Create("  Symbols","",buttom_name_symbol,coord_x,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);      
   event_symbol.SynchronizationTradingTools();   
   coord_x=element.Coord_x();
   coord_y=element.Coord_y();
   event_event.Create("  Events description","Enable/Disable events",buttom_name_event,coord_x+chart_symbol.GetMenuWidth()+1,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);
   
   menu_help.Create("   Brief info","",lebel_help,coord_x,coord_y,bg_color,font_color,select_color,"Segoe UI Semibold",font_size,Chart_ID,0,CORNER_LEFT_LOWER);      

   Print("Initialization of MCM Control panel completed ");

   return(0);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   for(int i=0;i<event_symbol.Total();i++)
     {
      element_symbol_current=event_symbol.GetNodeAtIndex(i);
      DeLoadAgent();
     }
   //--- MCM Control panel deinitialization:
   menu_control_panel.Delete();
   EventKillTimer();
  }

void OnTimer()
  {
   static int prev_chart_width=0;
   static int prev_chart_height=0;
   
   if(symbols_market!=SymbolsTotal(true))
     {
      StatusRestoration();
      chart_symbol.SynchronizationTradingTools();   
      event_symbol.SynchronizationTradingTools();   
     
      symbols_market=SymbolsTotal(true);
      menu_control_panel.StatusMessage(MSG_SYMBOL_CHANGE+IntegerToString(symbols_market));
     }

//   if(menu_control_panel.GetFlagMenuHorizontal()) menu_control_panel.AlignmentCenter();
   
   int chart_width=(int)ChartGetInteger(Chart_ID,CHART_WIDTH_IN_PIXELS);
   int chart_height=(int)ChartGetInteger(Chart_ID,CHART_HEIGHT_IN_PIXELS);
   
   if(menu_control_panel.GetFlagMenuHorizontal() && (prev_chart_width!=chart_width || prev_chart_height!=chart_height))
     {      
      menu_control_panel.AlignmentCenter();
      StatusRestoration();
      prev_chart_width=chart_width;
      prev_chart_height=chart_height;
     }

   ChartRedraw();
  }

void OnChartEvent(const int id,         // event or symbol index in Market Watch+CHARTEVENT_CUSTOM  
                  const long& lparam,   // timeframe
                  const double& dparam, // price
                  const string& sparam  // symbol
                 )
  {
//   Print("id=",id);
   
   if(id>=CHARTEVENT_CUSTOM)      
     {
      menu_control_panel.StatusMessage(TimeToString(TimeCurrent(),TIME_SECONDS)+" -> id="+IntegerToString(id-CHARTEVENT_CUSTOM)+":  "+sparam+" "+EventDescription(lparam)+" price="+DoubleToString(dparam,(int)SymbolInfoInteger(sparam,SYMBOL_DIGITS)));
      return;
     }
   
   switch(id)
     {
      case CHARTEVENT_OBJECT_CLICK:
        {
         if(sparam==buttom_name[0]) { ButtonControlPanel(); return; }
         if(sparam==buttom_name[1]) { ButtonCurtail();      return; }
         if(sparam==buttom_name[2]) { ButtonChart();        return; }
         if(sparam==buttom_name[3]) { ButtonEvent();        return; }
         if(sparam==buttom_name[4]) { ButtonHelp();         return; }
         if(sparam==buttom_name[5]) { ButtonStatusMessage();return; }
         
         if(chart_symbol.Visibility()) { MenuChartSymbol(sparam); return; }           
         if(menu_tools.Visibility())   { MenuControlPanel(sparam); return; }
         if(event_symbol.Visibility()) 
           { 
            MenuEventSymbol(sparam);

            if(event_event.Visibility())
              {
                MenuEventEvents(sparam);
                return;
              }
            return;
           }
           
         if(menu_help.Visibility()) { menu_help.Scrolling(sparam); return; }
        }
     }
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,      // size of price[] array
                 const int prev_calculated,  // number of bars calculated at previous call
                 const int begin,            // the beginning of data
                 const double& price[]       // array for calculation
   )
  {  
//---
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void ButtonHelp()
  {
   if(ObjectGetInteger(0,buttom_name[4],OBJPROP_STATE)==true)
     {
      StatusRestoration(4);
      CControlElement *element;
      element=menu_control_panel.GetNodeAtIndex(1);
      int coord_x=element.Coord_x();
      int coord_y=element.Coord_y();
      
      menu_help.Display(coord_x,coord_y);
      menu_control_panel.StatusMessage(MSG_HELP);
     }
   else
     {
      menu_control_panel.StatusMessage(MSG_EVENT);
      menu_help.Hide();
      ObjectSetInteger(0,buttom_name[4],OBJPROP_COLOR,font_color);
     }      
   return;
  }


void ButtonStatusMessage()
  {
   if(menu_control_panel.GetFlagStatusMessage())
     {
      StatusRestoration();
      menu_control_panel.HideStatusMessage();
     }
   else
     {
      StatusRestoration();
      menu_control_panel.DisplayStatusMessage();
      menu_control_panel.StatusMessage(MSG_EVENT);
     }      
   return;
  }
  
void ButtonChart()
  {
   if(ObjectGetInteger(0,buttom_name[2],OBJPROP_STATE)==true)
     {
      StatusRestoration(2);
      
      CControlElement *element;
      element=menu_control_panel.GetNodeAtIndex(3);
      int coord_x=element.Coord_x();
      int coord_y=element.Coord_y();
      chart_symbol.ChangeState();
      chart_symbol.Display(coord_x,coord_y);
      chart_period.ChangeState();  
      chart_period.Display(coord_x+chart_symbol.GetMenuWidth()+1,coord_y);    
      menu_control_panel.StatusMessage(MSG_SYMBOL_PERIOD);
     }
   else
     {
      menu_control_panel.StatusMessage(MSG_EVENT);
      chart_symbol.Hide();
      chart_period.Hide();
      ObjectSetInteger(0,buttom_name[2],OBJPROP_COLOR,font_color);
     }      
   return;
  }

void ButtonControlPanel()
  {
   if(ObjectGetInteger(0,buttom_name[0],OBJPROP_STATE)==true)
     {
      StatusRestoration(0);
      CControlElement *element;
      element=menu_control_panel.GetNodeAtIndex(1);
      int coord_x=element.Coord_x();
      int coord_y=element.Coord_y();
      menu_tools.ChangeState();
      menu_tools.Display(coord_x,coord_y);
      menu_control_panel.StatusMessage("Select unit of Control Panel");
     }
   else
     {
      menu_control_panel.StatusMessage(MSG_EVENT);
      menu_tools.Hide();
      ObjectSetInteger(0,buttom_name[0],OBJPROP_COLOR,font_color);
     }      
   return;
  }
  
void ButtonCurtail()
  {
   if(menu_control_panel.GetFlagMenuHorizontal())
     {
      StatusRestoration();
      menu_control_panel.HideMenuHorizontal();
     }
   else
     {
      StatusRestoration();
      menu_control_panel.DisplayMenuHorizontal();
      menu_control_panel.StatusMessage(MSG_EVENT);
     }      
   return;
  }

void StatusRestoration(int number_bitton=0xFFFF)
  {   
   for(int i=0; i<quantity_buttons; i++) 
      if(number_bitton!=i)
        {
         if(ObjectGetInteger(0,buttom_name[i],OBJPROP_STATE))
           {
            ObjectSetInteger(0,buttom_name[i],OBJPROP_STATE,false);
            if(i==4) menu_help.Hide();
            if(i==0) menu_tools.Hide();
            if(i==2) { chart_symbol.Hide();chart_period.Hide();}
            if(i==3) { event_symbol.ChangeStateSelect(); event_symbol.Hide(); event_event.Hide(); }

           }
         ObjectSetInteger(0,buttom_name[i],OBJPROP_COLOR,font_color);
        }
      else ObjectSetInteger(0,buttom_name[i],OBJPROP_COLOR,select_color);//font_color);
   return;
  }
  
//+------------------------------------------------------------------+
//| Return string description of timeframe                           |
//+------------------------------------------------------------------+
string PeriodToString(ENUM_TIMEFRAMES period)
  {
   switch(period)
     {
      case PERIOD_CURRENT: return(buttom_name_period[0]);
      case PERIOD_M1:  return(buttom_name_period[1]);
      case PERIOD_M2:  return(buttom_name_period[2]);
      case PERIOD_M3:  return(buttom_name_period[3]);
      case PERIOD_M4:  return(buttom_name_period[4]);
      case PERIOD_M5:  return(buttom_name_period[5]);
      case PERIOD_M6:  return(buttom_name_period[6]);
      case PERIOD_M10: return(buttom_name_period[7]);
      case PERIOD_M12: return(buttom_name_period[8]);
      case PERIOD_M15: return(buttom_name_period[9]);
      case PERIOD_M20: return(buttom_name_period[10]);
      case PERIOD_M30: return(buttom_name_period[11]);
      case PERIOD_H1:  return(buttom_name_period[12]);
      case PERIOD_H2:  return(buttom_name_period[13]);
      case PERIOD_H3:  return(buttom_name_period[14]);
      case PERIOD_H4:  return(buttom_name_period[15]);
      case PERIOD_H6:  return(buttom_name_period[16]);
      case PERIOD_H8:  return(buttom_name_period[17]);
      case PERIOD_H12: return(buttom_name_period[18]);
      case PERIOD_D1:  return(buttom_name_period[19]);
      case PERIOD_W1:  return(buttom_name_period[20]);
      case PERIOD_MN1: return(buttom_name_period[21]);
     }
//---
   return(" unknown period ");
  }  
  
//+------------------------------------------------------------------+
//| Returns period as string                                         |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES StringToPeriod(int period_id)
  {
   switch(period_id)
     {
      case 0:  return(Period());
      case 1:  return(PERIOD_M1);
      case 2:  return(PERIOD_M2);
      case 3:  return(PERIOD_M3);
      case 4:  return(PERIOD_M4);
      case 5:  return(PERIOD_M5);
      case 6:  return(PERIOD_M6);
      case 7:  return(PERIOD_M10);
      case 8:  return(PERIOD_M12);
      case 9:  return(PERIOD_M15);
      case 10: return(PERIOD_M20);
      case 11: return(PERIOD_M30);
      case 12: return(PERIOD_H1);
      case 13: return(PERIOD_H2);
      case 14: return(PERIOD_H3);
      case 15: return(PERIOD_H4);
      case 16: return(PERIOD_H6);
      case 17: return(PERIOD_H8);
      case 18: return(PERIOD_H12);
      case 19: return(PERIOD_D1);
      case 20: return(PERIOD_W1);
      case 21: return(PERIOD_MN1);
     }
//---
   return(Period());
  }  
  
  
void MenuChartSymbol(string sparam)
  { 
   int chart_symbol_id=chart_symbol.SelectOneElement(sparam);
   ENUM_TIMEFRAMES chart_period_id=StringToPeriod(chart_period.SelectOneElement(sparam));            

   CControlElement *element_symbol=chart_symbol.GetLastNode();
   CControlElement *element_period=chart_period.GetLastNode();
   
   element_symbol.State(false);
   element_period.State(false);
   
   if(sparam==element_symbol.Name())
     { 
      element_symbol=chart_symbol.GetNodeAtIndex(chart_symbol_id+2);
      string name=element_symbol.Name();
      if(element_symbol.Name()!=ChartSymbol(Chart_ID))
        {
         chart_symbol.ChangeState();
         if(!ChartSetSymbolPeriod(Chart_ID,element_symbol.Name(),chart_period_id))
           Print("Error in changing of the symbol or period");
         return;
        }
     }
   else if(sparam==element_period.Name() && chart_period_id!=ChartPeriod(Chart_ID) )
     {
      chart_symbol.ChangeState();
      element_symbol=chart_symbol.GetNodeAtIndex(chart_symbol_id+2);
      if(!ChartSetSymbolPeriod(Chart_ID,element_symbol.Name(),chart_period_id))
        Print("Error in changing of the symbol or period");
      return;
     }

   chart_symbol.Scrolling(sparam);
   chart_period.Scrolling(sparam);

   return;
  }
  
void MenuControlPanel(string sparam)
  { 
   int menu_tools_id=menu_tools.SelectMuchElement(sparam);//menu_tools.SelectOneElement(sparam); 
   CControlElement *element_tools=menu_tools.GetLastNode();
   
   if(sparam==element_tools.Name())
     {
        Print("The unit(s) is not added");
     }
   element_tools.State(false);

   menu_tools.Scrolling(sparam);

   return;
  }

void ButtonEvent()
  {
   if(ObjectGetInteger(0,buttom_name[3],OBJPROP_STATE)==true)
     {
      StatusRestoration(3);
      
      CControlElement *element;
      element=menu_control_panel.GetNodeAtIndex(4);
      int coord_x=element.Coord_x();
      int coord_y=element.Coord_y();
      event_symbol.ChangeState();
      event_symbol.Display(coord_x,coord_y);      
      
      menu_control_panel.StatusMessage(MSG_ESTABLISH_EVENTS);
     }
   else
     {
      event_symbol.ChangeStateSelect();
      event_symbol.Hide();
      event_event.Hide();
      ObjectSetInteger(0,buttom_name[3],OBJPROP_COLOR,font_color);
      menu_control_panel.StatusMessage(MSG_EVENT);    
     }  
   return;
  }
 
CControlElement *element_symbol_current;
void MenuEventSymbol(string sparam)
  {
   int event_symbol_id=event_symbol.SelectMuchElement(sparam);//menu_tools.SelectOneElement(sparam); 
   CControlElement *element_event=event_symbol.GetNodeAtIndex(event_symbol_id+2);
   
   if(event_symbol_id>=0)
     if(sparam==element_event.Name())
       if(element_event.StateElement())
        {
         if(element_event.IntParam()==-1 && element_event.UIntParam()!=0)
           {
            element_symbol_current=element_event;
            LoadAgent();
           }

         flag_event=element_event.UIntParam();
         element_symbol_current=element_event;
         ChangeState();

         //--- Show events selection menu
         element_event=menu_control_panel.GetNodeAtIndex(4);
         int coord_x=element_event.Coord_x();
         int coord_y=element_event.Coord_y();

         element_event=event_event.GetNodeAtIndex(event_event.Total()-5);
         element_event.Descript("  Event list on symbol "+sparam);
         event_event.Display(coord_x+event_symbol.GetMenuWidth()+1,coord_y);
         event_event.Display(coord_x-event_event.GetMenuWidth()-1,coord_y);
         menu_control_panel.StatusMessage(MSG_ESTABLISH_EVENTS);

         //---
         return;
        }
      else 
        {
         event_event.Hide(); // Hide event selection window
         if(element_event.IntParam()!=-1)
           {
            element_symbol_current=element_event;
            DeLoadAgent();
           }
        }
     
   event_symbol.Scrolling(sparam);
   return;
  }
  
void MenuEventEvents(string sparam)
  {   
   int event_event_id=event_event.SelectMuchElement(sparam);
   CControlElement *element_event=event_event.GetNodeAtIndex(event_event_id+2);

   if(event_event_id>=0)
     if(sparam==buttom_name_event[event_event_id])
       if(element_event.StateElement())
        {
         //--- Add event
         switch(event_event_id)
           {
            case  0:  flag_event|=CHARTEVENT_TICK;       break; // "New tick" event

            case  1:  flag_event|=CHARTEVENT_NEWBAR_M1;  break; // "New bar" event on M1 chart
            case  2:  flag_event|=CHARTEVENT_NEWBAR_M2;  break; // "New bar" event on M2 chart
            case  3:  flag_event|=CHARTEVENT_NEWBAR_M3;  break; // "New bar" event on M3 chart
            case  4:  flag_event|=CHARTEVENT_NEWBAR_M4;  break; // "New bar" event on M4 chart
   
            case  5:  flag_event|=CHARTEVENT_NEWBAR_M5;  break; // "New bar" event on M5 chart
            case  6:  flag_event|=CHARTEVENT_NEWBAR_M6;  break; // "New bar" event on M6 chart
            case  7:  flag_event|=CHARTEVENT_NEWBAR_M10; break; // "New bar" event on M10 chart
            case  8:  flag_event|=CHARTEVENT_NEWBAR_M12; break; // "New bar" event on M12 chart
   
            case  9:  flag_event|=CHARTEVENT_NEWBAR_M15; break; // "New bar" event on M15 chart
            case  10: flag_event|=CHARTEVENT_NEWBAR_M20; break; // "New bar" event on M20 chart
            case  11: flag_event|=CHARTEVENT_NEWBAR_M30; break; // "New bar" event on M30 chart
            case  12: flag_event|=CHARTEVENT_NEWBAR_H1;  break; // "New bar" event on H1 chart
   
            case  13: flag_event|=CHARTEVENT_NEWBAR_H2;  break; // "New bar" event on H2 chart
            case  14: flag_event|=CHARTEVENT_NEWBAR_H3;  break; // "New bar" event on H3 chart
            case  15: flag_event|=CHARTEVENT_NEWBAR_H4;  break; // "New bar" event on H4 chart
            case  16: flag_event|=CHARTEVENT_NEWBAR_H6;  break; // "New bar" event on H6 chart
   
            case  17: flag_event|=CHARTEVENT_NEWBAR_H8;  break; // "New bar" event on H8 chart
            case  18: flag_event|=CHARTEVENT_NEWBAR_H12; break; // "New bar" event on H12 chart
            case  19: flag_event|=CHARTEVENT_NEWBAR_D1;  break; // "New bar" event on daily chart
            case  20: flag_event|=CHARTEVENT_NEWBAR_W1;  break; // "New bar" event on weekly chart
     
            case  21: flag_event|=CHARTEVENT_NEWBAR_MN1; break; // "New bar" event on monthly chart
           }
         //---
         return;
        }
      else 
        {
         //--- Delete event
         switch(event_event_id)
           {
            case  0:  flag_event&=0xFFFFFFFF^CHARTEVENT_TICK;       break; // "New tick" event

            case  1:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M1;  break; // "New bar" event on M1 chart
            case  2:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M2;  break; // "New bar" event on M2 chart
            case  3:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M3;  break; // "New bar" event on M3 chart
            case  4:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M4;  break; // "New bar" event on M4 chart
   
            case  5:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M5;  break; // "New bar" event on M5 chart
            case  6:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M6;  break; // "New bar" event on M6 chart
            case  7:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M10; break; // "New bar" event on M10 chart
            case  8:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M12; break; // "New bar" event on M12 chart
   
            case  9:  flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M15; break; // "New bar" event on M15 chart
            case  10: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M20; break; // "New bar" event on M20 chart
            case  11: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_M30; break; // "New bar" event on M30 chart
            case  12: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H1;  break; // "New bar" event on H1 chart
   
            case  13: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H2;  break; // "New bar" event on H2 chart
            case  14: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H3;  break; // "New bar" event on H3 chart
            case  15: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H4;  break; // "New bar" event on H4 chart
            case  16: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H6;  break; // "New bar" event on H6 chart
   
            case  17: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H8;  break; // "New bar" event on H8 chart
            case  18: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_H12; break; // "New bar" event on H12 chart
            case  19: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_D1;  break; // "New bar" event on daily chart
            case  20: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_W1;  break; // "New bar" event on weekly chart
     
            case  21: flag_event&=0xFFFFFFFF^CHARTEVENT_NEWBAR_MN1; break; // "New bar" event on monthly chart
           }
         //---
         return;
        }
   
   //--- check if "modify" button pressed
   element_event=event_event.GetLastNode();
   element_event.State(false);
   if(sparam==element_event.Name())
   {
      if(flag_event!=element_symbol_current.UIntParam())
        {
         element_symbol_current.UIntParam(flag_event);
         DeLoadAgent();
         if(element_symbol_current.UIntParam()!=0) LoadAgent();
        }
   }
   //---
   
   event_event.Scrolling(sparam);
   
   return;
  }

void ChangeState()
  {
   CControlElement *element;
   
   element=event_event.GetNodeAtIndex(2); 
   if((flag_event&CHARTEVENT_TICK)>0) element.StateElement(true); else element.StateElement(false);       // "New tick" event
   element=event_event.GetNodeAtIndex(3); 
   if((flag_event&CHARTEVENT_NEWBAR_M1)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M1 chart
   element=event_event.GetNodeAtIndex(4); 
   if((flag_event&CHARTEVENT_NEWBAR_M2)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M2 chart
   element=event_event.GetNodeAtIndex(5); 
   if((flag_event&CHARTEVENT_NEWBAR_M3)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M3 chart
   element=event_event.GetNodeAtIndex(6); 
   if((flag_event&CHARTEVENT_NEWBAR_M4)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M4 chart
   element=event_event.GetNodeAtIndex(7); 
   if((flag_event&CHARTEVENT_NEWBAR_M5)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M5 chart
   element=event_event.GetNodeAtIndex(8); 
   if((flag_event&CHARTEVENT_NEWBAR_M6)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on M6 chart
   element=event_event.GetNodeAtIndex(9); 
   if((flag_event&CHARTEVENT_NEWBAR_M10)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on M10 chart
   element=event_event.GetNodeAtIndex(10); 
   if((flag_event&CHARTEVENT_NEWBAR_M12)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on M12 chart
   element=event_event.GetNodeAtIndex(11); 
   if((flag_event&CHARTEVENT_NEWBAR_M15)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on M15 chart
   element=event_event.GetNodeAtIndex(12); 
   if((flag_event&CHARTEVENT_NEWBAR_M20)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on M20 chart
   element=event_event.GetNodeAtIndex(13); 
   if((flag_event&CHARTEVENT_NEWBAR_M30)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on M30 chart
   element=event_event.GetNodeAtIndex(14); 
   if((flag_event&CHARTEVENT_NEWBAR_H1)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H1 chart
   element=event_event.GetNodeAtIndex(15); 
   if((flag_event&CHARTEVENT_NEWBAR_H2)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H2 chart
   element=event_event.GetNodeAtIndex(16); 
   if((flag_event&CHARTEVENT_NEWBAR_H3)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H3 chart
   element=event_event.GetNodeAtIndex(17); 
   if((flag_event&CHARTEVENT_NEWBAR_H4)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H4 chart
   element=event_event.GetNodeAtIndex(18); 
   if((flag_event&CHARTEVENT_NEWBAR_H6)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H6 chart
   element=event_event.GetNodeAtIndex(19); 
   if((flag_event&CHARTEVENT_NEWBAR_H8)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on H8 chart
   element=event_event.GetNodeAtIndex(20); 
   if((flag_event&CHARTEVENT_NEWBAR_H12)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on H12 chart
   element=event_event.GetNodeAtIndex(21); 
   if((flag_event&CHARTEVENT_NEWBAR_D1)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on daily chart
   element=event_event.GetNodeAtIndex(22); 
   if((flag_event&CHARTEVENT_NEWBAR_W1)>0) element.StateElement(true); else element.StateElement(false);  // "New bar" event on weekly chart
   element=event_event.GetNodeAtIndex(23); 
   if((flag_event&CHARTEVENT_NEWBAR_MN1)>0) element.StateElement(true); else element.StateElement(false); // "New bar" event on monthly chart
  }
  
bool LoadAgent()
  {
   flag_event=element_symbol_current.UIntParam();
   //--- load iControl panel MCM.mq5
   int handle_control_panel=iCustom(element_symbol_current.Name(),PERIOD_M1,"Spy Control panel MCM",Chart_ID,event_symbol.IndexOf(element_symbol_current)-1,flag_event);
   
   element_symbol_current.IntParam(handle_control_panel);
   
   if(handle_control_panel==INVALID_HANDLE)
      { Print("Error in adding of MCM Spy Control Panel"); return(false);}
      
   Print("The Spy Control Panel is set on symbol ",element_symbol_current.Name());
   menu_control_panel.StatusMessage("The Spy Control panel is set on symbol "+element_symbol_current.Name());

   return(true);  
  }  
  
bool DeLoadAgent()
  {
   //--- release iControl panel MCM.mq5
   int handle_control_panel=element_symbol_current.IntParam();
   
   if(handle_control_panel==INVALID_HANDLE) return(true);
   
   element_symbol_current.IntParam(INVALID_HANDLE);
      
   if(!IndicatorRelease(handle_control_panel))
      { Print("Error release of the Spy Control panel MCM"); return(false);}
      
   Print("The Spy Control panel MCM is released on symbol ",element_symbol_current.Name());
   menu_control_panel.StatusMessage("The MCM Spy Control panel is released on symbol "+element_symbol_current.Name());
   return(true);  
  }  
  
void SetEvent(int ID, ENUM_CHART_EVENT_SYMBOL flag)
  {
   element_symbol_current=event_symbol.GetNodeAtIndex(ID);
   element_symbol_current.UIntParam(flag);
   return;
  }
