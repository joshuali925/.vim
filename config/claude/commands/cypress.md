---
description: Write and run Cypress end-to-end tests
---

You will work on Cypress end-to-end tests, try not to modify source code, except for adding `data-test-subj` selectors.

- Run tests: `yarn cypress:run-without-security --spec [file]`
- Reduce cypress timeout for faster iterations
- Redirect output to a log file and check periodically, interrupt early and use `.only` for focused debugging
- Use `chrome-devtools` MCP on `localhost:5601/[path]` to identify elements and go through the workflow before writing new tests, server is already running. You can also use it for debugging failures.

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
