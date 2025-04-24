//+------------------------------------------------------------------+
//|                                                TradingPanel.mqh |
//|                                      BlueTrendTeam Implementation |
//|                                 https://github.com/Start13/BTT-Collaboration |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://github.com/Start13/BTT-Collaboration"
#property version   "1.00"
#property strict

#include "PanelBase.mqh"
#include "..\controls\Button.mqh"
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

//+------------------------------------------------------------------+
//| Classe per il pannello di trading                                |
//+------------------------------------------------------------------+
class CTradingPanel : public CPanelBase
{
private:
   // Controlli UI
   CButton           m_btnBuy;
   CButton           m_btnSell;
   CButton           m_btnCloseAll;
   
   // Oggetti di trading
   CTrade            m_trade;
   CSymbolInfo       m_symbolInfo;
   CAccountInfo      m_accountInfo;
   
   // Parametri di trading
   double            m_volume;
   double            m_stopLoss;
   double            m_takeProfit;
   int               m_slippage;
   string            m_symbol;
   
public:
                     CTradingPanel();
   virtual          ~CTradingPanel();
   
   // Creazione e distruzione
   virtual bool      Create(const string name = "TradingPanel", const int x = 20, const int y = 20, const int width = 300, const int height = 200);
   
   // Gestione eventi
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Eventi
   virtual void      OnBuyClick();
   virtual void      OnSellClick();
   virtual void      OnCloseAllClick();
   
   // Operazioni di trading
   bool              Buy();
   bool              Sell();
   bool              CloseAll();
   
   // Getters e Setters
   double            Volume() const { return m_volume; }
   void              Volume(const double volume) { m_volume = volume; }
   
   double            StopLoss() const { return m_stopLoss; }
   void              StopLoss(const double stopLoss) { m_stopLoss = stopLoss; }
   
   double            TakeProfit() const { return m_takeProfit; }
   void              TakeProfit(const double takeProfit) { m_takeProfit = takeProfit; }
   
   int               Slippage() const { return m_slippage; }
   void              Slippage(const int slippage) { m_slippage = slippage; }
   
   string            Symbol() const { return m_symbol; }
   void              Symbol(const string symbol);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CTradingPanel::CTradingPanel() : CPanelBase()
{
   m_volume = 0.1;
   m_stopLoss = 0.0;
   m_takeProfit = 0.0;
   m_slippage = 10;
   m_symbol = _Symbol;
   
   // Configura il titolo
   m_title = "Trading Panel";
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CTradingPanel::~CTradingPanel()
{
   // Nessuna operazione specifica necessaria qui
}

//+------------------------------------------------------------------+
//| Crea il pannello di trading                                      |
//+------------------------------------------------------------------+
bool CTradingPanel::Create(const string name = "TradingPanel", const int x = 20, const int y = 20, const int width = 300, const int height = 200)
{
   // Crea il pannello base
   if(!CPanelBase::Create(name, x, y, width, height))
      return false;
      
   // Inizializza il simbolo
   if(!m_symbolInfo.Name(m_symbol))
   {
      Print("Errore nell'inizializzazione del simbolo: ", m_symbol);
      return false;
   }
   
   // Crea i controlli
   
   // Pulsante Buy
   m_btnBuy = new CButton();
   if(!m_btnBuy.Create(m_name + "_btnBuy", m_x + 20, m_y + 50, 120, 30, "BUY"))
   {
      Print("Errore nella creazione del pulsante Buy");
      return false;
   }
   m_btnBuy.BackgroundColor(clrGreen);
   m_btnBuy.TextColor(clrWhite);
   AddControl(m_btnBuy);
   
   // Pulsante Sell
   m_btnSell = new CButton();
   if(!m_btnSell.Create(m_name + "_btnSell", m_x + 160, m_y + 50, 120, 30, "SELL"))
   {
      Print("Errore nella creazione del pulsante Sell");
      return false;
   }
   m_btnSell.BackgroundColor(clrRed);
   m_btnSell.TextColor(clrWhite);
   AddControl(m_btnSell);
   
   // Pulsante Close All
   m_btnCloseAll = new CButton();
   if(!m_btnCloseAll.Create(m_name + "_btnCloseAll", m_x + 20, m_y + 100, 260, 30, "CLOSE ALL"))
   {
      Print("Errore nella creazione del pulsante Close All");
      return false;
   }
   m_btnCloseAll.BackgroundColor(clrDarkGray);
   m_btnCloseAll.TextColor(clrWhite);
   AddControl(m_btnCloseAll);
   
   // Configura il trade
   m_trade.SetExpertMagicNumber(123456);  // Magic number da configurare
   m_trade.SetDeviationInPoints(m_slippage);
   m_trade.SetAsyncMode(false);  // Modalità sincrona per maggiore controllo
   
   return true;
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pannello di trading                      |
//+------------------------------------------------------------------+
bool CTradingPanel::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Gestione degli eventi del pannello base
   if(CPanelBase::ProcessEvent(id, lparam, dparam, sparam))
      return true;
      
   // Gestione degli eventi specifici
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == m_name + "_btnBuy")
      {
         OnBuyClick();
         return true;
      }
      else if(sparam == m_name + "_btnSell")
      {
         OnSellClick();
         return true;
      }
      else if(sparam == m_name + "_btnCloseAll")
      {
         OnCloseAllClick();
         return true;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Evento click sul pulsante Buy                                    |
//+------------------------------------------------------------------+
void CTradingPanel::OnBuyClick()
{
   if(Buy())
      Print("Ordine Buy eseguito con successo");
   else
      Print("Errore nell'esecuzione dell'ordine Buy: ", m_trade.ResultRetcode());
}

//+------------------------------------------------------------------+
//| Evento click sul pulsante Sell                                   |
//+------------------------------------------------------------------+
void CTradingPanel::OnSellClick()
{
   if(Sell())
      Print("Ordine Sell eseguito con successo");
   else
      Print("Errore nell'esecuzione dell'ordine Sell: ", m_trade.ResultRetcode());
}

//+------------------------------------------------------------------+
//| Evento click sul pulsante Close All                              |
//+------------------------------------------------------------------+
void CTradingPanel::OnCloseAllClick()
{
   if(CloseAll())
      Print("Tutte le posizioni chiuse con successo");
   else
      Print("Errore nella chiusura delle posizioni");
}

//+------------------------------------------------------------------+
//| Esegue un ordine Buy                                             |
//+------------------------------------------------------------------+
bool CTradingPanel::Buy()
{
   // Aggiorna i dati del simbolo
   m_symbolInfo.RefreshRates();
   
   // Calcola i livelli di stop loss e take profit
   double price = m_symbolInfo.Ask();
   double sl = m_stopLoss > 0 ? price - m_stopLoss * m_symbolInfo.Point() : 0;
   double tp = m_takeProfit > 0 ? price + m_takeProfit * m_symbolInfo.Point() : 0;
   
   // Esegue l'ordine
   return m_trade.Buy(m_volume, m_symbol, price, sl, tp, "Trading Panel");
}

//+------------------------------------------------------------------+
//| Esegue un ordine Sell                                            |
//+------------------------------------------------------------------+
bool CTradingPanel::Sell()
{
   // Aggiorna i dati del simbolo
   m_symbolInfo.RefreshRates();
   
   // Calcola i livelli di stop loss e take profit
   double price = m_symbolInfo.Bid();
   double sl = m_stopLoss > 0 ? price + m_stopLoss * m_symbolInfo.Point() : 0;
   double tp = m_takeProfit > 0 ? price - m_takeProfit * m_symbolInfo.Point() : 0;
   
   // Esegue l'ordine
   return m_trade.Sell(m_volume, m_symbol, price, sl, tp, "Trading Panel");
}

//+------------------------------------------------------------------+
//| Chiude tutte le posizioni                                        |
//+------------------------------------------------------------------+
bool CTradingPanel::CloseAll()
{
   bool result = true;
   
   // Chiude tutte le posizioni
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(m_trade.PositionClose(PositionGetSymbol(i)))
         Print("Posizione chiusa: ", PositionGetSymbol(i));
      else
      {
         Print("Errore nella chiusura della posizione ", PositionGetSymbol(i), ": ", m_trade.ResultRetcode());
         result = false;
      }
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Imposta il simbolo di trading                                    |
//+------------------------------------------------------------------+
void CTradingPanel::Symbol(const string symbol)
{
   if(m_symbol == symbol)
      return;
      
   // Verifica che il simbolo sia valido
   if(!m_symbolInfo.Name(symbol))
   {
      Print("Simbolo non valido: ", symbol);
      return;
   }
   
   m_symbol = symbol;
   
   // Aggiorna il titolo del pannello
   Title("Trading Panel - " + m_symbol);
}
//+------------------------------------------------------------------+
