//+------------------------------------------------------------------+
//|                                              New Heikin Ashi.mq4 |
//|                                                     Roman Geyzer |
//|                                                                  |
//+------------------------------------------------------------------+
#property description "We recommend next chart settings (press F8 or select menu 'Charts'->'Properties...'):"
#property description " - on 'Color' Tab select 'Black' for 'Line Graph'"
#property description " - on 'Common' Tab disable 'Chart on Foreground' checkbox and select 'Line Chart' radiobutton"
#property strict

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red // Changed from Red to Yellow by Nimit Chomnawang.
#property indicator_color2 Green
#property indicator_color3 Red // Changed from Red to Yellow by Nimit Chomnawang.
#property indicator_color4 Green
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3


extern int ShiftUp = 1000 ; 
//---
input color ExtColor1 = Red;    // Shadow of bear candlestick
input color ExtColor2 = Green;  // Shadow of bull candlestick
input color ExtColor3 = Red;    // Bear candlestick body
input color ExtColor4 = Green;  // Bull candlestick body
//--- buffers
double ExtLowHighBuffer[];
double ExtHighLowBuffer[];
double ExtOpenBuffer[];
double ExtCloseBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
void OnInit(void)
  {
   IndicatorShortName("Heiken Ashi");
   IndicatorDigits(Digits);
//--- indicator lines
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1,ExtColor1);
   SetIndexBuffer(0,ExtLowHighBuffer);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1,ExtColor2);
   SetIndexBuffer(1,ExtHighLowBuffer);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,3,ExtColor3);
   SetIndexBuffer(2,ExtOpenBuffer);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,3,ExtColor4);
   SetIndexBuffer(3,ExtCloseBuffer);
//---
   SetIndexLabel(0,"Low/High");
   SetIndexLabel(1,"High/Low");
   SetIndexLabel(2,"Open");
   SetIndexLabel(3,"Close");
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtLowHighBuffer);
   SetIndexBuffer(1,ExtHighLowBuffer);
   SetIndexBuffer(2,ExtOpenBuffer);
   SetIndexBuffer(3,ExtCloseBuffer);
//--- initialization done
  }
//+------------------------------------------------------------------+
//| Heiken Ashi                                                      |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int    i,pos;
   double haOpen,haHigh,haLow,haClose,haOpenA ,haCloseA ;
//---
   if(rates_total<=10)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtLowHighBuffer,false);
   ArraySetAsSeries(ExtHighLowBuffer,false);
   ArraySetAsSeries(ExtOpenBuffer,false);
   ArraySetAsSeries(ExtCloseBuffer,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
//--- preliminary calculation
   if(prev_calculated>1)
      pos=prev_calculated-1;
   else
     {
      //--- set first candle
      if(open[0]<close[0])
        {
         ExtLowHighBuffer[0]=low[0] ;
         ExtHighLowBuffer[0]=high[0];

         
        }
      else
        {
         ExtLowHighBuffer[0]=high[0];
         ExtHighLowBuffer[0]=low[0];

         
        }
      ExtOpenBuffer[0]=open[0];
      ExtCloseBuffer[0]=close[0];
      haOpenA=open[0];
      haCloseA=close[0];
      
      //---
      pos=1;
     }
//--- main loop of calculations
   for(i=pos; i<rates_total; i++)
     {
      haOpen=(haOpenA+haCloseA)/2;
      haClose=(open[i]+high[i]+low[i]+close[i])/4;
      haHigh=MathMax(high[i],MathMax(haOpenA,haCloseA));
      haLow=MathMin(low[i],MathMin(haOpenA,haCloseA));
      haOpenA=haOpen;
      haCloseA=haClose;

           
      if(haOpen<haClose)
        {
         ExtLowHighBuffer[i]=haLow+ShiftUp*Point;
         ExtHighLowBuffer[i]=haHigh+ShiftUp*Point;
         
         
        }
      else
        {
         ExtLowHighBuffer[i]=haHigh+ShiftUp*Point;
         ExtHighLowBuffer[i]=haLow+ShiftUp*Point ;
         
         
        }
        
      ExtOpenBuffer[i]=haOpen+ShiftUp*Point ;
      ExtCloseBuffer[i]=haClose +ShiftUp*Point;
     }
     
    
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
