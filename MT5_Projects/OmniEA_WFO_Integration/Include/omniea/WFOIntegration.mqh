//+------------------------------------------------------------------+
//|                                      WFOIntegration.mqh |
//|                                 Copyright 2025, BlueTrendTeam |
//|                                       AlgoWi Implementation   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

// Includi il file header del Walk Forward Optimizer
#include <WalkForwardOptimizer.mqh>

//+------------------------------------------------------------------+
//| Classe per integrare il Walk Forward Optimizer con OmniEA         |
//+------------------------------------------------------------------+
class CWFOIntegration
{
private:
   // Parametri di configurazione
   WFO_TIME_PERIOD    m_windowSize;
   int                m_customWindowSizeDays;
   WFO_TIME_PERIOD    m_stepSize;
   int                m_customStepSizePercent;
   int                m_stepOffset;
   string             m_outputFile;
   WFO_ESTIMATION_METHOD m_estimation;
   string             m_formula;
   double             m_pfMax;
   bool               m_closeTradesOnSeparationLine;
   
   // Stato
   bool               m_initialized;
   bool               m_wfoEnabled;
   
public:
                     CWFOIntegration();
                    ~CWFOIntegration();
   
   // Inizializzazione
   bool              Initialize(WFO_TIME_PERIOD windowSize = year, 
                               WFO_TIME_PERIOD stepSize = quarter,
                               int stepOffset = 0,
                               int customWindowSizeDays = 0,
                               int customStepSizePercent = 0);
   
   // Configurazione
   void              SetEstimationMethod(WFO_ESTIMATION_METHOD estimation, string formula = "");
   void              SetPFMax(double max);
   void              SetCloseTradesOnSeparationLine(bool enable);
   void              SetOutputFile(string filename);
   
   // Gestione dello stato
   bool              IsEnabled() const { return m_wfoEnabled; }
   void              Enable(bool enable = true) { m_wfoEnabled = enable; }
   
   // Funzioni di callback per OmniEA
   int               OnInit();
   int               OnTick();
   double            OnTester();
   void              OnTesterInit();
   void              OnTesterDeinit();
   void              OnTesterPass();
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CWFOIntegration::CWFOIntegration()
{
   m_windowSize = year;
   m_customWindowSizeDays = 0;
   m_stepSize = quarter;
   m_customStepSizePercent = 0;
   m_stepOffset = 0;
   m_outputFile = "";
   m_estimation = wfo_built_in_loose;
   m_formula = "";
   m_pfMax = 100.0;
   m_closeTradesOnSeparationLine = false;
   
   m_initialized = false;
   m_wfoEnabled = false;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CWFOIntegration::~CWFOIntegration()
{
}

//+------------------------------------------------------------------+
//| Inizializza l'integrazione con il Walk Forward Optimizer          |
//+------------------------------------------------------------------+
bool CWFOIntegration::Initialize(WFO_TIME_PERIOD windowSize, 
                                WFO_TIME_PERIOD stepSize,
                                int stepOffset,
                                int customWindowSizeDays,
                                int customStepSizePercent)
{
   // Salva i parametri
   m_windowSize = windowSize;
   m_customWindowSizeDays = customWindowSizeDays;
   m_stepSize = stepSize;
   m_customStepSizePercent = customStepSizePercent;
   m_stepOffset = stepOffset;
   
   // Imposta lo stato
   m_initialized = true;
   
   return true;
}

//+------------------------------------------------------------------+
//| Imposta il metodo di valutazione                                 |
//+------------------------------------------------------------------+
void CWFOIntegration::SetEstimationMethod(WFO_ESTIMATION_METHOD estimation, string formula)
{
   m_estimation = estimation;
   m_formula = formula;
}

//+------------------------------------------------------------------+
//| Imposta il valore massimo del profit factor                      |
//+------------------------------------------------------------------+
void CWFOIntegration::SetPFMax(double max)
{
   m_pfMax = max;
}

//+------------------------------------------------------------------+
//| Imposta se chiudere i trade sulla linea di separazione           |
//+------------------------------------------------------------------+
void CWFOIntegration::SetCloseTradesOnSeparationLine(bool enable)
{
   m_closeTradesOnSeparationLine = enable;
}

//+------------------------------------------------------------------+
//| Imposta il file di output                                        |
//+------------------------------------------------------------------+
void CWFOIntegration::SetOutputFile(string filename)
{
   m_outputFile = filename;
}

//+------------------------------------------------------------------+
//| Callback per OnInit di OmniEA                                    |
//+------------------------------------------------------------------+
int CWFOIntegration::OnInit()
{
   // Se WFO non è abilitato, restituisci successo
   if(!m_wfoEnabled)
      return INIT_SUCCEEDED;
      
   // Se non è stato inizializzato, restituisci errore
   if(!m_initialized)
   {
      Print("WFO Integration not initialized");
      return INIT_FAILED;
   }
   
   // Configura il Walk Forward Optimizer
   wfo_setEstimationMethod(m_estimation, m_formula);
   wfo_setPFmax(m_pfMax);
   wfo_setCloseTradesOnSeparationLine(m_closeTradesOnSeparationLine);
   
   // Inizializza il Walk Forward Optimizer
   int result = wfo_OnInit(m_windowSize, m_stepSize, m_stepOffset, m_customWindowSizeDays, m_customStepSizePercent);
   
   return result;
}

//+------------------------------------------------------------------+
//| Callback per OnTick di OmniEA                                    |
//+------------------------------------------------------------------+
int CWFOIntegration::OnTick()
{
   // Se WFO non è abilitato, restituisci 0 (continua normalmente)
   if(!m_wfoEnabled)
      return 0;
      
   // Chiama il Walk Forward Optimizer
   return wfo_OnTick();
}

//+------------------------------------------------------------------+
//| Callback per OnTester di OmniEA                                  |
//+------------------------------------------------------------------+
double CWFOIntegration::OnTester()
{
   // Se WFO non è abilitato, restituisci 0.0
   if(!m_wfoEnabled)
      return 0.0;
      
   // Chiama il Walk Forward Optimizer
   return wfo_OnTester();
}

//+------------------------------------------------------------------+
//| Callback per OnTesterInit di OmniEA                              |
//+------------------------------------------------------------------+
void CWFOIntegration::OnTesterInit()
{
   // Se WFO non è abilitato, non fare nulla
   if(!m_wfoEnabled)
      return;
      
   // Chiama il Walk Forward Optimizer
   wfo_OnTesterInit(m_outputFile);
}

//+------------------------------------------------------------------+
//| Callback per OnTesterDeinit di OmniEA                            |
//+------------------------------------------------------------------+
void CWFOIntegration::OnTesterDeinit()
{
   // Se WFO non è abilitato, non fare nulla
   if(!m_wfoEnabled)
      return;
      
   // Chiama il Walk Forward Optimizer
   wfo_OnTesterDeinit();
}

//+------------------------------------------------------------------+
//| Callback per OnTesterPass di OmniEA                              |
//+------------------------------------------------------------------+
void CWFOIntegration::OnTesterPass()
{
   // Se WFO non è abilitato, non fare nulla
   if(!m_wfoEnabled)
      return;
      
   // Chiama il Walk Forward Optimizer
   wfo_OnTesterPass();
}
