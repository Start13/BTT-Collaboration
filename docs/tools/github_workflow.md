# GitHub Workflow per BlueTrendTeam

Questo documento descrive il workflow GitHub utilizzato per la collaborazione tra diverse AI nel progetto BlueTrendTeam.

## Struttura dei Branch

- **main**: Branch principale che contiene il codice stabile e la documentazione ufficiale
- **dev_[nome_ai]**: Branch dedicati per ogni AI collaboratrice (es. dev_AIWindsurf)
- **feature/[nome_feature]**: Branch temporanei per lo sviluppo di funzionalità specifiche
- **bugfix/[nome_bug]**: Branch temporanei per la correzione di bug

## Workflow di Base

1. **Clonazione del Repository**:
   ```bash
   git clone https://github.com/BlueTrendTeam/BlueTrendTeam.git
   cd BlueTrendTeam
   ```

2. **Creazione del Branch dell'AI**:
   ```bash
   git checkout -b dev_[nome_ai]
   ```

3. **Sviluppo**:
   - Lavorare sui file nel branch dell'AI
   - Committare frequentemente con messaggi descrittivi

4. **Push al Repository Remoto**:
   ```bash
   git push origin dev_[nome_ai]
   ```

5. **Creazione di Pull Request**:
   - Creare una pull request dal branch dell'AI al branch main
   - Includere una descrizione dettagliata delle modifiche
   - Assegnare la review ad AI Windsurf

6. **Review e Merge**:
   - AI Windsurf revisiona le modifiche
   - Feedback e discussione nella pull request
   - Merge nel branch main dopo approvazione

## Convenzioni di Commit

### Formato del Messaggio di Commit

```
[tipo]: [descrizione breve]

[descrizione dettagliata]

[riferimenti]
```

### Tipi di Commit

- **feat**: Nuova funzionalità
- **fix**: Correzione di bug
- **docs**: Modifiche alla documentazione
- **style**: Modifiche che non influenzano il comportamento del codice (formattazione, spazi, ecc.)
- **refactor**: Refactoring del codice
- **test**: Aggiunta o modifica di test
- **chore**: Modifiche al processo di build o strumenti ausiliari

### Esempi

```
feat: Implementazione del sistema di etichette buffer

Aggiunta la funzionalità per identificare visivamente i buffer degli indicatori
con etichette "Buff XX" nell'interfaccia utente.

Risolve: #42
```

```
fix: Correzione del problema di accesso ai membri in CJAVal

Modificata la classe CJAVal per rendere pubblici i membri m_key e m_value,
risolvendo il problema di accesso durante la lettura dei file JSON.

Risolve: #53
```

## Gestione delle Issue

### Tipi di Issue

- **Bug**: Problemi nel codice esistente
- **Feature**: Richieste di nuove funzionalità
- **Documentation**: Miglioramenti alla documentazione
- **Question**: Domande sul progetto o sul codice

### Template per Issue

#### Bug Report

```
**Descrizione del Bug**
[Descrizione chiara e concisa del bug]

**Passi per Riprodurre**
1. [Primo passo]
2. [Secondo passo]
3. [...]

**Comportamento Atteso**
[Descrizione di cosa ci si aspetta che succeda]

**Comportamento Attuale**
[Descrizione di cosa succede effettivamente]

**Contesto Aggiuntivo**
[Qualsiasi altra informazione rilevante]
```

#### Feature Request

```
**Descrizione della Funzionalità**
[Descrizione chiara e concisa della funzionalità richiesta]

**Motivazione**
[Perché questa funzionalità è importante/utile]

**Implementazione Proposta**
[Idee su come implementare la funzionalità, se disponibili]

**Alternative Considerate**
[Eventuali alternative considerate]
```

## Automazione con GitHub Actions

### Workflow di CI/CD

1. **Verifica Sintassi MQL5**:
   - Attivato su push e pull request
   - Verifica la sintassi dei file MQL5 (.mq5, .mqh)
   - Segnala errori di compilazione

2. **Generazione Documentazione**:
   - Attivato su push al branch main
   - Genera documentazione automatica dai commenti nel codice
   - Aggiorna la wiki del repository

3. **Notifiche**:
   - Invia notifiche su nuove pull request
   - Avvisa AI Windsurf quando una pull request è pronta per la review

## Utilizzo degli Script di Automazione

Gli script di automazione si trovano nella cartella `docs/scripts` e facilitano il workflow GitHub:

1. **github_collaboration.ps1**: Script principale per la gestione del workflow GitHub
2. **github_interface.ps1**: Interfaccia semplificata per le operazioni comuni
3. **git_config.ps1**: Configurazione dell'ambiente Git

Per maggiori dettagli sull'utilizzo degli script, consultare il [README.md](../scripts/README.md) nella cartella scripts.

---

*Ultimo aggiornamento: 22 aprile 2025*
