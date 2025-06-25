#!/bin/bash

# setup-repo.sh - Initialize and populate GitHub repository for MCP-LMstudio

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/kevin-biot/MCP-LMstudio.git"
LOCAL_DIR="/Users/kevinbrown/servers"

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
check_directory() {
    if [ ! -f "package.json" ]; then
        log_error "Not in the MCP servers directory. Please run from $LOCAL_DIR"
        exit 1
    fi
    
    if [ ! -d ".git" ]; then
        log_error "Not a Git repository. Please initialize Git first."
        exit 1
    fi
    
    log_success "Directory check passed"
}

# Create essential files for the repository
create_essential_files() {
    log_info "Creating essential repository files..."
    
    # Create directories if they don't exist
    mkdir -p .github/workflows
    mkdir -p docs
    mkdir -p scripts
    mkdir -p tests
    
    # Update .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Build outputs
build/
dist/
lib/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Testing
coverage/
.nyc_output/
junit.xml

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Logs
logs
*.log

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# Docker
.dockerignore

# Local development
.local/
temp/
tmp/

# MCP specific
.mcp-memory/
mcp-data/
EOF

    log_success "Essential files created"
}

# Setup Git configuration
setup_git() {
    log_info "Setting up Git configuration..."
    
    # Check if origin remote exists
    if ! git remote get-url origin &> /dev/null; then
        log_info "Adding GitHub remote..."
        git remote add origin "$REPO_URL"
    else
        log_info "Updating GitHub remote..."
        git remote set-url origin "$REPO_URL"
    fi
    
    # Set up default branch
    git branch -M main
    
    log_success "Git configuration complete"
}

# Initial commit and push
initial_commit() {
    log_info "Creating initial commit..."
    
    git add .
    git commit -m "Initial commit: MCP-LMstudio repository setup

- Added comprehensive package.json with all development scripts
- Set up TypeScript, ESLint, and Prettier configurations
- Created GitHub Actions CI/CD pipeline
- Added Docker support for containerized deployment
- Created comprehensive documentation and guides
- Set up testing infrastructure
- Added development and utility scripts"
    
    log_info "Pushing to GitHub..."
    git push -u origin main
    
    log_success "Repository successfully pushed to GitHub!"
}

# Main execution
main() {
    log_info "Starting MCP-LMstudio repository setup..."
    
    check_directory
    create_essential_files
    setup_git
    initial_commit
    
    log_success "Repository setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Install development dependencies: npm install"
    echo "2. Build the project: npm run build"
    echo "3. Test the servers: npm test"
    echo "4. Check the repository on GitHub: $REPO_URL"
    echo ""
    echo "The repository has been populated and pushed to GitHub!"
}

# Run main function
main "$@"