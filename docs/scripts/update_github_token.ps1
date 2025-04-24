# Script per aggiornare il token GitHub
# BlueTrendTeam - 23 aprile 2025

$configPath = "C:\Users\Asus\BTT_Secure\github_config.json"

# Leggi la configurazione esistente
if (Test-Path $configPath) {
    $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
    $githubUser = $config.githubUser
    $repoName = $config.repoName
} else {
    $githubUser = "Start13"
    $repoName = "MQL5-Backup"
}

# Richiedi il nuovo token
Write-Host "Aggiornamento token GitHub per $githubUser/$repoName" -ForegroundColor Cyan
Write-Host "Per generare un nuovo token, vai su: https://github.com/settings/tokens" -ForegroundColor Yellow
Write-Host "Assicurati di concedere i permessi 'repo' al token" -ForegroundColor Yellow
$token = Read-Host "Inserisci il nuovo token GitHub" -AsSecureString
$tokenPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

# Crea il nuovo file di configurazione
$newConfig = @{
    githubUser = $githubUser
    repoName = $repoName
    token = $tokenPlain
} | ConvertTo-Json

# Salva il file di configurazione
Set-Content -Path $configPath -Value $newConfig -Encoding UTF8
Write-Host "Token GitHub aggiornato con successo!" -ForegroundColor Green
