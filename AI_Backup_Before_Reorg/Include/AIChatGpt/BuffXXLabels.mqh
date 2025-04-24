#ifndef __BUFFXXLABELS_MQH__
#define __BUFFXXLABELS_MQH__

//+------------------------------------------------------------------+
//| Inizializza l’etichetta di base per un buffer (slot)            |
//+------------------------------------------------------------------+
void InitBuffXXLabels(string indi_name, int slot_id) {
    string label_name = indi_name + "_BuffLabel_" + IntegerToString(slot_id);

    if (ObjectFind(0, label_name) < 0) {
        ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, label_name, OBJPROP_XSIZE, 100);
        ObjectSetInteger(0, label_name, OBJPROP_YSIZE, 20);
        ObjectSetInteger(0, label_name, OBJPROP_XDISTANCE, 10);
        ObjectSetInteger(0, label_name, OBJPROP_YDISTANCE, 50);
        ObjectSetInteger(0, label_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, label_name, OBJPROP_COLOR, clrWhite);
        // RIMOSSO: ObjectSetInteger(0, label_name, OBJPROP_BORDERCOLOR, clrBlack);
    }
}

//+------------------------------------------------------------------+
//| Disegna le etichette con i valori dei buffer                    |
//+------------------------------------------------------------------+
void DrawBuffLabels(string indi_name, int slot_id, double &buffers[]) {
    string label_name = indi_name + "_BuffLabel_" + IntegerToString(slot_id);

    for (int i = 0; i < ArraySize(buffers); i++) {
        string current_label = label_name + "_" + IntegerToString(i);

        if (ObjectFind(0, current_label) < 0) {
            ObjectCreate(0, current_label, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, current_label, OBJPROP_XSIZE, 100);
            ObjectSetInteger(0, current_label, OBJPROP_YSIZE, 20);
            ObjectSetInteger(0, current_label, OBJPROP_XDISTANCE, 10);
            ObjectSetInteger(0, current_label, OBJPROP_YDISTANCE, 50 + (i * 25));
            ObjectSetInteger(0, current_label, OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(0, current_label, OBJPROP_COLOR, clrWhite);
            // RIMOSSO: ObjectSetInteger(0, current_label, OBJPROP_BORDERCOLOR, clrBlack);
        }

        ObjectSetString(0, current_label, OBJPROP_TEXT, "Buff " + IntegerToString(i) + ": " + DoubleToString(buffers[i], 4));
    }
}

//+------------------------------------------------------------------+
//| Rimuove le etichette associate a uno slot                       |
//+------------------------------------------------------------------+
void ClearBuffLabels(string indi_name, int slot_id) {
    string label_prefix = indi_name + "_BuffLabel_" + IntegerToString(slot_id);

    for (int i = 0; i < 10; i++) {
        string label_name = label_prefix + "_" + IntegerToString(i);
        if (ObjectFind(0, label_name) >= 0)
            ObjectDelete(0, label_name);
    }
}

#endif // __BUFFXXLABELS_MQH__
