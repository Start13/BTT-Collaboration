# Script di Automazione BlueTrendTeam

Questa cartella contiene gli script di automazione per il progetto BlueTrendTeam. Gli script sono progettati per facilitare la gestione della documentazione e la collaborazione tra diverse AI.

## Script Disponibili

### 1. github_collaboration.ps1
Script principale per la gestione del workflow GitHub. Implementa tutte le funzionalità necessarie per la collaborazione tra diverse AI su GitHub.

### 2. github_interface.ps1
Interfaccia semplificata per le operazioni comuni di GitHub. Fornisce comandi facili da usare per le operazioni più frequenti.

### 3. git_config.ps1
Script per configurare l'ambiente Git con le credenziali dell'AI e altre impostazioni utili.

## Utilizzo degli Script di Collaborazione GitHub

### Configurazione Iniziale

1. **Configurare Git**:
   ```powershell
   .\git_config.ps1 -UserName "AIWindsurf" -UserEmail "aiwindsurf@bluetrendteam.com"
   ```

2. **Inizializzare il Repository**:
   ```powershell
   .\github_interface.ps1 -Initialize
   ```

### Workflow Quotidiano

1. **Sincronizzare il Repository**:
   ```powershell
   .\github_interface.ps1 -Sync
   ```

2. **Aggiornare il File di Stato**:
   ```powershell
   .\github_interface.ps1 -UpdateStatus -StatusMessage "Lavoro in corso" -CurrentTask "Task attuale" -NextTask "Prossimo task"
   ```

3. **Committare le Modifiche**:
   ```powershell
   .\github_interface.ps1 -Commit -Message "Descrizione delle modifiche"
   ```

4. **Pushare le Modifiche**:
   ```powershell
   .\github_interface.ps1 -Push
   ```

5. **Creare una Pull Request**:
   ```powershell
   .\github_interface.ps1 -CreatePR -Title "Titolo della PR" -Description "Descrizione della PR"
   ```

6. **Eseguire il Workflow Completo**:
   ```powershell
   .\github_interface.ps1 -StartWorkflow -StatusMessage "Lavoro in corso" -CurrentTask "Task attuale" -NextTask "Prossimo task" -CreatePullRequest
   ```

## Note Importanti

- Per utilizzare le funzionalità di GitHub, è necessario configurare un token di accesso personale come variabile d'ambiente `GITHUB_TOKEN`.
- Lo script crea automaticamente un branch dedicato per ogni AI nel formato `dev_[nome_ai]`.
- Tutte le modifiche vengono committate e pushate al branch dedicato dell'AI.
- Le pull request vengono create dal branch dell'AI al branch `main`.
- La supervisione del progetto è affidata ad AI Windsurf, che ha l'autorità di approvare le pull request.

## Riferimenti

Per maggiori dettagli sul workflow GitHub e sul sistema di collaborazione tra AI, consultare:
- [Collaborazione tra AI](../tools/collaborazione_ai.md)
- [GitHub Workflow](../tools/github_workflow.md)

---

*Ultimo aggiornamento: 22 aprile 2025*
