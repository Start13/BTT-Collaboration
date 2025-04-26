# Rapporto Errore OmniEA PresetManager

## Descrizione del Problema
OmniEA_Lite non riesce a caricarsi correttamente sui grafici MT5 a causa di problemi con il PresetManager. L'EA fallisce durante l'inizializzazione quando tenta di creare la directory dei preset e salvare il file Default.json.

## Errori Riscontrati
```
2025.04.26 21:19:51.783	OmniEA_Lite (XAUUSD,H1)	 Errore nel salvataggio del preset: C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Files\OmniEA\Presets\Default.json
2025.04.26 21:19:51.783	OmniEA_Lite (XAUUSD,H1)	EA terminato, Motivo: 7
2025.04.26 21:19:57.518	OmniEA_Lite (XAUUSD,H1)	 Avviso: La directory dei preset non esiste: C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Files\OmniEA\Presets
2025.04.26 21:19:57.518	OmniEA_Lite (XAUUSD,H1)	 Creazione automatica della directory...
2025.04.26 21:19:57.518	OmniEA_Lite (XAUUSD,H1)	 Errore nel salvataggio del preset: C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Files\OmniEA\Presets\Default.json
```

## Errori di Compilazione
```
'PresetManager.mqh'			1
FileTxt.mqh			
File.mqh			
Object.mqh			
StdLibErr.mqh			
FileJson.mqh			
ArrayObj.mqh			
Array.mqh			
Localization.mqh			
ArrayString.mqh			
'AddObject' - undeclared identifier	PresetManager.mqh	141	27
'risk' - some operator expected	PresetManager.mqh	141	38
'operator=' - no one of the overloads can be applied to the function call	PresetManager.mqh	141	20
could be one of 2 function(s)	PresetManager.mqh	141	20
   void CJAVal::operator=(const CJAVal&)	FileJson.mqh	16	7
   void CObject::operator=(const CObject&)	Object.mqh	11	7
'AddObject' - object pointer expected	PresetManager.mqh	141	27
4 errors, 0 warnings		5	1
```

## File Principali
- `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\omniea\PresetManager.mqh` - File principale con il problema
- `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Experts\AIWindsurf\OmniEA_Lite.ex5` - EA che utilizza il PresetManager

## Soluzioni Tentate
1. Modifica del percorso dei preset da `Data\OmniEA\Presets` a `MQL5\Files\OmniEA\Presets` e infine a `MQL5\Files`
2. Rimozione della dipendenza da CJAVal per la gestione JSON
3. Implementazione di un metodo di salvataggio file più diretto con FileOpen/FileWriteString/FileClose
4. Creazione manuale di una stringa JSON valida
5. Rimozione di tutti i tentativi di creazione directory

## Repository GitHub
Il codice aggiornato è disponibile su GitHub al seguente link:
https://github.com/Start13/BTT-Collaboration

## Struttura delle Cartelle
```
BTT-Collaboration/
├── Docs/
│   ├── BBTT_2025-04-26_2132.md (Riepilogo completo)
│   ├── OmniEA_PresetManager_Error_Report.md (Questo file)
│   └── Problema_PresetManager_OmniEA.md (Documentazione dettagliata)
├── src/
│   └── MQL5/
│       ├── Experts/
│       │   └── AIWindsurf/
│       │       └── OmniEA_Lite.mq5
│       └── Include/
│           └── AIWindsurf/
│               └── omniea/
│                   └── PresetManager.mqh
└── README.md
```

## Prossimi Passi Suggeriti
1. Analizzare come viene utilizzata correttamente la classe CJAVal nel contesto di MQL5
2. Verificare se è possibile utilizzare un approccio più semplice per la gestione JSON
3. Implementare una soluzione robusta che funzioni su tutti i terminali MT5
4. Testare la soluzione su diversi ambienti per garantire la compatibilità

## Note per l'AI
- Il problema deve essere risolto in modo che i clienti possano utilizzare OmniEA senza problemi
- La soluzione deve essere completamente automatica, senza richiedere configurazioni manuali
- È fondamentale mantenere la compatibilità con tutti i terminali MT5
- La soluzione deve rispettare la Regola 17 sulla memorizzazione fisica obbligatoria

## Contatto
Per ulteriori informazioni, contattare il team BlueTrendTeam.

*Ultimo aggiornamento: 26 aprile 2025, 21:35*
