#!/usr/bin/env python3
import sys
import os
import runpy

# Set up environment
os.environ.setdefault('MCP_MEMORY_SQLITE_PATH', os.path.expanduser('~/.local/share/mcp-memory/memory.db'))
os.environ.setdefault('MCP_MEMORY_STORAGE_BACKEND', 'sqlite_vec')

# Ensure data directory exists
data_dir = os.path.dirname(os.environ['MCP_MEMORY_SQLITE_PATH'])
os.makedirs(data_dir, exist_ok=True)

# Set up the path correctly
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(script_dir, 'src'))

if __name__ == "__main__":
    # Run server.py as main module
    runpy.run_path(os.path.join(script_dir, 'server.py'), run_name='__main__')
