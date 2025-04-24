# PROCEDURA COMPLETA PER IL CAMBIO DI CHAT IN BLUETRENDTEAM

Questa procedura dettagliata deve essere seguita ogni volta che si conclude una sessione di chat e si prevede di continuare il lavoro in una nuova chat.

## 1. PREPARAZIONE DEL RIEPILOGO

Quando si rilevano le trigger words ("nuova chat", "cambio chat", "passo a", ecc.), seguire questi passaggi:

1. Creare un riepilogo completo contenente:
   - Panoramica del progetto
   - Struttura delle directory
   - Componenti implementati
   - Prossimi passi
   - Regole da rispettare
   - **Riferimento esplicito alla necessità di leggere tutte le regole fondamentali**

2. Aggiungere in testa al riepilogo il seguente avviso:
```
# IMPORTANTE: LEGGERE TUTTE LE REGOLE FONDAMENTALI ALL'INIZIO DELLA NUOVA CHAT

Prima di continuare il lavoro, è OBBLIGATORIO leggere tutte le regole fondamentali memorizzate nel sistema.
Questo garantirà la continuità del lavoro e la corretta applicazione delle procedure stabilite.
```

## 2. INVIO DEL RIEPILOGO

Utilizzare lo script `send_telegram_notification.py` in `C:\Users\Asus\CascadeProjects\BlueTrendTeam\Scripts\`:

```bash
python send_telegram_notification.py <token> <chat_id> <path_to_riepilogo>
```

Lo script:
- Invia il file via Telegram
- Conferma l'invio all'utente

## 3. NELLA NUOVA CHAT

All'inizio della nuova chat:
1. Caricare il riepilogo
2. Leggere TUTTE le regole fondamentali
3. Confermare esplicitamente la comprensione delle regole
4. Riprendere il lavoro da dove era stato interrotto

## TRIGGER WORDS PER ATTIVARE LA PROCEDURA

Le seguenti parole o frasi attivano automaticamente questa procedura:
- "nuova chat"
- "cambio chat"
- "passo a"
- "concludiamo"
- "fine sessione"
- "continueremo"
- "riprenderemo"

## NOTA IMPORTANTE

Questa procedura è OBBLIGATORIA per garantire:
- Continuità del lavoro
- Coerenza nell'approccio
- Rispetto delle regole stabilite
- Efficienza nell'uso dei token
- Prevenzione della perdita di informazioni importanti

## MEMORIZZAZIONE FISICA DELLE INFORMAZIONI

È FONDAMENTALE memorizzare FISICAMENTE tutte le informazioni utili nelle apposite cartelle:
- Links: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\Links\`
- Docs: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\Docs\`
- Config: `C:\Users\Asus\CascadeProjects\BlueTrendTeam\Config\`

La memorizzazione solo nel sistema di memoria di Cascade NON è sufficiente, poiché queste informazioni non sono accessibili tra diverse chat.
