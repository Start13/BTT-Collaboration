//+------------------------------------------------------------------+
//|                                                        BreakoutEA.mq5 |
//|                                                Copyright 2025, Cascade |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Cascade"
#property version   "1.00"
#property strict

// Input Parameters
input int     LookbackPeriod = 20;      // Period for calculating high/low
input double  RiskPercent    = 1.0;     // Risk per trade (%)
input double  ATRPeriod      = 14;      // ATR Period for volatility
input double  ATRMultiplier  = 2.0;     // ATR multiplier for SL/TP

// Global Variables
int handle_atr;
double atr[];

//+------------------------------------------------------------------+
//| Expert initialization function                                      |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize ATR indicator
    handle_atr = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
    if(handle_atr == INVALID_HANDLE)
    {
        Print("Error creating ATR indicator!");
        return(INIT_FAILED);
    }
    
    ArraySetAsSeries(atr, true);
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(handle_atr != INVALID_HANDLE)
        IndicatorRelease(handle_atr);
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update ATR values
    if(CopyBuffer(handle_atr, 0, 0, 2, atr) != 2) return;
    
    // Calculate highest high and lowest low
    double highestHigh = iHigh(_Symbol, PERIOD_CURRENT, iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, LookbackPeriod, 1));
    double lowestLow = iLow(_Symbol, PERIOD_CURRENT, iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, LookbackPeriod, 1));
    
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    
    // Check for breakout conditions
    if(currentPrice > highestHigh && !HasOpenPosition())
    {
        double stopLoss = currentPrice - (atr[0] * ATRMultiplier);
        double takeProfit = currentPrice + (atr[0] * ATRMultiplier);
        OpenPosition(ORDER_TYPE_BUY, CalculateLotSize(currentPrice - stopLoss), stopLoss, takeProfit);
    }
    else if(currentPrice < lowestLow && !HasOpenPosition())
    {
        double stopLoss = currentPrice + (atr[0] * ATRMultiplier);
        double takeProfit = currentPrice - (atr[0] * ATRMultiplier);
        OpenPosition(ORDER_TYPE_SELL, CalculateLotSize(stopLoss - currentPrice), stopLoss, takeProfit);
    }
}

//+------------------------------------------------------------------+
//| Check if there's an open position                                  |
//+------------------------------------------------------------------+
bool HasOpenPosition()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionGetSymbol(i) == _Symbol)
            return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Calculate position size based on risk                              |
//+------------------------------------------------------------------+
double CalculateLotSize(double stopDistance)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (RiskPercent / 100.0);
    double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    if(stopDistance <= 0) return 0;
    
    double lots = NormalizeDouble(riskAmount / (stopDistance * tickValue / tickSize), 2);
    lots = MathFloor(lots / lotStep) * lotStep;
    
    double minLots = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLots = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    
    lots = MathMax(minLots, MathMin(maxLots, lots));
    
    return lots;
}

//+------------------------------------------------------------------+
//| Open a new position                                                |
//+------------------------------------------------------------------+
void OpenPosition(ENUM_ORDER_TYPE orderType, double lots, double sl, double tp)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = _Symbol;
    request.volume = lots;
    request.type = orderType;
    request.price = SymbolInfoDouble(_Symbol, orderType == ORDER_TYPE_BUY ? SYMBOL_ASK : SYMBOL_BID);
    request.sl = sl;
    request.tp = tp;
    request.deviation = 10;
    request.magic = 123456;
    request.comment = "Breakout EA";
    request.type_filling = ORDER_FILLING_FOK;
    
    if(!OrderSend(request, result))
        PrintFormat("OrderSend error %d", GetLastError());
}
