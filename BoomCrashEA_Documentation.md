# Boom Crash Expert Advisor (BoomCrashEA.mq5)

## Overview
This MT5 Expert Advisor is specifically designed for trading Boom and Crash indices. It implements a spike-based trading strategy that capitalizes on the volatility characteristics of these synthetic indices.

## Trading Strategy
- **Boom Pairs**: Sells after detecting a large bullish candle (spike up)
- **Crash Pairs**: Buys after detecting a large bearish candle (spike down)
- **Risk Management**: Implements adjustable Take Profit, Stop Loss, and aggressive trailing stop

## Key Features

### 1. Symbol Detection
- Automatically detects Boom and Crash symbols
- Works with all variants (Boom 500, Boom 1000, Crash 500, Crash 1000, etc.)
- Fails gracefully if used on unsupported symbols

### 2. Tick-Based Trading Control
- **Boom/Crash 1000**: Trades only after every 1000 ticks
- **Boom/Crash 500**: Trades only after every 500 ticks
- **Other variants**: Defaults to 100 ticks
- Can be disabled via UseTickControl parameter

### 3. Spike Detection Algorithm
- **Spike Threshold**: User-defined minimum candle size in points
- **Lookback Period**: Configurable number of candles to analyze
- **Bullish Spike**: Close > Open with size >= threshold
- **Bearish Spike**: Open > Close with size >= threshold

### 4. Position Management
- **One Trade Rule**: Only one position per symbol at a time
- **Magic Number**: Uses 123456 for trade identification
- **Trade Comments**: "Boom Sell Spike" or "Crash Buy Spike"

### 5. Aggressive Trailing Stop
- **Activation**: Starts when trade is in profit by TrailingStart points
- **Tightening**: Updates stop loss every TrailingStep points
- **Distance**: Maintains TrailingStop points from current price

## Input Parameters

### Trade Settings
- **LotSize** (0.01): Position size for all trades
- **TakeProfit** (100): Take profit level in points
- **StopLoss** (50): Stop loss level in points

### Spike Detection
- **SpikeThreshold** (50): Minimum candle size to qualify as spike (points)
- **LookbackCandles** (3): Number of recent candles to analyze

### Trailing Stop
- **UseTrailingStop** (true): Enable/disable trailing stop functionality
- **TrailingStart** (20): Minimum profit to activate trailing (points)
- **TrailingStep** (10): Minimum movement to update stop loss (points)
- **TrailingStop** (15): Distance from current price for stop loss (points)

### Tick Control
- **UseTickControl** (true): Enable tick-based trading restrictions
- **TickCounter** (0): Internal counter - do not modify

## Installation and Setup

1. Copy `BoomCrashEA.mq5` to your MT5 `Experts` folder
2. Compile the EA in MetaEditor
3. Attach to a Boom or Crash chart
4. Configure input parameters according to your risk tolerance
5. Enable auto-trading in MT5

## Recommended Settings

### Conservative Setup
- LotSize: 0.01
- SpikeThreshold: 100
- TakeProfit: 150
- StopLoss: 75
- TrailingStart: 30

### Aggressive Setup
- LotSize: 0.05
- SpikeThreshold: 30
- TakeProfit: 80
- StopLoss: 40
- TrailingStart: 15

## Risk Warnings

1. **Synthetic Indices Risk**: Boom and Crash indices are highly volatile synthetic instruments
2. **Spike Strategy Risk**: Strategy relies on volatility patterns that may change
3. **One Trade Limitation**: Only one position per symbol limits diversification
4. **Tick Dependency**: Performance depends on tick frequency and timing
5. **Market Conditions**: May perform differently in various market conditions

## Troubleshooting

### Common Issues
- **No Trades Opening**: Check if UseTickControl is enabled and sufficient ticks have passed
- **Wrong Symbol Error**: Ensure EA is attached to Boom or Crash symbols only
- **Trailing Stop Not Working**: Verify UseTrailingStop is enabled and position is sufficiently in profit

### Log Messages
- Monitor the Experts log for spike detection confirmations
- Trade execution success/failure messages are logged
- Trailing stop updates are recorded

## Version History
- **1.00**: Initial release with core functionality

## License
This EA is released under the MIT License. See LICENSE file for details.

## Support
For issues and questions, please refer to the repository documentation or create an issue on GitHub.