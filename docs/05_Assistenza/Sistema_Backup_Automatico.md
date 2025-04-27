# SISTEMA DI BACKUP AUTOMATICO BLUETRENDTEAM
*Ultimo aggiornamento: 27 aprile 2025, 15:38*

## PANORAMICA

Il sistema di backup automatico di BlueTrendTeam garantisce la continuità del lavoro tra diverse sessioni e AI, rispettando le Regole 14 e 16 sulle continuità del lavoro.

## FUNZIONAMENTO DELLO SCRIPT

Lo script `send_backup.py` è stato migliorato per:

1. **Ricercare automaticamente il file BBTT più recente**:
   ```python
   def find_latest_bbtt_file():
       docs_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Docs")
       bbtt_files = [f for f in os.listdir(docs_dir) if f.startswith("BBTT_") and f.endswith(".md")]
       
       if not bbtt_files:
           # Se non ci sono file BBTT nella cartella Docs, cerca nelle sottocartelle
           for root, dirs, files in os.walk(docs_dir):
               bbtt_files.extend([os.path.join(root, f) for f in files if f.startswith("BBTT_") and f.endswith(".md")])
           
           if not bbtt_files:
               # Fallback al file README.md se non ci sono file BBTT
               return os.path.join(os.path.dirname(os.path.abspath(__file__)), "Docs", "README.md")
       
       # Ordina i file per data di modifica (il più recente prima)
       latest_file = max(bbtt_files, key=lambda f: os.path.getmtime(os.path.join(docs_dir, f)))
       return os.path.join(docs_dir, latest_file)
   ```

2. **Inviare il file più recente via Telegram e Email**:
   ```python
   def main():
       print("Invio backup BlueTrendTeam...")
       
       # Invia su Telegram
       send_telegram_message()
       send_telegram_file(README_PATH)
       
       # Invia via email
       send_email()
       
       print("Backup completato!")
   ```

## VANTAGGI DEL NUOVO SISTEMA

1. **Automazione completa**:
   - Non richiede intervento manuale per selezionare il file da inviare
   - Seleziona sempre il file più recente e aggiornato

2. **Robustezza**:
   - Sistema di fallback a più livelli
   - Funziona anche se i file sono stati spostati in sottocartelle

3. **Continuità garantita**:
   - Il file inviato contiene sempre le informazioni più aggiornate
   - Il nome del file include l'ora corretta (es. BBTT_2025-04-27_1530.md)
   - La nuova AI può riprendere il lavoro esattamente dal punto in cui è stato interrotto

## CONTENUTO DEL FILE DI BACKUP

Il file di backup contiene:

1. **Stato attuale del progetto**:
   - Problemi risolti
   - Problemi in corso
   - Funzionalità implementate

2. **Punto esatto di ripresa del lavoro**:
   - Problemi da risolvere immediatamente
   - File principali da analizzare

3. **Struttura organizzativa della documentazione**:
   - Descrizione della struttura delle cartelle
   - Percorsi completi a tutti i file principali

4. **Istruzioni per la nuova AI**:
   - Documenti da consultare
   - File da analizzare
   - Regole da seguire

## COME UTILIZZARE IL SISTEMA

1. **Creare un nuovo file di riepilogo**:
   - Creare un file con nome `BBTT_YYYY-MM-DD_HHMM.md` nella cartella `Docs`
   - Includere tutte le informazioni necessarie per la continuità del lavoro

2. **Eseguire lo script di backup**:
   ```
   python C:\Users\Asus\CascadeProjects\BlueTrendTeam\send_backup.py
   ```

3. **Verificare l'invio**:
   - Controllare che il file sia stato inviato correttamente su Telegram
   - Controllare che il file sia stato inviato correttamente via Email

## CONFORMITÀ ALLE REGOLE

Questo sistema garantisce la conformità alle seguenti regole fondamentali:

- **Regola 14 - Continuità del lavoro nella stessa AI**:
  > Il lavoro in una nuova chat deve riprendere esattamente da dove eravamo nella chat precedente, memorizzando la fase di lavoro per garantire continuità.

- **Regola 16 - Continuità del lavoro tra diverse AI**:
  > Quando si passa il lavoro da un'AI all'altra, la nuova AI deve leggere il riepilogo completo del lavoro precedente, continuare esattamente da dove è stato interrotto il lavoro e mantenere la stessa struttura e approccio al progetto.

*Questo documento viene aggiornato regolarmente per riflettere eventuali modifiche al sistema di backup.*
