#!/bin/bash
# scripts/start-http.sh - HTTP mode startup script

set -e

# Default configuration
DEFAULT_PORT=8080
DEFAULT_DIRS="$HOME/Documents"

# Parse command line arguments
PORT=${PORT:-$DEFAULT_PORT}
DIRS="${@:-$DEFAULT_DIRS}"

echo "🚀 Starting MCP Filesystem Server (HTTP Mode)"
echo "📡 Port: $PORT"
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

echo "🌐 Server will be available at: http://localhost:$PORT/mcp"
echo "🛑 Press Ctrl+C to stop"
echo ""

# Start server
exec node dist/index.js --http --port="$PORT" $DIRS
