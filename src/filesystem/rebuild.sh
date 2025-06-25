#!/bin/bash

echo "🔨 Forcing rebuild of MCP Filesystem Server..."

# Remove old dist
rm -rf dist/

echo "📦 Installing dependencies..."
npm install

echo "🔨 Building TypeScript..."
npm run build

echo "✅ Rebuild complete!"

echo "🧪 Testing HTTP mode:"
echo "  node dist/index.js --http /tmp"
echo ""
echo "🎯 For LM Studio, use: http://localhost:8080/mcp"
