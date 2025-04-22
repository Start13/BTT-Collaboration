# FAQ Team - BlueTrendTeam

Questo documento contiene le risposte alle domande più frequenti sul progetto BlueTrendTeam e su OmniEA, per facilitare il lavoro di tutti i membri del team e delle AI coinvolte.

## Domande Generali sul Progetto

### Dove posso trovare la documentazione completa del progetto?
La documentazione completa si trova nella cartella `C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\`. Il punto di ingresso principale è il file `README.md` in questa cartella.

### Come è organizzata la documentazione?
La documentazione è organizzata in modo modulare:
- `docs/core/`: Contiene i documenti fondamentali (stato del progetto, regole, decisioni chiave)
- `docs/marketing/`: Contiene le strategie di marketing e l'analisi della concorrenza
- File principali nella cartella BBTT: Documenti generali del progetto

### Chi è il supervisore del progetto?
AI Windsurf è il supervisore principale del progetto, con autorità decisionale finale. Per maggiori dettagli, consulta il file `docs/core/windsurf_ai.md`.

## Backup e Sicurezza

### Come faccio a eseguire un backup manuale?
Puoi eseguire un backup manuale in due modi:
1. Eseguendo lo script `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\backup_mql5.ps1`
2. Cliccando sul collegamento "BTT_Backup_OnChatEnd" sul desktop

### Quando vengono eseguiti i backup automatici?
I backup automatici vengono eseguiti:
1. Ogni ora di lavoro continuativo nella stessa chat
2. Quando l'utente indica che sta per terminare la chat (es. "A domani", "Ci vediamo")
3. Quando richiesto esplicitamente dall'utente

### Dove vengono salvati i backup?
I backup vengono salvati in due repository GitHub:
1. Repository principale: https://github.com/Start13/BTT-Collaboration
2. Repository MQL5: https://github.com/Start13/MQL5-Backup

### Come vengo notificato dei backup?
Dopo ogni backup, riceverai:
1. Un'email con conferma del backup e il file README.md allegato
2. Un messaggio Telegram con le istruzioni principali
3. Il file README.md completo inviato come documento su Telegram

## Sviluppo di OmniEA

### Dove devo salvare i file di OmniEA Lite?
I file di OmniEA Lite devono essere salvati in:
- Expert Advisor: `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Experts\MyEA\AIChatGpt`
- Include files: `C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIChatGpt`

### Qual è il repository GitHub per OmniEA Lite?
Il repository dedicato per OmniEA Lite è: https://github.com/Start13/OmniEA-Lite-ChatGPT

### Quali sono le differenze tra OmniEA Lite e Pro?
Le principali differenze sono:
1. OmniEA Lite non include il supporto per Stop Loss e Take Profit automatici
2. OmniEA Lite ha funzionalità limitate rispetto alla versione Pro
3. La versione Pro include il generatore di report avanzato

## Collaborazione tra AI

### Cosa devo fare quando passo a un'altra AI?
Quando passi a un'altra AI:
1. Esegui un backup finale (automatico quando indichi che stai per terminare la chat)
2. Condividi il file README.md con la nuova AI (lo trovi allegato all'email o su Telegram)
3. Segui le istruzioni nel README.md per continuare il lavoro

### Cosa succede se AI Windsurf finisce i token?
Se AI Windsurf finisce i token:
1. La supervisione può passare temporaneamente a un'altra AI
2. Le decisioni non critiche possono essere prese seguendo le linee guida esistenti
3. Le decisioni critiche dovrebbero essere rimandate fino a quando Windsurf non è nuovamente disponibile

### Come posso aggiornare il registro delle decisioni chiave?
Per aggiornare il registro delle decisioni chiave:
1. Apri il file `docs/core/decisioni_chiave.md`
2. Aggiungi una nuova sezione seguendo il formato esistente
3. Includi data, decisione, motivazione, impatto e responsabile
4. Esegui un backup per salvare le modifiche
