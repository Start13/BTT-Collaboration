//+------------------------------------------------------------------+
//|                                                 TradeManager.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

#include <Trade\Trade.mqh>
#include "Parameters.mqh"
#include "RiskManager.mqh"

// Struttura per le informazioni sulla posizione
struct SPositionInfo
{
    ulong ticket;
    ENUM_POSITION_TYPE type;
    double volume;
    double openPrice;
    double stopLoss;
    double takeProfit;
    datetime openTime;
    
    void Reset()
    {
        ticket = 0;
        type = POSITION_TYPE_BUY;
        volume = 0;
        openPrice = 0;
        stopLoss = 0;
        takeProfit = 0;
        openTime = 0;
    }
};

//+------------------------------------------------------------------+
//| Class for managing trading operations                              |
//+------------------------------------------------------------------+
class CTradeManager
{
private:
    CTrade*         m_trade;            // Oggetto per le operazioni di trading
    CParameters*    m_params;           // Parametri di trading
    CRiskManager*   m_risk;            // Gestore del rischio
    string          m_symbol;           // Simbolo corrente
    
    // Array delle posizioni aperte
    SPositionInfo   m_positions[];
    
    // Metodi privati
    bool ValidateOrder(ENUM_POSITION_TYPE type, double volume, double price, 
                      double sl, double tp);
    void UpdatePositions();
    bool IsNewBar();
    
    // Variabili per il controllo delle barre
    datetime        m_lastBarTime;
    
public:
    CTradeManager();
    ~CTradeManager() { delete m_trade; }
    
    // Inizializzazione
    bool Initialize(string symbol, CParameters* params, CRiskManager* risk);
    
    // Metodi principali
    bool OpenPosition(ENUM_POSITION_TYPE type, double volume, double price, 
                     double sl, double tp, string comment = "");
    bool ClosePosition(ulong ticket);
    bool CloseAllPositions();
    bool ModifyPosition(ulong ticket, double sl, double tp);
    
    // Gestione delle posizioni
    void ManagePositions();
    bool HasOpenPositions() { return ArraySize(m_positions) > 0; }
    int GetTotalPositions() { return ArraySize(m_positions); }
    
    // Getters
    SPositionInfo* GetPosition(int index);
    double GetTotalVolume();
    double GetTotalProfit();
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CTradeManager::CTradeManager()
{
    m_trade = new CTrade();
    m_lastBarTime = 0;
    ArrayResize(m_positions, 0);
}

//+------------------------------------------------------------------+
//| Initialize trade manager                                           |
//+------------------------------------------------------------------+
bool CTradeManager::Initialize(string symbol, CParameters* params, CRiskManager* risk)
{
    if(!m_trade || !params || !risk)
        return false;
        
    m_symbol = symbol;
    m_params = params;
    m_risk = risk;
    
    // Configura l'oggetto trade
    m_trade.SetExpertMagicNumber(123456); // Magic number dell'EA
    m_trade.SetDeviationInPoints(10);     // Deviazione massima dal prezzo
    m_trade.SetTypeFilling(ORDER_FILLING_FOK);
    m_trade.LogLevel(LOG_LEVEL_ERRORS);
    
    return true;
}

//+------------------------------------------------------------------+
//| Open new position                                                  |
//+------------------------------------------------------------------+
bool CTradeManager::OpenPosition(ENUM_POSITION_TYPE type, double volume, double price,
                               double sl, double tp, string comment = "")
{
    if(!ValidateOrder(type, volume, price, sl, tp))
        return false;
        
    bool result = false;
    
    if(type == POSITION_TYPE_BUY)
        result = m_trade.Buy(volume, m_symbol, price, sl, tp, comment);
    else
        result = m_trade.Sell(volume, m_symbol, price, sl, tp, comment);
        
    if(result)
        UpdatePositions();
        
    return result;
}

//+------------------------------------------------------------------+
//| Close specific position                                            |
//+------------------------------------------------------------------+
bool CTradeManager::ClosePosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
        
    bool result = m_trade.PositionClose(ticket);
    
    if(result)
        UpdatePositions();
        
    return result;
}

//+------------------------------------------------------------------+
//| Close all positions                                               |
//+------------------------------------------------------------------+
bool CTradeManager::CloseAllPositions()
{
    bool result = true;
    
    for(int i = ArraySize(m_positions) - 1; i >= 0; i--)
    {
        if(!ClosePosition(m_positions[i].ticket))
            result = false;
    }
    
    return result;
}

//+------------------------------------------------------------------+
//| Modify position's stop loss and take profit                        |
//+------------------------------------------------------------------+
bool CTradeManager::ModifyPosition(ulong ticket, double sl, double tp)
{
    if(!PositionSelectByTicket(ticket))
        return false;
        
    bool result = m_trade.PositionModify(ticket, sl, tp);
    
    if(result)
        UpdatePositions();
        
    return result;
}

//+------------------------------------------------------------------+
//| Manage open positions                                             |
//+------------------------------------------------------------------+
void CTradeManager::ManagePositions()
{
    if(!IsNewBar())
        return;
        
    UpdatePositions();
    
    for(int i = ArraySize(m_positions) - 1; i >= 0; i--)
    {
        SPositionInfo* pos = GetPosition(i);
        if(!pos) continue;
        
        // Calcola i livelli di break even e trailing stop
        double breakEvenLevel = pos->openPrice + 
            (pos->type == POSITION_TYPE_BUY ? 1 : -1) * 
            m_params->GetBreakEvenLevel() * SymbolInfoDouble(m_symbol, SYMBOL_POINT);
            
        double trailStopLevel = pos->openPrice + 
            (pos->type == POSITION_TYPE_BUY ? 1 : -1) * 
            m_params->GetTrailStopLevel() * SymbolInfoDouble(m_symbol, SYMBOL_POINT);
            
        // Ottieni il prezzo corrente
        double currentPrice = (pos->type == POSITION_TYPE_BUY) ? 
            SymbolInfoDouble(m_symbol, SYMBOL_BID) : 
            SymbolInfoDouble(m_symbol, SYMBOL_ASK);
            
        // Verifica se modificare lo stop loss
        if(pos->type == POSITION_TYPE_BUY)
        {
            if(currentPrice >= breakEvenLevel && pos->stopLoss < pos->openPrice)
            {
                ModifyPosition(pos->ticket, pos->openPrice, pos->takeProfit);
            }
            else if(currentPrice >= trailStopLevel)
            {
                double newSL = currentPrice - m_params->GetTrailStopLevel() * 
                              SymbolInfoDouble(m_symbol, SYMBOL_POINT);
                if(newSL > pos->stopLoss)
                    ModifyPosition(pos->ticket, newSL, pos->takeProfit);
            }
        }
        else
        {
            if(currentPrice <= breakEvenLevel && pos->stopLoss > pos->openPrice)
            {
                ModifyPosition(pos->ticket, pos->openPrice, pos->takeProfit);
            }
            else if(currentPrice <= trailStopLevel)
            {
                double newSL = currentPrice + m_params->GetTrailStopLevel() * 
                              SymbolInfoDouble(m_symbol, SYMBOL_POINT);
                if(newSL < pos->stopLoss)
                    ModifyPosition(pos->ticket, newSL, pos->takeProfit);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Update positions array                                            |
//+------------------------------------------------------------------+
void CTradeManager::UpdatePositions()
{
    ArrayResize(m_positions, 0);
    
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0) continue;
        
        if(PositionGetString(POSITION_SYMBOL) != m_symbol)
            continue;
            
        int size = ArraySize(m_positions);
        ArrayResize(m_positions, size + 1);
        
        m_positions[size].ticket = ticket;
        m_positions[size].type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        m_positions[size].volume = PositionGetDouble(POSITION_VOLUME);
        m_positions[size].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
        m_positions[size].stopLoss = PositionGetDouble(POSITION_SL);
        m_positions[size].takeProfit = PositionGetDouble(POSITION_TP);
        m_positions[size].openTime = (datetime)PositionGetInteger(POSITION_TIME);
    }
}

//+------------------------------------------------------------------+
//| Get position by index                                             |
//+------------------------------------------------------------------+
SPositionInfo* CTradeManager::GetPosition(int index)
{
    if(index < 0 || index >= ArraySize(m_positions))
        return NULL;
        
    return &m_positions[index];
}

//+------------------------------------------------------------------+
//| Calculate total volume of open positions                           |
//+------------------------------------------------------------------+
double CTradeManager::GetTotalVolume()
{
    double volume = 0;
    
    for(int i = 0; i < ArraySize(m_positions); i++)
        volume += m_positions[i].volume;
        
    return volume;
}

//+------------------------------------------------------------------+
//| Calculate total floating profit of open positions                  |
//+------------------------------------------------------------------+
double CTradeManager::GetTotalProfit()
{
    double profit = 0;
    
    for(int i = 0; i < ArraySize(m_positions); i++)
    {
        if(!PositionSelectByTicket(m_positions[i].ticket))
            continue;
            
        profit += PositionGetDouble(POSITION_PROFIT);
    }
    
    return profit;
}

//+------------------------------------------------------------------+
//| Check if new bar has formed                                       |
//+------------------------------------------------------------------+
bool CTradeManager::IsNewBar()
{
    datetime currentBarTime = (datetime)SeriesInfoInteger(m_symbol, PERIOD_CURRENT, SERIES_LASTBAR_DATE);
    
    if(currentBarTime > m_lastBarTime)
    {
        m_lastBarTime = currentBarTime;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Validate order parameters                                         |
//+------------------------------------------------------------------+
bool CTradeManager::ValidateOrder(ENUM_POSITION_TYPE type, double volume, double price,
                                double sl, double tp)
{
    if(volume <= 0)
        return false;
        
    if(price <= 0)
        return false;
        
    // Verifica i livelli di stop loss e take profit
    double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    int stops_level = (int)SymbolInfoInteger(m_symbol, SYMBOL_TRADE_STOPS_LEVEL);
    
    if(type == POSITION_TYPE_BUY)
    {
        if(sl > 0 && price - sl < stops_level * point)
            return false;
            
        if(tp > 0 && tp - price < stops_level * point)
            return false;
    }
    else
    {
        if(sl > 0 && sl - price < stops_level * point)
            return false;
            
        if(tp > 0 && price - tp < stops_level * point)
            return false;
    }
    
    return true;
}
