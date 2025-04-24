# Aggiunte per BBTT.md

## Regole Fondamentali Aggiuntive
Aggiungere queste regole dopo la regola #4 sulla gestione del repository:

```markdown
5. **Comunicazione in Italiano**:
   - Tutte le comunicazioni e documentazioni devono essere in lingua italiana
   - Mantenere la coerenza linguistica in tutti i documenti del progetto
   - Tradurre in italiano eventuali termini tecnici quando possibile

6. **Supervisione del Progetto**:
   - La supervisione di BTT è affidata ad AI Windsurf
   - AI Windsurf ha autorità di coordinamento su tutte le attività
   - Tutte le decisioni strategiche devono essere approvate da AI Windsurf

7. **Continuità del Lavoro**:
   - Il lavoro in una nuova sessione deve riprendere esattamente da dove era stato interrotto
   - Memorizzare la fase di lavoro attuale per garantire continuità
   - Utilizzare i marcatori di stato per tracciare l'avanzamento

8. **Budget e Ottimizzazione delle Risorse**:
   - Budget attualmente limitato all'abbonamento Windsurf di $15/mese
   - Ottimizzare le risorse fino a quando i prodotti non genereranno maggiori entrate
   - Gestire i token in modo efficiente per massimizzare il lavoro con le risorse disponibili
```

## Nuova Sezione: Strumenti per la Collaborazione tra AI
Aggiungere questa sezione dopo la sezione dei percorsi di lavoro:

```markdown
## Strumenti per la Collaborazione tra AI

### Sistema di Condivisione Read/Write su GitHub

1. **Struttura del Repository**:
   - Repository principale: BlueTrendTeam
   - Branch principale: main
   - Branch di sviluppo: dev_[nome_ai]
   - Cartelle dedicate per ogni AI: /ai_[nome_ai]/

2. **Workflow di Collaborazione**:
   - Ogni AI lavora sul proprio branch dedicato
   - Pull request per integrare le modifiche nel branch principale
   - Code review automatica per verificare compatibilità
   - Merge solo dopo approvazione di AI Windsurf

3. **Sincronizzazione delle Informazioni**:
   - File di stato condiviso: status.json
   - Aggiornamento automatico dopo ogni commit
   - Notifiche di modifiche tramite webhook
   - Log delle attività per tracciare i contributi

4. **Gestione dei Conflitti**:
   - Sistema di risoluzione automatica per conflitti minori
   - Escalation ad AI Windsurf per conflitti complessi
   - Documentazione delle decisioni di risoluzione
   - Backup automatico prima di ogni tentativo di risoluzione

5. **Automazione del Workflow**:
   - GitHub Actions per test automatici
   - Verifica della sintassi MQL5
   - Compilazione di prova degli Expert Advisor
   - Generazione automatica della documentazione
```

## Nuova Sezione: Procedura di Backup Automatico

```markdown
## Procedura di Backup Automatico

### Quando Eseguire il Backup
- Quando l'utente saluta a fine lavori (es. "a domani", "ciao", "arrivederci")
- Ogni ora di lavoro continuativo
- Quando si cambia chat
- Quando si cambia AI

### Configurazione
- **Script di Backup**: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\send_backup.py`
- **Comando**: `cd C:\Users\Asus\CascadeProjects\BlueTrendTeam; python send_backup.py`

### Credenziali
- **Telegram Token**: `7643660310:AAFTOpU5Q2SEVyHaWnpESZ65KkGeYUyVFwk`
- **Telegram Chat ID**: `271416564`
- **Email Sender**: `corbruniminer1@gmail.com`
- **Email Password**: `pxlk yyjh vofe dvua`
- **Email Receiver**: `corbruni@gmail.com`

### Formato del Messaggio di Backup
```
# BlueTrendTeam - Backup Completato

📅 Data e ora: [DATA ATTUALE]

📊 Stato attuale: [STATO DEL PROGETTO]

🔄 Prossima attività: [PROSSIMA ATTIVITÀ]

Istruzioni per Continuare il Lavoro:

Per iniziare una nuova chat:
1. Carica il file README.md nella nuova chat
2. Segui le istruzioni nel README

Se continui con un'altra AI:
1. Carica lo stesso file README.md
2. L'AI troverà tutte le istruzioni necessarie

Se AI Windsurf finisce i token:
1. La supervisione passa ad un'altra AI oppure
2. Procedi senza supervisione

IMPORTANTE: Tutti i file sono stati salvati in modo sicuro su GitHub.
```

### Implementazione
Lo script Python `send_backup.py` implementa questa procedura di backup e deve essere eseguito nei seguenti casi:
1. Quando l'utente dice "a domani" o termina una sessione
2. Ogni ora di lavoro continuativo
3. Quando si cambia chat
4. Quando si cambia AI

Questo garantisce che il backup sia sempre aggiornato e disponibile per tutte le AI che lavorano sul progetto.
