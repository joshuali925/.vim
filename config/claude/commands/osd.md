# OpenSearch Dashboards Validation SOP

## Required Commands

1. **`yarn osd bootstrap`** - Install and link dependencies
   - Required when: Modified `package.json`, `yarn.lock`, or `packages/` directory
   - Skip when: Only changing application code

2. **`os optimize`** - Build optimizer bundles
   - Required when: Code changes made and server is not running
   - Avoid `--no-cache` unless absolutely necessary
   - Skip when: Server is already running

3. **`os run -e`** - Start development server on localhost:5601
   - Use this (NOT `yarn start`) unless user specifies otherwise
   - Server runs optimizer with file watcher automatically
   - Skip when: Server is already running

## Situational Validation

4. **Build artifact errors:** `yarn build-platform --linux --skip-os-packages`
5. **Runtime artifact errors:** `./build/opensearch-dashboards/bin/opensearch-dashboards` (after build)
6. **Browser console errors:** Use chrome-devtools MCP to access localhost:5601 with optionally provided path (after server starts)

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

If the tmux command does not work, or server is not behaving as expected, then kill the existing process and start the server yourself. Do not use tmux this time.
