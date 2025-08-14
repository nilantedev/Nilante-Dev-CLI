# MCP Memory Service - Usage Guide

This guide covers all aspects of using the MCP Memory Service, from basic operations to advanced configurations.

## 🚀 Getting Started

### Prerequisites

- Python 3.10+ 
- Git
- Claude Desktop (for local MCP integration)

### Installation

```bash
# Clone the repository
git clone https://github.com/doobidoo/mcp-memory-service.git
cd mcp-memory-service

# Install dependencies and configure the service
python install.py

# Verify installation
python scripts/database/db_health_check.py
```

### Quick Setup for Claude Desktop

1. **Install and configure**:
   ```bash
   python install.py
   ```

2. **Add to Claude Desktop config** (`~/.claude/claude_desktop_config.json`):
   ```json
   {
     "mcpServers": {
       "memory": {
         "command": "python", 
         "args": ["scripts/run_memory_server.py"],
         "cwd": "/path/to/mcp-memory-service",
         "env": {
           "MCP_MEMORY_STORAGE_BACKEND": "sqlite_vec"
         }
       }
     }
   }
   ```

3. **Restart Claude Desktop** and start using memory commands!

## 💾 Storage Backends

### SQLite-vec (Recommended)

**Benefits:**
- 75% less memory usage than ChromaDB
- Faster startup and query times
- Single-file database
- Production-ready

**Configuration:**
```bash
export MCP_MEMORY_STORAGE_BACKEND=sqlite_vec
export MCP_MEMORY_SQLITE_PATH=~/.local/share/mcp-memory/sqlite_vec.db
```

### ChromaDB

**Benefits:**
- Rich metadata support
- Advanced collection management
- Mature ecosystem

**Configuration:**
```bash
export MCP_MEMORY_STORAGE_BACKEND=chroma
export MCP_MEMORY_CHROMA_PATH=~/.local/share/mcp-memory/chroma_db
```

## 🧠 Core Memory Operations

### 1. Store Memory

Store information with automatic semantic indexing:

```json
{
  "method": "tools/call",
  "params": {
    "name": "store_memory",
    "arguments": {
      "content": "We decided to use SQLite-vec as our primary storage backend due to its 75% memory reduction and faster performance.",
      "tags": ["decision", "architecture", "database", "performance"],
      "memory_type": "decision",
      "metadata": {
        "importance": "high",
        "project": "memory-service",
        "date": "2024-01-15"
      }
    }
  }
}
```

**Parameters:**
- `content` (required): The information to store
- `tags` (optional): Array of tags for categorization
- `memory_type` (optional): Type of memory (note, decision, idea, etc.)
- `metadata` (optional): Additional key-value metadata

### 2. Semantic Search

Retrieve memories using natural language queries:

```json
{
  "method": "tools/call",
  "params": {
    "name": "retrieve_memory", 
    "arguments": {
      "query": "database performance decisions",
      "n_results": 5,
      "include_metadata": true
    }
  }
}
```

**Parameters:**
- `query` (required): Natural language search query
- `n_results` (optional): Number of results (default: 10)
- `include_metadata` (optional): Include metadata in results

### 3. Tag-Based Search

Search memories by specific tags:

```json
{
  "method": "tools/call",
  "params": {
    "name": "search_by_tag",
    "arguments": {
      "tags": ["decision", "architecture"],
      "limit": 20
    }
  }
}
```

### 4. Time-Based Recall

Retrieve memories from specific time periods:

```json
{
  "method": "tools/call",
  "params": {
    "name": "recall_memory",
    "arguments": {
      "query": "What decisions did we make last week?",
      "time_range": "last week"
    }
  }
}
```

**Supported time expressions:**
- "yesterday", "last week", "last month"
- "2024-01-15", "January 2024"  
- "past 3 days", "last 2 weeks"

### 5. Memory Management

#### Delete Specific Memory
```json
{
  "method": "tools/call",
  "params": {
    "name": "delete_memory",
    "arguments": {
      "content_hash": "abc123def456"
    }
  }
}
```

#### Bulk Delete by Tags
```json
{
  "method": "tools/call",
  "params": {
    "name": "delete_by_tags",
    "arguments": {
      "tags": ["temporary", "test"]
    }
  }
}
```

## 🌐 HTTP API Usage

For remote deployments, the service provides a full HTTP API:

### Start HTTP Server

```bash
python scripts/run_http_server.py
```

**Endpoints:**
- **Dashboard**: `http://localhost:8000/`
- **API Docs**: `http://localhost:8000/api/docs`
- **MCP Protocol**: `http://localhost:8000/mcp`
- **Health Check**: `http://localhost:8000/health`

### HTTP Examples

#### Store Memory via HTTP
```bash
curl -X POST http://localhost:8000/api/memories \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Important meeting notes",
    "tags": ["meeting", "notes"],
    "memory_type": "note"
  }'
```

#### Search Memories via HTTP
```bash
curl -X GET "http://localhost:8000/api/search?query=meeting%20notes&limit=5"
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MCP_MEMORY_STORAGE_BACKEND` | `sqlite_vec` | Storage backend to use |
| `MCP_MEMORY_SQLITE_PATH` | `~/.local/share/mcp-memory/sqlite_vec.db` | SQLite database path |
| `MCP_MEMORY_CHROMA_PATH` | `~/.local/share/mcp-memory/chroma_db` | ChromaDB storage path |
| `MCP_MEMORY_BACKUPS_PATH` | `~/.local/share/mcp-memory/backups` | Backup directory |
| `LOG_LEVEL` | `INFO` | Logging level |
| `MCP_API_KEY` | None | API key for HTTP authentication |

### Advanced Configuration

#### Enable HTTP Authentication
```bash
export MCP_API_KEY="$(openssl rand -base64 32)"
```

#### Optimize for High Memory Systems
```bash
export MCP_MEMORY_BATCH_SIZE=1000
export MCP_MEMORY_CACHE_SIZE=500MB
```

#### Enable Memory Consolidation
```bash
export MCP_CONSOLIDATION_ENABLED=true
export MCP_CONSOLIDATION_SCHEDULE="0 2 * * *"  # Daily at 2 AM
```

## 🛠️ Maintenance

### Health Checks

```bash
# Comprehensive health check
python scripts/database/db_health_check.py

# Check database statistics
python scripts/analyze_sqlite_vec_db.py ~/.local/share/mcp-memory/sqlite_vec.db

# Verify server connectivity
curl http://localhost:8000/health
```

### Backup and Restore

```bash
# Create backup
python scripts/backup_memories.py

# Restore from backup  
python scripts/restore_memories.py --backup-path /path/to/backup

# Migrate between backends
python scripts/migrate_storage.py --from chroma --to sqlite_vec
```

### Database Optimization

```bash
# Optimize database performance
python -c "
from src.mcp_memory_service.storage.sqlite_vec import SqliteVecMemoryStorage
import asyncio

async def optimize():
    storage = SqliteVecMemoryStorage('~/.local/share/mcp-memory/sqlite_vec.db')
    await storage.initialize()
    await storage.optimize_db()
    print('Database optimized')

asyncio.run(optimize())
"
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Import Errors
```bash
# Ensure virtual environment is activated
source .venv/bin/activate

# Install dependencies
pip install -e .

# Verify imports
python -c "from mcp_memory_service.server import main; print('OK')"
```

#### 2. Database Connection Issues
```bash
# Check permissions
ls -la ~/.local/share/mcp-memory/

# Verify database health
python scripts/database/db_health_check.py

# Reset database (removes all data)
rm ~/.local/share/mcp-memory/sqlite_vec.db
```

#### 3. Memory/Performance Issues
```bash
# Switch to SQLite-vec for better performance
export MCP_MEMORY_STORAGE_BACKEND=sqlite_vec

# Clear model cache
rm -rf ~/.cache/sentence-transformers/

# Check system resources
python -c "import psutil; print(f'Memory: {psutil.virtual_memory().percent}%')"
```

#### 4. Claude Desktop Integration
```bash
# Verify MCP server registration
grep -A 10 "memory" ~/.claude/claude_desktop_config.json

# Check server logs
tail -f ~/.claude/logs/mcp-memory-service.log

# Test MCP connection manually
python scripts/testing/run_memory_test.sh
```

## 📊 Performance Tips

1. **Use SQLite-vec** for production deployments
2. **Enable model caching** for frequently accessed embeddings
3. **Use specific tags** for faster filtering
4. **Regular database optimization** for large datasets
5. **Monitor memory usage** with system tools

## 🤝 Integration Examples

### With Claude Code Commands
```bash
claude /memory-store "Project architecture decision: Using microservices"
claude /memory-recall "architecture decisions from last month"
claude /memory-search --tags "architecture,decision"
```

### With Custom Applications
```python
import asyncio
from mcp_memory_service.storage.sqlite_vec import SqliteVecMemoryStorage
from mcp_memory_service.models.memory import Memory

async def store_and_search():
    storage = SqliteVecMemoryStorage()
    await storage.initialize()
    
    # Store memory
    memory = Memory(
        content="Important business decision",
        tags=["business", "decision"],
        memory_type="decision"
    )
    
    success, message = await storage.store(memory)
    print(f"Stored: {success}, {message}")
    
    # Search memories
    results = await storage.retrieve("business decisions", n_results=5)
    for result in results:
        print(f"Found: {result.content[:50]}...")

asyncio.run(store_and_search())
```

This covers the essential usage patterns for the MCP Memory Service. For more advanced features and API details, see the documentation in the `docs/` directory.