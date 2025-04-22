# Percorsi di Lavoro per BlueTrendTeam

## Percorsi MetaTrader 5

1. **Percorso principale MetaTrader 5**: 
   - C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5

2. **Percorso Expert Advisor**:
   - C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Experts\MyEA\AIWindsurf\omniea

3. **Percorso Include**:
   - C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf

4. **Percorso MetaEditor**:
   - C:\Program Files\MetaTrader 5\metaeditor64.exe

## Percorsi del Progetto BlueTrendTeam

1. **Percorso principale del progetto**:
   - C:\Users\Asus\CascadeProjects\BlueTrendTeam

2. **Percorso documentazione**:
   - C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT

3. **Percorso documentazione modulare**:
   - C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs

## Linee Guida per l'Utilizzo dei Percorsi

1. **Nei file MQL5**:
   - Utilizzare sempre percorsi relativi per gli include
   - Esempio: `#include <AIWindsurf/common/Localization.mqh>` invece di percorsi assoluti

2. **Nella documentazione**:
   - Utilizzare percorsi relativi per i collegamenti tra file
   - Esempio: `[Regole Fondamentali](./core/regole_fondamentali.md)`

3. **Nei comandi terminale**:
   - Utilizzare percorsi assoluti per garantire la corretta esecuzione
   - Specificare sempre la directory di lavoro corrente (cwd)

4. **Nei file di configurazione**:
   - Utilizzare variabili d'ambiente o placeholder quando possibile
   - Documentare chiaramente il significato di ogni percorso

---

*Ultimo aggiornamento: 22 aprile 2025*
