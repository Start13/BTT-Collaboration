# Script di sincronizzazione automatica MQL5 con GitHub
# BlueTrendTeam - 23 aprile 2025

# Configurazione
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$repoPath = "C:\Users\Asus\CascadeProjects\MQL5-Backup"
$interval = 300 # 5 minuti
$configPath = "C:\Users\Asus\BTT_Secure\github_config.json"

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Funzione per sincronizzare i file MQL5 con il repository GitHub
function Sync-MQL5Files {
    Write-Host "Sincronizzazione dei file MQL5..." -ForegroundColor Cyan
    $syncTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $filesChanged = 0
    
    # Sincronizza le cartelle delle AI
    $aiDirs = Get-ChildItem -Path "$mql5Path\Include" -Directory | Where-Object { $_.Name -like "AI*" }
    foreach ($aiDir in $aiDirs) {
        $aiName = $aiDir.Name
        $algoName = $aiMappings[$aiName]
        
        Write-Host "Sincronizzazione $aiName ($algoName)..." -ForegroundColor Yellow
        
        # Sincronizza Include
        $sourcePath = "$mql5Path\Include\$aiName"
        $targetPath = "$repoPath\Include\$aiName"
        if (-not (Test-Path $targetPath)) { New-Item -ItemType Directory -Path $targetPath -Force | Out-Null }
        
        # Copia i file .mqh
        $includeFiles = Get-ChildItem -Path $sourcePath -Recurse -Include "*.mqh"
        foreach ($file in $includeFiles) {
            $relativePath = $file.FullName.Substring($sourcePath.Length + 1)
            $targetFile = Join-Path $targetPath $relativePath
            $targetDir = Split-Path $targetFile -Parent
            
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            
            if (-not (Test-Path $targetFile) -or 
                (Get-Item $file.FullName).LastWriteTime -gt (Get-Item $targetFile).LastWriteTime) {
                Copy-Item $file.FullName -Destination $targetFile -Force
                $filesChanged++
            }
        }
        
        # Sincronizza Experts
        $sourcePath = "$mql5Path\Experts\$aiName"
        $targetPath = "$repoPath\Experts\$aiName"
        if (Test-Path $sourcePath) {
            if (-not (Test-Path $targetPath)) { New-Item -ItemType Directory -Path $targetPath -Force | Out-Null }
            
            # Copia i file .mq5
            $expertFiles = Get-ChildItem -Path $sourcePath -Recurse -Include "*.mq5"
            foreach ($file in $expertFiles) {
                $relativePath = $file.FullName.Substring($sourcePath.Length + 1)
                $targetFile = Join-Path $targetPath $relativePath
                $targetDir = Split-Path $targetFile -Parent
                
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                if (-not (Test-Path $targetFile) -or 
                    (Get-Item $file.FullName).LastWriteTime -gt (Get-Item $targetFile).LastWriteTime) {
                    Copy-Item $file.FullName -Destination $targetFile -Force
                    $filesChanged++
                }
            }
        }
        
        # Sincronizza Scripts
        $sourcePath = "$mql5Path\Scripts\$aiName"
        $targetPath = "$repoPath\Scripts\$aiName"
        if (Test-Path $sourcePath) {
            if (-not (Test-Path $targetPath)) { New-Item -ItemType Directory -Path $targetPath -Force | Out-Null }
            
            # Copia i file .mq5
            $scriptFiles = Get-ChildItem -Path $sourcePath -Recurse -Include "*.mq5"
            foreach ($file in $scriptFiles) {
                $relativePath = $file.FullName.Substring($sourcePath.Length + 1)
                $targetFile = Join-Path $targetPath $relativePath
                $targetDir = Split-Path $targetFile -Parent
                
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                if (-not (Test-Path $targetFile) -or 
                    (Get-Item $file.FullName).LastWriteTime -gt (Get-Item $targetFile).LastWriteTime) {
                    Copy-Item $file.FullName -Destination $targetFile -Force
                    $filesChanged++
                }
            }
        }
        
        # Sincronizza Indicators
        $sourcePath = "$mql5Path\Indicators\$aiName"
        $targetPath = "$repoPath\Indicators\$aiName"
        if (Test-Path $sourcePath) {
            if (-not (Test-Path $targetPath)) { New-Item -ItemType Directory -Path $targetPath -Force | Out-Null }
            
            # Copia i file .mq5
            $indicatorFiles = Get-ChildItem -Path $sourcePath -Recurse -Include "*.mq5"
            foreach ($file in $indicatorFiles) {
                $relativePath = $file.FullName.Substring($sourcePath.Length + 1)
                $targetFile = Join-Path $targetPath $relativePath
                $targetDir = Split-Path $targetFile -Parent
                
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                
                if (-not (Test-Path $targetFile) -or 
                    (Get-Item $file.FullName).LastWriteTime -gt (Get-Item $targetFile).LastWriteTime) {
                    Copy-Item $file.FullName -Destination $targetFile -Force
                    $filesChanged++
                }
            }
        }
    }
    
    # Aggiornamento del README con la data dell'ultimo backup
    $readmePath = "$repoPath\README.md"
    if (Test-Path $readmePath) {
        $readme = Get-Content $readmePath -Raw
        $readme = $readme -replace "(?<=\*\*Ultimo backup:\*\* ).*", "$(Get-Date -Format 'dd MMMM yyyy, HH:mm')"
        Set-Content -Path $readmePath -Value $readme -Encoding UTF8
    }
    
    return $filesChanged
}

# Funzione per eseguire commit e push
function Submit-Changes {
    Write-Host "Esecuzione del commit e push delle modifiche..." -ForegroundColor Cyan
    
    Set-Location $repoPath
    
    # Controllo se ci sono modifiche
    $status = git status --porcelain
    if ($status) {
        git add .
        git commit -m "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        
        if (Test-Path $configPath) {
            $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
            $token = $config.token
            $githubUser = $config.githubUser
            $repoName = $config.repoName
            
            git remote set-url origin "https://x-access-token:$token@github.com/$githubUser/$repoName.git"
            git push
            Write-Host "Push completato con successo!" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "File di configurazione non trovato: $configPath" -ForegroundColor Yellow
            return $false
        }
    }
    else {
        Write-Host "Nessuna modifica rilevata." -ForegroundColor Yellow
        return $false
    }
}

# Loop principale
Write-Host "=== Avvio sincronizzazione automatica MQL5 con GitHub ===" -ForegroundColor Green
Write-Host "Intervallo di sincronizzazione: $interval secondi" -ForegroundColor Cyan
Write-Host "Premi CTRL+C per terminare" -ForegroundColor Yellow

try {
    while ($true) {
        $startTime = Get-Date
        Write-Host "`n[$startTime] Inizio sincronizzazione..." -ForegroundColor Cyan
        
        $filesChanged = Sync-MQL5Files
        
        if ($filesChanged -gt 0) {
            Write-Host "Sincronizzati $filesChanged file." -ForegroundColor Green
            $pushSuccess = Submit-Changes
            
            if ($pushSuccess) {
                Write-Host "Sincronizzazione completata con successo!" -ForegroundColor Green
            }
            else {
                Write-Host "Sincronizzazione locale completata, ma il push su GitHub non è riuscito." -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "Nessun file modificato." -ForegroundColor Yellow
        }
        
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        Write-Host "[$endTime] Sincronizzazione completata in $duration secondi." -ForegroundColor Cyan
        
        Write-Host "Prossima sincronizzazione tra $interval secondi..." -ForegroundColor Yellow
        Start-Sleep -Seconds $interval
    }
}
catch {
    Write-Host "Errore durante la sincronizzazione: $_" -ForegroundColor Red
}
finally {
    Write-Host "=== Sincronizzazione terminata ===" -ForegroundColor Green
}
