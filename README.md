<!-- mcp-name: io.github.adityaarsharma/librecrawl-technical-seo-audit-mcp -->

<div align="center">

<img src="docs/assets/sitewalk-logo.png" alt="Sitewalk logo" width="96" height="96">

# Sitewalk: technical SEO audit MCP server

**Ask your AI assistant to audit a website. Get the technical SEO problems back, ranked by impact, with a plain fix for each.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-orange?style=for-the-badge)](https://modelcontextprotocol.io)
[![Latest Release](https://img.shields.io/github/v/release/adityaarsharma/sitewalk?style=for-the-badge&color=brightgreen)](https://github.com/adityaarsharma/sitewalk/releases)
[![Powered by LibreCrawl](https://img.shields.io/badge/Powered%20by-LibreCrawl-7C3AED?style=for-the-badge)](https://github.com/PhialsBasement/LibreCrawl)

</div>

---

This repository is the Sitewalk MCP server and nothing else: a Python server that drives the open-source [LibreCrawl](https://github.com/PhialsBasement/LibreCrawl) crawler, runs 30+ technical SEO checks, and hands your AI assistant a ranked report plus a zip of PDF and CSVs. It runs on your own machine, with no account, no sign-in and no page cap. Nothing leaves your machine except the requests the crawler makes to the site you audit.

Prefer not to host anything? The same audit is available as an app inside [ChatGPT](https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a).

## Set it up on your machine

You need [Docker](https://docs.docker.com/get-docker/) running. Then:

```bash
git clone https://github.com/adityaarsharma/sitewalk.git
cd sitewalk
./setup.sh
```

The script checks your machine, asks one optional question (a Google PageSpeed key), builds and starts the stack, waits until the MCP server answers, and prints exactly how to connect your assistant. The first build takes a few minutes.

| Command | What it does |
|---|---|
| `./setup.sh` | Guided setup |
| `./setup.sh --yes` | Same, no questions |
| `./setup.sh --check` | Only check that your machine can run it |
| `./setup.sh --update` | Pull the newest release and rebuild |
| `./setup.sh --stop` | Stop it (your reports are kept) |

Without Docker, see the manual route in [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).

## Connect an assistant

The server listens on `http://127.0.0.1:5081/mcp` (streamable HTTP).

- **ChatGPT and Grok** reach servers over the internet, so they need a public https address that forwards to your machine. The server has no sign-in of its own, so put it behind a tunnel that adds access control. Steps in [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md).
- **Clients on your computer** (Codex, Windsurf, any stdio-only client) connect through `mcp-remote`:

```json
{
  "mcpServers": {
    "sitewalk": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "http://127.0.0.1:5081/mcp"]
    }
  }
}
```

Then ask: `Audit https://yoursite.com for technical SEO problems`.

## What you get

- 30+ checks per audit (broken links, redirects, canonicals, titles and descriptions, headings, schema, images, hreflang, sitemap gaps, and more). Full list and the nine report files: [docs/CHECKS.md](docs/CHECKS.md).
- A branded PDF, a Markdown copy and CSVs, zipped in `./reports`.
- Chunked crawling that does not time out, WAF challenge detection, and a crawl delay that adapts to the site.
- 38 MCP tools: [docs/TOOLS.md](docs/TOOLS.md).

## Docs

| Guide | What is inside |
|---|---|
| [Getting started](docs/GETTING-STARTED.md) | Docker and manual setup, connecting clients, your first audit |
| [Configuration](docs/CONFIGURATION.md) | Every environment variable, HTTP and stdio transport |
| [Tools](docs/TOOLS.md) | All 38 MCP tools |
| [Checks](docs/CHECKS.md) | The 30+ checks and the report files |
| [Architecture](docs/ARCHITECTURE.md) | How the pieces fit |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common errors and fixes |

## Releases

Every change to the code that lands on `main` is tested and published as a new [GitHub release](https://github.com/adityaarsharma/sitewalk/releases) automatically. Update with `./setup.sh --update`.

## Licence and credits

Code is MIT: see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md). Built on [LibreCrawl](https://github.com/PhialsBasement/LibreCrawl) (MIT), [FastMCP](https://github.com/jlowin/fastmcp) and [WeasyPrint](https://weasyprint.org/). No telemetry.

Built by [Aditya Sharma](https://adityaarsharma.com).
