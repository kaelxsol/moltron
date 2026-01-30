#!/bin/bash
# ClawSnipe Setup Script

set -e

echo "=== ClawSnipe Setup ==="

# Check for OpenClaw
if ! command -v openclaw &> /dev/null; then
    echo "Installing OpenClaw..."
    npm install -g openclaw
fi

# Check for API key
if [ -z "$GEMINI_API_KEY" ]; then
    echo ""
    echo "GEMINI_API_KEY not set."
    echo "Get a free key at: https://ai.google.dev"
    echo ""
    read -p "Enter your Gemini API key: " GEMINI_API_KEY
    export GEMINI_API_KEY
fi

# Configure model
echo "Configuring model..."
openclaw config set agents.defaults.model.primary "google/gemini-2.0-flash"
openclaw config set browser.enabled true
openclaw config set agents.defaults.sandbox.browser.allowHostControl true

# Install skill
echo "Installing skill..."
mkdir -p ~/.openclaw/skills/clawsnipe
cp SKILL.md ~/.openclaw/skills/clawsnipe/SKILL.md

# Create cron job
echo "Creating cron job..."
openclaw cron add \
  --name "clawsnipe-trader" \
  --every 45s \
  --session isolated \
  --message "You are the clawsnipe trading bot. Use browser snapshot and browser act commands to trade on Axiom. 1) browser snapshot --profile chrome to see the page. 2) Navigate to https://axiom.trade/trackers?chain=sol 3) Look for starred wallets buying. 4) If good setup found, navigate to token page and buy 0.1 SOL. Follow the clawsnipe skill instructions for browser commands. Report: [BOUGHT token] or [SCANNED - no action]"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Start gateway:  GEMINI_API_KEY=\"$GEMINI_API_KEY\" openclaw gateway run"
echo "2. Open Chrome and go to axiom.trade"
echo "3. Click OpenClaw extension icon to attach tab"
echo "4. Bot will start scanning every 45 seconds"
