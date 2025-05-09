// Includiamo il gestore delle impostazioni
#include <AIGrok\BlueTrendTeam\Managers\BTT_SettingsManager.mqh>

// Struttura per gestire lo stato di una casella
struct IndicatorSlot {
   string name;           // Nome dell'indicatore (es. "RSI")
   bool is_assigning;     // True se in modalità assegnazione
   int countdown;         // Secondi rimanenti per il drag & drop
   bool is_blinking;      // True se la casella sta lampeggiando
   color current_color;   // Colore attuale della casella
   long last_update;      // Ultimo tick per aggiornare il countdown
};

// Array di caselle per ogni sezione
IndicatorSlot signal_buy_slots[3];  // Indicator 1, 2, 3 per Signal Buy
IndicatorSlot signal_sell_slots[3]; // Indicator 1, 2, 3 per Signal Sell
IndicatorSlot filter_slots[3];      // Filter Indicator 1, 2, 3 per Filtri

// Variabili globali
bool show_assignment_alert = true;  // Mostra avviso informativo
long last_tick = 0;                 // Ultimo tick per il lampeggio

// Funzione per salvare i dati delle caselle in last_config.set
void SaveIndicatorSlots() {
   string config_data = "";
   
   // Salva Signal Buy
   for (int i = 0; i < 3; i++) {
      config_data += "SignalBuy_Slot_" + IntegerToString(i) + "=" + signal_buy_slots[i].name + "\n";
   }
   
   // Salva Signal Sell
   for (int i = 0; i < 3; i++) {
      config_data += "SignalSell_Slot_" + IntegerToString(i) + "=" + signal_sell_slots[i].name + "\n";
   }
   
   // Salva Filtri
   for (int i = 0; i < 3; i++) {
      config_data += "Filter_Slot_" + IntegerToString(i) + "=" + filter_slots[i].name + "\n";
   }
   
   // Usa BTT_SettingsManager per salvare
   SaveSettingsToFile("last_config.set", config_data);
}

// Funzione per caricare i dati delle caselle da last_config.set
void LoadIndicatorSlots() {
   string config_data;
   if (LoadSettingsFromFile("last_config.set", config_data)) {
      // Parsifica il file e aggiorna le caselle
      string lines[];
      StringSplit(config_data, '\n', lines);
      for (int i = 0; i < ArraySize(lines); i++) {
         if (lines[i] == "") continue;
         string key_value[];
         StringSplit(lines[i], '=', key_value);
         if (ArraySize(key_value) != 2) continue;
         
         string key = key_value[0];
         string value = key_value[1];
         
         if (StringFind(key, "SignalBuy_Slot_") >= 0) {
            int slot_index = (int)StringSubstr(key, StringLen("SignalBuy_Slot_"));
            signal_buy_slots[slot_index].name = value;
         }
         else if (StringFind(key, "SignalSell_Slot_") >= 0) {
            int slot_index = (int)StringSubstr(key, StringLen("SignalSell_Slot_"));
            signal_sell_slots[slot_index].name = value;
         }
         else if (StringFind(key, "Filter_Slot_") >= 0) {
            int slot_index = (int)StringSubstr(key, StringLen("Filter_Slot_"));
            filter_slots[slot_index].name = value;
         }
      }
   }
}

// Inizializzazione delle caselle
void InitializeSlots() {
   for (int i = 0; i < 3; i++) {
      signal_buy_slots[i].name = "Add Indicator";
      signal_buy_slots[i].is_assigning = false;
      signal_buy_slots[i].countdown = 0;
      signal_buy_slots[i].is_blinking = false;
      signal_buy_slots[i].current_color = clrLightGray;
      signal_buy_slots[i].last_update = 0;

      signal_sell_slots[i].name = "Add Indicator";
      signal_sell_slots[i].is_assigning = false;
      signal_sell_slots[i].countdown = 0;
      signal_sell_slots[i].is_blinking = false;
      signal_sell_slots[i].current_color = clrLightGray;
      signal_sell_slots[i].last_update = 0;

      filter_slots[i].name = "Add Indicator";
      filter_slots[i].is_assigning = false;
      filter_slots[i].countdown = 0;
      filter_slots[i].is_blinking = false;
      filter_slots[i].current_color = clrLightGray;
      filter_slots[i].last_update = 0;
   }
   
   // Carica i dati salvati
   LoadIndicatorSlots();
}

// Gestione del click su una casella
void OnSlotClick(string section, int slot_index) {
   // Determina quale array modificare in base alla sezione
   if (section == "SignalBuy") {
      if (signal_buy_slots[slot_index].is_assigning) {
         // Se la casella è in modalità assegnazione, un click la interrompe
         signal_buy_slots[slot_index].is_assigning = false;
         signal_buy_slots[slot_index].countdown = 0;
         signal_buy_slots[slot_index].is_blinking = false;
         signal_buy_slots[slot_index].current_color = clrLightGray;
         signal_buy_slots[slot_index].name = "Add Indicator";
         ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, signal_buy_slots[slot_index].name);
         ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, signal_buy_slots[slot_index].current_color);
         ChartRedraw();
         return;
      }

      // Mostra avviso informativo al primo click
      if (show_assignment_alert) {
         int result = MessageBox("Per aggiungere un indicatore, trascina l'indicatore dal Navigator al grafico.\nVuoi ripetere questo avviso?", "OmniEA - Aggiungi Indicatore", MB_YESNOCANCEL | MB_ICONINFORMATION);
         if (result == IDYES) show_assignment_alert = true;
         else if (result == IDNO) show_assignment_alert = false;
         else return; // Cancel
      }

      // Avvia modalità assegnazione
      signal_buy_slots[slot_index].is_assigning = true;
      signal_buy_slots[slot_index].countdown = 10;
      signal_buy_slots[slot_index].is_blinking = true;
      signal_buy_slots[slot_index].current_color = clrYellow;
      signal_buy_slots[slot_index].last_update = GetTickCount();
      ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, "Drag indicator on chart\nTime left: 10s");
      ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, signal_buy_slots[slot_index].current_color);
      ChartRedraw();
   }
   else if (section == "SignalSell") {
      if (signal_sell_slots[slot_index].is_assigning) {
         signal_sell_slots[slot_index].is_assigning = false;
         signal_sell_slots[slot_index].countdown = 0;
         signal_sell_slots[slot_index].is_blinking = false;
         signal_sell_slots[slot_index].current_color = clrLightGray;
         signal_sell_slots[slot_index].name = "Add Indicator";
         ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, signal_sell_slots[slot_index].name);
         ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, signal_sell_slots[slot_index].current_color);
         ChartRedraw();
         return;
      }

      if (show_assignment_alert) {
         int result = MessageBox("Per aggiungere un indicatore, trascina l'indicatore dal Navigator al grafico.\nVuoi ripetere questo avviso?", "OmniEA - Aggiungi Indicatore", MB_YESNOCANCEL | MB_ICONINFORMATION);
         if (result == IDYES) show_assignment_alert = true;
         else if (result == IDNO) show_assignment_alert = false;
         else return;
      }

      signal_sell_slots[slot_index].is_assigning = true;
      signal_sell_slots[slot_index].countdown = 10;
      signal_sell_slots[slot_index].is_blinking = true;
      signal_sell_slots[slot_index].current_color = clrYellow;
      signal_sell_slots[slot_index].last_update = GetTickCount();
      ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, "Drag indicator on chart\nTime left: 10s");
      ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, signal_sell_slots[slot_index].current_color);
      ChartRedraw();
   }
   else if (section == "Filter") {
      if (filter_slots[slot_index].is_assigning) {
         filter_slots[slot_index].is_assigning = false;
         filter_slots[slot_index].countdown = 0;
         filter_slots[slot_index].is_blinking = false;
         filter_slots[slot_index].current_color = clrLightGray;
         filter_slots[slot_index].name = "Add Indicator";
         ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, filter_slots[slot_index].name);
         ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, filter_slots[slot_index].current_color);
         ChartRedraw();
         return;
      }

      if (show_assignment_alert) {
         int result = MessageBox("Per aggiungere un indicatore, trascina l'indicatore dal Navigator al grafico.\nVuoi ripetere questo avviso?", "OmniEA - Aggiungi Indicatore", MB_YESNOCANCEL | MB_ICONINFORMATION);
         if (result == IDYES) show_assignment_alert = true;
         else if (result == IDNO) show_assignment_alert = false;
         else return;
      }

      filter_slots[slot_index].is_assigning = true;
      filter_slots[slot_index].countdown = 10;
      filter_slots[slot_index].is_blinking = true;
      filter_slots[slot_index].current_color = clrYellow;
      filter_slots[slot_index].last_update = GetTickCount();
      ObjectSetString(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_TEXT, "Drag indicator on chart\nTime left: 10s");
      ObjectSetInteger(0, section + "_Slot_" + IntegerToString(slot_index), OBJPROP_COLOR, filter_slots[slot_index].current_color);
      ChartRedraw();
   }
}

// Gestione del drag & drop (rileva indicatore anche sul pannello)
bool DetectIndicatorDrop(string section, int slot_index, string &indicator_name) {
   // Simulazione: Rileva se un indicatore è stato trascinato (logica reale dipende da MT5)
   indicator_name = "RSI"; // Da implementare con logica reale
   return true; // Simulazione successo
}

// Aggiornamento delle caselle (chiamato a ogni tick)
void UpdateSlots() {
   long current_tick = GetTickCount();
   if (current_tick - last_tick < 100) return; // Aggiorna ogni 100ms
   last_tick = current_tick;

   bool config_changed = false;

   // Aggiorna tutte le caselle
   for (int i = 0; i < 3; i++) {
      // Signal Buy
      if (signal_buy_slots[i].is_assigning) {
         long elapsed = (GetTickCount() - signal_buy_slots[i].last_update) / 1000;
         signal_buy_slots[i].countdown = 10 - (int)elapsed;

         if (signal_buy_slots[i].countdown <= 0) {
            // Tempo scaduto
            signal_buy_slots[i].is_assigning = false;
            signal_buy_slots[i].is_blinking = false;
            signal_buy_slots[i].current_color = clrLightGray;
            signal_buy_slots[i].name = "Add Indicator";
            ObjectSetString(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_TEXT, signal_buy_slots[i].name);
            ObjectSetInteger(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_buy_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
            continue;
         }

         // Aggiorna lampeggio
         signal_buy_slots[i].is_blinking = !signal_buy_slots[i].is_blinking;
         signal_buy_slots[i].current_color = signal_buy_slots[i].is_blinking ? clrYellow : clrWhite;
         ObjectSetInteger(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_buy_slots[i].current_color);
         ObjectSetString(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Drag indicator on chart\nTime left: " + IntegerToString(signal_buy_slots[i].countdown) + "s");

         // Rileva drag & drop
         string indicator_name;
         if (DetectIndicatorDrop("SignalBuy", i, indicator_name)) {
            signal_buy_slots[i].is_assigning = false;
            signal_buy_slots[i].is_blinking = false;
            signal_buy_slots[i].current_color = clrGreen;
            signal_buy_slots[i].name = indicator_name;
            ObjectSetString(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_TEXT, signal_buy_slots[i].name);
            ObjectSetInteger(0, "SignalBuy_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_buy_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
         }
      }

      // Signal Sell
      if (signal_sell_slots[i].is_assigning) {
         long elapsed = (GetTickCount() - signal_sell_slots[i].last_update) / 1000;
         signal_sell_slots[i].countdown = 10 - (int)elapsed;

         if (signal_sell_slots[i].countdown <= 0) {
            signal_sell_slots[i].is_assigning = false;
            signal_sell_slots[i].is_blinking = false;
            signal_sell_slots[i].current_color = clrLightGray;
            signal_sell_slots[i].name = "Add Indicator";
            ObjectSetString(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_TEXT, signal_sell_slots[i].name);
            ObjectSetInteger(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_sell_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
            continue;
         }

         signal_sell_slots[i].is_blinking = !signal_sell_slots[i].is_blinking;
         signal_sell_slots[i].current_color = signal_sell_slots[i].is_blinking ? clrYellow : clrWhite;
         ObjectSetInteger(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_sell_slots[i].current_color);
         ObjectSetString(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Drag indicator on chart\nTime left: " + IntegerToString(signal_sell_slots[i].countdown) + "s");

         string indicator_name;
         if (DetectIndicatorDrop("SignalSell", i, indicator_name)) {
            signal_sell_slots[i].is_assigning = false;
            signal_sell_slots[i].is_blinking = false;
            signal_sell_slots[i].current_color = clrGreen;
            signal_sell_slots[i].name = indicator_name;
            ObjectSetString(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_TEXT, signal_sell_slots[i].name);
            ObjectSetInteger(0, "SignalSell_Slot_" + IntegerToString(i), OBJPROP_COLOR, signal_sell_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
         }
      }

      // Filtri
      if (filter_slots[i].is_assigning) {
         long elapsed = (GetTickCount() - filter_slots[i].last_update) / 1000;
         filter_slots[i].countdown = 10 - (int)elapsed;

         if (filter_slots[i].countdown <= 0) {
            filter_slots[i].is_assigning = false;
            filter_slots[i].is_blinking = false;
            filter_slots[i].current_color = clrLightGray;
            filter_slots[i].name = "Add Indicator";
            ObjectSetString(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_TEXT, filter_slots[i].name);
            ObjectSetInteger(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_COLOR, filter_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
            continue;
         }

         filter_slots[i].is_blinking = !filter_slots[i].is_blinking;
         filter_slots[i].current_color = filter_slots[i].is_blinking ? clrYellow : clrWhite;
         ObjectSetInteger(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_COLOR, filter_slots[i].current_color);
         ObjectSetString(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_TEXT, "Drag indicator on chart\nTime left: " + IntegerToString(filter_slots[i].countdown) + "s");

         string indicator_name;
         if (DetectIndicatorDrop("Filter", i, indicator_name)) {
            filter_slots[i].is_assigning = false;
            filter_slots[i].is_blinking = false;
            filter_slots[i].current_color = clrGreen;
            filter_slots[i].name = indicator_name;
            ObjectSetString(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_TEXT, filter_slots[i].name);
            ObjectSetInteger(0, "Filter_Slot_" + IntegerToString(i), OBJPROP_COLOR, filter_slots[i].current_color);
            config_changed = true;
            ChartRedraw();
         }
      }
   }

   // Salva le modifiche se necessario
   if (config_changed) {
      SaveIndicatorSlots();
   }

   ChartRedraw();
}

// Funzione principale per disegnare il Pannello Grande
void DrawBigPanel() {
   Print("Disegno del Pannello Grande...");

   // Disegna caselle per Signal Buy
   for (int i = 0; i < 3; i++) {
      string obj_name = "SignalBuy_Slot_" + IntegerToString(i);
      if (!ObjectCreate(0, obj_name, OBJ_BUTTON, 0, 0, 0)) {
         Print("Errore nella creazione di ", obj_name, ": ", GetLastError());
         continue;
      }
      ObjectSetInteger(0, obj_name, OBJPROP_XDISTANCE, 20);  // Spostato più a sinistra
      ObjectSetInteger(0, obj_name, OBJPROP_YDISTANCE, 50 + i * 30);  // Spostato più in alto
      ObjectSetInteger(0, obj_name, OBJPROP_XSIZE, 120);
      ObjectSetInteger(0, obj_name, OBJPROP_YSIZE, 25);
      ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_buy_slots[i].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, signal_buy_slots[i].current_color);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrSlateGray);
      ObjectSetInteger(0, obj_name, OBJPROP_BORDER_COLOR, clrLightGray);
      Print("Creata casella ", obj_name, " a X=", 20, ", Y=", 50 + i * 30);
   }

   // Disegna caselle per Signal Sell
   for (int i = 0; i < 3; i++) {
      string obj_name = "SignalSell_Slot_" + IntegerToString(i);
      if (!ObjectCreate(0, obj_name, OBJ_BUTTON, 0, 0, 0)) {
         Print("Errore nella creazione di ", obj_name, ": ", GetLastError());
         continue;
      }
      ObjectSetInteger(0, obj_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, obj_name, OBJPROP_YDISTANCE, 150 + i * 30);
      ObjectSetInteger(0, obj_name, OBJPROP_XSIZE, 120);
      ObjectSetInteger(0, obj_name, OBJPROP_YSIZE, 25);
      ObjectSetString(0, obj_name, OBJPROP_TEXT, signal_sell_slots[i].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, signal_sell_slots[i].current_color);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrSlateGray);
      ObjectSetInteger(0, obj_name, OBJPROP_BORDER_COLOR, clrLightGray);
      Print("Creata casella ", obj_name, " a X=", 20, ", Y=", 150 + i * 30);
   }

   // Disegna caselle per Filtri
   for (int i = 0; i < 3; i++) {
      string obj_name = "Filter_Slot_" + IntegerToString(i);
      if (!ObjectCreate(0, obj_name, OBJ_BUTTON, 0, 0, 0)) {
         Print("Errore nella creazione di ", obj_name, ": ", GetLastError());
         continue;
      }
      ObjectSetInteger(0, obj_name, OBJPROP_XDISTANCE, 20);
      ObjectSetInteger(0, obj_name, OBJPROP_YDISTANCE, 250 + i * 30);
      ObjectSetInteger(0, obj_name, OBJPROP_XSIZE, 120);
      ObjectSetInteger(0, obj_name, OBJPROP_YSIZE, 25);
      ObjectSetString(0, obj_name, OBJPROP_TEXT, filter_slots[i].name);
      ObjectSetInteger(0, obj_name, OBJPROP_COLOR, filter_slots[i].current_color);
      ObjectSetInteger(0, obj_name, OBJPROP_BGCOLOR, clrSlateGray);
      ObjectSetInteger(0, obj_name, OBJPROP_BORDER_COLOR, clrLightGray);
      Print("Creata casella ", obj_name, " a X=", 20, ", Y=", 250 + i * 30);
   }

   Print("Pannello Grande disegnato. Aggiorno il grafico...");
   ChartRedraw();
}

// Funzione helper per gestire gli eventi del pannello
void HandlePanelChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
   if (id == CHARTEVENT_OBJECT_CLICK) {
      if (StringFind(sparam, "SignalBuy_Slot_") >= 0) {
         int slot_index = (int)StringSubstr(sparam, StringLen("SignalBuy_Slot_"));
         OnSlotClick("SignalBuy", slot_index);
      }
      else if (StringFind(sparam, "SignalSell_Slot_") >= 0) {
         int slot_index = (int)StringSubstr(sparam, StringLen("SignalSell_Slot_"));
         OnSlotClick("SignalSell", slot_index);
      }
      else if (StringFind(sparam, "Filter_Slot_") >= 0) {
         int slot_index = (int)StringSubstr(sparam, StringLen("Filter_Slot_"));
         OnSlotClick("Filter", slot_index);
      }
   }
}