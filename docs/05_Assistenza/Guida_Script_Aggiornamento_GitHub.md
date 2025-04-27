# Guida all'Utilizzo dello Script di Aggiornamento GitHub

*Ultimo aggiornamento: 27 aprile 2025, 23:46*

## Introduzione

Questo documento fornisce istruzioni dettagliate su come utilizzare lo script automatizzato per aggiornare i repository GitHub con i file più recenti. Lo script può aggiornare due repository:

1. **MQL5-Backup**: Contiene i file MQL5 per OmniEA
2. **BTT-Collaboration**: Contiene i file del progetto BlueTrendTeam

Lo script implementa la procedura documentata in [Procedura_Aggiornamento_GitHub.md](./Procedura_Aggiornamento_GitHub.md) in modo automatizzato e affidabile.

## Prerequisiti

Prima di utilizzare lo script, assicurati che siano soddisfatti i seguenti prerequisiti:

1. **Git** deve essere installato sul sistema e disponibile nel PATH
2. **PowerShell** deve essere installato (preinstallato su Windows 10/11)
3. Il terminale MQL5 deve essere configurato correttamente con i file aggiornati
4. Il repository BlueTrendTeam deve contenere i file aggiornati

## File dello Script

Nella cartella `Scripts` sono disponibili due file:

1. `update_github_repository.ps1` - Lo script PowerShell principale che esegue l'aggiornamento
2. `update_github_repository.bat` - Un file batch interattivo che semplifica l'esecuzione dello script PowerShell

## Utilizzo Base

Per eseguire lo script con le impostazioni predefinite:

1. Fare doppio clic sul file `update_github_repository.bat` nella cartella `Scripts` o sul collegamento sul desktop
2. Quando richiesto, scegliere se aggiornare entrambi i repository o selezionare quali aggiornare
3. Seguire le istruzioni a schermo
4. Attendere il completamento dell'operazione

Lo script eseguirà automaticamente tutti i passaggi necessari per ciascun repository selezionato:

### Per MQL5-Backup:
- Verifica dei prerequisiti
- Preparazione dell'ambiente
- Clonazione del repository
- Creazione della struttura delle directory
- Copia dei file MQL5 aggiornati
- Configurazione di Git
- Aggiunta dei file modificati
- Esecuzione del commit
- Esecuzione del push
- Pulizia dell'ambiente

### Per BTT-Collaboration:
- Verifica dei prerequisiti
- Preparazione dell'ambiente
- Clonazione del repository
- Copia dei file recenti (modificati negli ultimi 7 giorni)
- Configurazione di Git
- Aggiunta dei file modificati
- Esecuzione del commit
- Esecuzione del push
- Pulizia dell'ambiente

## Utilizzo Avanzato

Per personalizzare il comportamento dello script, è possibile modificare i parametri all'inizio del file `update_github_repository.ps1`:

```powershell
param (
    [switch]$UpdateMQL5 = $true,
    [switch]$UpdateBTT = $true,
    [string]$MQL5RepositoryUrl = "https://github.com/Start13/MQL5-Backup.git",
    [string]$BTTRepositoryUrl = "https://github.com/Start13/BTT-Collaboration.git",
    [string]$BranchName = "master",
    [string]$CommitMessage = "Aggiornamento automatico: $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
    [string]$TempDirectory = "C:\Users\Asus\GitHub-Temp",
    [string]$MQL5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5",
    [string]$BTTPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam",
    [string]$GitUserEmail = "start13@example.com",
    [string]$GitUserName = "Start13"
)
```

È anche possibile eseguire lo script da PowerShell con parametri personalizzati:

```powershell
.\update_github_repository.ps1 -UpdateMQL5 $true -UpdateBTT $false -BranchName "develop" -CommitMessage "Aggiornamento personalizzato"
```

## Personalizzazione dei File da Copiare

### Per MQL5-Backup

Se desideri modificare l'elenco dei file MQL5 da copiare, puoi modificare l'array `$filesToCopy` nella funzione `Copy-MQL5Files` all'interno dello script PowerShell:

```powershell
$filesToCopy = @(
    @{
        Source = "$MQL5Path\Include\AIWindsurf\omniea\PresetManager.mqh"
        Destination = "$RepoPath\Include\AIWindsurf\omniea\PresetManager.mqh"
    },
    # Aggiungi o modifica i file qui
)
```

### Per BTT-Collaboration

Per il repository BlueTrendTeam, lo script copia automaticamente tutti i file modificati negli ultimi 7 giorni. Puoi modificare questo comportamento cambiando il parametro `$DaysBack` nella chiamata alla funzione `Find-RecentBTTFiles`:

```powershell
# Trova i file modificati negli ultimi 7 giorni (modifica il numero per cambiare il periodo)
$recentFiles = Find-RecentBTTFiles -Path $BTTPath -DaysBack 7
```

## Risoluzione dei Problemi

Se lo script incontra errori durante l'esecuzione, verranno visualizzati messaggi di errore dettagliati. Ecco alcuni problemi comuni e le relative soluzioni:

### Errore: "Git non è installato o non è disponibile nel PATH"

**Soluzione**: Installare Git da [git-scm.com](https://git-scm.com/) e assicurarsi che sia aggiunto al PATH di sistema.

### Errore: "Il percorso MQL5 non esiste" o "Il percorso BlueTrendTeam non esiste"

**Soluzione**: Verificare che i percorsi specificati nei parametri `$MQL5Path` e `$BTTPath` siano corretti.

### Errore: "Impossibile eseguire il push"

**Soluzione**: Potrebbe essere necessario configurare l'autenticazione Git. Considera di utilizzare un token di accesso personale:

```powershell
git remote set-url origin https://[USERNAME]:[TOKEN]@github.com/Start13/MQL5-Backup.git
```

## Applicazione della Regola 18

Lo script è stato progettato seguendo la Regola 18 sulla pulizia dei file e cartelle inutili. La directory temporanea creata durante l'esecuzione viene automaticamente eliminata al termine del processo, sia in caso di successo che di errore.

## Supporto

Per ulteriori informazioni o assistenza, consultare la documentazione completa nella cartella `Docs/05_Assistenza` o contattare il team di supporto.

---

*Questo documento è parte della documentazione ufficiale di BlueTrendTeam e deve essere consultato ogni volta che si desidera utilizzare lo script di aggiornamento dei repository GitHub.*
