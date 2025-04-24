#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import requests

def send_telegram_message(token, chat_id, message):
    """
    Invia un messaggio di testo su Telegram
    """
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    params = {
        "chat_id": chat_id,
        "text": message
    }
    
    try:
        response = requests.post(url, data=params)
        result = response.json()
        
        if result.get("ok"):
            print("Messaggio Telegram inviato con successo!")
            return True
        else:
            print(f"Errore nell'invio del messaggio Telegram: {result.get('description')}")
            return False
    except Exception as e:
        print(f"Eccezione durante l'invio del messaggio Telegram: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Utilizzo: python send_telegram_notification.py <token> <chat_id> <message_file>")
        sys.exit(1)
    
    token = sys.argv[1]
    chat_id = sys.argv[2]
    message_file = sys.argv[3]
    
    try:
        with open(message_file, 'r', encoding='utf-8') as f:
            message = f.read()
        
        success = send_telegram_message(token, chat_id, message)
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"Errore: {str(e)}")
        sys.exit(1)
