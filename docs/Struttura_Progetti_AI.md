# STRUTTURA DEI PROGETTI AI IN BLUETRENDTEAM

## Principio di Simmetria

Ogni AI deve mantenere una struttura simile, con personalizzazioni specifiche, per facilitare la manutenzione e ridurre la complessità. Questo significa:

1. **Struttura EA uniforme**: Tutti gli Expert Advisor devono seguire lo stesso modello di organizzazione
2. **Directory Include coerenti**: Le directory Include devono essere organizzate in modo simile tra le diverse AI
3. **Riutilizzo delle cartelle esistenti**: Evitare di creare nuove cartelle quando possibile, utilizzando quelle già esistenti
4. **Evitare la proliferazione di cartelle**: Non creare "mille" cartelle diverse, ma mantenere una struttura pulita e coerente

## Struttura Attuale Verificata

Tutte le AI presenti nel sistema seguono la stessa struttura di directory:

```
MQL5\Include\
├── AIChatGpt\
│   ├── common\
│   ├── indicators\
│   ├── omniea\
│   └── ui\
├── AIDeepSeek\
│   ├── common\
│   ├── indicators\
│   ├── omniea\
│   └── ui\
├── AIGemini\
│   ├── common\
│   ├── indicators\
│   ├── omniea\
│   └── ui\
├── AIGrok\
│   ├── common\
│   ├── indicators\
│   ├── omniea\
│   └── ui\
└── AIWindsurf\
    ├── common\
    ├── indicators\
    ├── omniea\
    └── ui\
```

## Struttura Raccomandata per Nuove AI

```
MQL5\
├── Experts\
│   ├── AIWindsurf\       # EA per AIWindsurf
│   ├── OmniEA\           # EA per OmniEA
│   └── [NuovaAI]\        # EA per la nuova AI
├── Include\
│   ├── AIWindsurf\       # Include per AIWindsurf
│   │   ├── common\       # Funzionalità core
│   │   ├── indicators\   # Indicatori personalizzati
│   │   ├── omniea\       # Componenti OmniEA
│   │   └── ui\           # Componenti UI
│   └── [NuovaAI]\        # Include per la nuova AI (struttura simile)
└── Scripts\
    ├── AIWindsurf\       # Script per AIWindsurf
    └── [NuovaAI]\        # Script per la nuova AI
```

## Vantaggi della Struttura Simmetrica

- **Facilità di navigazione**: Gli sviluppatori possono trovare rapidamente i file necessari
- **Manutenzione semplificata**: Le modifiche possono essere applicate in modo coerente tra le diverse AI
- **Riduzione della complessità**: Meno cartelle significa meno confusione
- **Migliore collaborazione**: Tutti i membri del team possono comprendere facilmente la struttura del progetto

## Regole per l'Aggiunta di Nuovi Componenti

1. Verificare sempre se esiste già una cartella appropriata per il nuovo componente
2. Mantenere la stessa struttura di directory tra le diverse AI
3. Utilizzare nomi di file e directory coerenti e descrittivi
4. Documentare la struttura di directory in caso di modifiche significative
