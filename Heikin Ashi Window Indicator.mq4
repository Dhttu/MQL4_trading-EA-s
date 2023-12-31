//+------------------------------------------------------------------+
//|                                                  heiken-ashi.mq4 |
//|        ©2011 Best-metatrader-indicators.com. All rights reserved |
//|                        http://www.best-metatrader-indicators.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011 Best-metatrader-indicators.com."
#property link      "http://www.best-metatrader-indicators.com"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Green
//----
extern color color1 = Red;
extern color color2 = Green;
extern color color3 = Red;
extern color color4 = Green;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
string Copyright="\xA9 WWW.BEST-METATRADER-INDICATORS.COM"; 
string MPrefix="FI";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_HISTOGRAM, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1, DRAW_HISTOGRAM, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2, DRAW_HISTOGRAM, 0, 3, color3);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3, DRAW_HISTOGRAM, 0, 3, color4);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0, 10);
   SetIndexDrawBegin(1, 10);
   SetIndexDrawBegin(2, 10);
   SetIndexDrawBegin(3, 10);
//---- indicator buffers mapping
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexBuffer(3, ExtMapBuffer4);
//---- initialization done
   DL("001", Copyright, 5, 20,Gold,"Arial",10,0); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ClearObjects(); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double haOpen, haHigh, haLow, haClose;
   if(Bars <= 10) 
       return(0);
   ExtCountedBars = IndicatorCounted();
//---- check for possible errors
   if(ExtCountedBars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(ExtCountedBars > 0) 
       ExtCountedBars--;
   int pos = Bars - ExtCountedBars - 1;
   while(pos >= 0)
     {
       haOpen = (ExtMapBuffer3[pos+1] + ExtMapBuffer4[pos+1]) / 2;
       haClose = (Open[pos] + High[pos] + Low[pos] + Close[pos]) / 4;
       haHigh = MathMax(High[pos], MathMax(haOpen, haClose));
       haLow = MathMin(Low[pos], MathMin(haOpen, haClose));
       if(haOpen  <haClose) 
         {
           ExtMapBuffer1[pos] = haLow;
           ExtMapBuffer2[pos] = haHigh;
         } 
       else
         {
           ExtMapBuffer1[pos] = haHigh;
           ExtMapBuffer2[pos] = haLow;
         } 
       ExtMapBuffer3[pos] = haOpen;
       ExtMapBuffer4[pos] = haClose;
 	     pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DL function                                                      |
//+------------------------------------------------------------------+
 void DL(string label, string text, int x, int y, color clr, string FontName = "Arial",int FontSize = 12, int typeCorner = 1)
 
{
   string labelIndicator = MPrefix + label;   
   if (ObjectFind(labelIndicator) == -1)
   {
      ObjectCreate(labelIndicator, OBJ_LABEL, 0, 0, 0);
  }
   
   ObjectSet(labelIndicator, OBJPROP_CORNER, typeCorner);
   ObjectSet(labelIndicator, OBJPROP_XDISTANCE, x);
   ObjectSet(labelIndicator, OBJPROP_YDISTANCE, y);
   ObjectSetText(labelIndicator, text, FontSize, FontName, clr);
  
}  

//+------------------------------------------------------------------+
//| ClearObjects function                                            |
//+------------------------------------------------------------------+
void ClearObjects() 
{ 
  for(int i=0;i<ObjectsTotal();i++) 
  if(StringFind(ObjectName(i),MPrefix)==0) { ObjectDelete(ObjectName(i)); i--; } 
}
//+------------------------------------------------------------------+