@echo off
title BTT_Backup
echo BTT Backup System - BlueTrendTeam
echo ================================
echo.
echo Avvio backup diretto con rotazione automatica dei canali...
echo.

cd /d C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\Scripts\Backup
python btt_unified.py

echo.
echo Grazie per aver utilizzato BTT Backup System!
echo.
