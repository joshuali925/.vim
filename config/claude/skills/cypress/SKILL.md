---
name: cypress
description: Write and run Cypress end-to-end tests
---

You will work on Cypress end-to-end tests, try not to modify source code, except for adding `data-test-subj` selectors.

- Run tests: `yarn cypress:run-without-security --spec [file]`
- Reduce cypress timeout for faster iterations
- Redirect output to a log file and check periodically, interrupt early and use `.only` for focused debugging
- Use the chrome MCP on `localhost:5601/[path]` to identify elements and go through the workflow before writing new tests, server is already running. You can also use it for debugging failures.

### New tests

- Keep new tests simple and focused on essential workflows, not every possible interaction
- Avoid arbitrary waits; use Cypress built-in retry/assertions/intercepts
- Do not assert user facing text. Instead, use `data-test-subj` selectors. If `data-test-subj` attribute does not already exist, create one with the appropriate prefix.

### Existing tests failed

- Prefer scoping every change to the newly added code. Avoid modifying existing source or existing tests unless a failure proves it's necessary
- If an existing test fails due to a behavioral change on the UI, confirm with the user whether the change is intentional
    - Unintentional: the new code caused a regression and fix it in the new code
    - Intentional: only then update the existing test to match the new behavior

Verify all tests pass together when finished.

## OSD Dev Server Config for Cypress

When running OSD locally with `os run -e` for Cypress tests, the `-e` flag adds default args that enable features which break classic plugin navigation:
- `--data_source.enabled=true` — causes plugins using `if (!dataSource)` pattern to skip app registration
- `--workspace.enabled=true` — redirects `/app/home` to `/app/workspace_initial`
- `--uiSettings.overrides['home:useNewHomePage']=true` — enables navGroup system

To disable these for running legacy plugin Cypress tests (e.g., reports-dashboards), append overrides AFTER the `-e` defaults:
```bash
OS_DAEMON=1 os run -e -- --no-base-path \
  --home.disableWelcomeScreen=true \
  --home.disableExperienceModal=true \
  --workspace.enabled=false \
  --data_source.enabled=false \
  "--uiSettings.overrides[home:useNewHomePage]=false" \
  --opensearch.hosts=http://localhost:$OS_PORT
```

The last-specified value wins for duplicate CLI args.

For the integration-test CI (bundled distribution), the workflow template uses:
```
bin/opensearch-dashboards serve --home.disableExperienceModal=true --home.disableWelcomeScreen=true
```
The bundled distribution doesn't have the `-e` dev defaults, so it doesn't need the extra overrides.
