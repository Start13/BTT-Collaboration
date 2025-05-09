//+------------------------------------------------------------------+
//|                                          exTestChartsMWClass.mq5 |
//|              Copyright 2017, Artem A. Trishkin, Skype artmedia70 |
//|                       https://login.mql5.com/ru/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Artem A. Trishkin, Skype artmedia70"
#property link      "https://login.mql5.com/ru/users/artmedia70"
#property version   "1.00"

#include <aChartsAndMWClass.mqh>
CChartsMW   mw;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//--- Подключение таймера класса
   mw.OnTimerEvent();
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- Подключение обработчика событий класса
   mw.OnEvent(id,lparam,dparam,sparam);
   //--- Проверяем возвращаемые значения
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_CHART_CLOSE)         Print(FUNCTION,"Закрыт график (sparam)",sparam,", lparam: ",(string)lparam,", dparam: ",EnumToString(GetTFasEnum((int)dparam)));
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_CHART_OPEN)          Print(FUNCTION,"Открыт график (sparam)",sparam,", lparam: ",(string)lparam,", dparam: ",EnumToString(GetTFasEnum((int)dparam)));
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_MW_CHANGE_SORT)      Print(FUNCTION,"Поменялся порядок сортировки символов в обзоре рынка, lparam: ",(string)lparam,", dparam: ",(string)dparam,", sparam: ",sparam);
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_MW_SYMBOL_ADD)       Print(FUNCTION,"Добавлен символ (sparam)",sparam,", lparam: ",(string)lparam,", dparam: ",(string)dparam);
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_MW_FEW_SYMBOL_ADD)   Print(FUNCTION,"Количество символов в обзоре рынка увеличилось на ",fabs(lparam-dparam),", lparam: ",(string)lparam,", dparam: ",(string)dparam);
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_MW_SYMBOL_DEL)       Print(FUNCTION,"Удалён символ (sparam)",sparam,", lparam: ",(string)lparam,", dparam: ",(string)dparam);
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_MW_FEW_SYMBOL_DEL)   Print(FUNCTION,"Количество символов в обзоре рынка уменьшилось на ",fabs(lparam-dparam),", lparam: ",(string)lparam,", dparam: ",(string)dparam);
   if(id==CHARTEVENT_CUSTOM+CHARTEVENT_CHART_CHANGE_ONE_CLICK) {
      string res=(sparam=="CHART_IS_ONE_CLICK_ON"?"активирована":"деактивирована");
      Print(FUNCTION,"Панель OneClick ",res," (sparam)",sparam,", lparam: ",(string)lparam,", dparam: ",(string)dparam);
      }
  }
//+------------------------------------------------------------------+
//| Возвращает наименование таймфрейма                               |
//+------------------------------------------------------------------+
string GetNameTF(int timeframe=PERIOD_CURRENT) {
   if(timeframe==PERIOD_CURRENT) timeframe=Period();
   switch(timeframe) {
      //--- MQL4
      case 1: return("M1");
      case 5: return("M5");
      case 15: return("M15");
      case 30: return("M30");
      case 60: return("H1");
      case 240: return("H4");
      case 1440: return("D1");
      case 10080: return("W1");
      case 43200: return("MN");
      //--- MQL5
      case 2: return("M2");
      case 3: return("M3");
      case 4: return("M4");      
      case 6: return("M6");
      case 10: return("M10");
      case 12: return("M12");
      case 16385: return("H1");
      case 16386: return("H2");
      case 16387: return("H3");
      case 16388: return("H4");
      case 16390: return("H6");
      case 16392: return("H8");
      case 16396: return("H12");
      case 16408: return("D1");
      case 32769: return("W1");
      case 49153: return("MN");      
      default: return("UnknownPeriod");
   }
}
//+------------------------------------------------------------------+
//| Возвращает таймфрейм как enum                                    |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES GetTFasEnum(int timeframe) {
   int statement=timeframe;
   switch(statement)
     {
      //--- mql4
      case 0: return(PERIOD_CURRENT);
      case 1: return(PERIOD_M1);
      case 5: return(PERIOD_M5);
      case 15: return(PERIOD_M15);
      case 30: return(PERIOD_M30);
      case 60: return(PERIOD_H1);
      case 240: return(PERIOD_H4);
      case 1440: return(PERIOD_D1);
      case 10080: return(PERIOD_W1);
      case 43200: return(PERIOD_MN1);
      //--- mql5
      case 2: return(PERIOD_M2);
      case 3: return(PERIOD_M3);
      case 4: return(PERIOD_M4);      
      case 6: return(PERIOD_M6);
      case 10: return(PERIOD_M10);
      case 12: return(PERIOD_M12);
      case 16385: return(PERIOD_H1);
      case 16386: return(PERIOD_H2);
      case 16387: return(PERIOD_H3);
      case 16388: return(PERIOD_H4);
      case 16390: return(PERIOD_H6);
      case 16392: return(PERIOD_H8);
      case 16396: return(PERIOD_H12);
      case 16408: return(PERIOD_D1);
      case 32769: return(PERIOD_W1);
      case 49153: return(PERIOD_MN1);      
      default: return(PERIOD_CURRENT);
     }
}
//+------------------------------------------------------------------+
