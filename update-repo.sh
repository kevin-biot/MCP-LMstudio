#!/bin/bash

# update-repo.sh - Update GitHub repository with latest changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in a git repository
check_git() {
    if [ ! -d ".git" ]; then
        log_error "Not a Git repository. Please run from the MCP-LMstudio directory."
        exit 1
    fi
    
    log_success "Git repository detected"
}

# Check for uncommitted changes
check_status() {
    log_info "Checking repository status..."
    
    if ! git diff-index --quiet HEAD --; then
        log_info "Found uncommitted changes"
        git status --short
    else
        log_info "Working directory is clean"
    fi
}

# Update repository
update_repo() {
    log_info "Adding all changes to Git..."
    git add .
    
    echo ""
    echo "=== Current changes to be committed ==="
    git status --short
    echo "======================================"
    echo ""
    
    # Ask for commit message
    echo "Enter commit message (or press Enter for default):"
    read -r commit_msg
    
    if [ -z "$commit_msg" ]; then
        commit_msg="Update MCP-LMstudio: Enhanced LM Studio integration

- Added comprehensive LM Studio configuration section to README
- Created detailed LM Studio integration guide (docs/lmstudio-integration.md)
- Added HTTP, stdio, and Docker configuration examples
- Included server-specific environment variable configurations
- Added troubleshooting and testing instructions
- Enhanced documentation with sample configs and best practices"
    fi
    
    log_info "Committing changes..."
    git commit -m "$commit_msg"
    
    log_info "Pushing to GitHub..."
    git push origin main
    
    log_success "Repository updated successfully!"
}

# Main execution
main() {
    log_info "Updating MCP-LMstudio repository..."
    
    check_git
    check_status
    update_repo
    
    echo ""
    log_success "✅ Repository update completed!"
    echo ""
    echo "🎯 What's new:"
    echo "  • Enhanced LM Studio configuration in README"
    echo "  • Comprehensive integration guide with examples"
    echo "  • Multiple deployment methods (HTTP, stdio, Docker)"
    echo "  • Troubleshooting and testing documentation"
    echo ""
    echo "🔗 View on GitHub: https://github.com/kevin-biot/MCP-LMstudio"
}

# Run main function
main "$@"