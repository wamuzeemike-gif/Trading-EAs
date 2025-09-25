//+------------------------------------------------------------------+
//|                                      BoomCrashEA_Settings.mqh |
//|                        Copyright 2025, Trading-EAs Repository   |
//|                                 https://github.com/wamuzeemike  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Trading-EAs Repository"
#property link      "https://github.com/wamuzeemike"

//+------------------------------------------------------------------+
//| Recommended Settings for Different Risk Profiles                |
//+------------------------------------------------------------------+

// Conservative Settings - Lower risk, smaller positions
struct ConservativeSettings
{
   static const double LotSize = 0.01;
   static const int TakeProfit = 150;
   static const int StopLoss = 75;
   static const int SpikeThreshold = 100;
   static const int TrailingStart = 30;
   static const int TrailingStep = 15;
   static const int TrailingStop = 20;
};

// Moderate Settings - Balanced risk/reward
struct ModerateSettings
{
   static const double LotSize = 0.02;
   static const int TakeProfit = 100;
   static const int StopLoss = 50;
   static const int SpikeThreshold = 70;
   static const int TrailingStart = 25;
   static const int TrailingStep = 12;
   static const int TrailingStop = 18;
};

// Aggressive Settings - Higher risk, larger positions
struct AggressiveSettings
{
   static const double LotSize = 0.05;
   static const int TakeProfit = 80;
   static const int StopLoss = 40;
   static const int SpikeThreshold = 30;
   static const int TrailingStart = 15;
   static const int TrailingStep = 8;
   static const int TrailingStop = 12;
};

// Scalping Settings - Very short-term trades
struct ScalpingSettings
{
   static const double LotSize = 0.03;
   static const int TakeProfit = 50;
   static const int StopLoss = 25;
   static const int SpikeThreshold = 20;
   static const int TrailingStart = 10;
   static const int TrailingStep = 5;
   static const int TrailingStop = 8;
};

//+------------------------------------------------------------------+
//| Symbol-specific optimized settings                               |
//+------------------------------------------------------------------+

// Boom 1000 optimized settings
struct Boom1000Settings
{
   static const int SpikeThreshold = 80;
   static const int TakeProfit = 120;
   static const int StopLoss = 60;
   static const int TrailingStart = 25;
};

// Boom 500 optimized settings  
struct Boom500Settings
{
   static const int SpikeThreshold = 60;
   static const int TakeProfit = 100;
   static const int StopLoss = 50;
   static const int TrailingStart = 20;
};

// Crash 1000 optimized settings
struct Crash1000Settings
{
   static const int SpikeThreshold = 80;
   static const int TakeProfit = 120;
   static const int StopLoss = 60;
   static const int TrailingStart = 25;
};

// Crash 500 optimized settings
struct Crash500Settings
{
   static const int SpikeThreshold = 60;
   static const int TakeProfit = 100;
   static const int StopLoss = 50;  
   static const int TrailingStart = 20;
};

//+------------------------------------------------------------------+
//| Time-based settings for different market conditions             |
//+------------------------------------------------------------------+

// High volatility period settings (news events, market open)
struct HighVolatilitySettings
{
   static const int SpikeThreshold = 120;
   static const int TakeProfit = 200;
   static const int StopLoss = 100;
   static const bool UseTickControl = false; // More frequent trading
};

// Low volatility period settings (market close, holidays)
struct LowVolatilitySettings
{
   static const int SpikeThreshold = 30;
   static const int TakeProfit = 60;
   static const int StopLoss = 30;
   static const bool UseTickControl = true; // Wait for ticks
};

//+------------------------------------------------------------------+
//| Utility functions for settings management                        |
//+------------------------------------------------------------------+

// Get recommended spike threshold based on symbol
int GetRecommendedSpikeThreshold(string symbol)
{
   if(StringFind(symbol, "Boom1000", 0) >= 0 || StringFind(symbol, "Crash1000", 0) >= 0)
      return 80;
   else if(StringFind(symbol, "Boom500", 0) >= 0 || StringFind(symbol, "Crash500", 0) >= 0)
      return 60;
   else
      return 50; // Default
}

// Get recommended lot size based on account balance
double GetRecommendedLotSize(double accountBalance)
{
   if(accountBalance < 100)
      return 0.01;
   else if(accountBalance < 500)
      return 0.02;
   else if(accountBalance < 1000)
      return 0.03;
   else
      return 0.05;
}

// Check if current time is high volatility period
bool IsHighVolatilityPeriod()
{
   MqlDateTime time;
   TimeToStruct(TimeCurrent(), time);
   
   // Assume high volatility during certain hours (can be customized)
   int hour = time.hour;
   
   // European and US market overlap (13:00-17:00 GMT)
   if(hour >= 13 && hour <= 17)
      return true;
      
   // US market open (13:30-15:00 GMT)
   if(hour >= 13 && hour <= 15)
      return true;
      
   return false;
}