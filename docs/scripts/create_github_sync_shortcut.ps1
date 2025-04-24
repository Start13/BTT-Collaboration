# Script per creare un collegamento nella cartella di avvio automatico
# BlueTrendTeam - 23 aprile 2025

$batchPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\start_github_sync.bat"
$startupFolder = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Startup"), "BTT_GitHub_Sync.lnk")

# Crea il collegamento
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($startupFolder)
$Shortcut.TargetPath = $batchPath
$Shortcut.Description = "Sincronizzazione automatica MQL5 con GitHub"
$Shortcut.WorkingDirectory = Split-Path $batchPath -Parent
$Shortcut.WindowStyle = 7  # Minimizzato
$Shortcut.Save()

Write-Host "Collegamento creato nella cartella di avvio automatico:" -ForegroundColor Green
Write-Host $startupFolder -ForegroundColor Cyan
Write-Host "La sincronizzazione GitHub verrà avviata automaticamente all'avvio di Windows." -ForegroundColor Yellow
