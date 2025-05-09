//+------------------------------------------------------------------+
//|                                              PanelDispatcher.mqh |
//|                                                     Igor Volodin |
//|                                       http://www.thefatpanel.com |
//+------------------------------------------------------------------+
#property copyright "Igor Volodin"
#property link      "http://www.thefatpanel.com"
#property version   "1.00"

#define INTERFACE_MODE_CHART	0
#define INTERFACE_MODE_WINDOW	1
#define INTERFACE_STEP	10000
#define PANEL_CONTAINER "Fatpanel\\panel"
//+------------------------------------------------------------------+
class CPanelButton: public CObject 
  {
public:
   string            name,title,classn;
   int               width,height,corner,windowHandle,size,x,y,colour,bgcolour;
   void CPanelButton() 
     {
      size=8;
      windowHandle=0;
      colour=Black;
      bgcolour=WhiteSmoke;
     }

   void draw(int x,int y) 
     {
      if(ObjectFind(0,name)<0) { ObjectDelete(0,name); }
      ObjectCreate(0,name,OBJ_BUTTON,(int) windowHandle,0,0);
      ObjectSetString(0,name,OBJPROP_TEXT,title);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bgcolour);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);
     }

  };
//+------------------------------------------------------------------+
class CPanelInput: public CObject 
  {
public:
   string            name,title,classn,text;
   int               width,height,corner,windowHandle,size,x,y,colour,bgcolour;
   void CPanelInput() 
     {
      size=8;
      windowHandle=0;
      colour=Black;
      bgcolour=WhiteSmoke;
     }

   void draw() 
     {
      if(ObjectFind(0,name)<0) { ObjectDelete(0,name); }
      ObjectCreate(0,name,OBJ_EDIT,(int) windowHandle,0,0);
      ObjectSetString(0,name,OBJPROP_TEXT,text);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bgcolour);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);

      string pname=name+"_label";
      ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
      ObjectSetString(0,pname,OBJPROP_TEXT,title);
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,(int)(y-size*1.5));
      ObjectSetInteger(0,pname,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,pname,OBJPROP_COLOR,colour);
      ObjectSetString(0,pname,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,pname,OBJPROP_FONTSIZE,size);
     }

   string value() 
     {
      text=ObjectGetString(0,name,OBJPROP_TEXT);
      return(text);
     }

  };
//+------------------------------------------------------------------+
class CPanelLegend: public CObject 
  {
public:
   string            name,title,classn,text;
   int               width,height,corner,windowHandle,size,x,y,colour,bgcolour;
   void CPanelLegend() 
     {
      size=8;
      windowHandle=0;
      colour=Black;
     }

   void draw() 
     {
      //title
      if(ObjectFind(0,name)<0) { ObjectDelete(0,name); }
      ObjectCreate(0,name,OBJ_LABEL,(int) windowHandle,0,0);
      ObjectSetString(0,name,OBJPROP_TEXT,title);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bgcolour);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);

      //data
      string pname=name+"_data";
      if(ObjectFind(0,pname)<0) { ObjectDelete(0,pname); }
      ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
      ObjectSetString(0,pname,OBJPROP_TEXT,text);
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,x+width);
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,pname,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,pname,OBJPROP_COLOR,colour);
      ObjectSetString(0,pname,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,pname,OBJPROP_FONTSIZE,size);
     }

  };
//+------------------------------------------------------------------+
class CPanelTab: public CObject 
  {
protected:
   CList             buttons;
   CList             inputs;
   CList             panels;
   CList             legends;
   bool              initialize;
public:
   bool              controlsCreated;
   CPanelTab        *holder;
   string            name,nameBack,title,tabBmp,tabBmpCommon;
   bool              isAct,showMode;
   int               X,Y,Xs,Ys,tabColor,buttonPos,buttonWidth,buttonHeight,bodyWidth,bodyHeight,size,back,bgColor,corner;
   int               windowHandle;
   void CPanelTab() 
     {
      initialize=false;
      title = "Unnamed";
      isAct = false;
      buttonWidth=88;
      buttonHeight=23;
      buttonPos = 0;
      bodyWidth = 10000;
      bodyHeight= 10000;
      size=8;
      bgColor=WhiteSmoke;
      X=0; Y=0; Xs=0; Ys=0;
      back=0;
      controlsCreated=false;
      showMode=false;
     }
   void ~CPanelTab()
     {
     }

protected:
   virtual void init()
     {
     }

   void createButton() 
     {
      if(ObjectFind(0,name)<0) 
        {
         ObjectCreate(0,name,OBJ_BUTTON,(int) windowHandle,0,0);
        }
      ObjectSetString(0,name,OBJPROP_TEXT,title);
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,X+getCornerDirection()*(Xs+buttonPos));
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,Y+Ys);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,buttonWidth);
      ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,buttonHeight);
      ObjectSetInteger(0,name,OBJPROP_COLOR,Black);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,tabColor);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
     }

   void createBack() 
     {
      nameBack=name+"_back";
      string lname=nameBack;
      if(ObjectFind(0,lname)<0) 
        {
         ObjectCreate(0,lname,OBJ_EDIT,(int) windowHandle,0,0);
        }
      ObjectSetInteger(0,lname,OBJPROP_XDISTANCE,X);
      ObjectSetInteger(0,lname,OBJPROP_YDISTANCE,Y+buttonHeight+Ys);
      ObjectSetInteger(0,lname,OBJPROP_YSIZE,bodyHeight);
      ObjectSetInteger(0,lname,OBJPROP_XSIZE,bodyWidth);
      ObjectSetInteger(0,lname,OBJPROP_WIDTH,1);
      ObjectSetInteger(0,lname,OBJPROP_CORNER,corner);
      ObjectSetInteger(0,lname,OBJPROP_STATE,1);
      ObjectSetInteger(0,lname,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(0,lname,OBJPROP_READONLY,1);
      ObjectSetInteger(0,lname,OBJPROP_BACK,back);
      ObjectSetInteger(0,lname,OBJPROP_COLOR,DarkGray);
      ObjectSetInteger(0,lname,OBJPROP_BORDER_TYPE,3);
      ObjectSetInteger(0,lname,OBJPROP_BGCOLOR,bgColor);
     }

   int getCornerDirection() 
     {
      if(corner==CORNER_RIGHT_LOWER || corner==CORNER_RIGHT_UPPER) 
        {
         return(-1);
        }
      return(1);
     }

public:
   void show() 
     {
      if(!initialize) 
        {
         init();
        }
      createButton();
      ObjectSetInteger(0,name,OBJPROP_STATE,1);

      int bmpShift=X;

      if(StringLen(tabBmpCommon)>0) 
        {
         string pname=name+"_bgcommon";
         if(ObjectFind(0,pname)>0) ObjectDelete(0,pname);
         ObjectCreate(0,pname,OBJ_BITMAP_LABEL,windowHandle,0,0);
         ObjectSetInteger(0,pname,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,X);
         ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,Y);
         ObjectSetString(0,pname,OBJPROP_BMPFILE,1,tabBmpCommon);
         ObjectSetString(0,pname,OBJPROP_BMPFILE,0,tabBmpCommon);
         ObjectSetInteger(0,pname,OBJPROP_CORNER,corner);
         bmpShift=X+getCornerDirection()*buttonPos;
        }

      if(StringLen(tabBmp)>0) 
        {
         string pname=name+"_bg";
         if(ObjectFind(0,pname)>0) ObjectDelete(0,pname);
         ObjectCreate(0,pname,OBJ_BITMAP_LABEL,windowHandle,0,0);
         ObjectSetInteger(0,pname,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,bmpShift);
         ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,Y);
         ObjectSetString(0,pname,OBJPROP_BMPFILE,1,tabBmp);
         ObjectSetString(0,pname,OBJPROP_BMPFILE,0,tabBmp);
         ObjectSetInteger(0,pname,OBJPROP_CORNER,corner);
        }

      isAct=true;
      if(!controlsCreated) 
        {
         createBack();
         onControlsCreate();
         controlsCreated=true;
         showMode=true;
           } else {
         if(!showMode) 
           {
            int c=ObjectsTotal(0,windowHandle);
            for(int i=c-1; i>=0; i--) 
              {
               string pname=ObjectName(0,i,windowHandle);
               if(StringFind(pname,name)!=-1) 
                 {
                  showAgain(pname);
                 }
              }
            showMode=true;
           }
        }
      onShow();
      ChartRedraw();
     }

   void hide() 
     {
      createButton();
      ObjectSetInteger(0,name,OBJPROP_STATE,0);
      isAct=false;
      if(controlsCreated) 
        {
         if(showMode) 
           {
            int c=ObjectsTotal(0,windowHandle);
            for(int i=c-1; i>=0; i--) 
              {
               string pname=ObjectName(0,i,windowHandle);
               if(StringFind(pname,name)!=-1) 
                 {
                  hideAgain(pname);
                 }
              }
            showMode=false;
           }
        }

      ChartRedraw();
     }

   virtual void onControlsCreate() 
     {

     }

   virtual void onShow() 
     {

     }

   virtual void onHide() 
     {

     }

   virtual void trace() {}

   virtual void save() {}
   virtual void open() {}

   virtual void dialog() {}
   virtual void closeDialog() {}
   virtual void applyDialog() {}

   virtual void move(int mode) 
     {

     }

   virtual void clear() {}

   void showAgain(string pname) 
     {
      if(pname!=name && pname!=name+"_bg" && pname!=name+"_bgcommon") 
        {
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,ObjectGetInteger(0,pname,OBJPROP_XDISTANCE)-INTERFACE_STEP);
        }
     }

   void hideAgain(string pname) 
     {
      if(pname!=name && pname!=name+"_bg" && pname!=name+"_bgcommon") 
        {
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,ObjectGetInteger(0,pname,OBJPROP_XDISTANCE)+INTERFACE_STEP);
        }
     }

   virtual void deinit() 
     {
     }

   virtual void onClick(const int x,const int y,const string id) {}

   string getLegendName(string lname) 
     {
      return(name+"-legends-"+lname);
     }

   string getButtonName(string lname) 
     {
      return(name+"-btn-"+lname);
     }

   string getInputName(string lname) 
     {
      return(name+"-input-"+lname);
     }

   string getInputValue(string lname) 
     {
      string result="";
      for(CPanelInput *b=inputs.GetFirstNode(); b!=NULL; b=inputs.GetNextNode()) 
        {
         if(b.name==getInputName(lname)) 
           {
            result= b.value();
           }
        }
      return(result);
     }
  };
//+------------------------------------------------------------------+
class CPanelTabContainer: public CObject 
  {
private:
   CPanelTab        *activeTab;
   CPanelTab        *savestateTab;
public:
   CList             tabs;
   int               X1,Y1,width,height,tshift,corner,mode,indicatorHandle,back;
   string            name,tabBmp;
   int               windowHandle;
   bool              initialize;
   bool              chartready;

   void CPanelTabContainer() 
     {
      activeTab=NULL;
      initialize = false;
      chartready = false;
     }
   void ~CPanelTabContainer()
     {
      IndicatorRelease(indicatorHandle);
      ChartIndicatorDelete(0,windowHandle,"panel");
     }
private:
   void init() 
     {
      if(!initialize) 
        {
         if(!chartready) 
           {
            if(mode==INTERFACE_MODE_WINDOW) 
              {
               windowHandle = -1;
               windowHandle = ChartWindowFind(0,"panel");

               if(windowHandle==-1) 
                 {
                  indicatorHandle=iCustom(_Symbol,0,PANEL_CONTAINER);
                  if(indicatorHandle!=INVALID_HANDLE) 
                    {
                     windowHandle=(int) ChartGetInteger(0,CHART_WINDOWS_TOTAL);
                     if(ChartIndicatorAdd(0,(int)windowHandle,indicatorHandle)) 
                       {
                        chartready=true;
                       }
                    }
                    } else {
                  chartready=true;
                 }
                 } else {
               windowHandle=0;
               chartready=true;
              }
           }
         if(chartready || MQL5InfoInteger(MQL5_TESTING)) 
           {
            int bpos=0;
            for(CPanelTab *t=tabs.GetFirstNode(); t!=NULL; t=tabs.GetNextNode()) 
              {
               t.Xs=tshift;
               t.corner=corner;
               t.X=X1;
               t.Y=Y1;
               t.back=back;
               t.windowHandle = windowHandle;
               t.tabBmpCommon = tabBmp;
               t.buttonPos=bpos;
               bpos+=t.buttonWidth;
               if(width>0) t.bodyWidth=width;
               if(height>0) t.bodyHeight=height;
              }
           }
         initialize=true;
        }
     }
public:
   void show() 
     {
      if(!initialize) 
        {
         init();
        }

      for(CPanelTab *t=tabs.GetFirstNode(); t!=NULL; t=tabs.GetNextNode()) 
        {
         if(t.isAct) 
           {
            activeTab=t;
           }
         t.hide();
        }
      if(CheckPointer(activeTab)) activeTab.show();
     }

   void onTimer() 
     {
      for(CPanelTab *t=tabs.GetFirstNode(); t!=NULL; t=tabs.GetNextNode()) 
        {
         t.trace();
        }
     }

   void deinit() 
     {
      for(CPanelTab *t=tabs.GetFirstNode(); t!=NULL; t=tabs.GetNextNode()) 
        {
         t.deinit();
        }
     }

   void onClick(int x,int y,const string id) 
     {
      x = (int) x - Y1;
      y = (int) y - X1;

      int i=0;
      bool btnClk=false;

      for(CPanelTab *t=tabs.GetFirstNode(); t!=NULL; t=tabs.GetNextNode()) 
        {
         if(t.name==id) 
           {
            t.show();
            if(activeTab!=NULL && t!=activeTab) 
              {
               activeTab.hide();
              }
            activeTab=t;
            btnClk=true;
           }
         i++;
        }

      if(!btnClk) 
        {
         if(CheckPointer(activeTab)) 
           {
            activeTab.onClick(x,y,id);
           }
        }
     }
  };


//+------------------------------------------------------------------+

#define ALGO_DOUBLE		1
#define ALGO_INT  		2
#define ALGO_BOOL 		3
#define ALGO_TIME 		4
#define ALGO_STRING 		5
#define ALGO_ENUM 		6

#define ALGO_DIRECTION_IN 		-1
#define ALGO_DIRECTION_OUT    1

#define ALGO_SIZE_STEP 		10
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
struct TBlockPropertyEnum  
  {
   int               selected;
   int               type;
   string            name;
   string            title;
   int               int_value;
   double            double_value;
   string            string_value;
   bool              bool_value;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TBlockProperty  
  {
   int               type;
   string            name;
   string            title;
   int               int_value;
   double            double_value;
   string            string_value;
   bool              bool_value;
   datetime          time_value;
   TBlockPropertyEnum enum_value[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TAlgoLabel 
  {
   int               x,y,lcolor;
   double            size;
   string            text;
   string            name;
  };
//+------------------------------------------------------------------+
// 
//+------------------------------------------------------------------+
class CAlgoBlock: public CObject 
  {
private:
protected:
   int               xDim;
   int               yDim;
   int               colour;
   int               bgColor;
   double            scale;
   TAlgoLabel        labels[];
public:
   string            blockType;
   int               virtX1;
   int               virtY1;
   int               X1,X2,Y1,Y2;
   int               width;
   int               height;
   int               step;
   bool              selected;
   bool              edited;
   int               id;
   string            uid;
   string            name;
   int               windowHandle;
   CList             connectPointers;
   TBlockProperty    properties[];

   //+------------------------------------------------------------------+
   void CAlgoBlock() 
     {
      step=ALGO_SIZE_STEP;
      scale=1;
      selected=false;
      edited=false;
      setLabel("name",10,0,1,"0");
      colour=DarkGreen;
      bgColor=AliceBlue;
     }
   //+------------------------------------------------------------------+
   void ~CAlgoBlock() {}

   //+------------------------------------------------------------------+
   void set(double scaleNew,int x=0,int y=0,int shiftX=0,int shiftY=0,int selfAction=1) 
     {
      scale= scaleNew;
      virtX1 = (int) ((x-shiftX-16)/scale);
      virtY1 = (int) ((y-shiftY-16)/scale);
      X1=(int)(x-16*scale); X2=(int)(X1+width*scale); Y1=(int)(y-16*scale); Y2=(int)(Y1+height*scale);

      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         if(c.connectDirection==ALGO_DIRECTION_IN && c.busy) 
           {
            if(CheckPointer(c.connectedBlock)) 
              {
               c.connectedBlock.set(scale,(int)(X1-c.connectedBlock.width*scale),
                                    (int)(Y1+16*scale+(c.y*height-c.connectedBlock.height*c.connectedPoint.y)*scale),
                                    shiftX,shiftY,0);
              }
              } else if(c.connectDirection==ALGO_DIRECTION_OUT && selfAction) {
            if(CheckPointer(c.connectedPoint)) 
              {
               c.connectedPoint.busy=false;
               c.connectedPoint.connectedBlock.onInputsBreak();
               c.connectedPoint.connectedBlock= NULL;
               c.connectedPoint.connectedPoint= NULL;
               c.connectedPoint = NULL;
               c.connectedBlock = NULL;
              }

           }

        }

      draw(getColor());
     }

   //+------------------------------------------------------------------+
   void draw(int col=0) 
     {
      if(!col) col=getColor();
      string blockname=uid+"_block";
      if(ObjectFind(0,blockname)<0) 
        {
         ObjectCreate(0,blockname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
        }
      ObjectSetInteger(0,blockname,OBJPROP_XDISTANCE,X1);
      ObjectSetInteger(0,blockname,OBJPROP_YDISTANCE,Y1);
      ObjectSetInteger(0,blockname,OBJPROP_XSIZE,X2-X1);
      ObjectSetInteger(0,blockname,OBJPROP_YSIZE,Y2-Y1);
      ObjectSetInteger(0,blockname,OBJPROP_BORDER_TYPE,0);
      ObjectSetInteger(0,blockname,OBJPROP_COLOR,col);
      ObjectSetInteger(0,blockname,OBJPROP_BGCOLOR,bgColor);

      int cnt=ArrayRange(labels,0);
      string labelname;
      for(int i=0; i<cnt; i++) 
        {
         labelname=uid+"_label_"+(string) i;
         int curcolor=col;
         double cursize=1;
         if(labels[i].lcolor) curcolor=labels[i].lcolor;
         if(labels[i].size) cursize=labels[i].size;
         int curx = (int) (X1+(X2-X1)/2.0-step*cursize*scale*0.5*StringLen(labels[i].text));
         int cury = (int) (Y1 + (Y2-Y1)/2.0-cnt*step*scale/1.7 + i*step*scale);

         if(labels[i].x) curx = (int) (X1+labels[i].x*scale);
         if(labels[i].y) cury = (int) (Y1+labels[i].y*scale);
         if(ObjectFind(0,labelname)<0) 
           {
            ObjectCreate(0,labelname,OBJ_LABEL,windowHandle,0,0);
           }
         ObjectSetInteger(0,labelname,OBJPROP_XDISTANCE,curx);
         ObjectSetInteger(0,labelname,OBJPROP_YDISTANCE,cury);
         ObjectSetInteger(0,labelname,OBJPROP_FONTSIZE,(int)(cursize*step*scale));
         ObjectSetInteger(0,labelname,OBJPROP_COLOR,curcolor);
         ObjectSetString(0,labelname,OBJPROP_TEXT,labels[i].text);
        }

      int i=0;
      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         string pname=uid+"_"+(string) i;
         if(CheckPointer(c.connectedBlock) && c.connectDirection==ALGO_DIRECTION_OUT) 
           {
            if(ObjectFind(0,pname)>0) 
              {
               ObjectDelete(0,pname);
              }
              } else {
            if(ObjectFind(0,pname)<0) 
              {
               ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
              }
            int connectWidth = 16;
            int connectShift = 0;
            if(c.x==0) connectShift=(int)(-1*connectWidth*scale);
            ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,(int)(X1+connectShift+c.x*(X2-X1)));
            ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,(int)(Y1+c.y*(Y2-Y1)));
            ObjectSetInteger(0,pname,OBJPROP_XSIZE,(int)(connectWidth*scale));
            ObjectSetInteger(0,pname,OBJPROP_YSIZE,1);
            ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);
            ObjectSetInteger(0,pname,OBJPROP_COLOR,col);
            ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,col);
           }
         i++;
        }
      onDraw();

      ChartRedraw();
     }
   //+------------------------------------------------------------------+
   void setLabel(string name,int x,int y,double size,string text,int lcolor=0) 
     {
      int cnt=ArrayRange(labels,0);
      if(!lcolor) {lcolor=getColor();}
      bool inPool=false;
      for(int i=0; i<cnt; i++) 
        {
         inPool= labels[i].name == name;
         if(inPool) 
           {
            labels[i].x=x; labels[i].y=y; labels[i].size=size; labels[i].text=text; labels[i].lcolor=lcolor;
            break;
           }
        }
      if(!inPool) 
        {
         ArrayResize(labels,cnt+1);
         labels[cnt].name=name;
         labels[cnt].x=x; labels[cnt].y=y;
         labels[cnt].size = size;
         labels[cnt].text = text;
         labels[cnt].lcolor=lcolor;
        }

     }
   //+------------------------------------------------------------------+
   void kill() 
     {
      int cnt=ObjectsTotal(0,windowHandle);
      for(int i=cnt-1; i>=0; i--) 
        {
         string pname=ObjectName(0,i,windowHandle);
         if(StringFind(pname,uid+"_",0)!=-1) 
           {
            ObjectDelete(0,pname);
           }
        }

      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         if(CheckPointer(c.connectedBlock)) 
           {
            c.connectedPoint.busy=false;
            c.connectedPoint.connectedBlock.onInputsBreak();
            c.connectedPoint.connectedBlock= NULL;
            c.connectedPoint.connectedPoint= NULL;
            c.connectedPoint=NULL;
            c.connectedBlock.draw();
            c.connectedBlock=NULL;
           }
        }
      ChartRedraw();
     }

   //+------------------------------------------------------------------+
   virtual void move() {}

   //+------------------------------------------------------------------+
   virtual void change(double newScale,int shiftX=0,int shiftY=0) 
     {
      scale=newScale;
      X1 = (int) (virtX1*scale+shiftX);
      Y1 = (int) (virtY1*scale+shiftY);
      X2 = (int) (X1+width*scale);
      Y2 = (int) (Y1+height*scale);
      draw(getColor());
     }

   //+------------------------------------------------------------------+
   void select() 
     {
      selected=!selected;
      draw(getColor());
     }

   //+------------------------------------------------------------------+
   void setProperty(int i,string propertyValue,int j=0) 
     {
      switch(properties[i].type) 
        {
         case ALGO_BOOL:
            properties[i].bool_value=(bool) propertyValue;
            break;
         case ALGO_DOUBLE:
            properties[i].double_value=(double) propertyValue;
            break;
         case ALGO_INT:
            properties[i].int_value=(int) propertyValue;
            break;
         case ALGO_STRING:
            properties[i].string_value=propertyValue;
            break;
         case ALGO_ENUM:
            properties[i].enum_value[j].selected=(int) propertyValue;
            break;
        }
     }

   //+------------------------------------------------------------------+
   //------------ callback methods --
   virtual void onDraw(){};
   virtual void onSetProperties(){};
   virtual void onInputsBreak() {}
   //--------------------------------

   //+------------------------------------------------------------------+				
   string getProperty(int i) 
     {
      string result="";
      int cnt=0;
      switch(properties[i].type) 
        {
         case ALGO_BOOL:
            result=(string) properties[i].bool_value;
            break;
            break;
         case ALGO_DOUBLE:
            result=DoubleToString(properties[i].double_value,_Digits);
            break;
         case ALGO_INT:
            result=IntegerToString(properties[i].int_value);
            break;
         case ALGO_STRING:
            result=properties[i].string_value;
            break;
         case ALGO_ENUM:
            cnt=ArrayRange(properties[i].enum_value,0);
            for(int j=0; j<cnt; j++) 
              {
               if(properties[i].enum_value[j].selected== 1)
                 {
                  switch(properties[i].enum_value[j].type) 
                    {
                     case ALGO_BOOL:
                        result=(string)properties[i].enum_value[j].bool_value;
                        break;
                     case ALGO_DOUBLE:
                        result=DoubleToString(properties[i].enum_value[j].double_value,_Digits);
                        break;
                     case ALGO_INT:
                        result=IntegerToString(properties[i].enum_value[j].int_value);
                        break;
                     case ALGO_STRING:
                        result=properties[i].enum_value[j].string_value;
                        break;
                    }
                  break;
                 }
              }
            break;
        }
      return(result);
     }

   //+------------------------------------------------------------------+
   virtual bool process() { return(false);}

   //+------------------------------------------------------------------+
   int getColor() 
     {
      if(selected) return(Blue);
      return(colour);
     }

   int getEnumInteger(int index) 
     {
      int cnt=ArrayRange(properties[index].enum_value,0);
      int result=-1;
      for(int i=0; i<cnt; i++) 
        {
         if((bool)properties[index].enum_value[i].selected) 
           {
            result=properties[index].enum_value[i].int_value;
           }
        }
      return(result);
     }

   string getEnumString(int index) 
     {
      int cnt=ArrayRange(properties[index].enum_value,0);
      string result="";
      for(int i=0; i<cnt; i++) 
        {
         if((bool)properties[index].enum_value[i].selected) 
           {
            result=properties[index].enum_value[i].string_value;
           }
        }
      return(result);
     }

   string getEnumTitle(int index) 
     {
      int cnt=ArrayRange(properties[index].enum_value,0);
      string result="";
      for(int i=0; i<cnt; i++) 
        {
         if((bool)properties[index].enum_value[i].selected) 
           {
            result=properties[index].enum_value[i].title;
           }
        }
      return(result);
     }

   string getEnumName(int index) 
     {
      int cnt=ArrayRange(properties[index].enum_value,0);
      string result="";
      for(int i=0; i<cnt; i++) 
        {
         if((bool)properties[index].enum_value[i].selected) 
           {
            result=properties[index].enum_value[i].name;
           }
        }
      return(result);
     }

   //+------------------------------------------------------------------+
   void save(int fileHandle) 
     {
      FileWriteString(fileHandle,"-object-",100);
      FileWriteString(fileHandle,name,100);
      FileWriteInteger(fileHandle,id);
      FileWriteString(fileHandle,uid,100);
      FileWriteInteger(fileHandle,virtX1);
      FileWriteInteger(fileHandle,virtY1);
      FileWriteInteger(fileHandle,X1);
      FileWriteInteger(fileHandle,Y1);

      FileWriteString(fileHandle,"-properties-",100);
      int c=ArrayRange(properties,0);
      int cnt,selectItem=-1;
      for(int i=0; i<c; i++) 
        {
         switch(properties[i].type) 
           {
            case ALGO_DOUBLE:
               FileWriteDouble(fileHandle,properties[i].double_value);
               break;
            case ALGO_INT:
               FileWriteInteger(fileHandle,properties[i].int_value);
               break;
            case ALGO_STRING:
               FileWriteString(fileHandle,properties[i].string_value,100);
               break;
            case ALGO_BOOL:
               FileWriteInteger(fileHandle,(int) properties[i].bool_value);
               break;
            case ALGO_ENUM:
               cnt=ArrayRange(properties[i].enum_value,0);

               for(int j=0; j<cnt; j++) 
                 {
                  if((bool)properties[i].enum_value[j].selected) 
                    {
                     selectItem=j;
                    }
                 }
               FileWriteInteger(fileHandle,selectItem);
               break;
           }
        }

     }

   //+------------------------------------------------------------------+
   void saveLink(int fileHandle) 
     {
      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         if(c.connectDirection==ALGO_DIRECTION_IN && c.busy) 
           {
            if(CheckPointer(c.connectedBlock)) 
              {
               FileWriteString(fileHandle,"-link-",100);
               FileWriteString(fileHandle,uid,100);
               FileWriteString(fileHandle,c.connectedBlock.uid,100);
              }
           }
        }
     }

   //+------------------------------------------------------------------+
   void readProperties(int fileHandle) 
     {
      string separator=FileReadString(fileHandle,100);
      if(separator=="-properties-") 
        {
         int c=ArrayRange(properties,0);
         int cnt=0;
         for(int i=0; i<c; i++) 
           {
            switch(properties[i].type) 
              {
               case ALGO_DOUBLE:
                  properties[i].double_value=FileReadDouble(fileHandle);
                  break;
               case ALGO_INT:
                  properties[i].int_value=FileReadInteger(fileHandle);
                  break;
               case ALGO_STRING:
                  properties[i].string_value=FileReadString(fileHandle,100);
                  break;
               case ALGO_BOOL:
                  properties[i].bool_value=(bool) FileReadInteger(fileHandle);
                  break;
               case ALGO_ENUM:
                  cnt=ArrayRange(properties[i].enum_value,0);
                  for(int j=0; j<cnt; j++) 
                    {
                     properties[i].enum_value[j].selected=0;
                    }
                  properties[i].enum_value[FileReadInteger(fileHandle)].selected=1;
                  break;
              }
           }
         onSetProperties();
        }
     }

   //+------------------------------------------------------------------+
   virtual void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CConnectPointer: public CObject 
  {
public:
   int               connectType;
   int               connectDirection;
   double            x,y;
   bool              busy;
   CAlgoBlock       *connectedBlock;
   CConnectPointer *connectedPoint;
   void CConnectPointer() 
     {
      busy=false;
     }

  };
//+------------------------------------------------------------------+
class CAlgoBlockLogic: public CAlgoBlock 
  {
public:
   void CAlgoBlockLogic() 
     {
      blockType="logic";

      xDim = 5;
      yDim = 13;
      width= step*xDim;
      height = step*yDim;
      colour = Teal;
      bgColor= Honeydew;

     }
public:
   //+------------------------------------------------------------------+
   virtual bool process() 
     {
      bool result=false;

      CAlgoBlockLogic* signalA = NULL;
      CAlgoBlockLogic* signalB = NULL;
      int numIn=0;
      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         if(c.connectDirection==ALGO_DIRECTION_IN) 
           {
            if(c.busy) 
              {
               if(CheckPointer(c.connectedBlock)) 
                 {

                  if(signalA==NULL) 
                    {
                     signalA= c.connectedBlock;
                       } else {
                     signalB=c.connectedBlock;
                    }
                 }
              }
            numIn++;
           }
        }

      if((numIn==2) && CheckPointer(signalA) && CheckPointer(signalB)) 
        {
         result= operate(signalA,signalB);
           } else if((numIn==1) && CheckPointer(signalA)) {
         result=operate(signalA);
        }

      return(result);
     }

   //+------------------------------------------------------------------+
   virtual bool operate(CAlgoBlockLogic *s1,CAlgoBlockLogic *s2) 
     {
      return(false);
     }

   //+------------------------------------------------------------------+
   virtual bool operate(CAlgoBlockLogic *s1) 
     {
      return(false);
     }

  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockLogicAnd: public CAlgoBlockLogic 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockLogicAnd() 
     {
      setLabel("name",12,20,1,"AND");
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_BOOL;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.11;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_BOOL;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.89;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);
     }

   bool operate(CAlgoBlockLogic *s1,CAlgoBlockLogic *s2) 
     {
      if(CheckPointer(s1) && CheckPointer(s2)) 
        {
         return(s1.process() && s2.process());
        }
      return(false);
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockLogicOr: public CAlgoBlockLogic 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockLogicOr() 
     {
      setLabel("name",12,20,1,"OR");
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_BOOL;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.11;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_BOOL;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.89;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);
     }

   bool operate(CAlgoBlockLogic *s1,CAlgoBlockLogic *s2) 
     {
      return(s1.process() || s2.process());
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockLogicNot: public CAlgoBlockLogic 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockLogicNot() 
     {
      xDim = 5;
      yDim = 5;
      width= step*xDim;
      height=step*yDim;
      setLabel("name",12,20,1,"NOT");
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_BOOL;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);
     }

   bool operate(CAlgoBlockLogic *s1) 
     {
      return(!s1.process());
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
class CAlgoBlockSignal: public CAlgoBlock 
  {
protected:
   double            value;
   void CAlgoBlockSignal() 
     {
      blockType="signal";
      value=0.0;

      xDim = 6;
      yDim = 3;
      width= step*xDim;
      height = step*yDim;
      colour = Maroon;
      bgColor= MistyRose;
     }
public:
   virtual double getValue() { return(-1.0);}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockSignalMa: public CAlgoBlockSignal 
  {
private:
   int               handleInd;
   double            buffer[];
public:
   //+------------------------------------------------------------------+
   void CAlgoBlockSignalMa() 
     {
      setLabel("name",2,15,1,"~MA");

      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_OUT;
      pointer1.x = 1;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      ArrayResize(properties,5);

      properties[0].type = ALGO_ENUM;
      properties[0].name = "symbol";
      properties[0].title= "Symbol:";
      ArrayResize(properties[0].enum_value,12);
      properties[0].enum_value[0].type=ALGO_STRING;
      properties[0].enum_value[0].string_value="EURUSD";
      properties[0].enum_value[0].title="EURUSD";
      properties[0].enum_value[0].selected=1;
      properties[0].enum_value[1].type=ALGO_STRING;
      properties[0].enum_value[1].string_value="GBPUSD";
      properties[0].enum_value[1].title= "GBPUSD";
      properties[0].enum_value[2].type = ALGO_STRING;
      properties[0].enum_value[2].string_value="USDCHF";
      properties[0].enum_value[2].title= "USDCHF";
      properties[0].enum_value[3].type = ALGO_STRING;
      properties[0].enum_value[3].string_value="USDJPY";
      properties[0].enum_value[3].title= "USDJPY";
      properties[0].enum_value[4].type = ALGO_STRING;
      properties[0].enum_value[4].string_value="USDCAD";
      properties[0].enum_value[4].title= "USDCAD";
      properties[0].enum_value[5].type = ALGO_STRING;
      properties[0].enum_value[5].string_value="AUDUSD";
      properties[0].enum_value[5].title= "AUDUSD";
      properties[0].enum_value[6].type = ALGO_STRING;
      properties[0].enum_value[6].string_value="EURGBP";
      properties[0].enum_value[6].title= "EURGBP";
      properties[0].enum_value[7].type = ALGO_STRING;
      properties[0].enum_value[7].string_value="EURAUD";
      properties[0].enum_value[7].title= "EURAUD";
      properties[0].enum_value[8].type = ALGO_STRING;
      properties[0].enum_value[8].string_value="EURCHF";
      properties[0].enum_value[8].title= "EURCHF";
      properties[0].enum_value[9].type = ALGO_STRING;
      properties[0].enum_value[9].string_value="EURJPY";
      properties[0].enum_value[9].title = "EURJPY";
      properties[0].enum_value[10].type = ALGO_STRING;
      properties[0].enum_value[10].string_value="GBPCHF";
      properties[0].enum_value[10].title= "GBPCHF";
      properties[0].enum_value[11].type = ALGO_STRING;
      properties[0].enum_value[11].string_value="GBPJPY";
      properties[0].enum_value[11].title="GBPJPY";

      properties[1].type = ALGO_ENUM;
      properties[1].name = "timeframe";
      properties[1].title= "Timeframe:";
      ArrayResize(properties[1].enum_value,8);
      properties[1].enum_value[0].type=ALGO_INT;
      properties[1].enum_value[0].int_value=PERIOD_M1;
      properties[1].enum_value[0].title="M1";
      properties[1].enum_value[0].selected=1;
      properties[1].enum_value[1].type=ALGO_INT;
      properties[1].enum_value[1].int_value=PERIOD_M5;
      properties[1].enum_value[1].title= "M5";
      properties[1].enum_value[2].type = ALGO_INT;
      properties[1].enum_value[2].int_value=PERIOD_M15;
      properties[1].enum_value[2].title= "M15";
      properties[1].enum_value[3].type = ALGO_INT;
      properties[1].enum_value[3].int_value=PERIOD_M30;
      properties[1].enum_value[3].title= "M30";
      properties[1].enum_value[4].type = ALGO_INT;
      properties[1].enum_value[4].int_value=PERIOD_M30;
      properties[1].enum_value[4].title= "H1";
      properties[1].enum_value[5].type = ALGO_INT;
      properties[1].enum_value[5].int_value=PERIOD_H1;
      properties[1].enum_value[5].title= "H4";
      properties[1].enum_value[6].type = ALGO_INT;
      properties[1].enum_value[6].int_value=PERIOD_D1;
      properties[1].enum_value[6].title= "D";
      properties[1].enum_value[7].type = ALGO_INT;
      properties[1].enum_value[7].int_value=PERIOD_W1;
      properties[1].enum_value[7].title="W";

      properties[2].type = ALGO_INT;
      properties[2].name = "period";
      properties[2].title= "Period:";
      properties[2].int_value=17;

      properties[3].type = ALGO_ENUM;
      properties[3].name = "method";
      properties[3].title= "Method:";
      ArrayResize(properties[3].enum_value,4);
      properties[3].enum_value[0].type=ALGO_INT;
      properties[3].enum_value[0].int_value=MODE_SMA;
      properties[3].enum_value[0].title="Simple";
      properties[3].enum_value[0].selected=1;
      properties[3].enum_value[1].type=ALGO_INT;
      properties[3].enum_value[1].int_value=MODE_EMA;
      properties[3].enum_value[1].title= "Exponential";
      properties[3].enum_value[2].type = ALGO_INT;
      properties[3].enum_value[2].int_value=MODE_SMMA;
      properties[3].enum_value[2].title= "Smoothed";
      properties[3].enum_value[3].type = ALGO_INT;
      properties[3].enum_value[3].int_value=MODE_LWMA;
      properties[3].enum_value[3].title="Linear Weighted";

      properties[4].type = ALGO_ENUM;
      properties[4].name = "pricetype";
      properties[4].title= "Apply to:";
      ArrayResize(properties[4].enum_value,4);
      properties[4].enum_value[0].type=ALGO_INT;
      properties[4].enum_value[0].int_value=PRICE_CLOSE;
      properties[4].enum_value[0].title="Close";
      properties[4].enum_value[0].selected=1;
      properties[4].enum_value[1].type=ALGO_INT;
      properties[4].enum_value[1].int_value=PRICE_OPEN;
      properties[4].enum_value[1].title= "Open";
      properties[4].enum_value[2].type = ALGO_INT;
      properties[4].enum_value[2].int_value=PRICE_HIGH;
      properties[4].enum_value[2].title= "High";
      properties[4].enum_value[3].type = ALGO_INT;
      properties[4].enum_value[3].int_value=PRICE_LOW;
      properties[4].enum_value[3].title="Low";

      ArraySetAsSeries(buffer,true);
      onSetProperties();
     }

   void resetHandle() 
     {

     }

   //+------------------------------------------------------------------+
   void onSetProperties() 
     {
      string symbol=getEnumString(0);
      int tf=getEnumInteger(1);
      int period = properties[2].int_value;
      int method = getEnumInteger(3);
      int pricetype=getEnumInteger(4);
      if(method!=-1 && pricetype!=-1) 
        {
         int newHandle=iMA(symbol,(ENUM_TIMEFRAMES)tf,period,0,(ENUM_MA_METHOD)method,(ENUM_APPLIED_PRICE)pricetype);
         if(newHandle==INVALID_HANDLE) 
           {
            Print("Error Creating Handles for indicators",GetLastError());
           }
         handleInd=newHandle;
           } else {
         Print("Error creating indicator. Wrong method");
        }
      setLabel("symbol",3,2,0.5,getEnumString(0));
      setLabel("tf",40,2,0.5,getEnumTitle(1));
      setLabel("period",3,10,0.5,(string) properties[2].int_value);
      setLabel("method",14,10,0.4,getEnumTitle(3));
     }

   //+------------------------------------------------------------------+
   double getValue() 
     {
      if(CopyBuffer(handleInd,0,0,2,buffer)<0) 
        {
         onSetProperties();
           } else {
         value=buffer[0];
         printData();
         return(value);
        }
      return(NULL);
     }

   //+------------------------------------------------------------------+
   void printData() 
     {
      string pname,outputValue;
      pname=uid+"_val";
      if(ObjectFind(0,pname)<0) 
        {
         ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
        }
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,(int) (X1+(X2-X1)*0.55));
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,(int) (Y1+(Y2-Y1)/1.6));
      ObjectSetInteger(0,pname,OBJPROP_FONTSIZE,(int)(step*scale/2));
      ObjectSetInteger(0,pname,OBJPROP_COLOR,BlueViolet);
      outputValue=" ";
      if(value>0) { outputValue=DoubleToString(value,_Digits); }
      ObjectSetString(0,pname,OBJPROP_TEXT,outputValue);
     }

   //+------------------------------------------------------------------+
   void onDraw() 
     {
      printData();
     }

   //+------------------------------------------------------------------+
   void onInputsBreak() 
     {
      value=0;
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockSignalBid: public CAlgoBlockSignal 
  {
public:
   double            value;
   //+------------------------------------------------------------------+
   void CAlgoBlockSignalBid() 
     {
      setLabel("name",2,15,1,"~BID");

      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_OUT;
      pointer1.x = 1;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      ArrayResize(properties,1);

      properties[0].type = ALGO_ENUM;
      properties[0].name = "symbol";
      properties[0].title= "Symbol:";
      ArrayResize(properties[0].enum_value,12);
      properties[0].enum_value[0].type=ALGO_STRING;
      properties[0].enum_value[0].string_value="EURUSD";
      properties[0].enum_value[0].title="EURUSD";
      properties[0].enum_value[0].selected=1;
      properties[0].enum_value[1].type=ALGO_STRING;
      properties[0].enum_value[1].string_value="GBPUSD";
      properties[0].enum_value[1].title= "GBPUSD";
      properties[0].enum_value[2].type = ALGO_STRING;
      properties[0].enum_value[2].string_value="USDCHF";
      properties[0].enum_value[2].title= "USDCHF";
      properties[0].enum_value[3].type = ALGO_STRING;
      properties[0].enum_value[3].string_value="USDJPY";
      properties[0].enum_value[3].title= "USDJPY";
      properties[0].enum_value[4].type = ALGO_STRING;
      properties[0].enum_value[4].string_value="USDCAD";
      properties[0].enum_value[4].title= "USDCAD";
      properties[0].enum_value[5].type = ALGO_STRING;
      properties[0].enum_value[5].string_value="AUDUSD";
      properties[0].enum_value[5].title= "AUDUSD";
      properties[0].enum_value[6].type = ALGO_STRING;
      properties[0].enum_value[6].string_value="EURGBP";
      properties[0].enum_value[6].title= "EURGBP";
      properties[0].enum_value[7].type = ALGO_STRING;
      properties[0].enum_value[7].string_value="EURAUD";
      properties[0].enum_value[7].title= "EURAUD";
      properties[0].enum_value[8].type = ALGO_STRING;
      properties[0].enum_value[8].string_value="EURCHF";
      properties[0].enum_value[8].title= "EURCHF";
      properties[0].enum_value[9].type = ALGO_STRING;
      properties[0].enum_value[9].string_value="EURJPY";
      properties[0].enum_value[9].title = "EURJPY";
      properties[0].enum_value[10].type = ALGO_STRING;
      properties[0].enum_value[10].string_value="GBPCHF";
      properties[0].enum_value[10].title= "GBPCHF";
      properties[0].enum_value[11].type = ALGO_STRING;
      properties[0].enum_value[11].string_value="GBPJPY";
      properties[0].enum_value[11].title="GBPJPY";

      onSetProperties();
     }

   //+------------------------------------------------------------------+
   void onSetProperties() 
     {
      string symbol=getEnumString(0);
      setLabel("symbol",3,2,0.5,symbol);
     }

   //+------------------------------------------------------------------+
   double getValue() 
     {
      MqlTick tick;
      value=0.0;
      if(SymbolInfoTick(getEnumString(0),tick)) 
        {
         value=tick.bid;
        }
      printData();
      return(value);
     }

   //+------------------------------------------------------------------+
   void printData() 
     {
      string pname,outputValue;
      // current value
      pname=uid+"_val";
      if(ObjectFind(0,pname)<0) 
        {
         ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
        }
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,(int) (X1+(X2-X1)*0.55));
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,(int) (Y1+(Y2-Y1)/1.6));
      ObjectSetInteger(0,pname,OBJPROP_FONTSIZE,(int) (step*scale/2.0));
      ObjectSetInteger(0,pname,OBJPROP_COLOR,BlueViolet);
      outputValue=" ";
      if(value>0) { outputValue=DoubleToString(value,_Digits); }
      ObjectSetString(0,pname,OBJPROP_TEXT,outputValue);
     }

   //+------------------------------------------------------------------+
   void onDraw() 
     {
      printData();
     }

   //+------------------------------------------------------------------+
   void onInputsBreak() 
     {
      //clear old values
      value=0;
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockSignalConst: public CAlgoBlockSignal 
  {
public:
   double            value;
   //+------------------------------------------------------------------+
   void CAlgoBlockSignalConst() 
     {
      setLabel("name",2,2,1,"~HLINE");

      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_OUT;
      pointer1.x = 1;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      ArrayResize(properties,1);
      properties[0].type = ALGO_DOUBLE;
      properties[0].name = "lvl";
      properties[0].title= "Level";
      properties[0].double_value=0;

      onSetProperties();
     }

   //+------------------------------------------------------------------+
   void onSetProperties() 
     {
     }

   //+------------------------------------------------------------------+
   double getValue() 
     {
      return(properties[0].double_value);
     }

   //+------------------------------------------------------------------+
   void printData() 
     {
      string pname,outputValue;
      // current value
      pname=uid+"_val";
      if(ObjectFind(0,pname)<0) 
        {
         ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
        }
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,(int) (X1+(X2-X1)*0.55));
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,(int) (Y1+(Y2-Y1)/1.6));
      ObjectSetInteger(0,pname,OBJPROP_FONTSIZE,(int) (step*scale/2.0));
      ObjectSetInteger(0,pname,OBJPROP_COLOR,BlueViolet);
      outputValue =" ";
      outputValue = DoubleToString(properties[0].double_value, _Digits);
      ObjectSetString(0,pname,OBJPROP_TEXT,outputValue);
     }

   //+------------------------------------------------------------------+
   void onDraw() 
     {
      printData();
     }

   //+------------------------------------------------------------------+
   void onInputsBreak() 
     {
      //clear old values
      value=0;
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
class CAlgoBlockState: public CAlgoBlockLogic 
  {
public:
   void CAlgoBlockState() 
     {
      blockType="state";
      xDim = 5;
      yDim = 5;
      width= step*xDim;
      height = step*yDim;
      colour = CadetBlue;
      bgColor= MintCream;
     }
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockStateBuy: public CAlgoBlockState 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockStateBuy() 
     {
      //--points
      xDim = 6;
      yDim = 5;
      width= step*xDim;
      height=step*yDim;
      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      ArrayResize(properties,1);

      properties[0].type = ALGO_ENUM;
      properties[0].name = "symbol";
      properties[0].title= "Symbol:";
      ArrayResize(properties[0].enum_value,12);
      properties[0].enum_value[0].type=ALGO_STRING;
      properties[0].enum_value[0].string_value="EURUSD";
      properties[0].enum_value[0].title="EURUSD";
      properties[0].enum_value[0].selected=1;
      properties[0].enum_value[1].type=ALGO_STRING;
      properties[0].enum_value[1].string_value="GBPUSD";
      properties[0].enum_value[1].title= "GBPUSD";
      properties[0].enum_value[2].type = ALGO_STRING;
      properties[0].enum_value[2].string_value="USDCHF";
      properties[0].enum_value[2].title= "USDCHF";
      properties[0].enum_value[3].type = ALGO_STRING;
      properties[0].enum_value[3].string_value="USDJPY";
      properties[0].enum_value[3].title= "USDJPY";
      properties[0].enum_value[4].type = ALGO_STRING;
      properties[0].enum_value[4].string_value="USDCAD";
      properties[0].enum_value[4].title= "USDCAD";
      properties[0].enum_value[5].type = ALGO_STRING;
      properties[0].enum_value[5].string_value="AUDUSD";
      properties[0].enum_value[5].title= "AUDUSD";
      properties[0].enum_value[6].type = ALGO_STRING;
      properties[0].enum_value[6].string_value="EURGBP";
      properties[0].enum_value[6].title= "EURGBP";
      properties[0].enum_value[7].type = ALGO_STRING;
      properties[0].enum_value[7].string_value="EURAUD";
      properties[0].enum_value[7].title= "EURAUD";
      properties[0].enum_value[8].type = ALGO_STRING;
      properties[0].enum_value[8].string_value="EURCHF";
      properties[0].enum_value[8].title= "EURCHF";
      properties[0].enum_value[9].type = ALGO_STRING;
      properties[0].enum_value[9].string_value="EURJPY";
      properties[0].enum_value[9].title = "EURJPY";
      properties[0].enum_value[10].type = ALGO_STRING;
      properties[0].enum_value[10].string_value="GBPCHF";
      properties[0].enum_value[10].title= "GBPCHF";
      properties[0].enum_value[11].type = ALGO_STRING;
      properties[0].enum_value[11].string_value="GBPJPY";
      properties[0].enum_value[11].title="GBPJPY";

      onSetProperties();
     }

   bool process() 
     {
      bool value=PositionSelect(getEnumString(0)) && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY;
      return(value);
     }

   void onSetProperties() 
     {
      setLabel("name",3,20,1,"IS_BUY");
      setLabel("symbol",3,2,0.5,getEnumString(0));
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockStateSell: public CAlgoBlockState 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockStateSell() 
     {
      //--points
      xDim = 6;
      yDim = 5;
      width= step*xDim;
      height=step*yDim;
      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      ArrayResize(properties,1);

      properties[0].type = ALGO_ENUM;
      properties[0].name = "symbol";
      properties[0].title= "Symbol:";
      ArrayResize(properties[0].enum_value,12);
      properties[0].enum_value[0].type=ALGO_STRING;
      properties[0].enum_value[0].string_value="EURUSD";
      properties[0].enum_value[0].title="EURUSD";
      properties[0].enum_value[0].selected=1;
      properties[0].enum_value[1].type=ALGO_STRING;
      properties[0].enum_value[1].string_value="GBPUSD";
      properties[0].enum_value[1].title= "GBPUSD";
      properties[0].enum_value[2].type = ALGO_STRING;
      properties[0].enum_value[2].string_value="USDCHF";
      properties[0].enum_value[2].title= "USDCHF";
      properties[0].enum_value[3].type = ALGO_STRING;
      properties[0].enum_value[3].string_value="USDJPY";
      properties[0].enum_value[3].title= "USDJPY";
      properties[0].enum_value[4].type = ALGO_STRING;
      properties[0].enum_value[4].string_value="USDCAD";
      properties[0].enum_value[4].title= "USDCAD";
      properties[0].enum_value[5].type = ALGO_STRING;
      properties[0].enum_value[5].string_value="AUDUSD";
      properties[0].enum_value[5].title= "AUDUSD";
      properties[0].enum_value[6].type = ALGO_STRING;
      properties[0].enum_value[6].string_value="EURGBP";
      properties[0].enum_value[6].title= "EURGBP";
      properties[0].enum_value[7].type = ALGO_STRING;
      properties[0].enum_value[7].string_value="EURAUD";
      properties[0].enum_value[7].title= "EURAUD";
      properties[0].enum_value[8].type = ALGO_STRING;
      properties[0].enum_value[8].string_value="EURCHF";
      properties[0].enum_value[8].title= "EURCHF";
      properties[0].enum_value[9].type = ALGO_STRING;
      properties[0].enum_value[9].string_value="EURJPY";
      properties[0].enum_value[9].title = "EURJPY";
      properties[0].enum_value[10].type = ALGO_STRING;
      properties[0].enum_value[10].string_value="GBPCHF";
      properties[0].enum_value[10].title= "GBPCHF";
      properties[0].enum_value[11].type = ALGO_STRING;
      properties[0].enum_value[11].string_value="GBPJPY";
      properties[0].enum_value[11].title="GBPJPY";

      onSetProperties();
     }

   bool process() 
     {
      bool value=PositionSelect(getEnumString(0)) && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL;
      return(value);
     }

   void onSetProperties() 
     {
      setLabel("name",3,20,1,"IS_SELL");
      setLabel("symbol",3,2,0.5,getEnumString(0));
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockStateTime: public CAlgoBlockState 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockStateTime() 
     {
      //--points
      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      ArrayResize(properties,2);

      properties[0].type = ALGO_INT;
      properties[0].name = "start";
      properties[0].title= "Start hour";
      properties[0].int_value=0;

      properties[1].type = ALGO_INT;
      properties[1].name = "end";
      properties[1].title= "End hour";
      properties[1].int_value=0;
      onSetProperties();

      onSetProperties();
     }

   bool process() 
     {
      int mHourStart=properties[0].int_value;
      int mHourEnd=properties[1].int_value;
      bool value=checkTime(StringToTime(IntegerToString(mHourStart)+":00"),StringToTime(IntegerToString(mHourEnd)+":00"));
      return(value);
     }

   void onSetProperties() 
     {
      setLabel("name",3,20,1,"TIME");
      setLabel("start",3,2,0.5,(string) properties[0].int_value+":00-");
      setLabel("end",25,2,0.5,(string) properties[1].int_value+":00");
     }

   bool checkTime(datetime start,datetime end) 
     {
      datetime dt=TimeCurrent();
      if(start<end)
         if(dt>=start && dt<end)
            return(true);
      if(start >= end)
         if(dt >= start || dt < end)
            return(true);
      return(false);
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockStateDof: public CAlgoBlockState 
  {
public:
   //+------------------------------------------------------------------+	
   void CAlgoBlockStateDof() 
     {
      //--points
      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      ArrayResize(properties,5);

      properties[0].type = ALGO_BOOL;
      properties[0].name = "monday";
      properties[0].title= "Monday";
      properties[0].bool_value=true;

      properties[1].type = ALGO_BOOL;
      properties[1].name = "tuesday";
      properties[1].title= "Tuesday";
      properties[1].bool_value=true;

      properties[2].type = ALGO_BOOL;
      properties[2].name = "wenesday";
      properties[2].title= "Wenesday";
      properties[2].bool_value=true;

      properties[3].type = ALGO_BOOL;
      properties[3].name = "thursday";
      properties[3].title= "Thursday";
      properties[3].bool_value=true;

      properties[4].type = ALGO_BOOL;
      properties[4].name = "friday";
      properties[4].title= "Friday";
      properties[4].bool_value=true;

      onSetProperties();
     }

   bool process() 
     {
      MqlDateTime date;
      TimeToStruct(TimeCurrent(),date);
      if( properties[0].bool_value && date.day_of_week == 1) return(true);
      if( properties[1].bool_value && date.day_of_week == 2) return(true);
      if( properties[2].bool_value && date.day_of_week == 3) return(true);
      if( properties[3].bool_value && date.day_of_week == 4) return(true);
      if( properties[4].bool_value && date.day_of_week == 5) return(true);
      return(false);
     }

   void onSetProperties() 
     {
      setLabel("name",3,20,1,"WEEK");
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };

#define MAGIC_NUMBER 29831343;
//+------------------------------------------------------------------+
// 
//+------------------------------------------------------------------+
class CAlgoBlockOrder: public CAlgoBlockLogic 
  {
public:
   void CAlgoBlockOrder() 
     {
      blockType="order";
      xDim = 7;
      yDim = 7;
      width= step*xDim;
      height = step*yDim;
      colour = Purple;
      bgColor= LavenderBlush;
     }
   bool process() 
     {
      bool result=false;
      CConnectPointer *c=connectPointers.GetFirstNode();
      if(CheckPointer(c.connectedBlock)) 
        {
         if(c.connectedBlock.process() ) 
           {
            result=operate();
           }
        }
      return(result);
     }
   virtual bool operate() { return(false); }
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOrderBuy: public CAlgoBlockOrder 
  {
public:
   MqlTick           tick;
   MqlTradeRequest   request;
   MqlTradeResult    tradeResult;
   MqlTradeCheckResult checkResult;
   //+------------------------------------------------------------------+		
   void CAlgoBlockOrderBuy() 
     {
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_BOOL;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      //---------------------------------------------------
      ArrayResize(properties,5);
      properties[0].type = ALGO_DOUBLE;
      properties[0].name = "lot";
      properties[0].title= "Volume";
      properties[0].double_value=0.1;

      properties[1].type = ALGO_INT;
      properties[1].name = "TP";
      properties[1].title= "Take Profit";
      properties[1].int_value=0;

      properties[2].type = ALGO_INT;
      properties[2].name = "sl";
      properties[2].title= "Stop Loss";
      properties[2].int_value=0;

      properties[3].type = ALGO_ENUM;
      properties[3].name = "symbol";
      properties[3].title= "Symbol:";
      ArrayResize(properties[3].enum_value,12);
      properties[3].enum_value[0].type=ALGO_STRING;
      properties[3].enum_value[0].string_value="EURUSD";
      properties[3].enum_value[0].title="EURUSD";
      properties[3].enum_value[0].selected=1;
      properties[3].enum_value[1].type=ALGO_STRING;
      properties[3].enum_value[1].string_value="GBPUSD";
      properties[3].enum_value[1].title= "GBPUSD";
      properties[3].enum_value[2].type = ALGO_STRING;
      properties[3].enum_value[2].string_value="USDCHF";
      properties[3].enum_value[2].title= "USDCHF";
      properties[3].enum_value[3].type = ALGO_STRING;
      properties[3].enum_value[3].string_value="USDJPY";
      properties[3].enum_value[3].title= "USDJPY";
      properties[3].enum_value[4].type = ALGO_STRING;
      properties[3].enum_value[4].string_value="USDCAD";
      properties[3].enum_value[4].title= "USDCAD";
      properties[3].enum_value[5].type = ALGO_STRING;
      properties[3].enum_value[5].string_value="AUDUSD";
      properties[3].enum_value[5].title= "AUDUSD";
      properties[3].enum_value[6].type = ALGO_STRING;
      properties[3].enum_value[6].string_value="EURGBP";
      properties[3].enum_value[6].title= "EURGBP";
      properties[3].enum_value[7].type = ALGO_STRING;
      properties[3].enum_value[7].string_value="EURAUD";
      properties[3].enum_value[7].title= "EURAUD";
      properties[3].enum_value[8].type = ALGO_STRING;
      properties[3].enum_value[8].string_value="EURCHF";
      properties[3].enum_value[8].title= "EURCHF";
      properties[3].enum_value[9].type = ALGO_STRING;
      properties[3].enum_value[9].string_value="EURJPY";
      properties[3].enum_value[9].title = "EURJPY";
      properties[3].enum_value[10].type = ALGO_STRING;
      properties[3].enum_value[10].string_value="GBPCHF";
      properties[3].enum_value[10].title= "GBPCHF";
      properties[3].enum_value[11].type = ALGO_STRING;
      properties[3].enum_value[11].string_value="GBPJPY";
      properties[3].enum_value[11].title="GBPJPY";

      properties[4].type = ALGO_BOOL;
      properties[4].name = "ON";
      properties[4].title= "On/Off";
      properties[4].bool_value=false;

      onSetProperties();
     }
   //+------------------------------------------------------------------+
   bool operate() 
     {

      bool result=false;
      if(properties[4].bool_value) 
        {
         double point=SymbolInfoDouble(getEnumString(3),SYMBOL_POINT);
         if(SymbolInfoTick(getEnumString(3),tick)) 
           {
            request.price=tick.ask;
            request.sl = tick.bid-properties[2].int_value*point;
            request.tp = tick.ask+properties[1].int_value*point;
            request.action       = TRADE_ACTION_DEAL;
            request.symbol       = getEnumString(3);
            request.volume       = properties[0].double_value;
            request.deviation    = 10;
            request.type         = ORDER_TYPE_BUY;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
               result=true;
                 } else {
               Print("Error: ",checkResult.retcode);
              }
           }
        }
      return(result);
     }

   void onSetProperties() 
     {
      if(properties[4].bool_value) 
        {
         setLabel("name",12,20,1,"☼ BUY");
           } else {
         setLabel("name",12,20,1,"● BUY");
        }
      setLabel("symbol",5,2,0.7,getEnumString(3));
      setLabel("tp",5,50,0.6,"tp="+(string) properties[1].int_value);
      setLabel("sl",40,50,0.6,"sl="+(string) properties[2].int_value);
      setLabel("lot",50,3,0.6,DoubleToString(properties[0].double_value,2));
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOrderSell: public CAlgoBlockOrder 
  {
public:
   MqlTick           tick;
   MqlTradeRequest   request;
   MqlTradeResult    tradeResult;
   MqlTradeCheckResult checkResult;
   //+------------------------------------------------------------------+		
   void CAlgoBlockOrderSell() 
     {
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_BOOL;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.5;
      connectPointers.Add(pointer1);

      //---------------------------------------------------
      ArrayResize(properties,5);
      properties[0].type = ALGO_DOUBLE;
      properties[0].name = "lot";
      properties[0].title= "Volume";
      properties[0].double_value=0.1;

      properties[1].type = ALGO_INT;
      properties[1].name = "TP";
      properties[1].title= "Take Profit";
      properties[1].int_value=0;

      properties[2].type = ALGO_INT;
      properties[2].name = "sl";
      properties[2].title= "Stop Loss";
      properties[2].int_value=0;

      properties[3].type = ALGO_ENUM;
      properties[3].name = "symbol";
      properties[3].title= "Symbol:";
      ArrayResize(properties[3].enum_value,12);
      properties[3].enum_value[0].type=ALGO_STRING;
      properties[3].enum_value[0].string_value="EURUSD";
      properties[3].enum_value[0].title="EURUSD";
      properties[3].enum_value[0].selected=1;
      properties[3].enum_value[1].type=ALGO_STRING;
      properties[3].enum_value[1].string_value="GBPUSD";
      properties[3].enum_value[1].title= "GBPUSD";
      properties[3].enum_value[2].type = ALGO_STRING;
      properties[3].enum_value[2].string_value="USDCHF";
      properties[3].enum_value[2].title= "USDCHF";
      properties[3].enum_value[3].type = ALGO_STRING;
      properties[3].enum_value[3].string_value="USDJPY";
      properties[3].enum_value[3].title= "USDJPY";
      properties[3].enum_value[4].type = ALGO_STRING;
      properties[3].enum_value[4].string_value="USDCAD";
      properties[3].enum_value[4].title= "USDCAD";
      properties[3].enum_value[5].type = ALGO_STRING;
      properties[3].enum_value[5].string_value="AUDUSD";
      properties[3].enum_value[5].title= "AUDUSD";
      properties[3].enum_value[6].type = ALGO_STRING;
      properties[3].enum_value[6].string_value="EURGBP";
      properties[3].enum_value[6].title= "EURGBP";
      properties[3].enum_value[7].type = ALGO_STRING;
      properties[3].enum_value[7].string_value="EURAUD";
      properties[3].enum_value[7].title= "EURAUD";
      properties[3].enum_value[8].type = ALGO_STRING;
      properties[3].enum_value[8].string_value="EURCHF";
      properties[3].enum_value[8].title= "EURCHF";
      properties[3].enum_value[9].type = ALGO_STRING;
      properties[3].enum_value[9].string_value="EURJPY";
      properties[3].enum_value[9].title = "EURJPY";
      properties[3].enum_value[10].type = ALGO_STRING;
      properties[3].enum_value[10].string_value="GBPCHF";
      properties[3].enum_value[10].title= "GBPCHF";
      properties[3].enum_value[11].type = ALGO_STRING;
      properties[3].enum_value[11].string_value="GBPJPY";
      properties[3].enum_value[11].title="GBPJPY";

      properties[4].type = ALGO_BOOL;
      properties[4].name = "ON";
      properties[4].title= "On/Off";
      properties[4].bool_value=false;

      onSetProperties();
     }
   //+------------------------------------------------------------------+
   bool operate() 
     {

      //buy order
      bool result=false;
      if(properties[4].bool_value) 
        {
         double point=SymbolInfoDouble(getEnumString(3),SYMBOL_POINT);
         if(SymbolInfoTick(getEnumString(3),tick)) 
           {
            request.price=tick.ask;
            request.sl = tick.ask+properties[2].int_value*point;
            request.tp = tick.bid-properties[1].int_value*point;
            request.action       = TRADE_ACTION_DEAL;
            request.symbol       = getEnumString(3);
            request.volume       = properties[0].double_value;
            request.deviation    = 10;
            request.type         = ORDER_TYPE_SELL;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
               result=true;
                 } else {
               Print("Error: ",checkResult.retcode);
              }
           }
        }
      return(result);
     }

   void onSetProperties() 
     {
      if(properties[4].bool_value) 
        {
         setLabel("name",12,20,1,"☼ SELL");
           } else {
         setLabel("name",12,20,1,"● SELL");
        }

      setLabel("symbol",5,2,0.7,getEnumString(3));
      setLabel("tp",5,50,0.6,"tp="+(string) properties[1].int_value);
      setLabel("sl",40,50,0.6,"sl="+(string) properties[2].int_value);
      setLabel("lot",50,3,0.6,DoubleToString(properties[0].double_value,2));
     }

   //+------------------------------------------------------------------+
   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
class CAlgoBlockOp: public CAlgoBlockLogic 
  {
   //+------------------------------------------------------------------+
public:
   void CAlgoBlockOp() 
     {
      blockType="op";
      xDim = 5;
      yDim = 7;
      width= step*xDim;
      height = step*yDim;
      colour = OrangeRed;
      bgColor= Seashell;

     }
   //+------------------------------------------------------------------+
   bool process() 
     {
      bool result=false;

      CAlgoBlockSignal* signalA = NULL;
      CAlgoBlockSignal* signalB = NULL;

      for(CConnectPointer *c=connectPointers.GetFirstNode(); c!=NULL; c=connectPointers.GetNextNode()) 
        {
         if(c.connectDirection==ALGO_DIRECTION_IN && c.busy) 
           {
            if(CheckPointer(c.connectedBlock)) 
              {
               if(signalA==NULL) 
                 {
                  signalA= c.connectedBlock;
                    } else {
                  signalB=c.connectedBlock;
                 }
              }
           }
        }

      if(CheckPointer(signalA) && CheckPointer(signalB)) 
        {
         if(operate(signalA,signalB)) 
           {
            result=true;
           }
        }
      return(result);
     }
   //+------------------------------------------------------------------+
   virtual bool operate(CAlgoBlockSignal *s1,CAlgoBlockSignal *s2) 
     {
      return(false);
     }

  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOpCross: public CAlgoBlockOp 
  {
private:
   double            oldS1[];
   double            oldS2[];
   int               timer;
public:

   void CAlgoBlockOpCross() 
     {
      timer=0;
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.21;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_DOUBLE;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.79;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      //---------------------------------------------------
      ArrayResize(properties,2);
      properties[0].type = ALGO_INT;
      properties[0].name = "bar1";
      properties[0].title= "Time Interval, s";
      properties[0].int_value=300;

      properties[1].type = ALGO_INT;
      properties[1].name = "sensity";
      properties[1].title= "Delta, points";
      properties[1].int_value=20;
      onSetProperties();
     }

   bool operate(CAlgoBlockSignal *s1,CAlgoBlockSignal *s2) 
     {
      double S1 = s1.getValue();
      double S2 = s2.getValue();

      int param_delay=properties[0].int_value;
      double param_sensity=properties[1].int_value;
      if(param_delay>0) 
        {
         if(oldS1[param_delay-1]!=0) 
           {
            string symbol= s1.getEnumString(0);
            double point = 1;
            if(StringLen(symbol)>0) 
              {
               point=SymbolInfoDouble(symbol,SYMBOL_POINT);
                 } else {
               symbol=s2.getEnumString(0);
               if(StringLen(symbol)>0) 
                 {
                  point=SymbolInfoDouble(symbol,SYMBOL_POINT);
                 }
              }
            if(oldS1[param_delay-1]>oldS2[param_delay-1] && S2-S1>param_sensity*point) 
              {
               resetBlock();
               return(true);
              }
           }
         if(timer>=param_delay) { timer=0;}
         oldS1[timer] = S1;
         oldS2[timer] = S2;
         timer++;
        }
      return(false);
     }

   void onInputsBreak() 
     {
      resetBlock();
     }

   void onSetProperties() 
     {
      setLabel("name",12,20,1,"X");
      setLabel("diapazon",10,37,0.5,(string) properties[0].int_value);
      setLabel("sensity",25,25,0.5,(string) properties[1].int_value);
      resetBlock();
     }

   void resetBlock() 
     {
      timer=0;
      ArrayFree(oldS1); ArrayFree(oldS2);
      ArrayResize(oldS1, properties[0].int_value);
      ArrayResize(oldS2, properties[0].int_value);
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOpEqual: public CAlgoBlockOp 
  {
private:
public:

   void CAlgoBlockOpEqual() 
     {
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.21;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_DOUBLE;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.79;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      //---------------------------------------------------
      ArrayResize(properties,1);
      properties[0].type = ALGO_INT;
      properties[0].name = "sensity";
      properties[0].title= "Sensity level, points";
      properties[0].int_value=20;
      onSetProperties();
     }

   bool operate(CAlgoBlockSignal *s1,CAlgoBlockSignal *s2) 
     {
      double S1 = s1.getValue();
      double S2 = s2.getValue();
      double param_sensity=properties[0].int_value;
      string symbol= s1.getEnumString(0);
      double point = 1;
      if(StringLen(symbol)>0) 
        {
         point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           } else {
         symbol=s2.getEnumString(0);
         if(StringLen(symbol)>0) 
           {
            point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           }
        }
      if(S2-S1<=param_sensity*point) 
        {
         return(true);
        }
      return(false);
     }

   void onInputsBreak() 
     {
     }

   void onSetProperties() 
     {
      setLabel("name",12,20,1,"=");
      setLabel("sensity",12,35,0.5,(string) properties[0].int_value);
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOpGreather: public CAlgoBlockOp 
  {
private:
public:

   void CAlgoBlockOpGreather() 
     {
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.21;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_DOUBLE;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.79;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      //---------------------------------------------------
      ArrayResize(properties,1);
      properties[0].type = ALGO_INT;
      properties[0].name = "sensity";
      properties[0].title= "More than, points";
      properties[0].int_value=20;
      onSetProperties();

     }

   bool operate(CAlgoBlockSignal *s1,CAlgoBlockSignal *s2) 
     {
      double S1 = s1.getValue();
      double S2 = s2.getValue();
      string symbol= s1.getEnumString(0);
      double point = 1;
      if(StringLen(symbol)>0) 
        {
         point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           } else {
         symbol=s2.getEnumString(0);
         if(StringLen(symbol)>0) 
           {
            point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           }
        }
      if(S1-S2>properties[0].int_value*point) 
        {
         return(true);
        }
      return(false);
     }

   void onSetProperties() 
     {
      setLabel("name",12,20,1,">");
      setLabel("sensity",12,35,0.5,(string) properties[0].int_value);
     }

   void onInputsBreak() 
     {
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
class CAlgoBlockOpLess: public CAlgoBlockOp 
  {
private:
public:

   void CAlgoBlockOpLess() 
     {
      //--points
      CConnectPointer *pointer1=new CConnectPointer();
      pointer1.connectType=ALGO_DOUBLE;
      pointer1.connectDirection=ALGO_DIRECTION_IN;
      pointer1.x = 0;
      pointer1.y = 0.21;
      connectPointers.Add(pointer1);

      CConnectPointer *pointer2=new CConnectPointer();
      pointer2.connectType=ALGO_DOUBLE;
      pointer2.connectDirection=ALGO_DIRECTION_IN;
      pointer2.x = 0;
      pointer2.y = 0.79;
      connectPointers.Add(pointer2);

      CConnectPointer *pointer3=new CConnectPointer();
      pointer3.connectType=ALGO_BOOL;
      pointer3.connectDirection=ALGO_DIRECTION_OUT;
      pointer3.x = 1;
      pointer3.y = 0.5;
      connectPointers.Add(pointer3);

      //---------------------------------------------------
      ArrayResize(properties,1);
      properties[0].type = ALGO_INT;
      properties[0].name = "sensity";
      properties[0].title= "Less then, points";
      properties[0].int_value=20;
      onSetProperties();
     }

   bool operate(CAlgoBlockSignal *s1,CAlgoBlockSignal *s2) 
     {
      double S1 = s1.getValue();
      double S2 = s2.getValue();
      string symbol= s1.getEnumString(0);
      double point = 1;
      if(StringLen(symbol)>0) 
        {
         point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           } else {
         symbol=s2.getEnumString(0);
         if(StringLen(symbol)>0) 
           {
            point=SymbolInfoDouble(symbol,SYMBOL_POINT);
           }
        }
      if(S2-S1>properties[0].int_value*point) 
        {
         return(true);
        }
      return(false);
     }

   void onSetProperties() 
     {
      setLabel("name",12,20,1,"<");
      setLabel("sensity",12,35,0.5,(string) properties[0].int_value);
     }

   void onInputsBreak() 
     {
     }

   void drawToolbarIcon() {}
  };
//+------------------------------------------------------------------+
class CPanelBlocksFactory 
  {
public:
   CAlgoBlock *factory(string className) 
     {
      CAlgoBlock *newBlock=factoryGet(className);
      newBlock.name=className;
      return(newBlock);
     }

   CAlgoBlock* factoryGet(string className) 
     {
      if(className == "CAlgoBlockOrderBuy") 
        {
         return(new CAlgoBlockOrderBuy());
           } else if(className=="CAlgoBlockOrderSell") {
         return(new CAlgoBlockOrderSell());
        }

      //signals
      else if(className=="CAlgoBlockSignalMa") 
        {
         return(new CAlgoBlockSignalMa());
           } else if(className=="CAlgoBlockSignalBid") {
         return(new CAlgoBlockSignalBid());
           } else if(className=="CAlgoBlockSignalConst") {
         return(new CAlgoBlockSignalConst());
        }

      //OP
      else if(className=="CAlgoBlockOpCross") 
        {
         return(new CAlgoBlockOpCross());
           } else if(className=="CAlgoBlockOpEqual") {
         return(new CAlgoBlockOpEqual());
           } else if(className=="CAlgoBlockOpGreather") {
         return(new CAlgoBlockOpGreather());
           } else if(className=="CAlgoBlockOpLess") {
         return(new CAlgoBlockOpLess());
        }
      //logic
      else if(className=="CAlgoBlockLogicAnd") 
        {
         return(new CAlgoBlockLogicAnd());
           } else if(className=="CAlgoBlockLogicOr") {
         return(new CAlgoBlockLogicOr());
           } else if(className=="CAlgoBlockLogicNot") {
         return(new CAlgoBlockLogicNot());
        }

      //state
      else if(className=="CAlgoBlockStateBuy") 
        {
         return(new CAlgoBlockStateBuy());
           } else if(className=="CAlgoBlockStateSell") {
         return(new CAlgoBlockStateSell());
           } else if(className=="CAlgoBlockStateTime") {
         return(new CAlgoBlockStateTime());
           } else if(className=="CAlgoBlockStateDof") {
         return(new CAlgoBlockStateDof());
        }


      return(new CAlgoBlock());
     }

  };

#include "../../Files/fatpanel/Inputs.mqh"
//+------------------------------------------------------------------+
class CPanelStrategyTab: public CPanelTab 
  {
private:
   bool              isOpen;
public:
   int               h;
   int               elementCounter;
   bool              propertiesMode;
   int               shiftX,shiftY;
   double            scale;
   CList             blocks;
   string            bindName;
   string            filename;
   CPanelBlocksFactory factory;
   string            bindButton;
   int               currentScale;
   bool              acceptMode;
   string            acceptType;
   string            acceptControl;
   void              CPanelStrategyTab();
   void             ~CPanelStrategyTab();
   void              init();
   void              clear();
   void              onClick(const int x,const int y,const string id);
   void              onHide();
   void              onControlsCreate();
   void              refreshControls();
   void              changeAll();
   void              connectTo(CAlgoBlock *slaveBlock,CAlgoBlock *masterBlock);
   void              trace();
   void              dialog();
   void              move(int mode);
   void              showProperties(CAlgoBlock *b);
   void              closeDialog();
   void              hideProperties();
   void              applyDialog();
   void              save();
   void              initBlock(CAlgoBlock *alg,int handle,string name,int id,string uid,int x,int y,int x1,int y1);
   void              open();
  };
//+------------------------------------------------------------------+
class CPanelBlocksTab: public CPanelTab 
  {
public:
   CPanelStrategyTab *holder;
   CPanelBlocksFactory factory;

   void onControlsCreate() 
     {
      int i=0,k=0;
      for(CPanelButton *b=buttons.GetFirstNode(); b!=NULL; b=buttons.GetNextNode()) 
        {
         b.draw(X-10-i*(b.width+10),Y+buttonHeight+10+k*(b.height+10));
         i++;
         if(MathMod(i,4)==0) 
           {
            k++;
            i=0;
           }

        }
     }

   void onClick(const int lparam,const int dparam,const string id) 
     {
      for(CPanelButton *b=buttons.GetFirstNode(); b!=NULL; b=buttons.GetNextNode()) 
        {
         if(id==b.name) 
           {
            ObjectSetInteger(0,id,OBJPROP_STATE,1);
            holder.acceptMode = true;
            holder.bindName = b.classn;
            holder.bindButton=id;
           }
        }
     }
  };
//+------------------------------------------------------------------+
class CPanelSignalsTab: public CPanelBlocksTab 
  {
public:
   void init() 
     {
      //-- inline config
      CPanelButton *b1=new CPanelButton();
      b1.name=name+"-btn-signals-ma";
      b1.title = "MA";
      b1.width = 50;
      b1.height = 50;
      b1.corner = corner;
      b1.windowHandle=windowHandle;
      b1.classn="CAlgoBlockSignalMa";
      buttons.Add(b1);

      CPanelButton *b3=new CPanelButton();
      b3.name=name+"-btn-signals-bid";
      b3.title = "BID";
      b3.width = 50;
      b3.height = 50;
      b3.corner = corner;
      b3.windowHandle=windowHandle;
      b3.classn="CAlgoBlockSignalBid";
      buttons.Add(b3);

      CPanelButton *b5=new CPanelButton();
      b5.name=name+"-btn-signals-const";
      b5.title = "HLINE";
      b5.width = 50;
      b5.height = 50;
      b5.corner = corner;
      b5.windowHandle=windowHandle;
      b5.classn="CAlgoBlockSignalConst";
      buttons.Add(b5);

      initialize=true;
     }
  };
//+------------------------------------------------------------------+
class CPanelOpTab: public CPanelBlocksTab 
  {
public:
   void init() 
     {
      //-- inline config
      CPanelButton *b1=new CPanelButton();
      b1.name=name+"-btn-op-cross";
      b1.title = "CROSS";
      b1.width = 50;
      b1.height = 50;
      b1.corner = corner;
      b1.windowHandle=windowHandle;
      b1.classn="CAlgoBlockOpCross";
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=name+"-btn-op-equal";
      b2.title = "=";
      b2.width = 50;
      b2.height = 50;
      b2.corner = corner;
      b2.windowHandle=windowHandle;
      b2.classn="CAlgoBlockOpEqual";
      buttons.Add(b2);

      CPanelButton *b3=new CPanelButton();
      b3.name=name+"-btn-op-grether";
      b3.title = ">";
      b3.width = 50;
      b3.height = 50;
      b3.corner = corner;
      b3.windowHandle=windowHandle;
      b3.classn="CAlgoBlockOpGreather";
      buttons.Add(b3);

      CPanelButton *b4=new CPanelButton();
      b4.name=name+"-btn-op-less";
      b4.title = "<";
      b4.width = 50;
      b4.height = 50;
      b4.corner = corner;
      b4.windowHandle=windowHandle;
      b4.classn="CAlgoBlockOpLess";
      buttons.Add(b4);

      initialize=true;
     }
  };
//+------------------------------------------------------------------+
class CPanelLogicTab: public CPanelBlocksTab 
  {
public:
   void init() 
     {
      //-- inline config
      CPanelButton *b1=new CPanelButton();
      b1.name=name+"-btn-logic-and";
      b1.title = "AND";
      b1.width = 50;
      b1.height = 50;
      b1.corner = corner;
      b1.windowHandle=windowHandle;
      b1.classn="CAlgoBlockLogicAnd";
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=name+"-btn-logic-or";
      b2.title = "OR";
      b2.width = 50;
      b2.height = 50;
      b2.corner = corner;
      b2.windowHandle=windowHandle;
      b2.classn="CAlgoBlockLogicOr";
      buttons.Add(b2);

      CPanelButton *b3=new CPanelButton();
      b3.name=name+"-btn-logic-not";
      b3.title = "NOT";
      b3.width = 50;
      b3.height = 50;
      b3.corner = corner;
      b3.windowHandle=windowHandle;
      b3.classn="CAlgoBlockLogicNot";
      buttons.Add(b3);

      initialize=true;
     }
  };
//+------------------------------------------------------------------+
class CPanelStateTab: public CPanelBlocksTab 
  {
public:
   void init() 
     {
      //-- inline config
      CPanelButton *b1=new CPanelButton();
      b1.name=name+"-btn-state-isbuy";
      b1.title = "IS_BUY";
      b1.width = 50;
      b1.height = 50;
      b1.corner = corner;
      b1.windowHandle=windowHandle;
      b1.classn="CAlgoBlockStateBuy";
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=name+"-btn-state-issell";
      b2.title = "IS_SELL";
      b2.width = 50;
      b2.height = 50;
      b2.corner = corner;
      b2.windowHandle=windowHandle;
      b2.classn="CAlgoBlockStateSell";
      buttons.Add(b2);

      CPanelButton *b3=new CPanelButton();
      b3.name=name+"-btn-state-time";
      b3.title = "TIME";
      b3.width = 50;
      b3.height = 50;
      b3.corner = corner;
      b3.windowHandle=windowHandle;
      b3.classn="CAlgoBlockStateTime";
      buttons.Add(b3);

      CPanelButton *b4=new CPanelButton();
      b4.name=name+"-btn-state-dof";
      b4.title = "WEEK";
      b4.width = 50;
      b4.height = 50;
      b4.corner = corner;
      b4.windowHandle=windowHandle;
      b4.classn="CAlgoBlockStateDof";
      buttons.Add(b4);

      initialize=true;
     }
  };
//+------------------------------------------------------------------+
class CPanelOrdersTab: public CPanelBlocksTab 
  {
public:
   void init() 
     {

      //-- inline config
      CPanelButton *b1=new CPanelButton();
      b1.name=name+"-btn-orders-buy-add";
      b1.title = "BUY";
      b1.width = 50;
      b1.height = 50;
      b1.corner = corner;
      b1.windowHandle=windowHandle;
      b1.classn="CAlgoBlockOrderBuy";
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=name+"-btn-orders-sell-add";
      b2.title = "SELL";
      b2.width = 50;
      b2.height = 50;
      b2.corner = corner;
      b2.windowHandle=windowHandle;
      b2.classn="CAlgoBlockOrderSell";
      buttons.Add(b2);

      initialize=true;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::CPanelStrategyTab() 
  {
   elementCounter=0;
   isOpen= false;
   scale = 1;
   currentScale=5;
   shiftX= 0;
   shiftY=0;
   acceptMode=false;
   propertiesMode=false;
   acceptType="";
   filename="FATPANEL.DAT";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::~CPanelStrategyTab() 
  {
   if(MessageBox("Save changes?","Question",MB_OKCANCEL)==1) 
     {
      save();
     }

   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      b.kill();
     }
   blocks.Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::init() 
  {

//-- <toolsPanel>
   string panelId=name+"_tools";
   CPanelTabContainer *toolsPanel=new CPanelTabContainer();
   toolsPanel.X1 = 330;
   toolsPanel.Y1 = 45;
   toolsPanel.width=300;
   toolsPanel.height = 85;
   toolsPanel.tshift = 0;
   toolsPanel.back=0;
   toolsPanel.corner=CORNER_RIGHT_UPPER;
   toolsPanel.name = panelId;
   toolsPanel.mode = INTERFACE_MODE_WINDOW;

   CPanelSignalsTab *_ptab1=new CPanelSignalsTab();
   _ptab1.title = "Data";
   _ptab1.isAct = true;
   _ptab1.buttonWidth=60;
   _ptab1.name=panelId+"-signals";
   _ptab1.isAct=true;
   _ptab1.holder=GetPointer(this);
   _ptab1.tabColor= WhiteSmoke;
   _ptab1.bgColor = WhiteSmoke;
   _ptab1.tabBmp="\\Images\\fatpanel\\toolspanel1.bmp";
   toolsPanel.tabs.Add(_ptab1);

   CPanelOpTab *_ptab2=new CPanelOpTab();
   _ptab2.title="Operations";
   _ptab2.buttonWidth=60;
   _ptab2.name=panelId+"-op";
   _ptab2.holder=GetPointer(this);
   _ptab2.tabColor=WhiteSmoke;
   _ptab2.tabBmp="\\Images\\fatpanel\\toolspanel2.bmp";
   toolsPanel.tabs.Add(_ptab2);

   CPanelStateTab *_ptab3=new CPanelStateTab();
   _ptab3.title="State";
   _ptab3.buttonWidth=65;
   _ptab3.name=panelId+"-state";
   _ptab3.holder=GetPointer(this);
   _ptab3.tabColor=WhiteSmoke;
   _ptab3.tabBmp="\\Images\\fatpanel\\toolspanel3.bmp";
   toolsPanel.tabs.Add(_ptab3);

   CPanelLogicTab *_ptab4=new CPanelLogicTab();
   _ptab4.title="Logic";
   _ptab4.buttonWidth=46;
   _ptab4.name=panelId+"-logic";
   _ptab4.holder=GetPointer(this);
   _ptab4.tabColor=WhiteSmoke;
   _ptab4.tabBmp="\\Images\\fatpanel\\toolspanel4.bmp";
   toolsPanel.tabs.Add(_ptab4);

   CPanelOrdersTab *_ptab5=new CPanelOrdersTab();
   _ptab5.title="Behaviour";
   _ptab5.buttonWidth=68;
   _ptab5.name=panelId+"-order";
   _ptab5.holder=GetPointer(this);
   _ptab5.tabColor=WhiteSmoke;
   _ptab5.tabBmp="\\Images\\fatpanel\\toolspanel5.bmp";
   toolsPanel.tabs.Add(_ptab5);
   panels.Add(toolsPanel);

   initialize=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::onControlsCreate() 
  {

   string pname=name+"-btn-clear";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"Delete");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,228);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,88);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,18);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
   ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

   pname=name+"-btn-save";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"Save");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,346);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,88);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,18);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
   ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

   pname=name+"-btn-inputs_checkbox";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,454);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,12);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,12);

   pname=pname+"_bool";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,454);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\checkon.bmp");
   ObjectSetString(0,pname,OBJPROP_BMPFILE,1,"\\Images\\fatpanel\\checkoff.bmp");
   ObjectSetInteger(0,pname,OBJPROP_STATE,0);

   pname=name+"-btn-inputs_checkbox_label";
   ObjectCreate(0,pname,OBJ_LABEL,(int) windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"with input params");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,470);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
   ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

   pname=name+"-btn-zupdownbg";
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,16);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,17);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,3000);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,WhiteSmoke);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);

   pname=name+"-btn-zupdownbg2";
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,-1);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,17);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,3000);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,WhiteSmoke);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);

   pname=name+"-btn-zleftrightbg";
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,16);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,3000);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,17);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,WhiteSmoke);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);

   pname=name+"-btn-zleftrightbg2";
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,-1);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,22);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,3000);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,17);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,WhiteSmoke);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);

   pname=name+"-btn-prev";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,14);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,14);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,15);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aleft.bmp");

   pname=name+"-btn-next";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,15);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aright.bmp");

   pname=name+"-btn-up";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,37);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,37);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aup.bmp");

   pname=name+"-btn-down";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,29);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,29);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\adown.bmp");

//---2

   pname=name+"-btn-prev2";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,14);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,14);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aleft.bmp");

   pname=name+"-btn-next2";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,29);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,29);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,23);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aright.bmp");

   pname=name+"-btn-up2";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,37);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,37);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\aup.bmp");

   pname=name+"-btn-down2";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,29);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,15);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,15);
   pname=pname+"-p";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,0);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,29);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\adown.bmp");

   pname=name+"-btn-plus";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"+");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,25);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,40);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,18);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
   ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

   pname=name+"-btn-minus";
   ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"-");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,70);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,45);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,40);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,18);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
   ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

   if(!isOpen) 
     {
      open();
      isOpen=true;
      refreshControls();
     }

   CPanelTabContainer *toolsPanel=panels.GetFirstNode();
   toolsPanel.show();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::clear() 
  {
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      if(b.selected) 
        {
         b.kill();
         blocks.DetachCurrent();
         delete(b);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::onClick(const int x,const int y,const string id) 
  {

   if(id==name+"-properties-close" || id==name+"-properties-close2") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,1);
      closeDialog();
     }

   if(id==name+"-properties-apply") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,1);
      applyDialog();
     }

   if(!acceptMode && !propertiesMode) 
     {
      int index1=-1,index2=-1;
      for(CAlgoBlock *b=blocks.GetLastNode(); b!=NULL; b=blocks.GetPrevNode()) 
        {

         if(x>b.X1 && x<b.X2 && y>b.Y1 && y<b.Y2) 
           {
            if(index1==-1) 
              {
               index1= blocks.IndexOf(b);
              }
              } else {
            if(b.selected) 
              {
               index2=blocks.IndexOf(b);
              }
           }
        }

      if(index1!=-1) 
        {
         if(index2==-1) 
           {
            CAlgoBlock *b=blocks.GetNodeAtIndex(index1);
            if(b.selected) 
              {
               dialog();
                 } else {
               b.select();
              }
              } else {
            CAlgoBlock *b=blocks.GetNodeAtIndex(index1);
            CAlgoBlock *b2=blocks.GetNodeAtIndex(index2);
            connectTo(b2,b);
           }
           } else {
         if(index2!=-1) 
           {
            if(id==nameBack) 
              {
               CAlgoBlock *b=blocks.GetNodeAtIndex(index2);
               b.select();
               b.set(scale,x,y,shiftX,shiftY);
              }
           }
        }
     }

   if(StringFind(id,"checkbox")!=-1) 
     {
      ObjectSetInteger(0,id+"_bool",OBJPROP_STATE,(int) !(bool)ObjectGetInteger(0,id+"_bool",OBJPROP_STATE));
     }

   if(StringFind(id,"radio")!=-1) 
     {
      string groupId=StringSubstr(id,0,StringFind(id,"radio"));
      int cnt=ObjectsTotal(0,windowHandle);
      string pname;
      for(int j=cnt-1; j>=0; j--) 
        {
         pname=ObjectName(0,j,windowHandle);
         if(StringFind(pname,groupId)!=-1) 
           {
            ObjectSetInteger(0,pname,OBJPROP_STATE,0);
           }
        }
      ObjectSetInteger(0,id+"_bool",OBJPROP_STATE,(int) !(bool)ObjectGetInteger(0,id+"_bool",OBJPROP_STATE));
     }

   if(id==name+"-btn-clear") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      clear();
     }

   if(id==name+"-btn-up" || id==name+"-btn-up2") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(1);
     }
   if(id==name+"-btn-down" || id==name+"-btn-down2") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(3);
     }

   if(id==name+"-btn-next" || id==name+"-btn-next2") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(2);
     }

   if(id==name+"-btn-prev" || id==name+"-btn-prev2") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(4);
     }

   if(id==name+"-btn-plus") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(5);
     }

   if(id==name+"-btn-minus") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      move(6);
     }

   if(id==name+"-btn-save") 
     {
      ObjectSetInteger(0,id,OBJPROP_STATE,0);
      save();
     }

   if(acceptMode && StringLen(bindName)>0) 
     {
      if(id==nameBack) 
        {
         CAlgoBlock *block=factory.factory(bindName);
         block.id=elementCounter;
         block.uid=name+"-"+IntegerToString(elementCounter);
         block.setLabel("id",block.width,block.height,0.5,(string) block.id, DarkGreen);
         block.windowHandle=windowHandle;
         block.set(scale,x,y, shiftX, shiftY);
         elementCounter++;
         acceptMode=false;
         blocks.Add(block);
         ObjectSetInteger(0,bindButton,OBJPROP_STATE,0);
         refreshControls();
        }
     }
   CPanelTabContainer *toolsPanel=panels.GetFirstNode();
   toolsPanel.onClick((int)x,(int)y,id);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::onHide() 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::refreshControls() 
  {
   controlsCreated=false;
   CPanelTabContainer *toolsPanel=panels.GetFirstNode();
   for(CPanelTab *tab=toolsPanel.tabs.GetFirstNode(); tab!=NULL; tab=toolsPanel.tabs.GetNextNode()) 
     {
      tab.controlsCreated=false;
     }
   int c=ObjectsTotal(0,windowHandle);
   for(int i=c-1; i>=0; i--) 
     {
      string pname=ObjectName(0,i,windowHandle);
      if(StringFind(pname,name+"-btn")!=-1 || StringFind(pname,name+"_tools")!=-1) 
        {
         ObjectDelete(0,pname);
        }
     }
   show();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::changeAll() 
  {
   int i=0;
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      b.change(scale,shiftX,shiftY);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::connectTo(CAlgoBlock *slaveBlock,CAlgoBlock *masterBlock) 
  {
   if(slaveBlock.selected) slaveBlock.select();
   bool attach=false;
   for(CConnectPointer *m=masterBlock.connectPointers.GetFirstNode(); m!=NULL; m=masterBlock.connectPointers.GetNextNode()) 
     {
      for(CConnectPointer *s=slaveBlock.connectPointers.GetFirstNode(); s!=NULL; s=slaveBlock.connectPointers.GetNextNode()) 
        {
         if(m.connectType==s.connectType && m.connectDirection==ALGO_DIRECTION_IN && s.connectDirection==ALGO_DIRECTION_OUT && !m.busy) 
           {
            slaveBlock.set(scale,(int)(masterBlock.X1-slaveBlock.width*scale),
                           (int)(masterBlock.Y1+16*scale+(masterBlock.height*m.y-slaveBlock.height*s.y)*scale),
                           shiftX,shiftY,1);
            m.busy=true;
            m.connectedBlock = slaveBlock;
            m.connectedPoint = s;
            s.connectedBlock = masterBlock;
            s.connectedPoint = m;
            attach=true;
            slaveBlock.draw();
            break;
           }
        }
      if(attach) break;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::trace() 
  {
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      if(b.blockType=="order") 
        {
         b.process();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::dialog() 
  {
   propertiesMode=true;
   CAlgoBlock* bSel = NULL;
   CAlgoBlock* bEdt = NULL;
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      if(b.selected) 
        {
         bSel=b;
        }
      if(b.edited) 
        {
         bEdt=b;
        }
     }
   if(CheckPointer(bSel)) 
     {
      if(CheckPointer(bEdt)) 
        {
         closeDialog();
        }
      showProperties(bSel);
      bSel.select();
      bSel.edited=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::move(int mode) 
  {
   switch(mode) 
     {
      case 1:
         shiftY+=40;
         break;
      case 2:
         shiftX-=40;
         break;
      case 3:
         shiftY-=40;
         break;
      case 4:
         shiftX+=40;
         break;
      case 5:
         scale*=1.2;
         break;
      case 6:
         scale/=1.2;
         break;
     }
   changeAll();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::showProperties(CAlgoBlock *b) 
  {
   string pname=name+"-properties";
   int y_size=(int) ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,windowHandle);
   int x_size=(int) ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,windowHandle);
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT," ");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,20);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,10);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,x_size-40);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,y_size-20);
   ObjectSetInteger(0,pname,OBJPROP_SELECTABLE,0);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,Gainsboro);

   pname=name+"-properties-head";
   ObjectCreate(0,pname,OBJ_RECTANGLE_LABEL,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT," ");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,20);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,10);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,x_size-40);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,30);
   ObjectSetInteger(0,pname,OBJPROP_SELECTABLE,0);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,DarkGray);
   ObjectSetInteger(0,pname,OBJPROP_BORDER_TYPE,0);
   ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,Olive);

   pname=name+"-properties-close";
   ObjectCreate(0,pname,OBJ_BUTTON,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT," x ");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,x_size-50);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,15);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,20);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,20);

   pname=name+"-properties-title";
   ObjectCreate(0,pname,OBJ_LABEL,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,"Properties");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,17);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,WhiteSmoke);

   pname=name+"-properties-uid";
   ObjectCreate(0,pname,OBJ_LABEL,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT,b.uid);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,-500);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,-200);

   pname=name+"-properties-bg";
   ObjectCreate(0,pname,OBJ_BITMAP_LABEL,windowHandle,0,0);
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,x_size-395);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,50);
   ObjectSetInteger(0,pname,OBJPROP_COLOR,Gainsboro);
   ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\help_"+b.name+".bmp");

   int c=ArrayRange(b.properties,0);
   int cnt = 0;
   int shx = 0, shy=0, shift=0;

   for(int i=0; i<c; i++) 
     {
      pname = name+"-properties-labels-"+(string) i;
      ObjectCreate(0,pname,OBJ_LABEL,windowHandle,0,0);
      ObjectSetString(0,pname,OBJPROP_TEXT,b.properties[i].title);
      ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
      ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,50+shift);
      ObjectSetInteger(0,pname,OBJPROP_COLOR,Gray);

      pname=name+"-properties-inputs-"+(string) i;
      switch(b.properties[i].type) 
        {
         case ALGO_BOOL:
            pname=pname+"_checkbox";
            ObjectCreate(0,pname,OBJ_BUTTON,(int) windowHandle,0,0);
            ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
            ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,66+shift);
            ObjectSetInteger(0,pname,OBJPROP_XSIZE,12);
            ObjectSetInteger(0,pname,OBJPROP_YSIZE,12);

            pname=pname+"_bool";
            ObjectCreate(0,pname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
            ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
            ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,66+shift);
            ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\checkon.bmp");
            ObjectSetString(0,pname,OBJPROP_BMPFILE,1,"\\Images\\fatpanel\\checkoff.bmp");
            if((bool) b.getProperty(i)) 
              {
               ObjectSetInteger(0,pname,OBJPROP_STATE,1);
                 } else {
               ObjectSetInteger(0,pname,OBJPROP_STATE,0);
              }
            shift+=40;
            break;
         case ALGO_DOUBLE:
         case ALGO_INT:
         case ALGO_STRING:
            ObjectCreate(0,pname,OBJ_EDIT,windowHandle,0,0);
            ObjectSetString(0,pname,OBJPROP_TEXT,b.getProperty(i));
            ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
            ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,66+shift);
            ObjectSetInteger(0,pname,OBJPROP_XSIZE,200);
            ObjectSetInteger(0,pname,OBJPROP_BGCOLOR,WhiteSmoke);
            ObjectSetInteger(0,pname,OBJPROP_COLOR,Gray);
            shift+=40;
            break;
         case ALGO_ENUM:

            cnt=ArrayRange(b.properties[i].enum_value,0);
            //property_value = b.getProperty(i);
            shx=0; shy=0;
            for(int j=0; j<cnt; j++) 
              {
               string lname=pname+"_radio_"+(string) j;
               ObjectCreate(0,lname,OBJ_BUTTON,(int) windowHandle,0,0);
               ObjectSetInteger(0,lname,OBJPROP_XDISTANCE,30+shx);
               ObjectSetInteger(0,lname,OBJPROP_YDISTANCE,66+shift+shy*18);
               ObjectSetInteger(0,lname,OBJPROP_XSIZE,12);
               ObjectSetInteger(0,lname,OBJPROP_YSIZE,12);

               lname=lname+"_bool";
               ObjectCreate(0,lname,OBJ_BITMAP_LABEL,(int) windowHandle,0,0);
               ObjectSetInteger(0,lname,OBJPROP_XDISTANCE,30+shx);
               ObjectSetInteger(0,lname,OBJPROP_YDISTANCE,66+shift+shy*18);
               ObjectSetString(0,lname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\radioon.bmp");
               ObjectSetString(0,lname,OBJPROP_BMPFILE,1,"\\Images\\fatpanel\\radiooff.bmp");
               if((bool) b.properties[i].enum_value[j].selected) 
                 {
                  ObjectSetInteger(0,lname,OBJPROP_STATE,1);
                    } else {
                  ObjectSetInteger(0,lname,OBJPROP_STATE,0);
                 }
               lname=pname+"_labelr_"+(string) j;
               ObjectCreate(0,lname,OBJ_LABEL,windowHandle,0,0);
               ObjectSetString(0,lname,OBJPROP_TEXT,b.properties[i].enum_value[j].title);
               ObjectSetInteger(0,lname,OBJPROP_XDISTANCE,45+shx);
               ObjectSetInteger(0,lname,OBJPROP_YDISTANCE,66+shift+shy*18);
               ObjectSetInteger(0,lname,OBJPROP_COLOR,Gray);
               shy++;
               if(MathMod((double)(j+1),2.0)==0) 
                 {
                  shx+=130; shy=0;
                 }
              }
            shift+=2*18+25;
            break;
        }
     }

   pname=name+"-properties-apply";
   ObjectCreate(0,pname,OBJ_BUTTON,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT," Apply ");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,30);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,y_size-50);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,20);

   pname=name+"-properties-close2";
   ObjectCreate(0,pname,OBJ_BUTTON,windowHandle,0,0);
   ObjectSetString(0,pname,OBJPROP_TEXT," Cancel ");
   ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,140);
   ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,y_size-50);
   ObjectSetInteger(0,pname,OBJPROP_XSIZE,70);
   ObjectSetInteger(0,pname,OBJPROP_YSIZE,20);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::closeDialog() 
  {
   hideProperties();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::hideProperties() 
  {
   int c=ObjectsTotal(0,windowHandle);
   for(int i=c-1; i>=0; i--) 
     {
      string pname=ObjectName(0,i,windowHandle);
      if(StringFind(pname,name+"-properties")!=-1) 
        {
         ObjectDelete(0,pname);
        }
     }
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      if(b.edited) 
        {
         b.edited=false;
        }
     }
   propertiesMode=false;
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::applyDialog() 
  {
   CAlgoBlock* bSel = NULL;
   CAlgoBlock* bEdt = NULL;
   for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
     {
      if(b.edited) 
        {
         int c=ArrayRange(b.properties,0);
         string pname;
         int cnt=0;
         for(int i=0; i<c; i++) 
           {
            pname = name+"-properties-inputs-"+(string) i;
            switch(b.properties[i].type) 
              {
               case ALGO_DOUBLE:
               case ALGO_INT:
               case ALGO_STRING:
                  b.setProperty(i,ObjectGetString(0,pname,OBJPROP_TEXT));
                  break;
               case ALGO_BOOL:
                  b.setProperty(i,IntegerToString(ObjectGetInteger(0,pname+"_checkbox_bool",OBJPROP_STATE)));
               case ALGO_ENUM:
                  cnt=ArrayRange(b.properties[i].enum_value,0);
                  for(int j=0; j<cnt; j++) 
                    {
                     b.setProperty(i,(string)ObjectGetInteger(0,pname+"_radio_"+(string)j+"_bool",OBJPROP_STATE),j);
                    }
              }
           }
         b.onSetProperties();
         b.draw();
         hideProperties();
         break;
        }
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::save() 
  {
   int handle=FileOpen(filename, FILE_WRITE|FILE_BIN|FILE_COMMON);
   if(handle!=INVALID_HANDLE) 
     {
      FileWriteDouble(handle,scale);
      FileWriteInteger(handle,elementCounter);
      FileWriteInteger(handle,shiftX);
      FileWriteInteger(handle,shiftY);
      for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
        {
         b.save(handle);
        }

      for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
        {
         b.saveLink(handle);
        }

      FileClose(handle);

      handle=FileOpen("fatpanel\\Inputs.mqh",FILE_WRITE|FILE_UNICODE);
      int handle2=FileOpen("fatpanel\\Init.mqh",FILE_WRITE|FILE_UNICODE);

      bool iscreate=ObjectGetInteger(0,name+"-btn-inputs_checkbox_bool",OBJPROP_STATE)==1;

      if(handle!=INVALID_HANDLE && iscreate) 
        {
         string initVars="int selector=0;\r\nfor(CAlgoBlock* b = blocks.GetFirstNode(); b != NULL; b = blocks.GetNextNode() ) {\r\n";
         int k=0;
         for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
           {
            int c=ArrayRange(b.properties,0);
            string line = "";
            string type = "";
            string value= "";
            string name = "";
            line="input string "+b.blockType+"_"+(string) k+"=\"\"; //===============Block №"+(string) b.id+"("+b.blockType+")===============\r\n";
            FileWriteString(handle,line);
            initVars = initVars+"if (selector == "+(string) k+") {\r\n";
            for(int i=0; i<c; i++) 
              {
               name= "input_"+b.blockType+"_"+(string) k+"_"+b.properties[i].name;
               type= "";
               switch(b.properties[i].type) 
                 {
                  case ALGO_BOOL:
                     type="bool";
                     value=b.getProperty(i);
                     initVars=initVars+"b.properties["+(string) i+"].bool_value = "+name+";\r\n";
                     break;
                  case ALGO_DOUBLE:
                     type="double";
                     value=b.getProperty(i);
                     initVars=initVars+"b.properties["+(string) i+"].double_value = "+name+";\r\n";
                     break;
                  case ALGO_INT:
                     type="int";
                     value=b.getProperty(i);
                     initVars=initVars+"b.properties["+(string) i+"].int_value = "+name+";\r\n";
                     break;
                  case ALGO_STRING:
                     type="string";
                     value="\""+b.getProperty(i)+"\"";
                     initVars=initVars+"b.properties["+(string) i+"].string_value = "+name+";\r\n";
                     break;
                  case ALGO_ENUM:
                     break;
                 }
               if(StringLen(type)>0) 
                 {
                  line="input "+type+" "+name+"="+value+"; //"+b.properties[i].title+"\r\n";
                  FileWriteString(handle,line);
                 }

              }
            initVars=initVars+"}\r\n";
            k++;
           }
         initVars=initVars+"b.onSetProperties();\r\nselector++;\r\n}";

         FileWriteString(handle2,initVars);
        }

      FileClose(handle);
      FileClose(handle2);

      string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
      uchar path[];
      StringToCharArray(terminal_data_path+"\\mql5.exe MQL5\\Experts\\Fatpanel\\FatPanel.mq5",path);
      int result=WinExec(path,2);

      MessageBox("All changes are saved","Message");
      keybd_event(0xA2,0,0,0);
      keybd_event(0x52,0,0,0);
      keybd_event(0xA2,0,0,0);
      keybd_event(0x52,0,0,0);
      keybd_event(0x52,0,2,0);
      keybd_event(0xA2,0,2,0);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::initBlock(CAlgoBlock *alg,int handle,string name,int id,string uid,int x,int y,int x1,int y1) 
  {
   alg.id=id;
   alg.uid=uid;
   alg.name=name;
   alg.windowHandle=windowHandle;
   alg.virtX1=x; alg.virtY1=y;
   alg.set(scale,x1,y1,shiftX, shiftY+16);
   alg.setLabel("id",alg.width,alg.height,0.5,(string) alg.id, DarkGreen);
   alg.readProperties(handle);
   blocks.Add(alg);
   alg.draw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelStrategyTab::open() 
  {
   int lnkCounter=0;

   if(FileIsExist(filename,FILE_COMMON)) 
     {
      int handle = FileOpen(filename, FILE_READ|FILE_BIN|FILE_COMMON);
      if(handle!=INVALID_HANDLE) 
        {
         scale=FileReadDouble(handle);
         elementCounter=FileReadInteger(handle);
         shiftX = FileReadInteger(handle);
         shiftY = FileReadInteger(handle);
         while(!FileIsEnding(handle)) 
           {
            string fileSectionType=FileReadString(handle,100);
            if(fileSectionType=="-object-") 
              {
               string name=FileReadString(handle,100);
               int id=FileReadInteger(handle);
               string uid=FileReadString(handle,100);
               int x = FileReadInteger(handle);
               int y = FileReadInteger(handle);
               int x1 = FileReadInteger(handle);
               int y1 = FileReadInteger(handle);

               initBlock(factory.factory(name),handle,name,id,uid,x,y,x1,y1);

               elementCounter++;
              }

            if(fileSectionType=="-link-") 
              {
               string uid1 = FileReadString(handle,100);
               string uid2 = FileReadString(handle,100);
               CAlgoBlock *b1=NULL; CAlgoBlock *b2=NULL;
               for(CAlgoBlock *b=blocks.GetFirstNode(); b!=NULL; b=blocks.GetNextNode()) 
                 {
                  if(b.uid == uid1) b1 = b;
                  if(b.uid == uid2) b2 = b;
                 }
               if(CheckPointer(b1) && CheckPointer(b2)) 
                 {
                  connectTo(b2,b1);
                  lnkCounter++;
                 }
              }

           }
         FileClose(handle);
#include "../../Files/fatpanel/Init.mqh";

           } else {
         Print("Scheme file not found",GetLastError());
        }
        } else {
      Print("Scheme is empty");
     }
  }
//+------------------------------------------------------------------+
class CPanelSymbolTab: public CPanelTab 
  {
public:
   string            symbol;
   void init() 
     {

      //panels
      string panelId=name+"_deals";
      CPanelTabContainer *dealsPanel=new CPanelTabContainer();
      dealsPanel.X1 = 40;
      dealsPanel.Y1 = 60;
      dealsPanel.width=350;
      dealsPanel.height = 90;
      dealsPanel.tshift = 5;
      dealsPanel.back=0;
      dealsPanel.corner=CORNER_LEFT_UPPER;
      dealsPanel.name = panelId;
      dealsPanel.mode = INTERFACE_MODE_WINDOW;

      CPanelDealTab *_ptab1=new CPanelDealTab();
      _ptab1.title="Immediate execution";
      _ptab1.symbol=symbol;
      _ptab1.buttonWidth=160;
      _ptab1.bgColor=Honeydew;
      _ptab1.tabColor=Honeydew;
      _ptab1.name=panelId+"-inst";
      _ptab1.isAct=true;
      dealsPanel.tabs.Add(_ptab1);

      CPanelDealPendTab *_ptab2=new CPanelDealPendTab();
      _ptab2.title="Pending";
      _ptab2.symbol=symbol;
      _ptab2.buttonWidth=100;
      _ptab2.bgColor=Honeydew;
      _ptab2.tabColor=Honeydew;
      _ptab2.name=panelId+"-pnd";
      dealsPanel.tabs.Add(_ptab2);

      panels.Add(dealsPanel);
      //------

      //inline config
      CPanelLegend *l1=new CPanelLegend();
      l1.name=getLegendName("profit");
      l1.width = 80; l1.height = 30;
      l1.title = "Profit:";
      l1.text=DoubleToString(getSymbolProfit(),2);
      l1.x=400;  l1.y=65; l1.size=13; l1.colour=getColorByProfit(getSymbolProfit());
      l1.windowHandle=windowHandle;
      legends.Add(l1);

      CPanelLegend *l9=new CPanelLegend();
      l9.name=getLegendName("stoplevel");
      l9.width = 80; l9.height = 60;
      l9.title = "Stop Level:";
      l9.text=(string) SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
      l9.x=400;  l9.y=90; l9.size=10;
      l9.windowHandle=windowHandle;
      legends.Add(l9);

      CPanelLegend *l4=new CPanelLegend();
      l4.name=getLegendName("spread");
      l4.width = 80; l4.height = 60;
      l4.title = "Spread:";
      l4.text=(string) SymbolInfoInteger(symbol,SYMBOL_SPREAD);
      l4.x=400;  l4.y=110; l4.size=10;
      l4.windowHandle=windowHandle;
      legends.Add(l4);

      CPanelLegend *l5=new CPanelLegend();
      l5.name=getLegendName("minlot");
      l5.width = 80; l5.height = 60;
      l5.title = "Volume:";
      l5.text=DoubleToString(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN),2)+"-"+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX),2)+"["+DoubleToString(SymbolInfoDouble(symbol,SYMBOL_VOLUME_LIMIT),2)+"]";
      l5.x=400;  l5.y=130; l5.size=10;
      l5.windowHandle=windowHandle;
      legends.Add(l5);

      initialize=true;
     }

   void onShow() 
     {
      if(ChartSymbol(0)!=symbol) 
        {
         ChartSetSymbolPeriod(0,symbol,ChartPeriod(0));
         setSymbolInfo();
        }
     }

   void onControlsCreate() 
     {
      for(CPanelButton *b=buttons.GetFirstNode(); b!=NULL; b=buttons.GetNextNode()) 
        {
         b.draw(b.x,b.y);
        }
      for(CPanelInput *b=inputs.GetFirstNode(); b!=NULL; b=inputs.GetNextNode()) 
        {
         b.draw();
        }

      CPanelTabContainer *dealsPanel=panels.GetFirstNode();
      dealsPanel.show();
     }

   void onClick(const int x,const int y,const string id) 
     {
      CPanelTabContainer *dealsPanel=panels.GetFirstNode();
      dealsPanel.onClick((int)x,(int)y,id);
      ChartRedraw();
     }

   void setSymbolInfo() 
     {
      for(CPanelLegend *b=legends.GetFirstNode(); b!=NULL; b=legends.GetNextNode()) 
        {
         if(b.name==getLegendName("profit")) 
           {
            b.text= DoubleToString(getSymbolProfit(),2);
           }
         if(b.name==getLegendName("stoplevel")) 
           {
            b.text= (string)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);
           }

         if(b.name==getLegendName("spread")) 
           {
            b.text= (string)SymbolInfoInteger(symbol,SYMBOL_SPREAD);
           }
         b.draw();
        }
     }

   void trace() 
     {
      double profit=getSymbolProfit();
      if(profit!=0.0) 
        {
         Ys=-5;
         buttonHeight=28;
         if(profit>0) 
           {
            tabColor=LightGreen;
              } else {
            tabColor=LightPink;
           }
           } else {
         Ys=0;
         buttonHeight=23;
         tabColor=WhiteSmoke;
        }
      createButton();

      if(isAct) 
        {
         setSymbolInfo();
        }
     }

   double getSymbolProfit() 
     {
      double profit= 0.0;
      int totalPos = PositionsTotal();
      if(totalPos>0) 
        {
         if(PositionSelect(symbol)) 
           {
            profit=PositionGetDouble(POSITION_PROFIT);
           }
        }
      return(profit);
     }

   int getColorByProfit(double profit) 
     {
      int result=MidnightBlue;
      if(profit>0) 
        {
         result=Green;
           } else if(profit<0) {
         result=Red;
        }
      return(result);
     }


  };

#define MAGIC_NUMBER_HANDTRADE 987654321;
//+------------------------------------------------------------------+
class CPanelDealTab: public CPanelTab 
  {
public:
   string            symbol;
   void init() 
     {

      //buttons
      CPanelButton *b1=new CPanelButton();
      b1.name=getButtonName("buy");
      b1.width=50;
      b1.height= 30;
      b1.title = "Buy";
      b1.bgcolour=SkyBlue;
      b1.x = 50;
      b1.y = 140;
      b1.size=10;
      b1.corner=corner;
      b1.windowHandle=windowHandle;
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=getButtonName("sell");
      b2.title = "Sell";
      b2.width = 50;
      b2.height= 30;
      b2.bgcolour=Salmon;
      b2.x = 105;
      b2.y = 140;
      b2.size=10;
      b2.corner=corner;
      b2.windowHandle=windowHandle;
      buttons.Add(b2);

      CPanelButton *b4=new CPanelButton();
      b4.name=getButtonName("modify");
      b4.title = "Modify";
      b4.width = 85;
      b4.height= 30;
      b4.bgcolour=Silver;
      b4.x = 205;
      b4.y = 140;
      b4.size=10;
      b4.corner=corner;
      b4.windowHandle=windowHandle;
      buttons.Add(b4);

      CPanelButton *b3=new CPanelButton();
      b3.name=getButtonName("closeall");
      b3.title = "Close";
      b3.width = 85;
      b3.height= 30;
      b3.bgcolour=DarkKhaki;
      b3.x = 295;
      b3.y = 140;
      b3.size=10;
      b3.corner=corner;
      b3.windowHandle=windowHandle;
      buttons.Add(b3);

      CPanelInput *e1=new CPanelInput();
      e1.name=getInputName("lot");
      e1.title= "lot";
      e1.text = "0.1";
      e1.width= 50;
      e1.height=20;
      e1.bgcolour=LightYellow;
      e1.x = 50;
      e1.y = 110;
      e1.size=10;
      e1.corner=corner;
      e1.windowHandle=windowHandle;
      inputs.Add(e1);

      CPanelInput *e2=new CPanelInput();
      e2.name=getInputName("tp");
      e2.title= "tp, points";
      e2.text = "0";
      e2.width= 50;
      e2.height=20;
      e2.bgcolour=LightGreen;
      e2.x = 105;
      e2.y = 110;
      e2.size=8;
      e2.corner=corner;
      e2.windowHandle=windowHandle;
      inputs.Add(e2);

      CPanelInput *e3=new CPanelInput();
      e3.name=getInputName("sl");
      e3.title= "sl, points";
      e3.text = "0";
      e3.width= 50;
      e3.height=20;
      e3.bgcolour=PeachPuff;
      e3.x = 160;
      e3.y = 110;
      e3.size=8;
      e3.corner=corner;
      e3.windowHandle=windowHandle;
      inputs.Add(e3);

      CPanelInput *e4=new CPanelInput();
      e4.name=getInputName("slippage");
      e4.title= "deviation, points";
      e4.text = "10";
      e4.width= 30;
      e4.height=20;
      e4.bgcolour=Ivory;
      e4.x = 215;
      e4.y = 110;
      e4.size=8;
      e4.corner=corner;
      e4.windowHandle=windowHandle;
      inputs.Add(e4);

      initialize=true;
     }

   void onShow() 
     {
     }

   void onControlsCreate() 
     {
      for(CPanelButton *b=buttons.GetFirstNode(); b!=NULL; b=buttons.GetNextNode()) 
        {
         b.draw(b.x,b.y);
        }
      for(CPanelInput *b=inputs.GetFirstNode(); b!=NULL; b=inputs.GetNextNode()) 
        {
         b.draw();
        }
     }

   void onClick(const int lparam,const int dparam,const string id) 
     {
      if(id==getButtonName("buy")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processBuy((double)getInputValue("lot"));
        }
      if(id==getButtonName("sell")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processSell((double)getInputValue("lot"));
        }
      if(id==getButtonName("closeall")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processCloseAll();
        }

      if(id==getButtonName("modify")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processModify();
        }
     }

   void setSymbolInfo() 
     {
     }

   void trace() 
     {
      if(isAct) 
        {
         setSymbolInfo();
        }
     }

   void processBuy(double lot) 
     {
      MqlTick tick;
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
         int sl = (int)getInputValue("sl");
         int tp = (int)getInputValue("tp");
         if(SymbolInfoTick(symbol,tick)) 
           {
            request.price=tick.ask;
            if(sl>0) request.sl = tick.bid-sl*point;
            if(tp>0) request.tp = tick.ask+tp*point;
            request.action       = TRADE_ACTION_DEAL;
            request.symbol       = symbol;
            request.volume       = lot;
            request.deviation    = (int)getInputValue("slippage");
            request.type         = ORDER_TYPE_BUY;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER_HANDTRADE;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
                 } else {
               MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
              }
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   void processSell(double lot) 
     {
      MqlTick tick;
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {

         double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
         int sl = (int)getInputValue("sl");
         int tp = (int)getInputValue("tp");
         if(SymbolInfoTick(symbol,tick)) 
           {
            request.price=tick.bid;
            if(sl>0) request.sl = tick.ask+sl*point;
            if(tp>0) request.tp = tick.bid-tp*point;
            request.action       = TRADE_ACTION_DEAL;
            request.symbol       = symbol;
            request.volume       = lot;
            request.deviation    = (int)getInputValue("slippage");
            request.type         = ORDER_TYPE_SELL;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER_HANDTRADE;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
                 } else {
               MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
              }
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   void processCloseAll() 
     {
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;
      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         double lot=0.0;
         if(PositionSelect(symbol)) 
           {
            lot=PositionGetDouble(POSITION_VOLUME);
            double maxlot=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
            switch(PositionGetInteger(POSITION_TYPE)) 
              {
               case POSITION_TYPE_BUY:
                  if(lot>maxlot) 
                    {
                     double lot1=maxlot;
                     while(lot>0) 
                       {
                        processSell(lot1);
                        lot=lot-lot1;
                        if(lot>maxlot) 
                          {
                           lot1=maxlot;
                             } else {
                           lot1=lot;
                          }
                       }
                       } else {
                     processSell(lot);
                    }
                  break;
               case POSITION_TYPE_SELL:
                  if(lot>maxlot) 
                    {
                     double lot1=maxlot;
                     while(lot>0) 
                       {
                        processBuy(lot1);
                        lot=lot-lot1;
                        if(lot>maxlot) 
                          {
                           lot1=maxlot;
                             } else {
                           lot1=lot;
                          }
                       }
                       } else {
                     processBuy(lot);
                    }
                  break;
              }
              } else {
            MessageBox("Open positions not found","Error",MB_ICONWARNING);
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   void processModify() 
     {
      MqlTick tick;
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         if(PositionSelect(symbol)) 
           {
            double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
            int sl = (int)getInputValue("sl");
            int tp = (int)getInputValue("tp");
            if(SymbolInfoTick(symbol,tick)) 
              {
               request.price=tick.bid;
               switch(PositionGetInteger(POSITION_TYPE)) 
                 {
                  case POSITION_TYPE_SELL:
                     if(sl>0) request.sl = tick.ask+sl*point;
                     if(tp>0) request.tp = tick.bid-tp*point;
                     break;
                  case POSITION_TYPE_BUY:
                     if(sl>0) request.sl = tick.bid-sl*point;
                     if(tp>0) request.tp = tick.ask+tp*point;
                     break;
                 }
               request.action       = TRADE_ACTION_SLTP;
               request.symbol       = symbol;
               request.deviation    = (int)getInputValue("slippage");
               request.type_time    = ORDER_TIME_GTC;
               request.magic        = MAGIC_NUMBER_HANDTRADE;
               if(OrderCheck(request,checkResult)) 
                 {
                  OrderSend(request,tradeResult);
                    } else {
                  MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
                 }
              }
              } else {
            MessageBox("Open positions not found","Error",MB_ICONWARNING);
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   string getErrorDescription(int errcode) 
     {
      string result="undefined error";
      switch(errcode) 
        {
         case TRADE_RETCODE_REQUOTE:
            result="TRADE_RETCODE_REQUOTE";
            break;
         case TRADE_RETCODE_REJECT:
            result="TRADE_RETCODE_REJECT";
            break;
         case TRADE_RETCODE_CANCEL:
            result="TRADE_RETCODE_CANCEL";
            break;
         case TRADE_RETCODE_ERROR:
            result="TRADE_RETCODE_ERROR";
            break;
         case TRADE_RETCODE_TIMEOUT:
            result="TRADE_RETCODE_TIMEOUT";
            break;
         case TRADE_RETCODE_INVALID:
            result="TRADE_RETCODE_INVALID";
            break;
         case TRADE_RETCODE_INVALID_VOLUME:
            result="TRADE_RETCODE_INVALID_VOLUME";
            break;
         case TRADE_RETCODE_INVALID_PRICE:
            result="TRADE_RETCODE_INVALID_PRICE";
            break;
         case TRADE_RETCODE_INVALID_STOPS:
            result="TRADE_RETCODE_INVALID_STOPS";
            break;
         case TRADE_RETCODE_TRADE_DISABLED:
            result="TRADE_RETCODE_TRADE_DISABLED";
            break;
         case TRADE_RETCODE_MARKET_CLOSED:
            result="TRADE_RETCODE_MARKET_CLOSED";
            break;
         case TRADE_RETCODE_NO_MONEY:
            result="TRADE_RETCODE_NO_MONEY";
            break;
         case TRADE_RETCODE_PRICE_CHANGED:
            result="TRADE_RETCODE_PRICE_CHANGED";
            break;
         case TRADE_RETCODE_PRICE_OFF:
            result="TRADE_RETCODE_PRICE_OFF";
            break;
         case TRADE_RETCODE_INVALID_EXPIRATION:
            result="TRADE_RETCODE_INVALID_EXPIRATION";
            break;
         case TRADE_RETCODE_ORDER_CHANGED:
            result="TRADE_RETCODE_ORDER_CHANGED";
            break;
         case TRADE_RETCODE_TOO_MANY_REQUESTS:
            result="TRADE_RETCODE_TOO_MANY_REQUESTS";
            break;
         case TRADE_RETCODE_NO_CHANGES:
            result="TRADE_RETCODE_NO_CHANGES";
            break;
         case TRADE_RETCODE_SERVER_DISABLES_AT:
            result="TRADE_RETCODE_SERVER_DISABLES_AT";
            break;
         case TRADE_RETCODE_CLIENT_DISABLES_AT:
            result="TRADE_RETCODE_CLIENT_DISABLES_AT";
            break;
         case TRADE_RETCODE_LOCKED:
            result="TRADE_RETCODE_LOCKED";
            break;
         case TRADE_RETCODE_FROZEN:
            result="TRADE_RETCODE_FROZEN";
            break;
         case TRADE_RETCODE_INVALID_FILL:
            result="TRADE_RETCODE_INVALID_FILL";
            break;
         case TRADE_RETCODE_CONNECTION:
            result="TRADE_RETCODE_CONNECTION";
            break;
         case TRADE_RETCODE_ONLY_REAL:
            result="TRADE_RETCODE_ONLY_REAL";
            break;
         case TRADE_RETCODE_LIMIT_ORDERS:
            result="TRADE_RETCODE_LIMIT_ORDERS";
            break;
         case TRADE_RETCODE_LIMIT_VOLUME:
            result="TRADE_RETCODE_LIMIT_VOLUME";
            break;
        }
      return(result);
     }

  };
//+------------------------------------------------------------------+
class CPanelDealPendTab: public CPanelDealTab 
  {
public:
   void init() 
     {
      //buttons
      CPanelButton *b1=new CPanelButton();
      b1.name=getButtonName("buypending");
      b1.width=100;
      b1.height= 30;
      b1.title = "Buy Pending";
      b1.bgcolour=SkyBlue;
      b1.x = 50;
      b1.y = 140;
      b1.size=9;
      b1.corner=corner;
      b1.windowHandle=windowHandle;
      buttons.Add(b1);

      CPanelButton *b2=new CPanelButton();
      b2.name=getButtonName("sellpending");
      b2.title = "Sell Pending";
      b2.width = 100;
      b2.height= 30;
      b2.bgcolour=Salmon;
      b2.x = 155;
      b2.y = 140;
      b2.size=9;
      b2.corner=corner;
      b2.windowHandle=windowHandle;
      buttons.Add(b2);

      CPanelButton *b5=new CPanelButton();
      b5.name=getButtonName("deleteall");
      b5.title = "Delete All";
      b5.width = 60;
      b5.height= 30;
      b5.bgcolour=DarkKhaki;
      b5.x = 320;
      b5.y = 140;
      b5.size=9;
      b5.corner=corner;
      b5.windowHandle=windowHandle;
      buttons.Add(b5);

      CPanelInput *e1=new CPanelInput();
      e1.name=getInputName("lot");
      e1.title= "lot";
      e1.text = "0.1";
      e1.width= 50;
      e1.height=20;
      e1.bgcolour=LightYellow;
      e1.x = 50;
      e1.y = 110;
      e1.size=10;
      e1.corner=corner;
      e1.windowHandle=windowHandle;
      inputs.Add(e1);

      CPanelInput *e2=new CPanelInput();
      e2.name=getInputName("tp");
      e2.title= "tp, points";
      e2.text = "0";
      e2.width= 50;
      e2.height=20;
      e2.bgcolour=LightGreen;
      e2.x = 105;
      e2.y = 110;
      e2.size=8;
      e2.corner=corner;
      e2.windowHandle=windowHandle;
      inputs.Add(e2);

      CPanelInput *e3=new CPanelInput();
      e3.name=getInputName("sl");
      e3.title= "sl, points";
      e3.text = "0";
      e3.width= 50;
      e3.height=20;
      e3.bgcolour=PeachPuff;
      e3.x = 160;
      e3.y = 110;
      e3.size=8;
      e3.corner=corner;
      e3.windowHandle=windowHandle;
      inputs.Add(e3);

      CPanelInput *e4=new CPanelInput();
      e4.name=getInputName("slippage");
      e4.title= "deviat., points";
      e4.text = "10";
      e4.width= 30;
      e4.height=20;
      e4.bgcolour=Ivory;
      e4.x = 215;
      e4.y = 110;
      e4.size=8;
      e4.corner=corner;
      e4.windowHandle=windowHandle;
      inputs.Add(e4);

      CPanelInput *e5=new CPanelInput();
      e5.name=getInputName("price");
      e5.title= "price";
      e5.text = "0.0";
      e5.width= 80;
      e5.height=20;
      e5.bgcolour=Ivory;
      e5.x = 300;
      e5.y = 110;
      e5.size=10;
      e5.corner=corner;
      e5.windowHandle=windowHandle;
      inputs.Add(e5);

      initialize=true;
     }

   void onShow() 
     {
     }

   void onControlsCreate() 
     {
      for(CPanelButton *b=buttons.GetFirstNode(); b!=NULL; b=buttons.GetNextNode()) 
        {
         b.draw(b.x,b.y);
        }
      for(CPanelInput *b=inputs.GetFirstNode(); b!=NULL; b=inputs.GetNextNode()) 
        {
         b.draw();
        }
     }

   void onClick(const int lparam,const int dparam,const string id) 
     {
      if(id==getButtonName("buypending")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processBuyPending();
        }
      if(id==getButtonName("sellpending")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processSellPending();
        }

      if(id==getButtonName("deleteall")) 
        {
         ObjectSetInteger(0,id,OBJPROP_STATE,0);
         processDeletePending();
        }
     }

   void trace() 
     {
     }

   void processBuyPending() 
     {
      MqlTick tick;
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
         int sl = (int)getInputValue("sl");
         int tp = (int)getInputValue("tp");
         double lot=(double)getInputValue("lot");
         double price=(double)getInputValue("price");
         if(SymbolInfoTick(symbol,tick)) 
           {
            request.price=price;
            int type=ORDER_TYPE_BUY_STOP;
            if(price<tick.ask) type=ORDER_TYPE_BUY_LIMIT;
            if(sl>0) request.sl = tick.ask-sl*point;
            if(tp>0) request.tp = tick.ask+tp*point;
            request.action       = TRADE_ACTION_PENDING;
            request.symbol       = symbol;
            request.volume       = lot;
            request.deviation    = (int)getInputValue("slippage");
            request.type         = (ENUM_ORDER_TYPE) type;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER_HANDTRADE;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
                 } else {
               MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
              }
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   void processSellPending() 
     {
      MqlTick tick;
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
         int sl = (int)getInputValue("sl");
         int tp = (int)getInputValue("tp");
         double lot=(double)getInputValue("lot");
         double price=(double)getInputValue("price");
         if(SymbolInfoTick(symbol,tick)) 
           {
            request.price=price;
            int type=ORDER_TYPE_SELL_STOP;
            if(price>tick.bid) type=ORDER_TYPE_SELL_LIMIT;
            if(sl>0) request.sl = tick.bid+sl*point;
            if(tp>0) request.tp = tick.bid-tp*point;
            request.action       = TRADE_ACTION_PENDING;
            request.symbol       = symbol;
            request.volume       = lot;
            request.deviation    = (int)getInputValue("slippage");
            request.type         = (ENUM_ORDER_TYPE) type;
            request.type_filling = ORDER_FILLING_FOK;
            request.type_time    = ORDER_TIME_GTC;
            request.comment      = "";
            request.magic        = MAGIC_NUMBER_HANDTRADE;

            if(OrderCheck(request,checkResult)) 
              {
               OrderSend(request,tradeResult);
                 } else {
               MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
              }
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

   void processDeletePending() 
     {
      MqlTradeRequest request;
      MqlTradeResult tradeResult;
      MqlTradeCheckResult checkResult;

      if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
        {
         int cnt=OrdersTotal();
         if(cnt>0) 
           {
            long ticket=-1;
            for(int i=cnt-1; i>=0; i--) 
              {
               ticket=(int) OrderGetTicket(i);
               if(ticket>0) 
                 {
                  request.action= TRADE_ACTION_REMOVE;
                  request.order = ticket;
                  if(OrderCheck(request,checkResult)) 
                    {
                     OrderSend(request,tradeResult);
                       } else {
                     MessageBox("Error: "+getErrorDescription(checkResult.retcode),"Error",MB_ICONWARNING);
                    }
                 }
              }
              } else {
            MessageBox("Not found pending orders on "+symbol+" ","Message",MB_ICONWARNING);
           }
           } else {
         MessageBox("Trade is disabled","Error",MB_ICONWARNING);
        }
     }

  };
//+------------------------------------------------------------------+
class CPanelMarketTab: public CPanelTab 
  {
private:
public:
   void              CPanelMarketTab();
   void             ~CPanelMarketTab();
   void              init();
   void              onClick(const int x,const int y,const string id);
   void              onHide();
   void              onControlsCreate();
   void              refreshControls();
   string            getAccountType();
   string            getMarginLevel();
   string            getTradeAllowed();
   void              setSymbolInfo();
   void              setAccountInfo();
   void              trace();

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::CPanelMarketTab() 
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::~CPanelMarketTab() 
  {
   int cnt=ObjectsTotal(0);
   string pname;
   for(int j=cnt-1; j>=0; j--) 
     {
      pname=ObjectName(0,j);
      if(StringFind(pname,name,0)!=-1) 
        {
         ObjectDelete(0,pname);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::init() 
  {

   int cnt=12;//SymbolsTotal(false);
              //-- <symbolsPanel>
   string symbols[]={"EURUSD","GBPUSD","USDCHF","USDJPY","USDCAD","AUDUSD","EURGBP","EURAUD","EURCHF","EURJPY","GBPCHF","GBPJPY"};
   string panelId=name+"_symbols";
   CPanelTabContainer *symbolsPanel=new CPanelTabContainer();
   symbolsPanel.X1 = 20;
   symbolsPanel.Y1 = 30;
   symbolsPanel.width=60*cnt;
   symbolsPanel.height = 140;
   symbolsPanel.tshift = 0;
   symbolsPanel.back=0;
   symbolsPanel.corner=CORNER_LEFT_UPPER;
   symbolsPanel.name=panelId;
   symbolsPanel.tabBmp="\\Images\\fatpanel\\symbolpanel.bmp";
   symbolsPanel.mode=INTERFACE_MODE_WINDOW;

   for(int i=0; i<cnt; i++) 
     {
      CPanelSymbolTab *_ptab1=new CPanelSymbolTab();
      _ptab1.title=symbols[i];
      _ptab1.symbol=symbols[i];
      _ptab1.buttonWidth=60;
      _ptab1.bgColor=WhiteSmoke;
      _ptab1.tabColor=WhiteSmoke;
      _ptab1.name=panelId+"-"+symbols[i];
      if(symbols[i]==ChartSymbol(0)) 
        {
         _ptab1.isAct=true;
        }
      _ptab1.tabBmp="\\Images\\fatpanel\\symbolpanel-"+symbols[i]+".bmp";
      symbolsPanel.tabs.Add(_ptab1);
     }
   panels.Add(symbolsPanel);

//inline config
   CPanelLegend *l1=new CPanelLegend();
   l1.name=getLegendName("login");
   l1.width = 100; l1.height = 30;
   l1.title = "Account:";
   l1.text=(string)AccountInfoInteger(ACCOUNT_LOGIN);
   l1.x=20;  l1.y=200; l1.size=10;
   l1.windowHandle=windowHandle;
   legends.Add(l1);

   CPanelLegend *l2=new CPanelLegend();
   l2.name=getLegendName("acctype");
   l2.width = 100; l2.height = 60;
   l2.title = "Account type:";
   l2.text=getAccountType();
   l2.x=20;  l2.y=220; l2.size=10;
   l2.windowHandle=windowHandle;
   legends.Add(l2);

   CPanelLegend *l9=new CPanelLegend();
   l9.name=getLegendName("server");
   l9.width = 100; l9.height = 60;
   l9.title = "Server:";
   l9.text=AccountInfoString(ACCOUNT_SERVER);
   l9.x=20;  l9.y=240; l9.size=10;
   l9.windowHandle=windowHandle;
   legends.Add(l9);

   CPanelLegend *l4=new CPanelLegend();
   l4.name=getLegendName("balance");
   l4.width = 60; l4.height = 60;
   l4.title = "Balance:";
   l4.text=DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2);
   l4.x=270;  l4.y=200; l4.size=10;
   l4.windowHandle=windowHandle;
   legends.Add(l4);

   CPanelLegend *l5=new CPanelLegend();
   l5.name=getLegendName("profit");
   l5.width = 60; l5.height = 60;
   l5.title = "Profit:";
   l5.text=DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT),2);
   l5.x=270;  l5.y=220; l5.size=10;
   l5.windowHandle=windowHandle;
   legends.Add(l5);

   CPanelLegend *l6=new CPanelLegend();
   l6.name=getLegendName("equity");
   l6.width = 60; l6.height = 60;
   l6.title = "Equity:";
   l6.text=DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2);
   l6.x=270;  l6.y=240; l6.size=10;
   l6.windowHandle=windowHandle;
   legends.Add(l6);

   CPanelLegend *l3=new CPanelLegend();
   l3.name=getLegendName("tradeallowed");
   l3.width = 125; l3.height = 60;
   l3.title = "Account access:";
   l3.text=getTradeAllowed();
   l3.x=440;  l3.y=200; l3.size=10;
   l3.windowHandle=windowHandle;
   legends.Add(l3);

   CPanelLegend *l8=new CPanelLegend();
   l8.name=getLegendName("marginlevel");
   l8.width = 125; l8.height = 60;
   l8.title = "Margin level:";
   l8.text=getMarginLevel();
   l8.x=440;  l8.y=220; l8.size=10;
   l8.windowHandle=windowHandle;
   legends.Add(l8);

   CPanelLegend *l7=new CPanelLegend();
   l7.name=getLegendName("currency");
   l7.width = 125; l7.height = 60;
   l7.title = "Account currency:";
   l7.text=AccountInfoString(ACCOUNT_CURRENCY);
   l7.x=440;  l7.y=240; l7.size=10;
   l7.windowHandle=windowHandle;
   legends.Add(l7);

   initialize=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::onControlsCreate() 
  {
   CPanelTabContainer *symbolsPanel=panels.GetFirstNode();
   symbolsPanel.show();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::onClick(const int x,const int y,const string id) 
  {
   if(StringFind(id,"checkbox")!=-1) 
     {
      ObjectSetInteger(0,id+"_bool",OBJPROP_STATE,(int) !(bool)ObjectGetInteger(0,id+"_bool",OBJPROP_STATE));
     }

   if(StringFind(id,"radio")!=-1) 
     {
      string groupId=StringSubstr(id,0,StringFind(id,"radio"));
      int cnt=ObjectsTotal(0,windowHandle);
      string pname;
      for(int j=cnt-1; j>=0; j--) 
        {
         pname=ObjectName(0,j,windowHandle);
         if(StringFind(pname,groupId)!=-1) 
           {
            ObjectSetInteger(0,pname,OBJPROP_STATE,0);
           }
        }
      ObjectSetInteger(0,id+"_bool",OBJPROP_STATE,(int) !(bool)ObjectGetInteger(0,id+"_bool",OBJPROP_STATE));
     }

   CPanelTabContainer *symbolsPanel=panels.GetFirstNode();
   symbolsPanel.onClick((int)x,(int)y,id);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::onHide() 
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::refreshControls() 
  {
   controlsCreated=false;
   CPanelTabContainer *symbolsPanel=panels.GetFirstNode();
   for(CPanelTab *tab=symbolsPanel.tabs.GetFirstNode(); tab!=NULL; tab=symbolsPanel.tabs.GetNextNode()) 
     {
      tab.controlsCreated=false;
     }
   int c=ObjectsTotal(0,windowHandle);
   for(int i=c-1; i>=0; i--) 
     {
      string pname=ObjectName(0,i,windowHandle);
      if(StringFind(pname,name+"-btn")!=-1 || StringFind(pname,name+"_tools")!=-1) 
        {
         ObjectDelete(0,pname);
        }
     }
   show();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::trace() 
  {
   if(isAct && !MQL5InfoInteger(MQL5_TESTING)) 
     {
      setSymbolInfo();
      setAccountInfo();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::setSymbolInfo() 
  {
   string labelname=name+"symbolname";
   if(ObjectFind(0,labelname)<0) 
     {
      ObjectCreate(0,labelname,OBJ_LABEL,0,0,0);
     }
   ObjectSetInteger(0,labelname,OBJPROP_XDISTANCE,15);
   ObjectSetInteger(0,labelname,OBJPROP_YDISTANCE,15);
   ObjectSetInteger(0,labelname,OBJPROP_FONTSIZE,15);
   ObjectSetInteger(0,labelname,OBJPROP_COLOR,MediumVioletRed);
   ObjectSetString(0,labelname,OBJPROP_TEXT,ChartSymbol(0));

   CPanelTabContainer *symbolsPanel=panels.GetFirstNode();
   for(CPanelSymbolTab *tab=symbolsPanel.tabs.GetFirstNode(); tab!=NULL; tab=symbolsPanel.tabs.GetNextNode()) 
     {
      tab.trace();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPanelMarketTab::setAccountInfo() 
  {
   for(CPanelLegend *b=legends.GetFirstNode(); b!=NULL; b=legends.GetNextNode()) 
     {
      if(b.name==getLegendName("balance")) 
        {
         b.text= DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE),2);
        }
      if(b.name==getLegendName("equity")) 
        {
         b.text= DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY),2);
        }
      if(b.name==getLegendName("marginlevel")) 
        {
         b.text= getMarginLevel();
        }
      if(b.name==getLegendName("tradeallowed")) 
        {
         b.text= getTradeAllowed();
        }
      if(b.name==getLegendName("profit")) 
        {
         b.text= DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT),2);
        }
      b.draw();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPanelMarketTab::getAccountType() 
  {
   string result;
   switch(AccountInfoInteger(ACCOUNT_TRADE_MODE)) 
     {
      case ACCOUNT_TRADE_MODE_DEMO:
         result="Demo trading account";
         break;
      case ACCOUNT_TRADE_MODE_CONTEST:
         result="Contest trading account";
         break;
      case ACCOUNT_TRADE_MODE_REAL:
         result="Real trading account";
         break;
      default:
         result="Unknown trade account";
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPanelMarketTab::getMarginLevel() 
  {
   string result="Not found";
   switch(AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE)) 
     {
      case ACCOUNT_STOPOUT_MODE_PERCENT:
         result=DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2)+"%";
         break;
      case ACCOUNT_STOPOUT_MODE_MONEY:
         result=DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL),2)+AccountInfoString(ACCOUNT_CURRENCY);
         break;

     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPanelMarketTab::getTradeAllowed() 
  {
//не отслеживает состояние рынка закрыт/открыт
   string result="invest";
   if((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)) result="direct";
/*
			//отключено т.к. ошибка в терминале. при смене символа если терминал отключает советник в TERMINAL_TRADE_ALLOWED значение не обновляется.
			if ((bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) result = result+" (автоторговля разрешена)"; else {
				result = result+" (автоторговля запрещена)";
			}
			*/
   return(result);
  }

#include <VirtualKeys.mqh> 
#import "kernel32.dll"
int    WinExec(uchar &cmd[],int showConsole);
#import "user32.dll"
void   keybd_event(int bVk,int bScan,int dwFlags,int dwExtraInfo);
#import
//+------------------------------------------------------------------+

class CPanelDispatcher: public CObject 
  {
private:
   CPanelTabContainer mainPanel;
public:
   bool              initialize;

   void CPanelDispatcher() 
     {
      initialize=false;
     }

   void ~CPanelDispatcher()
     {
     }

   void init() 
     {
      if(!initialize) 
        {
         //-- <mainPanel>
         mainPanel.X1 = 0;
         mainPanel.Y1 = 0;
         mainPanel.width=0;
         mainPanel.height = 0;
         mainPanel.tshift = 140;
         mainPanel.back=0;
         mainPanel.corner=CORNER_LEFT_UPPER;
         mainPanel.name = "main";
         mainPanel.mode = INTERFACE_MODE_WINDOW;

         CPanelStrategyTab *_ptab1=new CPanelStrategyTab();
         _ptab1.title= "Algorithm";
         _ptab1.name = "alg";
         _ptab1.isAct= true;
         _ptab1.tabColor=White;
         _ptab1.tabBmp="\\Images\\fatpanel\\fatpanelhead1.bmp";
         mainPanel.tabs.Add(_ptab1);

         CPanelMarketTab *_ptab2=new CPanelMarketTab();
         _ptab2.title= "Chart";
         _ptab2.name = "hnd";
         _ptab2.tabColor=White;
         _ptab2.tabBmp="\\Images\\fatpanel\\fatpanelhead2.bmp";
         mainPanel.tabs.Add(_ptab2);
         //-- </mainPanel> 

         mainPanel.show();

         string pname="btn-fullscreen";
         ObjectCreate(0,pname,OBJ_BUTTON,mainPanel.windowHandle,0,0);
         ObjectSetString(0,pname,OBJPROP_TEXT,"");
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,20);
         ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,0);
         ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,pname,OBJPROP_XSIZE,19);
         ObjectSetInteger(0,pname,OBJPROP_YSIZE,19);
         ObjectSetInteger(0,pname,OBJPROP_COLOR,Black);
         ObjectSetString(0,pname,OBJPROP_FONT,"Arial");

         pname="btn-fullscreen-bool";
         ObjectCreate(0,pname,OBJ_BITMAP_LABEL,mainPanel.windowHandle,0,0);
         ObjectSetInteger(0,pname,OBJPROP_XDISTANCE,20);
         ObjectSetInteger(0,pname,OBJPROP_YDISTANCE,0);
         ObjectSetInteger(0,pname,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetString(0,pname,OBJPROP_BMPFILE,1,"\\Images\\fatpanel\\fullscreenon.bmp");
         ObjectSetString(0,pname,OBJPROP_BMPFILE,0,"\\Images\\fatpanel\\fullscreenoff.bmp");
         ObjectSetInteger(0,pname,OBJPROP_STATE,0);

         initialize=true;
        }
     }

   void control() 
     {
      mainPanel.onTimer();
     }

   void trade() 
     {
     }

   void deinit() 
     {
     }

   void behavior(const int event,const long &lparam,const double &dparam,const string &sparam) 
     {
      if(event==CHARTEVENT_OBJECT_CLICK) 
        {
         int chartShift=0;
         if(mainPanel.mode==INTERFACE_MODE_WINDOW) 
           {
            chartShift=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
           }
         mainPanel.onClick((int)lparam,(int)dparam-chartShift,sparam);
         if(sparam=="btn-fullscreen") 
           {
            ObjectSetInteger(0,sparam+"-bool",OBJPROP_STATE,(int) !(bool)ObjectGetInteger(0,sparam+"-bool",OBJPROP_STATE));
            keybd_event(VK_F11,0,0,0);
            keybd_event(VK_F11,0,2,0);
           }
        }
     }
  };
//+------------------------------------------------------------------+
