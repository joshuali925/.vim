# OpenSearch Dashboards Validation SOP

## Required Commands

1. **`yarn osd bootstrap`** - Install and link dependencies
   - Required when: Modified `package.json`, `yarn.lock`, or `packages/` directory
   - Skip when: Only changing application code

2. **`os optimize`** - Build optimizer bundles
   - Required when: Code changes made and server is not running
   - Avoid `--no-cache` unless absolutely necessary
   - Skip when: Server is already running, unless user asks to run it

3. **`os run -e`** - Start development server on localhost:5601
   - Use this (NOT `yarn start`) unless user specifies otherwise
   - Server runs optimizer with file watcher automatically
   - Skip when: Server is already running

## Situational Validation

4. **Build artifact errors:** `yarn build-platform --linux --skip-os-packages`
5. **Runtime artifact errors:** `./build/opensearch-dashboards/bin/opensearch-dashboards` (after build)
6. **Browser console errors:** Use chrome-devtools MCP to access localhost:5601 with optionally provided path (after server starts)

## Browser Testing with Chrome DevTools MCP

When spawning subagent or agent teams that need to interact with the browser, include these instructions in their prompt to ensure they discover and use the MCP tools:

> You have Chrome DevTools MCP tools available. Do NOT use curl, WebFetch, or Bash for browser interaction — use the MCP tools instead. Start by using the `mcp__chrome-devtools__new_page` tool to open a new browser tab with a URL.

## Validation Rules

After every fix:

- Check if server is already running on :5601 first
- Run applicable steps based on changes
- Verify each step completes with NO errors
- If errors occur, including pre-existing ones, investigate and fix
- Repeat until all validation passes

If server is already running, you can check server output using:

```bash
tmux capture-pane -p -t 1.$(tmux list-panes -t 1 -F "#{pane_index} #{pane_current_command}" | awk '/node/ {print $1}')
```

The server will automatically compile typescript using file watcher. If there's a recent "bundles compiled successfully" log, then the latest changes are compiled.

If the tmux command does not work, or server is not behaving as expected, then kill the existing process and start the server yourself. Do not use tmux this time.
