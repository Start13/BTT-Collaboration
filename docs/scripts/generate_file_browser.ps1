# Script per generare un browser di file HTML per MQL5
# BlueTrendTeam - 23 aprile 2025

$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$outputPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\MQL5_Browser.html"

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Funzione per generare la struttura delle cartelle in HTML
function Get-FolderStructure {
    param (
        [string]$path,
        [string]$relativePath,
        [int]$level = 0
    )

    $indent = "    " * $level
    $html = ""
    
    # Ottieni le cartelle
    $folders = Get-ChildItem -Path $path -Directory | Sort-Object Name
    
    foreach ($folder in $folders) {
        $folderRelativePath = Join-Path $relativePath $folder.Name
        $folderDisplayName = $folder.Name
        
        # Se è una cartella AI, aggiungi la sigla neutrale
        if ($aiMappings.ContainsKey($folder.Name)) {
            $folderDisplayName = "$($folder.Name) ($($aiMappings[$folder.Name]))"
        }
        
        $html += "$indent<li class='folder'><span class='folder-name' onclick='toggleFolder(this)'>📁 $folderDisplayName</span>`n"
        $html += "$indent<ul class='folder-content' style='display:none;'>`n"
        
        # Ricorsione per le sottocartelle
        $html += Get-FolderStructure -path $folder.FullName -relativePath $folderRelativePath -level ($level + 1)
        
        # Ottieni i file nella cartella
        $files = Get-ChildItem -Path $folder.FullName -File | Where-Object { $_.Extension -in ".mqh", ".mq5" } | Sort-Object Name
        
        foreach ($file in $files) {
            $fileRelativePath = Join-Path $folderRelativePath $file.Name
            $fileUrl = "file:///$($file.FullName -replace '\\', '/')"
            $html += "$indent    <li class='file'><a href='$fileUrl' target='_blank'>📄 $($file.Name)</a></li>`n"
        }
        
        $html += "$indent</ul></li>`n"
    }
    
    return $html
}

# Crea l'HTML
$html = @"
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BlueTrendTeam - MQL5 File Browser</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            color: #333;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        .container {
            display: flex;
            gap: 20px;
        }
        .file-tree {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        .content {
            flex: 2;
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        ul {
            list-style-type: none;
            padding-left: 20px;
        }
        li {
            margin: 5px 0;
        }
        .folder-name {
            cursor: pointer;
            font-weight: bold;
            color: #2c3e50;
        }
        .folder-name:hover {
            color: #3498db;
        }
        a {
            text-decoration: none;
            color: #34495e;
        }
        a:hover {
            color: #3498db;
            text-decoration: underline;
        }
        .ai-section {
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .ai-title {
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .timestamp {
            font-size: 0.8em;
            color: #7f8c8d;
            margin-top: 20px;
            text-align: right;
        }
        .search-box {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h1>BlueTrendTeam - MQL5 File Browser</h1>
    
    <div class="container">
        <div class="file-tree">
            <input type="text" id="searchBox" class="search-box" placeholder="Cerca file..." onkeyup="searchFiles()">
            
            <h2>Include</h2>
            <ul id="includeTree">
                $(Get-FolderStructure -path "$mql5Path\Include" -relativePath "Include")
            </ul>
            
            <h2>Experts</h2>
            <ul id="expertsTree">
                $(Get-FolderStructure -path "$mql5Path\Experts" -relativePath "Experts")
            </ul>
            
            <h2>Scripts</h2>
            <ul id="scriptsTree">
                $(Get-FolderStructure -path "$mql5Path\Scripts" -relativePath "Scripts")
            </ul>
            
            <h2>Indicators</h2>
            <ul id="indicatorsTree">
                $(Get-FolderStructure -path "$mql5Path\Indicators" -relativePath "Indicators")
            </ul>
        </div>
        
        <div class="content">
            <h2>Guida alla navigazione</h2>
            <p>Benvenuto nel browser di file MQL5 di BlueTrendTeam!</p>
            <p>Questo strumento ti permette di navigare facilmente tra i file di tutte le AI del progetto.</p>
            
            <h3>Come utilizzare questo browser:</h3>
            <ul>
                <li>Clicca sulle cartelle (📁) per espanderle o comprimerle</li>
                <li>Clicca sui file (📄) per aprirli nel tuo editor predefinito</li>
                <li>Usa la casella di ricerca per trovare rapidamente file specifici</li>
            </ul>
            
            <h3>Struttura delle cartelle AI:</h3>
            <div class="ai-section">
                <div class="ai-title">AIWindsurf (AlgoWi)</div>
                <p>Implementazione originale di molti componenti di OmniEA</p>
            </div>
            
            <div class="ai-section">
                <div class="ai-title">AIChatGpt (AlgoCh)</div>
                <p>Implementazione di ChatGPT con focus su ottimizzazione e interfaccia utente</p>
            </div>
            
            <div class="ai-section">
                <div class="ai-title">AIGemini (AlgoGe)</div>
                <p>Implementazione di Gemini con focus su algoritmi avanzati</p>
            </div>
            
            <div class="ai-section">
                <div class="ai-title">AIGrok (AlgoGr)</div>
                <p>Implementazione di Grok con focus su analisi dei dati</p>
            </div>
            
            <div class="ai-section">
                <div class="ai-title">AIDeepSeek (AlgoDs)</div>
                <p>Implementazione di DeepSeek con focus su deep learning</p>
            </div>
        </div>
    </div>
    
    <div class="timestamp">
        Generato il: $(Get-Date -Format "dd MMMM yyyy, HH:mm")
    </div>
    
    <script>
        function toggleFolder(element) {
            var content = element.nextElementSibling;
            if (content.style.display === "none") {
                content.style.display = "block";
            } else {
                content.style.display = "none";
            }
        }
        
        function searchFiles() {
            var input = document.getElementById('searchBox');
            var filter = input.value.toUpperCase();
            var fileElements = document.getElementsByClassName('file');
            var folderElements = document.getElementsByClassName('folder');
            
            // Reset all folders to closed
            for (var i = 0; i < folderElements.length; i++) {
                var folderContent = folderElements[i].getElementsByClassName('folder-content')[0];
                if (filter === '') {
                    folderContent.style.display = 'none';
                }
            }
            
            // Search through files
            for (var i = 0; i < fileElements.length; i++) {
                var a = fileElements[i].getElementsByTagName('a')[0];
                var txtValue = a.textContent || a.innerText;
                
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    fileElements[i].style.display = '';
                    // Open all parent folders
                    var parent = fileElements[i].parentElement;
                    while (parent && parent.classList.contains('folder-content')) {
                        parent.style.display = 'block';
                        parent = parent.parentElement.parentElement;
                    }
                } else {
                    if (filter !== '') {
                        fileElements[i].style.display = 'none';
                    } else {
                        fileElements[i].style.display = '';
                    }
                }
            }
        }
    </script>
</body>
</html>
"@

# Salva l'HTML
Set-Content -Path $outputPath -Value $html -Encoding UTF8

Write-Host "Browser di file MQL5 generato con successo in: $outputPath" -ForegroundColor Green
Write-Host "Apertura del browser..." -ForegroundColor Cyan

# Apri il browser
Start-Process $outputPath
