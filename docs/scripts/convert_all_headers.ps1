# Script per convertire tutte le intestazioni esistenti con sigle neutrali
# BlueTrendTeam - 23 aprile 2025

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Percorso MQL5
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"

# Funzione per aggiornare le intestazioni di un file
function Update-FileHeader {
    param (
        [string]$FilePath,
        [string]$OldName,
        [string]$NewName
    )
    
    try {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        $modified = $false
        
        # Sostituzione "AI Implementation" con "Algo Implementation"
        if ($content -match "$OldName Implementation") {
            $content = $content -replace "$OldName Implementation", "$NewName Implementation"
            $modified = $true
        }
        
        # Sostituzione "Supervisionato da AI" con "Algo Implementation"
        if ($content -match "Supervisionato da $OldName") {
            $content = $content -replace "Supervisionato da $OldName", "$NewName Implementation"
            $modified = $true
        }
        
        # Se sono state fatte modifiche, salva il file
        if ($modified) {
            Set-Content -Path $FilePath -Value $content -Encoding UTF8
            Write-Host "Aggiornato: $FilePath" -ForegroundColor Green
            return $true
        }
        
        return $false
    }
    catch {
        Write-Host "Errore nell'aggiornamento di $FilePath : $_" -ForegroundColor Red
        return $false
    }
}

# Contatori per statistiche
$totalFiles = 0
$updatedFiles = 0

# Per ogni AI nella mappatura
foreach ($ai in $aiMappings.Keys) {
    $algo = $aiMappings[$ai]
    Write-Host "`nProcesso $ai -> $algo" -ForegroundColor Cyan
    
    # Trova tutti i file .mqh e .mq5 nelle cartelle dell'AI
    $includeFiles = Get-ChildItem -Path "$mql5Path\Include\$ai" -Recurse -Include "*.mqh" -ErrorAction SilentlyContinue
    $expertFiles = Get-ChildItem -Path "$mql5Path\Experts\$ai" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue
    $scriptFiles = Get-ChildItem -Path "$mql5Path\Scripts\$ai" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue
    $indicatorFiles = Get-ChildItem -Path "$mql5Path\Indicators\$ai" -Recurse -Include "*.mq5" -ErrorAction SilentlyContinue
    
    $files = @()
    if ($includeFiles) { $files += $includeFiles }
    if ($expertFiles) { $files += $expertFiles }
    if ($scriptFiles) { $files += $scriptFiles }
    if ($indicatorFiles) { $files += $indicatorFiles }
    
    $aiFileCount = $files.Count
    $aiUpdatedCount = 0
    
    Write-Host "Trovati $aiFileCount file per $ai" -ForegroundColor Yellow
    
    # Aggiorna ogni file
    foreach ($file in $files) {
        $totalFiles++
        $updated = Update-FileHeader -FilePath $file.FullName -OldName $ai -NewName $algo
        if ($updated) {
            $updatedFiles++
            $aiUpdatedCount++
        }
    }
    
    Write-Host "Aggiornati $aiUpdatedCount/$aiFileCount file per $ai -> $algo" -ForegroundColor Yellow
}

Write-Host "`n=== Riepilogo ===" -ForegroundColor Cyan
Write-Host "Totale file processati: $totalFiles" -ForegroundColor White
Write-Host "Totale file aggiornati: $updatedFiles" -ForegroundColor Green

Write-Host "`nConversione completata!" -ForegroundColor Green
