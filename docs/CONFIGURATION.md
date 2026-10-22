# Configuration

Everything is configured through environment variables. All are optional: the defaults work for a standard local setup. Set them via your shell, `docker compose`, or the `env` block of your MCP client config.

## Environment variables

| Variable | Default | Purpose |
|---|---|---|
| `LIBRECRAWL_URL` | `http://127.0.0.1:5080` | Full base URL of the LibreCrawl backend. Set this to reach a backend on another host or container (Docker Compose sets `http://librecrawl:5000`). Takes precedence over `LIBRECRAWL_PORT`. |
| `LIBRECRAWL_PORT` | `5080` | Backend port. Used only to build the default URL when `LIBRECRAWL_URL` is not set. |
| `MCP_HOST` | `127.0.0.1` | Bind address for the HTTP transport. Keep loopback on a shared host; set `0.0.0.0` inside a container (Compose does this). |
| `MCP_PORT` | `5081` | Port the MCP server listens on (HTTP transport). |
| `MCP_TRANSPORT` | `http` | `http` for streamable HTTP (long-lived service), or `stdio` for client-launched processes. |
| `REPORTS_DIR` | `~/librecrawl-reports` | Directory where audit zips are written. Docker mounts this to `./reports`. |
| `LIBRECRAWL_UPSTREAM_DB` | `~/.librecrawl/upstream/users.db` | Path to LibreCrawl's SQLite file, used for orphan-page and cleanup checks. If the file isn't reachable, those specific checks skip gracefully: the core audit is unaffected. |
| `PAGESPEED_API_KEY` | unset | Google PageSpeed Insights API key. Enables the `librecrawl_pagespeed*` tools and raises PSI rate limits (25k/day). |

## Transports

### HTTP (default)

The server runs a streamable-HTTP endpoint at `http://<MCP_HOST>:<MCP_PORT>/mcp`. Use this when the MCP is a persistent service (Docker, PM2, systemd, a VPS). Clients that speak stdio only (Claude Desktop/Code) connect through `mcp-remote`:

```json
{
  "mcpServers": {
    "librecrawl": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://127.0.0.1:5081/mcp"]
    }
  }
}
```

To expose the endpoint beyond localhost, set `MCP_HOST=0.0.0.0` **and** put it behind a reverse proxy with authentication: the server itself does not add auth.

### stdio

Set `MCP_TRANSPORT=stdio` and let the client launch `server.py` directly. The backend URL still comes from `LIBRECRAWL_URL`:

```json
{
  "mcpServers": {
    "librecrawl": {
      "command": "python",
      "args": ["/absolute/path/to/server.py"],
      "env": { "MCP_TRANSPORT": "stdio", "LIBRECRAWL_URL": "http://127.0.0.1:5080" }
    }
  }
}
```

## Docker Compose

`docker-compose.yml` sets container-appropriate values automatically:

```yaml
environment:
  - MCP_TRANSPORT=http
  - MCP_HOST=0.0.0.0
  - MCP_PORT=5081
  - LIBRECRAWL_URL=http://librecrawl:5000
  - REPORTS_DIR=/reports
  - LIBRECRAWL_UPSTREAM_DB=/librecrawl-data/users.db
  - PAGESPEED_API_KEY=${PAGESPEED_API_KEY:-}
```

Pass a PageSpeed key by putting `PAGESPEED_API_KEY=...` in a `.env` file next to `docker-compose.yml` (copy `.env.example`). The MCP port is published on loopback only (`127.0.0.1:5081`); change the port mapping in `docker-compose.yml` to expose it elsewhere.
