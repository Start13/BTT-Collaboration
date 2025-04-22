//+------------------------------------------------------------------+
//|                                                  RiskManager.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

// Constants
#define MIN_LOTS     0.01    // Minimum lot size
#define MAX_LOTS     100.0   // Maximum lot size
#define RISK_MARGIN  1.1     // Risk margin multiplier

//+------------------------------------------------------------------+
//| Class for managing trading risk                                    |
//+------------------------------------------------------------------+
class CRiskManager
{
private:
    double         m_riskPercent;       // Risk per trade (%)
    double         m_maxDrawdown;       // Maximum allowed drawdown (%)
    double         m_commission;        // Commission per lot (EUR)
    string         m_symbol;            // Trading symbol
    
    double CalculateTotalCost(double lots, ENUM_POSITION_TYPE type);
    double GetPointValue();
    
public:
    CRiskManager(double riskPercent = 1.0, double maxDrawdown = 20.0, double commission = 7.0);
    ~CRiskManager() {}
    
    // Risk calculation methods
    double CalculateLotSize(double stopLoss);
    double CalculatePositionRisk(double lots, double stopLoss);
    bool ValidateRisk(double lots, double stopLoss);
    
    // Setters
    void SetRiskPercent(double risk) { m_riskPercent = MathMax(0.1, MathMin(risk, 100.0)); }
    void SetMaxDrawdown(double dd) { m_maxDrawdown = MathMax(1.0, MathMin(dd, 100.0)); }
    void SetCommission(double commission) { m_commission = MathMax(0.0, commission); }
    void SetSymbol(string symbol) { m_symbol = symbol; }
    
    // Getters
    double GetRiskPercent() const { return m_riskPercent; }
    double GetMaxDrawdown() const { return m_maxDrawdown; }
    double GetCommission() const { return m_commission; }
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CRiskManager::CRiskManager(double riskPercent, 
                         double maxDrawdown,
                         double commission)
{
    m_riskPercent = MathMax(0.1, MathMin(riskPercent, 100.0));
    m_maxDrawdown = MathMax(1.0, MathMin(maxDrawdown, 100.0));
    m_commission = MathMax(0.0, commission);
    m_symbol = Symbol();
}

//+------------------------------------------------------------------+
//| Calculate total trading cost including spread and commission       |
//+------------------------------------------------------------------+
double CRiskManager::CalculateTotalCost(double lots, ENUM_POSITION_TYPE type)
{
    if(lots <= 0)
        return 0.0;
        
    // Get current spread
    double spread = SymbolInfoInteger(m_symbol, SYMBOL_SPREAD) * SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    
    // Calculate spread cost
    double spreadCost = spread * lots * SymbolInfoDouble(m_symbol, SYMBOL_TRADE_CONTRACT_SIZE);
    
    // Add commission
    double totalCost = spreadCost + (m_commission * lots);
    
    // Convert to account currency if needed
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    string profitCurrency = SymbolInfoString(m_symbol, SYMBOL_CURRENCY_PROFIT);
    
    if(accountCurrency != profitCurrency)
    {
        string conversionPair = profitCurrency + accountCurrency;
        double conversionRate = 1.0;
        
        if(SymbolSelect(conversionPair, true))
            conversionRate = SymbolInfoDouble(conversionPair, type == POSITION_TYPE_BUY ? SYMBOL_ASK : SYMBOL_BID);
            
        totalCost *= conversionRate;
    }
    
    return totalCost;
}

//+------------------------------------------------------------------+
//| Get point value in account currency                               |
//+------------------------------------------------------------------+
double CRiskManager::GetPointValue()
{
    double tickValue = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_SIZE);
    double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    
    return (tickValue / tickSize) * point;
}

//+------------------------------------------------------------------+
//| Calculate optimal lot size based on risk parameters                |
//+------------------------------------------------------------------+
double CRiskManager::CalculateLotSize(double stopLoss)
{
    if(stopLoss <= 0)
        return 0;
        
    // Calculate account risk amount
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = balance * m_riskPercent / 100.0;
    
    // Get point value
    double pointValue = GetPointValue();
    
    // Calculate lot size
    double lotSize = riskAmount / (stopLoss * pointValue);
    
    // Normalize lot size
    double minLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    
    lotSize = MathMin(maxLot, MathMax(minLot, lotSize));
    lotSize = NormalizeDouble(lotSize / lotStep, 0) * lotStep;
    
    // Validate total risk including costs
    if(!ValidateRisk(lotSize, stopLoss))
        return 0;
        
    return lotSize;
}

//+------------------------------------------------------------------+
//| Calculate position risk including costs                            |
//+------------------------------------------------------------------+
double CRiskManager::CalculatePositionRisk(double lots, double stopLoss)
{
    if(lots <= 0 || stopLoss <= 0)
        return 0;
        
    // Calculate stop loss risk
    double pointValue = GetPointValue();
    double slRisk = lots * stopLoss * pointValue;
    
    // Add trading costs
    double costs = CalculateTotalCost(lots, POSITION_TYPE_BUY);
    
    return slRisk + costs;
}

//+------------------------------------------------------------------+
//| Validate if position risk is within limits                         |
//+------------------------------------------------------------------+
bool CRiskManager::ValidateRisk(double lots, double stopLoss)
{
    if(lots <= 0 || stopLoss <= 0)
        return false;
        
    // Calculate total risk amount
    double riskAmount = CalculatePositionRisk(lots, stopLoss);
    
    // Check against account balance
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskPercent = (riskAmount / balance) * 100.0;
    
    return riskPercent <= m_riskPercent;
}
