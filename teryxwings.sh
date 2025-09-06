#!/bin/bash
set -e

# === Clone the repository ===
if [ ! -d "daemon" ]; then
    git clone https://github.com/teryxlabs/daemon
fi

# === Go to daemon directory ===
cd daemon

# === Install required tools ===
apt update
apt install -y nodejs npm git zip unzip jq

# === Extract daemon.zip if exists ===
if [ -f "daemon.zip" ]; then
    unzip -o daemon.zip
    cd daemon || true
fi

# === Install dependencies ===
npm install

# === Configure DracoDaemon ===
if [ -f "config.json" ]; then
    echo "🔑 Please enter the Daemon Configuration key (remoteKey): "
    read -r REMOTE_KEY

    # Update config.json with the key
    jq --arg key "$REMOTE_KEY" '.remoteKey = $key' config.json > config.tmp && mv config.tmp config.json

    echo "✅ Remote key set in config.json"
else
    echo "⚠️ config.json not found! You may need to generate or copy it manually."
fi

# === Start the daemon ===
echo "🚀 Starting DracoDaemon..."
echo "Tip: Use 'pm2 start .' to keep it running in background."
node .
