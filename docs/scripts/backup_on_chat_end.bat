@echo off
echo Esecuzione del backup alla chiusura della chat...

echo 1. Aggiornamento del README.md con il punto di ripresa del lavoro...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0update_readme.ps1"

echo 2. Esecuzione del backup MQL5 (solo locale)...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup_mql5_safe.ps1" -LocalOnly

echo 3. Invio del backup via Telegram ed email...
cd C:\Users\Asus\CascadeProjects\BlueTrendTeam
python send_backup.py

echo Backup completo eseguito con successo!
pause
