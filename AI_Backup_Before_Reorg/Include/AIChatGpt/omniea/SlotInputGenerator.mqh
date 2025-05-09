//+------------------------------------------------------------------+
//|                   SlotInputGenerator.mqh                         |
//|     Crea dinamicamente gli input per ogni slot indicatore       |
//+------------------------------------------------------------------+

// Slot enums
//enum ENUM_SLOT_TYPE { SLOT_BUY = 0, SLOT_SELL = 1, SLOT_FILTER = 2 };
//enum ENUM_SIGNAL_MODE { SIGNAL_LIVE = 0, SIGNAL_CANDLE_CLOSED = 1 };

//──────────────────────────────────────────────────────────
// Struttura slot dinamici (simplified 1.0)
input string Buy_0_IndName = "RSI";
input int    Buy_0_BufferIndex = 0;
input string Buy_0_Condition = "OVERBOUGHT";
input double Buy_0_CompareValue = 70;
input bool   Buy_0_Enabled = true;

input string Buy_1_IndName = "MA";
input int    Buy_1_BufferIndex = 0;
input string Buy_1_Condition = "CROSSOVER";
input double Buy_1_CompareValue = 0.0;
input bool   Buy_1_Enabled = true;

input string Buy_2_IndName = "Stochastic";
input int    Buy_2_BufferIndex = 0;
input string Buy_2_Condition = "CROSSLEVEL";
input double Buy_2_CompareValue = 20.0;
input bool   Buy_2_Enabled = true;

//──────────────────────────────────────────────────────────
input string Sell_0_IndName = "RSI";
input int    Sell_0_BufferIndex = 0;
input string Sell_0_Condition = "OVERSOLD";
input double Sell_0_CompareValue = 30;
input bool   Sell_0_Enabled = true;

input string Sell_1_IndName = "MA";
input int    Sell_1_BufferIndex = 0;
input string Sell_1_Condition = "CROSSUNDER";
input double Sell_1_CompareValue = 0.0;
input bool   Sell_1_Enabled = true;

input string Sell_2_IndName = "Stochastic";
input int    Sell_2_BufferIndex = 0;
input string Sell_2_Condition = "CROSSLEVEL";
input double Sell_2_CompareValue = 80.0;
input bool   Sell_2_Enabled = true;

//──────────────────────────────────────────────────────────
input string Filter_0_IndName = "ATR";
input int    Filter_0_BufferIndex = 0;
input string Filter_0_Condition = "GREATER_THAN";
input double Filter_0_CompareValue = 0.001;
input bool   Filter_0_Enabled = true;

input string Filter_1_IndName = "Volume";
input int    Filter_1_BufferIndex = 0;
input string Filter_1_Condition = "PEAK";
input double Filter_1_CompareValue = 1000;
input bool   Filter_1_Enabled = true;
