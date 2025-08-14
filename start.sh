#!/bin/bash
# MCP Memory Service Starter Script
# This script handles virtual environment activation automatically

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${BLUE}$1${NC}"
}

echo_success() {
    echo -e "${GREEN}$1${NC}"
}

echo_warning() {
    echo -e "${YELLOW}$1${NC}"
}

echo_error() {
    echo -e "${RED}$1${NC}"
}

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo_error "❌ Virtual environment not found!"
    echo "Please install dependencies first:"
    echo "  python install.py"
    exit 1
fi

# Activate virtual environment
source .venv/bin/activate

# Set up environment variables
export PYTHONPATH="$SCRIPT_DIR/src:$PYTHONPATH"
export MCP_MEMORY_STORAGE_BACKEND="${MCP_MEMORY_STORAGE_BACKEND:-sqlite_vec}"

# Parse arguments
case "${1:-}" in
    "--http")
        echo_info "🌐 Starting HTTP server with web dashboard..."
        echo "Dashboard will be available at: http://localhost:8000"
        exec python scripts/run_http_server.py "${@:2}"
        ;;
    "--help"|"-h")
        echo "MCP Memory Service - Main entry point"
        echo ""
        echo "Usage:"
        echo "  ./start.sh               # Start MCP server for Claude Desktop"
        echo "  ./start.sh --http        # Start HTTP server with dashboard"
        echo "  ./start.sh --help        # Show this help"
        echo ""
        echo "Setup:"
        echo "  python install.py        # Install dependencies first"
        echo ""
        echo "For more information, see:"
        echo "  README.md      # Overview and quick start"
        echo "  QUICKSTART.md  # 5-minute setup guide"
        echo "  USAGE.md       # Complete usage documentation"
        ;;
    "")
        echo_info "🧠 Starting MCP Memory Service for Claude Desktop..."
        echo "Server will be available for Claude Desktop integration"
        exec python scripts/run_memory_server.py "$@"
        ;;
    *)
        echo_error "Unknown option: $1"
        echo "Use --help for available options"
        exit 1
        ;;
esac