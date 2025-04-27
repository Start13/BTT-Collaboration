# Script per l'aggiornamento automatico dei repository GitHub
# Creato il: 27 aprile 2025
# Autore: BlueTrendTeam
# Ultimo aggiornamento: 27 aprile 2025, 23:50

# Parametri configurabili
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

# Funzione per la gestione degli errori
function Handle-Error {
    param (
        [string]$ErrorMessage
    )
    Write-Host "ERRORE: $ErrorMessage" -ForegroundColor Red
    # Pulizia in caso di errore
    if (Test-Path $TempDirectory) {
        Remove-Item -Recurse -Force $TempDirectory -ErrorAction SilentlyContinue
    }
    exit 1
}

# Funzione per la verifica dei prerequisiti
function Check-Prerequisites {
    Write-Host "Verifica dei prerequisiti..." -ForegroundColor Cyan
    
    # Verifica che Git sia installato
    try {
        $gitVersion = git --version
        Write-Host "Git installato: $gitVersion" -ForegroundColor Green
    } catch {
        Handle-Error "Git non è installato o non è disponibile nel PATH."
    }
    
    # Verifica che il percorso MQL5 esista
    if ($UpdateMQL5 -and -not (Test-Path $MQL5Path)) {
        Handle-Error "Il percorso MQL5 non esiste: $MQL5Path"
    }
    
    # Verifica che il percorso BTT esista
    if ($UpdateBTT -and -not (Test-Path $BTTPath)) {
        Handle-Error "Il percorso BlueTrendTeam non esiste: $BTTPath"
    }
    
    Write-Host "Tutti i prerequisiti sono soddisfatti." -ForegroundColor Green
}

# Funzione per la preparazione dell'ambiente
function Prepare-Environment {
    Write-Host "Preparazione dell'ambiente..." -ForegroundColor Cyan
    
    # Rimuovi la directory temporanea se esiste già
    if (Test-Path $TempDirectory) {
        Write-Host "Rimozione della directory temporanea esistente..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $TempDirectory
    }
    
    # Crea la directory temporanea
    Write-Host "Creazione della directory temporanea: $TempDirectory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TempDirectory | Out-Null
    
    # Imposta la directory corrente
    Set-Location $TempDirectory
    
    Write-Host "Ambiente preparato con successo." -ForegroundColor Green
}

# Funzione per clonare il repository
function Clone-Repository {
    param (
        [string]$RepositoryUrl,
        [string]$RepositoryName
    )
    
    Write-Host "Clonazione del repository $RepositoryName" -ForegroundColor Cyan
    Write-Host "URL: $RepositoryUrl" -ForegroundColor Cyan
    
    try {
        git clone $RepositoryUrl
        $repoName = $RepositoryUrl.Split('/')[-1].Replace('.git', '')
        Set-Location "$TempDirectory\$repoName"
        Write-Host "Repository $RepositoryName clonato con successo." -ForegroundColor Green
        return $repoName
    } catch {
        Handle-Error "Impossibile clonare il repository $RepositoryName. Errore: $($_.Exception.Message)"
    }
}

# Funzione per creare la struttura delle directory per MQL5
function Create-MQL5DirectoryStructure {
    Write-Host "Creazione della struttura delle directory per MQL5..." -ForegroundColor Cyan
    
    $directories = @(
        "Include\AIWindsurf\omniea",
        "Include\AIWindsurf\ui",
        "Include\AIWindsurf\indicators",
        "Experts\OmniEA"
    )
    
    foreach ($dir in $directories) {
        $fullPath = Join-Path (Get-Location) $dir
        if (-not (Test-Path $fullPath)) {
            Write-Host "Creazione directory: $dir" -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        }
    }
    
    Write-Host "Struttura delle directory MQL5 creata con successo." -ForegroundColor Green
}

# Funzione per copiare i file MQL5
function Copy-MQL5Files {
    param (
        [string]$RepoPath
    )
    
    Write-Host "Copia dei file dal terminale MQL5 al repository..." -ForegroundColor Cyan
    
    $filesToCopy = @(
        @{
            Source = "$MQL5Path\Include\AIWindsurf\omniea\PresetManager.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\omniea\PresetManager.mqh"
        },
        @{
            Source = "$MQL5Path\Include\AIWindsurf\ui\PanelUI.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\ui\PanelUI.mqh"
        },
        @{
            Source = "$MQL5Path\Include\AIWindsurf\ui\PanelEvents.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\ui\PanelEvents.mqh"
        },
        @{
            Source = "$MQL5Path\Include\AIWindsurf\ui\PanelBase.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\ui\PanelBase.mqh"
        },
        @{
            Source = "$MQL5Path\Include\AIWindsurf\ui\PanelManager.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\ui\PanelManager.mqh"
        },
        @{
            Source = "$MQL5Path\Include\AIWindsurf\omniea\SlotManager.mqh"
            Destination = "$RepoPath\Include\AIWindsurf\omniea\SlotManager.mqh"
        }
    )
    
    foreach ($file in $filesToCopy) {
        if (Test-Path $file.Source) {
            Write-Host "Copia del file: $($file.Source)" -ForegroundColor Yellow
            Copy-Item -Path $file.Source -Destination $file.Destination -Force
        } else {
            Write-Host "ATTENZIONE: Il file sorgente non esiste: $($file.Source)" -ForegroundColor Yellow
        }
    }
    
    Write-Host "File MQL5 copiati con successo." -ForegroundColor Green
}

# Funzione per trovare i file più recenti in BTT
function Find-RecentBTTFiles {
    param (
        [string]$Path,
        [int]$DaysBack = 7
    )
    
    $cutoffDate = (Get-Date).AddDays(-$DaysBack)
    
    # Trova tutti i file modificati negli ultimi giorni, escludendo le directory .git e node_modules
    $recentFiles = Get-ChildItem -Path $Path -Recurse -File | 
                   Where-Object { 
                       $_.LastWriteTime -gt $cutoffDate -and 
                       $_.FullName -notmatch '[\\/]\.git[\\/]' -and 
                       $_.FullName -notmatch '[\\/]node_modules[\\/]' -and
                       $_.FullName -notmatch '[\\/]GitHub-Temp[\\/]'
                   }
    
    return $recentFiles
}

# Funzione per copiare i file BTT
function Copy-BTTFiles {
    param (
        [string]$RepoPath
    )
    
    Write-Host "Copia dei file recenti da BlueTrendTeam al repository..." -ForegroundColor Cyan
    
    # Trova i file modificati negli ultimi 7 giorni
    $recentFiles = Find-RecentBTTFiles -Path $BTTPath -DaysBack 7
    
    $filesCopied = 0
    
    foreach ($file in $recentFiles) {
        # Calcola il percorso relativo
        $relativePath = $file.FullName.Substring($BTTPath.Length + 1)
        $destinationPath = Join-Path $RepoPath $relativePath
        $destinationDir = Split-Path -Parent $destinationPath
        
        # Crea la directory di destinazione se non esiste
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }
        
        # Copia il file
        Write-Host "Copia del file: $relativePath" -ForegroundColor Yellow
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        $filesCopied++
    }
    
    Write-Host "File BlueTrendTeam copiati con successo: $filesCopied file." -ForegroundColor Green
}

# Funzione per configurare Git
function Configure-Git {
    Write-Host "Configurazione di Git..." -ForegroundColor Cyan
    
    try {
        git config --global user.email $GitUserEmail
        git config --global user.name $GitUserName
        Write-Host "Git configurato con successo." -ForegroundColor Green
    } catch {
        Handle-Error "Impossibile configurare Git. Errore: $($_.Exception.Message)"
    }
}

# Funzione per verificare lo stato e aggiungere i file
function Add-Files {
    param (
        [string]$RepositoryName
    )
    
    Write-Host "Verifica dello stato e aggiunta dei file per $RepositoryName..." -ForegroundColor Cyan
    
    try {
        # Verifica lo stato
        git status
        
        # Aggiungi tutti i file modificati
        git add .
        
        # Verifica lo stato dopo l'aggiunta
        git status
        
        Write-Host "File aggiunti con successo per $RepositoryName." -ForegroundColor Green
    } catch {
        Handle-Error "Impossibile aggiungere i file per $RepositoryName. Errore: $($_.Exception.Message)"
    }
}

# Funzione per eseguire il commit
function Commit-Changes {
    param (
        [string]$RepositoryName,
        [string]$CustomCommitMessage = ""
    )
    
    $message = if ($CustomCommitMessage -eq "") { $CommitMessage } else { $CustomCommitMessage }
    Write-Host "Esecuzione del commit per $RepositoryName..." -ForegroundColor Cyan
    
    try {
        git commit -m "$message"
        Write-Host "Commit eseguito con successo per $RepositoryName." -ForegroundColor Green
    } catch {
        Handle-Error "Impossibile eseguire il commit per $RepositoryName. Errore: $($_.Exception.Message)"
    }
}

# Funzione per eseguire il push
function Push-Changes {
    param (
        [string]$RepositoryName
    )
    
    Write-Host "Esecuzione del push per $RepositoryName..." -ForegroundColor Cyan
    
    try {
        git push origin $BranchName
        Write-Host "Push eseguito con successo per $RepositoryName." -ForegroundColor Green
    } catch {
        Handle-Error "Impossibile eseguire il push per $RepositoryName. Errore: $($_.Exception.Message)"
    }
}

# Funzione per la pulizia
function Clean-Up {
    Write-Host "Pulizia..." -ForegroundColor Cyan
    
    # Torna alla directory principale
    Set-Location "C:\Users\Asus"
    
    # Rimuovi la directory temporanea
    if (Test-Path $TempDirectory) {
        Remove-Item -Recurse -Force $TempDirectory
        Write-Host "Directory temporanea rimossa con successo." -ForegroundColor Green
    }
    
    Write-Host "Pulizia completata con successo." -ForegroundColor Green
}

# Funzione per aggiornare il repository MQL5
function Update-MQL5Repository {
    Write-Host "=== Inizio dell'aggiornamento del repository MQL5 ===" -ForegroundColor Magenta
    
    # Clona il repository
    $repoName = Clone-Repository -RepositoryUrl $MQL5RepositoryUrl -RepositoryName "MQL5-Backup"
    
    # Crea la struttura delle directory
    Create-MQL5DirectoryStructure
    
    # Copia i file
    Copy-MQL5Files -RepoPath "$TempDirectory\$repoName"
    
    # Configura Git
    Configure-Git
    
    # Aggiungi i file
    Add-Files -RepositoryName "MQL5-Backup"
    
    # Esegui il commit
    Commit-Changes -RepositoryName "MQL5-Backup" -CustomCommitMessage "Aggiornamento MQL5: PresetManager, PanelUI, PanelEvents e altri file necessari"
    
    # Esegui il push
    Push-Changes -RepositoryName "MQL5-Backup"
    
    Write-Host "=== Aggiornamento del repository MQL5 completato con successo! ===" -ForegroundColor Green
}

# Funzione per aggiornare il repository BlueTrendTeam
function Update-BTTRepository {
    Write-Host "=== Inizio dell'aggiornamento del repository BlueTrendTeam ===" -ForegroundColor Magenta
    
    # Torna alla directory temporanea
    Set-Location $TempDirectory
    
    # Clona il repository
    $repoName = Clone-Repository -RepositoryUrl $BTTRepositoryUrl -RepositoryName "BTT-Collaboration"
    
    # Copia i file
    Copy-BTTFiles -RepoPath "$TempDirectory\$repoName"
    
    # Configura Git
    Configure-Git
    
    # Aggiungi i file
    Add-Files -RepositoryName "BTT-Collaboration"
    
    # Esegui il commit
    Commit-Changes -RepositoryName "BTT-Collaboration" -CustomCommitMessage "Aggiornamento BlueTrendTeam: documentazione, script e altre risorse"
    
    # Esegui il push
    Push-Changes -RepositoryName "BTT-Collaboration"
    
    Write-Host "=== Aggiornamento del repository BlueTrendTeam completato con successo! ===" -ForegroundColor Green
}

# Funzione principale
function Main {
    $startTime = Get-Date
    
    Write-Host "=== Inizio dell'aggiornamento dei repository GitHub ===" -ForegroundColor Magenta
    Write-Host "Data e ora: $(Get-Date)" -ForegroundColor Magenta
    
    if ($UpdateMQL5) {
        Write-Host "Repository MQL5: $MQL5RepositoryUrl" -ForegroundColor Magenta
    }
    
    if ($UpdateBTT) {
        Write-Host "Repository BlueTrendTeam: $BTTRepositoryUrl" -ForegroundColor Magenta
    }
    
    Write-Host "Branch: $BranchName" -ForegroundColor Magenta
    Write-Host "Directory temporanea: $TempDirectory" -ForegroundColor Magenta
    Write-Host "=================================================" -ForegroundColor Magenta
    
    try {
        # Verifica prerequisiti e prepara l'ambiente
        Check-Prerequisites
        Prepare-Environment
        
        # Aggiorna il repository MQL5 se richiesto
        if ($UpdateMQL5) {
            Update-MQL5Repository
        }
        
        # Aggiorna il repository BlueTrendTeam se richiesto
        if ($UpdateBTT) {
            Update-BTTRepository
        }
        
        $endTime = Get-Date
        $duration = $endTime - $startTime
        
        Write-Host "=== Aggiornamento dei repository GitHub completato con successo! ===" -ForegroundColor Green
        Write-Host "Data e ora di completamento: $(Get-Date)" -ForegroundColor Green
        Write-Host "Durata totale: $($duration.Minutes) minuti e $($duration.Seconds) secondi" -ForegroundColor Green
    } catch {
        Handle-Error "Si è verificato un errore durante l'aggiornamento dei repository. Errore: $($_.Exception.Message)"
    } finally {
        # Esegui sempre la pulizia
        Clean-Up
    }
}

# Esegui la funzione principale
Main
