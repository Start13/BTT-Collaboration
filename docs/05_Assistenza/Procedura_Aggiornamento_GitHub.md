# Procedura Corretta per Aggiornare Repository GitHub

*Ultimo aggiornamento: 27 aprile 2025, 23:25*

## Problema Identificato

Basandoci sul feedback di Grok (27 aprile 2025): *"Il repository https://github.com/Start13/MQL5-Backup non sembra contenere i file aggiornati che hai menzionato (pannelli interattivi, MyInclude, MyLibrary, ecc.)"*, abbiamo identificato diversi problemi che possono verificarsi durante l'aggiornamento di un repository GitHub:

1. Problemi con l'operatore `&&` in PowerShell che non è supportato nella versione utilizzata
2. File non correttamente caricati o visibili nel repository
3. Struttura delle directory non mantenuta correttamente
4. Problemi di autenticazione con GitHub

## Soluzione: Metodo Passo-Passo

### 1. Preparazione dell'Ambiente

```powershell
# Creare una directory temporanea per il clone
mkdir C:\Users\Asus\GitHub-Temp

# Posizionarsi nella directory temporanea
cd C:\Users\Asus\GitHub-Temp
```

### 2. Clonare il Repository Esistente

```powershell
# Clonare il repository
git clone https://github.com/Start13/MQL5-Backup.git

# Entrare nella directory del repository
cd MQL5-Backup
```

### 3. Verificare la Struttura delle Directory

```powershell
# Assicurarsi che tutte le directory necessarie esistano
mkdir -Force Include\AIWindsurf\omniea
mkdir -Force Include\AIWindsurf\ui
mkdir -Force Include\AIWindsurf\indicators
mkdir -Force Experts\OmniEA
```

### 4. Copiare i File Aggiornati

```powershell
# Copiare i file dal terminale MQL5 al repository temporaneo
# Utilizzare percorsi assoluti e comandi separati (non &&)

# PresetManager
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\omniea\PresetManager.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\omniea\"

# PanelUI
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\ui\PanelUI.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\ui\"

# PanelEvents
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\ui\PanelEvents.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\ui\"

# Altri file necessari
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\ui\PanelBase.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\ui\"
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\ui\PanelManager.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\ui\"
Copy-Item "C:\Users\Asus\AppData\Roaming\MetaQuotes\Terminal\C695EA989DD2215C5F14AD2E649A7166\MQL5\Include\AIWindsurf\omniea\SlotManager.mqh" -Destination "C:\Users\Asus\GitHub-Temp\MQL5-Backup\Include\AIWindsurf\omniea\"
```

### 5. Configurare Git

```powershell
# Configurare Git con le credenziali
git config --global user.email "start13@example.com"
git config --global user.name "Start13"
```

### 6. Verificare lo Stato e Aggiungere i File

```powershell
# Verificare quali file sono stati modificati
git status

# Aggiungere tutti i file modificati
git add .

# Verificare che tutti i file siano stati aggiunti correttamente
git status
```

### 7. Eseguire il Commit

```powershell
# Eseguire il commit con un messaggio descrittivo
git commit -m "Aggiornamento completo: PresetManager, PanelUI, PanelEvents e altri file necessari"
```

### 8. Eseguire il Push

```powershell
# Eseguire il push al repository remoto
git push origin master
```

### 9. Verificare il Repository Online

Dopo aver eseguito il push, visitare il repository su GitHub per verificare che tutti i file siano stati caricati correttamente:
https://github.com/Start13/MQL5-Backup

### 10. Pulizia

```powershell
# Eliminare la directory temporanea
cd C:\Users\Asus
Remove-Item -Recurse -Force GitHub-Temp
```

## Verifica Finale

Per assicurarsi che il repository sia stato aggiornato correttamente, è necessario verificare che:

1. Tutti i file siano visibili nel repository online
2. La struttura delle directory sia mantenuta correttamente
3. I file contengano le modifiche più recenti

## Risoluzione Problemi Comuni

- **Problema di autenticazione**: Se il push fallisce per problemi di autenticazione, utilizzare un token di accesso personale:
  ```powershell
  git remote set-url origin https://[USERNAME]:[TOKEN]@github.com/Start13/MQL5-Backup.git
  ```

- **File non visibili**: Se i file non sono visibili, verificare che siano stati aggiunti correttamente con `git add`

- **Struttura directory non mantenuta**: Se la struttura delle directory non è mantenuta, verificare che le directory siano state create correttamente

## Nota Importante

Questo metodo utilizza comandi separati invece dell'operatore `&&` per evitare problemi con PowerShell. Ogni comando deve essere eseguito separatamente, assicurandosi che il comando precedente sia stato completato con successo prima di procedere con il successivo.

## Applicazione della Regola 18

Seguendo la Regola 18 sulla pulizia dei file e cartelle inutili, ricordarsi sempre di eliminare le directory temporanee create durante il processo di aggiornamento, come indicato nel passo 10.

---

*Questo documento è parte della documentazione ufficiale di BlueTrendTeam e deve essere consultato ogni volta che si desidera aggiornare un repository GitHub.*
