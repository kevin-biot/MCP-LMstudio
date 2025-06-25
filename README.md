# MCP-LMstudio

A collection of Model Context Protocol (MCP) servers optimized for use with LM Studio and other local AI models.

## About

This repository contains reference implementations and custom servers for the [Model Context Protocol](https://modelcontextprotocol.io/) (MCP), specifically tailored for integration with LM Studio. MCP enables secure, controlled access to tools and data sources for Large Language Models (LLMs).

## 🌟 Available Servers

### Reference Servers
- **[Everything](src/everything)** - Reference/test server with prompts, resources, and tools
- **[Fetch](src/fetch)** - Web content fetching and conversion for efficient LLM usage
- **[Filesystem](src/filesystem)** - Secure file operations with configurable access controls
- **[Git](src/git)** - Tools to read, search, and manipulate Git repositories
- **[Memory](src/memory)** - Knowledge graph-based persistent memory system
- **[Sequential Thinking](src/sequentialthinking)** - Dynamic and reflective problem-solving through thought sequences
- **[Time](src/time)** - Time and timezone conversion capabilities

### Custom Servers for LM Studio
Coming soon - custom servers optimized for local LLM workflows.

## 🚀 Quick Start

### Prerequisites
- **LM Studio**: Version 0.2.0 or higher with MCP support
- **Node.js**: Version 18+ 
- **npm or pnpm**: For package management

### Installation

1. Clone this repository:
```bash
git clone https://github.com/kevin-biot/MCP-LMstudio.git
cd MCP-LMstudio
```

2. Install dependencies:
```bash
npm install
# or
pnpm install
```

3. Build the servers:
```bash
npm run build
```

## ⚙️ LM Studio Configuration

### Method 1: HTTP Server Configuration (Recommended)

Start the MCP servers in HTTP mode and configure LM Studio to connect:

#### 1. Start MCP Servers with HTTP Transport

**Basic startup:**
```bash
# Start filesystem server on HTTP
npm run start:filesystem -- --transport=http --port=8080

# Start additional servers on different ports
npm run start:fetch -- --transport=http --port=8081
npm run start:memory -- --transport=http --port=8082
```

**With directory configuration:**
```bash
# Configure allowed directories for filesystem server
export MCP_ALLOWED_DIRS="/Users/kevinbrown/Documents,/Users/kevinbrown/servers,/workspace"
npm run start:filesystem -- --transport=http --port=8080
```

#### 2. Configure LM Studio
Add this configuration to your LM Studio settings:

**File**: LM Studio Settings → Model Context Protocol

```json
{
  "mcpServers": {
    "filesystem-http": {
      "url": "http://localhost:8080/mcp"
    },
    "fetch-http": {
      "url": "http://localhost:8081/mcp"
    },
    "memory-http": {
      "url": "http://localhost:8082/mcp"
    }
  }
}
```

### Method 2: Stdio Configuration

For direct stdio communication (advanced users):

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "node",
      "args": ["/path/to/MCP-LMstudio/build/src/filesystem/index.js"],
      "env": {
        "MCP_ALLOWED_DIRS": "/safe/directory/path"
      }
    },
    "fetch": {
      "command": "node",
      "args": ["/path/to/MCP-LMstudio/build/src/fetch/index.js"]
    },
    "memory": {
      "command": "node", 
      "args": ["/path/to/MCP-LMstudio/build/src/memory/index.js"],
      "env": {
        "MCP_MEMORY_DIR": "/path/to/memory/storage"
      }
    }
  }
}
```

### Method 3: Docker Configuration

Run servers in Docker containers:

```bash
# Build Docker image
docker build -t mcp-lmstudio .

# Run individual servers with volume mounts
docker run -d -p 8080:3000 \
  -v /safe/directories:/app/allowed-dirs \
  -e MCP_ALLOWED_DIRS="/app/allowed-dirs" \
  --name mcp-filesystem mcp-lmstudio node build/src/filesystem/index.js

docker run -d -p 8081:3000 --name mcp-fetch mcp-lmstudio node build/src/fetch/index.js
docker run -d -p 8082:3000 --name mcp-memory mcp-lmstudio node build/src/memory/index.js
```

Then configure LM Studio with Docker URLs:
```json
{
  "mcpServers": {
    "filesystem-docker": {
      "url": "http://localhost:8080/mcp"
    },
    "fetch-docker": {
      "url": "http://localhost:8081/mcp"
    },
    "memory-docker": {
      "url": "http://localhost:8082/mcp"
    }
  }
}
```

## 🔧 Server-Specific Configuration

### 🗂️ Filesystem Server Configuration

**⚠️ IMPORTANT SECURITY**: The filesystem server requires explicit directory configuration. **NO DIRECTORIES ARE ACCESSIBLE BY DEFAULT**.

#### Environment Variables

| Variable | Purpose | Example | Default |
|----------|---------|---------|---------|
| `MCP_ALLOWED_DIRS` | **Required**: Comma-separated safe directories | `/home/user/docs,/workspace` | None (server won't start) |
| `MCP_READ_ONLY` | Restrict to read-only operations | `true` or `false` | `false` |
| `MCP_MAX_FILE_SIZE` | Maximum file size to read (bytes) | `10485760` (10MB) | `5242880` (5MB) |
| `MCP_EXCLUDED_PATTERNS` | File patterns to exclude | `*.log,*.tmp,node_modules` | `*.log,*.tmp` |
| `MCP_FOLLOW_SYMLINKS` | Follow symbolic links | `true` or `false` | `false` |

#### Configuration Examples

**Development Setup:**
```bash
# Allow access to development directories
export MCP_ALLOWED_DIRS="/Users/kevinbrown/servers,/Users/kevinbrown/Documents,/workspace/projects"
export MCP_READ_ONLY="false"
export MCP_MAX_FILE_SIZE="10485760"  # 10MB
npm run start:filesystem -- --transport=http --port=8080
```

**Read-Only Documentation Access:**
```bash
# Safe read-only access to documentation
export MCP_ALLOWED_DIRS="/usr/share/doc,/home/user/references"
export MCP_READ_ONLY="true"
export MCP_MAX_FILE_SIZE="5242880"  # 5MB
npm run start:filesystem -- --transport=http --port=8080
```

**Production Security:**
```bash
# Highly restricted production setup
export MCP_ALLOWED_DIRS="/var/app/data"
export MCP_READ_ONLY="true"
export MCP_MAX_FILE_SIZE="1048576"  # 1MB only
export MCP_EXCLUDED_PATTERNS="*.exe,*.sh,*.bat,*.dll"
npm run start:filesystem -- --transport=http --port=8080
```

**LM Studio Configuration with Environment Variables:**
```json
{
  "filesystem": {
    "url": "http://localhost:8080/mcp",
    "env": {
      "MCP_ALLOWED_DIRS": "/Users/kevinbrown/Documents,/Users/kevinbrown/servers",
      "MCP_READ_ONLY": "false",
      "MCP_MAX_FILE_SIZE": "10485760",
      "MCP_EXCLUDED_PATTERNS": "*.log,*.tmp,.git,node_modules"
    }
  }
}
```

#### Security Best Practices

**✅ Safe Directory Examples:**
```bash
# ✅ GOOD: Specific project directories
export MCP_ALLOWED_DIRS="/workspace/my-project,/home/user/documents"

# ✅ GOOD: Read-only system documentation  
export MCP_ALLOWED_DIRS="/usr/share/doc"
export MCP_READ_ONLY="true"

# ✅ GOOD: Temporary scratch space
export MCP_ALLOWED_DIRS="/tmp/mcp-scratch"
```

**❌ Dangerous Configurations:**
```bash
# ❌ NEVER: Root directory access
export MCP_ALLOWED_DIRS="/"

# ❌ DANGEROUS: System directories
export MCP_ALLOWED_DIRS="/etc,/var,/usr/bin"

# ❌ RISKY: Entire home directory
export MCP_ALLOWED_DIRS="/Users/kevinbrown"  # Too broad!
```

#### Directory Setup Script
```bash
#!/bin/bash
# setup-filesystem.sh - Safe filesystem server setup

# Create safe directories
mkdir -p /tmp/mcp-safe
mkdir -p "$HOME/mcp-workspace"

# Set permissions
chmod 755 /tmp/mcp-safe
chmod 755 "$HOME/mcp-workspace"

# Configure and start
export MCP_ALLOWED_DIRS="/tmp/mcp-safe,$HOME/mcp-workspace,$HOME/Documents"
export MCP_READ_ONLY="false"
export MCP_MAX_FILE_SIZE="10485760"
export DEBUG="mcp:filesystem"

echo "Starting filesystem server with directories: $MCP_ALLOWED_DIRS"
npm run start:filesystem -- --transport=http --port=8080
```

### 🌐 Fetch Server Configuration

**Environment Variables:**
- `MCP_USER_AGENT`: Custom user agent string (default: "MCP-LMstudio/1.0")
- `MCP_TIMEOUT`: Request timeout in milliseconds (default: 30000)
- `MCP_MAX_REDIRECTS`: Maximum HTTP redirects (default: 5)
- `MCP_ALLOWED_DOMAINS`: Comma-separated allowed domains (optional)

**Configuration:**
```json
{
  "fetch": {
    "url": "http://localhost:8081/mcp",
    "env": {
      "MCP_USER_AGENT": "MCP-LMstudio/1.0",
      "MCP_TIMEOUT": "30000",
      "MCP_MAX_REDIRECTS": "5",
      "MCP_ALLOWED_DOMAINS": "github.com,stackoverflow.com,docs.python.org"
    }
  }
}
```

**Usage Examples in LM Studio:**
- "Fetch content from https://api.github.com/repos/microsoft/vscode"
- "Get the HTML from https://example.com and extract the title"
- "Download the JSON from this API endpoint"

### 🧠 Memory Server Configuration

**Environment Variables:**
- `MCP_MEMORY_DIR`: Directory for persistent storage (default: `./.mcp-memory`)
- `MCP_MAX_ENTITIES`: Maximum entities to store (default: 1000)
- `MCP_MEMORY_TTL`: Time-to-live for memories in seconds (default: unlimited)

**Configuration:**
```json
{
  "memory": {
    "url": "http://localhost:8082/mcp",
    "env": {
      "MCP_MEMORY_DIR": "/home/user/.mcp-memory",
      "MCP_MAX_ENTITIES": "10000",
      "MCP_MEMORY_TTL": "86400"
    }
  }
}
```

**Usage Examples in LM Studio:**
- "Remember that I prefer TypeScript over JavaScript"
- "Store information about my current project: building an MCP server"
- "What programming languages do I like?"
- "Forget my preference about databases"

### 🔄 Git Server Configuration

**Environment Variables:**
- `MCP_GIT_SAFE_DIRS`: Safe Git repository directories
- `MCP_GIT_MAX_DIFF_SIZE`: Maximum diff size to process (default: 100000)

**Configuration:**
```json
{
  "git": {
    "url": "http://localhost:8083/mcp",
    "env": {
      "MCP_GIT_SAFE_DIRS": "/workspace/repos,/home/user/projects",
      "MCP_GIT_MAX_DIFF_SIZE": "100000"
    }
  }
}
```

### Testing Your Configuration

1. **Start the servers with debug:**
```bash
export DEBUG="mcp:*"
export MCP_ALLOWED_DIRS="/Users/kevinbrown/servers"
npm run start:filesystem -- --transport=http --port=8080
```

2. **Test with MCP Inspector:**
```bash
npm run inspector:filesystem
```

3. **Verify in LM Studio:**
   - Open LM Studio
   - Load a compatible model
   - Try commands like: "List files in my servers directory"
   - Test restrictions: "List files in /etc" (should be denied)

4. **Test HTTP endpoints:**
```bash
# Test if server is running
curl http://localhost:8080/health

# Test MCP endpoint
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "tools/list"}'
```

## 🧪 Testing

### Running Tests
```bash
npm test
```

### Testing Individual Servers
```bash
# Test filesystem server
npm run test:filesystem

# Test fetch server  
npm run test:fetch

# Test memory server
npm run test:memory
```

### Manual Testing
```bash
# Start a server in stdio mode for testing
node build/src/filesystem/index.js

# Use the MCP inspector for debugging
npx @modelcontextprotocol/inspector node build/src/filesystem/index.js
```

### Server Startup Testing
```bash
# Test all servers startup
./scripts/test-and-dev.sh test-servers
```

## 📖 Documentation

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [LM Studio Integration Guide](docs/lmstudio-integration.md)
- [Server Development Guide](docs/development.md)

## 🛠️ Development

### Setting up for Development

1. Fork and clone the repository
2. Install dependencies: `npm install`
3. Start development: `npm run dev`

### Creating a New Server

1. Create a new directory in `src/`
2. Follow the MCP server structure
3. Add tests in the `__tests__` directory
4. Update this README

### Code Quality

This project uses:
- TypeScript for type safety
- ESLint for code linting
- Prettier for code formatting
- Jest for testing

Run quality checks:
```bash
npm run lint
npm run type-check
npm run format
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and add tests
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

### Contribution Guidelines
- Ensure all tests pass
- Follow the existing code style
- Add documentation for new features
- Include tests for new functionality

## 🚨 Troubleshooting

### Common Issues

**Server won't start:**
```bash
# Check Node.js version
node --version  # Should be 18+

# Rebuild the project
npm run build

# Check port availability
lsof -i :8080
```

**LM Studio can't connect:**
```bash
# Verify server is running
curl http://localhost:8080/mcp

# Check firewall settings
# Ensure correct URL in LM Studio config
```

**Permission errors (filesystem server):**
```bash
# Check allowed directories
echo $MCP_ALLOWED_DIRS

# Verify directory exists and is accessible
ls -la /your/target/directory

# Check server logs
export DEBUG="mcp:filesystem"
npm run start:filesystem -- --transport=http --port=8080
```

**Filesystem access denied:**
```
Error: Access denied. Directory '/etc' is not in allowed directories.
Solution: Add directory to MCP_ALLOWED_DIRS or use a safer directory.
```

**File too large error:**
```
Error: File size exceeds maximum allowed size (5MB).
Solution: Increase MCP_MAX_FILE_SIZE or use smaller files.
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [Model Context Protocol](https://github.com/modelcontextprotocol/specification)
- [LM Studio](https://lmstudio.ai/)
- [Official MCP Servers](https://github.com/modelcontextprotocol/servers)

## 📞 Support

- [Issues](https://github.com/kevin-biot/MCP-LMstudio/issues)
- [Discussions](https://github.com/kevin-biot/MCP-LMstudio/discussions)

## 🏗️ Project Status

This project is under active development. Features and APIs may change.

### Roadmap
- [x] LM Studio integration documentation  
- [x] HTTP transport support for easy integration
- [x] Docker containerization
- [x] Comprehensive security configuration
- [ ] Custom servers for local LLM workflows
- [ ] Performance optimizations for local models
- [ ] Web interface for server management
- [ ] Authentication and security enhancements

---

Made with ❤️ for the LM Studio community