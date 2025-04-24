@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0update_readme.ps1"
echo README.md aggiornato con successo!
pause
