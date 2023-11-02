//+------------------------------------------------------------------+
//|                                       Heiken Ashi day Trader.mq4 |
//|                                                     Roman Geyzer |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Roman Geyzer"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// extrenal varibles: 

extern int MagicNumber = 123456;
//will be changed per currency pair

double RR_ratio = 2;// not in use

extern int FirstTradingHour = 1;
extern int LastTradingHour = 23;
int TradingMinutes = 00;
//Trades placed at te begining of the hour

// following is trading general configoration strategy


bool UseRR = false; //// not in use
// RR will overide SL and TP - only relevent for: range, double, trend, last candles SL
bool UseTP = true;// not in use
//TP can be false if usuing exit strategy

// following only chooses strategies to use
bool UseHA = false; // not in use
bool UseMA = true;// default
bool UseDouble = false; // not in use
bool UseBreakOut = false; // not in use
bool UsePatterns = false; // not in use
bool UseRange = false; // not in use
bool UseBB = false; // not in use
bool UseSR = false; // not in use
// Engulfing or doji+ another candle


// following only relevent for strategies combination and confirmation - need to make sure that in use in all subfunctions in strategies functions
bool ConfirmWithMA = false;// not in use
extern bool ConfirmWithHA = false;
extern bool ConfirmWithPattern = false;
extern bool ConfirmWithFIB = false;
extern bool ConfirmWithRSI = false;
extern bool ConfirmWithMACD = false;
extern bool ConfirmWithBB = false;
//cinfirm with BB - dont buy low and sell high

// following only relevent for managing trades using strategy
extern bool UseMAExit = false;
extern bool UseHAExit = false;
extern bool UseDoubleExit = false;
extern bool UseRangExit = false;
extern bool UseBreakOutExit = false;
extern bool UseMACDExit = false;
bool UseCloseSLExit = false;//not in use
bool UseSRExit = false;//not in use
extern bool UseBBExit = false;
extern bool UsePatternsExit = false;
// Engulfing and doji+ another candle


/* ******************* decided to keep out for the meantime - MACD strategy
extern double MACDFastEMA=12;
extern double MACDSlowEMA=26;
extern double MACDSMA=9;
extern double MACDLimit=9;
*/


#include <Open Orders include.mqh>
#include <Manage Open Trades include.mqh>
#include <HA include.mqh>
#include <MA include.mqh>
#include <Close SL include.mqh>
#include <Range include.mqh>
#include <Double include.mqh>
#include <BB include.mqh>
#include <RSI include.mqh>
#include <FIB include.mqh>
#include <Pattern include.mqh>


int OnInit() {  return(INIT_SUCCEEDED);}

void OnDeinit(const int reason) {  }

//+------------------------------------------------------------------+
//| Start of General functions:                               |
//+------------------------------------------------------------------+

double CalculateLotSize(double SL) //Calculate the size of the position size 
{         
   double nTickValue=MarketInfo(Symbol(),MODE_TICKVALUE); //We get the value of a tick
   double LotSize=(AccountBalance()*MaxRiskPerTrade/100)/(SL*nTickValue);   //We apply the formula to calculate the position size and assign the value to the variable
   return LotSize/10;
}

double CalculatePipSize() //Calculate the size of the position size 
{         
   return (Point*10);
}

void OnTick()
{
    Comment (" curren trades open: ",OpenOrdersThisPair (Symbol()));

    if (TimeMinute(TimeCurrent())== TradingMinutes && TimeHour (TimeCurrent())>= FirstTradingHour && TimeHour (TimeCurrent ())<=LastTradingHour )
    {
        if (OpenOrdersThisPair (Symbol()) ==0)
        {       
              if (check_is_buy ()) PlaceBuyOrder();
              else if (check_is_sell() ) PlaceSellOrder();
        }
       // else check_open_trade ()
     }
 if (OpenOrdersThisPair (Symbol()) ==1 && TimeMinute (TimeCurrent () - OrderOpenTime())> Period() ) manage_open_trade();
    if (OpenOrdersThisPair (Symbol()) ==1) manage_SL();
}





              
