# Development Guide

## Setup Development Environment

1. Clone the repository
2. Install dependencies: `npm install`
3. Build the project: `npm run build`
4. Run tests: `npm test`

## Server Development

Each server should follow the MCP specification and include:
- Proper error handling
- Comprehensive tests
- Documentation
- Type definitions

## Testing

Run the test suite:
```bash
npm test
npm run test:coverage
```

Test individual servers:
```bash
npm run test:filesystem
npm run inspector:filesystem
```

## Project Structure

```
src/
├── filesystem/     # File system operations server
├── fetch/          # Web content fetching server
├── memory/         # Persistent memory server
├── git/            # Git operations server
├── time/           # Time utilities server
├── everything/     # Reference implementation
└── sequentialthinking/  # Sequential thinking server
```

## Adding a New Server

1. Create directory in `src/`
2. Implement MCP server interface
3. Add package.json with proper configuration
4. Write comprehensive tests
5. Update main README and documentation