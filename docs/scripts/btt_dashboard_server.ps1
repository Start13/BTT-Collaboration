# Crea un server web locale per la dashboard
Add-Type -AssemblyName System.Web

# Crea un listener HTTP
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8080/')
$listener.Start()

Write-Host "Server avviato su http://localhost:8080/"
Write-Host "Premi CTRL+C per terminare il server"
Write-Host "NOTA: Il server si chiuderà automaticamente quando chiudi la finestra del browser"

# Variabile per tracciare l'ultima attività
$lastActivity = Get-Date
$inactivityTimeout = 300 # 5 minuti di inattività prima di chiudere

# Funzione per avviare la sincronizzazione GitHub
function Start-GitHubSync {
    $syncScript = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts\auto_sync_github.ps1"
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$syncScript`"" -PassThru
}

# Avvia la sincronizzazione GitHub all'avvio del server
Write-Host "Avvio della sincronizzazione GitHub..."
Start-GitHubSync

# Funzione per fermare la sincronizzazione GitHub
function Stop-GitHubSync {
    Stop-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*auto_sync_github.ps1*" }
}

# Funzione per aggiornare l'indice dei file
function Update-FileIndex {
    $mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
    
    # Ottieni la struttura dei file
    $fileStructure = @{}
    
    # Funzione per aggiungere i file di una cartella alla struttura
    function Get-FileStructure {
        param (
            [string]$basePath,
            [string]$section
        )
        
        $result = @{}
        
        if (Test-Path $basePath) {
            # Ottieni le cartelle AI
            $aiDirs = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -like "AI*" } | Sort-Object Name
            
            foreach ($aiDir in $aiDirs) {
                $aiName = $aiDir.Name
                $files = @()
                
                # Ottieni tutti i file MQL5 ricorsivamente
                $mqlFiles = Get-ChildItem -Path $aiDir.FullName -Recurse -Include "*.mqh", "*.mq5", "*.ex5", "*.txt", "*.md", "*.csv", "*.json", "*.xml", "*.html", "*.js", "*.css", "*.h", "*.c", "*.cpp" | Sort-Object FullName
                
                foreach ($file in $mqlFiles) {
                    $relativePath = $file.FullName.Substring($mql5Path.Length + 1)
                    $fileUrl = "file:///$($file.FullName -replace '\\', '/')"
                    $files += @{
                        "path" = $relativePath
                        "url" = $fileUrl
                        "name" = $file.Name
                        "lastModified" = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                    }
                }
                
                $result[$aiName] = $files
            }
        }
        
        return $result
    }
    
    $fileStructure["Include"] = Get-FileStructure -basePath "$mql5Path\Include" -section "Include"
    $fileStructure["Experts"] = Get-FileStructure -basePath "$mql5Path\Experts" -section "Experts"
    $fileStructure["Scripts"] = Get-FileStructure -basePath "$mql5Path\Scripts" -section "Scripts"
    $fileStructure["Indicators"] = Get-FileStructure -basePath "$mql5Path\Indicators" -section "Indicators"
    
    return $fileStructure | ConvertTo-Json -Depth 10
}

# Gestisci le richieste HTTP
try {
    # Avvia un job in background per monitorare l'inattività
    $job = Start-Job -ScriptBlock {
        param($timeout)
        $start = Get-Date
        while ((Get-Date) - $start -lt [TimeSpan]::FromSeconds($timeout)) {
            Start-Sleep -Seconds 10
        }
    } -ArgumentList 30 # Controlla ogni 30 secondi
    
    while ($listener.IsListening) {
        # Imposta un timeout per GetContext per permettere di controllare l'inattività
        $result = $listener.BeginGetContext($null, $null)
        $completed = $result.AsyncWaitHandle.WaitOne(10000) # 10 secondi timeout
        
        if ($completed) {
            $context = $listener.EndGetContext($result)
            $request = $context.Request
            $response = $context.Response
            
            # Aggiorna il timestamp dell'ultima attività
            $lastActivity = Get-Date
            
            # Imposta il content type predefinito
            $response.ContentType = 'text/html'
            
            # Gestisci le diverse richieste
            switch ($request.Url.LocalPath) {
                "/" {
                    # Pagina principale
                    $content = Get-Content "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BTT_Dashboard.html" -Raw
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/files" {
                    # API per ottenere la struttura dei file
                    $response.ContentType = 'application/json'
                    $content = Update-FileIndex
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/sync/start" {
                    # API per avviare la sincronizzazione
                    $response.ContentType = 'application/json'
                    Start-GitHubSync
                    $content = '{"status":"started"}'
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/sync/stop" {
                    # API per fermare la sincronizzazione
                    $response.ContentType = 'application/json'
                    Stop-GitHubSync
                    $content = '{"status":"stopped"}'
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/file/content" {
                    # API per ottenere il contenuto di un file
                    $response.ContentType = 'text/plain; charset=utf-8'
                    
                    # Ottieni il percorso del file dalla query string
                    $filePath = $request.QueryString["path"]
                    
                    if ($filePath -and (Test-Path $filePath)) {
                        try {
                            # Leggi il contenuto del file
                            $content = Get-Content -Path $filePath -Raw -Encoding UTF8
                            
                            # Se il file non ha contenuto, restituisci un messaggio
                            if ([string]::IsNullOrEmpty($content)) {
                                $content = "Il file è vuoto."
                            }
                        }
                        catch {
                            $content = "Errore nella lettura del file: $_"
                        }
                    }
                    else {
                        $content = "File non trovato o percorso non specificato."
                    }
                    
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                "/api/file/open" {
                    # API per aprire un file nell'editor predefinito
                    $response.ContentType = 'text/plain'
                    
                    # Ottieni il percorso del file dalla query string
                    $filePath = $request.QueryString["path"]
                    
                    if ($filePath -and (Test-Path $filePath)) {
                        try {
                            # Apri il file nell'editor predefinito
                            Start-Process $filePath
                            $content = "File aperto con successo: $filePath"
                        }
                        catch {
                            $content = "Errore nell'apertura del file: $_"
                        }
                    }
                    else {
                        $content = "File non trovato o percorso non specificato."
                    }
                    
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
                default {
                    # 404 Not Found
                    $response.StatusCode = 404
                    $content = "404 - Not Found"
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
                    $response.ContentLength64 = $buffer.Length
                    $response.OutputStream.Write($buffer, 0, $buffer.Length)
                }
            }
            
            # Chiudi lo stream
            $response.OutputStream.Close()
        }
        else {
            # Controlla l'inattività
            $inactivityTime = (Get-Date) - $lastActivity
            if ($inactivityTime.TotalSeconds -gt $inactivityTimeout) {
                Write-Host "Nessuna attività rilevata per $($inactivityTime.TotalMinutes) minuti. Chiusura del server..."
                break
            }
        }
    }
}
finally {
    # Ferma la sincronizzazione GitHub se attiva
    Stop-GitHubSync
    
    # Ferma il listener
    $listener.Stop()
    Write-Host "Server terminato."
    
    # Chiudi eventuali job in background
    Stop-Job -Job $job -ErrorAction SilentlyContinue
    Remove-Job -Job $job -ErrorAction SilentlyContinue
}
