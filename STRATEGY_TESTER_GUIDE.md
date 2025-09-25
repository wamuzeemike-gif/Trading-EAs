# Strategy Tester Configuration Guide

## Quick Start Guide for Strategy Tester

### 1. Installation
1. Copy the `.mq4` files from the `Experts` folder to your MetaTrader 4 `MQL4/Experts` directory
2. Open MetaEditor and compile each EA to generate the `.ex4` files
3. Restart MetaTrader 4 to see the EAs in your Navigator

### 2. Setting up Strategy Tester

#### Basic Testing:
1. **Open Strategy Tester**: Press Ctrl+R or View → Strategy Tester
2. **Select EA**: Choose "IndependentEADemo" or "SimpleMACrossEA"
3. **Select Symbol**: Choose your preferred currency pair (e.g., EURUSD)
4. **Select Model**: 
   - "Open prices only" - Fastest, basic testing
   - "Control points" - Good balance of speed and accuracy
   - "Every tick" - Most accurate, slowest
5. **Set Date Range**: Select your testing period
6. **Click Start**: Begin the backtest

#### Advanced Testing (Optimization):
1. **Check "Optimization"** checkbox in Strategy Tester
2. **Select Parameters**: Double-click on parameters you want to optimize
3. **Set Ranges**: Define min, max, and step values for each parameter
4. **Run Optimization**: This will test multiple parameter combinations

### 3. Expert Advisors Included

#### IndependentEADemo.mq4
- **Strategy**: RSI + Moving Average crossover with risk management
- **Features**: Trailing stops, spread control, comprehensive logging
- **Best for**: Long-term testing and optimization

#### SimpleMACrossEA.mq4  
- **Strategy**: Simple moving average crossover
- **Features**: Clean, straightforward implementation
- **Best for**: Quick testing and learning

### 4. Recommended Test Settings

#### For IndependentEADemo:
- **Model**: Control points or Every tick
- **Period**: M15 or H1 for best results
- **Date Range**: At least 3 months of data
- **Symbols**: Major pairs (EURUSD, GBPUSD, USDJPY)

#### For SimpleMACrossEA:
- **Model**: Control points
- **Period**: H1 or H4
- **Date Range**: 6 months to 1 year
- **Symbols**: Trending pairs work best

### 5. Optimization Tips

1. **Start Simple**: Begin with default parameters
2. **One at a Time**: Optimize one parameter group at a time
3. **Realistic Data**: Use quality historical data
4. **Forward Testing**: Always validate results on recent data
5. **Risk Management**: Never optimize stop loss and take profit together

### 6. Performance Metrics to Watch

- **Profit Factor**: Should be > 1.3
- **Maximum Drawdown**: Should be < 20%
- **Win Rate**: Look for consistency, not just high win rate
- **Sharpe Ratio**: Risk-adjusted returns
- **Recovery Factor**: Profit / Max Drawdown

### 7. Common Issues and Solutions

**Issue**: EA doesn't open trades
- **Solution**: Check if "Allow live trading" is enabled
- **Solution**: Verify spread settings and market hours

**Issue**: Different results on different runs
- **Solution**: Use "Every tick" model for consistent results
- **Solution**: Ensure data quality and completeness

**Issue**: Optimization takes too long
- **Solution**: Reduce date range or parameter ranges
- **Solution**: Use "Control points" model instead of "Every tick"

### 8. Next Steps

1. **Demo Testing**: Test successful parameters on demo account
2. **Forward Testing**: Validate on out-of-sample data
3. **Live Trading**: Start with small lot sizes
4. **Monitor Performance**: Regular review and adjustment

### 9. File Structure
```
Trading-EAs/
├── Experts/
│   ├── IndependentEADemo.mq4    # Main demo EA
│   └── SimpleMACrossEA.mq4      # Simple MA cross EA
├── Include/                     # (Empty - for future libraries)
├── README.md                    # Main documentation
├── STRATEGY_TESTER_GUIDE.md     # This guide
└── .gitignore                   # Git ignore file
```

### 10. Support

For issues or questions:
1. Check the main README.md file
2. Review the EA source code comments
3. Use the GitHub repository's issue tracker