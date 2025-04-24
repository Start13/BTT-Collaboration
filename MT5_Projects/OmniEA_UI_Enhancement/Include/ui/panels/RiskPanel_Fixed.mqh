//+------------------------------------------------------------------+
//|                                             RiskPanel.mqh |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                       AlgoWi Implementation   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

#include "..\..\ui\PanelBase.mqh"
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>

//+------------------------------------------------------------------+
//| Classe per il pannello di gestione del rischio                   |
//+------------------------------------------------------------------+
class CRiskPanel : public CPanelBase
{
private:
   // Controlli
   string            m_btnCalculateName;
   string            m_btnRiskMinusName;
   string            m_btnRiskPlusName;
   string            m_btnStopMinusName;
   string            m_btnStopPlusName;
   
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
   
   // Nome del pannello
   string            m_name;             // Nome del pannello
   
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
   virtual void      DrawHeader();
   virtual void      DrawRows();
   virtual void      CreateButtons();
   
   // Aggiornamento delle etichette
   virtual void      UpdateLabels();
   
   // Metodi di utilità
   bool              SetBounds(int x, int y, int width, int height);
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
   // Rimuovi gli oggetti grafici
   ObjectDelete(0, m_btnCalculateName);
   ObjectDelete(0, m_btnRiskMinusName);
   ObjectDelete(0, m_btnRiskPlusName);
   ObjectDelete(0, m_btnStopMinusName);
   ObjectDelete(0, m_btnStopPlusName);
}

//+------------------------------------------------------------------+
//| Imposta i limiti del pannello                                     |
//+------------------------------------------------------------------+
bool CRiskPanel::SetBounds(int x, int y, int width, int height)
{
   m_x = x;
   m_y = y;
   m_width = width;
   m_height = height;
   
   return true;
}

//+------------------------------------------------------------------+
//| Crea il pannello                                                 |
//+------------------------------------------------------------------+
bool CRiskPanel::Create(const string name)
{
   m_name = name;
   
   // Imposta le dimensioni del pannello
   int width = 300;
   int height = 250;
   
   if(!SetBounds(50, 50, width, height))
      return false;
      
   // Crea i pulsanti
   CreateButtons();
   
   // Disegna l'intestazione
   DrawHeader();
   
   // Disegna le righe
   DrawRows();
   
   return true;
}

//+------------------------------------------------------------------+
//| Crea i pulsanti del pannello                                     |
//+------------------------------------------------------------------+
void CRiskPanel::CreateButtons()
{
   int width = m_width;
   int height = m_height;
   
   // Pulsante di calcolo
   m_btnCalculateName = m_name + "_BtnCalculate";
   
   if(ObjectFind(0, m_btnCalculateName) < 0)
      ObjectCreate(0, m_btnCalculateName, OBJ_BUTTON, 0, 0, 0);
      
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_XDISTANCE, m_x + 20);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_YDISTANCE, m_y + 180);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_XSIZE, width - 40);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_YSIZE, 30);
   ObjectSetString(0, m_btnCalculateName, OBJPROP_TEXT, "Calculate");
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_BACK, false);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, m_btnCalculateName, OBJPROP_ZORDER, 1);
   
   // Pulsanti per il rischio
   m_btnRiskMinusName = m_name + "_BtnRiskMinus";
   
   if(ObjectFind(0, m_btnRiskMinusName) < 0)
      ObjectCreate(0, m_btnRiskMinusName, OBJ_BUTTON, 0, 0, 0);
      
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_XDISTANCE, m_x + 20);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_YDISTANCE, m_y + 70);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_XSIZE, 30);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_YSIZE, 20);
   ObjectSetString(0, m_btnRiskMinusName, OBJPROP_TEXT, "-");
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_BACK, false);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, m_btnRiskMinusName, OBJPROP_ZORDER, 1);
   
   m_btnRiskPlusName = m_name + "_BtnRiskPlus";
   
   if(ObjectFind(0, m_btnRiskPlusName) < 0)
      ObjectCreate(0, m_btnRiskPlusName, OBJ_BUTTON, 0, 0, 0);
      
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_XDISTANCE, m_x + width - 50);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_YDISTANCE, m_y + 70);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_XSIZE, 30);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_YSIZE, 20);
   ObjectSetString(0, m_btnRiskPlusName, OBJPROP_TEXT, "+");
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_BACK, false);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, m_btnRiskPlusName, OBJPROP_ZORDER, 1);
   
   // Pulsanti per lo stop loss
   m_btnStopMinusName = m_name + "_BtnStopMinus";
   
   if(ObjectFind(0, m_btnStopMinusName) < 0)
      ObjectCreate(0, m_btnStopMinusName, OBJ_BUTTON, 0, 0, 0);
      
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_XDISTANCE, m_x + 20);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_YDISTANCE, m_y + 100);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_XSIZE, 30);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_YSIZE, 20);
   ObjectSetString(0, m_btnStopMinusName, OBJPROP_TEXT, "-");
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_BACK, false);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, m_btnStopMinusName, OBJPROP_ZORDER, 1);
   
   m_btnStopPlusName = m_name + "_BtnStopPlus";
   
   if(ObjectFind(0, m_btnStopPlusName) < 0)
      ObjectCreate(0, m_btnStopPlusName, OBJ_BUTTON, 0, 0, 0);
      
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_XDISTANCE, m_x + width - 50);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_YDISTANCE, m_y + 100);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_XSIZE, 30);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_YSIZE, 20);
   ObjectSetString(0, m_btnStopPlusName, OBJPROP_TEXT, "+");
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_BORDER_COLOR, clrBlack);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_BACK, false);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_STATE, false);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, m_btnStopPlusName, OBJPROP_ZORDER, 1);
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pannello                                 |
//+------------------------------------------------------------------+
bool CRiskPanel::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Gestione dei clic sui pulsanti
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      // Pulsante di calcolo
      if(sparam == m_btnCalculateName)
      {
         OnCalculateClick();
         return true;
      }
      
      // Pulsante di decremento del rischio
      if(sparam == m_btnRiskMinusName)
      {
         OnRiskMinusClick();
         return true;
      }
      
      // Pulsante di incremento del rischio
      if(sparam == m_btnRiskPlusName)
      {
         OnRiskPlusClick();
         return true;
      }
      
      // Pulsante di decremento dello stop loss
      if(sparam == m_btnStopMinusName)
      {
         OnStopMinusClick();
         return true;
      }
      
      // Pulsante di incremento dello stop loss
      if(sparam == m_btnStopPlusName)
      {
         OnStopPlusClick();
         return true;
      }
   }
   
   // Gestione del cambio di simbolo
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
   
   // Ottieni il valore del punto
   double tickValue = m_symbolInfo.TickValue();
   
   // Calcola il volume
   double volume = 0.0;
   
   if(tickValue > 0)
   {
      volume = riskAmount / (stopLossPoints * tickValue);
      
      // Arrotonda il volume al lotto minimo
      double minLot = m_symbolInfo.LotsMin();
      double lotStep = m_symbolInfo.LotsStep();
      
      if(minLot > 0 && lotStep > 0)
      {
         volume = MathFloor(volume / lotStep) * lotStep;
         
         if(volume < minLot)
            volume = minLot;
            
         double maxLot = m_symbolInfo.LotsMax();
         if(volume > maxLot)
            volume = maxLot;
      }
   }
      
   return volume;
}

//+------------------------------------------------------------------+
//| Calcola l'importo a rischio in base al volume e allo stop loss   |
//+------------------------------------------------------------------+
double CRiskPanel::CalculateRiskAmount(const double volume, const double stopLossPoints)
{
   if(stopLossPoints <= 0 || volume <= 0)
      return 0.0;
      
   // Ottieni il valore del punto
   double tickValue = m_symbolInfo.TickValue();
   
   // Calcola l'importo a rischio
   double riskAmount = volume * stopLossPoints * tickValue;
   
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
   
   // Calcola l'importo a rischio
   m_riskAmount = CalculateRiskAmount(m_calculatedVolume, m_stopLossPoints);
   
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
   m_stopLossPoints = MathMax(1.0, m_stopLossPoints - m_stopStep);
   
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
//| Disegna l'intestazione del pannello                              |
//+------------------------------------------------------------------+
void CRiskPanel::DrawHeader()
{
   int x = m_x + 10;
   int y = m_y + 30;
   
   // Crea il titolo del pannello
   ObjectCreate(0, m_name + "_Title", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, m_name + "_Title", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, m_name + "_Title", OBJPROP_YDISTANCE, y);
   ObjectSetString(0, m_name + "_Title", OBJPROP_TEXT, "Risk Management Panel");
   ObjectSetInteger(0, m_name + "_Title", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_name + "_Title", OBJPROP_FONTSIZE, 12);
   ObjectSetString(0, m_name + "_Title", OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, m_name + "_Title", OBJPROP_HIDDEN, true);
   
   // Crea una linea separatrice
   y += 30;
   ObjectCreate(0, m_name + "_Separator", OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_XSIZE, m_width - 20);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_YSIZE, 2);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_COLOR, clrSilver);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_BGCOLOR, clrSilver);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, m_name + "_Separator", OBJPROP_HIDDEN, true);
}

//+------------------------------------------------------------------+
//| Disegna i controlli del pannello                                 |
//+------------------------------------------------------------------+
void CRiskPanel::DrawRows()
{
   int x = m_x + 10;
   int y = m_y + 70;
   int labelWidth = 120;
   int controlWidth = m_width - 20 - labelWidth;
   int rowHeight = 25;
   
   // Riga 1: Simbolo
   ObjectCreate(0, m_name + "_SymbolLabel", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, m_name + "_SymbolLabel", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, m_name + "_SymbolLabel", OBJPROP_YDISTANCE, y);
   ObjectSetString(0, m_name + "_SymbolLabel", OBJPROP_TEXT, "Symbol:");
   ObjectSetInteger(0, m_name + "_SymbolLabel", OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, m_name + "_SymbolLabel", OBJPROP_FONTSIZE, 10);
   ObjectSetString(0, m_name + "_SymbolLabel", OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, m_name + "_SymbolLabel", OBJPROP_HIDDEN, true);
   
   ObjectCreate(0, m_name + "_SymbolValue", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, m_name + "_SymbolValue", OBJPROP_XDISTANCE, x + labelWidth);
   ObjectSetInteger(0, m_name + "_SymbolValue", OBJPROP_YDISTANCE, y);
   ObjectSetString(0, m_name + "_SymbolValue", OBJPROP_TEXT, m_symbol);
   ObjectSetInteger(0, m_name + "_SymbolValue", OBJPROP_COLOR, clrLightYellow);
   ObjectSetInteger(0, m_name + "_SymbolValue", OBJPROP_FONTSIZE, 10);
   ObjectSetString(0, m_name + "_SymbolValue", OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, m_name + "_SymbolValue", OBJPROP_HIDDEN, true);
   
   y += rowHeight + 5;
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
