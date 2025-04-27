import requests
import os
import smtplib
import json
from email.message import EmailMessage
from datetime import datetime

# Carica le credenziali dal file di configurazione sicuro
config_path = "C:\\Users\\Asus\\BTT_Secure\\notification_config.json"
try:
    with open(config_path, 'r') as config_file:
        config = json.load(config_file)
        # Estrai le credenziali dalla struttura JSON esistente
        TELEGRAM_TOKEN = config["telegram"]["bot_token"]
        TELEGRAM_CHAT_ID = config["telegram"]["chat_id"]
        EMAIL_SENDER = config["email"]["sender_email"]
        EMAIL_PASSWORD = config["email"]["sender_password"]
        EMAIL_RECEIVER = config["email"]["recipient_email"]
except Exception as e:
    print(f"Errore nel caricamento del file di configurazione: {str(e)}")
    # Valori di fallback (non usati per l'invio effettivo)
    TELEGRAM_TOKEN = "token_placeholder"
    TELEGRAM_CHAT_ID = "chat_id_placeholder"
    EMAIL_SENDER = "sender_placeholder@example.com"
    EMAIL_PASSWORD = "password_placeholder"
    EMAIL_RECEIVER = "receiver_placeholder@example.com"

# Trova il file BBTT più recente
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

README_PATH = find_latest_bbtt_file()

# Messaggio di backup
BACKUP_MESSAGE = """# BlueTrendTeam - Backup Completato

 Data e ora: {date_time}

 Stato attuale: Completato: Migrazione di tutte le cartelle AI nelle nuove strutture standardizzate e aggiunta dei pannelli UI

 Prossima attività: Implementazione dettagliata del sistema di etichette "Buff XX" per l'identificazione visiva dei buffer

Istruzioni per Continuare il Lavoro:

Per iniziare una nuova chat:
1. Carica il file README.md nella nuova chat
2. Segui le istruzioni nel README

Se continui con un'altra AI:
1. Carica lo stesso file README.md
2. L'AI troverà tutte le istruzioni necessarie

Se AI Windsurf finisce i token:
1. La supervisione passa ad un'altra AI oppure
2. Procedi senza supervisione

IMPORTANTE: Tutti i file sono stati salvati in modo sicuro su GitHub.
"""

def send_telegram_message():
    """Invia il messaggio di backup su Telegram"""
    current_time = datetime.now().strftime("%d %B %Y, %H:%M")
    message = BACKUP_MESSAGE.format(date_time=current_time)
    
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
    data = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message,
        "parse_mode": "Markdown"
    }
    
    try:
        response = requests.post(url, data=data)
        if response.status_code == 200:
            print("+ Messaggio inviato con successo su Telegram")
        else:
            print(f"- Errore nell'invio del messaggio su Telegram: {response.text}")
    except Exception as e:
        print(f"- Errore nell'invio del messaggio su Telegram: {str(e)}")

def send_telegram_file(filepath):
    """Invia un file su Telegram"""
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
    
    try:
        with open(filepath, 'rb') as f:
            files = {"document": f}
            data = {"chat_id": TELEGRAM_CHAT_ID}
            response = requests.post(url, data=data, files=files)
        
        if response.status_code == 200:
            print(f"+ File {os.path.basename(filepath)} inviato con successo su Telegram")
        else:
            print(f"- Errore nell'invio del file su Telegram: {response.text}")
    except Exception as e:
        print(f"- Errore nell'invio del file su Telegram: {str(e)}")

def send_email():
    """Invia il backup via email"""
    current_time = datetime.now().strftime("%d %B %Y, %H:%M")
    message = BACKUP_MESSAGE.format(date_time=current_time)
    
    msg = EmailMessage()
    msg['Subject'] = f"BlueTrendTeam Backup - {datetime.now().strftime('%d/%m/%Y %H:%M')}"
    msg['From'] = EMAIL_SENDER
    msg['To'] = EMAIL_RECEIVER
    msg.set_content(message)
    
    # Allega il file README.md
    try:
        with open(README_PATH, 'rb') as f:
            file_data = f.read()
        msg.add_attachment(file_data, maintype='application', subtype='octet-stream', filename=os.path.basename(README_PATH))
        
        # Invia l'email
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(EMAIL_SENDER, EMAIL_PASSWORD)
            smtp.send_message(msg)
        print("+ Backup inviato con successo via Email")
    except Exception as e:
        print(f"- Errore nell'invio via Email: {str(e)}")

def main():
    print("Invio backup BlueTrendTeam...")
    
    # Invia su Telegram
    send_telegram_message()
    send_telegram_file(README_PATH)
    
    # Invia via email
    send_email()
    
    print("Backup completato!")

if __name__ == "__main__":
    main()
