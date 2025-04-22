#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import json
import smtplib
import requests
import datetime
from email.message import EmailMessage

def send_telegram_message(token, chat_id, message):
    """
    Invia un messaggio di testo su Telegram
    """
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    params = {
        "chat_id": chat_id,
        "text": message,
        "parse_mode": "Markdown"
    }
    
    try:
        response = requests.post(url, data=params)
        result = response.json()
        
        if result.get("ok"):
            print("✓ Messaggio Telegram inviato con successo!")
            return True
        else:
            print(f"✗ Errore nell'invio del messaggio Telegram: {result.get('description')}")
            return False
    except Exception as e:
        print(f"✗ Eccezione durante l'invio del messaggio Telegram: {str(e)}")
        return False

def send_telegram_file(token, chat_id, file_path, caption=""):
    """
    Invia un file su Telegram
    """
    if not os.path.exists(file_path):
        print(f"✗ File non trovato: {file_path}")
        return False
    
    url = f"https://api.telegram.org/bot{token}/sendDocument"
    
    try:
        with open(file_path, 'rb') as f:
            files = {'document': f}
            data = {'chat_id': chat_id}
            if caption:
                data['caption'] = caption
            
            response = requests.post(url, data=data, files=files)
            result = response.json()
            
            if result.get("ok"):
                print("✓ File Telegram inviato con successo!")
                return True
            else:
                print(f"✗ Errore nell'invio del file Telegram: {result.get('description')}")
                return False
    except Exception as e:
        print(f"✗ Eccezione durante l'invio del file Telegram: {str(e)}")
        return False

def send_email(sender_email, sender_password, recipient_email, subject, body, attachment_path=None):
    """
    Invia un'email con Gmail, opzionalmente con un allegato
    """
    try:
        msg = EmailMessage()
        msg['Subject'] = subject
        msg['From'] = sender_email
        msg['To'] = recipient_email
        msg.set_content(body)
        
        # Per inviare email HTML
        msg.add_alternative(body, subtype='html')
        
        # Aggiungi allegato se specificato
        if attachment_path and os.path.exists(attachment_path):
            with open(attachment_path, 'rb') as f:
                file_data = f.read()
                file_name = os.path.basename(attachment_path)
            
            msg.add_attachment(file_data, maintype='text', subtype='markdown', filename=file_name)
            print(f"Allegato aggiunto: {file_name}")
        
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(sender_email, sender_password)
            smtp.send_message(msg)
        
        print("✓ Email inviata con successo!")
        return True
    except Exception as e:
        print(f"✗ Errore nell'invio dell'email: {str(e)}")
        return False

def get_project_info(readme_path):
    """
    Estrae informazioni dal file README
    """
    current_datetime = datetime.datetime.now().strftime("%d %B %Y, %H:%M")
    stato_attuale = ""
    prossima_attivita = ""
    
    try:
        with open(readme_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
            # Estrai informazioni rilevanti
            import re
            stato_match = re.search(r'Stato attuale\*\*:\s*(.*?)[\r\n]', content)
            if stato_match:
                stato_attuale = stato_match.group(1)
            
            attivita_match = re.search(r'Prossima attività\*\*:\s*(.*?)[\r\n]', content)
            if attivita_match:
                prossima_attivita = attivita_match.group(1)
    except Exception as e:
        print(f"Errore durante la lettura del README: {str(e)}")
    
    return {
        "data_ora": current_datetime,
        "stato_attuale": stato_attuale,
        "prossima_attivita": prossima_attivita,
        "readme_path": readme_path
    }

def create_notification_content(project_info):
    """
    Crea il contenuto delle notifiche
    """
    email_subject = f"BlueTrendTeam - Backup Completato - {project_info['data_ora']}"
    
    email_body = f"""
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        h1 {{ color: #0066cc; }}
        h2 {{ color: #0099ff; }}
        .info {{ background-color: #f0f8ff; padding: 15px; border-left: 5px solid #0066cc; margin-bottom: 20px; }}
        .instructions {{ background-color: #f5f5f5; padding: 15px; border-left: 5px solid #666; }}
        .important {{ color: #cc0000; font-weight: bold; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>BlueTrendTeam - Backup Completato</h1>
        <div class="info">
            <p><strong>Data e ora:</strong> {project_info['data_ora']}</p>
            <p><strong>Stato attuale:</strong> {project_info['stato_attuale']}</p>
            <p><strong>Prossima attività:</strong> {project_info['prossima_attivita']}</p>
        </div>
        
        <h2>Istruzioni per Continuare il Lavoro</h2>
        <div class="instructions">
            <p><strong>Per iniziare una nuova chat:</strong></p>
            <ol>
                <li>Carica il file README.md nella nuova chat:<br>
                <code>{project_info['readme_path']}</code></li>
                <li>Segui le istruzioni nel README per continuare il lavoro</li>
            </ol>
            
            <p><strong>Se continui con un'altra AI:</strong></p>
            <ol>
                <li>Carica lo stesso file README.md nella nuova chat</li>
                <li>L'AI troverà tutte le istruzioni necessarie nel README</li>
                <li>Assicurati che la nuova AI esegua i backup automatici</li>
            </ol>
            
            <p><strong>Se AI Windsurf finisce i token:</strong></p>
            <ol>
                <li>La supervisione passa ad un'altra AI oppure</li>
                <li>Procedi senza supervisione, seguendo le Regole Fondamentali</li>
            </ol>
            
            <p class="important">IMPORTANTE: Tutti i file sono stati salvati in modo sicuro su GitHub. In caso di problemi, puoi accedere ai repository:</p>
            <ul>
                <li>BTT-Collaboration: <a href="https://github.com/Start13/BTT-Collaboration">https://github.com/Start13/BTT-Collaboration</a></li>
                <li>MQL5-Backup: <a href="https://github.com/Start13/MQL5-Backup">https://github.com/Start13/MQL5-Backup</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
"""
    
    telegram_message = f"""
*BlueTrendTeam - Backup Completato*

📅 *Data e ora:* {project_info['data_ora']}
📊 *Stato attuale:* {project_info['stato_attuale']}
🔜 *Prossima attività:* {project_info['prossima_attivita']}

*Istruzioni per Continuare il Lavoro:*

*Per iniziare una nuova chat:*
1. Carica il file README.md nella nuova chat
2. Segui le istruzioni nel README

*Se continui con un'altra AI:*
1. Carica lo stesso file README.md
2. L'AI troverà tutte le istruzioni necessarie

*Se AI Windsurf finisce i token:*
1. La supervisione passa ad un'altra AI oppure
2. Procedi senza supervisione

*IMPORTANTE:* Tutti i file sono stati salvati in modo sicuro su GitHub.
"""
    
    return {
        "email_subject": email_subject,
        "email_body": email_body,
        "telegram_message": telegram_message
    }

def main():
    if len(sys.argv) != 2:
        print("Utilizzo: python send_all_notifications.py <config_file>")
        sys.exit(1)
    
    config_file = sys.argv[1]
    
    try:
        # Carica la configurazione
        with open(config_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # Estrai le credenziali
        email_config = config.get('email', {})
        telegram_config = config.get('telegram', {})
        
        sender_email = email_config.get('sender_email')
        sender_password = email_config.get('sender_password')
        recipient_email = email_config.get('recipient_email')
        
        telegram_token = telegram_config.get('bot_token')
        telegram_chat_id = telegram_config.get('chat_id')
        
        # Percorso del README
        readme_path = "C:\\Users\\Asus\\CascadeProjects\\BlueTrendTeam\\BBTT\\docs\\README.md"
        
        # Ottieni informazioni sul progetto
        project_info = get_project_info(readme_path)
        
        # Crea il contenuto delle notifiche
        notification_content = create_notification_content(project_info)
        
        # Invia email con README.md allegato
        email_sent = send_email(
            sender_email,
            sender_password,
            recipient_email,
            notification_content['email_subject'],
            notification_content['email_body'],
            readme_path  # Aggiungi README.md come allegato
        )
        
        # Invia messaggio Telegram con le istruzioni
        telegram_sent = send_telegram_message(
            telegram_token,
            telegram_chat_id,
            notification_content['telegram_message']
        )
        
        # Invia anche il file README.md completo su Telegram
        if telegram_sent:
            send_telegram_file(
                telegram_token,
                telegram_chat_id,
                readme_path,
                "File README.md da condividere con la nuova AI"
            )
        
        if email_sent or telegram_sent:
            print("Notifiche inviate con successo!")
            sys.exit(0)
        else:
            print("Errore durante l'invio delle notifiche")
            sys.exit(1)
    
    except Exception as e:
        print(f"Errore: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
