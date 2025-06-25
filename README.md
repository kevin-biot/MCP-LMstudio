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

#### 1. Start MCP Server with HTTP Transport
```bash
# Start filesystem server on HTTP
npm run start:filesystem -- --transport=http --port=8080

# Or start multiple servers on different ports
npm run start:fetch -- --transport=http --port=8081
npm run start:memory -- --transport=http --port=8082
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

# Run individual servers
docker run -d -p 8080:3000 --name mcp-filesystem mcp-lmstudio node build/src/filesystem/index.js
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

### Server-Specific Configuration

#### Filesystem Server
```json
{
  "filesystem": {
    "url": "http://localhost:8080/mcp",
    "env": {
      "MCP_ALLOWED_DIRS": "/home/user/documents,/home/user/projects",
      "MCP_READ_ONLY": "false"
    }
  }
}
```

#### Memory Server
```json
{
  "memory": {
    "url": "http://localhost:8082/mcp",
    "env": {
      "MCP_MEMORY_DIR": "/home/user/.mcp-memory",
      "MCP_MAX_ENTITIES": "10000"
    }
  }
}
```

### Testing Your Configuration

1. **Start the servers:**
```bash
npm run start:filesystem -- --transport=http --port=8080
```

2. **Test with MCP Inspector:**
```bash
npm run inspector:filesystem
```

3. **Verify in LM Studio:**
   - Open LM Studio
   - Load a compatible model
   - Try commands like: "List files in my documents folder"

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
- Check Node.js version: `node --version` (should be 18+)
- Rebuild the project: `npm run build`
- Check port availability: `lsof -i :8080`

**LM Studio can't connect:**
- Verify server is running: `curl http://localhost:8080/mcp`
- Check firewall settings
- Ensure correct URL in LM Studio config

**Permission errors (filesystem server):**
- Verify `MCP_ALLOWED_DIRS` configuration
- Check directory permissions
- Run with appropriate user permissions

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
- [ ] Custom servers for local LLM workflows
- [ ] Performance optimizations for local models
- [ ] Web interface for server management
- [ ] Authentication and security enhancements

---

Made with ❤️ for the LM Studio community