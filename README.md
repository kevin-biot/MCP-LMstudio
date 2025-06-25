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
- Node.js 18+ or Python 3.8+
- npm or pnpm for JavaScript servers
- pip for Python servers

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

### Usage with LM Studio

1. Start an MCP server:
```bash
node build/src/filesystem/index.js
```

2. Configure LM Studio to connect to the MCP server (detailed instructions coming soon)

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

## 📖 Documentation

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [LM Studio Integration Guide](docs/lmstudio-integration.md) (coming soon)
- [Server Development Guide](docs/development.md) (coming soon)

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
- [ ] LM Studio integration documentation
- [ ] Custom servers for local LLM workflows
- [ ] Performance optimizations for local models
- [ ] Docker containerization
- [ ] Web interface for server management

---

Made with ❤️ for the LM Studio community