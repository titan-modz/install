#!/bin/bash
set -e

# === Clone the repository ===
if [ ! -d "v4panel" ]; then
    git clone https://github.com/teryxlabs/v4panel
fi

# === Setup Node.js 23.x ===
curl -sL https://deb.nodesource.com/setup_23.x | sudo bash -

# === Install dependencies ===
apt-get update
apt-get install -y nodejs git zip unzip

# === Enter panel directory ===
cd v4panel

# === Extract panel.zip if exists ===
if [ -f "panel.zip" ]; then
    apt install -y zip unzip
    unzip -o panel.zip
fi

# === Install Node.js dependencies & setup ===
npm install
npm run seed
npm run createUser

# === Start the panel (foreground) ===
echo "🚀 Starting panel with Node.js..."
echo "Tip: use 'pm2 start .' to keep it running in background."
node .
