# Progetto Argonaut

## Panoramica
Argonaut è un Expert Advisor avanzato per MetaTrader 5 specializzato nel trading basato sui gap di prezzo, con capacità di auto-apprendimento e ottimizzazione. Il sistema è progettato per adattarsi automaticamente alle condizioni di mercato e migliorare le proprie performance nel tempo.

## Requisiti Specifici

- **Broker**: RoboForex (account procent)
- **Asset iniziale**: XAUUSD
- **Timeframes supportati**: Da 5m a 4h
- **Strategia**: Trading basato sui gap con capacità di auto-apprendimento
- **Costi di commissione**: 7 EUR per lotto
- **Dimensione minima del lotto**: 0.01

## Funzionalità Principali

### Auto-apprendimento
- Ottimizzazione automatica dei parametri
- Adattamento alle condizioni di mercato
- Miglioramento continuo delle performance

### Multi-asset
- Supporto per diversi strumenti finanziari
- Ottimizzazione specifica per asset
- Gestione del portafoglio diversificato

### Strategia di Hedging
- Apertura di posizioni in direzioni opposte
- Gestione del rischio attraverso il bilanciamento delle posizioni
- Protezione contro movimenti estremi del mercato

### Dati Storici
- Utilizzo di dati da TickStory (MT5_bars.csv e MT5_ticks.csv)
- Analisi approfondita dei dati storici
- Backtesting accurato

### Adattamento in Tempo Reale
- Regolazione dei parametri in tempo reale
- Risposta rapida ai cambiamenti del mercato
- Monitoraggio continuo delle performance

### Specifiche del Broker
- Considerazione degli orari di mercato specifici del broker
- Gestione dello spread
- Ottimizzazione per i costi di swap

## Componenti Tecnici

### Sistema di Rilevamento Gap
- Algoritmi avanzati per l'identificazione dei gap
- Classificazione dei gap per dimensione e significatività
- Previsione della probabilità di chiusura del gap

### Ottimizzazione Automatica
- Algoritmi genetici per l'ottimizzazione dei parametri
- Ottimizzazione settimanale automatica
- Validazione dei risultati attraverso walk-forward testing

### Gestione del Rischio
- Calcolo dinamico del rischio per operazione
- Adattamento del volume in base alla volatilità
- Protezione del capitale durante periodi di alta volatilità

### Interfaccia Utente
- Dashboard per il monitoraggio delle performance
- Visualizzazione grafica dei gap identificati
- Statistiche dettagliate sulle operazioni

### Integrazione con OptimizerGenerator
- Generazione automatica di configurazioni di ottimizzazione
- Supporto per l'ottimizzazione dei parametri di rilevamento dei gap
- Implementazione della funzionalità di auto-ottimizzazione settimanale

## Sviluppi Futuri

### Versione 2.0
- Implementazione di algoritmi di machine learning avanzati
- Supporto per pattern di prezzo complessi oltre ai gap
- Integrazione con fonti di dati esterne

### Versione Mobile
- Interfaccia ottimizzata per dispositivi mobili
- Notifiche push per eventi significativi
- Monitoraggio remoto delle performance

### Versione Cloud
- Hosting su server cloud per operatività 24/7
- Sincronizzazione tra più terminali
- Backup automatico delle configurazioni e dei dati

## Integrazione con OmniEA

### Componenti Condivisi
- OptimizerGenerator.mqh per l'ottimizzazione dei parametri
- Sistema di gestione preset in formato JSON
- Framework di localizzazione multilingua

### Differenze Chiave
- Argonaut: Specializzato in gap trading con auto-apprendimento
- OmniEA: Sistema generico per combinare indicatori tecnici

---

*Ultimo aggiornamento: 22 aprile 2025*
