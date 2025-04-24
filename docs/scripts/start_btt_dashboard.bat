@echo off
echo Avvio della Dashboard BlueTrendTeam...
start "" http://localhost:8080/
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\btt_dashboard_server.ps1"
