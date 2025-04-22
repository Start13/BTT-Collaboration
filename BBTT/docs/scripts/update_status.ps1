# Script per aggiornare automaticamente la sezione "Punto di Ripresa del Lavoro" nel README.md
# Creato il 22 aprile 2025 per BlueTrendTeam

# Percorsi dei file
$readmePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\README.md"
$statusPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\core\stato_progetto.md"

# Ottieni la data e ora corrente
$currentDate = Get-Date -Format "dd MMMM yyyy, HH:mm"

# Leggi lo stato attuale del progetto con encoding UTF-8
$statusContent = Get-Content -Path $statusPath -Raw -Encoding UTF8

# Estrai l'ultimo task completato e i prossimi task pianificati
$lastTaskMatch = [regex]::Match($statusContent, "(?<=## Ultimo Task Completato\r?\n)(.*?)(?=\r?\n\r?\n## Prossimi Task Pianificati)", [System.Text.RegularExpressions.RegexOptions]::Singleline)
$nextTaskMatch = [regex]::Match($statusContent, "(?<=## Prossimi Task Pianificati\r?\n)(.*?)(?=\r?\n\r?\n## Problemi in Sospeso)", [System.Text.RegularExpressions.RegexOptions]::Singleline)

$lastTask = ""
$nextTask = ""

if ($lastTaskMatch.Success) {
    $lastTask = $lastTaskMatch.Value.Trim().Split("`n")[0].TrimStart("- ")
}

if ($nextTaskMatch.Success) {
    $nextTask = $nextTaskMatch.Value.Trim().Split("`n")[0].TrimStart("- ")
}

# Leggi il contenuto attuale del README con encoding UTF-8
$readmeContent = Get-Content -Path $readmePath -Raw -Encoding UTF8

# Aggiorna la data, lo stato attuale e la prossima attività
$updatedContent = $readmeContent -replace "(?<=\*\*Ultimo aggiornamento\*\*: ).*(?=\r?\n)", $currentDate
$updatedContent = $updatedContent -replace "(?<=\*\*Stato attuale\*\*: ).*(?=\r?\n)", "Completato: $lastTask"
$updatedContent = $updatedContent -replace "(?<=\*\*Prossima attività\*\*: ).*(?=\r?\n)", $nextTask

# Salva il contenuto aggiornato con encoding UTF-8 senza BOM
[System.IO.File]::WriteAllText($readmePath, $updatedContent, [System.Text.Encoding]::UTF8)

Write-Host "README.md aggiornato con successo."
Write-Host "Data: $currentDate"
Write-Host "Stato attuale: Completato: $lastTask"
Write-Host "Prossima attività: $nextTask"
