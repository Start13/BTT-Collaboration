//+------------------------------------------------------------------+
//|                                                  DataManager.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

// Constants for gap analysis
#define MIN_GAP_POINTS      50     // Minimum gap size for XAUUSD (5 pips)
#define MAX_GAP_POINTS     500     // Maximum gap size for XAUUSD (50 pips)
#define GAP_HISTORY_DAYS    90     // Days of gap history to analyze
#define CSV_BUFFER_SIZE  10000     // Buffer size for CSV reading

// Definizione dei tipi di gap
enum ENUM_GAP_TYPE
{
    GAP_BULLISH,    // Gap rialzista
    GAP_BEARISH,    // Gap ribassista
    GAP_NONE        // Nessun gap
};

//+------------------------------------------------------------------+
//| Struttura per le informazioni sul gap                             |
//+------------------------------------------------------------------+
struct SGapInfo
{
    ENUM_GAP_TYPE type;      // Tipo di gap
    double        size;      // Dimensione del gap in punti
    double        startPrice;// Prezzo di inizio gap
    double        endPrice;  // Prezzo di fine gap
    double        stopLoss;  // Livello di stop loss
    double        takeProfit;// Livello di take profit
    double        fillPercent; // Percentuale di riempimento
    double        fillBars;   // Numero di barre per il riempimento
    datetime      time;      // Tempo di rilevamento
    
    void SGapInfo() { Reset(); }
    void Reset()
    {
        type = GAP_NONE;
        size = 0;
        startPrice = 0;
        endPrice = 0;
        stopLoss = 0;
        takeProfit = 0;
        fillPercent = 0;
        fillBars = 0;
        time = 0;
    }
};

//+------------------------------------------------------------------+
//| Class for managing market data and gap analysis                    |
//+------------------------------------------------------------------+
class CDataManager
{
private:
    string   m_symbol;
    ENUM_TIMEFRAMES m_timeframe;
    SGapInfo m_lastGap;
    double   m_gapThreshold;
    
    // CSV file paths
    string   m_barsFile;
    string   m_ticksFile;
    
    // Statistical variables
    double   m_avgGapSize;
    double   m_avgFillPercent;
    double   m_avgFillBars;
    double   m_gapSuccessRate;
    SGapInfo m_gapHistory[];
    
    bool     AnalyzeGapStatistics();
    bool     IsValidGap(double gapSize);
    double   CalculateGapProbability(double gapSize, bool isBullish);
    
public:
    CDataManager();
    ~CDataManager();
    
    // Initialization
    bool Initialize(string symbol, ENUM_TIMEFRAMES timeframe);
    void SetDataFiles(string barsFile, string ticksFile);
    
    // Gap analysis methods
    bool DetectCurrentGap(double &gapSize, bool &isBullish);
    double GetGapTargetPrice(double gapSize, bool isBullish);
    double GetOptimalStopLoss(double gapSize, bool isBullish);
    double GetOptimalTakeProfit(double gapSize, bool isBullish);
    
    // Statistics getters
    double GetAverageGapSize() { return m_avgGapSize; }
    double GetAverageFillPercent() { return m_avgFillPercent; }
    double GetAverageFillBars() { return m_avgFillBars; }
    double GetGapSuccessRate() { return m_gapSuccessRate; }
    
    // Nuova funzione pubblica
    bool LoadHistoricalData();
    bool DetectGap();
    SGapInfo GetLastGap() const { return m_lastGap; }
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CDataManager::CDataManager()
{
    m_symbol = "XAUUSD";
    m_timeframe = PERIOD_M5;
    m_avgGapSize = 0;
    m_avgFillPercent = 0;
    m_avgFillBars = 0;
    m_gapSuccessRate = 0;
}

//+------------------------------------------------------------------+
//| Initialize with specific symbol and timeframe                      |
//+------------------------------------------------------------------+
bool CDataManager::Initialize(string symbol, ENUM_TIMEFRAMES timeframe)
{
    m_symbol = symbol;
    m_timeframe = timeframe;
    m_lastGap.Reset();
    m_gapThreshold = 0;
    
    return LoadHistoricalData();
}

//+------------------------------------------------------------------+
//| Set CSV data file paths                                           |
//+------------------------------------------------------------------+
void CDataManager::SetDataFiles(string barsFile, string ticksFile)
{
    m_barsFile = barsFile;
    m_ticksFile = ticksFile;
}

//+------------------------------------------------------------------+
//| Load and analyze historical data                                   |
//+------------------------------------------------------------------+
bool CDataManager::LoadHistoricalData()
{
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    // Get historical data
    int copied = CopyRates(m_symbol, m_timeframe, 0, GAP_HISTORY_DAYS * PeriodSeconds(PERIOD_D1) / PeriodSeconds(m_timeframe), rates);
    
    if(copied <= 0)
        return false;
        
    // Analyze gaps
    int gapCount = 0;
    double totalGapSize = 0;
    double totalFillPercent = 0;
    
    for(int i = copied - 1; i > 0; i--)
    {
        double gap = 0;
        bool isBullish = false;
        
        // Check for gap between current open and previous high/low
        if(rates[i].open > rates[i-1].high)
        {
            gap = rates[i].open - rates[i-1].high;
            isBullish = true;
        }
        else if(rates[i].open < rates[i-1].low)
        {
            gap = rates[i-1].low - rates[i].open;
            isBullish = false;
        }
        
        if(gap > 0)
        {
            gap = NormalizeDouble(gap / Point(), 0);
            if(gap >= m_gapThreshold)
            {
                gapCount++;
                totalGapSize += gap;
                
                // Calculate fill percentage
                double fillAmount = 0;
                if(isBullish)
                    fillAmount = rates[i].high - rates[i].open;
                else
                    fillAmount = rates[i].open - rates[i].low;
                    
                totalFillPercent += (fillAmount / gap) * 100;
            }
        }
    }
    
    // Update statistics
    if(gapCount > 0)
    {
        m_avgGapSize = totalGapSize / gapCount;
        m_avgFillPercent = totalFillPercent / gapCount;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect gap in current price                                        |
//+------------------------------------------------------------------+
bool CDataManager::DetectGap()
{
    m_lastGap.Reset();
    
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    // Get the last 2 candles
    if(CopyRates(m_symbol, m_timeframe, 0, 2, rates) != 2)
        return false;
        
    // Calculate gap size
    double gap = 0;
    
    // For bullish gap
    if(rates[0].open > rates[1].high)
    {
        gap = rates[0].open - rates[1].high;
        m_lastGap.type = GAP_BULLISH;
    }
    // For bearish gap
    else if(rates[0].open < rates[1].low)
    {
        gap = rates[1].low - rates[0].open;
        m_lastGap.type = GAP_BEARISH;
    }
    else
        return false;
        
    // Convert gap to points
    gap = NormalizeDouble(gap / Point(), 0);
    
    if(MathAbs(gap) < m_gapThreshold)
        return false;
        
    // Fill gap information
    m_lastGap.size = MathAbs(gap);
    m_lastGap.startPrice = rates[1].close;
    m_lastGap.endPrice = rates[0].open;
    m_lastGap.time = rates[0].time;
    
    // Calculate stop loss and take profit levels
    if(m_lastGap.type == GAP_BULLISH)
    {
        m_lastGap.stopLoss = rates[1].high;  // Stop loss at previous high
        m_lastGap.takeProfit = rates[0].open + (gap * Point()); // Take profit at gap size
    }
    else
    {
        m_lastGap.stopLoss = rates[1].low;   // Stop loss at previous low
        m_lastGap.takeProfit = rates[0].open - (gap * Point()); // Take profit at gap size
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Analyze gap statistics                                            |
//+------------------------------------------------------------------+
bool CDataManager::AnalyzeGapStatistics()
{
    int totalGaps = ArraySize(m_gapHistory);
    if(totalGaps == 0)
        return false;
        
    double totalSize = 0;
    double totalFillPercent = 0;
    double totalFillBars = 0;
    int filledGaps = 0;
    
    for(int i = 0; i < totalGaps; i++)
    {
        totalSize += m_gapHistory[i].size;
        totalFillPercent += m_gapHistory[i].fillPercent;
        totalFillBars += m_gapHistory[i].fillBars;
        
        if(m_gapHistory[i].fillPercent >= 100)
            filledGaps++;
    }
    
    m_avgGapSize = totalSize / totalGaps;
    m_avgFillPercent = totalFillPercent / totalGaps;
    m_avgFillBars = totalFillBars / totalGaps;
    m_gapSuccessRate = (double)filledGaps / totalGaps * 100;
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect if there's currently a gap                                  |
//+------------------------------------------------------------------+
bool CDataManager::DetectCurrentGap(double &gapSize, bool &isBullish)
{
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    if(CopyRates(m_symbol, m_timeframe, 0, 2, rates) != 2)
        return false;
        
    double gap = rates[0].open - rates[1].close;
    
    if(IsValidGap(MathAbs(gap)))
    {
        gapSize = MathAbs(gap);
        isBullish = (gap > 0);
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if gap size is valid                                        |
//+------------------------------------------------------------------+
bool CDataManager::IsValidGap(double gapSize)
{
    return (gapSize >= MIN_GAP_POINTS && gapSize <= MAX_GAP_POINTS);
}

//+------------------------------------------------------------------+
//| Calculate probability of gap fill                                  |
//+------------------------------------------------------------------+
double CDataManager::CalculateGapProbability(double gapSize, bool isBullish)
{
    int totalSimilar = 0;
    int filledSimilar = 0;
    double sizeTolerance = m_avgGapSize * 0.2; // 20% tolerance
    
    for(int i = 0; i < ArraySize(m_gapHistory); i++)
    {
        if(MathAbs(m_gapHistory[i].size - gapSize) <= sizeTolerance &&
           m_gapHistory[i].type == (isBullish ? GAP_BULLISH : GAP_BEARISH))
        {
            totalSimilar++;
            if(m_gapHistory[i].fillPercent >= 100)
                filledSimilar++;
        }
    }
    
    if(totalSimilar == 0)
        return 0;
        
    return (double)filledSimilar / totalSimilar * 100;
}

//+------------------------------------------------------------------+
//| Get optimal target price for gap trade                            |
//+------------------------------------------------------------------+
double CDataManager::GetGapTargetPrice(double gapSize, bool isBullish)
{
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    if(CopyRates(m_symbol, m_timeframe, 0, 1, rates) != 1)
        return 0;
        
    // Use average fill percentage to calculate target
    double targetMove = gapSize * (m_avgFillPercent / 100.0);
    
    if(isBullish)
        return rates[0].open - targetMove;
    else
        return rates[0].open + targetMove;
}

//+------------------------------------------------------------------+
//| Get optimal stop loss for gap trade                               |
//+------------------------------------------------------------------+
double CDataManager::GetOptimalStopLoss(double gapSize, bool isBullish)
{
    // Use 30% of gap size as stop loss
    double stopLoss = gapSize * 0.3;
    
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    if(CopyRates(m_symbol, m_timeframe, 0, 1, rates) != 1)
        return 0;
        
    if(isBullish)
        return rates[0].open + stopLoss;
    else
        return rates[0].open - stopLoss;
}

//+------------------------------------------------------------------+
//| Get optimal take profit for gap trade                             |
//+------------------------------------------------------------------+
double CDataManager::GetOptimalTakeProfit(double gapSize, bool isBullish)
{
    // Use 80% of gap size as take profit
    double takeProfit = gapSize * 0.8;
    
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    
    if(CopyRates(m_symbol, m_timeframe, 0, 1, rates) != 1)
        return 0;
        
    if(isBullish)
        return rates[0].open - takeProfit;
    else
        return rates[0].open + takeProfit;
}
