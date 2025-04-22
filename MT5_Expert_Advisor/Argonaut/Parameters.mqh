//+------------------------------------------------------------------+
//|                                                   Parameters.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

#include "Statistics.mqh"

// Struttura per i limiti dei parametri
struct SParameterBounds
{
    double min;
    double max;
    double step;
    
    void SParameterBounds(double minValue = 0, double maxValue = 0, double stepValue = 0)
    {
        min = minValue;
        max = maxValue;
        step = stepValue;
    }
};

// Struttura per i parametri di trading
struct STradeParameters
{
    // Gap parameters
    double gapThreshold;
    double minGapSize;
    double maxGapSize;
    
    // Risk parameters
    double riskPercent;
    double maxDrawdown;
    
    // Position management
    double takeProfitMultiplier;
    double stopLossMultiplier;
    double breakEvenLevel;
    double trailStopLevel;
    
    // Learning parameters
    double learningRate;
    double momentumFactor;
    
    void Reset()
    {
        gapThreshold = 10;
        minGapSize = 5;
        maxGapSize = 100;
        riskPercent = 1.0;
        maxDrawdown = 20.0;
        takeProfitMultiplier = 2.0;
        stopLossMultiplier = 1.0;
        breakEvenLevel = 0.5;
        trailStopLevel = 0.3;
        learningRate = 0.1;
        momentumFactor = 0.9;
    }
};

//+------------------------------------------------------------------+
//| Class for managing trading parameters                              |
//+------------------------------------------------------------------+
class CParameters
{
private:
    STradeParameters    m_params;           // Current parameters
    STradeParameters    m_bestParams;       // Best performing parameters
    SParameterBounds    m_bounds[];         // Parameter bounds
    double             m_bestPerformance;   // Best performance metric
    bool               m_isOptimizing;      // Optimization flag
    
    // Private methods
    void InitializeBounds();
    void ValidateParameters();
    double CalculatePerformanceScore(const SPerformanceMetrics &metrics);
    void UpdateParameters(double gradient);
    
public:
    CParameters();
    ~CParameters() {}
    
    // Parameter optimization
    void OptimizeParameters(const SPerformanceMetrics &metrics);
    void ResetToDefault();
    
    // Getters
    double GetGapThreshold() const { return m_params.gapThreshold; }
    double GetMinGapSize() const { return m_params.minGapSize; }
    double GetMaxGapSize() const { return m_params.maxGapSize; }
    double GetRiskPercent() const { return m_params.riskPercent; }
    double GetMaxDrawdown() const { return m_params.maxDrawdown; }
    double GetTakeProfitMultiplier() const { return m_params.takeProfitMultiplier; }
    double GetStopLossMultiplier() const { return m_params.stopLossMultiplier; }
    double GetBreakEvenLevel() const { return m_params.breakEvenLevel; }
    double GetTrailStopLevel() const { return m_params.trailStopLevel; }
    
    // Setters
    void SetGapThreshold(double value);
    void SetMinGapSize(double value);
    void SetMaxGapSize(double value);
    void SetRiskPercent(double value);
    void SetMaxDrawdown(double value);
    void SetTakeProfitMultiplier(double value);
    void SetStopLossMultiplier(double value);
    void SetBreakEvenLevel(double value);
    void SetTrailStopLevel(double value);
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CParameters::CParameters()
{
    m_params.Reset();
    m_bestParams.Reset();
    m_bestPerformance = 0;
    m_isOptimizing = false;
    InitializeBounds();
}

//+------------------------------------------------------------------+
//| Initialize parameter bounds                                        |
//+------------------------------------------------------------------+
void CParameters::InitializeBounds()
{
    ArrayResize(m_bounds, 10);
    
    // Gap parameters
    m_bounds[0] = SParameterBounds(5, 50, 1);      // gapThreshold
    m_bounds[1] = SParameterBounds(1, 20, 1);      // minGapSize
    m_bounds[2] = SParameterBounds(50, 200, 10);   // maxGapSize
    
    // Risk parameters
    m_bounds[3] = SParameterBounds(0.1, 5.0, 0.1); // riskPercent
    m_bounds[4] = SParameterBounds(5.0, 30.0, 1.0);// maxDrawdown
    
    // Position management
    m_bounds[5] = SParameterBounds(1.0, 5.0, 0.1); // takeProfitMultiplier
    m_bounds[6] = SParameterBounds(0.5, 2.0, 0.1); // stopLossMultiplier
    m_bounds[7] = SParameterBounds(0.2, 1.0, 0.1); // breakEvenLevel
    m_bounds[8] = SParameterBounds(0.1, 0.5, 0.1); // trailStopLevel
    
    // Learning parameters
    m_bounds[9] = SParameterBounds(0.01, 0.5, 0.01);// learningRate
}

//+------------------------------------------------------------------+
//| Optimize parameters based on performance metrics                    |
//+------------------------------------------------------------------+
void CParameters::OptimizeParameters(const SPerformanceMetrics &metrics)
{
    if(!m_isOptimizing)
        return;
        
    double currentPerformance = CalculatePerformanceScore(metrics);
    
    if(currentPerformance > m_bestPerformance)
    {
        m_bestPerformance = currentPerformance;
        m_bestParams = m_params;
    }
    
    double gradient = m_bestPerformance - currentPerformance;
    UpdateParameters(gradient);
}

//+------------------------------------------------------------------+
//| Calculate performance score                                        |
//+------------------------------------------------------------------+
double CParameters::CalculatePerformanceScore(const SPerformanceMetrics &metrics)
{
    double score = 0;
    
    score += 0.3 * metrics.profitFactor;
    score += 0.2 * metrics.sharpeRatio;
    score += 0.2 * (100 - metrics.maxDrawdown) / 100;
    score += 0.15 * metrics.winRate / 100;
    score += 0.15 * metrics.expectancy;
    
    return score;
}

//+------------------------------------------------------------------+
//| Update parameters using gradient descent                           |
//+------------------------------------------------------------------+
void CParameters::UpdateParameters(double gradient)
{
    if(MathAbs(gradient) < 0.0001)
        return;
        
    double step = m_params.learningRate * gradient;
    
    SetGapThreshold(m_params.gapThreshold - step);
    SetMinGapSize(m_params.minGapSize - step);
    SetMaxGapSize(m_params.maxGapSize - step);
    SetRiskPercent(m_params.riskPercent - step);
    SetTakeProfitMultiplier(m_params.takeProfitMultiplier - step);
    SetStopLossMultiplier(m_params.stopLossMultiplier - step);
    SetBreakEvenLevel(m_params.breakEvenLevel - step);
    SetTrailStopLevel(m_params.trailStopLevel - step);
}

//+------------------------------------------------------------------+
//| Reset parameters to default values                                 |
//+------------------------------------------------------------------+
void CParameters::ResetToDefault()
{
    m_params.Reset();
    m_bestParams.Reset();
    m_bestPerformance = 0;
    m_isOptimizing = false;
}

//+------------------------------------------------------------------+
//| Parameter setters with bounds validation                           |
//+------------------------------------------------------------------+
void CParameters::SetGapThreshold(double value)
{
    m_params.gapThreshold = MathMax(m_bounds[0].min, 
                                  MathMin(m_bounds[0].max, value));
}

void CParameters::SetMinGapSize(double value)
{
    m_params.minGapSize = MathMax(m_bounds[1].min, 
                                MathMin(m_bounds[1].max, value));
}

void CParameters::SetMaxGapSize(double value)
{
    m_params.maxGapSize = MathMax(m_bounds[2].min, 
                                MathMin(m_bounds[2].max, value));
}

void CParameters::SetRiskPercent(double value)
{
    m_params.riskPercent = MathMax(m_bounds[3].min, 
                                 MathMin(m_bounds[3].max, value));
}

void CParameters::SetMaxDrawdown(double value)
{
    m_params.maxDrawdown = MathMax(m_bounds[4].min, 
                                 MathMin(m_bounds[4].max, value));
}

void CParameters::SetTakeProfitMultiplier(double value)
{
    m_params.takeProfitMultiplier = MathMax(m_bounds[5].min, 
                                          MathMin(m_bounds[5].max, value));
}

void CParameters::SetStopLossMultiplier(double value)
{
    m_params.stopLossMultiplier = MathMax(m_bounds[6].min, 
                                        MathMin(m_bounds[6].max, value));
}

void CParameters::SetBreakEvenLevel(double value)
{
    m_params.breakEvenLevel = MathMax(m_bounds[7].min, 
                                    MathMin(m_bounds[7].max, value));
}

void CParameters::SetTrailStopLevel(double value)
{
    m_params.trailStopLevel = MathMax(m_bounds[8].min, 
                                    MathMin(m_bounds[8].max, value));
}
