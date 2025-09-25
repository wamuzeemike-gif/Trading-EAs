//+------------------------------------------------------------------+
//|                                                 BoomCrashEA.mq5 |
//|                        Copyright 2025, Trading-EAs Repository   |
//|                                 https://github.com/wamuzeemike  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Trading-EAs Repository"
#property link      "https://github.com/wamuzeemike"
#property version   "1.00"
#property description "Expert Advisor for Boom and Crash indices with spike-based trading"

//--- Input parameters
input group "== Trade Settings =="
input double   LotSize = 0.01;           // Lot size for trades
input int      TakeProfit = 100;         // Take Profit in points
input int      StopLoss = 50;            // Stop Loss in points

input group "== Spike Detection =="
input int      SpikeThreshold = 50;      // Spike threshold in points
input int      LookbackCandles = 3;      // Number of candles to look back for spike detection

input group "== Trailing Stop =="
input bool     UseTrailingStop = true;   // Enable trailing stop
input int      TrailingStart = 20;       // Points in profit to start trailing
input int      TrailingStep = 10;        // Trailing step in points
input int      TrailingStop = 15;        // Trailing stop distance in points

input group "== Tick Control =="
input bool     UseTickControl = true;    // Enable tick-based trading control
input int      TickCounter = 0;          // Internal tick counter (do not modify)

//--- Global variables
int tickCount = 0;
int requiredTicks = 0;
string symbolType = "";
bool isBoomSymbol = false;
bool isCrashSymbol = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Check if symbol is Boom or Crash
   string symbol = Symbol();
   symbolType = symbol;
   
   if(StringFind(symbol, "Boom", 0) >= 0)
   {
      isBoomSymbol = true;
      isCrashSymbol = false;
      
      // Determine required ticks based on symbol
      if(StringFind(symbol, "1000", 0) >= 0)
         requiredTicks = 1000;
      else if(StringFind(symbol, "500", 0) >= 0)
         requiredTicks = 500;
      else
         requiredTicks = 100; // Default for other Boom variants
   }
   else if(StringFind(symbol, "Crash", 0) >= 0)
   {
      isCrashSymbol = true;
      isBoomSymbol = false;
      
      // Determine required ticks based on symbol
      if(StringFind(symbol, "1000", 0) >= 0)
         requiredTicks = 1000;
      else if(StringFind(symbol, "500", 0) >= 0)
         requiredTicks = 500;
      else
         requiredTicks = 100; // Default for other Crash variants
   }
   else
   {
      Print("Warning: This EA is designed for Boom and Crash symbols only. Current symbol: ", symbol);
      return(INIT_FAILED);
   }
   
   Print("Boom Crash EA initialized for symbol: ", symbol);
   Print("Symbol type: ", isBoomSymbol ? "Boom" : "Crash");
   Print("Required ticks: ", requiredTicks);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("Boom Crash EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Increment tick counter
   if(UseTickControl)
   {
      tickCount++;
      if(tickCount < requiredTicks)
         return; // Wait for required number of ticks
      
      tickCount = 0; // Reset counter after reaching threshold
   }
   
   // Check if we already have a position open
   if(PositionsTotal() > 0)
   {
      // Apply trailing stop if enabled
      if(UseTrailingStop)
         ApplyTrailingStop();
      return; // Only one position per symbol
   }
   
   // Check for spike patterns
   if(isBoomSymbol)
   {
      if(DetectBullishSpike())
      {
         OpenSellOrder();
      }
   }
   else if(isCrashSymbol)
   {
      if(DetectBearishSpike())
      {
         OpenBuyOrder();
      }
   }
}

//+------------------------------------------------------------------+
//| Detect bullish spike (for Boom symbols)                         |
//+------------------------------------------------------------------+
bool DetectBullishSpike()
{
   double high[], low[], open[], close[];
   
   if(CopyHigh(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, high) != LookbackCandles ||
      CopyLow(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, low) != LookbackCandles ||
      CopyOpen(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, open) != LookbackCandles ||
      CopyClose(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, close) != LookbackCandles)
   {
      Print("Error copying price data");
      return false;
   }
   
   // Check the most recent candle for a bullish spike
   int lastIndex = LookbackCandles - 1;
   double candleSize = (close[lastIndex] - open[lastIndex]) / _Point;
   
   // For bullish spike: close > open and size > threshold
   if(close[lastIndex] > open[lastIndex] && candleSize >= SpikeThreshold)
   {
      Print("Bullish spike detected. Candle size: ", candleSize, " points");
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Detect bearish spike (for Crash symbols)                        |
//+------------------------------------------------------------------+
bool DetectBearishSpike()
{
   double high[], low[], open[], close[];
   
   if(CopyHigh(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, high) != LookbackCandles ||
      CopyLow(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, low) != LookbackCandles ||
      CopyOpen(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, open) != LookbackCandles ||
      CopyClose(Symbol(), PERIOD_CURRENT, 1, LookbackCandles, close) != LookbackCandles)
   {
      Print("Error copying price data");
      return false;
   }
   
   // Check the most recent candle for a bearish spike
   int lastIndex = LookbackCandles - 1;
   double candleSize = (open[lastIndex] - close[lastIndex]) / _Point;
   
   // For bearish spike: open > close and size > threshold
   if(open[lastIndex] > close[lastIndex] && candleSize >= SpikeThreshold)
   {
      Print("Bearish spike detected. Candle size: ", candleSize, " points");
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Open sell order (for Boom symbols after bullish spike)         |
//+------------------------------------------------------------------+
void OpenSellOrder()
{
   double price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double sl = (StopLoss > 0) ? price + StopLoss * _Point : 0;
   double tp = (TakeProfit > 0) ? price - TakeProfit * _Point : 0;
   
   MqlTradeRequest request;
   MqlTradeResult result;
   
   ZeroMemory(request);
   request.action = TRADE_ACTION_DEAL;
   request.symbol = Symbol();
   request.volume = LotSize;
   request.type = ORDER_TYPE_SELL;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 10;
   request.magic = 123456;
   request.comment = "Boom Sell Spike";
   
   if(OrderSend(request, result))
   {
      Print("Sell order opened successfully. Ticket: ", result.order);
   }
   else
   {
      Print("Failed to open sell order. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open buy order (for Crash symbols after bearish spike)         |
//+------------------------------------------------------------------+
void OpenBuyOrder()
{
   double price = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double sl = (StopLoss > 0) ? price - StopLoss * _Point : 0;
   double tp = (TakeProfit > 0) ? price + TakeProfit * _Point : 0;
   
   MqlTradeRequest request;
   MqlTradeResult result;
   
   ZeroMemory(request);
   request.action = TRADE_ACTION_DEAL;
   request.symbol = Symbol();
   request.volume = LotSize;
   request.type = ORDER_TYPE_BUY;
   request.price = price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 10;
   request.magic = 123456;
   request.comment = "Crash Buy Spike";
   
   if(OrderSend(request, result))
   {
      Print("Buy order opened successfully. Ticket: ", result.order);
   }
   else
   {
      Print("Failed to open buy order. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Apply aggressive trailing stop                                   |
//+------------------------------------------------------------------+
void ApplyTrailingStop()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(PositionSelectByIndex(i))
      {
         if(PositionGetString(POSITION_SYMBOL) != Symbol())
            continue;
            
         ulong ticket = PositionGetInteger(POSITION_TICKET);
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentSL = PositionGetDouble(POSITION_SL);
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         double currentPrice;
         double newSL = 0;
         bool modifyOrder = false;
         
         if(type == POSITION_TYPE_BUY)
         {
            currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
            double profit = currentPrice - openPrice;
            
            // Check if we're in profit enough to start trailing
            if(profit >= TrailingStart * _Point)
            {
               newSL = currentPrice - TrailingStop * _Point;
               
               // Only modify if new SL is better than current SL
               if(newSL > currentSL + TrailingStep * _Point || currentSL == 0)
               {
                  modifyOrder = true;
               }
            }
         }
         else if(type == POSITION_TYPE_SELL)
         {
            currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            double profit = openPrice - currentPrice;
            
            // Check if we're in profit enough to start trailing
            if(profit >= TrailingStart * _Point)
            {
               newSL = currentPrice + TrailingStop * _Point;
               
               // Only modify if new SL is better than current SL
               if(newSL < currentSL - TrailingStep * _Point || currentSL == 0)
               {
                  modifyOrder = true;
               }
            }
         }
         
         if(modifyOrder)
         {
            MqlTradeRequest request;
            MqlTradeResult result;
            
            ZeroMemory(request);
            request.action = TRADE_ACTION_SLTP;
            request.symbol = Symbol();
            request.position = ticket;
            request.sl = newSL;
            request.tp = PositionGetDouble(POSITION_TP);
            
            if(OrderSend(request, result))
            {
               Print("Trailing stop updated. New SL: ", newSL);
            }
            else
            {
               Print("Failed to update trailing stop. Error: ", GetLastError());
            }
         }
      }
   }
}