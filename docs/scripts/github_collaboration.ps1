# Script per la collaborazione tra AI su GitHub
# Creato il 22 aprile 2025 per BlueTrendTeam

# Configurazione
$config = @{
    # Repository GitHub
    RepoOwner = "BlueTrendTeam"
    RepoName = "BlueTrendTeam"
    
    # Credenziali (da sostituire con valori reali o usare variabili d'ambiente)
    # IMPORTANTE: Non salvare mai token o credenziali direttamente nel codice
    # Usare variabili d'ambiente o gestori di segreti
    GitHubToken = $env:GITHUB_TOKEN
    
    # Percorsi locali
    LocalRepoPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam"
    StatusFilePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\status.json"
    
    # Configurazione AI
    AIName = "AIWindsurf" # Nome dell'AI corrente
    SupervisorAI = "AIWindsurf" # AI supervisore (come da regola fondamentale #12)
    
    # Impostazioni di log
    LogPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\logs"
    LogFile = "github_collaboration.log"
}

# Crea la cartella di log se non esiste
if (-not (Test-Path $config.LogPath)) {
    New-Item -Path $config.LogPath -ItemType Directory | Out-Null
}

# Funzione per scrivere nel log
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Scrivi nel file di log
    $logFilePath = Join-Path -Path $config.LogPath -ChildPath $config.LogFile
    Add-Content -Path $logFilePath -Value $logMessage -Encoding UTF8
    
    # Mostra anche nella console
    Write-Host $logMessage
}

# Funzione per verificare se git è installato
function Test-GitInstalled {
    try {
        $gitVersion = git --version
        Write-Log "Git installato: $gitVersion"
        return $true
    }
    catch {
        Write-Log "Git non è installato. Installare Git da https://git-scm.com/downloads" -Level "ERROR"
        return $false
    }
}

# Funzione per verificare se il repository locale esiste
function Test-LocalRepository {
    $repoPath = $config.LocalRepoPath
    if (Test-Path (Join-Path -Path $repoPath -ChildPath ".git")) {
        Write-Log "Repository locale trovato in: $repoPath"
        return $true
    }
    else {
        Write-Log "Repository locale non trovato in: $repoPath" -Level "WARN"
        return $false
    }
}

# Funzione per clonare il repository
function Clone-Repository {
    param (
        [string]$Path = $config.LocalRepoPath
    )
    
    if (Test-Path $Path) {
        Write-Log "La directory $Path esiste già. Verificare se è un repository git." -Level "WARN"
        if (Test-LocalRepository) {
            return $true
        }
        else {
            Write-Log "La directory esiste ma non è un repository git." -Level "ERROR"
            return $false
        }
    }
    
    try {
        $repoUrl = "https://github.com/$($config.RepoOwner)/$($config.RepoName).git"
        Write-Log "Clonazione del repository da $repoUrl a $Path"
        
        # Se è disponibile un token, usa l'autenticazione
        if ($config.GitHubToken) {
            $repoUrl = "https://$($config.GitHubToken)@github.com/$($config.RepoOwner)/$($config.RepoName).git"
        }
        
        git clone $repoUrl $Path
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Repository clonato con successo"
            return $true
        }
        else {
            Write-Log "Errore durante la clonazione del repository" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Eccezione durante la clonazione: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per creare o passare al branch dell'AI
function Switch-AIBranch {
    param (
        [string]$AIName = $config.AIName
    )
    
    $branchName = "dev_$AIName"
    
    try {
        # Verifica se il branch esiste localmente
        $localBranches = git branch
        $branchExists = $localBranches -match "\s+$branchName$"
        
        if ($branchExists) {
            Write-Log "Passaggio al branch esistente: $branchName"
            git checkout $branchName
        }
        else {
            # Verifica se il branch esiste sul remote
            git fetch
            $remoteBranches = git branch -r
            $remoteBranchExists = $remoteBranches -match "origin/$branchName$"
            
            if ($remoteBranchExists) {
                Write-Log "Passaggio al branch remoto: $branchName"
                git checkout -b $branchName origin/$branchName
            }
            else {
                Write-Log "Creazione di un nuovo branch: $branchName"
                git checkout -b $branchName
            }
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Ora si sta lavorando sul branch: $branchName"
            return $true
        }
        else {
            Write-Log "Errore durante il passaggio/creazione del branch" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Eccezione durante la gestione del branch: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per aggiornare il file di stato
function Update-StatusFile {
    param (
        [string]$StatusMessage,
        [string]$CurrentTask,
        [string]$NextTask
    )
    
    $statusFilePath = $config.StatusFilePath
    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
    
    # Crea l'oggetto di stato
    $status = @{
        last_update = $timestamp
        ai_name = $config.AIName
        status_message = $StatusMessage
        current_task = $CurrentTask
        next_task = $NextTask
        branch = "dev_$($config.AIName)"
    }
    
    # Converti in JSON e salva
    $statusJson = $status | ConvertTo-Json -Depth 5
    $statusJson | Out-File -FilePath $statusFilePath -Encoding UTF8
    
    Write-Log "File di stato aggiornato: $statusFilePath"
    return $true
}

# Funzione per leggere il file di stato
function Get-StatusFile {
    param (
        [string]$StatusFilePath = $config.StatusFilePath
    )
    
    if (Test-Path $StatusFilePath) {
        try {
            $statusContent = Get-Content -Path $StatusFilePath -Raw -Encoding UTF8
            $status = $statusContent | ConvertFrom-Json
            return $status
        }
        catch {
            Write-Log "Errore durante la lettura del file di stato: $_" -Level "ERROR"
            return $null
        }
    }
    else {
        Write-Log "File di stato non trovato: $StatusFilePath" -Level "WARN"
        return $null
    }
}

# Funzione per committare le modifiche
function Commit-Changes {
    param (
        [string]$Message = "Aggiornamento da $($config.AIName)"
    )
    
    try {
        # Aggiungi tutte le modifiche
        git add .
        
        # Verifica se ci sono modifiche da committare
        $status = git status --porcelain
        if (-not $status) {
            Write-Log "Nessuna modifica da committare"
            return $true
        }
        
        # Commit delle modifiche
        git commit -m $Message
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Modifiche committate con successo: $Message"
            return $true
        }
        else {
            Write-Log "Errore durante il commit delle modifiche" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Eccezione durante il commit: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per pushare le modifiche
function Push-Changes {
    param (
        [string]$Branch = "dev_$($config.AIName)"
    )
    
    try {
        # Push delle modifiche
        if ($config.GitHubToken) {
            # Se è disponibile un token, usa l'autenticazione
            $repoUrl = "https://$($config.GitHubToken)@github.com/$($config.RepoOwner)/$($config.RepoName).git"
            git push $repoUrl $Branch
        }
        else {
            git push origin $Branch
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Modifiche pushate con successo al branch: $Branch"
            return $true
        }
        else {
            Write-Log "Errore durante il push delle modifiche" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Eccezione durante il push: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per creare una pull request
function New-PullRequest {
    param (
        [string]$Title = "Aggiornamenti da $($config.AIName)",
        [string]$Body = "Pull request automatica creata da $($config.AIName)",
        [string]$HeadBranch = "dev_$($config.AIName)",
        [string]$BaseBranch = "main"
    )
    
    if (-not $config.GitHubToken) {
        Write-Log "Token GitHub non configurato. Impossibile creare pull request." -Level "ERROR"
        return $false
    }
    
    try {
        $apiUrl = "https://api.github.com/repos/$($config.RepoOwner)/$($config.RepoName)/pulls"
        
        $headers = @{
            Authorization = "token $($config.GitHubToken)"
            Accept = "application/vnd.github.v3+json"
        }
        
        $body = @{
            title = $Title
            body = $Body
            head = $HeadBranch
            base = $BaseBranch
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"
        
        Write-Log "Pull request creata con successo: $($response.html_url)"
        return $true
    }
    catch {
        Write-Log "Errore durante la creazione della pull request: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per sincronizzare il repository locale con quello remoto
function Sync-Repository {
    try {
        # Passa al branch principale
        git checkout main
        
        # Pull delle ultime modifiche
        git pull origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Repository sincronizzato con successo"
            
            # Torna al branch dell'AI
            Switch-AIBranch
            
            return $true
        }
        else {
            Write-Log "Errore durante la sincronizzazione del repository" -Level "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "Eccezione durante la sincronizzazione: $_" -Level "ERROR"
        return $false
    }
}

# Funzione per creare la cartella dedicata all'AI se non esiste
function Initialize-AIFolder {
    param (
        [string]$AIName = $config.AIName
    )
    
    $aiFolder = Join-Path -Path $config.LocalRepoPath -ChildPath "ai_$AIName"
    
    if (-not (Test-Path $aiFolder)) {
        try {
            New-Item -Path $aiFolder -ItemType Directory | Out-Null
            
            # Crea un file README.md nella cartella dell'AI
            $readmePath = Join-Path -Path $aiFolder -ChildPath "README.md"
            $readmeContent = @"
# AI: $AIName

Questa cartella contiene i contributi di $AIName al progetto BlueTrendTeam.

## Ruolo

$AIName contribuisce al progetto BlueTrendTeam nei seguenti ambiti:

- Sviluppo di componenti per OmniEA
- Ottimizzazione del codice
- Documentazione tecnica

## Attività Correnti

- In corso: Implementazione del sistema di collaborazione GitHub
- Prossima: Sviluppo del generatore di report per OmniEA

## Contatti

Per informazioni su $AIName, contattare il supervisore del progetto.

---

*Ultimo aggiornamento: $(Get-Date -Format "dd MMMM yyyy")*
"@
            
            $readmeContent | Out-File -FilePath $readmePath -Encoding UTF8
            
            Write-Log "Cartella AI creata con successo: $aiFolder"
            return $true
        }
        catch {
            Write-Log "Errore durante la creazione della cartella AI: $_" -Level "ERROR"
            return $false
        }
    }
    else {
        Write-Log "La cartella AI esiste già: $aiFolder"
        return $true
    }
}

# Funzione principale per eseguire il workflow completo
function Start-GitHubCollaboration {
    param (
        [string]$StatusMessage = "Lavoro in corso",
        [string]$CurrentTask = "Implementazione del sistema di collaborazione GitHub",
        [string]$NextTask = "Sviluppo del generatore di report per OmniEA",
        [switch]$CreatePullRequest = $false
    )
    
    Write-Log "Avvio del workflow di collaborazione GitHub per $($config.AIName)"
    
    # Verifica se git è installato
    if (-not (Test-GitInstalled)) {
        return $false
    }
    
    # Verifica se il repository locale esiste, altrimenti clonalo
    if (-not (Test-LocalRepository)) {
        if (-not (Clone-Repository)) {
            return $false
        }
    }
    
    # Vai nella directory del repository
    Set-Location -Path $config.LocalRepoPath
    
    # Sincronizza il repository
    Sync-Repository
    
    # Passa al branch dell'AI
    Switch-AIBranch
    
    # Inizializza la cartella dell'AI
    Initialize-AIFolder
    
    # Aggiorna il file di stato
    Update-StatusFile -StatusMessage $StatusMessage -CurrentTask $CurrentTask -NextTask $NextTask
    
    # Commit delle modifiche
    Commit-Changes -Message "Aggiornamento stato da $($config.AIName): $CurrentTask"
    
    # Push delle modifiche
    Push-Changes
    
    # Crea una pull request se richiesto
    if ($CreatePullRequest) {
        New-PullRequest -Title "[$($config.AIName)] $CurrentTask" -Body "Completato: $CurrentTask`nProssimo: $NextTask"
    }
    
    Write-Log "Workflow di collaborazione GitHub completato con successo"
    return $true
}

# Esempio di utilizzo
# Start-GitHubCollaboration -StatusMessage "Implementazione in corso" -CurrentTask "Sistema di collaborazione GitHub" -NextTask "Generatore di report" -CreatePullRequest

# Esporta le funzioni per l'uso in altri script
Export-ModuleMember -Function Start-GitHubCollaboration, Update-StatusFile, Sync-Repository, Commit-Changes, Push-Changes, New-PullRequest
