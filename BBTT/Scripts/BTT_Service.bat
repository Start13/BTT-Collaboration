@echo off
echo BTT Backup Service - Servizio di backup automatico
echo ================================================
echo.
echo Questo servizio verifichera' ogni 5 minuti se ci sono state modifiche
echo ai file BBTT o MQL5 e creera' un backup automatico ogni 3 ore se necessario.
echo.
echo Il servizio continuera' a funzionare in background.
echo Per interrompere il servizio, chiudi questa finestra.
echo.
echo Avvio del servizio in corso...
echo.
cd /d C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\Scripts\Backup
python btt_service.py
pause
