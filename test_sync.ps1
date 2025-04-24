# Script per testare la sincronizzazione tra AI
$testFile = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\test_sync.mqh"

# Crea un file di test con timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$content = @"
//+------------------------------------------------------------------+
//|                                              test_sync.mqh |
//|                                 Copyright 2025, BlueTrendTeam    |
//|                                       AlgoWi Implementation      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrendteam.com"

// File di test per la sincronizzazione
// Creato il: $timestamp
"@

# Scrivi il contenuto nel file
Set-Content -Path $testFile -Value $content -Encoding UTF8

Write-Host "File di test creato: $testFile"
Write-Host "Contenuto: Timestamp $timestamp"
Write-Host ""
Write-Host "Ora verifica che il file appaia nella dashboard e nel repository GitHub."
Write-Host "Un'altra AI dovrebbe essere in grado di vedere questo file dopo la sincronizzazione."
