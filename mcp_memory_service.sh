#!/bin/bash
export MCP_MEMORY_SQLITE_PATH="$HOME/.local/share/mcp-memory/memory.db"
export MCP_MEMORY_STORAGE_BACKEND="sqlite_vec"
mkdir -p "$(dirname "$MCP_MEMORY_SQLITE_PATH")"

# Debug output to stderr
echo "MCP-SHELL-DEBUG: Starting MCP Memory Service" >&2
echo "MCP-SHELL-DEBUG: Python path: /home/nilante/nilante-dev/ai-environment/servers/venvs/memory-service/bin/python" >&2
echo "MCP-SHELL-DEBUG: Script path: /home/nilante/nilante-dev/ai-environment/servers/memory/mcp-memory-service/production_mcp_wrapper.py" >&2

exec /home/nilante/nilante-dev/ai-environment/servers/venvs/memory-service/bin/python \
  /home/nilante/nilante-dev/ai-environment/servers/memory/mcp-memory-service/production_mcp_wrapper.py "$@"
