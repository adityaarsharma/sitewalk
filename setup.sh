#!/usr/bin/env bash
# Sitewalk MCP server: guided local setup (Docker).
#
#   ./setup.sh            guided: checks, asks one question, builds, starts, tests, prints how to connect
#   ./setup.sh --yes      same, no questions (reads PAGESPEED_API_KEY from the environment if set)
#   ./setup.sh --check    only check that this machine can run it
#   ./setup.sh --update   pull the latest code and rebuild
#   ./setup.sh --stop     stop the containers (reports in ./reports are kept)
set -euo pipefail
cd "$(dirname "$0")"

MCP_URL="http://127.0.0.1:5081/mcp"
YES=0; MODE=setup
for a in "$@"; do
  case "$a" in
    --yes|-y) YES=1 ;;
    --check) MODE=check ;;
    --update) MODE=update ;;
    --stop) MODE=stop ;;
    -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $a (try --help)" >&2; exit 2 ;;
  esac
done

if [ -t 1 ]; then B=$'\033[1m'; G=$'\033[32m'; R=$'\033[31m'; N=$'\033[0m'; else B=; G=; R=; N=; fi
ok()   { echo "${G}ok${N}   $*"; }
fail() { echo "${R}fail${N} $*" >&2; exit 1; }
step() { echo; echo "${B}$*${N}"; }

check_machine() {
  step "1/4 Checking this machine"
  command -v docker >/dev/null 2>&1 || fail "Docker is not installed. Get it at https://docs.docker.com/get-docker/ then run ./setup.sh again."
  docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 is missing. Update Docker Desktop, or install the compose plugin."
  docker info >/dev/null 2>&1 || fail "Docker is installed but not running. Start Docker Desktop (or the docker service) and run ./setup.sh again."
  ok "Docker and Compose are ready"
  if command -v lsof >/dev/null 2>&1 && lsof -iTCP:5081 -sTCP:LISTEN >/dev/null 2>&1 \
     && ! docker compose ps --status running 2>/dev/null | grep -q mcp; then
    fail "Port 5081 is already used by another program. Stop it, then run ./setup.sh again."
  fi
  ok "Port 5081 is free (or already ours)"
}

write_env() {
  step "2/4 Settings"
  if [ -f .env ]; then ok ".env already exists, keeping it"; return; fi
  key="${PAGESPEED_API_KEY:-}"
  if [ "$YES" -eq 0 ] && [ -z "$key" ]; then
    echo "Optional: a Google PageSpeed Insights API key turns on the PageSpeed tools."
    echo "Free key: https://developers.google.com/speed/docs/insights/v5/get-started"
    printf "Paste it, or press Enter to skip: "
    read -r key || key=""
  fi
  ( umask 077; printf '# Created by setup.sh. Never commit this file.\nPAGESPEED_API_KEY=%s\n' "$key" > .env )
  ok "wrote .env"
}

start_stack() {
  step "3/4 Building and starting (the first build takes a few minutes: it downloads Chromium for JS pages)"
  mkdir -p reports
  docker compose up -d --build
  printf "Waiting for the MCP server"
  for _ in $(seq 1 90); do
    code=$(curl -s -o /dev/null -m 3 -w '%{http_code}' "$MCP_URL" 2>/dev/null || true)
    if [ -n "$code" ] && [ "$code" != "000" ]; then
      echo; ok "MCP server answers at $MCP_URL (HTTP $code)"; return
    fi
    printf "."; sleep 3
  done
  echo
  docker compose logs --tail 40 || true
  fail "The MCP server did not come up in 4.5 minutes. The last log lines are above. Full logs: docker compose logs"
}

print_next() {
  step "4/4 Connect an AI client"
  cat <<EOT
Your MCP server runs only on this machine: $MCP_URL
Audit reports (zip with PDF and CSVs) are saved in: $(pwd)/reports

${B}Clients that run on this computer${N} (Codex, Windsurf, any client that speaks stdio only):
  { "mcpServers": { "sitewalk": { "command": "npx", "args": ["-y", "mcp-remote", "$MCP_URL"] } } }

${B}ChatGPT and Grok${N} reach your server over the internet, so they need a public https address
that forwards to $MCP_URL. The server has no sign-in of its own, so do not publish it bare:
  1. Open a tunnel that adds access control (for example Cloudflare Tunnel with Access, or ngrok with OAuth).
  2. ChatGPT: add a custom MCP connector in its settings (developer mode may be needed), then paste <your https address>/mcp.
     Grok: add a custom connector with the same address.
  More: docs/GETTING-STARTED.md

Then ask your assistant:  Audit https://yoursite.com for technical SEO problems

Later:  ./setup.sh --update  (newest release)    ./setup.sh --stop  (shut it down)
EOT
}

case "$MODE" in
  check)  check_machine ;;
  stop)   docker compose down; ok "stopped" ;;
  update)
    check_machine
    if [ -d .git ]; then git pull --ff-only || fail "git pull failed. Resolve local changes, then run ./setup.sh --update again."; fi
    start_stack; print_next ;;
  setup)  check_machine; write_env; start_stack; print_next ;;
esac
