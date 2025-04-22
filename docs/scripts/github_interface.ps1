# Script di interfaccia per github_collaboration.ps1
# Creato il 22 aprile 2025 per BlueTrendTeam

param (
    [switch]$Initialize,
    [switch]$UpdateStatus,
    [string]$StatusMessage,
    [string]$CurrentTask,
    [string]$NextTask,
    [switch]$Sync,
    [switch]$Commit,
    [string]$Message,
    [switch]$Push,
    [switch]$CreatePR,
    [string]$Title,
    [string]$Description,
    [switch]$StartWorkflow,
    [switch]$CreatePullRequest,
    [string]$AIName
)

# Importa le funzioni dal modulo principale
$scriptPath = $PSScriptRoot
$mainScriptPath = Join-Path -Path $scriptPath -ChildPath "github_collaboration.ps1"

# Verifica se il file principale esiste
if (-not (Test-Path $mainScriptPath)) {
    Write-Host "Errore: File principale non trovato: $mainScriptPath" -ForegroundColor Red
    exit 1
}

# Importa il modulo principale
. $mainScriptPath

# Funzione per mostrare l'aiuto
function Show-Help {
    Write-Host "Utilizzo dello script di collaborazione GitHub per BlueTrendTeam" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parametri:" -ForegroundColor Yellow
    Write-Host "  -Initialize             : Inizializza il repository locale e crea la cartella dell'AI"
    Write-Host "  -UpdateStatus           : Aggiorna il file di stato"
    Write-Host "    -StatusMessage        : Messaggio di stato"
    Write-Host "    -CurrentTask          : Task attuale"
    Write-Host "    -NextTask             : Prossimo task"
    Write-Host "  -Sync                   : Sincronizza il repository locale con quello remoto"
    Write-Host "  -Commit                 : Commit delle modifiche"
    Write-Host "    -Message              : Messaggio del commit"
    Write-Host "  -Push                   : Push delle modifiche"
    Write-Host "  -CreatePR               : Crea una pull request"
    Write-Host "    -Title                : Titolo della pull request"
    Write-Host "    -Description          : Descrizione della pull request"
    Write-Host "  -StartWorkflow          : Esegue il workflow completo"
    Write-Host "    -CreatePullRequest    : Crea una pull request alla fine del workflow"
    Write-Host "  -AIName                 : Nome dell'AI (default: AIWindsurf)"
    Write-Host ""
    Write-Host "Esempi:" -ForegroundColor Green
    Write-Host "  .\github_interface.ps1 -Initialize"
    Write-Host "  .\github_interface.ps1 -UpdateStatus -StatusMessage 'Lavoro in corso' -CurrentTask 'Task attuale' -NextTask 'Prossimo task'"
    Write-Host "  .\github_interface.ps1 -Sync"
    Write-Host "  .\github_interface.ps1 -Commit -Message 'Descrizione delle modifiche'"
    Write-Host "  .\github_interface.ps1 -Push"
    Write-Host "  .\github_interface.ps1 -CreatePR -Title 'Titolo della PR' -Description 'Descrizione della PR'"
    Write-Host "  .\github_interface.ps1 -StartWorkflow -StatusMessage 'Lavoro in corso' -CurrentTask 'Task attuale' -NextTask 'Prossimo task' -CreatePullRequest"
}

# Se non è specificato alcun parametro, mostra l'aiuto
if ((-not $Initialize) -and (-not $UpdateStatus) -and (-not $Sync) -and (-not $Commit) -and (-not $Push) -and (-not $CreatePR) -and (-not $StartWorkflow)) {
    Show-Help
    exit 0
}

# Imposta il nome dell'AI se specificato
if ($AIName) {
    $config.AIName = $AIName
}

# Esegui le azioni in base ai parametri
if ($Initialize) {
    Write-Host "Inizializzazione del repository per $($config.AIName)..." -ForegroundColor Cyan
    
    # Verifica se git è installato
    if (-not (Test-GitInstalled)) {
        exit 1
    }
    
    # Verifica se il repository locale esiste, altrimenti clonalo
    if (-not (Test-LocalRepository)) {
        if (-not (Clone-Repository)) {
            exit 1
        }
    }
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    # Passa al branch dell'AI
    Switch-AIBranch
    
    # Inizializza la cartella dell'AI
    Initialize-AIFolder
    
    Write-Host "Inizializzazione completata con successo" -ForegroundColor Green
}

if ($UpdateStatus) {
    Write-Host "Aggiornamento del file di stato..." -ForegroundColor Cyan
    
    if (-not $StatusMessage) {
        $StatusMessage = "Lavoro in corso"
    }
    
    if (-not $CurrentTask) {
        $CurrentTask = "Task non specificato"
    }
    
    if (-not $NextTask) {
        $NextTask = "Prossimo task non specificato"
    }
    
    Update-StatusFile -StatusMessage $StatusMessage -CurrentTask $CurrentTask -NextTask $NextTask
    
    Write-Host "File di stato aggiornato con successo" -ForegroundColor Green
}

if ($Sync) {
    Write-Host "Sincronizzazione del repository..." -ForegroundColor Cyan
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    Sync-Repository
    
    Write-Host "Sincronizzazione completata con successo" -ForegroundColor Green
}

if ($Commit) {
    Write-Host "Commit delle modifiche..." -ForegroundColor Cyan
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    if (-not $Message) {
        $Message = "Aggiornamento da $($config.AIName)"
    }
    
    Commit-Changes -Message $Message
    
    Write-Host "Commit completato con successo" -ForegroundColor Green
}

if ($Push) {
    Write-Host "Push delle modifiche..." -ForegroundColor Cyan
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    Push-Changes
    
    Write-Host "Push completato con successo" -ForegroundColor Green
}

if ($CreatePR) {
    Write-Host "Creazione della pull request..." -ForegroundColor Cyan
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    if (-not $Title) {
        $Title = "[$($config.AIName)] Aggiornamenti"
    }
    
    if (-not $Description) {
        $Description = "Pull request automatica creata da $($config.AIName)"
    }
    
    New-PullRequest -Title $Title -Body $Description
    
    Write-Host "Pull request creata con successo" -ForegroundColor Green
}

if ($StartWorkflow) {
    Write-Host "Avvio del workflow completo..." -ForegroundColor Cyan
    
    if (-not $StatusMessage) {
        $StatusMessage = "Lavoro in corso"
    }
    
    if (-not $CurrentTask) {
        $CurrentTask = "Task non specificato"
    }
    
    if (-not $NextTask) {
        $NextTask = "Prossimo task non specificato"
    }
    
    Start-GitHubCollaboration -StatusMessage $StatusMessage -CurrentTask $CurrentTask -NextTask $NextTask -CreatePullRequest:$CreatePullRequest
    
    Write-Host "Workflow completato con successo" -ForegroundColor Green
}
