<!-- mcp-name: io.github.adityaarsharma/librecrawl-technical-seo-audit-mcp -->

<div align="center">

<img src="docs/assets/sitewalk-logo.png" alt="Sitewalk logo" width="96" height="96">

# Sitewalk: technical SEO audit MCP server

**Ask your AI assistant to audit a website. Get the technical SEO problems back, ranked by impact, with a plain fix for each.**

<p>
<a href="https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a"><img alt="Use Sitewalk in ChatGPT" src="https://img.shields.io/badge/Use%20Sitewalk%20in%20ChatGPT-10A37F?style=for-the-badge&logo=openai&logoColor=white"></a>
<a href="#set-it-up-on-your-machine"><img alt="Self-host with Docker" src="https://img.shields.io/badge/Self--host%20with%20Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"></a>
<a href="https://audit.adityaarsharma.com/"><img alt="Website" src="https://img.shields.io/badge/audit.adityaarsharma.com-111827?style=for-the-badge"></a>
</p>
<p>
<a href="#what-is-the-chatgpt-app"><img alt="What is the ChatGPT app?" src="https://img.shields.io/badge/What%20is%20the%20ChatGPT%20app%3F-6B7280?style=flat-square"></a>
<a href="#what-is-mcp"><img alt="What is MCP?" src="https://img.shields.io/badge/What%20is%20MCP%3F-6B7280?style=flat-square"></a>
<a href="LICENSE"><img alt="MIT licence" src="https://img.shields.io/badge/licence-MIT-blue?style=flat-square"></a>
<a href="https://github.com/adityaarsharma/sitewalk/releases"><img alt="Latest release" src="https://img.shields.io/github/v/release/adityaarsharma/sitewalk?style=flat-square&color=brightgreen"></a>
<a href="https://github.com/PhialsBasement/LibreCrawl"><img alt="Powered by LibreCrawl" src="https://img.shields.io/badge/powered%20by-LibreCrawl-7C3AED?style=flat-square"></a>
</p>

</div>

---

This repository is the Sitewalk MCP server and nothing else: a Python server that drives the open-source [LibreCrawl](https://github.com/PhialsBasement/LibreCrawl) crawler, runs 30+ technical SEO checks, and hands your AI assistant a ranked report plus a zip of PDF and CSVs. It runs on your own machine, with no account, no sign-in and no page cap. Nothing leaves your machine except the requests the crawler makes to the site you audit.

Prefer not to host anything? Use the hosted [ChatGPT app](#what-is-the-chatgpt-app).

## What is the ChatGPT app?

Sitewalk also runs as an app inside ChatGPT, hosted by us. There is nothing to install: open it, type `Audit https://yoursite.com`, and ChatGPT brings back the technical SEO problems ranked by impact, a plain fix for each, and a link to the full report. Plans and limits are on [audit.adityaarsharma.com](https://audit.adityaarsharma.com/). The hosted service is separate from the code in this repository.

## What is MCP?

MCP (Model Context Protocol) is an open standard that lets an AI assistant call outside tools. This repository is one such tool: your assistant asks it to crawl a site and gets the findings back. You do not need to know anything about MCP to use the ChatGPT app. It only matters if you run this repository yourself.

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
