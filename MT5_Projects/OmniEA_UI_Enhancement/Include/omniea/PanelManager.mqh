//+------------------------------------------------------------------+
//|                                          PanelManager.mqh |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                 https://www.bluetrendteam.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

// Includi il PanelManager originale di OmniEA
#include <AIWindsurf\ui\PanelManager.mqh>

// Includi i pannelli personalizzati
#include "..\ui\panels\TradingPanel.mqh"
#include "..\ui\panels\MultiCurrencyPanel.mqh"
#include "..\ui\panels\RiskPanel.mqh"

//+------------------------------------------------------------------+
//| Classe per estendere il PanelManager di OmniEA                   |
//+------------------------------------------------------------------+
class CEnhancedPanelManager : public CPanelManager
{
private:
   // Pannelli personalizzati
   CTradingPanel     m_tradingPanel;
   CMultiCurrencyPanel m_multiCurrencyPanel;
   CRiskPanel        m_riskPanel;
   
   // Configurazione
   bool              m_enhancedUIEnabled;
   string            m_symbol;
   
public:
                     CEnhancedPanelManager();
                    ~CEnhancedPanelManager();
   
   // Metodi di inizializzazione e chiusura
   virtual bool      Initialize(const string symbol);
   virtual void      Shutdown();
   
   // Gestione eventi
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Gestione UI avanzata
   bool              EnableEnhancedUI(const bool enable = true);
   bool              IsEnhancedUIEnabled() const { return m_enhancedUIEnabled; }
   
   // Accesso ai pannelli
   CTradingPanel*    GetTradingPanel() { return &m_tradingPanel; }
   CMultiCurrencyPanel* GetMultiCurrencyPanel() { return &m_multiCurrencyPanel; }
   CRiskPanel*       GetRiskPanel() { return &m_riskPanel; }
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CEnhancedPanelManager::CEnhancedPanelManager()
{
   m_enhancedUIEnabled = false;
   m_symbol = "";
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CEnhancedPanelManager::~CEnhancedPanelManager()
{
   Shutdown();
}

//+------------------------------------------------------------------+
//| Inizializza il PanelManager e i pannelli personalizzati          |
//+------------------------------------------------------------------+
bool CEnhancedPanelManager::Initialize(const string symbol)
{
   // Salva il simbolo
   m_symbol = symbol;
   
   // Inizializza il PanelManager originale
   if(!CPanelManager::Initialize(symbol))
      return false;
      
   // Se l'UI avanzata è abilitata, inizializza i pannelli personalizzati
   if(m_enhancedUIEnabled)
   {
      // Inizializza il pannello di trading
      if(!m_tradingPanel.Create("OmniEA_TradingPanel"))
      {
         Print("Error initializing Trading Panel");
         return false;
      }
      
      // Posiziona il pannello
      m_tradingPanel.SetBounds(20, 20, 300, 400);
      
      // Inizializza il pannello multi-valuta
      if(!m_multiCurrencyPanel.Create("OmniEA_MultiCurrencyPanel"))
      {
         Print("Error initializing Multi-Currency Panel");
         return false;
      }
      
      // Posiziona il pannello
      m_multiCurrencyPanel.SetBounds(330, 20, 600, 400);
      
      // Inizializza il pannello di gestione del rischio
      if(!m_riskPanel.Create("OmniEA_RiskPanel"))
      {
         Print("Error initializing Risk Panel");
         return false;
      }
      
      // Posiziona il pannello
      m_riskPanel.SetBounds(20, 430, 300, 250);
      
      // Imposta il simbolo nel pannello di gestione del rischio
      m_riskPanel.SetSymbol(symbol);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Chiude il PanelManager e i pannelli personalizzati               |
//+------------------------------------------------------------------+
void CEnhancedPanelManager::Shutdown()
{
   // Chiudi il PanelManager originale
   CPanelManager::Shutdown();
   
   // Se l'UI avanzata è abilitata, chiudi i pannelli personalizzati
   if(m_enhancedUIEnabled)
   {
      // I pannelli verranno distrutti automaticamente dai loro distruttori
   }
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del PanelManager e dei pannelli personalizzati|
//+------------------------------------------------------------------+
bool CEnhancedPanelManager::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Prima passa l'evento al PanelManager originale
   if(CPanelManager::ProcessEvent(id, lparam, dparam, sparam))
      return true;
      
   // Se l'UI avanzata è abilitata, passa l'evento ai pannelli personalizzati
   if(m_enhancedUIEnabled)
   {
      // Passa l'evento al pannello di trading
      if(m_tradingPanel.ProcessEvent(id, lparam, dparam, sparam))
         return true;
         
      // Passa l'evento al pannello multi-valuta
      if(m_multiCurrencyPanel.ProcessEvent(id, lparam, dparam, sparam))
         return true;
         
      // Passa l'evento al pannello di gestione del rischio
      if(m_riskPanel.ProcessEvent(id, lparam, dparam, sparam))
         return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Abilita o disabilita l'UI avanzata                               |
//+------------------------------------------------------------------+
bool CEnhancedPanelManager::EnableEnhancedUI(const bool enable)
{
   // Se lo stato non è cambiato, non fare nulla
   if(m_enhancedUIEnabled == enable)
      return true;
      
   // Aggiorna lo stato
   m_enhancedUIEnabled = enable;
   
   // Se l'UI avanzata è stata abilitata, inizializza i pannelli personalizzati
   if(m_enhancedUIEnabled)
   {
      // Reinizializza con il simbolo corrente
      return Initialize(m_symbol);
   }
   else
   {
      // Se l'UI avanzata è stata disabilitata, chiudi i pannelli personalizzati
      Shutdown();
      
      // Reinizializza il PanelManager originale
      return CPanelManager::Initialize(m_symbol);
   }
}
