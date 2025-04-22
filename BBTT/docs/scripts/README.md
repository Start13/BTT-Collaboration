# Script di Automazione BlueTrendTeam

Questa cartella contiene gli script di automazione per il progetto BlueTrendTeam. Gli script sono progettati per facilitare la gestione della documentazione e la collaborazione tra diverse AI.

## Script Disponibili

### 1. update_readme.ps1
Aggiorna automaticamente la data nell'intestazione del README.md principale.

**Utilizzo**:
```powershell
.\update_readme.ps1
```

### 2. update_status.ps1
Aggiorna la sezione "Punto di Ripresa del Lavoro" nel README.md estraendo le informazioni dal file stato_progetto.md.

**Utilizzo**:
```powershell
.\update_status.ps1
```

### 3. github_collaboration.ps1
Implementa il sistema di collaborazione tra diverse AI tramite GitHub, come descritto nel documento [Collaborazione tra AI](../tools/collaborazione_ai.md).

## Utilizzo dello Script di Collaborazione GitHub

Lo script `github_collaboration.ps1` fornisce diverse funzionalità per facilitare la collaborazione tra AI su GitHub:

1. **Inizializzazione del repository**:
   ```powershell
   .\github_collaboration.ps1 -Initialize
   ```

2. **Aggiornamento dello stato**:
   ```powershell
   .\github_collaboration.ps1 -UpdateStatus -StatusMessage "Lavoro in corso" -CurrentTask "Task attuale" -NextTask "Prossimo task"
   ```

3. **Sincronizzazione con il repository remoto**:
   ```powershell
   .\github_collaboration.ps1 -Sync
   ```

4. **Commit e push delle modifiche**:
   ```powershell
   .\github_collaboration.ps1 -Commit -Message "Descrizione delle modifiche"
   ```

5. **Creazione di una pull request**:
   ```powershell
   .\github_collaboration.ps1 -CreatePR -Title "Titolo della PR" -Description "Descrizione della PR"
   ```

6. **Workflow completo**:
   ```powershell
   .\github_collaboration.ps1 -StartWorkflow -StatusMessage "Lavoro in corso" -CurrentTask "Task attuale" -NextTask "Prossimo task" -CreatePullRequest
   ```

## Configurazione

Lo script utilizza il file `status.json` nella cartella `docs` per memorizzare le informazioni di stato e configurazione. È possibile modificare questo file per personalizzare il comportamento dello script.

## Note Importanti

- Per utilizzare le funzionalità di GitHub, è necessario configurare un token di accesso personale come variabile d'ambiente `GITHUB_TOKEN`.
- Lo script crea automaticamente un branch dedicato per ogni AI nel formato `dev_[nome_ai]`.
- Tutte le modifiche vengono committate e pushate al branch dedicato dell'AI.
- Le pull request vengono create dal branch dell'AI al branch `main`.
- La supervisione del progetto è affidata ad AI Windsurf, che ha l'autorità di approvare le pull request.

## Come Utilizzare gli Script

1. Prima di iniziare una nuova sessione di lavoro, eseguire `update_status.ps1` per aggiornare il README con lo stato attuale del progetto
2. Al termine della sessione, aggiornare manualmente il file `stato_progetto.md` con i progressi fatti
3. Eseguire nuovamente `update_status.ps1` per sincronizzare il README con lo stato aggiornato

## Nota Importante

Questi script sono progettati per facilitare la continuità del lavoro tra diverse sessioni di AI, in conformità con la Regola Fondamentale #7 sulla continuità del lavoro.

---

*Ultimo aggiornamento: 22 aprile 2025*
