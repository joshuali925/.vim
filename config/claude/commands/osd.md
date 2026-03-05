---
description: OpenSearch Dashboards validation SOP
---

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
6. **Browser console errors:** Use `playwright-cli` skill to access `localhost:5601` with optionally provided path (after server starts)
   - Store any generated images, logs, etc. in the `./.playwright-cli/` directory
   - When spawning subagent or agent teams that need to interact with the browser, ensure they use the `playwright-cli` skill (NOT curl or WebFetch) for browser interactions

## Validation Rules

After every fix:

- Check if server is already running on :5601 port first (`curl -sL -o /dev/null -w "%{http_code}" http://localhost:5601`)
- Run applicable steps based on changes
- Verify each step completes with NO errors
- If errors occur, including pre-existing ones, investigate and fix
- Always use `playwright-cli` skill to verify fixes if user has provided a URL path
- Repeat until all validation passes

If server is already running, you can check server output using:

```bash
p=$(tmux list-panes -t 1 -F "#{pane_index} #{pane_current_command}" | awk '/node/ {print $1; e=1} END {exit !e}') && tmux capture-pane -p -t "1.$p"
```

The server will automatically compile typescript using file watcher. Ignore bundle errors above any "bundles compiled successfully" message, and if there's a recent "bundles compiled successfully" log, then the latest changes are compiled.

If the tmux command does not work, or server is not behaving as expected, then kill the existing process and start the server yourself. Do not use tmux this time.
