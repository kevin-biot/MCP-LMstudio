# MCP Filesystem Server

A production-ready **Model Context Protocol (MCP) server** that provides secure filesystem access for AI assistants like Claude, LM Studio, and VS Code Copilot.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node Version](https://img.shields.io/badge/node-%3E%3D18-brightgreen)](https://nodejs.org/)

## ✨ Features

- 🔒 **Secure sandboxing** - Access limited to specified directories
- 🌐 **Dual transport** - Supports both HTTP and stdio modes
- 📁 **Complete filesystem operations** - Read, write, edit, search, and manage files
- 🔍 **Advanced file operations** - Memory-efficient tail/head, diff-based editing
- 🛡️ **Path validation** - Protection against directory traversal attacks
- 🔗 **Symlink safety** - Proper symlink resolution and validation
- 📊 **Rich metadata** - File sizes, permissions, timestamps
- 🎯 **Multiple clients** - Works with Claude Desktop, LM Studio, VS Code, and more

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/kevinbrown/mcp-filesystem-server
cd mcp-filesystem-server

# Install and build
./scripts/install.sh
```

### HTTP Mode (for LM Studio, web clients)

```bash
# Start server with access to your directories
./scripts/start-http.sh ~/Documents ~/Projects ~/Code

# Server runs at http://localhost:8080/mcp
```

### Stdio Mode (for Claude Desktop)

```bash
# Start server for Claude Desktop
./scripts/start-stdio.sh ~/Documents ~/Projects
```

## 🔧 Client Configuration

### LM Studio
```json
{
  "mcpServers": {
    "filesystem": {
      "url": "http://localhost:8080/mcp",
      "transport": "http"
    }
  }
}
```

### Claude Desktop
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "node",
      "args": ["/path/to/mcp-filesystem-server/dist/index.js", "~/Documents", "~/Projects"]
    }
  }
}
```

### VS Code
```json
{
  "mcp": {
    "servers": {
      "filesystem": {
        "command": "node",
        "args": ["/path/to/mcp-filesystem-server/dist/index.js", "~/Documents"]
      }
    }
  }
}
```

## 🛠️ Available Tools

| Tool | Description | Example Use |
|------|-------------|-------------|
| `read_file` | Read complete file contents | Code review, documentation |
| `write_file` | Create or overwrite files | Generate code, save content |
| `edit_file` | Make targeted edits with diffs | Refactor code, update configs |
| `list_directory` | Browse directory contents | Explore project structure |
| `search_files` | Find files by pattern | Locate specific files |
| `create_directory` | Create new directories | Set up project structure |
| `move_file` | Move or rename files | Organize files |
| `get_file_info` | Get file metadata | Check file properties |
| `read_multiple_files` | Read several files at once | Compare multiple files |
| `list_directory_with_sizes` | Directory listing with sizes | Analyze disk usage |
| `directory_tree` | Recursive directory structure | Understand project layout |
| `list_allowed_directories` | Show accessible directories | Verify permissions |

## 🔒 Security Features

- **Sandboxed access** - Only specified directories are accessible
- **Path validation** - Prevents directory traversal attacks
- **Symlink resolution** - Safely handles symbolic links
- **Permission checking** - Validates file system permissions
- **Error isolation** - Secure error handling without information leakage

## 📋 Usage Examples

### Basic Commands

```bash
# HTTP mode on custom port
PORT=3000 ./scripts/start-http.sh ~/Code ~/Documents

# Stdio mode with multiple directories
./scripts/start-stdio.sh ~/Projects ~/Documents ~/Desktop

# Using environment variables
export MCP_PORT=8080
export MCP_DIRS="~/Documents ~/Projects"
./scripts/start-http.sh
```

### Advanced Configuration

```bash
# Start with specific directory access
node dist/index.js --http --port=3000 \
  "/Users/username/Projects" \
  "/Users/username/Documents" \
  "/Users/username/Scripts"
```

## 🔧 Configuration Options

### Command Line Arguments

- `--http` - Enable HTTP mode (default: stdio)
- `--port=PORT` - Set HTTP port (default: 8080)
- `DIR1 DIR2 ...` - Allowed directories (required)

### Environment Variables

- `PORT` - HTTP server port
- `MCP_DIRS` - Colon-separated allowed directories
- `NODE_ENV` - Environment (development/production)

## 🐳 Docker Support

```dockerfile
# Dockerfile example
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080
CMD ["node", "dist/index.js", "--http", "/workspace"]
```

```bash
# Build and run
docker build -t mcp-filesystem .
docker run -p 8080:8080 -v ~/Projects:/workspace mcp-filesystem
```

## 🧪 Testing the Server

### HTTP Mode Testing

```bash
# Test server health
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'

# List available tools
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
```

### Stdio Mode Testing

```bash
# Test with MCP Inspector
npx @modelcontextprotocol/inspector dist/index.js ~/Documents
```

## 🚨 Troubleshooting

### Common Issues

**Server won't start**
- Check Node.js version (≥18 required)
- Verify all directories exist and are accessible
- Ensure port is not already in use

**Path validation errors**
- Use absolute paths for directories
- Avoid symlinked directories (use real paths)
- Check directory permissions

**LM Studio connection issues**
- Verify server is running on correct port
- Check MCP configuration syntax
- Ensure proper Accept headers

### Debug Mode

```bash
# Enable debug logging
DEBUG=mcp:* ./scripts/start-http.sh ~/Documents

# Verbose output
node dist/index.js --http --verbose ~/Documents
```

## 📚 Documentation

- [Installation Guide](examples/README.md)
- [Configuration Examples](examples/)
- [Security Best Practices](#security-features)
- [API Reference](#available-tools)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on the [Model Context Protocol](https://modelcontextprotocol.io/) specification
- Inspired by the official MCP reference implementations
- Thanks to the Anthropic team for creating MCP

## 🔗 Related Projects

- [Model Context Protocol](https://github.com/modelcontextprotocol/specification)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [Claude Desktop](https://claude.ai/download)
- [LM Studio](https://lmstudio.ai/)

---

⭐ **Star this repo** if you find it useful! |
| `edit_file` | Make targeted edits with diffs | Refactor code, update configs |
| `list_directory` | Browse directory contents | Explore project structure |
| `search_files` | Find files by pattern | Locate specific files |
| `create_directory` | Create new directories | Set up project structure |
| `move_file` | Move or rename files | Organize files |
| `get_file_info` | Get file metadata | Check file properties |
| `read_multiple_files` | Read several files at once | Compare multiple files |
| `list_directory_with_sizes` | Directory listing with sizes | Analyze disk usage |
| `directory_tree` | Recursive directory structure | Understand project layout |
| `list_allowed_directories` | Show accessible directories | Verify permissions |

## 🔒 Security Features

- **Sandboxed access** - Only specified directories are accessible
- **Path validation** - Prevents directory traversal attacks
- **Symlink resolution** - Safely handles symbolic links
- **Permission checking** - Validates file system permissions
- **Error isolation** - Secure error handling without information leakage

## 📁 Project Structure

```
mcp-filesystem-server/
├── README.md                 # This file
├── package.json              # Package configuration
├── tsconfig.json            # TypeScript configuration
├── src/
│   ├── index.ts             # Main server file
│   ├── types.ts             # Type definitions
│   └── utils/
│       ├── path-utils.ts    # Path validation utilities
│       └── file-utils.ts    # File operation utilities
├── scripts/
│   ├── start-http.sh        # HTTP mode startup script
│   ├── start-stdio.sh       # Stdio mode startup script
│   └── install.sh           # Installation script
├── examples/
│   ├── claude-desktop.json  # Claude Desktop config
│   ├── lm-studio.json      # LM Studio config
│   └── vscode-mcp.json     # VS Code MCP config
└── dist/                    # Compiled JavaScript (generated)
```

## ⚙️ Configuration Options

### Command Line Arguments

```bash
# HTTP mode with custom port
node dist/index.js --http --port=3000 ~/Documents ~/Projects

# Stdio mode (default)
node dist/index.js ~/Documents ~/Projects
```

### Environment Variables

```bash
# Set default port for HTTP mode
export PORT=3000

# Use in startup scripts
./scripts/start-http.sh ~/Documents
```

## 🧪 Testing the Server

### Test HTTP Mode

```bash
# Start server
./scripts/start-http.sh ~/Documents

# Test with curl
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}'
```

### Test Stdio Mode

```bash
# Test with echo (basic test)
echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}' | node dist/index.js ~/Documents
```

## 🔧 Development

### Building from Source

```bash
# Install dependencies
npm install

# Build TypeScript
npm run build

# Watch mode for development
npm run dev
```

### Project Scripts

```bash
npm run build          # Build TypeScript
npm run dev            # Watch mode
npm run start:http     # Start HTTP mode
npm run start:stdio    # Start stdio mode
npm run clean          # Clean dist directory
```

## 🚨 Troubleshooting

### Common Issues

#### "Access denied - path outside allowed directories"
- **Cause**: Path is outside specified directories or symlink issues
- **Solution**: Use absolute paths, check for symlinks (e.g., `/tmp` → `/private/tmp` on macOS)

#### "Parent directory does not exist"
- **Cause**: Directory doesn't exist or permission issues
- **Solution**: Create directory first or check permissions

#### LM Studio not connecting
- **Cause**: Server not running, wrong URL, or port issues
- **Solution**: Verify server is running on `http://localhost:8080/mcp`

#### Model not using MCP tools
- **Cause**: Model doesn't support tool calling or MCP not properly configured
- **Solution**: Use a tool-capable model (Llama 3.1, Qwen2.5, etc.) and verify MCP connection

### Debug Commands

```bash
# Check server status
curl -I http://localhost:8080/mcp

# List available tools
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}'

# Test directory access
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": "list_allowed_directories", "arguments": {}}}'
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on the [Model Context Protocol](https://modelcontextprotocol.io/) specification
- Inspired by the official MCP reference implementations
- Thanks to the Anthropic team for creating MCP

## 🔗 Related Projects

- [Model Context Protocol](https://github.com/modelcontextprotocol/specification)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [Claude Desktop](https://claude.ai/download)
- [LM Studio](https://lmstudio.ai/)

---

⭐ **Star this repo** if you find it useful!
