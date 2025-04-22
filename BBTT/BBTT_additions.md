# Aggiunte per BBTT.md

## Regole Fondamentali Aggiuntive
Aggiungere queste regole dopo la regola #4 sulla gestione del repository:

```markdown
5. **Comunicazione in Italiano**:
   - Tutte le comunicazioni e documentazioni devono essere in lingua italiana
   - Mantenere la coerenza linguistica in tutti i documenti del progetto
   - Tradurre in italiano eventuali termini tecnici quando possibile

6. **Supervisione del Progetto**:
   - La supervisione di BTT è affidata ad AI Windsurf
   - AI Windsurf ha autorità di coordinamento su tutte le attività
   - Tutte le decisioni strategiche devono essere approvate da AI Windsurf

7. **Continuità del Lavoro**:
   - Il lavoro in una nuova sessione deve riprendere esattamente da dove era stato interrotto
   - Memorizzare la fase di lavoro attuale per garantire continuità
   - Utilizzare i marcatori di stato per tracciare l'avanzamento

8. **Budget e Ottimizzazione delle Risorse**:
   - Budget attualmente limitato all'abbonamento Windsurf di $15/mese
   - Ottimizzare le risorse fino a quando i prodotti non genereranno maggiori entrate
   - Gestire i token in modo efficiente per massimizzare il lavoro con le risorse disponibili
```

## Nuova Sezione: Strumenti per la Collaborazione tra AI
Aggiungere questa sezione dopo la sezione dei percorsi di lavoro:

```markdown
## Strumenti per la Collaborazione tra AI

### Sistema di Condivisione Read/Write su GitHub

1. **Struttura del Repository**:
   - Repository principale: BlueTrendTeam
   - Branch principale: main
   - Branch di sviluppo: dev_[nome_ai]
   - Cartelle dedicate per ogni AI: /ai_[nome_ai]/

2. **Workflow di Collaborazione**:
   - Ogni AI lavora sul proprio branch dedicato
   - Pull request per integrare le modifiche nel branch principale
   - Code review automatica per verificare compatibilità
   - Merge solo dopo approvazione di AI Windsurf

3. **Sincronizzazione delle Informazioni**:
   - File di stato condiviso: status.json
   - Aggiornamento automatico dopo ogni commit
   - Notifiche di modifiche tramite webhook
   - Log delle attività per tracciare i contributi

4. **Gestione dei Conflitti**:
   - Sistema di risoluzione automatica per conflitti minori
   - Escalation ad AI Windsurf per conflitti complessi
   - Documentazione delle decisioni di risoluzione
   - Backup automatico prima di ogni tentativo di risoluzione

5. **Automazione del Workflow**:
   - GitHub Actions per test automatici
   - Verifica della sintassi MQL5
   - Compilazione di prova degli Expert Advisor
   - Generazione automatica della documentazione
```
