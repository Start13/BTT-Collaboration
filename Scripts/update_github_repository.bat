@echo off
echo ===== Script di aggiornamento repository GitHub =====
echo.
echo Questo script eseguira' l'aggiornamento automatico dei repository GitHub:
echo 1. MQL5-Backup (https://github.com/Start13/MQL5-Backup.git)
echo 2. BTT-Collaboration (https://github.com/Start13/BTT-Collaboration.git)
echo.
echo Data e ora: %date% %time%
echo.
echo ===================================================
echo.

set /p choice=Vuoi aggiornare entrambi i repository? (S/N): 
if /i "%choice%"=="N" goto :CUSTOM

echo Aggiornamento di entrambi i repository in corso...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0update_github_repository.ps1" -UpdateMQL5 $true -UpdateBTT $true
goto :END

:CUSTOM
echo.
set /p mql5=Vuoi aggiornare il repository MQL5-Backup? (S/N): 
set /p btt=Vuoi aggiornare il repository BTT-Collaboration? (S/N): 
echo.

set MQL5Param=$false
set BTTParam=$false

if /i "%mql5%"=="S" set MQL5Param=$true
if /i "%btt%"=="S" set BTTParam=$true

echo Aggiornamento personalizzato in corso...
powershell.exe -ExecutionPolicy Bypass -File "%~dp0update_github_repository.ps1" -UpdateMQL5 %MQL5Param% -UpdateBTT %BTTParam%

:END
echo.
if %ERRORLEVEL% EQU 0 (
    echo ===== Aggiornamento completato con successo! =====
) else (
    echo ===== Si e' verificato un errore durante l'aggiornamento! =====
)

echo.
echo Premi un tasto per chiudere questa finestra...
pause > nul
