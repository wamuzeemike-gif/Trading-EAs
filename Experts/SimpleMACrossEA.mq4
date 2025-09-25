//+------------------------------------------------------------------+
//|                                        SimpleMACrossEA.mq4      |
//|                               Copyright 2025, Trading-EAs       |
//|                                    Simple MA Cross Strategy      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Trading-EAs"
#property link      ""
#property version   "1.0"
#property strict

//--- Input parameters
input double LotSize = 0.1;              // Lot size
input int FastMA = 5;                    // Fast MA period
input int SlowMA = 15;                   // Slow MA period
input int StopLoss = 30;                 // Stop Loss in pips
input int TakeProfit = 60;               // Take Profit in pips
input int MagicNumber = 54321;           // Magic number
input string Comment = "SimpleMACross";   // Trade comment

//--- Global variables
double point;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   point = Point;
   if(Digits == 5 || Digits == 3) point *= 10;
   
   Print("Simple MA Cross EA initialized");
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("Simple MA Cross EA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!IsTradeAllowed()) return;
   
   // Only one trade at a time
   if(CountTrades() > 0) return;
   
   // Get MA values
   double fast_ma_0 = iMA(NULL, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE, 0);
   double fast_ma_1 = iMA(NULL, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE, 1);
   double slow_ma_0 = iMA(NULL, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE, 0);
   double slow_ma_1 = iMA(NULL, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE, 1);
   
   // Buy signal: Fast MA crosses above Slow MA
   if(fast_ma_0 > slow_ma_0 && fast_ma_1 <= slow_ma_1)
   {
      OpenBuy();
   }
   // Sell signal: Fast MA crosses below Slow MA  
   else if(fast_ma_0 < slow_ma_0 && fast_ma_1 >= slow_ma_1)
   {
      OpenSell();
   }
}

//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
void OpenBuy()
{
   double sl = (StopLoss > 0) ? Ask - StopLoss * point : 0;
   double tp = (TakeProfit > 0) ? Ask + TakeProfit * point : 0;
   
   int ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, sl, tp, Comment, MagicNumber, 0, clrGreen);
   
   if(ticket > 0)
      Print("Buy order opened: ", ticket);
   else
      Print("Error opening buy order: ", GetLastError());
}

//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
void OpenSell()
{
   double sl = (StopLoss > 0) ? Bid + StopLoss * point : 0;
   double tp = (TakeProfit > 0) ? Bid - TakeProfit * point : 0;
   
   int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, sl, tp, Comment, MagicNumber, 0, clrRed);
   
   if(ticket > 0)
      Print("Sell order opened: ", ticket);
   else
      Print("Error opening sell order: ", GetLastError());
}

//+------------------------------------------------------------------+
//| Count trades                                                     |
//+------------------------------------------------------------------+
int CountTrades()
{
   int count = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         count++;
   }
   return count;
}

//+------------------------------------------------------------------+