# Scripts di BlueTrendTeam

Questa cartella contiene tutti gli script utilizzati internamente dal progetto BlueTrendTeam. La centralizzazione degli script in un'unica cartella segue la regola fondamentale #3 sull'ordine e ottimizzazione delle cartelle e file.

## Elenco degli Script

### 1. send_backup.py
**Funzione**: Script principale per la creazione di backup e l'invio tramite Telegram e email.
**Utilizzo**: `python send_backup.py`
**Note**: Utilizza le credenziali memorizzate in `C:\Users\Asus\BTT_Secure\notification_config.json`.

### 2. send_bbtt_unico.py
**Funzione**: Script semplificato per l'invio del file BBTT.md come backup unico.
**Utilizzo**: `python send_bbtt_unico.py`
**Note**: Versione più leggera rispetto a send_backup.py.

### 3. btt_agent.py
**Funzione**: Agente automatizzato per la gestione delle operazioni di routine di BlueTrendTeam.
**Utilizzo**: `python btt_agent.py`
**Note**: Originariamente situato nella cartella Script_BTT.

### 4. send_all_notifications.py
**Funzione**: Script per l'invio di notifiche a tutti i canali configurati (Telegram, email, ecc.).
**Utilizzo**: `python send_all_notifications.py`
**Note**: Originariamente situato nella cartella docs/scripts.

### 5. send_telegram_notification.py
**Funzione**: Script dedicato all'invio di notifiche solo su Telegram.
**Utilizzo**: `python send_telegram_notification.py [messaggio]`
**Note**: Originariamente situato nella cartella docs/scripts.

## Note Importanti

1. Questi script sono stati centralizzati per facilitare la manutenzione e l'aggiornamento.
2. Le copie originali sono state mantenute nelle loro posizioni originali per evitare di interrompere eventuali dipendenze esistenti.
3. In futuro, si consiglia di utilizzare esclusivamente gli script in questa cartella e di rimuovere le copie duplicate.

## Sicurezza

Tutti gli script che richiedono credenziali utilizzano il file di configurazione sicuro situato in `C:\Users\Asus\BTT_Secure\notification_config.json`. Non modificare questo percorso senza aggiornare anche gli script.

---

*Ultimo aggiornamento: 24 aprile 2025*
