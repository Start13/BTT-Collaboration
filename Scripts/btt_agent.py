# btt_agent.py - AGENTE BTT aggiornato con controllo MT5 attivo + BBTT_buffer aggiornato dinamicamente
import os, datetime, smtplib, requests, subprocess
from email.message import EmailMessage
from typing import List

# CONFIGURAZIONE BASE
BASE_PATH = "C:\\Users\\Asus\\AppData\\Roaming\\MetaQuotes\\Terminal\\"
FOLDERS_TO_SCAN = ["MQL5\\Experts", "MQL5\\Include", "MQL5\\Scripts"]
VALID_EXTENSIONS = [".mq5", ".mqh", ".log"]
EMAIL_SENDER = "corbruniminer1@gmail.com"
EMAIL_PASSWORD = "pxlk yyjh vofe dvua"
EMAIL_RECEIVER = "corbruni@gmail.com"
TELEGRAM_TOKEN = "7643660310:AAFTOpU5Q2SEVyHaWnpESZ65KkGeYUyVFwk"
TELEGRAM_CHAT_ID = "271416564"
MAX_EMAIL_SIZE_MB = 20

# BBTT_buffer aggiornato da codice vivo
BBTT_BUFFER = """
[STRUTTURA ATTUALE BBTT]
- Contiene decisioni strategiche incrementali
- Include info tecniche, organizzative e operative
- È salvato solo nel BBTT_YYYY-MM-DD_HHMM.txt come output logico runtime

[REGOLE SINCRONIZZAZIONE FILE]
- Nessun file BBTT_buffer.txt viene più salvato
- Il contenuto del file BBTT completo equivale a ciò che io ho in memoria viva (BBTT_buffer)

[FLUSSO OPERATIVO DEFINITIVO]
- Descrizione EA (utente) → generazione codice (assistente)
- Compilazione in MetaEditor → errori → correzione logica
- Strategia, debug e ottimizzazione gestite qui dentro
"""

def is_mt5_running() -> bool:
    try:
        output = subprocess.check_output('tasklist', creationflags=0x08000000).decode()
        return "terminal64.exe" in output.lower()
    except Exception:
        return False


def get_output_dir():
    date_str = datetime.datetime.now().strftime("%Y-%m-%d")
    folder = os.path.join("C:\\BTT_Agent", f"BBTT_{date_str}")
    os.makedirs(folder, exist_ok=True)
    return folder


def scan_files(base: str, folders: List[str], extensions: List[str]) -> List[str]:
    results = []
    for folder in folders:
        full_path = os.path.join(base, folder)
        for root, _, files in os.walk(full_path):
            for f in files:
                if any(f.endswith(ext) for ext in extensions):
                    results.append(os.path.join(root, f))
    return results


def read_file(filepath: str) -> str:
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return f"\n--- {filepath} ---\n" + f.read()
    except Exception as e:
        return f"\n--- {filepath} ---\n[ERROR] {str(e)}"


def generate_bbtt() -> str:
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    return f"""
*** BBTT – Backup BlueTrendTeam ***
🕒 DATA: {now}

{BBTT_BUFFER.strip()}
"""


def save_files_mt5(files: List[str], path: str):
    with open(path, 'w', encoding='utf-8') as out:
        out.write("*** Files_MT5 Snapshot ***\n")
        out.write(f"DATA: {datetime.datetime.now()}\n")
        out.write(f"BASE PATH: {BASE_PATH}\n")
        out.write("===================================\n")
        for file in files:
            out.write(read_file(file) + '\n')


def cleanup_old_files(folder: str, prefix: str, max_count: int):
    files = sorted(
        [f for f in os.listdir(folder) if f.startswith(prefix)],
        key=lambda f: os.path.getmtime(os.path.join(folder, f))
    )
    while len(files) > max_count:
        os.remove(os.path.join(folder, files.pop(0)))


def send_telegram(filepath: str):
    url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendDocument"
    with open(filepath, "rb") as f:
        requests.post(url, data={"chat_id": TELEGRAM_CHAT_ID}, files={"document": f})


def send_email(bbtt_path: str):
    if os.path.getsize(bbtt_path) > MAX_EMAIL_SIZE_MB * 1024 * 1024:
        print("[X] FILE TROPPO GRANDE PER EMAIL (supera 20MB), invio annullato.")
        return
    msg = EmailMessage()
    msg['Subject'] = 'BBTT aggiornato'
    msg['From'] = EMAIL_SENDER
    msg['To'] = EMAIL_RECEIVER
    with open(bbtt_path, 'rb') as f1:
        msg.add_attachment(f1.read(), maintype='text', subtype='plain', filename=os.path.basename(bbtt_path))
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
        smtp.login(EMAIL_SENDER, EMAIL_PASSWORD)
        smtp.send_message(msg)


def main():
    if not is_mt5_running():
        return

    input("Premi INVIO per avviare il backup...")
    files = scan_files(BASE_PATH, FOLDERS_TO_SCAN, VALID_EXTENSIONS)
    output_dir = get_output_dir()
    now = datetime.datetime.now().strftime("%Y-%m-%d_%H%M")
    bbtt_path = os.path.join(output_dir, f"BBTT_{now}.txt")
    files_path = os.path.join(output_dir, f"Files_MT5_{now}.txt")

    with open(bbtt_path, 'w', encoding='utf-8') as f:
        f.write(generate_bbtt())
    save_files_mt5(files, files_path)
    cleanup_old_files(output_dir, "BBTT_", 3)
    cleanup_old_files(output_dir, "Files_MT5_", 3)
    print(f"[] Salvato: {bbtt_path}\n[] Salvato: {files_path}")

    invio_tg = input("Vuoi inviare anche su Telegram? [s/n]: ").strip().lower()
    if invio_tg == 's':
        send_telegram(bbtt_path)
        send_telegram(files_path)
        print("[] Inviato via Telegram")

    invio_email = input("Vuoi inviare anche via Email? [s/n]: ").strip().lower()
    if invio_email == 's':
        send_email(bbtt_path)
        send_email(files_path)
        print("[] Inviato via Email")

    input("\nPremi INVIO per chiudere.")


if __name__ == "__main__":
    main()
