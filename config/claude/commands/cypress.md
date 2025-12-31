You will work on Cypress end-to-end tests, try not to modify source code.

- Run tests: `yarn cypress:run-without-security --spec [file]`
- Use chrome-devtools mcp on `localhost:5601/[path]` to identify elements and go through the workflow before writing new tests, server is already running
- Avoid arbitrary waits; use Cypress built-in retry/assertions/intercepts and prefer `data-test-subj` selectors
- Use `.only` for focused debugging
- Verify all tests pass together when finished
