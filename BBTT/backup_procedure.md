# Procedura di Backup Automatico

## Quando Eseguire il Backup
- Quando l'utente saluta a fine lavori (es. "a domani", "ciao", "arrivederci")
- Ogni ora di lavoro continuativo
- Quando si cambia chat
- Quando si cambia AI

## Configurazione
- **Script di Backup**: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\send_backup.py`
- **Script di Aggiornamento README**: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\update_readme.ps1`
- **Comando Backup Completo**: 
  ```
  powershell -ExecutionPolicy Bypass -File "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\update_readme.ps1"
  cd C:\Users\Asus\CascadeProjects\BlueTrendTeam
  python send_backup.py
  ```

## Credenziali
- **Telegram Token**: `7643660310:AAFTOpU5Q2SEVyHaWnpESZ65KkGeYUyVFwk`
- **Telegram Chat ID**: `271416564`
- **Email Sender**: `corbruniminer1@gmail.com`
- **Email Password**: `pxlk yyjh vofe dvua`
- **Email Receiver**: `corbruni@gmail.com`

## Procedura Completa di Backup

### 1. Aggiornamento del README.md

Prima di inviare il backup, è fondamentale aggiornare il README.md con il "Punto di Ripresa del Lavoro" per garantire la continuità del progetto. Questo viene fatto automaticamente dallo script `update_readme.ps1` che:

- Aggiorna la data e l'ora dell'ultimo aggiornamento
- Estrae lo stato attuale del progetto e la prossima attività dal file `stato_progetto.md`
- Se `stato_progetto.md` non esiste, utilizza i dati dal `README_handoff.md`
- Aggiorna la sezione "Punto di Ripresa del Lavoro" nel README.md con:
  - Data e ora dell'ultimo aggiornamento
  - Stato attuale del progetto
  - Prossima attività pianificata
  - Contesto attuale del lavoro

La struttura della sezione "Punto di Ripresa del Lavoro" è la seguente:

```markdown
## Punto di Ripresa del Lavoro

📅 **Data ultimo aggiornamento**: [DATA E ORA]

📊 **Stato attuale del progetto**:
- [STATO 1]
- [STATO 2]
- [STATO 3]

🔄 **Prossima attività**:
- [ATTIVITÀ 1]
- [ATTIVITÀ 2]

🔍 **Contesto attuale**:
[DESCRIZIONE DEL CONTESTO ATTUALE]
```

### 2. Invio del Backup

Dopo aver aggiornato il README.md, lo script `send_backup.py` invia il backup via Telegram ed email con il seguente formato:

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

## Implementazione

Il processo completo di backup include:

1. **Aggiornamento del README.md** tramite lo script PowerShell `update_readme.ps1`
2. **Invio del backup** via Telegram e email tramite lo script Python `send_backup.py`

Questo processo deve essere eseguito nei seguenti casi:
1. Quando l'utente dice "a domani" o termina una sessione
2. Ogni ora di lavoro continuativo
3. Quando si cambia chat
4. Quando si cambia AI

Questo garantisce che:
- Il README.md sia sempre aggiornato con le informazioni più recenti
- Il backup sia sempre disponibile per tutte le AI che lavorano sul progetto
- La continuità del lavoro sia mantenuta tra diverse sessioni di AI

## Collegamento sul Desktop

È disponibile un collegamento sul desktop "BTT_Backup_OnChatEnd" che punta a `C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\backup_on_chat_end.bat` per eseguire manualmente il backup completo quando necessario.
