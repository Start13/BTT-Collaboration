//+------------------------------------------------------------------+
//|                                                  Statistics.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

// Struttura per le metriche di performance
struct SPerformanceMetrics
{
    double profitFactor;    // Fattore di profitto
    double maxDrawdown;     // Massimo drawdown
    double winRate;         // Percentuale di vincita
    double expectancy;      // Aspettativa matematica
    double sharpeRatio;     // Indice di Sharpe
    double averageWin;      // Profitto medio delle operazioni vincenti
    double averageLoss;     // Perdita media delle operazioni perdenti
    int totalTrades;        // Numero totale di operazioni
    int consecutiveLosses;  // Numero di perdite consecutive
    
    void Reset()
    {
        profitFactor = 0;
        maxDrawdown = 0;
        winRate = 0;
        expectancy = 0;
        sharpeRatio = 0;
        averageWin = 0;
        averageLoss = 0;
        totalTrades = 0;
        consecutiveLosses = 0;
    }
};

//+------------------------------------------------------------------+
//| Classe per la gestione delle statistiche                           |
//+------------------------------------------------------------------+
class CStatistics
{
private:
    double m_trades[];              // Array delle operazioni
    double m_profits[];            // Array dei profitti
    double m_correlationMatrix[][]; // Matrice di correlazione
    int m_timeframes[];            // Array dei timeframe analizzati
    int m_maxHistory;              // Massimo storico da analizzare
    
    // Metriche di performance correnti
    SPerformanceMetrics m_currentMetrics;
    
    // Metodi privati
    double CalculateCorrelation(const double &array1[], const double &array2[], const int size);
    double CalculateDrawdown(const double &equity[], const int size);
    double CalculateSharpeRatio(const double &returns[], const int size);
    
public:
    CStatistics();
    ~CStatistics() { ArrayFree(m_correlationMatrix); }
    
    // Metodi principali
    bool Initialize(const int maxHistory);
    void UpdateStats(const double profit, const bool isWin);
    void UpdateCorrelation(const int timeframe, const double correlation);
    SPerformanceMetrics GetPerformanceMetrics() const { return m_currentMetrics; }
    
    // Getters
    double GetProfitFactor() const { return m_currentMetrics.profitFactor; }
    double GetMaxDrawdown() const { return m_currentMetrics.maxDrawdown; }
    double GetWinRate() const { return m_currentMetrics.winRate; }
    double GetExpectancy() const { return m_currentMetrics.expectancy; }
    double GetSharpeRatio() const { return m_currentMetrics.sharpeRatio; }
    int GetConsecutiveLosses() const { return m_currentMetrics.consecutiveLosses; }
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CStatistics::CStatistics()
{
    m_maxHistory = 1000;
    m_currentMetrics.Reset();
    ArrayResize(m_trades, 0);
    ArrayResize(m_profits, 0);
    ArrayResize(m_timeframes, 0);
}

//+------------------------------------------------------------------+
//| Initialize statistics                                              |
//+------------------------------------------------------------------+
bool CStatistics::Initialize(const int maxHistory)
{
    if(maxHistory <= 0)
        return false;
        
    m_maxHistory = maxHistory;
    
    // Ridimensiona gli array
    ArrayResize(m_trades, 0);
    ArrayResize(m_profits, 0);
    ArrayResize(m_timeframes, 0);
    
    // Inizializza la matrice di correlazione
    ArrayResize(m_correlationMatrix, 0);
    
    return true;
}

//+------------------------------------------------------------------+
//| Update statistics with new trade                                   |
//+------------------------------------------------------------------+
void CStatistics::UpdateStats(const double profit, const bool isWin)
{
    // Aggiorna array delle operazioni
    int size = ArraySize(m_trades);
    ArrayResize(m_trades, size + 1);
    ArrayResize(m_profits, size + 1);
    
    m_trades[size] = (double)isWin;
    m_profits[size] = profit;
    
    // Limita la dimensione dello storico
    if(size > m_maxHistory)
    {
        ArrayRemove(m_trades, 0, 1);
        ArrayRemove(m_profits, 0, 1);
        size--;
    }
    
    // Aggiorna metriche
    double totalProfit = 0;
    double totalLoss = 0;
    int wins = 0;
    int losses = 0;
    
    for(int i = 0; i < size; i++)
    {
        if(m_profits[i] > 0)
        {
            totalProfit += m_profits[i];
            wins++;
        }
        else
        {
            totalLoss += MathAbs(m_profits[i]);
            losses++;
        }
    }
    
    // Calcola metriche
    m_currentMetrics.totalTrades = size;
    m_currentMetrics.winRate = (double)wins / (double)size * 100;
    
    if(losses > 0)
        m_currentMetrics.profitFactor = totalProfit / totalLoss;
    else
        m_currentMetrics.profitFactor = totalProfit;
        
    if(wins > 0)
        m_currentMetrics.averageWin = totalProfit / wins;
        
    if(losses > 0)
        m_currentMetrics.averageLoss = totalLoss / losses;
        
    m_currentMetrics.expectancy = (m_currentMetrics.winRate/100 * m_currentMetrics.averageWin) - 
                                 ((100-m_currentMetrics.winRate)/100 * m_currentMetrics.averageLoss);
                                 
    // Calcola drawdown
    m_currentMetrics.maxDrawdown = CalculateDrawdown(m_profits, size);
    
    // Calcola Sharpe Ratio
    m_currentMetrics.sharpeRatio = CalculateSharpeRatio(m_profits, size);
    
    // Aggiorna perdite consecutive
    if(!isWin)
        m_currentMetrics.consecutiveLosses++;
    else
        m_currentMetrics.consecutiveLosses = 0;
}

//+------------------------------------------------------------------+
//| Update correlation matrix                                          |
//+------------------------------------------------------------------+
void CStatistics::UpdateCorrelation(const int timeframe, const double correlation)
{
    int size = ArraySize(m_timeframes);
    int index = -1;
    
    // Trova l'indice del timeframe
    for(int i = 0; i < size; i++)
    {
        if(m_timeframes[i] == timeframe)
        {
            index = i;
            break;
        }
    }
    
    // Se il timeframe non esiste, aggiungilo
    if(index == -1)
    {
        ArrayResize(m_timeframes, size + 1);
        m_timeframes[size] = timeframe;
        index = size;
        
        // Aggiorna dimensione matrice
        ArrayResize(m_correlationMatrix, size + 1);
        for(int i = 0; i <= size; i++)
        {
            ArrayResize(m_correlationMatrix[i], size + 1);
        }
    }
    
    // Aggiorna correlazione
    m_correlationMatrix[index][index] = correlation;
}

//+------------------------------------------------------------------+
//| Calculate correlation between two arrays                           |
//+------------------------------------------------------------------+
double CStatistics::CalculateCorrelation(const double &array1[], const double &array2[], const int size)
{
    if(size <= 1)
        return 0;
        
    double sum1 = 0, sum2 = 0, sum12 = 0;
    double sum1Sq = 0, sum2Sq = 0;
    
    for(int i = 0; i < size; i++)
    {
        sum1 += array1[i];
        sum2 += array2[i];
        sum12 += array1[i] * array2[i];
        sum1Sq += array1[i] * array1[i];
        sum2Sq += array2[i] * array2[i];
    }
    
    double numerator = size * sum12 - sum1 * sum2;
    double denominator = MathSqrt((size * sum1Sq - sum1 * sum1) * (size * sum2Sq - sum2 * sum2));
    
    if(denominator == 0)
        return 0;
        
    return numerator / denominator;
}

//+------------------------------------------------------------------+
//| Calculate maximum drawdown                                         |
//+------------------------------------------------------------------+
double CStatistics::CalculateDrawdown(const double &equity[], const int size)
{
    if(size <= 1)
        return 0;
        
    double maxDrawdown = 0;
    double peak = equity[0];
    
    for(int i = 1; i < size; i++)
    {
        if(equity[i] > peak)
            peak = equity[i];
        else
        {
            double dd = (peak - equity[i]) / peak * 100;
            if(dd > maxDrawdown)
                maxDrawdown = dd;
        }
    }
    
    return maxDrawdown;
}

//+------------------------------------------------------------------+
//| Calculate Sharpe Ratio                                            |
//+------------------------------------------------------------------+
double CStatistics::CalculateSharpeRatio(const double &returns[], const int size)
{
    if(size <= 1)
        return 0;
        
    double sum = 0;
    double sumSq = 0;
    
    for(int i = 0; i < size; i++)
    {
        sum += returns[i];
        sumSq += returns[i] * returns[i];
    }
    
    double mean = sum / size;
    double variance = (sumSq - sum * sum / size) / (size - 1);
    
    if(variance <= 0)
        return 0;
        
    return mean / MathSqrt(variance);
}
