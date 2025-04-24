# Script per configurare l'attività pianificata di sincronizzazione GitHub
# BlueTrendTeam - 23 aprile 2025

$taskName = "BTT_GitHub_Sync"
$scriptPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\start_github_sync.bat"

# Verifica se l'attività esiste già
$taskExists = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($taskExists) {
    Write-Host "L'attività '$taskName' esiste già. Vuoi sostituirla?" -ForegroundColor Yellow
    $replace = Read-Host "Sostituire? (S/N)"
    if ($replace -ne "S") {
        Write-Host "Operazione annullata." -ForegroundColor Red
        exit
    }
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Crea l'azione
$action = New-ScheduledTaskAction -Execute $scriptPath

# Crea il trigger (ogni 5 minuti)
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration ([TimeSpan]::FromDays(3650))

# Crea le impostazioni (esegui anche se la batteria è scarica, non interrompere se in esecuzione)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Hidden -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

# Crea l'attività pianificata
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force

Write-Host "Attività pianificata '$taskName' creata con successo!" -ForegroundColor Green
Write-Host "La sincronizzazione GitHub verrà eseguita automaticamente ogni 5 minuti." -ForegroundColor Cyan
