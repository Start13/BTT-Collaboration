# Script per configurare l'automazione dei backup (versione utente)
# Versione 1.0 - 22 aprile 2025

# Configurazione
$scriptPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts"
$backupScript = "$scriptPath\backup_mql5.ps1"

# Funzione per creare uno script di backup da eseguire alla chiusura della chat
function Create-ChatEndBackupScript {
    Write-Host "Configurazione del backup automatico alla chiusura della chat..." -ForegroundColor Cyan
    
    # Crea uno script batch che verrà eseguito alla chiusura della chat
    $chatEndScriptPath = "$scriptPath\backup_on_chat_end.bat"
    
@"
@echo off
echo Esecuzione del backup alla chiusura della chat...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "$backupScript"
echo Backup completato!
pause
"@ | Out-File -FilePath $chatEndScriptPath -Encoding ascii
    
    Write-Host "Script di backup alla chiusura della chat creato: $chatEndScriptPath" -ForegroundColor Green
    
    # Crea un collegamento sul desktop per facilitare l'esecuzione
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktopPath\BTT_Backup_OnChatEnd.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $chatEndScriptPath
    $Shortcut.IconLocation = "shell32.dll,46"
    $Shortcut.Description = "Esegui il backup di BlueTrendTeam alla chiusura della chat"
    $Shortcut.Save()
    
    Write-Host "Collegamento creato sul desktop: $shortcutPath" -ForegroundColor Green
    
    # Aggiorna il file README.md per includere le istruzioni
    $readmePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\README.md"
    $readme = Get-Content $readmePath -Raw
    
    if ($readme -notmatch "## Backup Automatico") {
        $backupInstructions = @"

## Backup Automatico
Il sistema è configurato per eseguire backup automatici:
- Alla chiusura della chat (clicca sul collegamento "BTT_Backup_OnChatEnd" sul desktop)

**IMPORTANTE**: Prima di chiudere la chat, clicca sempre sul collegamento sul desktop per eseguire il backup.
"@
        
        $readme = $readme -replace "(## Struttura della Documentazione)", "$backupInstructions`n`n$1"
        $readme | Out-File -FilePath $readmePath -Encoding utf8
        
        Write-Host "Istruzioni di backup aggiunte al README.md" -ForegroundColor Green
    }
}

# Funzione per verificare che lo script di backup funzioni correttamente
function Test-BackupScript {
    Write-Host "Test dello script di backup..." -ForegroundColor Cyan
    
    try {
        & $backupScript
        Write-Host "Test completato con successo!" -ForegroundColor Green
    }
    catch {
        Write-Host "Errore durante il test dello script di backup: $_" -ForegroundColor Red
    }
}

# Esecuzione principale
try {
    Write-Host "=== Configurazione dell'automazione dei backup ===" -ForegroundColor Green
    
    # Verifica che lo script di backup esista
    if (-not (Test-Path $backupScript)) {
        Write-Host "Script di backup non trovato: $backupScript" -ForegroundColor Red
        exit 1
    }
    
    # Configura il backup alla chiusura della chat
    Create-ChatEndBackupScript
    
    # Testa lo script di backup
    Test-BackupScript
    
    Write-Host "=== Configurazione completata con successo! ===" -ForegroundColor Green
    Write-Host "Il sistema eseguirà backup automatici alla chiusura della chat." -ForegroundColor Green
    Write-Host "Per configurare il backup orario, esegui questo script come amministratore." -ForegroundColor Yellow
}
catch {
    Write-Host "Errore durante la configurazione: $_" -ForegroundColor Red
}
