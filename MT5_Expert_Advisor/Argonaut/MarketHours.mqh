//+------------------------------------------------------------------+
//|                                                  MarketHours.mqh |
//|                                                Copyright 2025     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property strict

// Market session times (server time)
#define ASIAN_SESSION_START      1  // 01:00
#define ASIAN_SESSION_END        9  // 09:00
#define EUROPEAN_SESSION_START   9  // 09:00
#define EUROPEAN_SESSION_END    18  // 18:00
#define US_SESSION_START       14  // 14:00
#define US_SESSION_END        23  // 23:00

// Trading days
#define MONDAY    1
#define FRIDAY    5

//+------------------------------------------------------------------+
//| Class for managing market hours and sessions                       |
//+------------------------------------------------------------------+
class CMarketHours
{
private:
    string   m_symbol;
    datetime m_serverTime;
    bool     m_isMarketOpen;
    
    // Session states
    bool     m_isAsianSession;
    bool     m_isEuropeanSession;
    bool     m_isUSSession;
    
    void UpdateServerTime();
    bool IsHoliday();
    bool IsWeekend();
    
public:
    CMarketHours();
    ~CMarketHours();
    
    // Main methods
    bool IsMarketOpen();
    bool IsGapTrading();
    bool IsMajorSessionOverlap();
    
    // Session checks
    bool IsAsianSession() { return m_isAsianSession; }
    bool IsEuropeanSession() { return m_isEuropeanSession; }
    bool IsUSSession() { return m_isUSSession; }
    
    // Time getters
    int GetServerHour();
    int GetServerMinute();
    int GetServerDay();
};

//+------------------------------------------------------------------+
//| Constructor                                                        |
//+------------------------------------------------------------------+
CMarketHours::CMarketHours()
{
    m_symbol = Symbol();
    UpdateServerTime();
}

//+------------------------------------------------------------------+
//| Update server time and session states                              |
//+------------------------------------------------------------------+
void CMarketHours::UpdateServerTime()
{
    m_serverTime = TimeCurrent();
    
    int hour = GetServerHour();
    
    // Update session states
    m_isAsianSession = (hour >= ASIAN_SESSION_START && hour < ASIAN_SESSION_END);
    m_isEuropeanSession = (hour >= EUROPEAN_SESSION_START && hour < EUROPEAN_SESSION_END);
    m_isUSSession = (hour >= US_SESSION_START && hour < US_SESSION_END);
    
    // Update market open state
    m_isMarketOpen = !IsWeekend() && !IsHoliday();
}

//+------------------------------------------------------------------+
//| Check if market is currently open                                  |
//+------------------------------------------------------------------+
bool CMarketHours::IsMarketOpen()
{
    UpdateServerTime();
    return m_isMarketOpen;
}

//+------------------------------------------------------------------+
//| Check if current time is suitable for gap trading                  |
//+------------------------------------------------------------------+
bool CMarketHours::IsGapTrading()
{
    UpdateServerTime();
    
    // Check if it's the start of a new session
    int hour = GetServerHour();
    int minute = GetServerMinute();
    
    // Asian session opening (check for gaps)
    if(hour == ASIAN_SESSION_START && minute < 15)
        return true;
        
    // European session opening (check for gaps)
    if(hour == EUROPEAN_SESSION_START && minute < 15)
        return true;
        
    // US session opening (check for gaps)
    if(hour == US_SESSION_START && minute < 15)
        return true;
        
    return false;
}

//+------------------------------------------------------------------+
//| Check if there's a major session overlap                           |
//+------------------------------------------------------------------+
bool CMarketHours::IsMajorSessionOverlap()
{
    UpdateServerTime();
    
    // European-US session overlap (highest volatility)
    if(m_isEuropeanSession && m_isUSSession)
        return true;
        
    // Asian-European session overlap
    if(m_isAsianSession && m_isEuropeanSession)
        return true;
        
    return false;
}

//+------------------------------------------------------------------+
//| Check if current day is a weekend                                  |
//+------------------------------------------------------------------+
bool CMarketHours::IsWeekend()
{
    int day = GetServerDay();
    return (day < MONDAY || day > FRIDAY);
}

//+------------------------------------------------------------------+
//| Check if current day is a holiday                                  |
//+------------------------------------------------------------------+
bool CMarketHours::IsHoliday()
{
    MqlDateTime dt;
    TimeToStruct(m_serverTime, dt);
    
    // New Year's Day
    if(dt.mon == 1 && dt.day == 1)
        return true;
        
    // Christmas
    if(dt.mon == 12 && dt.day == 25)
        return true;
        
    // Good Friday (variable date, simplified check)
    if(dt.mon == 4 && (dt.day >= 10 && dt.day <= 16) && dt.day_of_week == 5)
        return true;
        
    return false;
}

//+------------------------------------------------------------------+
//| Get current server hour                                            |
//+------------------------------------------------------------------+
int CMarketHours::GetServerHour()
{
    MqlDateTime dt;
    TimeToStruct(m_serverTime, dt);
    return dt.hour;
}

//+------------------------------------------------------------------+
//| Get current server minute                                          |
//+------------------------------------------------------------------+
int CMarketHours::GetServerMinute()
{
    MqlDateTime dt;
    TimeToStruct(m_serverTime, dt);
    return dt.min;
}

//+------------------------------------------------------------------+
//| Get current server day of week                                     |
//+------------------------------------------------------------------+
int CMarketHours::GetServerDay()
{
    MqlDateTime dt;
    TimeToStruct(m_serverTime, dt);
    return dt.day_of_week;
}
