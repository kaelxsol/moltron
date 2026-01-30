<p align="center">
  <img src="moltimus.png" alt="MOLTIMUS" width="200">
</p>

# MOLTIMUS

AI trading agent for Solana memecoins on Axiom. Uses OpenClaw browser automation to execute trades through axiom.trade.

[![ClawHub](https://img.shields.io/badge/ClawHub-moltimus-red)](https://www.clawhub.ai/kaelxsol/moltimus)
[![Website](https://img.shields.io/badge/Website-moltimus.vercel.app-blue)](https://moltimus.vercel.app)

## What It Does

- Monitors tracked wallets for buys
- Scans for high-conviction setups (starred wallets, Twitter calls, low mcap)
- Executes trades automatically via browser control
- Manages positions with stop-loss and take-profit rules

## Requirements

- [OpenClaw](https://openclaw.ai) installed and configured
- Chrome browser with OpenClaw extension
- [Axiom](https://axiom.trade) account (logged in)
- Gemini API key (free at [ai.google.dev](https://ai.google.dev))

## Quick Start

### 1. Install OpenClaw

```bash
npm install -g openclaw
openclaw onboard
```

### 2. Set Gemini API Key

```bash
# Windows
setx GEMINI_API_KEY "your-api-key-here"

# Mac/Linux
export GEMINI_API_KEY="your-api-key-here"
```

### 3. Configure Model

```bash
openclaw config set agents.defaults.model.primary "google/gemini-2.0-flash"
```

### 4. Install the Skill

```bash
# From ClawdHub
npx clawdhub install moltimus

# Or manually copy SKILL.md to:
# ~/.openclaw/skills/moltimus/SKILL.md
```

### 5. Start Gateway

```bash
GEMINI_API_KEY="your-key" openclaw gateway run
```

### 6. Attach Browser

1. Open Chrome
2. Go to [axiom.trade](https://axiom.trade) and log in
3. Click the OpenClaw extension icon to attach the tab

### 7. Create Cron Job

```bash
openclaw cron add \
  --name "moltimus-trader" \
  --every 45s \
  --session isolated \
  --message "You are the moltimus trading bot. Use browser snapshot and browser act commands to trade on Axiom. 1) browser snapshot --profile chrome to see the page. 2) Navigate to https://axiom.trade/trackers?chain=sol 3) Look for starred wallets buying. 4) If good setup found, navigate to token page and buy 0.1 SOL. Follow the moltimus skill instructions for browser commands. Report: [BOUGHT token] or [SCANNED - no action]"
```

## Configuration

### Risk Settings (in SKILL.md)

| Setting | Default | Description |
|---------|---------|-------------|
| Max per trade | 0.5 SOL | Maximum SOL per single trade |
| Max exposure | 2 SOL | Total SOL across all positions |
| Max positions | 3 | Concurrent open positions |
| Stop loss | -20% | Auto-sell trigger |
| Take profit | +50/100/200% | Scaled exit targets |

### Entry Criteria

The bot only buys when:
- Liquidity > 10 SOL
- Mint authority disabled
- No single holder > 10%
- Starred wallet bought OR Twitter call

## Commands

```bash
# Check status
openclaw cron list

# Force run
openclaw cron run <job-id> --force

# View recent runs
openclaw cron runs --id <job-id> --limit 5

# Disable
openclaw cron disable <job-id>
```

## Troubleshooting

### "No API key found for provider google"
Gateway doesn't have GEMINI_API_KEY. Restart with:
```bash
GEMINI_API_KEY="your-key" openclaw gateway --force run
```

### "Browser control service not reachable"
Attach a tab: Click OpenClaw extension icon on your Axiom tab.

### Bot scans but doesn't trade
Check the skill is loaded:
```bash
openclaw skills list | grep moltimus
```

## Links

- [OpenClaw Docs](https://docs.openclaw.ai)
- [Axiom](https://axiom.trade)
- [ClawdHub](https://clawdhub.com)

## License

MIT
