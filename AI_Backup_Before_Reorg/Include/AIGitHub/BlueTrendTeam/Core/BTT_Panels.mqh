//+------------------------------------------------------------------+
//| Gestione dei pannelli per OmniEA                                 |
//+------------------------------------------------------------------+
#property strict

class CBigPanel
{
public:
   void Create()
   {
      // Verifica se il pannello esiste già
      if (ObjectFind(0, "BigPanel") != -1)
      {
         Print("Big Panel già esistente, aggiornamento...");
         return;
      }

      // Creazione di un rettangolo come pannello
      if (!ObjectCreate(0, "BigPanel", OBJ_RECTANGLE_LABEL, 0, 0, 0))
      {
         Print("Errore: impossibile creare il pannello");
         return;
      }

      // Imposta proprietà del pannello
      ObjectSetInteger(0, "BigPanel", OBJPROP_XDISTANCE, 10);   // Distanza dal bordo sinistro
      ObjectSetInteger(0, "BigPanel", OBJPROP_YDISTANCE, 10);   // Distanza dal bordo superiore
      ObjectSetInteger(0, "BigPanel", OBJPROP_XSIZE, 300);      // Larghezza
      ObjectSetInteger(0, "BigPanel", OBJPROP_YSIZE, 100);      // Altezza
      ObjectSetInteger(0, "BigPanel", OBJPROP_COLOR, clrWhite); // Colore di sfondo
      ObjectSetInteger(0, "BigPanel", OBJPROP_CORNER, 0);       // Angolo di riferimento
      ObjectSetInteger(0, "BigPanel", OBJPROP_BACK, true);      // Sfondo
      ObjectSetString(0, "BigPanel", OBJPROP_TEXT, "OmniEA Panel"); // Testo del pannello
      ObjectSetInteger(0, "BigPanel", OBJPROP_FONTSIZE, 12);    // Dimensione del font
      ObjectSetInteger(0, "BigPanel", OBJPROP_ALIGN, ALIGN_CENTER); // Allineamento testo

      Print("Big Panel Created");
   }

   void UpdateInfo()
   {
      // Aggiorna il contenuto del pannello
      static int updateCount = 0;
      updateCount++;
      string newText = StringFormat("Aggiornamento: %d", updateCount);
      ObjectSetString(0, "BigPanel", OBJPROP_TEXT, newText);
      Print("Big Panel Updated");
   }

   void Destroy()
   {
      // Rimuove il pannello
      if (ObjectDelete(0, "BigPanel"))
      {
         Print("Big Panel Destroyed");
      }
      else
      {
         Print("Errore: impossibile eliminare il pannello");
      }
   }
};

void InitializeBigPanel(CBigPanel &panel)
{
   panel.Create();
}

void UpdateBigPanel(CBigPanel &panel)
{
   panel.UpdateInfo();
}

void DeinitializeBigPanel(CBigPanel &panel)
{
   panel.Destroy();
}