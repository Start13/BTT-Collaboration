# Script per creare un indice HTML dei file MQL5
# BlueTrendTeam - 23 aprile 2025

$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"
$outputPath = "C:\Users\Asus\CascadeProjects\BlueTrendTeam\MQL5_Index.html"

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Inizio dell'HTML
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>BlueTrendTeam - MQL5 File Index</title>
    <meta charset="UTF-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; }
        h2 { color: #3498db; margin-top: 30px; }
        h3 { color: #2c3e50; margin-top: 20px; }
        .file-list { margin-left: 20px; }
        .file { margin: 5px 0; }
        a { text-decoration: none; color: #34495e; }
        a:hover { text-decoration: underline; color: #3498db; }
        .search { margin: 20px 0; }
        #searchInput { padding: 8px; width: 300px; }
        .timestamp { font-size: 0.8em; color: #7f8c8d; margin-top: 20px; }
    </style>
</head>
<body>
    <h1>BlueTrendTeam - MQL5 File Index</h1>
    
    <div class="search">
        <input type="text" id="searchInput" placeholder="Cerca file..." onkeyup="searchFiles()">
    </div>
    
"@

# Funzione per aggiungere i file di una cartella all'HTML
function Add-FilesToHtml {
    param (
        [string]$path,
        [string]$title
    )
    
    if (Test-Path $path) {
        $html = "<h2>$title</h2>`n"
        
        # Ottieni le cartelle AI
        $aiDirs = Get-ChildItem -Path $path -Directory | Where-Object { $_.Name -like "AI*" } | Sort-Object Name
        
        foreach ($aiDir in $aiDirs) {
            $aiName = $aiDir.Name
            $algoName = $aiMappings[$aiName]
            
            $html += "<h3>$aiName"
            if ($algoName) {
                $html += " ($algoName)"
            }
            $html += "</h3>`n<div class='file-list'>`n"
            
            # Ottieni tutti i file MQL5 ricorsivamente
            $files = Get-ChildItem -Path $aiDir.FullName -Recurse -Include "*.mqh", "*.mq5" | Sort-Object FullName
            
            foreach ($file in $files) {
                $relativePath = $file.FullName.Substring($mql5Path.Length + 1)
                $fileUrl = "file:///$($file.FullName -replace '\\', '/')"
                $html += "<div class='file'><a href='$fileUrl' target='_blank'>$relativePath</a></div>`n"
            }
            
            $html += "</div>`n"
        }
        
        return $html
    }
    
    return ""
}

# Aggiungi le sezioni per Include, Experts, Scripts e Indicators
$html += Add-FilesToHtml -path "$mql5Path\Include" -title "Include"
$html += Add-FilesToHtml -path "$mql5Path\Experts" -title "Experts"
$html += Add-FilesToHtml -path "$mql5Path\Scripts" -title "Scripts"
$html += Add-FilesToHtml -path "$mql5Path\Indicators" -title "Indicators"

# Fine dell'HTML
$html += @"
    <div class="timestamp">
        Generato il: $(Get-Date -Format "dd MMMM yyyy, HH:mm")
    </div>
    
    <script>
        function searchFiles() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toUpperCase();
            var files = document.getElementsByClassName('file');
            
            for (var i = 0; i < files.length; i++) {
                var a = files[i].getElementsByTagName('a')[0];
                var txtValue = a.textContent || a.innerText;
                
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    files[i].style.display = "";
                } else {
                    files[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
"@

# Salva l'HTML
Set-Content -Path $outputPath -Value $html -Encoding UTF8

Write-Host "Indice dei file MQL5 generato con successo in: $outputPath" -ForegroundColor Green
Write-Host "Apertura dell'indice..." -ForegroundColor Cyan

# Apri il browser
Start-Process $outputPath
