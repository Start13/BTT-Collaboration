//+------------------------------------------------------------------+
//| BTT_Panels.mqh - Panel management for OmniEA                     |
//| Copyright 2025, BlueTrendTeam                                    |
//| https://www.mql5.com                                             |
//+------------------------------------------------------------------+
#property strict

#include <AIDeepSeek\BlueTrendTeam\BTT_Utilities.mqh>

//+------------------------------------------------------------------+
//| Panel tracking structure                                         |
//+------------------------------------------------------------------+
struct PanelElement
{
   string name;
   int    x;
   int    y;
   int    width;
   int    height;
   color  bgColor;
   color  borderColor;
   string text;
};

//+------------------------------------------------------------------+
//| Drag & drop tracking structure                                   |
//+------------------------------------------------------------------+
struct DragDropTracker
{
   bool     isActive;
   datetime startTime;
   int      blinkStage;
   string   indicatorName;
   int      targetBox;
};

//+------------------------------------------------------------------+
//| CBTT_Panels class                                                |
//+------------------------------------------------------------------+
class CBTT_Panels
{
private:
   PanelElement    m_mainPanel;
   PanelElement    m_header;
   PanelElement    m_infoPanel;
   PanelElement    m_tradePanel;
   PanelElement    m_signalPanel;
   
   DragDropTracker m_dragTracker;
   
   string         m_addIndicatorBtn;
   string         m_indicatorBoxes[3];
   string         m_removeButtons[3];
   
   color          m_panelColor;
   color          m_textColor;
   
   // Timer variables
   bool           m_isBlinking;
   int            m_blinkCounter;
   int            m_blinkTarget;
   color          m_originalColor;

public:
   // Constructor
   CBTT_Panels() : m_panelColor(clrRoyalBlue), m_textColor(clrWhite),
                   m_isBlinking(false), m_blinkCounter(0), m_blinkTarget(-1)
   {
      m_dragTracker.isActive = false;
      m_dragTracker.startTime = 0;
      m_dragTracker.blinkStage = 0;
      m_dragTracker.indicatorName = "";
      m_dragTracker.targetBox = -1;
      
      // Initialize panel elements
      InitializeElements();
   }
   
   // Initialize panel elements
   void InitializeElements()
   {
      // Main panel
      m_mainPanel.name = "BTT_Panel_Main";
      m_mainPanel.x = 10;
      m_mainPanel.y = 10;
      m_mainPanel.width = 800;
      m_mainPanel.height = 600;
      m_mainPanel.bgColor = m_panelColor;
      m_mainPanel.borderColor = clrBlack;
      m_mainPanel.text = "";
      
      // Header
      m_header.name = "BTT_Panel_Header";
      m_header.x = 20;
      m_header.y = 20;
      m_header.width = 760;
      m_header.height = 40;
      m_header.bgColor = m_panelColor;
      m_header.borderColor = clrNONE;
      m_header.text = "OMNIEA LITE v1.0 by BTT";
      
      // Info panel
      m_infoPanel.name = "BTT_Panel_Info";
      m_infoPanel.x = 20;
      m_infoPanel.y = 70;
      m_infoPanel.width = 200;
      m_infoPanel.height = 200;
      m_infoPanel.bgColor = m_panelColor;
      m_infoPanel.borderColor = clrSilver;
      m_infoPanel.text = "";
      
      // Trade panel
      m_tradePanel.name = "BTT_Panel_Trade";
      m_tradePanel.x = 240;
      m_tradePanel.y = 70;
      m_tradePanel.width = 400;
      m_tradePanel.height = 300;
      m_tradePanel.bgColor = m_panelColor;
      m_tradePanel.borderColor = clrSilver;
      m_tradePanel.text = "";
      
      // Signal panel
      m_signalPanel.name = "BTT_Panel_Signal";
      m_signalPanel.x = 20;
      m_signalPanel.y = 280;
      m_signalPanel.width = 760;
      m_signalPanel.height = 300;
      m_signalPanel.bgColor = m_panelColor;
      m_signalPanel.borderColor = clrSilver;
      m_signalPanel.text = "";
      
      // Indicator boxes
      m_indicatorBoxes[0] = "BTT_Indicator1";
      m_indicatorBoxes[1] = "BTT_Indicator2";
      m_indicatorBoxes[2] = "BTT_IndicatorExt1";
      
      // Remove buttons
      m_removeButtons[0] = "BTT_RemoveIndicator1";
      m_removeButtons[1] = "BTT_RemoveIndicator2";
      m_removeButtons[2] = "BTT_RemoveIndicatorExt1";
      
      // Add indicator button
      m_addIndicatorBtn = "BTT_Btn_AddIndicator";
   }
   
   // Create all panels
   bool CreatePanels(color panelColor, color textColor)
   {
      m_panelColor = panelColor;
      m_textColor = textColor;
      
      // Create main panel
      if(!CreatePanel(m_mainPanel))
         return false;
      
      // Create header
      if(!CreateHeader())
         return false;
      
      // Create info panel
      if(!CreateInfoPanel())
         return false;
      
      // Create trade panel
      if(!CreateTradePanel())
         return false;
      
      // Create signal panel
      if(!CreateSignalPanel())
         return false;
      
      // Create add indicator button
      if(!CreateAddIndicatorButton())
         return false;
      
      // Create indicator boxes
      for(int i = 0; i < 3; i++)
      {
         if(!CreateIndicatorBox(i))
            return false;
      }
      
      // Create remove buttons
      for(int i = 0; i < 3; i++)
      {
         if(!CreateRemoveButton(i))
            return false;
      }
      
      return true;
   }
   
   // Delete all panels
   void DeletePanels()
   {
      ObjectsDeleteAll(0, "BTT_");
   }
   
   // Save panel configuration
   void SaveConfiguration()
   {
      // TODO: Implement configuration saving
   }
   
   // Update account information
   void UpdateAccountInfo()
   {
      string infoText = StringFormat("Broker: %s\nAccount: %d\nBalance: %.2f\nEquity: %.2f",
                                    AccountInfoString(ACCOUNT_COMPANY),
                                    AccountInfoInteger(ACCOUNT_LOGIN),
                                    AccountInfoDouble(ACCOUNT_BALANCE),
                                    AccountInfoDouble(ACCOUNT_EQUITY));
      
      ObjectSetString(0, m_infoPanel.name + "_Text", OBJPROP_TEXT, infoText);
   }
   
   // Update market information
   void UpdateMarketInfo()
   {
      string marketText = StringFormat("Symbol: %s\nSpread: %.1f\nTime: %s",
                                      Symbol(),
                                      MarketInfo(Symbol(), MODE_SPREAD),
                                      TimeToString(TimeCurrent(), TIME_MINUTES|TIME_SECONDS));
      
      ObjectSetString(0, m_infoPanel.name + "_MarketText", OBJPROP_TEXT, marketText);
   }
   
   // Handle drag and drop
   void HandleDragDrop()
   {
      if(!m_dragTracker.isActive)
         return;
      
      // Handle blinking effect
      if(TimeCurrent() - m_dragTracker.startTime < 10) // 10-second countdown
      {
         int secondsLeft = 10 - (int)(TimeCurrent() - m_dragTracker.startTime);
         string btnText = StringFormat("Drag indicator\nTime left: %ds", secondsLeft);
         ObjectSetString(0, m_addIndicatorBtn, OBJPROP_TEXT, btnText);
         
         // Blinking effect
         if((int)TimeCurrent() % 2 == 0)
            ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, clrLightBlue);
         else
            ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, m_panelColor);
      }
      else
      {
         // Timeout
         m_dragTracker.isActive = false;
         ObjectSetString(0, m_addIndicatorBtn, OBJPROP_TEXT, "Add Indicator");
         ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, m_panelColor);
      }
   }
   
   // Start drag and drop process
   void StartDragDrop(int targetBox)
   {
      m_dragTracker.isActive = true;
      m_dragTracker.startTime = TimeCurrent();
      m_dragTracker.targetBox = targetBox;
      
      // Show informational message
      int answer = MessageBox("To add an indicator to OmniEA:\n1. Press 'Add Indicator' button\n2. Drag indicator from Navigator to chart",
                             "Information", MB_YESNO|MB_ICONINFORMATION);
      
      // Save user preference
      if(answer == IDNO)
      {
         // User doesn't want to see this message again
         // (should save this preference in a file or global variable)
      }
   }
   
   // Add detected indicator
   void AddIndicator(string indicatorName)
   {
      if(!m_dragTracker.isActive || m_dragTracker.targetBox < 0)
         return;
         
      m_dragTracker.isActive = false;
      m_dragTracker.indicatorName = indicatorName;
      
      // Update corresponding box
      UpdateIndicatorBox(m_dragTracker.targetBox, indicatorName);
      
      // Visual feedback
      ObjectSetString(0, m_addIndicatorBtn, OBJPROP_TEXT, indicatorName);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, clrLimeGreen);
      
      // Start blinking the box
      StartBoxBlinking(m_dragTracker.targetBox);
      
      EventSetTimer(2);
   }
   
   // Handle chart events
   void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      // Handle button clicks
      if(id == CHARTEVENT_OBJECT_CLICK)
      {
         // Add indicator button
         if(sparam == m_addIndicatorBtn)
         {
            // Default to external indicator box
            StartDragDrop(2);
         }
         
         // Remove indicator buttons
         for(int i = 0; i < 3; i++)
         {
            if(sparam == m_removeButtons[i])
            {
               RemoveIndicator(i);
               break;
            }
         }
      }
      
      // Handle drag and drop
      if(id == CHARTEVENT_DROP)
      {
         if(m_dragTracker.isActive)
         {
            AddIndicator(sparam);
         }
      }
   }
   
   // Handle timer events
   void OnTimer()
   {
      // Reset add indicator button after showing indicator name
      ObjectSetString(0, m_addIndicatorBtn, OBJPROP_TEXT, "Add Indicator");
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, m_panelColor);
      
      EventKillTimer();
   }

private:
   // Create panel element
   bool CreatePanel(const PanelElement &element)
   {
      if(!ObjectCreate(0, element.name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, element.name, OBJPROP_XDISTANCE, element.x);
      ObjectSetInteger(0, element.name, OBJPROP_YDISTANCE, element.y);
      ObjectSetInteger(0, element.name, OBJPROP_XSIZE, element.width);
      ObjectSetInteger(0, element.name, OBJPROP_YSIZE, element.height);
      ObjectSetInteger(0, element.name, OBJPROP_BGCOLOR, element.bgColor);
      ObjectSetInteger(0, element.name, OBJPROP_BORDER_COLOR, element.borderColor);
      
      return true;
   }
   
   // Create header
   bool CreateHeader()
   {
      if(!ObjectCreate(0, m_header.name + "_Text", OBJ_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetString(0, m_header.name + "_Text", OBJPROP_TEXT, m_header.text);
      ObjectSetInteger(0, m_header.name + "_Text", OBJPROP_XDISTANCE, m_header.x);
      ObjectSetInteger(0, m_header.name + "_Text", OBJPROP_YDISTANCE, m_header.y);
      ObjectSetInteger(0, m_header.name + "_Text", OBJPROP_COLOR, m_textColor);
      ObjectSetInteger(0, m_header.name + "_Text", OBJPROP_FONTSIZE, 12);
      
      return true;
   }
   
   // Create info panel
   bool CreateInfoPanel()
   {
      if(!CreatePanel(m_infoPanel))
         return false;
      
      // Account info text
      if(!ObjectCreate(0, m_infoPanel.name + "_Text", OBJ_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, m_infoPanel.name + "_Text", OBJPROP_XDISTANCE, m_infoPanel.x + 10);
      ObjectSetInteger(0, m_infoPanel.name + "_Text", OBJPROP_YDISTANCE, m_infoPanel.y + 10);
      ObjectSetInteger(0, m_infoPanel.name + "_Text", OBJPROP_COLOR, m_textColor);
      
      // Market info text
      if(!ObjectCreate(0, m_infoPanel.name + "_MarketText", OBJ_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, m_infoPanel.name + "_MarketText", OBJPROP_XDISTANCE, m_infoPanel.x + 10);
      ObjectSetInteger(0, m_infoPanel.name + "_MarketText", OBJPROP_YDISTANCE, m_infoPanel.y + 100);
      ObjectSetInteger(0, m_infoPanel.name + "_MarketText", OBJPROP_COLOR, m_textColor);
      
      return true;
   }
   
   // Create trade panel
   bool CreateTradePanel()
   {
      if(!CreatePanel(m_tradePanel))
         return false;
      
      // Add trade settings controls here
      
      return true;
   }
   
   // Create signal panel
   bool CreateSignalPanel()
   {
      if(!CreatePanel(m_signalPanel))
         return false;
      
      // Add signal controls here
      
      return true;
   }
   
   // Create add indicator button
   bool CreateAddIndicatorButton()
   {
      if(!ObjectCreate(0, m_addIndicatorBtn, OBJ_BUTTON, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_XDISTANCE, m_tradePanel.x + m_tradePanel.width/2 - 75);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_YDISTANCE, m_tradePanel.y + m_tradePanel.height - 50);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_XSIZE, 150);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_YSIZE, 40);
      ObjectSetString(0, m_addIndicatorBtn, OBJPROP_TEXT, "Add Indicator");
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_COLOR, m_textColor);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BGCOLOR, m_panelColor);
      ObjectSetInteger(0, m_addIndicatorBtn, OBJPROP_BORDER_COLOR, m_textColor);
      
      return true;
   }
   
   // Create indicator box
   bool CreateIndicatorBox(int index)
   {
      string boxName = m_indicatorBoxes[index];
      int yPos = m_signalPanel.y + 30 + (index * 40);
      
      // Create box background
      if(!ObjectCreate(0, boxName, OBJ_RECTANGLE_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, boxName, OBJPROP_XDISTANCE, m_signalPanel.x + 20);
      ObjectSetInteger(0, boxName, OBJPROP_YDISTANCE, yPos);
      ObjectSetInteger(0, boxName, OBJPROP_XSIZE, 200);
      ObjectSetInteger(0, boxName, OBJPROP_YSIZE, 30);
      ObjectSetInteger(0, boxName, OBJPROP_BGCOLOR, m_panelColor);
      ObjectSetInteger(0, boxName, OBJPROP_BORDER_COLOR, (index == 2) ? clrGreen : clrBlue);
      ObjectSetInteger(0, boxName, OBJPROP_BORDER_TYPE, BORDER_SUNKEN);
      
      // Create box text
      if(!ObjectCreate(0, boxName + "_Text", OBJ_LABEL, 0, 0, 0))
         return false;
      
      ObjectSetString(0, boxName + "_Text", OBJPROP_TEXT, (index == 2) ? "Indicator Ext 1" : StringFormat("Indicator %d", index+1));
      ObjectSetInteger(0, boxName + "_Text", OBJPROP_XDISTANCE, m_signalPanel.x + 30);
      ObjectSetInteger(0, boxName + "_Text", OBJPROP_YDISTANCE, yPos + 8);
      ObjectSetInteger(0, boxName + "_Text", OBJPROP_COLOR, m_textColor);
      
      return true;
   }
   
   // Create remove button
   bool CreateRemoveButton(int index)
   {
      string btnName = m_removeButtons[index];
      int yPos = m_signalPanel.y + 30 + (index * 40);
      
      if(!ObjectCreate(0, btnName, OBJ_BUTTON, 0, 0, 0))
         return false;
      
      ObjectSetInteger(0, btnName, OBJPROP_XDISTANCE, m_signalPanel.x + 230);
      ObjectSetInteger(0, btnName, OBJPROP_YDISTANCE, yPos);
      ObjectSetInteger(0, btnName, OBJPROP_XSIZE, 20);
      ObjectSetInteger(0, btnName, OBJPROP_YSIZE, 20);
      ObjectSetString(0, btnName, OBJPROP_TEXT, "X");
      ObjectSetInteger(0, btnName, OBJPROP_COLOR, clrRed);
      ObjectSetInteger(0, btnName, OBJPROP_BGCOLOR, m_panelColor);
      
      return true;
   }
   
   // Update indicator box
   void UpdateIndicatorBox(int index, string indicatorName)
   {
      if(index < 0 || index >= ArraySize(m_indicatorBoxes))
         return;
         
      string boxName = m_indicatorBoxes[index];
      string prefix = (index == 2) ? "Ext: " : "";
      
      ObjectSetString(0, boxName + "_Text", OBJPROP_TEXT, prefix + indicatorName);
   }
   
   // Remove indicator
   void RemoveIndicator(int index)
   {
      if(index < 0 || index >= ArraySize(m_indicatorBoxes))
         return;
         
      string defaultText = (index == 2) ? "Indicator Ext 1" : StringFormat("Indicator %d", index+1);
      ObjectSetString(0, m_indicatorBoxes[index] + "_Text", OBJPROP_TEXT, defaultText);
   }
   
   // Start box blinking
   void StartBoxBlinking(int index)
   {
      if(index < 0 || index >= ArraySize(m_indicatorBoxes))
         return;
         
      m_isBlinking = true;
      m_blinkCounter = 0;
      m_blinkTarget = index;
      m_originalColor = ObjectGetInteger(0, m_indicatorBoxes[index], OBJPROP_BORDER_COLOR);
      
      EventSetMillisecondTimer(250);
   }
   
   // Handle blinking timer
   void HandleBlinking()
   {
      if(!m_isBlinking || m_blinkTarget < 0)
         return;
         
      if(m_blinkCounter < 8) // 2 seconds (250ms * 8)
      {
         string boxName = m_indicatorBoxes[m_blinkTarget];
         color blinkColor = (m_blinkCounter % 2 == 0) ? clrYellow : m_originalColor;
         ObjectSetInteger(0, boxName, OBJPROP_BORDER_COLOR, blinkColor);
         m_blinkCounter++;
      }
      else
      {
         m_isBlinking = false;
         string boxName = m_indicatorBoxes[m_blinkTarget];
         ObjectSetInteger(0, boxName, OBJPROP_BORDER_COLOR, m_originalColor);
         EventKillTimer();
      }
   }
};