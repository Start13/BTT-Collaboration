//+------------------------------------------------------------------+
//|                                                      Button.mqh |
//|                                      BlueTrendTeam Implementation |
//|                                 https://github.com/Start13/BTT-Collaboration |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://github.com/Start13/BTT-Collaboration"
#property version   "1.00"
#property strict

#include "BaseControl.mqh"

//+------------------------------------------------------------------+
//| Classe per il controllo Button                                   |
//+------------------------------------------------------------------+
class CButton : public CBaseControl
{
private:
   string            m_text;              // Testo del pulsante
   bool              m_pressed;           // Stato del pulsante (premuto/non premuto)
   color             m_pressedColor;      // Colore quando premuto
   color             m_hoverColor;        // Colore quando il mouse è sopra
   bool              m_hover;             // Stato hover
   int               m_fontSize;          // Dimensione del testo
   string            m_font;              // Font del testo
   
public:
                     CButton();
   virtual          ~CButton();
   
   // Creazione e distruzione
   virtual bool      Create(const string name, const int x, const int y, const int width, const int height, const string text = "Button");
   virtual void      Destroy();
   
   // Disegno
   virtual void      Draw();
   
   // Gestione eventi
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Eventi
   virtual void      OnClick();
   virtual void      OnMouseEnter();
   virtual void      OnMouseLeave();
   
   // Getters e Setters
   string            Text() const { return m_text; }
   void              Text(const string text);
   
   bool              Pressed() const { return m_pressed; }
   void              Pressed(const bool pressed);
   
   color             PressedColor() const { return m_pressedColor; }
   void              PressedColor(const color clr) { m_pressedColor = clr; }
   
   color             HoverColor() const { return m_hoverColor; }
   void              HoverColor(const color clr) { m_hoverColor = clr; }
   
   int               FontSize() const { return m_fontSize; }
   void              FontSize(const int size) { m_fontSize = size; }
   
   string            Font() const { return m_font; }
   void              Font(const string font) { m_font = font; }
   
   // Implementazione di CBaseControl
   virtual void      Visible(const bool visible);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CButton::CButton() : CBaseControl()
{
   m_text = "Button";
   m_pressed = false;
   m_pressedColor = clrLightGray;
   m_hoverColor = clrWhiteSmoke;
   m_hover = false;
   m_fontSize = 10;
   m_font = "Arial";
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CButton::~CButton()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Crea il pulsante                                                 |
//+------------------------------------------------------------------+
bool CButton::Create(const string name, const int x, const int y, const int width, const int height, const string text = "Button")
{
   if(!CBaseControl::Create(name, x, y, width, height))
      return false;
      
   m_text = text;
   
   // Crea l'oggetto grafico del pulsante
   if(!ObjectCreate(0, m_name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione del pulsante: ", GetLastError());
      return false;
   }
   
   // Configura l'oggetto
   ObjectSetInteger(0, m_name, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, m_name, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, m_name, OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, m_name, OBJPROP_YSIZE, m_height);
   ObjectSetInteger(0, m_name, OBJPROP_BGCOLOR, m_backgroundColor);
   ObjectSetInteger(0, m_name, OBJPROP_BORDER_COLOR, m_borderColor);
   ObjectSetInteger(0, m_name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, m_name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, m_name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, m_name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, m_name, OBJPROP_ZORDER, m_zOrder);
   
   // Crea l'etichetta di testo
   string textName = m_name + "_text";
   if(!ObjectCreate(0, textName, OBJ_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione dell'etichetta di testo: ", GetLastError());
      Destroy();
      return false;
   }
   
   // Configura l'etichetta
   ObjectSetInteger(0, textName, OBJPROP_XDISTANCE, m_x + m_width / 2);
   ObjectSetInteger(0, textName, OBJPROP_YDISTANCE, m_y + m_height / 2);
   ObjectSetInteger(0, textName, OBJPROP_ANCHOR, ANCHOR_CENTER);
   ObjectSetInteger(0, textName, OBJPROP_COLOR, m_textColor);
   ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, m_fontSize);
   ObjectSetString(0, textName, OBJPROP_FONT, m_font);
   ObjectSetString(0, textName, OBJPROP_TEXT, m_text);
   ObjectSetInteger(0, textName, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, textName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, textName, OBJPROP_ZORDER, m_zOrder + 1);
   
   return true;
}

//+------------------------------------------------------------------+
//| Distrugge il pulsante                                            |
//+------------------------------------------------------------------+
void CButton::Destroy()
{
   ObjectDelete(0, m_name);
   ObjectDelete(0, m_name + "_text");
}

//+------------------------------------------------------------------+
//| Disegna il pulsante                                              |
//+------------------------------------------------------------------+
void CButton::Draw()
{
   if(!m_visible)
      return;
      
   // Imposta il colore di sfondo in base allo stato
   color bgColor = m_backgroundColor;
   if(m_pressed)
      bgColor = m_pressedColor;
   else if(m_hover)
      bgColor = m_hoverColor;
      
   ObjectSetInteger(0, m_name, OBJPROP_BGCOLOR, bgColor);
   
   // Aggiorna la posizione e le dimensioni
   ObjectSetInteger(0, m_name, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, m_name, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, m_name, OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, m_name, OBJPROP_YSIZE, m_height);
   
   // Aggiorna l'etichetta di testo
   string textName = m_name + "_text";
   ObjectSetInteger(0, textName, OBJPROP_XDISTANCE, m_x + m_width / 2);
   ObjectSetInteger(0, textName, OBJPROP_YDISTANCE, m_y + m_height / 2);
   ObjectSetInteger(0, textName, OBJPROP_COLOR, m_textColor);
   ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, m_fontSize);
   ObjectSetString(0, textName, OBJPROP_FONT, m_font);
   ObjectSetString(0, textName, OBJPROP_TEXT, m_text);
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pulsante                                 |
//+------------------------------------------------------------------+
bool CButton::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   if(!m_visible)
      return false;
      
   // Gestione del click
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == m_name)
   {
      m_pressed = true;
      Draw();
      OnClick();
      m_pressed = false;
      Draw();
      return true;
   }
   
   // Gestione del mouse hover
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      int x = (int)lparam;
      int y = (int)dparam;
      
      bool isHover = (x >= m_x && x <= m_x + m_width && y >= m_y && y <= m_y + m_height);
      
      if(isHover && !m_hover)
      {
         m_hover = true;
         Draw();
         OnMouseEnter();
         return true;
      }
      else if(!isHover && m_hover)
      {
         m_hover = false;
         Draw();
         OnMouseLeave();
         return true;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Evento click                                                     |
//+------------------------------------------------------------------+
void CButton::OnClick()
{
   // Da implementare nelle classi derivate o tramite callback
   Print("Button clicked: ", m_name);
}

//+------------------------------------------------------------------+
//| Evento mouse enter                                               |
//+------------------------------------------------------------------+
void CButton::OnMouseEnter()
{
   // Da implementare nelle classi derivate o tramite callback
}

//+------------------------------------------------------------------+
//| Evento mouse leave                                               |
//+------------------------------------------------------------------+
void CButton::OnMouseLeave()
{
   // Da implementare nelle classi derivate o tramite callback
}

//+------------------------------------------------------------------+
//| Imposta il testo del pulsante                                    |
//+------------------------------------------------------------------+
void CButton::Text(const string text)
{
   if(m_text == text)
      return;
      
   m_text = text;
   
   if(m_visible)
   {
      string textName = m_name + "_text";
      ObjectSetString(0, textName, OBJPROP_TEXT, m_text);
   }
}

//+------------------------------------------------------------------+
//| Imposta lo stato del pulsante                                    |
//+------------------------------------------------------------------+
void CButton::Pressed(const bool pressed)
{
   if(m_pressed == pressed)
      return;
      
   m_pressed = pressed;
   
   if(m_visible)
      Draw();
}

//+------------------------------------------------------------------+
//| Imposta la visibilità del pulsante                               |
//+------------------------------------------------------------------+
void CButton::Visible(const bool visible)
{
   if(m_visible == visible)
      return;
      
   m_visible = visible;
   
   ObjectSetInteger(0, m_name, OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   ObjectSetInteger(0, m_name + "_text", OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   
   if(visible)
      Draw();
}
//+------------------------------------------------------------------+
