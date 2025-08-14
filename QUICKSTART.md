# Quick Start Guide - MCP Memory Service

Get up and running with the MCP Memory Service in under 5 minutes.

## 🚀 One-Command Setup

```bash
git clone https://github.com/doobidoo/mcp-memory-service.git
cd mcp-memory-service
python install.py && echo "✅ Installation complete!"
```

## ⚡ Instant Testing

```bash
# Test the installation
python scripts/database/db_health_check.py

# Start the service 
python start.py &

# Start HTTP server with dashboard
python start.py --http
```

## 🎯 Claude Desktop Integration (30 seconds)

1. **Add to your Claude config**:
   ```bash
   # Edit ~/.claude/claude_desktop_config.json
   {
     "mcpServers": {
       "memory": {
         "command": "python",
         "args": ["start.py"], 
         "cwd": "/path/to/mcp-memory-service"
       }
     }
   }
   ```

2. **Restart Claude Desktop**

3. **Start using memory**:
   - "Please store this: We're using SQLite-vec for better performance"
   - "What did we decide about the database?"

## 🧪 Quick Test Commands

```bash
# Store a test memory
curl -X POST http://localhost:8000/api/memories \
  -H "Content-Type: application/json" \
  -d '{"content": "Test memory", "tags": ["test"]}'

# Search for it
curl "http://localhost:8000/api/search?query=test&limit=1"

# View dashboard
open http://localhost:8000
```

## 🛠️ Common First Steps

### Choose Your Storage Backend

**SQLite-vec (Recommended)**:
```bash
export MCP_MEMORY_STORAGE_BACKEND=sqlite_vec
# 75% less memory, faster performance
```

**ChromaDB (Feature-rich)**:
```bash
export MCP_MEMORY_STORAGE_BACKEND=chroma  
# More features, higher resource usage
```

### Verify Everything Works

```bash
# Health check (should show all ✅)
python scripts/database/db_health_check.py

# Expected output:
# ✅ Environment Configuration: PASS
# ✅ Dependencies Check: PASS  
# ✅ Database Creation: PASS
# ✅ Memory Operations: PASS
# 🎉 Database Health Check: PASSED
```

## 🎉 You're Ready!

- **Local MCP Server**: Claude Desktop integration active
- **HTTP API**: Available at `http://localhost:8000`
- **Dashboard**: Web interface for memory management
- **Storage**: Optimized SQLite-vec backend

## 📚 Next Steps

- **[Full Usage Guide](USAGE.md)** - Complete feature documentation
- **[API Reference](docs/api/)** - Detailed API documentation
- **[Advanced Configuration](docs/guides/)** - Performance tuning
- **[Deployment Guide](docs/deployment/)** - Production setup

## 🆘 Need Help?

**Something not working?**

1. **Check the health status**: `python scripts/database/db_health_check.py`
2. **View logs**: `tail -f ~/.claude/logs/mcp-memory-service.log`
3. **Common issues**: See [USAGE.md#troubleshooting](USAGE.md#troubleshooting)
4. **GitHub Issues**: [Report problems](https://github.com/doobidoo/mcp-memory-service/issues)

**Installation issues?**
```bash
# Fresh start
rm -rf .venv
python install.py --force-reinstall
```

**Permission issues?**
```bash
# Fix database permissions
mkdir -p ~/.local/share/mcp-memory
chmod 755 ~/.local/share/mcp-memory
```

---

**That's it!** Your MCP Memory Service is ready to enhance your Claude Desktop experience with persistent, searchable memory. 🧠✨