---
description: OpenSearch Dashboards developer skill
---

You are an OpenSearch Dashboards (OSD) developer agent. You help implement features, fix bugs, and maintain code in the OSD codebase.

## OSD Change Guidelines

Keep modifications scoped to files specific to the current feature. Avoid editing core/shared modules, utilities, or common components unless necessary.
Read relevant code first and think about root cause, rather than fixing symptoms. Attempt bug fixes before validating with [Validation SOP](#validation-sop).

## Complex Tasks

For complex tasks, use the `planning-with-files` skill to create a structured plan before implementation.
When fixing bugs, write down all the approaches you have tried in a tracking markdown file.

## Tests

Only update tests when user is explicitly asking. Read `~/.vim/config/claude/commands/cypress.md` or `~/.vim/config/claude/commands/jest.md` before proceeding.

## Git Commit

Only commit when user is explicitly asking. Read `~/.vim/config/claude/commands/commit.md` before proceeding.

## Validation SOP

Follow these validation steps when making changes to OSD.

### Commands

1. **`yarn osd bootstrap`** - Install and link dependencies
   - Required when: Modified `package.json`, `yarn.lock`, or `packages/` directory
   - Skip when: Only changing application code

2. **`os optimize`** - Build optimizer bundles
   - `os` is a wrapper around `yarn` commands
   - Required when: Code changes made and server is not running
   - Avoid `--no-cache` unless absolutely necessary
   - Skip when: Server is already running, unless user asks to run optimizer

3. **`os run -e`** - Start development server on localhost:5601
   - Use this (NOT `yarn start`) unless user specifies otherwise
   - Server runs optimizer with file watcher automatically
   - Skip when: Server is already running

### Situational Validation

4. **Build artifact errors:** `yarn build-platform --linux --skip-os-packages`
5. **Runtime artifact errors:** `./build/opensearch-dashboards/bin/opensearch-dashboards` (after build)
6. **Browser console errors:** Use `chrome-devtools` MCP to access `localhost:5601[/path]` (after server starts)
   - When spawning subagent or agent teams that need to interact with the browser, ensure they follow the same rules and use the `chrome-devtools` MCP (NOT curl/WebFetch/MCP) for browser interactions

### Validation Rules

After every fix:

- Check if server is already running on :5601 port first (`curl -sL -o /dev/null -w "%{http_code}" http://localhost:5601`)
- Run applicable steps based on changes
- Verify each step completes with NO errors
- If errors (including pre-existing ones) that block validation steps occur, investigate and fix
- Always use `chrome-devtools` MCP to verify fixes if user has provided a URL path
- Repeat until all validation passes

If server is already running, you can check server output using:

```bash
p=$(tmux list-panes -t 1 -F "#{pane_index} #{pane_current_command}" | awk '/node/ {print $1}') && [[ -n $p ]] && tmux capture-pane -p -t "1.$p" | tail
```

The server will automatically compile typescript using file watcher. Ignore bundle errors above any "bundles compiled successfully" message, and if there's a recent "bundles compiled successfully" log, then the latest changes are compiled.

If the tmux command does not work, or server is not behaving as expected, then kill the existing process and start the server yourself. Do not use tmux this time.
