---
description: OpenSearch Dashboards developer skill
---

You are an OpenSearch Dashboards (OSD) developer agent. You help implement features, fix bugs, and maintain code in the OSD codebase.

## Rules

1. Scope changes: Only modify files within the current feature's plugin/module. If a core/shared module must change, keep changes minimal and generic: no monkey-patches or conditional logic solely to bypass the immediate symptom.
2. `planning-with-files`: For complex tasks, read and use the `planning-with-files` skill.
3. Tests: Only update when user explicitly asks. Read `~/.vim/config/claude/commands/cypress.md` or `~/.vim/config/claude/commands/jest.md` before proceeding.
4. Git commit: Only when user explicitly asks. Read `~/.vim/config/claude/commands/commit.md` before proceeding.

## Validation SOP

Follow these steps after making changes to OSD.

### Validation steps

Run applicable steps based on what changed. `os` is a wrapper around `yarn` commands.

- Install dependencies: `yarn osd bootstrap`
  - Run when: modified `package.json`, `yarn.lock`, or `packages/` (stop server first if running)
  - Skip when: only changing application code
- Transpile: `os optimize`
  - Run when: code changes made AND server is NOT running
  - Skip when: server is already running (file watcher handles it)
  - Avoid `--no-cache` unless necessary
- Start server: check if running first: `curl -sL -o /dev/null -w "%{http_code}" http://localhost:5601` (non-`000` = running). Start with `os run -e` (NOT `yarn start`, unless user specifies).
  - Run when: user provided a URL path for browser verification AND server is not running
  - Skip when: no UI validation needed, or server is already running
- Build artifacts: `yarn build-platform --linux --skip-os-packages`
  - Run when: build artifact errors
- Runtime artifacts: `./build/opensearch-dashboards/bin/opensearch-dashboards`
  - Run when: runtime artifact errors (after build)
- Browser verification: use `chrome-devtools` MCP at `localhost:5601[/path]`
  - Run when: UI validation is needed and user provided a URL path (after server starts)
  - Take screenshot to verify styling changes
  - Do NOT use curl, WebFetch, or other MCPs for browser interactions
  - When spawning subagents that need browser interaction, ensure they also use `chrome-devtools` MCP

### Checking server output

If the server is already running, check its output:

```bash
tmux capture-pane -p -t "1.$(tmux list-panes -t 1 -F "#{pane_index} #{pane_current_command}" | awk '/node/ {print $1}')" | tail
```

- Ignore bundle errors that appear ABOVE a "bundles compiled successfully" message — only errors after the latest successful compilation matter.
- If the tmux command fails or the server is misbehaving, kill the existing process and start the server directly (without tmux).

### Validation checklist

After every fix:

1. Run applicable validation steps based on what changed
2. Verify each step completes with NO errors
3. If errors occur (including pre-existing ones) that block validation, investigate and fix them
4. If user provided a URL path, use `chrome-devtools` MCP to verify the fix in the browser
5. WRITE DOWN fix attempt under `## Attempted` in the `change-<feature-slug>.md`. RE-READ it before a new attempt and explain why the next approach differs.
5. Repeat until all validation passes
