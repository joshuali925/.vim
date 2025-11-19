You will be making a change to OpenSearch Dashboards. These commands can help to validate your change.

1. `yarn osd bootstrap`: install and linking dependencies.
2. `scripts/use_node scripts/build_opensearch_dashboards_platform_plugins`: run optimizer to create bundles.
3. `yarn start`: start OpenSearch Dashboards on localhost:5601. If user provides a `os run <args>` command, use it instead of `yarn start`.
4. If you are fixing errors related to building artifact: run `yarn build-platform --linux --skip-os-packages`.
5. If you are fixing errors related to running artifact: run `./build/opensearch-dashboards/bin/opensearch-dashboards` after build.
6. If you are fixing errors that show up in browser console: use chrome-devtools MCP to access localhost:5601[/path] after server has started.

After making any fix, you must follow these rules and investigate errors.

- If you've modified dependencies or the `packages/` directory, you must run 1 first. Otherwise it's not required.
- 2 is always required.
- 3-6 are required only for relevant situations.

Repeat the steps until they finish successfully with NO errors.
