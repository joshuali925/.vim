# OpenSearch-Dashboards Directory Refactoring

Break up tasks and spawn one subagent per directory. Each subagent owns all phases for its directory and must not modify files outside it. Cross-directory issues (dead code, duplication) should be reported, not fixed.

Run tests after each phase. When in doubt about removing code, leave it. Do not add features or refactor beyond scope.

## Phase 1: Reorganize (no behavior changes)
- Decompose large files into smaller, focused units
- Extract shared logic into reusable modules within the directory
- Relocate files to subdirectories by domain grouping
- Follow existing naming conventions (snake_case, named exports)

## Phase 2: Cleanup
- Consolidate duplicates into shared utilities from Phase 1
- Grep to verify exports are imported somewhere before deleting
- Delete confirmed dead/unused code
- Strip comments that restate code; keep license headers, "why" comments, TODOs
- Replace hard-coded colors with OUI color variables
- Eliminate inline styles — use EUI component props, or a className + SCSS rule
- Wrap user-facing strings with `<FormattedMessage>` or `i18n.translate()`

## Phase 3: Tests
- Fix broken tests (old paths, removed APIs, stale mocks)
- Add tests for files that does not have coverage
- Run the tests using `yarn test:jest <path>`

## Phase 4: Commit
- Request the main agent to commit using conventional commits (title only, no description)
