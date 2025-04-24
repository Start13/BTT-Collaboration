# Script per copiare i file tra diverse AI mantenendo il contenuto ma aggiornando l'intestazione
# BlueTrendTeam - 23 aprile 2025

# Mappatura delle AI alle sigle neutrali
$aiMappings = @{
    "AIWindsurf" = "AlgoWi";
    "AIChatGpt" = "AlgoCh";
    "AIGemini" = "AlgoGe";
    "AIGrok" = "AlgoGr";
    "AIDeepSeek" = "AlgoDs"
}

# Parametri
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceAI,
    
    [Parameter(Mandatory=$true)]
    [string]$TargetAI,
    
    [Parameter(Mandatory=$false)]
    [string]$SingleFile,
    
    [Parameter(Mandatory=$false)]
    [switch]$CopyAll
)

# Percorso MQL5
$mql5Path = "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5"

# Verifica che le AI specificate esistano
if (-not $aiMappings.ContainsKey($SourceAI)) {
    Write-Host "Errore: AI sorgente '$SourceAI' non valida. Valori validi: $($aiMappings.Keys -join ', ')" -ForegroundColor Red
    exit 1
}

if (-not $aiMappings.ContainsKey($TargetAI)) {
    Write-Host "Errore: AI target '$TargetAI' non valida. Valori validi: $($aiMappings.Keys -join ', ')" -ForegroundColor Red
    exit 1
}

$sourceAlgo = $aiMappings[$SourceAI]
$targetAlgo = $aiMappings[$TargetAI]

# Funzione per aggiornare l'intestazione di un file
function Update-FileHeader {
    param (
        [string]$FilePath,
        [string]$SourceAlgo,
        [string]$TargetAlgo
    )
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Sostituzione "[SourceAlgo] Implementation" con "[TargetAlgo] Implementation"
    $updatedContent = $content -replace "$SourceAlgo Implementation", "$TargetAlgo Implementation"
    
    # Sostituzione "Supervisionato da [SourceAI]" con "[TargetAlgo] Implementation"
    $updatedContent = $updatedContent -replace "Supervisionato da $SourceAI", "$TargetAlgo Implementation"
    
    # Aggiorna i percorsi di inclusione
    $updatedContent = $updatedContent -replace "#include <$SourceAI/", "#include <$TargetAI/"
    
    Set-Content -Path $FilePath -Value $updatedContent -Encoding UTF8
}

# Funzione per copiare un singolo file
function Copy-SingleFile {
    param (
        [string]$RelativePath
    )
    
    $sourcePath = Join-Path $mql5Path $RelativePath
    $targetPath = $sourcePath -replace $SourceAI, $TargetAI
    $targetDir = Split-Path $targetPath -Parent
    
    if (-not (Test-Path $sourcePath)) {
        Write-Host "Errore: File sorgente non trovato: $sourcePath" -ForegroundColor Red
        return $false
    }
    
    # Crea la directory di destinazione se non esiste
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "Creata directory: $targetDir" -ForegroundColor Yellow
    }
    
    # Copia il file
    Copy-Item $sourcePath -Destination $targetPath -Force
    Write-Host "File copiato: $targetPath" -ForegroundColor Green
    
    # Aggiorna l'intestazione
    Update-FileHeader -FilePath $targetPath -SourceAlgo $sourceAlgo -TargetAlgo $targetAlgo
    Write-Host "Intestazione aggiornata: $targetPath" -ForegroundColor Green
    
    return $true
}

# Funzione per copiare tutti i file
function Copy-AllFiles {
    $totalFiles = 0
    $copiedFiles = 0
    
    # Copia file Include
    $includeSourcePath = "$mql5Path\Include\$SourceAI"
    if (Test-Path $includeSourcePath) {
        $includeFiles = Get-ChildItem -Path $includeSourcePath -Recurse -Include "*.mqh"
        foreach ($file in $includeFiles) {
            $totalFiles++
            $relativePath = "Include\$SourceAI\" + $file.FullName.Substring($includeSourcePath.Length + 1)
            if (Copy-SingleFile -RelativePath $relativePath) {
                $copiedFiles++
            }
        }
    }
    
    # Copia file Experts
    $expertsSourcePath = "$mql5Path\Experts\$SourceAI"
    if (Test-Path $expertsSourcePath) {
        $expertFiles = Get-ChildItem -Path $expertsSourcePath -Recurse -Include "*.mq5"
        foreach ($file in $expertFiles) {
            $totalFiles++
            $relativePath = "Experts\$SourceAI\" + $file.FullName.Substring($expertsSourcePath.Length + 1)
            if (Copy-SingleFile -RelativePath $relativePath) {
                $copiedFiles++
            }
        }
    }
    
    # Copia file Scripts
    $scriptsSourcePath = "$mql5Path\Scripts\$SourceAI"
    if (Test-Path $scriptsSourcePath) {
        $scriptFiles = Get-ChildItem -Path $scriptsSourcePath -Recurse -Include "*.mq5"
        foreach ($file in $scriptFiles) {
            $totalFiles++
            $relativePath = "Scripts\$SourceAI\" + $file.FullName.Substring($scriptsSourcePath.Length + 1)
            if (Copy-SingleFile -RelativePath $relativePath) {
                $copiedFiles++
            }
        }
    }
    
    # Copia file Indicators
    $indicatorsSourcePath = "$mql5Path\Indicators\$SourceAI"
    if (Test-Path $indicatorsSourcePath) {
        $indicatorFiles = Get-ChildItem -Path $indicatorsSourcePath -Recurse -Include "*.mq5"
        foreach ($file in $indicatorFiles) {
            $totalFiles++
            $relativePath = "Indicators\$SourceAI\" + $file.FullName.Substring($indicatorsSourcePath.Length + 1)
            if (Copy-SingleFile -RelativePath $relativePath) {
                $copiedFiles++
            }
        }
    }
    
    return @{
        TotalFiles = $totalFiles
        CopiedFiles = $copiedFiles
    }
}

# Esecuzione principale
Write-Host "=== Copia file tra AI ===" -ForegroundColor Green
Write-Host "AI Sorgente: $SourceAI ($sourceAlgo)" -ForegroundColor Cyan
Write-Host "AI Target: $TargetAI ($targetAlgo)" -ForegroundColor Cyan

if ($SingleFile) {
    Write-Host "Modalità: Copia singolo file" -ForegroundColor Yellow
    Write-Host "File: $SingleFile" -ForegroundColor Yellow
    
    $success = Copy-SingleFile -RelativePath $SingleFile
    
    if ($success) {
        Write-Host "`nFile copiato e aggiornato con successo!" -ForegroundColor Green
    }
    else {
        Write-Host "`nErrore nella copia del file." -ForegroundColor Red
    }
}
elseif ($CopyAll) {
    Write-Host "Modalità: Copia tutti i file" -ForegroundColor Yellow
    
    $result = Copy-AllFiles
    
    Write-Host "`n=== Riepilogo ===" -ForegroundColor Cyan
    Write-Host "Totale file processati: $($result.TotalFiles)" -ForegroundColor White
    Write-Host "Totale file copiati: $($result.CopiedFiles)" -ForegroundColor Green
    
    if ($result.CopiedFiles -eq $result.TotalFiles) {
        Write-Host "`nTutti i file sono stati copiati e aggiornati con successo!" -ForegroundColor Green
    }
    else {
        Write-Host "`nAlcuni file non sono stati copiati. Controlla gli errori sopra." -ForegroundColor Yellow
    }
}
else {
    Write-Host "Errore: Specificare -SingleFile o -CopyAll" -ForegroundColor Red
    Write-Host "`nEsempi di utilizzo:" -ForegroundColor Yellow
    Write-Host "  .\copy_ai_files.ps1 -SourceAI AIWindsurf -TargetAI AIChatGpt -SingleFile 'Include\AIWindsurf\common\BufferLabeling.mqh'" -ForegroundColor White
    Write-Host "  .\copy_ai_files.ps1 -SourceAI AIWindsurf -TargetAI AIChatGpt -CopyAll" -ForegroundColor White
}
