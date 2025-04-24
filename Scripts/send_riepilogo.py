import os
import datetime
import requests

# Configurazione
TELEGRAM_TOKEN = "7643660310:AAFTOpU5Q2SEVyHaWnpESZ65KkGeYUyVFwk"
TELEGRAM_CHAT_ID = "271416564"
RIEPILOGO_PATH = "C:\\Users\\Asus\\CascadeProjects\\BlueTrendTeam\\riepilogo.md"

def send_telegram(filepath):
    print(f"Invio {os.path.basename(filepath)} su Telegram...")
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
    with open(filepath, "rb") as f:
        response = requests.post(url, data={"chat_id": TELEGRAM_CHAT_ID}, files={"document": f})
    if response.status_code == 200:
        print("+ File inviato con successo su Telegram")
    else:
        print(f"- Errore nell'invio su Telegram: {response.text}")

def main():
    # Verifica che il file esista
    if not os.path.exists(RIEPILOGO_PATH):
        print(f"Il file {RIEPILOGO_PATH} non esiste!")
        return
    
    print(f"File trovato: {RIEPILOGO_PATH}")
    
    # Invia su Telegram
    send_telegram(RIEPILOGO_PATH)
    
    print("\nOperazione completata!")

if __name__ == "__main__":
    main()
