# MCP Filesystem Server Configuration Examples

This directory contains configuration examples for various MCP clients.

## LM Studio
- **File**: `lm-studio.json`
- **Usage**: Copy content to LM Studio's MCP configuration
- **Transport**: HTTP

## Claude Desktop  
- **File**: `claude-desktop.json`
- **Usage**: Add to `~/.config/claude/claude_desktop_config.json`
- **Transport**: Stdio

## VS Code
- **File**: `vscode-mcp.json` 
- **Usage**: Add to VS Code settings or `.vscode/mcp.json`
- **Transport**: Stdio

## Environment Variables

You can also configure the server using environment variables:

```bash
# HTTP mode configuration
export MCP_HTTP_PORT=8080
export MCP_ALLOWED_DIRS="~/Documents:~/Projects:~/Code"

# Start server
./scripts/start-http.sh
```

## Security Notes

- Always use absolute paths for allowed directories
- Avoid using `/` or overly broad directory access
- Test path validation with your specific directory structure
- Consider using read-only mounts for sensitive directories
