#!/usr/bin/env python3
"""
Main entry point for MCP Memory Service

Usage:
  python start.py                  # Start MCP server for Claude Desktop
  python start.py --http           # Start HTTP server with web dashboard
  python start.py --help           # Show help
"""

import sys
import os
import subprocess
from pathlib import Path

def main():
    """Main entry point for the MCP Memory Service."""
    
    # Get the directory containing this script
    script_dir = Path(__file__).parent
    
    if len(sys.argv) > 1:
        if sys.argv[1] == "--http":
            print("🌐 Starting HTTP server with web dashboard...")
            print("Dashboard will be available at: http://localhost:8000")
            script_path = script_dir / "scripts" / "run_http_server.py"
        elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
            print(__doc__)
            print("\nAvailable commands:")
            print("  python start.py          # MCP server for Claude Desktop")
            print("  python start.py --http   # HTTP server with dashboard") 
            print("  python start.py --help   # Show this help")
            print("\nFor more information, see:")
            print("  README.md      # Overview and quick start")
            print("  QUICKSTART.md  # 5-minute setup guide")
            print("  USAGE.md       # Complete usage documentation")
            return
        else:
            print(f"Unknown option: {sys.argv[1]}")
            print("Use --help for available options")
            return
    else:
        print("🧠 Starting MCP Memory Service for Claude Desktop...")
        print("Server will be available for Claude Desktop integration")
        script_path = script_dir / "scripts" / "run_memory_server.py"
    
    # Run the appropriate script
    try:
        subprocess.run([sys.executable, str(script_path)] + sys.argv[2:], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error starting service: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nService stopped by user")
        sys.exit(0)

if __name__ == "__main__":
    main()