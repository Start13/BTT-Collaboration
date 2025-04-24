# Script per il backup automatico dei file MQL5 su GitHub
# Versione 2.0 - 23 aprile 2025

# Configurazione
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$backupRepoPath = "C:\Users\Asus\CascadeProjects\MQL5-Backup"
$configPath = "C:\Users\Asus\BTT_Secure\github_config.json"

# Funzione per creare il repository di backup se non esiste
function Initialize-BackupRepo {
    if (-not (Test-Path $backupRepoPath)) {
        Write-Host "Creazione della directory di backup..."
        New-Item -ItemType Directory -Path $backupRepoPath -Force | Out-Null
        
        Write-Host "Inizializzazione del repository Git..."
        Set-Location $backupRepoPath
        git init
        
        # Creazione del README.md
        @"
# MQL5-Backup

Backup automatico dei file MQL5 per BlueTrendTeam.

Questo repository contiene:
- Expert Advisors (OmniEA, Argonaut)
- Indicatori personalizzati
- Script
- Include files (MQH)

**Ultimo backup:** $(Get-Date -Format "dd MMMM yyyy, HH:mm")
"@ | Out-File -FilePath "$backupRepoPath\README.md" -Encoding utf8
        
        # Creazione del .gitignore
        @"
# File compilati
*.ex5
*.ex4

# File temporanei
*.tmp

# Log files
*.log

# File di configurazione personali
terminal.ini
config.json
**/notification_config.json
**/github_config.json
"@ | Out-File -FilePath "$backupRepoPath\.gitignore" -Encoding utf8
        
        git add .
        git commit -m "Inizializzazione del repository di backup MQL5"
    }
    else {
        Write-Host "Repository di backup già esistente."
    }
}

# Funzione per sincronizzare i file MQL5
function Sync-MQL5Files {
    Write-Host "Sincronizzazione dei file MQL5..."
    
    # Copia dei file da MQL5 al repository di backup
    $folders = @("Experts", "Include", "Indicators", "Scripts")
    foreach ($folder in $folders) {
        $sourcePath = Join-Path $mql5Path $folder
        $destPath = Join-Path $backupRepoPath $folder
        
        if (Test-Path $sourcePath) {
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Directory -Path $destPath -Force | Out-Null
            }
            
            # Copia dei file .mq5, .mqh
            Get-ChildItem -Path $sourcePath -Recurse -Include "*.mq5", "*.mqh" | ForEach-Object {
                $relativePath = $_.FullName.Substring($sourcePath.Length + 1)
                $targetFile = Join-Path $destPath $relativePath
                $targetDir = Split-Path $targetFile -Parent
                
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                Copy-Item $_.FullName -Destination $targetFile -Force
            }
        }
    }
    
    # Aggiornamento del README con la data dell'ultimo backup
    $readmePath = "$backupRepoPath\README.md"
    $readme = Get-Content $readmePath -Raw
    $readme = $readme -replace "(?<=\*\*Ultimo backup:\*\* ).*", "$(Get-Date -Format 'dd MMMM yyyy, HH:mm')"
    $readme | Out-File -FilePath $readmePath -Encoding utf8
}

# Funzione per eseguire commit e push
function Submit-Changes {
    Write-Host "Esecuzione del commit e push delle modifiche..."
    
    Set-Location $backupRepoPath
    
    # Controllo se ci sono modifiche
    $status = git status --porcelain
    if ($status) {
        git add .
        git commit -m "Backup automatico MQL5: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        
        if (Test-Path $configPath) {
            $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
            $token = $config.token
            $githubUser = $config.githubUser
            $repoName = $config.repoName
            
            git remote set-url origin "https://x-access-token:$token@github.com/$githubUser/$repoName.git"
            git push
            Write-Host "Backup completato con successo!"
        }
        else {
            Write-Host "File di configurazione non trovato. Impossibile eseguire il push."
        }
    }
    else {
        Write-Host "Nessuna modifica rilevata."
    }
}

# Esecuzione principale
param(
    [switch]$LocalOnly
)

try {
    Write-Host "=== Avvio del backup MQL5 ===" -ForegroundColor Green
    Initialize-BackupRepo
    Sync-MQL5Files
    
    if (-not $LocalOnly) {
        Submit-Changes
    } else {
        Write-Host "Modalità backup locale attivata. Skip del push su GitHub." -ForegroundColor Yellow
    }
    
    # Invia notifiche dopo il backup
    $notificationConfigPath = "C:\Users\Asus\BTT_Secure\notification_config.json"
    if (Test-Path $notificationConfigPath) {
        Write-Host "Invio notifiche via email e Telegram..." -ForegroundColor Cyan
        $notificationScript = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "send_all_notifications.py"
        if (Test-Path $notificationScript) {
            python $notificationScript $notificationConfigPath
        }
        else {
            Write-Host "Script di notifica non trovato: $notificationScript" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "File di configurazione delle notifiche non trovato: $notificationConfigPath" -ForegroundColor Yellow
    }
    
    Write-Host "=== Backup MQL5 completato ===" -ForegroundColor Green
}
catch {
    Write-Host "Errore durante il backup: $_" -ForegroundColor Red
}
