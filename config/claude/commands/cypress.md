---
description: Write and run Cypress end-to-end tests
---

You will work on Cypress end-to-end tests, try not to modify source code, except for adding `data-test-subj` selectors.

- Run tests: `yarn cypress:run-without-security --spec [file]`
- Reduce cypress timeout for faster iterations
- Redirect output to a log file and check periodically, interrupt early and use `.only` for focused debugging
- Use `chrome-devtools` MCP on `localhost:5601/[path]` to identify elements and go through the workflow before writing new tests, server is already running
- Keep new tests simple and focused on essential workflows, not every possible interaction
- Avoid arbitrary waits; use Cypress built-in retry/assertions/intercepts
- Do not assert user facing text, create and use `data-test-subj` selectors
- Verify all tests pass together when finished
