//+------------------------------------------------------------------+
//|                   BufferLabeling.mqh                             |
//|   Identificazione e tooltip dinamici per i buffer degli EA      |
//+------------------------------------------------------------------+

string GetBufferLabel(int index, string indicatorName)
{
   string base = "Buff" + StringFormat("%02d", index);
   string type = DetectBufferType(index, indicatorName);

   return base + " [" + type + "]";
}

//──────────────────────────────────────────────────────────
// Classificazione euristica del tipo buffer
string DetectBufferType(int index, string name)
{
   string lname = name;
   StringToLower(lname);


   if (StringFind(name, "rsi") != -1)
   {
      if (index == 0) return "Valore RSI";
      if (index == 1) return "Segnale RSI";
   }

   if (StringFind(name, "stoch") != -1)
   {
      if (index == 0) return "%K";
      if (index == 1) return "%D";
   }

   if (StringFind(name, "macd") != -1)
   {
      if (index == 0) return "MACD Line";
      if (index == 1) return "Signal";
      if (index == 2) return "Histogram";
   }

   if (StringFind(name, "ma") != -1 || StringFind(name, "average") != -1)
      return "Media Mobile";

   if (StringFind(name, "boll") != -1)
   {
      if (index == 0) return "Banda Superiore";
      if (index == 1) return "Media";
      if (index == 2) return "Banda Inferiore";
   }

   // Fallback
   return "Buffer";
}
