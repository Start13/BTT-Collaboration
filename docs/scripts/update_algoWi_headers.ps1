# Script per aggiornare le intestazioni di AIWindsurf a AlgoWi
# BlueTrendTeam - 23 aprile 2025

# Percorso MQL5
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$aiName = "AIWindsurf"
$algoName = "AlgoWi"

# Trova tutti i file .mqh e .mq5 nelle cartelle dell'AI
$includeFiles = Get-ChildItem -Path "$mql5Path\Include\$aiName" -Recurse -Include "*.mqh" -ErrorAction SilentlyContinue
$expertFiles = Get-ChildItem -Path "$mql5Path\Experts\$aiName" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue
$scriptFiles = Get-ChildItem -Path "$mql5Path\Scripts\$aiName" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue
$indicatorFiles = Get-ChildItem -Path "$mql5Path\Indicators\$aiName" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue

$files = @()
if ($includeFiles) { $files += $includeFiles }
if ($expertFiles) { $files += $expertFiles }
if ($scriptFiles) { $files += $scriptFiles }
if ($indicatorFiles) { $files += $indicatorFiles }

$totalFiles = $files.Count
$updatedFiles = 0

Write-Host "Trovati $totalFiles file per $aiName" -ForegroundColor Yellow

# Aggiorna ogni file
foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $modified = $false
        
        # Sostituzione "Supervisionato da AI Windsurf" con "AlgoWi Implementation"
        if ($content -match "Supervisionato da $aiName") {
            $content = $content -replace "Supervisionato da $aiName", "$algoName Implementation"
            $modified = $true
        }
        elseif ($content -match "Supervisionato da AI Windsurf") {
            $content = $content -replace "Supervisionato da AI Windsurf", "$algoName Implementation"
            $modified = $true
        }
        
        # Se sono state fatte modifiche, salva il file
        if ($modified) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8
            Write-Host "Aggiornato: $($file.FullName)" -ForegroundColor Green
            $updatedFiles++
        }
        else {
            Write-Host "Nessuna modifica necessaria: $($file.FullName)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Errore nell'aggiornamento di $($file.FullName) : $_" -ForegroundColor Red
    }
}

Write-Host "`n=== Riepilogo ===" -ForegroundColor Cyan
Write-Host "Totale file processati: $totalFiles" -ForegroundColor White
Write-Host "Totale file aggiornati: $updatedFiles" -ForegroundColor Green

Write-Host "`nConversione completata!" -ForegroundColor Green
