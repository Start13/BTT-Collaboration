# Script per aggiornare automaticamente il README.md con lo stato attuale del progetto
# Creato il 22 aprile 2025 per BlueTrendTeam

# Percorso del file README
$readmePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\README.md"

# Ottieni la data e ora corrente
$currentDate = Get-Date -Format "dd MMMM yyyy, HH:mm"

# Leggi il contenuto attuale del README
$content = Get-Content -Path $readmePath -Raw

# Aggiorna la data nell'intestazione
$updatedContent = $content -replace "(?<=\*\*Ultimo aggiornamento\*\*: ).*(?=\r?\n)", $currentDate

# Salva il contenuto aggiornato
$updatedContent | Set-Content -Path $readmePath -Encoding UTF8

Write-Host "README.md aggiornato con successo. Data impostata a: $currentDate"
