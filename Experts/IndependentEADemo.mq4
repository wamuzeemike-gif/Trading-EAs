//+------------------------------------------------------------------+
//|                                        IndependentEADemo.mq4    |
//|                               Copyright 2025, Trading-EAs       |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Trading-EAs"
#property link      ""
#property version   "1.0"
#property strict

//--- Input parameters for Strategy Tester optimization
input double LotSize = 0.1;              // Lot size for trades
input int StopLoss = 50;                 // Stop Loss in pips
input int TakeProfit = 100;              // Take Profit in pips
input int RSI_Period = 14;               // RSI period
input double RSI_Oversold = 30;          // RSI oversold level
input double RSI_Overbought = 70;        // RSI overbought level
input int MA_Fast_Period = 10;           // Fast MA period
input int MA_Slow_Period = 20;           // Slow MA period
input int MaxSpread = 5;                 // Maximum allowed spread in pips
input bool UseTrailingStop = true;       // Enable trailing stop
input int TrailingStop = 30;             // Trailing stop in pips
input int TrailingStep = 10;             // Trailing step in pips
input int MagicNumber = 12345;           // Magic number for trades
input string TradeComment = "IndependentEA"; // Trade comment

//--- Global variables
double point;
int digits;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Get point value and digits for current symbol
   point = Point;
   digits = Digits;
   
   //--- Adjust point for 5-digit brokers
   if(digits == 5 || digits == 3)
      point *= 10;
   
   //--- Print initialization info
   Print("IndependentEA Demo initialized for ", Symbol());
   Print("Point: ", point, ", Digits: ", digits);
   Print("Lot Size: ", LotSize, ", Stop Loss: ", StopLoss, " pips, Take Profit: ", TakeProfit, " pips");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("IndependentEA Demo deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check if market is closed
   if(!IsTradeAllowed())
      return;
   
   //--- Check spread
   double spread = Ask - Bid;
   if(spread > MaxSpread * point)
   {
      Comment("Spread too high: ", DoubleToStr(spread/point, 1), " pips");
      return;
   }
   
   //--- Update trailing stops
   if(UseTrailingStop)
      UpdateTrailingStops();
   
   //--- Check for new trade signals
   CheckForTradingSignals();
   
   //--- Update display
   UpdateDisplay();
}

//+------------------------------------------------------------------+
//| Check for trading signals                                         |
//+------------------------------------------------------------------+
void CheckForTradingSignals()
{
   //--- Don't open new trades if we already have positions
   if(CountOpenTrades() > 0)
      return;
   
   //--- Get technical indicators
   double rsi = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, 0);
   double ma_fast_current = iMA(NULL, 0, MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ma_fast_previous = iMA(NULL, 0, MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 1);
   double ma_slow_current = iMA(NULL, 0, MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ma_slow_previous = iMA(NULL, 0, MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 1);
   
   //--- Buy signal: RSI oversold and fast MA crosses above slow MA
   bool buy_signal = (rsi < RSI_Oversold) && 
                     (ma_fast_current > ma_slow_current) && 
                     (ma_fast_previous <= ma_slow_previous);
   
   //--- Sell signal: RSI overbought and fast MA crosses below slow MA
   bool sell_signal = (rsi > RSI_Overbought) && 
                      (ma_fast_current < ma_slow_current) && 
                      (ma_fast_previous >= ma_slow_previous);
   
   //--- Execute trades
   if(buy_signal)
   {
      OpenBuyTrade();
   }
   else if(sell_signal)
   {
      OpenSellTrade();
   }
}

//+------------------------------------------------------------------+
//| Open buy trade                                                   |
//+------------------------------------------------------------------+
void OpenBuyTrade()
{
   double entry_price = Ask;
   double sl = (StopLoss > 0) ? entry_price - StopLoss * point : 0;
   double tp = (TakeProfit > 0) ? entry_price + TakeProfit * point : 0;
   
   int ticket = OrderSend(Symbol(), OP_BUY, LotSize, entry_price, 3, sl, tp, 
                         TradeComment + " Buy", MagicNumber, 0, clrGreen);
   
   if(ticket > 0)
   {
      Print("Buy order opened successfully. Ticket: ", ticket, 
            ", Entry: ", DoubleToStr(entry_price, digits),
            ", SL: ", DoubleToStr(sl, digits),
            ", TP: ", DoubleToStr(tp, digits));
   }
   else
   {
      Print("Error opening buy order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open sell trade                                                  |
//+------------------------------------------------------------------+
void OpenSellTrade()
{
   double entry_price = Bid;
   double sl = (StopLoss > 0) ? entry_price + StopLoss * point : 0;
   double tp = (TakeProfit > 0) ? entry_price - TakeProfit * point : 0;
   
   int ticket = OrderSend(Symbol(), OP_SELL, LotSize, entry_price, 3, sl, tp, 
                         TradeComment + " Sell", MagicNumber, 0, clrRed);
   
   if(ticket > 0)
   {
      Print("Sell order opened successfully. Ticket: ", ticket, 
            ", Entry: ", DoubleToStr(entry_price, digits),
            ", SL: ", DoubleToStr(sl, digits),
            ", TP: ", DoubleToStr(tp, digits));
   }
   else
   {
      Print("Error opening sell order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Count open trades for this EA                                    |
//+------------------------------------------------------------------+
int CountOpenTrades()
{
   int count = 0;
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) && 
         OrderSymbol() == Symbol() && 
         OrderMagicNumber() == MagicNumber)
      {
         count++;
      }
   }
   return count;
}

//+------------------------------------------------------------------+
//| Update trailing stops                                            |
//+------------------------------------------------------------------+
void UpdateTrailingStops()
{
   for(int i = 0; i < OrdersTotal(); i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) && 
         OrderSymbol() == Symbol() && 
         OrderMagicNumber() == MagicNumber)
      {
         if(OrderType() == OP_BUY)
         {
            double new_sl = Bid - TrailingStop * point;
            if(new_sl > OrderStopLoss() + TrailingStep * point && new_sl > OrderOpenPrice())
            {
               bool result = OrderModify(OrderTicket(), OrderOpenPrice(), new_sl, 
                                       OrderTakeProfit(), 0, clrBlue);
               if(result)
                  Print("Buy trailing stop updated for ticket: ", OrderTicket(), 
                        ", New SL: ", DoubleToStr(new_sl, digits));
            }
         }
         else if(OrderType() == OP_SELL)
         {
            double new_sl = Ask + TrailingStop * point;
            if((OrderStopLoss() == 0 || new_sl < OrderStopLoss() - TrailingStep * point) && 
               new_sl < OrderOpenPrice())
            {
               bool result = OrderModify(OrderTicket(), OrderOpenPrice(), new_sl, 
                                       OrderTakeProfit(), 0, clrBlue);
               if(result)
                  Print("Sell trailing stop updated for ticket: ", OrderTicket(), 
                        ", New SL: ", DoubleToStr(new_sl, digits));
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Update display information                                        |
//+------------------------------------------------------------------+
void UpdateDisplay()
{
   string display_text = "\n";
   display_text += "=== Independent EA Demo ===\n";
   display_text += "Symbol: " + Symbol() + "\n";
   display_text += "Spread: " + DoubleToStr((Ask-Bid)/point, 1) + " pips\n";
   display_text += "Open Trades: " + IntegerToString(CountOpenTrades()) + "\n";
   
   //--- Get current indicator values
   double rsi = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, 0);
   double ma_fast = iMA(NULL, 0, MA_Fast_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   double ma_slow = iMA(NULL, 0, MA_Slow_Period, 0, MODE_SMA, PRICE_CLOSE, 0);
   
   display_text += "RSI(" + IntegerToString(RSI_Period) + "): " + DoubleToStr(rsi, 2) + "\n";
   display_text += "Fast MA(" + IntegerToString(MA_Fast_Period) + "): " + DoubleToStr(ma_fast, digits) + "\n";
   display_text += "Slow MA(" + IntegerToString(MA_Slow_Period) + "): " + DoubleToStr(ma_slow, digits) + "\n";
   
   //--- Show account info
   display_text += "Account Balance: " + DoubleToStr(AccountBalance(), 2) + "\n";
   display_text += "Account Equity: " + DoubleToStr(AccountEquity(), 2) + "\n";
   
   Comment(display_text);
}

//+------------------------------------------------------------------+
//| Timer function (optional - for additional functionality)         |
//+------------------------------------------------------------------+
void OnTimer()
{
   //--- This function can be used for periodic tasks
   //--- Currently not implemented but available for future enhancements
}

//+------------------------------------------------------------------+
//| ChartEvent function (optional - for user interactions)           |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   //--- This function can be used to handle chart events
   //--- Currently not implemented but available for future enhancements
}

//+------------------------------------------------------------------+