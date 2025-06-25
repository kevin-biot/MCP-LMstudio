#!/bin/bash
# Comprehensive testing and development script
set -e

SERVERS=("filesystem" "fetch" "memory" "everything" "git" "time" "sequentialthinking")

log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

test_server_startup() {
    local server=$1
    log_info "Testing $server server startup..."
    
    timeout 10s npm run "start:$server" > /dev/null 2>&1 &
    local pid=$!
    sleep 3
    
    if kill -0 $pid 2>/dev/null; then
        log_success "$server server started successfully"
        kill $pid 2>/dev/null || true
        return 0
    else
        echo "❌ $server server failed to start"
        return 1
    fi
}

case ${1:-help} in
    "test-servers")
        log_info "Testing all server startups..."
        for server in "${SERVERS[@]}"; do
            test_server_startup "$server"
        done
        ;;
    "help"|*)
        echo "Usage: $0 [test-servers|help]"
        ;;
esac