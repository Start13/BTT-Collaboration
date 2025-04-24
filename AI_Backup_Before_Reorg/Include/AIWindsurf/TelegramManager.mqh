//+------------------------------------------------------------------+
//|                                               TelegramManager.mqh |
//|                                    Copyright 2025, BlueTrendTeam |
//|                                       https://www.bluetrend.team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, BlueTrendTeam"
#property link      "https://www.bluetrend.team"
#property version   "1.00"

#include <Arrays\ArrayString.mqh>

//+------------------------------------------------------------------+
//| Classe per gestire i messaggi Telegram mantenendo solo i più recenti |
//+------------------------------------------------------------------+
class CTelegramManager
{
private:
   CArrayString    m_messages;       // Array per memorizzare i messaggi
   int             m_maxMessages;    // Numero massimo di messaggi da mantenere
   string          m_botToken;       // Token del bot Telegram
   string          m_chatId;         // ID della chat Telegram
   
public:
                   CTelegramManager(string botToken, string chatId, int maxMessages=3);
                  ~CTelegramManager();
   
   // Invia un messaggio e mantiene solo gli ultimi m_maxMessages
   bool            SendMessage(string message);
   
   // Elimina i messaggi più vecchi
   void            DeleteOldMessages();
   
   // Getter e setter
   void            SetMaxMessages(int maxMessages) { m_maxMessages = maxMessages; }
   int             GetMaxMessages() { return m_maxMessages; }
   void            SetBotToken(string botToken) { m_botToken = botToken; }
   void            SetChatId(string chatId) { m_chatId = chatId; }
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CTelegramManager::CTelegramManager(string botToken, string chatId, int maxMessages=3)
{
   m_botToken = botToken;
   m_chatId = chatId;
   m_maxMessages = maxMessages;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CTelegramManager::~CTelegramManager()
{
   m_messages.Clear();
}

//+------------------------------------------------------------------+
//| Invia un messaggio e mantiene solo gli ultimi m_maxMessages      |
//+------------------------------------------------------------------+
bool CTelegramManager::SendMessage(string message)
{
   // Aggiungi il messaggio all'array
   m_messages.Add(message);
   
   // Costruisci l'URL per l'invio del messaggio
   string url = "https://api.telegram.org/bot" + m_botToken + 
                "/sendMessage?chat_id=" + m_chatId + 
                "&text=" + StringReplace(message, " ", "%20");
   
   // Invia il messaggio
   string headers = "Content-Type: application/x-www-form-urlencoded\r\n";
   char post[], result[];
   int res = WebRequest("GET", url, headers, 0, post, result, headers);
   
   if(res == -1)
   {
      Print("Errore nell'invio del messaggio Telegram: ", GetLastError());
      return false;
   }
   
   // Elimina i messaggi più vecchi se necessario
   DeleteOldMessages();
   
   return true;
}

//+------------------------------------------------------------------+
//| Elimina i messaggi più vecchi                                    |
//+------------------------------------------------------------------+
void CTelegramManager::DeleteOldMessages()
{
   // Se abbiamo più messaggi del massimo consentito, elimina i più vecchi
   while(m_messages.Total() > m_maxMessages)
   {
      // Trova l'ID del messaggio più vecchio
      string oldestMessage = m_messages.At(0);
      
      // Costruisci l'URL per eliminare il messaggio
      string url = "https://api.telegram.org/bot" + m_botToken + 
                   "/deleteMessage?chat_id=" + m_chatId + 
                   "&message_id=";
      
      // Estrai l'ID del messaggio (assumendo che sia stato salvato nel formato "ID:messaggio")
      string messageId = "";
      
      // Qui dovresti implementare la logica per estrarre l'ID del messaggio
      // Questo dipende da come vengono salvati i messaggi e i loro ID
      
      // Elimina il messaggio più vecchio dall'array
      m_messages.Delete(0);
      
      // Nota: Per eliminare effettivamente i messaggi da Telegram,
      // avrai bisogno degli ID dei messaggi, che vengono restituiti
      // quando invii un messaggio. Questo richiede una gestione più complessa
      // che memorizza gli ID dei messaggi insieme ai messaggi stessi.
   }
}
