//+------------------------------------------------------------------+
//|                                                 BaseControl.mqh |
//|                                      BlueTrendTeam Implementation |
//|                                 https://github.com/Start13/BTT-Collaboration |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://github.com/Start13/BTT-Collaboration"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Classe base per tutti i controlli UI                             |
//+------------------------------------------------------------------+
class CBaseControl
{
protected:
   string            m_name;              // Nome del controllo
   int               m_id;                // ID del controllo
   int               m_x, m_y;            // Posizione
   int               m_width, m_height;   // Dimensioni
   color             m_backgroundColor;   // Colore di sfondo
   color             m_borderColor;       // Colore del bordo
   color             m_textColor;         // Colore del testo
   int               m_zOrder;            // Ordine Z
   bool              m_visible;           // Visibilità
   
public:
                     CBaseControl();
   virtual          ~CBaseControl();
   
   // Creazione e distruzione
   virtual bool      Create(const string name, const int x, const int y, const int width, const int height);
   virtual void      Destroy();
   
   // Gestione eventi
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Getters e Setters
   string            Name() const { return m_name; }
   void              Name(const string name) { m_name = name; }
   
   int               ID() const { return m_id; }
   void              ID(const int id) { m_id = id; }
   
   int               X() const { return m_x; }
   void              X(const int x) { m_x = x; }
   
   int               Y() const { return m_y; }
   void              Y(const int y) { m_y = y; }
   
   int               Width() const { return m_width; }
   void              Width(const int width) { m_width = width; }
   
   int               Height() const { return m_height; }
   void              Height(const int height) { m_height = height; }
   
   color             BackgroundColor() const { return m_backgroundColor; }
   void              BackgroundColor(const color clr) { m_backgroundColor = clr; }
   
   color             BorderColor() const { return m_borderColor; }
   void              BorderColor(const color clr) { m_borderColor = clr; }
   
   color             TextColor() const { return m_textColor; }
   void              TextColor(const color clr) { m_textColor = clr; }
   
   int               ZOrder() const { return m_zOrder; }
   void              ZOrder(const int z) { m_zOrder = z; }
   
   bool              Visible() const { return m_visible; }
   virtual void      Visible(const bool visible);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CBaseControl::CBaseControl()
{
   m_name = "";
   m_id = 0;
   m_x = 0;
   m_y = 0;
   m_width = 100;
   m_height = 30;
   m_backgroundColor = clrWhite;
   m_borderColor = clrBlack;
   m_textColor = clrBlack;
   m_zOrder = 0;
   m_visible = true;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CBaseControl::~CBaseControl()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Crea il controllo                                                |
//+------------------------------------------------------------------+
bool CBaseControl::Create(const string name, const int x, const int y, const int width, const int height)
{
   m_name = name;
   m_x = x;
   m_y = y;
   m_width = width;
   m_height = height;
   
   // Implementazione di base, da sovrascrivere nelle classi derivate
   return true;
}

//+------------------------------------------------------------------+
//| Distrugge il controllo                                           |
//+------------------------------------------------------------------+
void CBaseControl::Destroy()
{
   // Implementazione di base, da sovrascrivere nelle classi derivate
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del controllo                                |
//+------------------------------------------------------------------+
bool CBaseControl::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   // Implementazione di base, da sovrascrivere nelle classi derivate
   return false;
}

//+------------------------------------------------------------------+
//| Imposta la visibilità del controllo                              |
//+------------------------------------------------------------------+
void CBaseControl::Visible(const bool visible)
{
   if(m_visible == visible)
      return;
      
   m_visible = visible;
   
   // Implementazione di base, da sovrascrivere nelle classi derivate
}
//+------------------------------------------------------------------+
