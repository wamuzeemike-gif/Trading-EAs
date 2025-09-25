# Trading-EAs
All things Forex

## Expert Advisors

### BoomCrashEA.mq5
A specialized MT5 Expert Advisor designed for trading Boom and Crash indices with spike-based strategy.

**Features:**
- Spike detection algorithm for volatile synthetic indices
- Symbol-specific tick control (500/1000 tick intervals)
- Aggressive trailing stop functionality
- One position per symbol risk management
- Comprehensive input parameters for customization

**Strategy:**
- **Boom pairs**: Sells after bullish spike detection
- **Crash pairs**: Buys after bearish spike detection
- Suitable for scalping and short-term trading

**Files:**
- `BoomCrashEA.mq5` - Main Expert Advisor
- `BoomCrashEA_Documentation.md` - Comprehensive documentation
- `BoomCrashEA_Settings.mqh` - Recommended settings and configurations

**Installation:**
1. Copy the .mq5 file to your MT5 Experts folder
2. Compile in MetaEditor
3. Attach to Boom or Crash chart
4. Configure parameters as needed
5. Enable auto-trading

See `BoomCrashEA_Documentation.md` for detailed setup instructions and recommended settings.
