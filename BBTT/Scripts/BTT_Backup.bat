@echo off
title BTT_Backup
echo BTT Backup System - BlueTrendTeam
echo ================================
echo.

cd /d C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\Scripts\Backup
python -c "import os; import sys; sys.path.append('.'); from btt_unified import main; main()"

echo.
echo Grazie per aver utilizzato BTT Backup System!
echo.
pause
