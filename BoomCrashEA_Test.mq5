//+------------------------------------------------------------------+
//|                                         BoomCrashEA_Test.mq5   |
//|                        Copyright 2025, Trading-EAs Repository   |
//|                                 https://github.com/wamuzeemike  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Trading-EAs Repository"
#property link      "https://github.com/wamuzeemike"
#property version   "1.00"
#property description "Test script for BoomCrashEA functionality"
#property script_show_inputs

// Test input parameters
input string TestSymbol = "Boom1000Index"; // Symbol to test
input bool   RunSymbolTests = true;        // Test symbol detection
input bool   RunSpikeTests = true;         // Test spike calculations
input bool   RunTickTests = true;          // Test tick counting logic

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("=== Boom Crash EA Test Suite ===");
   
   if(RunSymbolTests)
      TestSymbolDetection();
      
   if(RunSpikeTests)
      TestSpikeCalculations();
      
   if(RunTickTests)
      TestTickLogic();
      
   Print("=== Test Suite Complete ===");
}

//+------------------------------------------------------------------+
//| Test symbol detection logic                                      |
//+------------------------------------------------------------------+
void TestSymbolDetection()
{
   Print("\n--- Symbol Detection Tests ---");
   
   string testSymbols[] = {
      "Boom1000Index", "Boom500Index", "BoomIndex",
      "Crash1000Index", "Crash500Index", "CrashIndex",
      "EURUSD", "InvalidSymbol"
   };
   
   for(int i = 0; i < ArraySize(testSymbols); i++)
   {
      string symbol = testSymbols[i];
      bool isBoom = StringFind(symbol, "Boom", 0) >= 0;
      bool isCrash = StringFind(symbol, "Crash", 0) >= 0;
      int requiredTicks = 0;
      
      if(isBoom || isCrash)
      {
         if(StringFind(symbol, "1000", 0) >= 0)
            requiredTicks = 1000;
         else if(StringFind(symbol, "500", 0) >= 0)
            requiredTicks = 500;
         else
            requiredTicks = 100;
      }
      
      Print("Symbol: ", symbol, 
            " | Type: ", isBoom ? "Boom" : (isCrash ? "Crash" : "Other"),
            " | Required Ticks: ", requiredTicks,
            " | Valid: ", (isBoom || isCrash) ? "Yes" : "No");
   }
}

//+------------------------------------------------------------------+
//| Test spike calculation logic                                     |
//+------------------------------------------------------------------+
void TestSpikeCalculations()
{
   Print("\n--- Spike Calculation Tests ---");
   
   // Simulate candle data
   struct TestCandle
   {
      double open;
      double close;
      string type;
   };
   
   TestCandle candles[] = {
      {1.2000, 1.2100, "Bullish Spike"},    // 100 points bullish
      {1.2100, 1.2050, "Small Bearish"},    // 50 points bearish  
      {1.2050, 1.1950, "Bearish Spike"},    // 100 points bearish
      {1.1950, 1.1960, "Small Bullish"},    // 10 points bullish
      {1.1960, 1.2160, "Large Bullish"}     // 200 points bullish
   };
   
   int spikeThreshold = 50; // 50 points threshold
   
   for(int i = 0; i < ArraySize(candles); i++)
   {
      TestCandle candle = candles[i];
      double candleSize = 0;
      bool isBullish = candle.close > candle.open;
      bool isBearish = candle.open > candle.close;
      bool isSpike = false;
      
      if(isBullish)
      {
         candleSize = (candle.close - candle.open) * 10000; // Convert to points
         isSpike = candleSize >= spikeThreshold;
      }
      else if(isBearish)
      {
         candleSize = (candle.open - candle.close) * 10000; // Convert to points
         isSpike = candleSize >= spikeThreshold;
      }
      
      Print("Candle: ", candle.type,
            " | Size: ", candleSize, " points",
            " | Direction: ", isBullish ? "Bullish" : (isBearish ? "Bearish" : "Doji"),
            " | Is Spike: ", isSpike ? "Yes" : "No");
   }
}

//+------------------------------------------------------------------+
//| Test tick counting logic                                         |
//+------------------------------------------------------------------+
void TestTickLogic()
{
   Print("\n--- Tick Logic Tests ---");
   
   struct TickTest
   {
      string symbolType;
      int requiredTicks;
      int currentTicks;
      bool shouldTrade;
   };
   
   TickTest tests[] = {
      {"Boom1000", 1000, 999, false},
      {"Boom1000", 1000, 1000, true},
      {"Boom1000", 1000, 1001, true},
      {"Boom500", 500, 499, false},
      {"Boom500", 500, 500, true},
      {"Crash1000", 1000, 500, false},
      {"Crash500", 500, 600, true}
   };
   
   for(int i = 0; i < ArraySize(tests); i++)
   {
      TickTest test = tests[i];
      bool actualResult = test.currentTicks >= test.requiredTicks;
      bool testPassed = actualResult == test.shouldTrade;
      
      Print("Symbol: ", test.symbolType,
            " | Required: ", test.requiredTicks,
            " | Current: ", test.currentTicks,  
            " | Should Trade: ", test.shouldTrade ? "Yes" : "No",
            " | Test: ", testPassed ? "PASS" : "FAIL");
   }
}

//+------------------------------------------------------------------+
//| Test trailing stop calculations                                  |
//+------------------------------------------------------------------+
void TestTrailingStop()
{
   Print("\n--- Trailing Stop Tests ---");
   
   // Simulate position scenarios
   struct TrailingTest
   {
      string positionType;
      double openPrice;
      double currentPrice;
      double currentSL;
      int trailingStart;
      int trailingStop;
      double expectedNewSL;
      bool shouldModify;
   };
   
   TrailingTest tests[] = {
      {"BUY", 1.2000, 1.2050, 0, 30, 20, 1.2030, true},     // 50 points profit, should trail
      {"BUY", 1.2000, 1.2020, 0, 30, 20, 0, false},         // 20 points profit, below threshold
      {"SELL", 1.2000, 1.1950, 0, 30, 20, 1.1970, true},    // 50 points profit, should trail
      {"SELL", 1.2000, 1.1980, 0, 30, 20, 0, false}         // 20 points profit, below threshold
   };
   
   for(int i = 0; i < ArraySize(tests); i++)
   {
      TrailingTest test = tests[i];
      double profit = 0;
      double newSL = 0;
      bool shouldModify = false;
      
      if(test.positionType == "BUY")
      {
         profit = (test.currentPrice - test.openPrice) * 10000; // Points
         if(profit >= test.trailingStart)
         {
            newSL = test.currentPrice - test.trailingStop * 0.0001;
            shouldModify = true;
         }
      }
      else // SELL
      {
         profit = (test.openPrice - test.currentPrice) * 10000; // Points  
         if(profit >= test.trailingStart)
         {
            newSL = test.currentPrice + test.trailingStop * 0.0001;
            shouldModify = true;
         }
      }
      
      Print("Position: ", test.positionType,
            " | Profit: ", profit, " points",
            " | New SL: ", newSL,
            " | Should Modify: ", shouldModify ? "Yes" : "No",
            " | Expected: ", test.shouldModify ? "Yes" : "No",
            " | Test: ", (shouldModify == test.shouldModify) ? "PASS" : "FAIL");
   }
}