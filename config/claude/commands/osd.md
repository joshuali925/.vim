# OpenSearch Dashboards Validation Protocol

When making changes to OpenSearch Dashboards, follow this validation workflow:

## Required Commands

1. **`yarn osd bootstrap`** - Install and link dependencies
   - **Required when:** You've modified `package.json`, `yarn.lock`, or anything in `packages/` directory
   - **Skip when:** Only changing application code

2. **`scripts/use_node scripts/build_opensearch_dashboards_platform_plugins`** - Build optimizer bundles
   - **Required when** You've made code changes, and the server is not running
   - Avoid `--no-cache` flag unless absolutely necessary

3. **`os run -e`** - Start development server on localhost:5601
   - Use this command (NOT `yarn start`) unless user specifies otherwise
   - `os run` is a wrapper with feature flags
   - Server runs optimizer with file watcher automatically
   - **If server is already running:** No need to stop and rerun step 2

## Situational Validation

4. **Build artifact errors:** `yarn build-platform --linux --skip-os-packages`

5. **Runtime artifact errors:** `./build/opensearch-dashboards/bin/opensearch-dashboards` (after build)

6. **Browser console errors:** Use chrome-devtools MCP to access localhost:5601 with optionally provided path (after server starts)

## Validation Rules

After **every fix**, you must:
- Run applicable steps based on what you changed
- Verify each step completes with **NO errors**
- If errors occur, investigate and fix them
- Repeat until all validation passes successfully
