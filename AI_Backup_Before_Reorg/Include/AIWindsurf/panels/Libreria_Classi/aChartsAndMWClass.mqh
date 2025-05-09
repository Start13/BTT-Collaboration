//+------------------------------------------------------------------+
//|                                            aChartsAndMWClass.mqh |
//|              Copyright 2017, Artem A. Trishkin, Skype artmedia70 |
//|                       https://login.mql5.com/ru/users/artmedia70 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Artem A. Trishkin, Skype artmedia70"
#property link      "https://login.mql5.com/ru/users/artmedia70"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CChartsMW
  {
protected:

private:
   //---
   #define              FUNCTION                            (__FUNCTION__+" > ")       // Описание функции
   #define              TIMER_STEP_MSECONDS                 (16)                       // Шаг таймера в миллисекундах
   #define              CHARTEVENT_CHART_OPEN               (32)                       // Событие открытия нового графика
   #define              CHARTEVENT_CHART_CLOSE              (33)                       // Событие закрытия графика
   #define              CHARTEVENT_MW_SYMBOL_ADD            (34)                       // Событие добавления символа в обзор рынка
   #define              CHARTEVENT_MW_FEW_SYMBOL_ADD        (35)                       // Событие добавления нескольких символов в обзор рынка
   #define              CHARTEVENT_MW_SYMBOL_DEL            (36)                       // Событие удаления символа из обзора рынка
   #define              CHARTEVENT_MW_FEW_SYMBOL_DEL        (37)                       // Событие удаления нескольких символов из обзора рынка
   #define              CHARTEVENT_MW_CHANGE_SORT           (38)                       // Событие изменения сортировки символов в обзоре рынка
   #define              CHARTEVENT_CHART_CHANGE_ONE_CLICK   (39)                       // Событие открытия/закрытия панели OneClick
   #define              CHART_IS_ONE_CLICK_ON               ("CHART_IS_ONE_CLICK_ON")  // Флаг присутствия панели OneClick на графике
   #define              CHART_IS_ONE_CLICK_OFF              ("CHART_IS_ONE_CLICK_OFF") // Флаг отсутствия панели OneClick на графике
   //---

   //---
   struct DataCharts
     {
      long              chart_id;                        // ID графика
      string            chart_symbol;                    // Символ графика
      bool              chart_is_object;                 // Признак объекта-графика
      ENUM_TIMEFRAMES   chart_timeframe;                 // Таймфрейм графика
     };
   //---
   long                 m_chart_id;                      // ChartID() текущего графика
   long                 m_opened_chart_id;               // ChartID() открытого графика
   bool                 m_opened_is_object;              // Признак объекта открытого графика
   bool                 m_chart_prev_one_click;          // Предыдущее значение параметра "панель торговли OneClick" на чарте
   //---
   long                 m_closed_chart_id;               // ChartID() закрытого графика
   string               m_closed_symbol;                 // Symbol() закрытого графика
   bool                 m_closed_is_object;              // Признак объекта закрытого графика
   ENUM_TIMEFRAMES      m_closed_timeframe;              // Таймфрейм закрытого графика
   uchar                m_charts_num_curr;               // Количество открытых графиков
   uchar                m_charts_num_prev;               // Количество открытых графиков на прошлой проверке
   //---
   string               m_server_name;                   // Имя сервера
   string               m_account_company;               // Имя компании
   string               m_account_name;                  // Имя пользователя
   long                 m_account_login;                 // Номер счёта
   //---
   string               m_server_name_prev;              // Прошлое имя сервера
   string               m_account_company_prev;          // Прошлое имя компании
   string               m_account_name_prev;             // Прошлое имя пользователя
   long                 m_account_login_prev;            // Прошлый номер счёта
   //---
   int                  m_num_symbols_in_mw;             // Количество символов в обзоре рынка
   int                  m_num_symbols_in_array;          // Количество символов в массиве
   int                  m_last_num_symbols;              // Количество символов в обзоре рынка на прошлой проверке
   int                  m_last_num_for_ret_code;         // Количество символов в обзоре рынка на прошлой проверке для возврата в ret_code
   string               m_array_symbols[];               // Массив со списком символов
   string               m_last_added_symbol;             // Имя последнего добавленного символа
   string               m_last_deleted_symbol;           // Имя последнего удалённого символа
   string               m_last_changed_symbol;           // Имя последнего символа
   //---
   DataCharts           m_data_chart;                    // Данные открытого/закрытого графика
   DataCharts           m_array_charts_curr[];           // Массив текущих открытых графиков
   DataCharts           m_array_charts_prev[];           // Массив предыдущих открытых графиков
   
//+------------------------------------------------------------------+
//| Работа с графиками                                               |
//+------------------------------------------------------------------+
private:
   //--- Получение символа текущего графика
   string               GetSymbol(void)                                                {return(ChartSymbol(m_chart_id));}
   //--- Установка/получение ChartID() текущего графика
   void                 SetChartID(void)                                               {m_chart_id=ChartID();}
   long                 GetChartID(void)                                               {return(m_chart_id);}
   //--- Установка параметра "панель торговли OneClick" на чарте
   void                 SetChartOneClick(bool value)                                   {ChartSetInteger(m_chart_id,CHART_SHOW_ONE_CLICK,value);}
   //--- Установка/получение предыдущего параметра "панель торговли OneClick" на чарте
   void                 SetChartOneClickPrev(bool value)                               {m_chart_prev_one_click=value;}
   bool                 IsChartOneClickPrev(void)                                      {return(m_chart_prev_one_click);}
   //--- Получает количество открытых графиков и заполняет данные по ним
   uchar                GetChartNumbers(DataCharts &array_charts[]);
   //--- Возвращает флаг наличия графика в массиве
   bool                 IsPresentChart(long chart_id,DataCharts &array[]);
   //--- Возвращает ChartID() открытого графика и заполняет массив данных этого графика
   long                 GetDataOpenedChart(DataCharts &data);
   //--- Возвращает ChartID() закрытого графика и заполняет массив данных этого графика
   long                 GetDataClosedChart(DataCharts &data);
   //--- Заполняет массив символов, возвращает размер массива
   int                  FillingSymbolsBaseList(void);
   //--- Возвращает индекс символа в массиве
   short                GetSymbolIndexInBaseList(string symbol_name);
   
public:
   //--- Получение параметра "панель торговли OneClick" на чарте
   bool                 IsChartOneClick(void)                                          {return(ChartGetInteger(m_chart_id,CHART_SHOW_ONE_CLICK));}
   //--- возвращает количество имеющихся графиков
   uchar                GetChartNumbers(void)                                          {return(m_charts_num_curr);}
   //--- Возвращает ChartID() открытого графика
   long                 GetOpenedChartID(void)                                         {return(m_opened_chart_id);}
   //--- Возвращает Symbol() открытого графика
   string               GetOpenedSymbol(void)                                          {return(ChartSymbol(m_opened_chart_id));}
   //--- Возвращает таймфрейм открытого графика
   ENUM_TIMEFRAMES      GetOpenedTimeframe(void)                                       {return(ChartPeriod(m_opened_chart_id));}
   //--- Возвращает ChartID() закрытого графика
   long                 GetClosedChartID(void)                                         {return(m_closed_chart_id);}
   //--- Возвращает Symbol() закрытого графика
   string               GetClosedSymbol(void)                                          {return(m_closed_symbol);}
   //--- Возвращает таймфрейм закрытого графика
   ENUM_TIMEFRAMES      GetClosedTimeframe(void)                                       {return(m_closed_timeframe);}
   //--- Возвращает признак того, что закрытый график был объектом
   bool                 IsClosedIsObject(void)                                         {return(m_closed_is_object);}
   //--- Возвращает признак того, что открытый график - объект
   bool                 IsOpenedIsObject(void)                                         {return(m_opened_is_object);}
   //--- Проверяет открыт ли график символа
   bool                 CheckOpenChart(string symbol_name);
   bool                 CheckOpenChart(string symbol_name,ENUM_TIMEFRAMES timeframe);
   //--- Открывает график символа
   long                 OpenChart(string symbol_name,ENUM_TIMEFRAMES timeframe);
   //--- Возвращает флаг наличия открытых графиков всех символов в обзоре рынка
   bool                 IsOpenedAllCharts(void);
   
//+------------------------------------------------------------------+
//| Работа с Обзором рынка                                           |
//+------------------------------------------------------------------+
private:
   
   //--- Устанавливает/возвращает имя клиента
   void                 SetAccountName(void)                                           {m_account_name=AccountInfoString(ACCOUNT_NAME);}
   string               GetAccountName(void)                                           {return(m_account_name);}
   //--- Устанавливает/возвращает имя торгового сервера
   void                 SetAccountServer(void)                                         {m_server_name=AccountInfoString(ACCOUNT_SERVER);}
   string               GetAccountServer(void)                                         {return(m_server_name);}
   //--- Устанавливает/возвращает имя компании
   void                 SetAccountCompany(void)                                        {m_account_company=AccountInfoString(ACCOUNT_COMPANY);}
   string               GetAccountCompany(void)                                        {return(m_account_company);}
   //--- Устанавливает/возвращает номер счёта
   void                 SetAccountNumber(void)                                         {m_account_login=AccountInfoInteger(ACCOUNT_LOGIN);}
   long                 GetAccountNumber(void)                                         {return(m_account_login);}
   //--- Возвращает флаг изменений в обзоре рынка
   bool                 IsChangeSymbolListInMW(ushort &ret_code);
   //--- Возвращает флаг изменения сортировки сомволов в обзоре рынка
   bool                 IsChangeSortingSymbolsInMW(void);
   //--- Возвращает наименование удалённого символа
   string               GetDeletedSymbol(void);
   //--- Возвращает наименование добавленного символа
   string               GetAddedSymbol(void);
   //--- Возвращает наименование последнего символа, с которым было проведено действие
   string               GetLastChangedSymbol(void)                                     {return(m_last_changed_symbol);}
   //--- Возвращает индекс символа в обзоре рынка
   short                GetSymbolIndexInMW(string symbol_name, bool selected=false);
   //--- Возвращает размер массива символов
   int                  GetNumberSymbols(void)                                         {return(m_num_symbols_in_array);}
   
public:
   //--- Помещает выбранный символ в обзор рынка
   bool                 PutSymbolToMarketWatch(string symbol_name)                     {return(SymbolSelect(symbol_name,true));}
   //--- Возвращает флаг наличия символа в обзоре рынка/на сервере
   bool                 IsExistSymbolInMW(string symbol_name, bool select=false);
   //--- Возвращает количество символов в обзоре рынка
   int                  GetNumSymbolsInMW(void)                                        {return(SymbolsTotal(true));}
   //--- Возвращает количество всех доступных символов
   int                  GetNumAllSymbols(void)                                         {return(SymbolsTotal(false));}
   //--- Удаляет все возможные символы из Обзора рынка
   void                 ClearMarketWatch(void);

   //--- Обработчик событий графика
   virtual void         OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void         OnTimerEvent(void);
//--- Конструктор/деструктор
                        CChartsMW();
                       ~CChartsMW();
  };
//+------------------------------------------------------------------+
//| Конструктор                                                      |
//+------------------------------------------------------------------+
CChartsMW::CChartsMW()
  {
//--- Включим таймер
   if(!MQLInfoInteger(MQL_TESTER)) EventSetMillisecondTimer(TIMER_STEP_MSECONDS);
   //--- Установка ChartID()
   SetChartID();
   //--- Текущее и предыдущее количество открытых графиков
   m_charts_num_curr=GetChartNumbers(m_array_charts_curr);
   m_charts_num_prev=GetChartNumbers(m_array_charts_prev);
   //--- предыдущее состояние панели OnClick
   m_chart_prev_one_click=IsChartOneClick();
   //--- Данные аккаунта
   SetAccountCompany();
   SetAccountName();
   SetAccountNumber();
   SetAccountServer();
   //--- количество символов в обзоре рынка
   m_last_num_for_ret_code=m_last_num_symbols=m_num_symbols_in_mw=GetNumSymbolsInMW();
   m_num_symbols_in_array=FillingSymbolsBaseList();
  }
//+------------------------------------------------------------------+
//| Деструктор                                                       |
//+------------------------------------------------------------------+
CChartsMW::~CChartsMW()
  {
   EventKillTimer();
   ArrayFree(m_array_charts_curr);
   ArrayFree(m_array_charts_prev);
   ArrayFree(m_array_symbols);
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CChartsMW::OnTimerEvent(void)
  {
   //--- каждые 200 миллисекунд
   static int count=0;
   if(count<200) {
      count+=TIMER_STEP_MSECONDS;
      return;
      }
   //--- Обнулить счётчик
   count=0;
   
   //--- Определим изменение наличия/отсутствия панели торговли OneClick
   if(IsChartOneClick()!=IsChartOneClickPrev()) {
      if(IsChartOneClick()) EventChartCustom(m_chart_id,CHARTEVENT_CHART_CHANGE_ONE_CLICK,196,75,"CHART_IS_ONE_CLICK_ON");
      if(!IsChartOneClick())EventChartCustom(m_chart_id,CHARTEVENT_CHART_CHANGE_ONE_CLICK,196,75,"CHART_IS_ONE_CLICK_OFF");
      SetChartOneClickPrev(IsChartOneClick());
      }
   //--- Заполним данные об имеющихся графиках
   m_charts_num_curr=GetChartNumbers(m_array_charts_curr);
   if(m_charts_num_curr!=m_charts_num_prev) {
      if(m_charts_num_curr>m_charts_num_prev) {
         m_opened_chart_id=GetDataOpenedChart(m_data_chart);
         EventChartCustom(m_chart_id,CHARTEVENT_CHART_OPEN,m_opened_chart_id,GetOpenedTimeframe(),GetOpenedSymbol());
         }
      if(m_charts_num_curr<m_charts_num_prev) {
         m_closed_chart_id=GetDataClosedChart(m_data_chart);
         m_closed_symbol=m_data_chart.chart_symbol;
         EventChartCustom(m_chart_id,CHARTEVENT_CHART_CLOSE,m_closed_chart_id,GetClosedTimeframe(),GetClosedSymbol());
         }
      m_charts_num_prev=GetChartNumbers(m_array_charts_prev);
      }
      
   //--- Отлавливаем изменение в Обзоре рынка
   ushort ret_code=0;
   if(IsChangeSymbolListInMW(ret_code)) {
      EventChartCustom(m_chart_id,ret_code,m_num_symbols_in_mw,m_last_num_for_ret_code,GetLastChangedSymbol());
      m_num_symbols_in_array=FillingSymbolsBaseList();
      }
  } 
//+------------------------------------------------------------------+
//| Обработчик события графика                                       |
//+------------------------------------------------------------------+
void CChartsMW::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
  }
//+------------------------------------------------------------------+
//| Возвращает количество открытых графиков и заполняет массив       |
//+------------------------------------------------------------------+
uchar CChartsMW::GetChartNumbers(DataCharts &array_charts[]){
   long currChart, prevChart=ChartFirst(); 
   uchar i=0, limit=CHARTS_MAX; 
   ArrayResize(array_charts,i+1);
   array_charts[i].chart_id=prevChart;
   array_charts[i].chart_symbol=ChartSymbol(prevChart);
   array_charts[i].chart_is_object=ChartGetInteger(prevChart,CHART_IS_OBJECT);
   while(i<limit) { 
      currChart=ChartNext(prevChart);
      if(currChart<0) break;
      prevChart=currChart;
      i++;
      ArrayResize(array_charts,i+1);
      array_charts[i].chart_id=prevChart;
      array_charts[i].chart_symbol=ChartSymbol(prevChart);
      array_charts[i].chart_timeframe=ChartPeriod(prevChart);
      array_charts[i].chart_is_object=ChartGetInteger(prevChart,CHART_IS_OBJECT);
      }
   return((uchar)ArraySize(array_charts));
}
//+------------------------------------------------------------------+
//| Возвращает ChartID() открытого графика и заполняет массив данных |
//+------------------------------------------------------------------+
long CChartsMW::GetDataOpenedChart(DataCharts &data){
   uchar sz=(uchar)ArraySize(m_array_charts_curr);
   for(uchar i=0; i<sz; i++) {
      long chart_id=m_array_charts_curr[i].chart_id;
      if(!IsPresentChart(chart_id,m_array_charts_prev)) {
         data.chart_id=chart_id;
         data.chart_symbol=m_array_charts_curr[i].chart_symbol;
         m_opened_is_object=data.chart_is_object=m_array_charts_curr[i].chart_is_object;
         data.chart_timeframe=m_array_charts_curr[i].chart_timeframe;
         return(chart_id);
         }
      }
   return(0);
}
//+------------------------------------------------------------------+
//| Возвращает ChartID() закрытого графика и заполняет массив данных |
//+------------------------------------------------------------------+
long CChartsMW::GetDataClosedChart(DataCharts &data){
   uchar sz=(uchar)ArraySize(m_array_charts_prev);
   for(uchar i=0; i<sz; i++) {
      long chart_id=m_array_charts_prev[i].chart_id;
      if(!IsPresentChart(chart_id,m_array_charts_curr)) {
         data.chart_id=chart_id;
         data.chart_symbol=m_array_charts_prev[i].chart_symbol;
         m_closed_timeframe=data.chart_timeframe=m_array_charts_prev[i].chart_timeframe;
         m_closed_is_object=data.chart_is_object=m_array_charts_prev[i].chart_is_object;
         return(chart_id);
         }
      }
   return(0);
}
//+------------------------------------------------------------------+
//| Возвращает флаг наличия графика в массиве                        |
//+------------------------------------------------------------------+
bool CChartsMW::IsPresentChart(long chart_id,DataCharts &array[]){
   int sz=ArraySize(array);
   for(uchar i=0; i<sz; i++) {
      if(array[i].chart_id==chart_id) return(true);
      }
   return(false);
}
//+------------------------------------------------------------------+
//| Проверяет открыт ли график символа                               |
//+------------------------------------------------------------------+
bool CChartsMW::CheckOpenChart(string symbol_name) {
   long currChart, prevChart=ChartFirst(); 
   int i=0, limit=CHARTS_MAX; 
   if(ChartSymbol(prevChart)==symbol_name) return(true);
   while(i<limit) { 
      currChart=ChartNext(prevChart);  // на основании предыдущего получим новый график 
      if(currChart<0) break;           // достигли конца списка графиков 
      if(ChartSymbol(currChart)==symbol_name && !ChartGetInteger(currChart,CHART_IS_OBJECT)) return(true);
      prevChart=currChart;             // запомним идентификатор текущего графика для ChartNext() 
      i++;
      }
   return(false);
}
//+------------------------------------------------------------------+
//| Проверяет открыт ли график символа с заданным таймфреймом        |
//+------------------------------------------------------------------+
bool CChartsMW::CheckOpenChart(string symbol_name,ENUM_TIMEFRAMES timeframe) {
   long currChart, prevChart=ChartFirst(); 
   int i=0, limit=CHARTS_MAX; 
   if(ChartSymbol(prevChart)==symbol_name) return(true);
   while(i<limit) { 
      currChart=ChartNext(prevChart);  // на основании предыдущего получим новый график 
      if(currChart<0) break;           // достигли конца списка графиков 
      if(ChartSymbol(currChart)==symbol_name && ChartPeriod(currChart)==timeframe && !ChartGetInteger(currChart,CHART_IS_OBJECT)) return(true);
      prevChart=currChart;             // запомним идентификатор текущего графика для ChartNext() 
      i++;
      }
   return(false);
}
//+------------------------------------------------------------------+
//|  Открывает график символа                                        |
//+------------------------------------------------------------------+
long CChartsMW::OpenChart(string symbol_name,ENUM_TIMEFRAMES timeframe){
   long id=0;
   if(GetChartNumbers()<CHARTS_MAX) {
      if(!CheckOpenChart(symbol_name,timeframe)) {
         id=ChartOpen(symbol_name,timeframe);
         }
      }
   return(id);
}
//+------------------------------------------------------------------+
//| Возвращает флаг наличия символа на сервере                       |
//+------------------------------------------------------------------+
bool CChartsMW::IsExistSymbolInMW(string symbol_name,bool select=false){
   for(short i=0; i<SymbolsTotal(select); i++) {
      if(SymbolName(i,select)==symbol_name) return(true);
      }
   return(false);
}
//+------------------------------------------------------------------+
//|  Удаляет символы из MarketWatch                                  |
//+------------------------------------------------------------------+
void CChartsMW::ClearMarketWatch(void) {
   for(int i=SymbolsTotal(true)-1; i>=0; i--) {
      string sy=SymbolName(i,true);
      ResetLastError();
      if(!SymbolSelect(sy,false)) {
         int err=GetLastError();
         string err_txt=(CheckOpenChart(sy))?": график символа открыт":
                         err==4305?": возможно есть сделки на символе":
                         ": ошибка "+(string)err;
         Print(FUNCTION,"Не удалось удалить ",sy," из обзора рынка",err_txt);
         }
      }
}
//+------------------------------------------------------------------+
//| Проверка, что графики всех символов в обзоре рынка открыты       |
//+------------------------------------------------------------------+
bool CChartsMW::IsOpenedAllCharts(void){
   for(ushort i=0; i<GetNumSymbolsInMW(); i++) {
      string sy=SymbolName(i,true);
      if(!CheckOpenChart(sy)) return(false);
      }
   return(true);
}
//+------------------------------------------------------------------+
//|  Возвращает индекс символа в обзоре рынка                        |
//+------------------------------------------------------------------+
short CChartsMW::GetSymbolIndexInMW(string symbol_name, bool selected=false) {
   for(short i=0; i<SymbolsTotal(selected); i++) if(SymbolName(i,selected)==symbol_name) return(i);
   return(-1);
}
//+------------------------------------------------------------------+
//| Возвращает флаг изменений в обзоре рынка                         |
//+------------------------------------------------------------------+
bool CChartsMW::IsChangeSymbolListInMW(ushort &ret_code){
   m_num_symbols_in_mw=GetNumSymbolsInMW();
   m_last_added_symbol="";
   m_last_deleted_symbol="";
   //--- изменилось количество символов в обзоре
   if(m_num_symbols_in_mw!=m_last_num_symbols) {
      //--- количество символов увеличилось
      if(m_num_symbols_in_mw>m_last_num_symbols) {
         //--- добавлен один символ
         if(m_num_symbols_in_mw-m_last_num_symbols==1) ret_code=CHARTEVENT_MW_SYMBOL_ADD;
         //--- добавлено несколько символов
         else ret_code=CHARTEVENT_MW_FEW_SYMBOL_ADD;
         m_last_added_symbol=GetAddedSymbol();
         m_last_changed_symbol=m_last_added_symbol;
         }
      //--- количество символов уменьшилось
      if(m_num_symbols_in_mw<m_last_num_symbols) {
         //--- удалён один символ
         if(m_last_num_symbols-m_num_symbols_in_mw==1) ret_code=CHARTEVENT_MW_SYMBOL_DEL;
         //--- удалёно несколько символов
         else ret_code=CHARTEVENT_MW_FEW_SYMBOL_DEL;
         m_last_deleted_symbol=GetDeletedSymbol();
         m_last_changed_symbol=m_last_deleted_symbol;
         }
      m_last_num_for_ret_code=m_last_num_symbols;
      m_last_num_symbols=m_num_symbols_in_mw;
      return(true);
      }
   //--- поменялся порядок сортировки
   else {
      if(IsChangeSortingSymbolsInMW()) {
         m_last_num_for_ret_code=m_last_num_symbols;
         m_last_num_symbols=m_num_symbols_in_mw;
         ret_code=CHARTEVENT_MW_CHANGE_SORT;
         return(true);
         }
      }
   return(false);
}
//+------------------------------------------------------------------+
//| Возвращает наименование удалённого символа                       |
//+------------------------------------------------------------------+
string CChartsMW::GetDeletedSymbol(void){
   if(ArraySize(m_array_symbols)==0) {
      Print(FUNCTION,"Массив символов m_array_symbols[] пуст!");
      return("");
      }
   for(ushort i=0; i<ArraySize(m_array_symbols); i++) {
      string symbol_name=m_array_symbols[i];
      if(GetSymbolIndexInMW(symbol_name,true)<0) return(symbol_name);
      }
   return("");
}
//+------------------------------------------------------------------+
//| Возвращает наименование добавленного символа                     |
//+------------------------------------------------------------------+
string CChartsMW::GetAddedSymbol(void){
   if(ArraySize(m_array_symbols)==0) {
      Print(FUNCTION,"Массив символов m_array_symbols[] пуст!");
      return("");
      }
   for(ushort i=0; i<SymbolsTotal(true); i++) {
      string symbol_name=SymbolName(i,true);
      if(GetSymbolIndexInBaseList(symbol_name)<0) return(symbol_name);
      }
   return("");
}
//+------------------------------------------------------------------+
//| Проверка изменения сортировки символов в обзоре рынка            |
//+------------------------------------------------------------------+
bool CChartsMW::IsChangeSortingSymbolsInMW(void){
   if(ArraySize(m_array_symbols)==0) {
      //Print(FUNCTION,"Массив символов m_array_symbols[] пуст!");
      return(false);
      }
   for(ushort i=0; i<GetNumSymbolsInMW(); i++) {
      string sy_mw=SymbolName(i,true);
      string sy_ls=m_array_symbols[i];
      if(sy_ls!=sy_mw) return(true);
      }
   return(false);
}
//+------------------------------------------------------------------+
//| Заполняет массив символов                                        |
//+------------------------------------------------------------------+
int CChartsMW::FillingSymbolsBaseList(void){
   ushort n=0;
   ArrayResize(m_array_symbols,0,1000);
   for(ushort i=0; i<GetNumSymbolsInMW(); i++) {
      string symbol_name=SymbolName(i,true);
      if(symbol_name!="") {
         n++;
         ArrayResize(m_array_symbols,n,1000);
         m_array_symbols[n-1]=symbol_name;
         }
      }
   return(n);
}
//+------------------------------------------------------------------+
//|  Возвращает индекс символа в массиве                             |
//+------------------------------------------------------------------+
short CChartsMW::GetSymbolIndexInBaseList(string symbol_name) {
   for(short i=0; i<ArraySize(m_array_symbols); i++) if(m_array_symbols[i]==symbol_name) return(i);
   return(-1);
}
//+------------------------------------------------------------------+
