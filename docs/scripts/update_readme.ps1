# Script per aggiornare automaticamente il README.md con il punto di ripresa del lavoro
# Creato da AI Windsurf per BlueTrendTeam
# Data: 22 aprile 2025

# Percorso del file README.md
$readmePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\README.md"

# Ottieni la data e l'ora corrente
$currentDateTime = Get-Date -Format "dd MMMM yyyy, HH:mm"

# Leggi il contenuto attuale del README.md
$content = Get-Content -Path $readmePath -Raw

# Estrai lo stato attuale e la prossima attività dal file stato_progetto.md se esiste
$statoProgettoPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\core\stato_progetto.md"
$statoAttuale = ""
$prossimaAttivita = ""
$contestoAttuale = ""

if (Test-Path $statoProgettoPath) {
    $statoContent = Get-Content -Path $statoProgettoPath -Raw
    
    # Estrai lo stato attuale
    if ($statoContent -match "## Stato Attuale\s*\r?\n([\s\S]*?)(?=\r?\n##|\z)") {
        $statoAttuale = $matches[1].Trim()
    }
    
    # Estrai la prossima attività
    if ($statoContent -match "## Prossima Attività\s*\r?\n([\s\S]*?)(?=\r?\n##|\z)") {
        $prossimaAttivita = $matches[1].Trim()
    }
    
    # Estrai il contesto attuale
    if ($statoContent -match "## Contesto Attuale\s*\r?\n([\s\S]*?)(?=\r?\n##|\z)") {
        $contestoAttuale = $matches[1].Trim()
    }
}

# Se non è stato trovato lo stato_progetto.md, usa i valori predefiniti dal README_handoff.md
if ([string]::IsNullOrEmpty($statoAttuale) -or [string]::IsNullOrEmpty($prossimaAttivita)) {
    $handoffPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\README_handoff.md"
    if (Test-Path $handoffPath) {
        $handoffContent = Get-Content -Path $handoffPath -Raw
        
        # Estrai lo stato attuale - senza usare emoji
        if ($handoffContent -match "\*\*Completato\*\*:([\s\S]*?)(?=\*\*Prossima|\z)") {
            $statoAttuale = $matches[1].Trim()
        }
        
        # Estrai la prossima attività - senza usare emoji
        if ($handoffContent -match "\*\*Prossima attività\*\*:([\s\S]*?)(?=##|\z)") {
            $prossimaAttivita = $matches[1].Trim()
        }
    }
}

# Se ancora non abbiamo trovato i valori, usa quelli attuali
if ([string]::IsNullOrEmpty($statoAttuale)) {
    $statoAttuale = "- Migrazione di tutte le cartelle AI nelle nuove strutture standardizzate
- Aggiunta dei pannelli UI da Panel MT5 alla cartella Include\AIWindsurf\panels
- Creazione del gestore messaggi Telegram (TelegramManager.mqh)"
}

if ([string]::IsNullOrEmpty($prossimaAttivita)) {
    $prossimaAttivita = '- Implementazione dettagliata del sistema di etichette "Buff XX" per l''identificazione visiva dei buffer
- Sviluppo di OmniEA Lite per renderlo vendibile su mql5.com entro fine settimana'
}

if ([string]::IsNullOrEmpty($contestoAttuale)) {
    $contestoAttuale = "Stiamo lavorando all'implementazione del sistema BuffXXLabels.mqh per OmniEA Lite, che permetterà di visualizzare i valori dei buffer degli indicatori direttamente sul grafico."
}

# Crea la nuova sezione "Punto di Ripresa del Lavoro"
$nuovaSezionePuntoRipresa = @"
## Punto di Ripresa del Lavoro

📅 **Data ultimo aggiornamento**: $currentDateTime

📊 **Stato attuale del progetto**:
$statoAttuale

🔄 **Prossima attività**:
$prossimaAttivita

🔍 **Contesto attuale**:
$contestoAttuale

"@

# Aggiorna il README.md
if ($content -match "## Punto di Ripresa del Lavoro\s*\r?\n([\s\S]*?)(?=\r?\n## Progetti)") {
    # Se la sezione esiste già, aggiornala
    $content = $content -replace "## Punto di Ripresa del Lavoro\s*\r?\n([\s\S]*?)(?=\r?\n## Progetti)", $nuovaSezionePuntoRipresa
} else {
    # Se la sezione non esiste, aggiungila dopo l'intestazione
    $content = $content -replace "(Repository principale.*?supervisionato da AI Windsurf\.)\r?\n", "`$1`r`n`r`n$nuovaSezionePuntoRipresa"
}

# Aggiorna anche la data nell'ultima riga
$content = $content -replace "\*Ultimo aggiornamento:.*?\*", "*Ultimo aggiornamento: $currentDateTime*"

# Scrivi il contenuto aggiornato nel file README.md
Set-Content -Path $readmePath -Value $content

Write-Host "README.md aggiornato con successo!"
