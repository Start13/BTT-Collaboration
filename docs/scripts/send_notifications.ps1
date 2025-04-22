# Script per inviare notifiche dopo il backup
# Versione 1.0 - 22 aprile 2025

# Configurazione
$configPath = "C:\Users\Asus\BTT_Secure\notification_config.json"
$readmePath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BBTT\docs\README.md"

# Funzione per caricare la configurazione
function Get-NotificationConfiguration {
    if (Test-Path $configPath) {
        try {
            $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
            return $config
        }
        catch {
            Write-Host "Errore durante il caricamento della configurazione: $_" -ForegroundColor Red
            return $null
        }
    }
    else {
        Write-Host "File di configurazione non trovato: $configPath" -ForegroundColor Red
        return $null
    }
}

# Funzione per inviare email
function Send-EmailNotification {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Subject,
        
        [Parameter(Mandatory=$true)]
        [string]$Body,
        
        [Parameter(Mandatory=$true)]
        $Config
    )
    
    try {
        $smtpServer = $Config.email.smtp_server
        $smtpPort = $Config.email.smtp_port
        $senderEmail = $Config.email.sender_email
        $senderPassword = $Config.email.sender_password
        $recipientEmail = $Config.email.recipient_email
        
        $securePassword = ConvertTo-SecureString $senderPassword -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential($senderEmail, $securePassword)
        
        Send-MailMessage -From $senderEmail -To $recipientEmail -Subject $Subject -Body $Body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential -BodyAsHtml
        
        Write-Host "Email inviata con successo a $recipientEmail" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Errore durante l'invio dell'email: $_" -ForegroundColor Red
        return $false
    }
}

# Funzione per inviare messaggio Telegram
function Send-TelegramNotification {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        $Config
    )
    
    try {
        $botToken = $Config.telegram.bot_token
        $chatId = $Config.telegram.chat_id
        
        $uri = "https://api.telegram.org/bot$botToken/sendMessage"
        $body = @{
            chat_id = $chatId
            text = $Message
            parse_mode = "HTML"
        }
        
        Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body ($body | ConvertTo-Json)
        
        Write-Host "Messaggio Telegram inviato con successo" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Errore durante l'invio del messaggio Telegram: $_" -ForegroundColor Red
        return $false
    }
}

# Funzione per ottenere informazioni sul progetto
function Get-ProjectInfo {
    $readmeContent = ""
    $currentDateTime = Get-Date -Format "dd MMMM yyyy, HH:mm"
    
    if (Test-Path $readmePath) {
        $readmeContent = Get-Content -Path $readmePath -Raw
    }
    
    # Estrai informazioni rilevanti
    $statoAttuale = ""
    $prossimaAttivita = ""
    
    if ($readmeContent -match "Stato attuale\*\*:\s*(.*?)[\r\n]") {
        $statoAttuale = $matches[1]
    }
    
    if ($readmeContent -match "Prossima attività\*\*:\s*(.*?)[\r\n]") {
        $prossimaAttivita = $matches[1]
    }
    
    return @{
        DataOra = $currentDateTime
        StatoAttuale = $statoAttuale
        ProssimaAttivita = $prossimaAttivita
        ReadmePath = $readmePath
    }
}

# Funzione per creare il contenuto della notifica
function New-NotificationContent {
    param (
        [Parameter(Mandatory=$true)]
        $ProjectInfo
    )
    
    $emailSubject = "BlueTrendTeam - Backup Completato - $($ProjectInfo.DataOra)"
    
    $emailBody = @"
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        h1 { color: #0066cc; }
        h2 { color: #0099ff; }
        .info { background-color: #f0f8ff; padding: 15px; border-left: 5px solid #0066cc; margin-bottom: 20px; }
        .instructions { background-color: #f5f5f5; padding: 15px; border-left: 5px solid #666; }
        .important { color: #cc0000; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>BlueTrendTeam - Backup Completato</h1>
        <div class="info">
            <p><strong>Data e ora:</strong> $($ProjectInfo.DataOra)</p>
            <p><strong>Stato attuale:</strong> $($ProjectInfo.StatoAttuale)</p>
            <p><strong>Prossima attività:</strong> $($ProjectInfo.ProssimaAttivita)</p>
        </div>
        
        <h2>Istruzioni per Continuare il Lavoro</h2>
        <div class="instructions">
            <p><strong>Per iniziare una nuova chat:</strong></p>
            <ol>
                <li>Carica il file README.md nella nuova chat:<br>
                <code>$($ProjectInfo.ReadmePath)</code></li>
                <li>Segui le istruzioni nel README per continuare il lavoro</li>
            </ol>
            
            <p><strong>Se continui con un'altra AI:</strong></p>
            <ol>
                <li>Carica lo stesso file README.md nella nuova chat</li>
                <li>L'AI troverà tutte le istruzioni necessarie nel README</li>
                <li>Assicurati che la nuova AI esegua i backup automatici</li>
            </ol>
            
            <p><strong>Se AI Windsurf finisce i token:</strong></p>
            <ol>
                <li>La supervisione passa ad un'altra AI oppure</li>
                <li>Procedi senza supervisione, seguendo le Regole Fondamentali</li>
            </ol>
            
            <p class="important">IMPORTANTE: Tutti i file sono stati salvati in modo sicuro su GitHub. In caso di problemi, puoi accedere ai repository:</p>
            <ul>
                <li>BTT-Collaboration: <a href="https://github.com/Start13/BTT-Collaboration">https://github.com/Start13/BTT-Collaboration</a></li>
                <li>MQL5-Backup: <a href="https://github.com/Start13/MQL5-Backup">https://github.com/Start13/MQL5-Backup</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
"@
    
    $telegramMessage = @"
<b>BlueTrendTeam - Backup Completato</b>

📅 <b>Data e ora:</b> $($ProjectInfo.DataOra)
📊 <b>Stato attuale:</b> $($ProjectInfo.StatoAttuale)
🔜 <b>Prossima attività:</b> $($ProjectInfo.ProssimaAttivita)

<b>Istruzioni per Continuare il Lavoro:</b>

<b>Per iniziare una nuova chat:</b>
1. Carica il file README.md nella nuova chat
2. Segui le istruzioni nel README

<b>Se continui con un'altra AI:</b>
1. Carica lo stesso file README.md
2. L'AI troverà tutte le istruzioni necessarie

<b>Se AI Windsurf finisce i token:</b>
1. La supervisione passa ad un'altra AI oppure
2. Procedi senza supervisione

<b>IMPORTANTE:</b> Tutti i file sono stati salvati in modo sicuro su GitHub.
"@
    
    return @{
        EmailSubject = $emailSubject
        EmailBody = $emailBody
        TelegramMessage = $telegramMessage
    }
}

# Funzione principale
function Send-BackupNotifications {
    Write-Host "=== Invio notifiche dopo il backup ===" -ForegroundColor Cyan
    
    # Carica la configurazione
    $config = Get-NotificationConfiguration
    if ($null -eq $config) {
        Write-Host "Impossibile inviare notifiche: configurazione non valida" -ForegroundColor Red
        return
    }
    
    # Ottieni informazioni sul progetto
    $projectInfo = Get-ProjectInfo
    
    # Crea il contenuto della notifica
    $notificationContent = New-NotificationContent -ProjectInfo $projectInfo
    
    # Invia email
    $emailSent = Send-EmailNotification -Subject $notificationContent.EmailSubject -Body $notificationContent.EmailBody -Config $config
    
    # Invia messaggio Telegram
    $telegramSent = Send-TelegramNotification -Message $notificationContent.TelegramMessage -Config $config
    
    if ($emailSent -or $telegramSent) {
        Write-Host "Notifiche inviate con successo!" -ForegroundColor Green
    }
    else {
        Write-Host "Errore durante l'invio delle notifiche" -ForegroundColor Red
    }
}

# Esecuzione principale
try {
    Send-BackupNotifications
}
catch {
    Write-Host "Errore durante l'invio delle notifiche: $_" -ForegroundColor Red
}
