import os
import datetime
import smtplib
import requests
from email.message import EmailMessage

# Configurazione
TELEGRAM_TOKEN = "7643660310:AAFTOpU5Q2SEVyHaWnpESZ65KkGeYUyVFwk"
TELEGRAM_CHAT_ID = "271416564"
EMAIL_SENDER = "corbruniminer1@gmail.com"
EMAIL_PASSWORD = "pxlk yyjh vofe dvua"
EMAIL_RECEIVER = "corbruni@gmail.com"
BBTT_UNICO_PATH = "c:\\Users\\Asus\\CascadeProjects\\BlueTrendTeam\\BBTT\\BBTT_Unico.txt"

def send_telegram(filepath):
    print(f"Invio {os.path.basename(filepath)} su Telegram...")
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
    with open(filepath, "rb") as f:
        response = requests.post(url, data={"chat_id": TELEGRAM_CHAT_ID}, files={"document": f})
    if response.status_code == 200:
        print("✓ File inviato con successo su Telegram")
    else:
        print(f"✗ Errore nell'invio su Telegram: {response.text}")

def send_email(filepath):
    print(f"Invio {os.path.basename(filepath)} via Email...")
    msg = EmailMessage()
    msg['Subject'] = 'BBTT_Unico aggiornato'
    msg['From'] = EMAIL_SENDER
    msg['To'] = EMAIL_RECEIVER
    
    with open(filepath, 'rb') as f:
        file_data = f.read()
        file_name = os.path.basename(filepath)
    
    msg.add_attachment(file_data, maintype='text', subtype='plain', filename=file_name)
    
    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(EMAIL_SENDER, EMAIL_PASSWORD)
            smtp.send_message(msg)
        print("✓ File inviato con successo via Email")
    except Exception as e:
        print(f"✗ Errore nell'invio via Email: {str(e)}")

def main():
    # Verifica che il file esista
    if not os.path.exists(BBTT_UNICO_PATH):
        print(f"Il file {BBTT_UNICO_PATH} non esiste!")
        return
    
    print(f"File trovato: {BBTT_UNICO_PATH}")
    
    # Invia su Telegram
    send_telegram(BBTT_UNICO_PATH)
    
    # Chiedi se inviare anche via email
    email_choice = input("Vuoi inviare anche via Email? [s/n]: ").strip().lower()
    if email_choice == 's':
        send_email(BBTT_UNICO_PATH)
    
    print("\nOperazione completata!")

if __name__ == "__main__":
    main()
