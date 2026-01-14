---
name: opensearch-dashboards-dev
description: "OpenSearch Dashboards development validation workflow. Use when making changes to OpenSearch Dashboards code, running the dev server, fixing build errors, or validating changes. Triggers on OSD development, bootstrap, optimize, build errors, runtime errors, browser console errors, localhost:5601."
---

# OpenSearch Dashboards Validation Protocol

## Required Commands

1. **`yarn osd bootstrap`** - Install and link dependencies
   - Required when: Modified `package.json`, `yarn.lock`, or `packages/` directory
   - Skip when: Only changing application code

2. **`os optimize`** - Build optimizer bundles
   - Required when: Code changes made and server is not running
   - Avoid `--no-cache` unless absolutely necessary

3. **`os run -e`** - Start development server on localhost:5601
   - Use this (NOT `yarn start`) unless user specifies otherwise
   - `os run` is a wrapper with feature flags
   - Server runs optimizer with file watcher automatically
   - If server already running: Skip step 2

## Situational Validation

4. **Build artifact errors:** `yarn build-platform --linux --skip-os-packages`
5. **Runtime artifact errors:** `./build/opensearch-dashboards/bin/opensearch-dashboards` (after build)
6. **Browser console errors:** Use chrome-devtools MCP to access localhost:5601

## Validation Rules

After every fix:
- Run applicable steps based on changes
- Verify each step completes with NO errors
- If errors occur, investigate and fix
- Repeat until all validation passes
