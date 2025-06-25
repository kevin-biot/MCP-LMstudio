#!/bin/bash
# scripts/install.sh - Installation script

set -e

echo "📦 Installing MCP Filesystem Server..."

# Check Node.js version
NODE_VERSION=$(node --version 2>/dev/null || echo "none")
if [ "$NODE_VERSION" = "none" ]; then
    echo "❌ Node.js not found. Please install Node.js 18+ first."
    exit 1
fi

MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | cut -d'v' -f2)
if [ $MAJOR_VERSION -lt 18 ]; then
    echo "❌ Node.js $NODE_VERSION found. Please upgrade to Node.js 18+."
    exit 1
fi

echo "✅ Node.js $NODE_VERSION found"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build project
echo "🔨 Building TypeScript..."
npm run build

# Make scripts executable
chmod +x scripts/*.sh

echo ""
echo "✅ Installation complete!"
echo ""
echo "🚀 Quick start:"
echo "  HTTP mode:  ./scripts/start-http.sh ~/Documents ~/Projects"
echo "  Stdio mode: ./scripts/start-stdio.sh ~/Documents ~/Projects"
echo ""
echo "📚 See README.md for configuration examples"
