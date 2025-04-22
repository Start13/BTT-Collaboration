# Progetto OmniEA

## Panoramica
OmniEA è un Expert Advisor avanzato per MetaTrader 5 che permette di combinare diversi indicatori tecnici in strategie di trading personalizzate. Il sistema è progettato per essere flessibile, intuitivo e potente, consentendo agli utenti di creare strategie complesse senza necessità di programmazione.

## Versioni
- **OmniEA Lite**: Versione base con funzionalità essenziali
- **OmniEA Pro**: Versione completa con funzionalità avanzate

## Componenti Principali

### Struttura del Pannello
- **Tre pulsanti indicatori generici** (senza distinzione Buy/Sell)
- **Due pulsanti indicatori "Filter"**
- **Funzionalità drag-and-drop** per trascinare lo stesso indicatore da un pulsante già assegnato ad un altro

### Configurazione Indicatori
- Negli input dell'EA, specificare l'azione dell'indicatore per il Buy e il Sell separatamente
- Ogni indicatore può avere parametri diversi per operazioni Buy e Sell
- Supporto per indicatori in finestra principale e sotto-finestre

### Struttura degli Input
- **Formato**: `[Sezione]_[Slot]_[NomeIndicatore]_[Parametro]`
- **Esempio**: `Buy_1_MA_BufferIndex`, `Buy_1_MA_Condition`
- **Descrizioni**: Includono riferimenti alle etichette "Buff XX"
- **Enum adattivi**: Opzioni contestuali in base al tipo di indicatore

### Parametri Specifici MQL5
- **Time Trading**: Input per definire l'intervallo orario (es. 08:00-20:00) durante il quale il trading è attivo
- **News Filter**: Input per evitare il trading durante eventi di notizie importanti
- **Comment**: Input per personalizzare il commento degli ordini

### Sistema di Etichette "Buff XX"
- Etichettatura visiva dei buffer degli indicatori
- Riferimento semplificato ai buffer negli input di condizione
- Supporto per indicatori con buffer multipli

### Sistema di Preset
- Salvataggio e caricamento di configurazioni complete
- Formato JSON per la portabilità
- Supporto per preset multipli
- Funzionalità di importazione/esportazione

### Ottimizzazione
- Generazione automatica di file .set per ottimizzazione
- Supporto per ottimizzazione di parametri specifici
- Integrazione con il tester di strategia di MetaTrader 5

## File Implementati

### Core
- **OmniEA.mq5**: File principale dell'Expert Advisor
- **Localization.mqh**: Sistema multilingua
- **SlotManager.mqh**: Gestione degli slot per indicatori
- **BufferLabeling.mqh**: Etichettatura dei buffer

### UI
- **PanelBase.mqh**: Base per l'interfaccia utente
- **PanelUI.mqh**: Elementi dell'interfaccia
- **PanelEvents.mqh**: Gestione eventi dell'interfaccia
- **PanelManager.mqh**: Manager principale dell'interfaccia

### Gestione Dati
- **PresetManager.mqh**: Gestione dei preset
- **OptimizerGenerator.mqh**: Generazione configurazioni ottimizzazione
- **FileJson.mqh**: Gestione dei file JSON
- **FileCSV.mqh**: Gestione dei file CSV

### Filtri
- **TimeTrading.mqh**: Gestione del filtro orario di trading
- **NewsFilter.mqh**: Gestione del filtro notizie economiche

## Specifiche Tecniche

### Tipi di Indicatori Supportati
1. **Indicatori di trend (MA, MACD, Ichimoku)**:
   - Confronto con prezzo (per indicatori nella finestra principale)
   - Confronto con altri indicatori nella stessa finestra
   - Direzione/pendenza
   - Attraversamento di livelli significativi (es. zero per MACD)

2. **Oscillatori (RSI, Stochastic, CCI)**:
   - Confronto con livelli specifici (es. 30/70 per RSI)
   - Attraversamento di livelli
   - Divergenze con il prezzo
   - Condizioni di ipercomprato/ipervenduto

3. **Indicatori di volatilità (Bollinger, ATR, Envelopes)**:
   - Confronto con valori relativi (es. distanza dalle bande)
   - Espansione/contrazione (aumento/diminuzione della volatilità)
   - Prezzo che tocca/supera le bande

4. **Indicatori personalizzati**:
   - Supporto per indicatori personalizzati con interfaccia standard
   - Possibilità di specificare manualmente i buffer da utilizzare
   - Opzioni di confronto adattate al contesto della finestra

### Sistema di Enum Adattivi
- Generazione dinamica degli input in base al tipo di indicatore
- Adattamento contestuale delle opzioni disponibili
- Supporto per indicatori in diverse finestre

## Requisiti per Pubblicazione su MQL5 Market
- Codice ben commentato e strutturato
- Conformità ai requisiti di sicurezza
- Documentazione completa
- Localizzazione multilingua (inglese, russo)

---

*Ultimo aggiornamento: 22 aprile 2025*
