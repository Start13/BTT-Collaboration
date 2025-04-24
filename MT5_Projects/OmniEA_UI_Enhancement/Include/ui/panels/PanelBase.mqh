//+------------------------------------------------------------------+
//|                                                   PanelBase.mqh |
//|                                      BlueTrendTeam Implementation |
//|                                 https://github.com/Start13/BTT-Collaboration |
//+------------------------------------------------------------------+
#property copyright "BlueTrendTeam"
#property link      "https://github.com/Start13/BTT-Collaboration"
#property version   "1.00"
#property strict

#include "..\controls\BaseControl.mqh"

//+------------------------------------------------------------------+
//| Classe base per tutti i pannelli                                 |
//+------------------------------------------------------------------+
class CPanelBase
{
protected:
   string            m_name;              // Nome del pannello
   CBaseControl     *m_controls[];        // Array di controlli
   int               m_controlCount;      // Numero di controlli
   bool              m_visible;           // Visibilità
   int               m_x, m_y;            // Posizione
   int               m_width, m_height;   // Dimensioni
   color             m_backgroundColor;   // Colore di sfondo
   color             m_borderColor;       // Colore del bordo
   string            m_title;             // Titolo del pannello
   bool              m_draggable;         // Pannello trascinabile
   bool              m_resizable;         // Pannello ridimensionabile
   
public:
                     CPanelBase();
   virtual          ~CPanelBase();
   
   // Creazione e distruzione
   virtual bool      Create(const string name, const int x = 20, const int y = 20, const int width = 300, const int height = 200);
   virtual void      Destroy();
   
   // Gestione controlli
   virtual bool      AddControl(CBaseControl *control);
   virtual bool      RemoveControl(const string name);
   virtual CBaseControl* GetControl(const string name);
   
   // Gestione eventi
   virtual bool      ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
   
   // Disegno
   virtual void      Draw();
   
   // Getters e Setters
   string            Name() const { return m_name; }
   void              Name(const string name) { m_name = name; }
   
   bool              Visible() const { return m_visible; }
   virtual void      Visible(const bool visible);
   
   int               X() const { return m_x; }
   void              X(const int x);
   
   int               Y() const { return m_y; }
   void              Y(const int y);
   
   int               Width() const { return m_width; }
   void              Width(const int width);
   
   int               Height() const { return m_height; }
   void              Height(const int height);
   
   color             BackgroundColor() const { return m_backgroundColor; }
   void              BackgroundColor(const color clr);
   
   color             BorderColor() const { return m_borderColor; }
   void              BorderColor(const color clr);
   
   string            Title() const { return m_title; }
   void              Title(const string title);
   
   bool              Draggable() const { return m_draggable; }
   void              Draggable(const bool draggable);
   
   bool              Resizable() const { return m_resizable; }
   void              Resizable(const bool resizable);
};

//+------------------------------------------------------------------+
//| Costruttore                                                      |
//+------------------------------------------------------------------+
CPanelBase::CPanelBase()
{
   m_name = "";
   m_controlCount = 0;
   m_visible = true;
   m_x = 20;
   m_y = 20;
   m_width = 300;
   m_height = 200;
   m_backgroundColor = clrWhiteSmoke;
   m_borderColor = clrGray;
   m_title = "Panel";
   m_draggable = true;
   m_resizable = false;
}

//+------------------------------------------------------------------+
//| Distruttore                                                      |
//+------------------------------------------------------------------+
CPanelBase::~CPanelBase()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Crea il pannello                                                 |
//+------------------------------------------------------------------+
bool CPanelBase::Create(const string name, const int x = 20, const int y = 20, const int width = 300, const int height = 200)
{
   m_name = name;
   m_x = x;
   m_y = y;
   m_width = width;
   m_height = height;
   
   // Crea l'oggetto grafico del pannello
   if(!ObjectCreate(0, m_name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione del pannello: ", GetLastError());
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
   ObjectSetInteger(0, m_name, OBJPROP_ZORDER, 0);
   
   // Crea la barra del titolo
   string titleBarName = m_name + "_titlebar";
   if(!ObjectCreate(0, titleBarName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione della barra del titolo: ", GetLastError());
      Destroy();
      return false;
   }
   
   // Configura la barra del titolo
   ObjectSetInteger(0, titleBarName, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, titleBarName, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, titleBarName, OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, titleBarName, OBJPROP_YSIZE, 25);
   ObjectSetInteger(0, titleBarName, OBJPROP_BGCOLOR, m_borderColor);
   ObjectSetInteger(0, titleBarName, OBJPROP_BORDER_COLOR, m_borderColor);
   ObjectSetInteger(0, titleBarName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, titleBarName, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, titleBarName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, titleBarName, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, titleBarName, OBJPROP_ZORDER, 1);
   
   // Crea l'etichetta del titolo
   string titleName = m_name + "_title";
   if(!ObjectCreate(0, titleName, OBJ_LABEL, 0, 0, 0))
   {
      Print("Errore nella creazione dell'etichetta del titolo: ", GetLastError());
      Destroy();
      return false;
   }
   
   // Configura l'etichetta del titolo
   ObjectSetInteger(0, titleName, OBJPROP_XDISTANCE, m_x + 10);
   ObjectSetInteger(0, titleName, OBJPROP_YDISTANCE, m_y + 15);
   ObjectSetInteger(0, titleName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, titleName, OBJPROP_FONTSIZE, 10);
   ObjectSetString(0, titleName, OBJPROP_FONT, "Arial");
   ObjectSetString(0, titleName, OBJPROP_TEXT, m_title);
   ObjectSetInteger(0, titleName, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, titleName, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, titleName, OBJPROP_ZORDER, 2);
   
   // Crea il pulsante di chiusura
   string closeBtnName = m_name + "_close";
   if(!ObjectCreate(0, closeBtnName, OBJ_BUTTON, 0, 0, 0))
   {
      Print("Errore nella creazione del pulsante di chiusura: ", GetLastError());
      Destroy();
      return false;
   }
   
   // Configura il pulsante di chiusura
   ObjectSetInteger(0, closeBtnName, OBJPROP_XDISTANCE, m_x + m_width - 25);
   ObjectSetInteger(0, closeBtnName, OBJPROP_YDISTANCE, m_y + 5);
   ObjectSetInteger(0, closeBtnName, OBJPROP_XSIZE, 20);
   ObjectSetInteger(0, closeBtnName, OBJPROP_YSIZE, 15);
   ObjectSetInteger(0, closeBtnName, OBJPROP_BGCOLOR, clrRed);
   ObjectSetInteger(0, closeBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closeBtnName, OBJPROP_BORDER_COLOR, clrDarkRed);
   ObjectSetString(0, closeBtnName, OBJPROP_TEXT, "X");
   ObjectSetInteger(0, closeBtnName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, closeBtnName, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, closeBtnName, OBJPROP_ZORDER, 3);
   
   return true;
}

//+------------------------------------------------------------------+
//| Distrugge il pannello                                            |
//+------------------------------------------------------------------+
void CPanelBase::Destroy()
{
   // Distrugge tutti i controlli
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL)
      {
         delete m_controls[i];
         m_controls[i] = NULL;
      }
   }
   
   m_controlCount = 0;
   ArrayFree(m_controls);
   
   // Distrugge gli oggetti del pannello
   ObjectDelete(0, m_name);
   ObjectDelete(0, m_name + "_titlebar");
   ObjectDelete(0, m_name + "_title");
   ObjectDelete(0, m_name + "_close");
}

//+------------------------------------------------------------------+
//| Aggiunge un controllo al pannello                                |
//+------------------------------------------------------------------+
bool CPanelBase::AddControl(CBaseControl *control)
{
   if(control == NULL)
      return false;
      
   // Ridimensiona l'array
   int newSize = m_controlCount + 1;
   if(ArrayResize(m_controls, newSize) != newSize)
   {
      Print("Errore nel ridimensionamento dell'array dei controlli");
      return false;
   }
   
   // Aggiunge il controllo
   m_controls[m_controlCount] = control;
   m_controlCount++;
   
   return true;
}

//+------------------------------------------------------------------+
//| Rimuove un controllo dal pannello                                |
//+------------------------------------------------------------------+
bool CPanelBase::RemoveControl(const string name)
{
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL && m_controls[i].Name() == name)
      {
         // Distrugge il controllo
         delete m_controls[i];
         
         // Sposta gli altri controlli
         for(int j = i; j < m_controlCount - 1; j++)
            m_controls[j] = m_controls[j + 1];
            
         // Ridimensiona l'array
         m_controlCount--;
         ArrayResize(m_controls, m_controlCount);
         
         return true;
      }
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Ottiene un controllo dal pannello                                |
//+------------------------------------------------------------------+
CBaseControl* CPanelBase::GetControl(const string name)
{
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL && m_controls[i].Name() == name)
         return m_controls[i];
   }
   
   return NULL;
}

//+------------------------------------------------------------------+
//| Gestisce gli eventi del pannello                                 |
//+------------------------------------------------------------------+
bool CPanelBase::ProcessEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
   if(!m_visible)
      return false;
      
   // Gestione del pulsante di chiusura
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == m_name + "_close")
   {
      Visible(false);
      return true;
   }
   
   // Gestione del trascinamento
   if(m_draggable && id == CHARTEVENT_OBJECT_DRAG && (sparam == m_name + "_titlebar" || sparam == m_name + "_title"))
   {
      int x = (int)ObjectGetInteger(0, m_name + "_titlebar", OBJPROP_XDISTANCE);
      int y = (int)ObjectGetInteger(0, m_name + "_titlebar", OBJPROP_YDISTANCE);
      
      if(x != m_x || y != m_y)
      {
         X(x);
         Y(y);
         return true;
      }
   }
   
   // Passa l'evento ai controlli
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL && m_controls[i].ProcessEvent(id, lparam, dparam, sparam))
         return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Disegna il pannello                                              |
//+------------------------------------------------------------------+
void CPanelBase::Draw()
{
   if(!m_visible)
      return;
      
   // Aggiorna il pannello
   ObjectSetInteger(0, m_name, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, m_name, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, m_name, OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, m_name, OBJPROP_YSIZE, m_height);
   ObjectSetInteger(0, m_name, OBJPROP_BGCOLOR, m_backgroundColor);
   ObjectSetInteger(0, m_name, OBJPROP_BORDER_COLOR, m_borderColor);
   
   // Aggiorna la barra del titolo
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_XSIZE, m_width);
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_BGCOLOR, m_borderColor);
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_BORDER_COLOR, m_borderColor);
   
   // Aggiorna l'etichetta del titolo
   ObjectSetInteger(0, m_name + "_title", OBJPROP_XDISTANCE, m_x + 10);
   ObjectSetInteger(0, m_name + "_title", OBJPROP_YDISTANCE, m_y + 15);
   ObjectSetString(0, m_name + "_title", OBJPROP_TEXT, m_title);
   
   // Aggiorna il pulsante di chiusura
   ObjectSetInteger(0, m_name + "_close", OBJPROP_XDISTANCE, m_x + m_width - 25);
   ObjectSetInteger(0, m_name + "_close", OBJPROP_YDISTANCE, m_y + 5);
}

//+------------------------------------------------------------------+
//| Imposta la visibilità del pannello                               |
//+------------------------------------------------------------------+
void CPanelBase::Visible(const bool visible)
{
   if(m_visible == visible)
      return;
      
   m_visible = visible;
   
   // Imposta la visibilità degli oggetti del pannello
   ObjectSetInteger(0, m_name, OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   ObjectSetInteger(0, m_name + "_title", OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   ObjectSetInteger(0, m_name + "_close", OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
   
   // Imposta la visibilità dei controlli
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL)
         m_controls[i].Visible(visible);
   }
   
   if(visible)
      Draw();
}

//+------------------------------------------------------------------+
//| Imposta la posizione X del pannello                              |
//+------------------------------------------------------------------+
void CPanelBase::X(const int x)
{
   if(m_x == x)
      return;
      
   int deltaX = x - m_x;
   m_x = x;
   
   if(m_visible)
      Draw();
      
   // Aggiorna la posizione dei controlli
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL)
         m_controls[i].X(m_controls[i].X() + deltaX);
   }
}

//+------------------------------------------------------------------+
//| Imposta la posizione Y del pannello                              |
//+------------------------------------------------------------------+
void CPanelBase::Y(const int y)
{
   if(m_y == y)
      return;
      
   int deltaY = y - m_y;
   m_y = y;
   
   if(m_visible)
      Draw();
      
   // Aggiorna la posizione dei controlli
   for(int i = 0; i < m_controlCount; i++)
   {
      if(m_controls[i] != NULL)
         m_controls[i].Y(m_controls[i].Y() + deltaY);
   }
}

//+------------------------------------------------------------------+
//| Imposta la larghezza del pannello                                |
//+------------------------------------------------------------------+
void CPanelBase::Width(const int width)
{
   if(m_width == width || width < 100)
      return;
      
   m_width = width;
   
   if(m_visible)
      Draw();
}

//+------------------------------------------------------------------+
//| Imposta l'altezza del pannello                                   |
//+------------------------------------------------------------------+
void CPanelBase::Height(const int height)
{
   if(m_height == height || height < 50)
      return;
      
   m_height = height;
   
   if(m_visible)
      Draw();
}

//+------------------------------------------------------------------+
//| Imposta il colore di sfondo del pannello                         |
//+------------------------------------------------------------------+
void CPanelBase::BackgroundColor(const color clr)
{
   if(m_backgroundColor == clr)
      return;
      
   m_backgroundColor = clr;
   
   if(m_visible)
      ObjectSetInteger(0, m_name, OBJPROP_BGCOLOR, m_backgroundColor);
}

//+------------------------------------------------------------------+
//| Imposta il colore del bordo del pannello                         |
//+------------------------------------------------------------------+
void CPanelBase::BorderColor(const color clr)
{
   if(m_borderColor == clr)
      return;
      
   m_borderColor = clr;
   
   if(m_visible)
   {
      ObjectSetInteger(0, m_name, OBJPROP_BORDER_COLOR, m_borderColor);
      ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_BGCOLOR, m_borderColor);
      ObjectSetInteger(0, m_name + "_titlebar", OBJPROP_BORDER_COLOR, m_borderColor);
   }
}

//+------------------------------------------------------------------+
//| Imposta il titolo del pannello                                   |
//+------------------------------------------------------------------+
void CPanelBase::Title(const string title)
{
   if(m_title == title)
      return;
      
   m_title = title;
   
   if(m_visible)
      ObjectSetString(0, m_name + "_title", OBJPROP_TEXT, m_title);
}

//+------------------------------------------------------------------+
//| Imposta se il pannello è trascinabile                            |
//+------------------------------------------------------------------+
void CPanelBase::Draggable(const bool draggable)
{
   m_draggable = draggable;
}

//+------------------------------------------------------------------+
//| Imposta se il pannello è ridimensionabile                        |
//+------------------------------------------------------------------+
void CPanelBase::Resizable(const bool resizable)
{
   m_resizable = resizable;
   
   // Implementazione del ridimensionamento da aggiungere in futuro
}
//+------------------------------------------------------------------+
