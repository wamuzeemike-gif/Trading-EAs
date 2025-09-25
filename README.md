# Trading-EAs
All things Forex

## Independent EA Demo for Strategy Tester

This repository contains a complete MetaTrader 4 Expert Advisor (EA) designed specifically for independent operation in the Strategy Tester. The EA implements a robust trading strategy with comprehensive risk management features.

### Features

- **Independent Operation**: Runs completely independently without external dependencies
- **Strategy Tester Compatible**: Fully optimized for MetaTrader 4 Strategy Tester
- **Multiple Technical Indicators**: Uses RSI and Moving Average crossover strategy
- **Risk Management**: Includes Stop Loss, Take Profit, and Trailing Stop functionality
- **Spread Control**: Monitors and limits trades based on spread conditions
- **Comprehensive Logging**: Detailed trade logging for analysis
- **Optimizable Parameters**: All key parameters can be optimized in Strategy Tester

### Trading Strategy

The EA uses a combination of:
1. **RSI (Relative Strength Index)**: Identifies overbought/oversold conditions
2. **Moving Average Crossover**: Fast MA crossing slow MA for trend confirmation
3. **Risk Management**: Automatic stop loss and take profit levels
4. **Trailing Stops**: Dynamic stop loss adjustment to lock in profits

### Installation and Usage

1. **Copy the EAs**: Copy the files from the `Experts/` folder to your MetaTrader 4 `MQL4/Experts` directory
2. **Compile**: Open MetaEditor and compile each EA to generate the `.ex4` files
3. **Strategy Tester**: 
   - Open MetaTrader 4
   - Go to View → Strategy Tester (or press Ctrl+R)
   - Select "IndependentEADemo" or "SimpleMACrossEA" from the Expert Advisor dropdown
   - Configure your test parameters
   - Click "Start" to run the backtest

For detailed instructions, see [STRATEGY_TESTER_GUIDE.md](STRATEGY_TESTER_GUIDE.md)

### Input Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| LotSize | 0.1 | Trade lot size |
| StopLoss | 50 | Stop loss in pips |
| TakeProfit | 100 | Take profit in pips |
| RSI_Period | 14 | RSI calculation period |
| RSI_Oversold | 30 | RSI oversold level |
| RSI_Overbought | 70 | RSI overbought level |
| MA_Fast_Period | 10 | Fast moving average period |
| MA_Slow_Period | 20 | Slow moving average period |
| MaxSpread | 5 | Maximum allowed spread in pips |
| UseTrailingStop | true | Enable/disable trailing stop |
| TrailingStop | 30 | Trailing stop distance in pips |
| TrailingStep | 10 | Trailing stop step in pips |
| MagicNumber | 12345 | Unique identifier for EA trades |
| TradeComment | "IndependentEA" | Comment for all trades |

### Strategy Tester Optimization

This EA is designed for optimization in the Strategy Tester. You can:

1. **Single Test**: Test with default parameters
2. **Optimization**: Optimize any combination of input parameters
3. **Forward Testing**: Use the EA on demo accounts after backtesting
4. **Multiple Timeframes**: Test on different timeframes (M1, M5, M15, H1, H4, D1)

### Best Practices

1. **Backtest First**: Always backtest thoroughly before live trading
2. **Optimize Parameters**: Use Strategy Tester optimization for your specific symbol and timeframe
3. **Risk Management**: Never risk more than 1-2% of your account per trade
4. **Demo Testing**: Test on demo account before going live
5. **Monitor Performance**: Regular monitoring and adjustment of parameters

### Files Included

```
Trading-EAs/
├── Experts/
│   ├── IndependentEADemo.mq4    # Main comprehensive EA with RSI+MA strategy
│   └── SimpleMACrossEA.mq4      # Simple moving average crossover EA
├── Include/                     # Reserved for future MQL4 include files
├── README.md                    # Main documentation
├── STRATEGY_TESTER_GUIDE.md     # Detailed testing and optimization guide
├── LICENSE                      # MIT License
└── .gitignore                   # Git ignore file
```

### Expert Advisors Available

#### 1. IndependentEADemo.mq4
- **Primary EA** for the Strategy Tester
- Advanced RSI and Moving Average crossover strategy
- Comprehensive risk management features
- Full optimization capabilities
- Detailed logging and display

#### 2. SimpleMACrossEA.mq4  
- Simple moving average crossover strategy
- Clean, easy-to-understand code
- Perfect for learning and quick testing
- Minimal parameters for fast optimization

### License

This project is licensed under the MIT License - see the LICENSE file for details.

### Support

For questions, issues, or contributions, please use the GitHub repository's issue tracker.
