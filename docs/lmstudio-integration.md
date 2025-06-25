# LM Studio Integration Guide

Complete guide for integrating MCP servers with LM Studio for enhanced local AI capabilities.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Setup](#quick-setup)
- [Configuration Methods](#configuration-methods)
- [Server Configurations](#server-configurations)
- [Testing Integration](#testing-integration)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

## Prerequisites

### System Requirements
- **LM Studio**: Version 0.2.0 or higher with MCP support
- **Node.js**: Version 18.0 or higher
- **Operating System**: Windows, macOS, or Linux
- **Memory**: At least 8GB RAM (16GB recommended for larger models)

### Software Installation
1. **Install LM Studio**
   - Download from [lmstudio.ai](https://lmstudio.ai/)
   - Ensure MCP support is enabled in settings

2. **Install Node.js**
   - Download from [nodejs.org](https://nodejs.org/)
   - Verify: `node --version` (should be 18+)

3. **Clone this repository**
   ```bash
   git clone https://github.com/kevin-biot/MCP-LMstudio.git
   cd MCP-LMstudio
   npm install && npm run build
   ```

## Quick Setup

### 1. Start MCP Servers
```bash
# Start filesystem server on port 8080
npm run start:filesystem -- --transport=http --port=8080

# Start additional servers (in separate terminals)
npm run start:fetch -- --transport=http --port=8081
npm run start:memory -- --transport=http --port=8082
```

### 2. Configure LM Studio
Open LM Studio → Settings → Model Context Protocol and add:

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

### 3. Test Integration
In LM Studio chat:
- "List files in my current directory"
- "Fetch content from https://example.com"
- "Remember that I prefer Python for scripting"

## Configuration Methods

### Method 1: HTTP Transport (Recommended)

**Advantages:**
- Easy to configure and debug
- Works across network boundaries
- Better error handling
- Can be load-balanced

**Setup:**
```bash
# Start servers with HTTP transport
npm run start:filesystem -- --transport=http --port=8080
npm run start:fetch -- --transport=http --port=8081
```

**LM Studio Configuration:**
```json
{
  "mcpServers": {
    "filesystem": {
      "url": "http://localhost:8080/mcp",
      "timeout": 30000,
      "retries": 3
    },
    "fetch": {
      "url": "http://localhost:8081/mcp",
      "timeout": 30000,
      "retries": 3
    }
  }
}
```

### Method 2: Stdio Transport

**Advantages:**
- Lower latency
- More secure (no network exposure)
- Direct process communication

**LM Studio Configuration:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "node",
      "args": ["/absolute/path/to/MCP-LMstudio/build/src/filesystem/index.js"],
      "env": {
        "MCP_ALLOWED_DIRS": "/home/user/documents,/home/user/projects"
      }
    },
    "fetch": {
      "command": "node",
      "args": ["/absolute/path/to/MCP-LMstudio/build/src/fetch/index.js"]
    }
  }
}
```

### Method 3: Docker Containers

**Advantages:**
- Isolated environments
- Easy deployment
- Consistent across systems

**Setup:**
```bash
# Build image
docker build -t mcp-lmstudio .

# Run servers
docker run -d -p 8080:3000 --name mcp-filesystem \
  -v /home/user/safe-dirs:/app/allowed-dirs \
  mcp-lmstudio node build/src/filesystem/index.js

docker run -d -p 8081:3000 --name mcp-fetch \
  mcp-lmstudio node build/src/fetch/index.js
```

**LM Studio Configuration:**
```json
{
  "mcpServers": {
    "filesystem-docker": {
      "url": "http://localhost:8080/mcp"
    },
    "fetch-docker": {
      "url": "http://localhost:8081/mcp"
    }
  }
}
```

## Server Configurations

### Filesystem Server

**Environment Variables:**
- `MCP_ALLOWED_DIRS`: Comma-separated safe directories
- `MCP_READ_ONLY`: Set to "true" for read-only access
- `MCP_MAX_FILE_SIZE`: Maximum file size to read (bytes)

**Configuration Examples:**

**Development Setup:**
```json
{
  "filesystem-dev": {
    "url": "http://localhost:8080/mcp",
    "env": {
      "MCP_ALLOWED_DIRS": "/workspace/projects,/home/user/documents",
      "MCP_READ_ONLY": "false",
      "MCP_MAX_FILE_SIZE": "10485760"
    }
  }
}
```

**Production Setup:**
```json
{
  "filesystem-prod": {
    "url": "http://localhost:8080/mcp",
    "env": {
      "MCP_ALLOWED_DIRS": "/var/app/data",
      "MCP_READ_ONLY": "true",
      "MCP_MAX_FILE_SIZE": "1048576"
    }
  }
}
```

### Fetch Server

**Environment Variables:**
- `MCP_USER_AGENT`: Custom user agent string
- `MCP_TIMEOUT`: Request timeout (milliseconds)
- `MCP_MAX_REDIRECTS`: Maximum HTTP redirects
- `MCP_ALLOWED_DOMAINS`: Comma-separated allowed domains

**Configuration:**
```json
{
  "fetch": {
    "url": "http://localhost:8081/mcp",
    "env": {
      "MCP_USER_AGENT": "MCP-LMstudio/1.0",
      "MCP_TIMEOUT": "30000",
      "MCP_MAX_REDIRECTS": "5",
      "MCP_ALLOWED_DOMAINS": "example.com,api.github.com"
    }
  }
}
```

### Memory Server

**Environment Variables:**
- `MCP_MEMORY_DIR`: Directory for persistent storage
- `MCP_MAX_ENTITIES`: Maximum entities to store
- `MCP_MEMORY_TTL`: Time-to-live for memories (seconds)

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

### Git Server

**Environment Variables:**
- `MCP_GIT_SAFE_DIRS`: Safe Git repository directories
- `MCP_GIT_MAX_DIFF_SIZE`: Maximum diff size to process

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

## Testing Integration

### 1. Verify Server Health
```bash
# Check if servers are running
curl http://localhost:8080/health
curl http://localhost:8081/health
curl http://localhost:8082/health

# Test MCP endpoint
curl -X POST http://localhost:8080/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "ping"}'
```

### 2. Use MCP Inspector
```bash
# Test individual servers
npm run inspector:filesystem
npm run inspector:fetch
npm run inspector:memory
```

### 3. Test in LM Studio

**Filesystem Operations:**
- "List files in my documents folder"
- "Read the contents of README.md"
- "Create a new file called test.txt with sample content"

**Web Fetching:**
- "Fetch the content from https://httpbin.org/json"
- "Get the HTML from https://example.com and extract the title"

**Memory Operations:**
- "Remember that I prefer TypeScript over JavaScript"
- "What programming languages do I prefer?"
- "Forget my language preferences"

**Git Operations:**
- "Show me the status of my current Git repository"
- "What files have been modified in the last commit?"

## Troubleshooting

### Common Issues

#### 1. Server Won't Start
**Error:** `Error: listen EADDRINUSE :::8080`

**Solution:**
```bash
# Check what's using the port
lsof -i :8080
# Kill the process or use a different port
npm run start:filesystem -- --transport=http --port=8090
```

#### 2. LM Studio Can't Connect
**Error:** `Connection refused` or `Timeout`

**Solutions:**
1. Verify server is running: `curl http://localhost:8080/mcp`
2. Check firewall settings
3. Ensure correct URL in LM Studio config
4. Try restarting LM Studio

#### 3. Permission Denied (Filesystem)
**Error:** `EACCES: permission denied`

**Solutions:**
1. Check `MCP_ALLOWED_DIRS` includes the target directory
2. Verify directory permissions: `ls -la /target/directory`
3. Run server with appropriate user permissions

#### 4. Memory Issues
**Error:** `JavaScript heap out of memory`

**Solutions:**
1. Increase Node.js memory: `node --max-old-space-size=4096`
2. Reduce `MCP_MAX_ENTITIES` for memory server
3. Monitor system resources

### Debug Mode

Enable debug logging:
```bash
# Set debug environment
export DEBUG=mcp:*

# Start server with debug output
npm run start:filesystem -- --transport=http --port=8080
```

### Log Analysis

Check server logs:
```bash
# View real-time logs
tail -f ~/.local/share/LMStudio/logs/mcp.log

# Search for errors
grep -i error ~/.local/share/LMStudio/logs/mcp.log
```

## Advanced Usage

### Load Balancing Multiple Servers

Run multiple instances of the same server:
```bash
# Start multiple filesystem servers
npm run start:filesystem -- --transport=http --port=8080
npm run start:filesystem -- --transport=http --port=8085
```

Configure LM Studio with multiple endpoints:
```json
{
  "mcpServers": {
    "filesystem-1": {
      "url": "http://localhost:8080/mcp"
    },
    "filesystem-2": {
      "url": "http://localhost:8085/mcp"
    }
  }
}
```

### Custom Server Wrappers

Create wrapper scripts for complex configurations:

**filesystem-wrapper.sh:**
```bash
#!/bin/bash
export MCP_ALLOWED_DIRS="/workspace,/home/user/docs"
export MCP_READ_ONLY="false"
export DEBUG="mcp:filesystem"

node /path/to/MCP-LMstudio/build/src/filesystem/index.js --transport=http --port=8080
```

### Security Considerations

1. **Network Security:**
   - Bind servers to localhost only in production
   - Use HTTPS for remote connections
   - Implement authentication if needed

2. **File System Security:**
   - Carefully configure `MCP_ALLOWED_DIRS`
   - Use read-only mode when possible
   - Regular audit of accessible directories

3. **Memory Security:**
   - Set appropriate `MCP_MAX_ENTITIES` limits
   - Regular cleanup of stored memories
   - Monitor memory usage

### Performance Optimization

1. **Server Performance:**
   - Use HTTP/2 when available
   - Enable response compression
   - Implement caching for frequently accessed data

2. **LM Studio Performance:**
   - Reduce timeout values for faster responses
   - Use connection pooling
   - Monitor resource usage

## Integration Examples

### Development Workflow
Perfect for coding assistants:
```json
{
  "mcpServers": {
    "dev-filesystem": {
      "url": "http://localhost:8080/mcp",
      "env": {
        "MCP_ALLOWED_DIRS": "/workspace/projects"
      }
    },
    "dev-git": {
      "url": "http://localhost:8083/mcp",
      "env": {
        "MCP_GIT_SAFE_DIRS": "/workspace/projects"
      }
    },
    "dev-memory": {
      "url": "http://localhost:8082/mcp",
      "env": {
        "MCP_MEMORY_DIR": "/workspace/.mcp-memory"
      }
    }
  }
}
```

### Research Workflow
Ideal for research and content creation:
```json
{
  "mcpServers": {
    "research-fetch": {
      "url": "http://localhost:8081/mcp"
    },
    "research-memory": {
      "url": "http://localhost:8082/mcp",
      "env": {
        "MCP_MEMORY_DIR": "/research/.mcp-memory",
        "MCP_MAX_ENTITIES": "50000"
      }
    }
  }
}
```

## Support and Resources

- **Documentation**: [Model Context Protocol Docs](https://modelcontextprotocol.io/)
- **Issues**: [GitHub Issues](https://github.com/kevin-biot/MCP-LMstudio/issues)
- **Discussions**: [GitHub Discussions](https://github.com/kevin-biot/MCP-LMstudio/discussions)
- **LM Studio Support**: [LM Studio Documentation](https://lmstudio.ai/docs)

---

For development and contributing, see the [Development Guide](development.md).