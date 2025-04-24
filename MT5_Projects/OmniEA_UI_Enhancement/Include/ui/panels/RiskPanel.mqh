//+------------------------------------------------------------------+
//|                                             RiskPanel.mqh |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                 https://www.bluetrendteam.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

#include "..\controls\BaseControl.mqh"
#include "..\controls\Button.mqh"
#include "PanelBase.mqh"
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>

//+------------------------------------------------------------------+
//| Classe per il pannello di gestione del rischio                   |
//+------------------------------------------------------------------+
class CRiskPanel : public CPanelBase
{
private:
   // Controlli
   CButton           m_btnCalculate;     // Pulsante per calcolare
   CButton           m_btnRiskMinus;     // Pulsante per diminuire il rischio
   CButton           m_btnRiskPlus;      // Pulsante per aumentare il rischio
   CButton           m_btnStopMinus;     // Pulsante per diminuire lo stop loss
   CButton           m_btnStopPlus;      // Pulsante per aumentare lo stop loss
   
   // Dati
   double            m_riskPercent;      // Percentuale di rischio
   double            m_stopLossPoints;   // Stop loss in punti
   double            m_calculatedVolume; // Volume calcolato
   double            m_riskAmount;       // Importo a rischio
   
   // Oggetti per accesso ai dati
   CAccountInfo      m_accountInfo;      // Informazioni sull'account
   CSymbolInfo       m_symbolInfo;       // Informazioni sul simbolo
   
   // Configurazione
   string            m_symbol;           // Simbolo corrente
   double            m_riskStep;         // Passo di incremento/decremento del rischio
   double            m_stopStep;         // Passo di incremento/decremento dello stop loss
   
public:
                     CRiskPanel();
                    ~CRiskPanel();
   
   virtual bool      Create(const string name = "RiskPanel");
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Calcolo del rischio
   double            CalculateVolume(const double riskPercent, const double stopLossPoints);
   double            CalculateRiskAmount(const double volume, const double stopLossPoints);
   
   // Getters e Setters
   void              SetSymbol(const string symbol);
   string            GetSymbol() const { return m_symbol; }
   
   void              SetRiskPercent(const double riskPercent);
   double            GetRiskPercent() const { return m_riskPercent; }
   
   void              SetStopLossPoints(const double stopLossPoints);
   double            GetStopLossPoints() const { return m_stopLossPoints; }
   
   double            GetCalculatedVolume() const { return m_calculatedVolume; }
   double            GetRiskAmount() const { return m_riskAmount; }
   
protected:
   // Eventi
   virtual void      OnCalculateClick();
   virtual void      OnRiskMinusClick();
   virtual void      OnRiskPlusClick();
   virtual void      OnStopMinusClick();
   virtual void      OnStopPlusClick();
   
   // Disegno
   virtual void      DrawLabels();
   virtual void      UpdateLabels();
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CRiskPanel::CRiskPanel()
{
   m_riskPercent = 1.0;     // 1% di default
   m_stopLossPoints = 100;  // 100 punti di default
   m_calculatedVolume = 0.0;
   m_riskAmount = 0.0;
   m_symbol = _Symbol;
   m_riskStep = 0.1;        // 0.1% di passo
   m_stopStep = 10;         // 10 punti di passo
   
   // Inizializza il simbolo
   m_symbolInfo.Name(m_symbol);
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CRiskPanel::~CRiskPanel()
{
}

//+------------------------------------------------------------------+
//| Crea il pannello                                                 |
//+------------------------------------------------------------------+
bool CRiskPanel::Create(const string name)
{
   if(!CPanelBase::Create(name))
      return false;
      
   // Imposta le dimensioni del pannello
   int width = 300;
   int height = 250;
   
   if(!SetBounds(50, 50, width, height))
      return false;
      
   // Crea i pulsanti
   
   // Pulsante di calcolo
   if(!m_btnCalculate.Create(m_name + "_BtnCalculate", width/2 - 40, height - 40, 80, 30, "Calculate"))
      return false;
      
   m_btnCalculate.Text("Calculate");
   if(!AddControl(&m_btnCalculate))
      return false;
      
   // Pulsanti per il rischio
   if(!m_btnRiskMinus.Create(m_name + "_BtnRiskMinus", 20, 70, 30, 20, "-"))
      return false;
      
   m_btnRiskMinus.Text("-");
   if(!AddControl(&m_btnRiskMinus))
      return false;
      
   if(!m_btnRiskPlus.Create(m_name + "_BtnRiskPlus", width - 50, 70, 30, 20, "+"))
      return false;
      
   m_btnRiskPlus.Text("+");
   if(!AddControl(&m_btnRiskPlus))
      return false;
      
   // Pulsanti per lo stop loss
   if(!m_btnStopMinus.Create(m_name + "_BtnStopMinus", 20, 120, 30, 20, "-"))
      return false;
      
   m_btnStopMinus.Text("-");
   if(!AddControl(&m_btnStopMinus))
      return false;
      
   if(!m_btnStopPlus.Create(m_name + "_BtnStopPlus", width - 50, 120, 30, 20, "+"))
      return false;
      
   m_btnStopPlus.Text("+");
   if(!AddControl(&m_btnStopPlus))
      return false;
      
   // Disegna le etichette
   DrawLabels();
   
   // Calcola il volume iniziale
   OnCalculateClick();
   
   return true;
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pannello                                 |
//+------------------------------------------------------------------+
bool CRiskPanel::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Prima passa l'evento alla classe base
   if(CPanelBase::ProcessEvent(id, lparam, dparam, sparam))
      return true;
      
   // Gestione degli eventi specifici
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == m_btnCalculate.Name())
      {
         OnCalculateClick();
         return true;
      }
      else if(sparam == m_btnRiskMinus.Name())
      {
         OnRiskMinusClick();
         return true;
      }
      else if(sparam == m_btnRiskPlus.Name())
      {
         OnRiskPlusClick();
         return true;
      }
      else if(sparam == m_btnStopMinus.Name())
      {
         OnStopMinusClick();
         return true;
      }
      else if(sparam == m_btnStopPlus.Name())
      {
         OnStopPlusClick();
         return true;
      }
   }
   
   // Aggiornamento quando cambia il simbolo
   if(id == CHARTEVENT_CHART_CHANGE)
   {
      if(m_symbol != _Symbol)
      {
         SetSymbol(_Symbol);
         OnCalculateClick();
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Calcola il volume in base al rischio e allo stop loss            |
//+------------------------------------------------------------------+
double CRiskPanel::CalculateVolume(const double riskPercent, const double stopLossPoints)
{
   if(stopLossPoints <= 0)
      return 0.0;
      
   // Ottieni il saldo dell'account
   double balance = m_accountInfo.Balance();
   
   // Calcola l'importo a rischio
   double riskAmount = balance * riskPercent / 100.0;
   
   // Aggiorna l'importo a rischio
   m_riskAmount = riskAmount;
   
   // Assicurati che le informazioni sul simbolo siano aggiornate
   if(!m_symbolInfo.RefreshRates())
      return 0.0;
      
   // Calcola il valore di un pip
   double tickSize = m_symbolInfo.TickSize();
   double tickValue = m_symbolInfo.TickValue();
   double pointValue = tickValue / tickSize;
   
   // Calcola il volume
   double volume = riskAmount / (stopLossPoints * pointValue);
   
   // Arrotonda il volume al lotto minimo
   double minVolume = m_symbolInfo.LotsMin();
   double stepVolume = m_symbolInfo.LotsStep();
   
   volume = MathFloor(volume / stepVolume) * stepVolume;
   
   // Assicurati che il volume sia almeno il minimo
   if(volume < minVolume)
      volume = minVolume;
      
   // Assicurati che il volume non superi il massimo
   double maxVolume = m_symbolInfo.LotsMax();
   if(volume > maxVolume)
      volume = maxVolume;
      
   return volume;
}

//+------------------------------------------------------------------+
//| Calcola l'importo a rischio in base al volume e allo stop loss   |
//+------------------------------------------------------------------+
double CRiskPanel::CalculateRiskAmount(const double volume, const double stopLossPoints)
{
   if(stopLossPoints <= 0 || volume <= 0)
      return 0.0;
      
   // Assicurati che le informazioni sul simbolo siano aggiornate
   if(!m_symbolInfo.RefreshRates())
      return 0.0;
      
   // Calcola il valore di un pip
   double tickSize = m_symbolInfo.TickSize();
   double tickValue = m_symbolInfo.TickValue();
   double pointValue = tickValue / tickSize;
   
   // Calcola l'importo a rischio
   double riskAmount = volume * stopLossPoints * pointValue;
   
   return riskAmount;
}

//+------------------------------------------------------------------+
//| Imposta il simbolo                                               |
//+------------------------------------------------------------------+
void CRiskPanel::SetSymbol(const string symbol)
{
   m_symbol = symbol;
   m_symbolInfo.Name(symbol);
   
   // Aggiorna le etichette
   UpdateLabels();
}

//+------------------------------------------------------------------+
//| Imposta la percentuale di rischio                                |
//+------------------------------------------------------------------+
void CRiskPanel::SetRiskPercent(const double riskPercent)
{
   m_riskPercent = riskPercent;
   
   // Aggiorna le etichette
   UpdateLabels();
}

//+------------------------------------------------------------------+
//| Imposta lo stop loss in punti                                    |
//+------------------------------------------------------------------+
void CRiskPanel::SetStopLossPoints(const double stopLossPoints)
{
   m_stopLossPoints = stopLossPoints;
   
   // Aggiorna le etichette
   UpdateLabels();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di calcolo                        |
//+------------------------------------------------------------------+
void CRiskPanel::OnCalculateClick()
{
   // Calcola il volume
   m_calculatedVolume = CalculateVolume(m_riskPercent, m_stopLossPoints);
   
   // Aggiorna le etichette
   UpdateLabels();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di diminuzione del rischio        |
//+------------------------------------------------------------------+
void CRiskPanel::OnRiskMinusClick()
{
   // Diminuisci il rischio
   m_riskPercent = MathMax(0.1, m_riskPercent - m_riskStep);
   
   // Aggiorna le etichette
   UpdateLabels();
   
   // Ricalcola il volume
   OnCalculateClick();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di aumento del rischio            |
//+------------------------------------------------------------------+
void CRiskPanel::OnRiskPlusClick()
{
   // Aumenta il rischio
   m_riskPercent = m_riskPercent + m_riskStep;
   
   // Aggiorna le etichette
   UpdateLabels();
   
   // Ricalcola il volume
   OnCalculateClick();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di diminuzione dello stop loss    |
//+------------------------------------------------------------------+
void CRiskPanel::OnStopMinusClick()
{
   // Diminuisci lo stop loss
   m_stopLossPoints = MathMax(10, m_stopLossPoints - m_stopStep);
   
   // Aggiorna le etichette
   UpdateLabels();
   
   // Ricalcola il volume
   OnCalculateClick();
}

//+------------------------------------------------------------------+
//| Gestisce il click sul pulsante di aumento dello stop loss        |
//+------------------------------------------------------------------+
void CRiskPanel::OnStopPlusClick()
{
   // Aumenta lo stop loss
   m_stopLossPoints = m_stopLossPoints + m_stopStep;
   
   // Aggiorna le etichette
   UpdateLabels();
   
   // Ricalcola il volume
   OnCalculateClick();
}

//+------------------------------------------------------------------+
//| Disegna le etichette                                             |
//+------------------------------------------------------------------+
void CRiskPanel::DrawLabels()
{
   int x = 10;
   int width = m_width - 20;
   
   // Etichetta del simbolo
   string symbolLabelName = m_name + "_SymbolLabel";
   
   if(ObjectFind(0, symbolLabelName) < 0)
      ObjectCreate(0, symbolLabelName, OBJ_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, symbolLabelName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_YDISTANCE, 40);
   ObjectSetString(0, symbolLabelName, OBJPROP_TEXT, "Symbol: " + m_symbol);
   ObjectSetString(0, symbolLabelName, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, symbolLabelName, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, symbolLabelName, OBJPROP_ZORDER, 1);
   
   // Etichetta del rischio
   string riskLabelName = m_name + "_RiskLabel";
   
   if(ObjectFind(0, riskLabelName) < 0)
      ObjectCreate(0, riskLabelName, OBJ_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, riskLabelName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, riskLabelName, OBJPROP_YDISTANCE, 70);
   ObjectSetString(0, riskLabelName, OBJPROP_TEXT, "Risk: " + DoubleToString(m_riskPercent, 1) + "%");
   ObjectSetString(0, riskLabelName, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, riskLabelName, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, riskLabelName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, riskLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, riskLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, riskLabelName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, riskLabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, riskLabelName, OBJPROP_ZORDER, 1);
   
   // Etichetta dello stop loss
   string stopLabelName = m_name + "_StopLabel";
   
   if(ObjectFind(0, stopLabelName) < 0)
      ObjectCreate(0, stopLabelName, OBJ_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, stopLabelName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, stopLabelName, OBJPROP_YDISTANCE, 120);
   ObjectSetString(0, stopLabelName, OBJPROP_TEXT, "Stop Loss: " + DoubleToString(m_stopLossPoints, 0) + " points");
   ObjectSetString(0, stopLabelName, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, stopLabelName, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, stopLabelName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, stopLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, stopLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, stopLabelName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, stopLabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, stopLabelName, OBJPROP_ZORDER, 1);
   
   // Etichetta del volume calcolato
   string volumeLabelName = m_name + "_VolumeLabel";
   
   if(ObjectFind(0, volumeLabelName) < 0)
      ObjectCreate(0, volumeLabelName, OBJ_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, volumeLabelName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_YDISTANCE, 170);
   ObjectSetString(0, volumeLabelName, OBJPROP_TEXT, "Volume: " + DoubleToString(m_calculatedVolume, 2) + " lots");
   ObjectSetString(0, volumeLabelName, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, volumeLabelName, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, volumeLabelName, OBJPROP_ZORDER, 1);
   
   // Etichetta dell'importo a rischio
   string riskAmountLabelName = m_name + "_RiskAmountLabel";
   
   if(ObjectFind(0, riskAmountLabelName) < 0)
      ObjectCreate(0, riskAmountLabelName, OBJ_LABEL, 0, 0, 0);
      
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_YDISTANCE, 200);
   ObjectSetString(0, riskAmountLabelName, OBJPROP_TEXT, "Risk Amount: " + DoubleToString(m_riskAmount, 2) + " " + m_accountInfo.Currency());
   ObjectSetString(0, riskAmountLabelName, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, riskAmountLabelName, OBJPROP_ZORDER, 1);
}

//+------------------------------------------------------------------+
//| Aggiorna le etichette                                            |
//+------------------------------------------------------------------+
void CRiskPanel::UpdateLabels()
{
   // Aggiorna l'etichetta del simbolo
   string symbolLabelName = m_name + "_SymbolLabel";
   if(ObjectFind(0, symbolLabelName) >= 0)
      ObjectSetString(0, symbolLabelName, OBJPROP_TEXT, "Symbol: " + m_symbol);
      
   // Aggiorna l'etichetta del rischio
   string riskLabelName = m_name + "_RiskLabel";
   if(ObjectFind(0, riskLabelName) >= 0)
      ObjectSetString(0, riskLabelName, OBJPROP_TEXT, "Risk: " + DoubleToString(m_riskPercent, 1) + "%");
      
   // Aggiorna l'etichetta dello stop loss
   string stopLabelName = m_name + "_StopLabel";
   if(ObjectFind(0, stopLabelName) >= 0)
      ObjectSetString(0, stopLabelName, OBJPROP_TEXT, "Stop Loss: " + DoubleToString(m_stopLossPoints, 0) + " points");
      
   // Aggiorna l'etichetta del volume calcolato
   string volumeLabelName = m_name + "_VolumeLabel";
   if(ObjectFind(0, volumeLabelName) >= 0)
      ObjectSetString(0, volumeLabelName, OBJPROP_TEXT, "Volume: " + DoubleToString(m_calculatedVolume, 2) + " lots");
      
   // Aggiorna l'etichetta dell'importo a rischio
   string riskAmountLabelName = m_name + "_RiskAmountLabel";
   if(ObjectFind(0, riskAmountLabelName) >= 0)
      ObjectSetString(0, riskAmountLabelName, OBJPROP_TEXT, "Risk Amount: " + DoubleToString(m_riskAmount, 2) + " " + m_accountInfo.Currency());
}
