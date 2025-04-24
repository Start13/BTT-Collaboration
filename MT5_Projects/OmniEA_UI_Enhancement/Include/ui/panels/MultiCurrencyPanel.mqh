//+------------------------------------------------------------------+
//|                                       MultiCurrencyPanel.mqh |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                 https://www.bluetrendteam.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

#include "..\controls\BaseControl.mqh"
#include "..\controls\Button.mqh"
#include "PanelBase.mqh"
#include <Trade\SymbolInfo.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayObj.mqh>

//+------------------------------------------------------------------+
//| Classe per rappresentare una riga della griglia multi-valuta     |
//+------------------------------------------------------------------+
class CCurrencyRow
{
private:
   string            m_symbol;
   double            m_bid;
   double            m_ask;
   double            m_spread;
   double            m_dailyChange;
   datetime          m_lastUpdate;
   
public:
                     CCurrencyRow(const string symbol);
                    ~CCurrencyRow();
   
   bool              Update();
   
   // Getters
   string            Symbol() const { return m_symbol; }
   double            Bid() const { return m_bid; }
   double            Ask() const { return m_ask; }
   double            Spread() const { return m_spread; }
   double            DailyChange() const { return m_dailyChange; }
   datetime          LastUpdate() const { return m_lastUpdate; }
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CCurrencyRow::CCurrencyRow(const string symbol)
{
   m_symbol = symbol;
   m_bid = 0.0;
   m_ask = 0.0;
   m_spread = 0.0;
   m_dailyChange = 0.0;
   m_lastUpdate = 0;
   
   Update();
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CCurrencyRow::~CCurrencyRow()
{
}

//+------------------------------------------------------------------+
//| Aggiorna i dati della riga                                       |
//+------------------------------------------------------------------+
bool CCurrencyRow::Update()
{
   CSymbolInfo symbolInfo;
   
   if(!symbolInfo.Name(m_symbol))
      return false;
      
   if(!symbolInfo.RefreshRates())
      return false;
      
   m_bid = symbolInfo.Bid();
   m_ask = symbolInfo.Ask();
   m_spread = (m_ask - m_bid) / symbolInfo.Point();
   
   // Calcola la variazione giornaliera
   MqlRates rates[2];
   if(CopyRates(m_symbol, PERIOD_D1, 0, 2, rates) == 2)
   {
      double yesterdayClose = rates[0].close;
      double currentPrice = (m_bid + m_ask) / 2.0;
      m_dailyChange = (currentPrice - yesterdayClose) / yesterdayClose * 100.0;
   }
   
   m_lastUpdate = TimeCurrent();
   
   return true;
}

//+------------------------------------------------------------------+
//| Classe per il pannello di monitoraggio multi-valuta              |
//+------------------------------------------------------------------+
class CMultiCurrencyPanel : public CPanelBase
{
private:
   CArrayObj         m_rows;           // Array di righe CCurrencyRow
   CArrayString      m_symbols;        // Array di simboli monitorati
   CButton           m_btnRefresh;     // Pulsante di aggiornamento
   CButton           m_btnAdd;         // Pulsante per aggiungere simboli
   int               m_updateInterval; // Intervallo di aggiornamento in secondi
   datetime          m_lastUpdate;     // Ultimo aggiornamento
   int               m_rowHeight;      // Altezza di ogni riga
   int               m_headerHeight;   // Altezza dell'intestazione
   
public:
                     CMultiCurrencyPanel();
                    ~CMultiCurrencyPanel();
   
   virtual bool      Create(const string name = "MultiCurrencyPanel");
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Gestione simboli
   bool              AddSymbol(const string symbol);
   bool              RemoveSymbol(const string symbol);
   void              ClearSymbols();
   
   // Aggiornamento dati
   void              RefreshData();
   void              SetUpdateInterval(const int seconds) { m_updateInterval = seconds; }
   
protected:
   virtual void      OnRefreshClick();
   virtual void      OnAddClick();
   virtual void      DrawHeader();
   virtual void      DrawRows();
   virtual void      DrawRow(const int index, const int y);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CMultiCurrencyPanel::CMultiCurrencyPanel()
{
   m_updateInterval = 5; // Aggiornamento ogni 5 secondi di default
   m_lastUpdate = 0;
   m_rowHeight = 20;
   m_headerHeight = 25;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CMultiCurrencyPanel::~CMultiCurrencyPanel()
{
   ClearSymbols();
}

//+------------------------------------------------------------------+
//| Crea il pannello                                                 |
//+------------------------------------------------------------------+
bool CMultiCurrencyPanel::Create(const string name)
{
   if(!CPanelBase::Create(name))
      return false;
      
   // Imposta le dimensioni del pannello
   int width = 600;
   int height = 400;
   
   if(!SetBounds(50, 50, width, height))
      return false;
      
   // Crea il pulsante di aggiornamento
   if(!m_btnRefresh.Create(m_name + "_BtnRefresh", width - 100, 5, 80, 20, "Refresh"))
      return false;
      
   m_btnRefresh.Text("Refresh");
   if(!AddControl(&m_btnRefresh))
      return false;
      
   // Crea il pulsante per aggiungere simboli
   if(!m_btnAdd.Create(m_name + "_BtnAdd", width - 200, 5, 80, 20, "Add Symbol"))
      return false;
      
   m_btnAdd.Text("Add Symbol");
   if(!AddControl(&m_btnAdd))
      return false;
      
   // Aggiungi alcuni simboli di default
   AddSymbol("EURUSD");
   AddSymbol("GBPUSD");
   AddSymbol("USDJPY");
   AddSymbol("AUDUSD");
   
   // Disegna l'intestazione e le righe
   DrawHeader();
   DrawRows();
   
   return true;
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pannello                                 |
//+------------------------------------------------------------------+
bool CMultiCurrencyPanel::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Prima passa l'evento alla classe base
   if(CPanelBase::ProcessEvent(id, lparam, dparam, sparam))
      return true;
      
   // Gestione degli eventi specifici
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == m_btnRefresh.Name())
      {
         OnRefreshClick();
         return true;
      }
      else if(sparam == m_btnAdd.Name())
      {
         OnAddClick();
         return true;
      }
   }
   
   // Aggiornamento automatico
   if(id == CHARTEVENT_CHART_CHANGE)
   {
      datetime currentTime = TimeCurrent();
      if(currentTime - m_lastUpdate >= m_updateInterval)
      {
         RefreshData();
         m_lastUpdate = currentTime;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Aggiunge un simbolo al pannello                                  |
//+------------------------------------------------------------------+
bool CMultiCurrencyPanel::AddSymbol(const string symbol)
{
   // Verifica se il simbolo esiste
   if(!SymbolSelect(symbol, true))
      return false;
      
   // Verifica se il simbolo è già presente
   for(int i = 0; i < m_symbols.Total(); i++)
   {
      if(m_symbols.At(i) == symbol)
         return true; // Simbolo già presente
   }
   
   // Aggiungi il simbolo all'array
   m_symbols.Add(symbol);
   
   // Crea una nuova riga per il simbolo
   CCurrencyRow *row = new CCurrencyRow(symbol);
   if(row == NULL)
      return false;
      
   // Aggiungi la riga all'array
   m_rows.Add(row);
   
   // Ridisegna le righe
   DrawRows();
   
   return true;
}

//+------------------------------------------------------------------+
//| Rimuove un simbolo dal pannello                                  |
//+------------------------------------------------------------------+
bool CMultiCurrencyPanel::RemoveSymbol(const string symbol)
{
   for(int i = 0; i < m_symbols.Total(); i++)
   {
      if(m_symbols.At(i) == symbol)
      {
         // Rimuovi il simbolo dall'array
         m_symbols.Delete(i);
         
         // Rimuovi la riga corrispondente
         CCurrencyRow *row = m_rows.At(i);
         if(row != NULL)
            delete row;
            
         m_rows.Delete(i);
         
         // Ridisegna le righe
         DrawRows();
         
         return true;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Rimuove tutti i simboli dal pannello                             |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::ClearSymbols()
{
   // Rimuovi tutte le righe
   for(int i = 0; i < m_rows.Total(); i++)
   {
      CCurrencyRow *row = m_rows.At(i);
      if(row != NULL)
         delete row;
   }
   
   m_rows.Clear();
   m_symbols.Clear();
   
   // Ridisegna le righe
   DrawRows();
}

//+------------------------------------------------------------------+
//| Aggiorna i dati di tutti i simboli                               |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::RefreshData()
{
   for(int i = 0; i < m_rows.Total(); i++)
   {
      CCurrencyRow *row = m_rows.At(i);
      if(row != NULL)
         row.Update();
   }
   
   // Ridisegna le righe
   DrawRows();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di aggiornamento                  |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::OnRefreshClick()
{
   RefreshData();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di aggiunta simboli               |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::OnAddClick()
{
   // Qui si potrebbe implementare una finestra di dialogo per selezionare un simbolo
   // Per semplicità, aggiungiamo un simbolo fisso
   string newSymbol = "USDCHF";
   
   // Chiedi all'utente quale simbolo aggiungere
   // Questo è solo un esempio, in un'implementazione reale si userebbe una finestra di dialogo
   string message = "Inserisci il simbolo da aggiungere:";
   string inputSymbol = newSymbol;
   
   // Per ora aggiungiamo semplicemente il simbolo predefinito
   AddSymbol(newSymbol);
}

//+------------------------------------------------------------------+
//| Disegna l'intestazione della tabella                             |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::DrawHeader()
{
   int x = 10;
   int y = m_headerHeight;
   int width = m_width - 20;
   
   // Crea l'oggetto di intestazione
   string objName = m_name + "_Header";
   
   if(ObjectFind(0, objName) < 0)
      ObjectCreate(0, objName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, objName, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, objName, OBJPROP_YSIZE, m_headerHeight);
   ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, clrSteelBlue);
   ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, false);
   ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, objName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, objName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, objName, OBJPROP_ZORDER, 0);
   
   // Crea le etichette delle colonne
   string columns[] = {"Symbol", "Bid", "Ask", "Spread", "Daily Change", "Last Update"};
   int columnWidths[] = {100, 100, 100, 80, 100, 120};
   
   for(int i = 0; i < ArraySize(columns); i++)
   {
      string labelName = m_name + "_Header_" + IntegerToString(i);
      
      if(ObjectFind(0, labelName) < 0)
         ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0);
         
      ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, y + 5);
      ObjectSetString(0, labelName, OBJPROP_TEXT, columns[i]);
      ObjectSetString(0, labelName, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(0, labelName, OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
      ObjectSetInteger(0, labelName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, labelName, OBJPROP_SELECTED, false);
      ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, labelName, OBJPROP_ZORDER, 1);
      
      x += columnWidths[i];
   }
}

//+------------------------------------------------------------------+
//| Disegna tutte le righe della tabella                             |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::DrawRows()
{
   int y = m_headerHeight * 2;
   
   for(int i = 0; i < m_rows.Total(); i++)
   {
      DrawRow(i, y);
      y += m_rowHeight;
   }
}

//+------------------------------------------------------------------+
//| Disegna una singola riga della tabella                           |
//+------------------------------------------------------------------+
void CMultiCurrencyPanel::DrawRow(const int index, const int y)
{
   if(index < 0 || index >= m_rows.Total())
      return;
      
   CCurrencyRow *row = m_rows.At(index);
   if(row == NULL)
      return;
      
   int x = 10;
   int width = m_width - 20;
   
   // Crea l'oggetto di sfondo della riga
   string objName = m_name + "_Row_" + IntegerToString(index);
   
   if(ObjectFind(0, objName) < 0)
      ObjectCreate(0, objName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, objName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, objName, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, objName, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, objName, OBJPROP_YSIZE, m_rowHeight);
   ObjectSetInteger(0, objName, OBJPROP_BGCOLOR, index % 2 == 0 ? clrWhiteSmoke : clrGainsboro);
   ObjectSetInteger(0, objName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, objName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, objName, OBJPROP_BACK, false);
   ObjectSetInteger(0, objName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, objName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, objName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, objName, OBJPROP_ZORDER, 0);
   
   // Crea le etichette delle celle
   string values[] = {
      row.Symbol(),
      DoubleToString(row.Bid(), _Digits),
      DoubleToString(row.Ask(), _Digits),
      DoubleToString(row.Spread(), 1),
      DoubleToString(row.DailyChange(), 2) + "%",
      TimeToString(row.LastUpdate(), TIME_DATE|TIME_SECONDS)
   };
   
   int columnWidths[] = {100, 100, 100, 80, 100, 120};
   
   for(int i = 0; i < ArraySize(values); i++)
   {
      string labelName = m_name + "_Row_" + IntegerToString(index) + "_Cell_" + IntegerToString(i);
      
      if(ObjectFind(0, labelName) < 0)
         ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0);
         
      ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, y + 5);
      ObjectSetString(0, labelName, OBJPROP_TEXT, values[i]);
      ObjectSetString(0, labelName, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 10);
      ObjectSetInteger(0, labelName, OBJPROP_COLOR, i == 4 && row.DailyChange() < 0 ? clrRed : (i == 4 && row.DailyChange() > 0 ? clrGreen : clrBlack));
      ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
      ObjectSetInteger(0, labelName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, labelName, OBJPROP_SELECTED, false);
      ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, labelName, OBJPROP_ZORDER, 1);
      
      x += columnWidths[i];
   }
}
