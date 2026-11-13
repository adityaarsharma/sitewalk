<!-- mcp-name: io.github.adityaarsharma/librecrawl-technical-seo-audit-mcp -->

<div align="center">

<img src="docs/assets/sitewalk-logo.png" alt="Sitewalk logo" width="96" height="96">

# Sitewalk: SEO audit in ChatGPT, and the open-source technical SEO audit server

**Ask ChatGPT to audit your website. Find what is broken, what to fix first, and how, in about a minute of your time.**

<p>
<a href="https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a"><img alt="Use Sitewalk in ChatGPT" src="https://img.shields.io/badge/Use%20Sitewalk%20in%20ChatGPT-10A37F?style=for-the-badge&logo=openai&logoColor=white"></a>
<a href="#set-it-up-on-your-machine"><img alt="Self-host with Docker" src="https://img.shields.io/badge/Self--host%20with%20Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"></a>
<a href="https://sitewalkseo.com/"><img alt="Website" src="https://img.shields.io/badge/sitewalkseo.com-111827?style=for-the-badge"></a>
</p>
<p>
<a href="#what-is-the-chatgpt-app"><img alt="ChatGPT or self-host?" src="https://img.shields.io/badge/ChatGPT%20or%20self--host%3F-6B7280?style=flat-square"></a>
<a href="#what-is-mcp"><img alt="What is MCP?" src="https://img.shields.io/badge/What%20is%20MCP%3F-6B7280?style=flat-square"></a>
<a href="LICENSE"><img alt="MIT licence" src="https://img.shields.io/badge/licence-MIT-blue?style=flat-square"></a>
<a href="https://github.com/adityaarsharma/sitewalk/releases"><img alt="Latest release" src="https://img.shields.io/github/v/release/adityaarsharma/sitewalk?style=flat-square&color=brightgreen"></a>
<a href="https://github.com/PhialsBasement/LibreCrawl"><img alt="Powered by LibreCrawl" src="https://img.shields.io/badge/powered%20by-LibreCrawl-7C3AED?style=flat-square"></a>
</p>

</div>

---

Sitewalk crawls your site the way a search engine bot does and gives you the technical SEO problems ranked by impact, each with a plain fix, a site health score out of 100, and a report you can send to a client or developer.

## Two ways to use it

| | **In ChatGPT** (hosted) | **Self-hosted** (this repository) |
|---|---|---|
| Setup | None. Open the app, ask for an audit | Docker, one command: `./setup.sh` |
| Checks | 200+ in 18 groups | 30+ |
| Cost | Free to start, 5 audits a month | Free forever, MIT licence |
| Pages per audit | 50 without a confirmed email, 500 with one | No cap, your machine |
| Your data | Report links, CSV and PDF | Never leaves your machine |
| Best for | Site owners, freelancers, agencies | Developers who want to run it themselves |

Start in ChatGPT: [Use Sitewalk in ChatGPT](https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a). This repository is the open-source server and nothing else: a Python MCP server that drives the open-source [LibreCrawl](https://github.com/PhialsBasement/LibreCrawl) crawler. The hosted service runs separate code.

## Try it in 60 seconds

1. Open [Sitewalk in ChatGPT](https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a).
2. Type: `Audit https://yoursite.com for technical SEO problems`
3. The first time, enter the 6-digit code we email you. No password.

Other things people ask it:

- `What should I fix first on my site?`
- `Find broken links, redirect chains and duplicate titles`
- `Is a noindex tag or robots.txt keeping my pages out of search?`
- `Is my site ready for AI search? Check llms.txt and AI crawler access`
- `Monitor yoursite.com and tell me if something breaks`

## What you get

- A site health score out of 100 and every problem ranked worst first, with the pages it affects.
- A plain-English fix for each problem, so you can act on it or hand it to a developer.
- A web report, plus PDF and CSV downloads.
- Checks for broken links and redirect chains, titles and meta descriptions, canonicals and noindex, hreflang, sitemaps, structured data, images, security headers, page speed and AI-search readiness.
- Monthly monitoring of a site you have audited, with an email only when something changes.
- Politeness built in: it reads robots.txt, identifies itself as SitewalkBot, and keeps a slow pace.

Not covered: backlinks, keyword rankings, Google Search Console or analytics data.

## Common questions

**Is there a Screaming Frog alternative that works inside ChatGPT?** Sitewalk runs the crawl on its own server and returns a ranked list in the chat, so there is nothing to install. Screaming Frog is stronger for very large sites and custom extraction: see the [comparison](https://sitewalkseo.com/alternatives/screaming-frog/), with dated sources.

**Is there a free technical SEO audit tool?** Yes. Sitewalk is free for 5 audits a month in ChatGPT, and the self-hosted server is free with no limits.

**Does it work on any website?** Any public website, within robots.txt. A site that blocks crawlers will say so in the report.

**How long does an audit take?** A small site usually takes a few minutes, a 500-page audit 20 to 60 minutes. It keeps running if you close the chat, and you get an email when it is done.

## A free, open-source Screaming Frog alternative

The self-hosted build in this repository is free and MIT licensed, with no page cap and no account. You run it with Docker, ask your AI assistant to audit a site, and get a ranked list of technical SEO problems, a PDF and CSVs, with your data staying on your machine. It runs 30+ checks: broken links, redirects, canonicals, titles and descriptions, headings, schema, images, hreflang and sitemap gaps.

Screaming Frog is stronger for very large crawls, custom extraction and JavaScript rendering of a whole site. If you want the result inside ChatGPT without hosting anything, use the [hosted app](https://chatgpt.com/plugins/plugin_asdk_app_6ac47963cb448191a5b1757e0682bd6a) (200+ checks, 5 free audits a month). Dated comparison: [Sitewalk vs Screaming Frog](https://sitewalkseo.com/alternatives/screaming-frog/).

## What is MCP?

MCP (Model Context Protocol) is an open standard that lets an AI assistant call outside tools. This repository is one such tool: your assistant asks it to crawl a site and gets the findings back. You do not need to know anything about MCP to use Sitewalk in ChatGPT. It only matters if you run this repository yourself.

## Self-host it

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

## Self-hosted details

- 30+ checks per audit (self-hosted) (broken links, redirects, canonicals, titles and descriptions, headings, schema, images, hreflang, sitemap gaps, and more). Full list and the nine report files: [docs/CHECKS.md](docs/CHECKS.md).
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
