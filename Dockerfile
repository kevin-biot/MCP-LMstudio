# Multi-stage build for MCP-LMstudio servers
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine AS production
RUN apk add --no-cache dumb-init
RUN addgroup -g 1001 -S mcp && adduser -S mcp -u 1001

WORKDIR /app
COPY --from=builder --chown=mcp:mcp /app/build ./build
COPY --from=builder --chown=mcp:mcp /app/node_modules ./node_modules
COPY --from=builder --chown=mcp:mcp /app/package*.json ./

USER mcp
EXPOSE 3000

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "build/src/filesystem/index.js"]