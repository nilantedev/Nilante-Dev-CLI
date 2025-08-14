# MCP Memory Service

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![smithery badge](https://smithery.ai/badge/@doobidoo/mcp-memory-service)](https://smithery.ai/server/@doobidoo/mcp-memory-service)

An intelligent semantic memory service for Claude Desktop using the Model Context Protocol (MCP). Provides persistent storage, semantic search, and autonomous memory consolidation with support for multiple storage backends.

## ✨ Key Features

- 🧠 **Semantic Memory**: Store and retrieve memories using natural language
- 🔍 **Smart Search**: Vector-based similarity search with tag filtering  
- 📊 **Multiple Storage Backends**: SQLite-vec (recommended) and ChromaDB
- 🌐 **HTTP API**: Remote deployment with web dashboard
- 🔄 **Memory Consolidation**: Automatic organization and compression
- 🏷️ **Advanced Tagging**: Hierarchical tag system with search
- ⚡ **High Performance**: Optimized for large-scale deployments

## 🚀 Quick Start

### Installation

```bash
git clone https://github.com/doobidoo/mcp-memory-service.git
cd mcp-memory-service
python install.py
```

### Start the Service

**Simple Launch (Recommended)**:
```bash
# Using shell script (automatically handles virtual environment)
./start.sh               # MCP server for Claude Desktop
./start.sh --http        # HTTP server with dashboard
./start.sh --help        # Show help

# Using Python script (requires manual virtual environment)
source .venv/bin/activate
python start.py          # MCP server for Claude Desktop  
python start.py --http   # HTTP server with dashboard
```

**Direct Launch**:
```bash
# Local MCP server (for Claude Desktop)
python scripts/run_memory_server.py

# HTTP server (for remote access)
python scripts/run_http_server.py
```

### Claude Desktop Configuration

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "memory": {
      "command": "./start.sh",
      "args": [],
      "cwd": "/path/to/mcp-memory-service"
    }
  }
}
```

## 📖 Documentation

- **[Installation Guide](docs/installation/master-guide.md)** - Complete setup instructions
- **[API Documentation](docs/api/)** - Memory operations and endpoints
- **[Storage Backends](docs/guides/STORAGE_BACKENDS.md)** - SQLite-vec vs ChromaDB
- **[Deployment Guide](docs/deployment/)** - Production deployment options
- **[Claude Code Integration](docs/guides/claude-code-integration.md)** - Direct command usage

## 🛠️ Core Operations

### Store Memory
```python
# Via MCP
{
  "method": "tools/call",
  "params": {
    "name": "store_memory",
    "arguments": {
      "content": "Important project decision about using SQLite-vec",
      "tags": ["project", "decision", "database"],
      "memory_type": "decision"
    }
  }
}
```

### Search Memories
```python
# Semantic search
{
  "method": "tools/call", 
  "params": {
    "name": "retrieve_memory",
    "arguments": {
      "query": "database decisions",
      "n_results": 5
    }
  }
}

# Tag-based search
{
  "method": "tools/call",
  "params": {
    "name": "search_by_tag",
    "arguments": {
      "tags": ["project", "decision"]
    }
  }
}
```

## 🏗️ Architecture

```
mcp-memory-service/
├── src/mcp_memory_service/      # Core application
│   ├── server.py               # Main MCP server
│   ├── storage/                # Storage backends
│   ├── models/                 # Data models
│   └── utils/                  # Utilities
├── scripts/                    # Management scripts
├── tools/docker/               # Docker deployment
├── docs/                       # Documentation
└── examples/                   # Usage examples
```

## 🔧 Configuration

Key environment variables:

- `MCP_MEMORY_STORAGE_BACKEND`: `sqlite_vec` (recommended) or `chroma`
- `MCP_MEMORY_SQLITE_PATH`: SQLite database location
- `MCP_MEMORY_CHROMA_PATH`: ChromaDB storage location
- `LOG_LEVEL`: Logging verbosity (DEBUG, INFO, WARNING, ERROR)

## 🧪 Health Check

```bash
# Run comprehensive health check
python scripts/database/db_health_check.py

# Check service status
curl http://localhost:8000/health
```

## 📊 Storage Backends

| Backend | Best For | Memory Usage | Performance |
|---------|----------|--------------|-------------|
| **SQLite-vec** | Production, efficiency | -75% vs ChromaDB | Faster startup |
| **ChromaDB** | Development, features | Higher | Feature-rich |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## 🔗 Links

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/doobidoo/mcp-memory-service/issues)
- **MCP Protocol**: [Model Context Protocol](https://modelcontextprotocol.io/)

## 📈 Version

Current version: **4.1.0**

See [CHANGELOG.md](CHANGELOG.md) for release history.