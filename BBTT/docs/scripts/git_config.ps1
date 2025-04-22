# Script per configurare Git per la collaborazione tra AI
# Creato il 22 aprile 2025 per BlueTrendTeam

param (
    [string]$UserName = "AIWindsurf",
    [string]$UserEmail = "aiwindsurf@bluetrendteam.com",
    [string]$TokenPath,
    [switch]$Help
)

# Funzione per mostrare l'aiuto
function Show-Help {
    Write-Host "Configurazione Git per la collaborazione tra AI su BlueTrendTeam" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Parametri:" -ForegroundColor Yellow
    Write-Host "  -UserName   : Nome utente Git (default: AIWindsurf)"
    Write-Host "  -UserEmail  : Email utente Git (default: aiwindsurf@bluetrendteam.com)"
    Write-Host "  -TokenPath  : Percorso del file contenente il token GitHub"
    Write-Host "  -Help       : Mostra questo messaggio di aiuto"
    Write-Host ""
    Write-Host "Esempi:" -ForegroundColor Green
    Write-Host "  .\git_config.ps1"
    Write-Host "  .\git_config.ps1 -UserName 'AltroAI' -UserEmail 'altroai@bluetrendteam.com'"
    Write-Host "  .\git_config.ps1 -TokenPath 'C:\path\to\token.txt'"
}

# Se è richiesto l'aiuto, mostralo ed esci
if ($Help) {
    Show-Help
    exit 0
}

# Verifica se git è installato
function Test-GitInstalled {
    try {
        $gitVersion = git --version
        Write-Host "Git installato: $gitVersion" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Git non è installato. Installare Git da https://git-scm.com/downloads" -ForegroundColor Red
        return $false
    }
}

# Se git non è installato, esci
if (-not (Test-GitInstalled)) {
    exit 1
}

# Configura il nome utente e l'email
Write-Host "Configurazione del nome utente e dell'email..." -ForegroundColor Cyan
git config --global user.name $UserName
git config --global user.email $UserEmail

# Verifica se la configurazione è stata applicata
$configuredName = git config --global user.name
$configuredEmail = git config --global user.email

if ($configuredName -eq $UserName -and $configuredEmail -eq $UserEmail) {
    Write-Host "Nome utente e email configurati con successo:" -ForegroundColor Green
    Write-Host "  Nome: $configuredName"
    Write-Host "  Email: $configuredEmail"
}
else {
    Write-Host "Errore durante la configurazione del nome utente e dell'email" -ForegroundColor Red
    exit 1
}

# Configura il token GitHub se specificato
if ($TokenPath) {
    Write-Host "Configurazione del token GitHub..." -ForegroundColor Cyan
    
    # Verifica se il file del token esiste
    if (-not (Test-Path $TokenPath)) {
        Write-Host "File del token non trovato: $TokenPath" -ForegroundColor Red
        exit 1
    }
    
    # Leggi il token dal file
    $token = Get-Content -Path $TokenPath -Raw
    
    # Rimuovi eventuali spazi o caratteri di nuova riga
    $token = $token.Trim()
    
    # Configura il token come variabile d'ambiente
    [Environment]::SetEnvironmentVariable("GITHUB_TOKEN", $token, "User")
    
    # Verifica se la variabile d'ambiente è stata impostata
    $envToken = [Environment]::GetEnvironmentVariable("GITHUB_TOKEN", "User")
    
    if ($envToken) {
        Write-Host "Token GitHub configurato con successo" -ForegroundColor Green
    }
    else {
        Write-Host "Errore durante la configurazione del token GitHub" -ForegroundColor Red
        exit 1
    }
    
    # Configura le credenziali Git per memorizzare il token
    Write-Host "Configurazione delle credenziali Git..." -ForegroundColor Cyan
    
    # Configura il credential helper
    git config --global credential.helper store
    
    Write-Host "Credenziali Git configurate con successo" -ForegroundColor Green
}

# Altre configurazioni utili
Write-Host "Configurazione di altre impostazioni Git..." -ForegroundColor Cyan

# Configura l'editor di default
git config --global core.editor notepad

# Configura il comportamento di fine riga
git config --global core.autocrlf true

# Configura l'output colorato
git config --global color.ui auto

# Configura l'alias per il log grafico
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# Configura il comportamento di pull
git config --global pull.rebase false

Write-Host "Configurazione Git completata con successo" -ForegroundColor Green

# Mostra la configurazione attuale
Write-Host "Configurazione Git attuale:" -ForegroundColor Cyan
git config --list
