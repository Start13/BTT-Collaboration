# Script per creare una dashboard interattiva per BlueTrendTeam
# BlueTrendTeam - 23 aprile 2025

$dashboardPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\BTT_Dashboard.html"
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$scriptPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\docs\scripts"

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Crea il server web locale
$serverScript = @"
# Crea un server web locale per la dashboard
Add-Type -AssemblyName System.Web

# Crea un listener HTTP
`$listener = New-Object System.Net.HttpListener
`$listener.Prefixes.Add('http://localhost:8080/')
`$listener.Start()

Write-Host "Server avviato su http://localhost:8080/"
Write-Host "Premi CTRL+C per terminare il server"

# Funzione per avviare la sincronizzazione GitHub
function Start-GitHubSync {
    `$syncScript = "$scriptPath\auto_sync_github.ps1"
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"`$syncScript`"" -PassThru
}

# Funzione per fermare la sincronizzazione GitHub
function Stop-GitHubSync {
    Stop-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { `$_.CommandLine -like "*auto_sync_github.ps1*" }
}

# Funzione per aggiornare l'indice dei file
function Update-FileIndex {
    `$mql5Path = "$mql5Path"
    
    # Ottieni la struttura dei file
    `$fileStructure = @{}
    
    # Funzione per aggiungere i file di una cartella alla struttura
    function Get-FileStructure {
        param (
            [string]`$basePath,
            [string]`$section
        )
        
        `$result = @{}
        
        if (Test-Path `$basePath) {
            # Ottieni le cartelle AI
            `$aiDirs = Get-ChildItem -Path `$basePath -Directory | Where-Object { `$_.Name -like "AI*" } | Sort-Object Name
            
            foreach (`$aiDir in `$aiDirs) {
                `$aiName = `$aiDir.Name
                `$files = @()
                
                # Ottieni tutti i file MQL5 ricorsivamente
                `$mqlFiles = Get-ChildItem -Path `$aiDir.FullName -Recurse -Include "*.mqh", "*.mq5" | Sort-Object FullName
                
                foreach (`$file in `$mqlFiles) {
                    `$relativePath = `$file.FullName.Substring(`$mql5Path.Length + 1)
                    `$fileUrl = "file:///`$(`$file.FullName -replace '\\', '/')"
                    `$files += @{
                        "path" = `$relativePath
                        "url" = `$fileUrl
                        "name" = `$file.Name
                        "lastModified" = `$file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                    }
                }
                
                `$result[`$aiName] = `$files
            }
        }
        
        return `$result
    }
    
    `$fileStructure["Include"] = Get-FileStructure -basePath "`$mql5Path\Include" -section "Include"
    `$fileStructure["Experts"] = Get-FileStructure -basePath "`$mql5Path\Experts" -section "Experts"
    `$fileStructure["Scripts"] = Get-FileStructure -basePath "`$mql5Path\Scripts" -section "Scripts"
    `$fileStructure["Indicators"] = Get-FileStructure -basePath "`$mql5Path\Indicators" -section "Indicators"
    
    return `$fileStructure | ConvertTo-Json -Depth 10
}

# Gestisci le richieste HTTP
try {
    while (`$listener.IsListening) {
        `$context = `$listener.GetContext()
        `$request = `$context.Request
        `$response = `$context.Response
        
        # Imposta il content type predefinito
        `$response.ContentType = 'text/html'
        
        # Gestisci le diverse richieste
        switch (`$request.Url.LocalPath) {
            "/" {
                # Pagina principale
                `$content = Get-Content "$dashboardPath" -Raw
                `$buffer = [System.Text.Encoding]::UTF8.GetBytes(`$content)
                `$response.ContentLength64 = `$buffer.Length
                `$response.OutputStream.Write(`$buffer, 0, `$buffer.Length)
            }
            "/api/files" {
                # API per ottenere la struttura dei file
                `$response.ContentType = 'application/json'
                `$content = Update-FileIndex
                `$buffer = [System.Text.Encoding]::UTF8.GetBytes(`$content)
                `$response.ContentLength64 = `$buffer.Length
                `$response.OutputStream.Write(`$buffer, 0, `$buffer.Length)
            }
            "/api/sync/start" {
                # API per avviare la sincronizzazione
                `$response.ContentType = 'application/json'
                Start-GitHubSync
                `$content = '{"status":"started"}'
                `$buffer = [System.Text.Encoding]::UTF8.GetBytes(`$content)
                `$response.ContentLength64 = `$buffer.Length
                `$response.OutputStream.Write(`$buffer, 0, `$buffer.Length)
            }
            "/api/sync/stop" {
                # API per fermare la sincronizzazione
                `$response.ContentType = 'application/json'
                Stop-GitHubSync
                `$content = '{"status":"stopped"}'
                `$buffer = [System.Text.Encoding]::UTF8.GetBytes(`$content)
                `$response.ContentLength64 = `$buffer.Length
                `$response.OutputStream.Write(`$buffer, 0, `$buffer.Length)
            }
            default {
                # 404 Not Found
                `$response.StatusCode = 404
                `$content = "404 - Not Found"
                `$buffer = [System.Text.Encoding]::UTF8.GetBytes(`$content)
                `$response.ContentLength64 = `$buffer.Length
                `$response.OutputStream.Write(`$buffer, 0, `$buffer.Length)
            }
        }
        
        # Chiudi lo stream
        `$response.OutputStream.Close()
    }
}
finally {
    # Ferma il listener
    `$listener.Stop()
}
"@

# Salva lo script del server
$serverScriptPath = "$scriptPath\btt_dashboard_server.ps1"
Set-Content -Path $serverScriptPath -Value $serverScript -Encoding UTF8

# Crea l'HTML della dashboard
$html = @"
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BlueTrendTeam Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        h1 {
            margin: 0;
            font-size: 24px;
        }
        .controls {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        .btn-success {
            background-color: #2ecc71;
            color: white;
        }
        .btn-success:hover {
            background-color: #27ae60;
        }
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .status {
            margin-left: 10px;
            font-size: 14px;
        }
        .status-on {
            color: #2ecc71;
        }
        .status-off {
            color: #e74c3c;
        }
        .content {
            display: flex;
            margin-top: 20px;
        }
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px;
            margin-right: 20px;
        }
        .main {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px;
        }
        .search-box {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .section {
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
            cursor: pointer;
        }
        .section-title:hover {
            color: #3498db;
        }
        .ai-group {
            margin-left: 15px;
            margin-bottom: 15px;
        }
        .ai-title {
            font-size: 16px;
            font-weight: bold;
            color: #34495e;
            margin-bottom: 5px;
            cursor: pointer;
        }
        .ai-title:hover {
            color: #3498db;
        }
        .file-list {
            margin-left: 15px;
            display: none;
        }
        .file-item {
            margin: 5px 0;
        }
        .file-link {
            text-decoration: none;
            color: #34495e;
        }
        .file-link:hover {
            color: #3498db;
            text-decoration: underline;
        }
        .timestamp {
            font-size: 0.8em;
            color: #7f8c8d;
            margin-top: 20px;
            text-align: right;
        }
        .welcome {
            padding: 20px;
            line-height: 1.6;
        }
        .welcome h2 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-top: 0;
        }
        .welcome ul {
            margin-left: 20px;
        }
        .welcome li {
            margin-bottom: 10px;
        }
        .loader {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 2s linear infinite;
            display: inline-block;
            vertical-align: middle;
            margin-right: 10px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <header>
        <h1>BlueTrendTeam Dashboard</h1>
        <div class="controls">
            <button id="syncButton" class="btn btn-primary" onclick="toggleSync()">Avvia Sincronizzazione</button>
            <button id="refreshButton" class="btn btn-success" onclick="refreshFiles()">Aggiorna Indice</button>
            <span id="syncStatus" class="status status-off">Sync: OFF</span>
            <div id="loader" class="loader hidden"></div>
        </div>
    </header>
    
    <div class="container">
        <div class="content">
            <div class="sidebar">
                <input type="text" id="searchInput" class="search-box" placeholder="Cerca file..." onkeyup="searchFiles()">
                
                <div class="section">
                    <div class="section-title" onclick="toggleSection('includeSection')">Include</div>
                    <div id="includeSection" class="section-content"></div>
                </div>
                
                <div class="section">
                    <div class="section-title" onclick="toggleSection('expertsSection')">Experts</div>
                    <div id="expertsSection" class="section-content"></div>
                </div>
                
                <div class="section">
                    <div class="section-title" onclick="toggleSection('scriptsSection')">Scripts</div>
                    <div id="scriptsSection" class="section-content"></div>
                </div>
                
                <div class="section">
                    <div class="section-title" onclick="toggleSection('indicatorsSection')">Indicators</div>
                    <div id="indicatorsSection" class="section-content"></div>
                </div>
            </div>
            
            <div class="main">
                <div class="welcome">
                    <h2>Benvenuto nella Dashboard BlueTrendTeam</h2>
                    <p>Questa dashboard ti permette di gestire facilmente la collaborazione tra AI nel progetto BlueTrendTeam.</p>
                    
                    <h3>Funzionalità principali:</h3>
                    <ul>
                        <li><strong>Sincronizzazione GitHub</strong> - Avvia/ferma la sincronizzazione automatica con GitHub ogni 5 minuti</li>
                        <li><strong>Indice dei file</strong> - Naviga tra tutti i file MQL5 di tutte le AI</li>
                        <li><strong>Ricerca rapida</strong> - Trova rapidamente file specifici</li>
                    </ul>
                    
                    <h3>Come utilizzare la dashboard:</h3>
                    <ul>
                        <li>Clicca su <strong>Avvia Sincronizzazione</strong> per iniziare a sincronizzare i file con GitHub</li>
                        <li>Clicca su <strong>Aggiorna Indice</strong> per aggiornare l'elenco dei file</li>
                        <li>Usa la <strong>casella di ricerca</strong> per trovare file specifici</li>
                        <li>Clicca sulle <strong>sezioni</strong> e sulle <strong>AI</strong> per espandere/comprimere l'elenco dei file</li>
                        <li>Clicca sui <strong>file</strong> per aprirli nel tuo editor predefinito</li>
                    </ul>
                </div>
                
                <div class="timestamp">
                    Ultimo aggiornamento: <span id="lastUpdate"></span>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let syncActive = false;
        let fileData = {};
        
        // Inizializza la dashboard
        document.addEventListener('DOMContentLoaded', function() {
            refreshFiles();
            updateTimestamp();
        });
        
        // Aggiorna l'indice dei file
        function refreshFiles() {
            showLoader();
            fetch('/api/files')
                .then(response => response.json())
                .then(data => {
                    fileData = data;
                    renderFileStructure();
                    updateTimestamp();
                    hideLoader();
                })
                .catch(error => {
                    console.error('Errore nel caricamento dei file:', error);
                    hideLoader();
                });
        }
        
        // Renderizza la struttura dei file
        function renderFileStructure() {
            renderSection('Include', 'includeSection');
            renderSection('Experts', 'expertsSection');
            renderSection('Scripts', 'scriptsSection');
            renderSection('Indicators', 'indicatorsSection');
        }
        
        // Renderizza una sezione
        function renderSection(section, elementId) {
            const sectionElement = document.getElementById(elementId);
            sectionElement.innerHTML = '';
            
            const sectionData = fileData[section];
            if (!sectionData) return;
            
            for (const aiName in sectionData) {
                const files = sectionData[aiName];
                if (files.length === 0) continue;
                
                // Ottieni la sigla neutrale
                let algoName = '';
                if (aiName === 'AIWindsurf') algoName = 'AlgoWi';
                else if (aiName === 'AIChatGpt') algoName = 'AlgoCh';
                else if (aiName === 'AIGemini') algoName = 'AlgoGe';
                else if (aiName === 'AIGrok') algoName = 'AlgoGr';
                else if (aiName === 'AIDeepSeek') algoName = 'AlgoDs';
                
                // Crea il gruppo AI
                const aiGroup = document.createElement('div');
                aiGroup.className = 'ai-group';
                
                const aiTitle = document.createElement('div');
                aiTitle.className = 'ai-title';
                aiTitle.textContent = aiName + (algoName ? ` (${algoName})` : '');
                aiTitle.onclick = function() { toggleAI(aiName + section); };
                aiGroup.appendChild(aiTitle);
                
                const fileList = document.createElement('div');
                fileList.className = 'file-list';
                fileList.id = aiName + section;
                
                // Aggiungi i file
                files.forEach(file => {
                    const fileItem = document.createElement('div');
                    fileItem.className = 'file-item';
                    
                    const fileLink = document.createElement('a');
                    fileLink.className = 'file-link';
                    fileLink.href = file.url;
                    fileLink.textContent = file.path;
                    fileLink.setAttribute('target', '_blank');
                    
                    fileItem.appendChild(fileLink);
                    fileList.appendChild(fileItem);
                });
                
                aiGroup.appendChild(fileList);
                sectionElement.appendChild(aiGroup);
            }
        }
        
        // Mostra/nascondi una sezione
        function toggleSection(sectionId) {
            const section = document.getElementById(sectionId);
            const display = section.style.display;
            section.style.display = display === 'none' || display === '' ? 'block' : 'none';
        }
        
        // Mostra/nascondi un gruppo AI
        function toggleAI(aiId) {
            const aiFiles = document.getElementById(aiId);
            const display = aiFiles.style.display;
            aiFiles.style.display = display === 'none' || display === '' ? 'block' : 'none';
        }
        
        // Cerca file
        function searchFiles() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const fileItems = document.getElementsByClassName('file-item');
            
            for (let i = 0; i < fileItems.length; i++) {
                const fileLink = fileItems[i].getElementsByClassName('file-link')[0];
                const fileName = fileLink.textContent.toLowerCase();
                
                if (fileName.includes(searchText)) {
                    fileItems[i].style.display = '';
                    
                    // Mostra il gruppo AI e la sezione
                    let parent = fileItems[i].parentElement;
                    while (parent) {
                        parent.style.display = 'block';
                        parent = parent.parentElement;
                        if (parent && parent.className === 'section-content') {
                            break;
                        }
                    }
                } else {
                    fileItems[i].style.display = 'none';
                }
            }
        }
        
        // Avvia/ferma la sincronizzazione
        function toggleSync() {
            const syncButton = document.getElementById('syncButton');
            const syncStatus = document.getElementById('syncStatus');
            
            showLoader();
            
            if (syncActive) {
                // Ferma la sincronizzazione
                fetch('/api/sync/stop')
                    .then(response => response.json())
                    .then(data => {
                        syncActive = false;
                        syncButton.textContent = 'Avvia Sincronizzazione';
                        syncButton.className = 'btn btn-primary';
                        syncStatus.textContent = 'Sync: OFF';
                        syncStatus.className = 'status status-off';
                        hideLoader();
                    })
                    .catch(error => {
                        console.error('Errore nell\'arresto della sincronizzazione:', error);
                        hideLoader();
                    });
            } else {
                // Avvia la sincronizzazione
                fetch('/api/sync/start')
                    .then(response => response.json())
                    .then(data => {
                        syncActive = true;
                        syncButton.textContent = 'Ferma Sincronizzazione';
                        syncButton.className = 'btn btn-danger';
                        syncStatus.textContent = 'Sync: ON';
                        syncStatus.className = 'status status-on';
                        hideLoader();
                    })
                    .catch(error => {
                        console.error('Errore nell\'avvio della sincronizzazione:', error);
                        hideLoader();
                    });
            }
        }
        
        // Aggiorna il timestamp
        function updateTimestamp() {
            const now = new Date();
            const options = { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            document.getElementById('lastUpdate').textContent = now.toLocaleDateString('it-IT', options);
        }
        
        // Mostra il loader
        function showLoader() {
            document.getElementById('loader').classList.remove('hidden');
        }
        
        // Nascondi il loader
        function hideLoader() {
            document.getElementById('loader').classList.add('hidden');
        }
    </script>
</body>
</html>
"@

# Salva l'HTML della dashboard
Set-Content -Path $dashboardPath -Value $html -Encoding UTF8

# Crea lo script di avvio
$startScript = @"
@echo off
echo Avvio della Dashboard BlueTrendTeam...
start http://localhost:8080/
powershell -ExecutionPolicy Bypass -File "$serverScriptPath"
"@

# Salva lo script di avvio
$startScriptPath = "$scriptPath\start_btt_dashboard.bat"
Set-Content -Path $startScriptPath -Value $startScript -Encoding UTF8

# Crea il collegamento sul desktop
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut([System.Environment]::GetFolderPath("Desktop") + "\BlueTrendTeam Dashboard.lnk")
$Shortcut.TargetPath = $startScriptPath
$Shortcut.Description = "Avvia la dashboard BlueTrendTeam"
$Shortcut.WorkingDirectory = Split-Path $startScriptPath -Parent
$Shortcut.IconLocation = "C:\Windows\System32\SHELL32.dll,18"
$Shortcut.Save()

Write-Host "Dashboard BlueTrendTeam creata con successo!" -ForegroundColor Green
Write-Host "Un collegamento è stato creato sul desktop." -ForegroundColor Cyan
Write-Host "Avvio della dashboard..." -ForegroundColor Yellow

# Avvia la dashboard
Start-Process $startScriptPath
