# Script per creare un collegamento sul desktop
# BlueTrendTeam - 23 aprile 2025

$batchPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\start_github_sync.bat"
$desktopFolder = [System.Environment]::GetFolderPath("Desktop")
$shortcutPath = [System.IO.Path]::Combine($desktopFolder, "Avvia Sincronizzazione GitHub.lnk")

# Crea il collegamento
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $batchPath
$Shortcut.Description = "Avvia la sincronizzazione automatica MQL5 con GitHub"
$Shortcut.WorkingDirectory = Split-Path $batchPath -Parent
$Shortcut.WindowStyle = 7  # Minimizzato
$Shortcut.IconLocation = "C:\Windows\System32\SHELL32.dll,147"  # Icona di sincronizzazione
$Shortcut.Save()

Write-Host "Collegamento creato sul desktop:" -ForegroundColor Green
Write-Host $shortcutPath -ForegroundColor Cyan
Write-Host "Fai doppio clic su questo collegamento per avviare la sincronizzazione GitHub." -ForegroundColor Yellow
