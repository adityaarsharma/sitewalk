# Troubleshooting

Common problems and fixes. If none of these match, [open an issue](https://github.com/adityaarsharma/sitewalk/issues/new) with the failing tool call and any server logs.

## The MCP starts but every audit fails to connect

**Symptom:** tools return connection errors, or the crawl never leaves `queued`.

**Cause:** the MCP can't reach the LibreCrawl backend.

**Fix:** confirm the backend is up and that `LIBRECRAWL_URL` points at it.
- Docker: `docker compose ps` should show `librecrawl` as `healthy`.
- Manual: check the backend responds — `curl http://127.0.0.1:5080/` — and start the MCP with `LIBRECRAWL_URL=http://127.0.0.1:5080`.
- Inside containers, `127.0.0.1` refers to the container itself — use the service name (`http://librecrawl:5000`), which Compose sets for you.

## Audits complete but the report is empty

**Symptom:** `status: done` but `pages_done` is 0 or the zip has no crawl data; `upstream_crawl_id` is null.

**Cause:** LibreCrawl's session-persistence bug — it reads `session_id` before the crawler creates it, so results are never written to its DB.

**Fix:** apply the session-persistence patch to LibreCrawl's `main.py`. This repo's Docker image (and so `./setup.sh`) applies it automatically (`docker/patch-librecrawl.py`). If you run LibreCrawl by hand, run that patch script against its `main.py` and restart the backend.

## PDF generation fails / no PDF in the zip

**Symptom:** CSVs are present but the `.pdf` is missing, or a WeasyPrint import/library error appears in logs.

**Cause:** WeasyPrint needs system libraries (Pango, Cairo, GDK-Pixbuf, HarfBuzz) that aren't installed.

**Fix:**
- Docker: already baked into the image — rebuild with `docker compose build --no-cache mcp` if you customized the Dockerfile.
- Manual (Debian/Ubuntu): `sudo apt-get install -y libpango-1.0-0 libpangocairo-1.0-0 libcairo2 libgdk-pixbuf-2.0-0 libffi-dev libharfbuzz0b libfribidi0 fonts-dejavu-core`
- macOS (Homebrew): `brew install pango cairo gdk-pixbuf libffi`

## Docker: `librecrawl` never becomes healthy

**Symptom:** `docker compose up` hangs on the health check; `mcp` never starts.

**Fix:**
- The first build downloads Chromium and can take several minutes — give it time (`start_period` is 60s, with retries).
- Check the engine logs: `docker compose logs librecrawl`.
- If the build failed on the Chromium/Playwright step, the image still runs (JS rendering just won't be available); rebuild with `docker compose build librecrawl`.

## Port already in use

**Symptom:** `address already in use` on `5080` or `5081`.

**Fix:** change the ports. Set `MCP_PORT` for the MCP and `LIBRECRAWL_PORT` (or a full `LIBRECRAWL_URL`) for the backend. In Docker, edit the `ports:` mapping in `docker-compose.yml`.

## Client can't see the tools

**Symptom:** your assistant says the librecrawl tools aren't available.

**Fix:**
- Fully **restart** the MCP client after editing its config (a reload isn't always enough).
- HTTP transport: confirm the endpoint responds and the `mcp-remote` URL matches `http://<host>:<MCP_PORT>/mcp`.
- stdio transport: confirm the `command`/`args` point at the right Python and `server.py`, and that `MCP_TRANSPORT=stdio` is in the `env` block.

## Large sites: slow, or the origin starts rate-limiting

**Symptom:** a very large/heavy site crawls slowly or the origin pushes back.

**This is by design.** The AIMD controller trades speed for politeness — it backs off automatically when it sees errors or rising latency so it never overloads an origin. Heavy pages get more *time*, not more *parallelism*. Let it run; progress is persisted, and the crawl survives restarts. If it appears stuck in discovery, `librecrawl_audit_force_advance(session_id)` finalizes the pages crawled so far.

## Orphan/cleanup checks are skipped

**Symptom:** logs mention the upstream DB wasn't found.

**Cause:** `LIBRECRAWL_UPSTREAM_DB` doesn't point at LibreCrawl's SQLite file.

**Fix:** set it to the real path (Docker shares it via a volume at `/librecrawl-data/users.db`). This only affects orphan-page/cleanup checks — the core audit is unaffected, which is why it degrades silently.
