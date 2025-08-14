# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

MCP Memory Service is a clean, production-ready Model Context Protocol server providing semantic memory and persistent storage for Claude Desktop. Features multiple storage backends (SQLite-vec recommended, ChromaDB supported), HTTP API, and autonomous memory consolidation.

## Key Commands

### Development
- **Install dependencies**: `python install.py` (platform-aware installation)
- **Run MCP server**: `python scripts/run_memory_server.py`
- **Run HTTP server**: `python scripts/run_http_server.py`
- **Health check**: `python scripts/database/db_health_check.py`
- **Check environment**: `python scripts/verify_environment.py`
- **Quick start**: See `QUICKSTART.md` for 5-minute setup

### Build & Package
- **Build package**: `python -m build`
- **Install locally**: `pip install -e .`

## Architecture

### Core Components

1. **Server Layer** (`src/mcp_memory_service/server.py`)
   - Implements MCP protocol with async request handlers
   - Global model and embedding caches for performance
   - Handles all memory operations (store, retrieve, search, delete)

2. **Storage Abstraction** (`src/mcp_memory_service/storage/`)
   - `base.py`: Abstract interface for storage backends
   - `sqlite_vec.py`: SQLite-vec implementation (recommended)
   - `chroma.py`: ChromaDB implementation
   - `chroma_enhanced.py`: Extended ChromaDB features

3. **Models** (`src/mcp_memory_service/models/memory.py`)
   - `Memory`: Core dataclass for memory entries
   - `MemoryMetadata`: Metadata structure
   - All models use Python dataclasses with type hints

4. **Configuration** (`src/mcp_memory_service/config.py`)
   - Environment-based configuration
   - Platform-specific optimizations
   - Hardware acceleration detection

### Key Design Patterns

- **Async/Await**: All I/O operations are async
- **Type Safety**: Comprehensive type hints (Python 3.10+)
- **Error Handling**: Specific exception types with clear messages
- **Caching**: Global caches for models and embeddings to improve performance
- **Platform Detection**: Automatic hardware optimization (CUDA, MPS, DirectML, ROCm)

### MCP Protocol Operations

Memory operations implemented:
- `store_memory`: Store new memories with tags and metadata
- `retrieve_memory`: Basic retrieval by query
- `recall_memory`: Natural language time-based retrieval
- `search_by_tag`: Tag-based search
- `delete_memory`: Delete specific memories
- `delete_by_tag/tags`: Bulk deletion by tags
- `optimize_db`: Database optimization
- `check_database_health`: Health monitoring
- `debug_retrieve`: Similarity analysis for debugging

### Testing

The codebase has been cleaned up - test files that were incomplete have been removed. Core functionality is verified through:
- Health checks: `python scripts/database/db_health_check.py`
- Integration testing: Test the full MCP protocol workflow
- Manual testing: Use the provided test scripts

Run health check: `python scripts/database/db_health_check.py`

### Environment Variables

Key configuration:
- `MCP_MEMORY_STORAGE_BACKEND`: `sqlite_vec` (recommended) or `chroma`
- `MCP_MEMORY_SQLITE_PATH`: SQLite database location (default: `~/.local/share/mcp-memory/sqlite_vec.db`)
- `MCP_MEMORY_CHROMA_PATH`: ChromaDB storage location (default: `~/.local/share/mcp-memory/chroma_db`)
- `MCP_MEMORY_BACKUPS_PATH`: Backup location (default: `~/.local/share/mcp-memory/backups`)
- `MCP_API_KEY`: API key for HTTP authentication (optional, no default)
- `LOG_LEVEL`: Logging verbosity (DEBUG, INFO, WARNING, ERROR)

#### API Key Configuration

The `MCP_API_KEY` environment variable enables HTTP API authentication:

```bash
# Generate a secure API key
export MCP_API_KEY="$(openssl rand -base64 32)"

# Or set manually
export MCP_API_KEY="your-secure-api-key-here"
```

When set, all HTTP API requests require the `Authorization: Bearer <api_key>` header. This is essential for production deployments and multi-client setups.

### Platform Support

The codebase includes platform-specific optimizations:
- **macOS**: MPS acceleration for Apple Silicon, CPU fallback for Intel
- **Windows**: CUDA, DirectML, or CPU
- **Linux**: CUDA, ROCm, or CPU

Hardware detection is automatic via `utils/system_detection.py`.

### Development Tips

1. When modifying storage backends, ensure compatibility with the abstract base class
2. Memory operations should handle duplicates gracefully (content hashing)
3. Time parsing supports natural language ("yesterday", "last week")
4. Use the debug_retrieve operation to analyze similarity scores
5. The server maintains global state for models - be careful with concurrent modifications
6. All new features should include corresponding tests
7. Use semantic commit messages for version management

### Common Issues

1. **MPS Fallback**: On macOS, if MPS fails, set `PYTORCH_ENABLE_MPS_FALLBACK=1`
2. **ONNX Runtime**: For compatibility issues, use `MCP_MEMORY_USE_ONNX=true`
3. **ChromaDB Persistence**: Ensure write permissions for storage paths
4. **Memory Usage**: Model loading is deferred until first use to reduce startup time