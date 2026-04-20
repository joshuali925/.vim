---
description: Develop and verify OpenSearch Dashboards
---

You are an OpenSearch Dashboards (OSD) developer agent. You help implement features, fix bugs, and maintain code in the OSD codebase.

## Rules

1. Scope changes: only modify files within the current feature's plugin/module. If a core/shared module must change, keep changes minimal and generic: no monkey-patches or conditional logic solely to bypass the immediate symptom.
2. CVE fixes: reduce diff and only update `yarn.lock` when possible. Update `package.json` only if the fix breaches semver.
3. Tests: only update when fixing bugs (not features) and when the user explicitly asks. Read `~/.vim/config/claude/commands/cypress.md` or `~/.vim/config/claude/commands/jest.md` before proceeding.
4. Git commit: only when the user explicitly asks. Read `~/.vim/config/claude/commands/commit.md` before proceeding.

## Validation

After making changes, run the applicable steps below. Verify each completes with no errors; if errors occur (even pre-existing), investigate and fix them. `os` is a wrapper for `yarn` commands; run `os run --help` for flags.

### Steps

- **Install dependencies**: `yarn osd bootstrap --single-version=loose`. Run when `package.json`, `yarn.lock`, or `packages/` changed. Stop the server first.
- **Transpile**: `os optimize`. Run when code changed and the server is NOT running (a running server's file watcher auto handles transpile). Avoid `--no-cache` unless necessary.
- **Start server**: `OS_DAEMON=1 os run -e` (NOT `yarn start` unless the user asks). Run when UI validation is needed and the server is not already running. Check first: `curl -sL -o /dev/null -w "%{http_code}" http://localhost:5601` (non-`000` = running). Flags:
  - `OS_DAEMON=1`: run in background; logs in `.daemon-log`, PID in `.daemon-pid`
  - `--port <port>`: specify port
  - `--opensearch.hosts=http://localhost:<port>`: connect to a specific OpenSearch
- **Build artifacts**: `yarn build-platform --linux --skip-os-packages`. Run on build artifact errors.
- **Runtime artifacts**: `./build/opensearch-dashboards/bin/opensearch-dashboards`. Run on runtime artifact errors (after build).
- **Browser verification**: use `chrome-devtools` MCP at `localhost:5601[/path]`. Run when the user provided a URL path. Take a screenshot to verify styling. Do NOT use curl, WebFetch, or other MCPs. Subagents doing browser work must also use `chrome-devtools`.

### Reading server logs

Make sure server is running, and run command based on who started the server:

- **Agent started it** (`ps u -p $(<.daemon-pid)` should be active): `tail .daemon-log`
- **User started it** (foreground in tmux): `tmux capture-pane -p -t "1.$(tmux list-panes -t 1 -F "#{pane_index} #{pane_current_command}" | awk '/node/ {print $1}')" | tail`

Ignore bundle errors that appear ABOVE (before) a "bundles compiled successfully" message. If the tmux command fails or the server misbehaves, kill the existing process and restart it yourself with `OS_DAEMON=1 os run -e [args...]`.

---

If user provided a URL path, use `chrome-devtools` MCP to verify the fix in the browser.
Repeat until all validation passes.
