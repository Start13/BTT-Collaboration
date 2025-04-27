@echo off
echo ===== Avvio della Dashboard BlueTrendTeam con accesso ai file MQL5 =====
echo.

:: Percorsi
set BTT_PATH=C:\Users\Asus\CascadeProjects\BlueTrendTeam
set MQL5_PATH=C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5
set DASHBOARD_MQL5_PATH=%BTT_PATH%\docs\dashboard\mql5_files

:: Verifica se la directory per i file MQL5 esiste, altrimenti creala
if not exist "%DASHBOARD_MQL5_PATH%" (
    echo Creazione della directory per i file MQL5...
    mkdir "%DASHBOARD_MQL5_PATH%"
)

:: Crea un collegamento simbolico ai file MQL5 se non esiste già
if not exist "%DASHBOARD_MQL5_PATH%\Include" (
    echo Creazione del collegamento simbolico ai file MQL5...
    mklink /D "%DASHBOARD_MQL5_PATH%\Include" "%MQL5_PATH%\Include"
    mklink /D "%DASHBOARD_MQL5_PATH%\Experts" "%MQL5_PATH%\Experts"
    mklink /D "%DASHBOARD_MQL5_PATH%\Scripts" "%MQL5_PATH%\Scripts"
    mklink /D "%DASHBOARD_MQL5_PATH%\Libraries" "%MQL5_PATH%\Libraries"
)

:: Crea un file README.md nella directory dei file MQL5 per spiegare a Grok cosa sono
echo Creazione del file README per Grok...
echo # File MQL5 di OmniEA > "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo Questa directory contiene collegamenti simbolici ai file MQL5 originali di OmniEA. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo ## Struttura >> "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - **Include**: Contiene i file header (.mqh) >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - **Experts**: Contiene gli Expert Advisors (.mq5) >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - **Scripts**: Contiene gli script (.mq5) >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - **Libraries**: Contiene le librerie (.mq5, .dll) >> "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo ## File Importanti >> "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - `Include\AIWindsurf\omniea\PresetManager.mqh`: Gestisce i preset di OmniEA >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - `Include\AIWindsurf\ui\PanelUI.mqh`: Gestisce l'interfaccia utente >> "%DASHBOARD_MQL5_PATH%\README.md"
echo - `Include\AIWindsurf\ui\PanelEvents.mqh`: Gestisce gli eventi dell'interfaccia >> "%DASHBOARD_MQL5_PATH%\README.md"
echo. >> "%DASHBOARD_MQL5_PATH%\README.md"
echo Ultimo aggiornamento: %date% %time% >> "%DASHBOARD_MQL5_PATH%\README.md"

:: Avvia il browser con il dashboard
echo Avvio del browser con la Dashboard BlueTrendTeam...
start "" http://localhost:8080/

:: Avvia il server del dashboard
echo Avvio del server del dashboard...
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%BTT_PATH%\docs\scripts\btt_dashboard_server.ps1"

echo.
echo Dashboard avviata con successo!
echo Grok ora può accedere sia ai file BlueTrendTeam che ai file MQL5 di OmniEA.
echo.
