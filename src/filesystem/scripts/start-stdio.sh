#!/bin/bash
# scripts/start-stdio.sh - Stdio mode startup script

set -e

# Default configuration  
DEFAULT_DIRS="$HOME/Documents"
DIRS="${@:-$DEFAULT_DIRS}"

echo "🚀 Starting MCP Filesystem Server (Stdio Mode)"
echo "📁 Allowed directories: $DIRS"
echo ""

# Check if built
if [ ! -f "dist/index.js" ]; then
    echo "🔨 Building server..."
    npm run build
fi

# Check if dependencies installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "📤 Server running on stdio (for Claude Desktop)"
echo ""

# Start server
exec node dist/index.js $DIRS
