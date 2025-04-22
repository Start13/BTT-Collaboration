//+------------------------------------------------------------------+
//|                                                      Argonaut.mq5 |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property link      "https://www.roboforex.com"
#property version   "1.00"
#property strict

// Include necessari
#include "DataManager.mqh"
#include "RiskManager.mqh"
#include "TradeManager.mqh"
#include "Parameters.mqh"
#include "Statistics.mqh"
#include "MarketHours.mqh"

// Input parameters
input string   InpSymbol = "XAUUSD";     // Trading symbol
input double   InpRiskPercent = 1.0;      // Risk per trade (%)
input double   InpGapThreshold = 10.0;    // Gap threshold in points
input double   InpMinGapSize = 5.0;       // Minimum gap size in points
input double   InpMaxGapSize = 100.0;     // Maximum gap size in points
input double   InpTPMultiplier = 2.0;     // Take profit multiplier
input double   InpSLMultiplier = 1.0;     // Stop loss multiplier
input double   InpBreakEven = 0.5;        // Break even level (ratio)
input double   InpTrailStop = 0.3;        // Trailing stop level (ratio)
input bool     InpUseHedging = true;      // Use hedging strategy
input int      InpMaxTrades = 10;         // Maximum simultaneous trades

// Global variables
CDataManager*    g_data = NULL;           // Data manager
CRiskManager*    g_risk = NULL;           // Risk manager
CTradeManager*   g_trade = NULL;          // Trade manager
CParameters*     g_params = NULL;         // Parameters manager
CStatistics*     g_stats = NULL;          // Statistics manager
CMarketHours*    g_market = NULL;         // Market hours manager

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
    // Inizializza i manager
    g_data = new CDataManager();
    g_risk = new CRiskManager();
    g_trade = new CTradeManager();
    g_params = new CParameters();
    g_stats = new CStatistics();
    g_market = new CMarketHours();
    
    // Verifica l'inizializzazione
    if(!g_data || !g_risk || !g_trade || !g_params || !g_stats || !g_market)
    {
        Print("Failed to create manager objects");
        return INIT_FAILED;
    }
    
    // Inizializza i singoli componenti
    if(!g_data.Initialize(InpSymbol, PERIOD_CURRENT))
    {
        Print("Failed to initialize DataManager");
        return INIT_FAILED;
    }
    
    if(!g_risk.Initialize(InpRiskPercent, InpSymbol))
    {
        Print("Failed to initialize RiskManager");
        return INIT_FAILED;
    }
    
    if(!g_trade.Initialize(InpSymbol, g_params, g_risk))
    {
        Print("Failed to initialize TradeManager");
        return INIT_FAILED;
    }
    
    if(!g_stats.Initialize(1000))  // Store last 1000 trades
    {
        Print("Failed to initialize Statistics");
        return INIT_FAILED;
    }
    
    if(!g_market.Initialize(InpSymbol))
    {
        Print("Failed to initialize MarketHours");
        return INIT_FAILED;
    }
    
    // Configura i parametri iniziali
    g_params.SetGapThreshold(InpGapThreshold);
    g_params.SetMinGapSize(InpMinGapSize);
    g_params.SetMaxGapSize(InpMaxGapSize);
    g_params.SetTakeProfitMultiplier(InpTPMultiplier);
    g_params.SetStopLossMultiplier(InpSLMultiplier);
    g_params.SetBreakEvenLevel(InpBreakEven);
    g_params.SetTrailStopLevel(InpTrailStop);
    
    Print("Argonaut EA initialized successfully");
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Chiudi tutte le posizioni aperte
    if(g_trade)
        g_trade.CloseAllPositions();
    
    // Libera la memoria
    if(g_data) delete g_data;
    if(g_risk) delete g_risk;
    if(g_trade) delete g_trade;
    if(g_params) delete g_params;
    if(g_stats) delete g_stats;
    if(g_market) delete g_market;
    
    Print("Argonaut EA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick()
{
    // Verifica se il mercato è aperto
    if(!g_market.IsMarketOpen())
        return;
        
    // Aggiorna le statistiche
    if(g_trade.HasOpenPositions())
    {
        SPerformanceMetrics metrics;
        metrics.profitFactor = g_stats.GetProfitFactor();
        metrics.maxDrawdown = g_stats.GetMaxDrawdown();
        metrics.winRate = g_stats.GetWinRate();
        metrics.expectancy = g_stats.GetExpectancy();
        metrics.sharpeRatio = g_stats.GetSharpeRatio();
        metrics.consecutiveLosses = g_stats.GetConsecutiveLosses();
        
        g_params.OptimizeParameters(metrics);
    }
    
    // Gestisci le posizioni aperte
    g_trade.ManagePositions();
    
    // Cerca nuovi gap
    if(g_data.DetectGap())
    {
        SGapInfo gap;
        if(g_data.GetLastGap(gap))
        {
            // Verifica se il gap è valido per il trading
            if(gap.size >= g_params.GetMinGapSize() && 
               gap.size <= g_params.GetMaxGapSize())
            {
                // Calcola il volume
                double volume = g_risk.CalculateLotSize(gap.stopLoss);
                
                // Apri la posizione
                g_trade.OpenPosition(
                    gap.type == GAP_BULLISH ? POSITION_TYPE_BUY : POSITION_TYPE_SELL,
                    volume,
                    gap.endPrice,
                    gap.stopLoss,
                    gap.takeProfit,
                    "gap_trade"
                );
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Expert trade transaction function                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                       const MqlTradeRequest& request,
                       const MqlTradeResult& result)
{
    // Aggiorna le statistiche quando una posizione viene chiusa
    if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
    {
        HistoryDealSelect(trans.deal);
        
        if(HistoryDealGetInteger(trans.deal, DEAL_ENTRY) == DEAL_ENTRY_OUT)
        {
            double profit = HistoryDealGetDouble(trans.deal, DEAL_PROFIT);
            bool isWin = profit > 0;
            g_stats.UpdateStats(profit, isWin);
        }
    }
}
