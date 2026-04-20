---
description: Refactor OpenSearch Dashboards
---

Run tests after each phase. Do not add features or refactor beyond scope. Do not change behaviors.

## Phase 1: Reorganize

- Decompose large files into smaller, focused units
- Extract shared logic into reusable modules within the directory
- Relocate files to subdirectories by domain grouping
- Follow existing naming conventions (snake_case, named exports)

## Phase 2: Cleanup

- Consolidate duplicates into shared utilities from Phase 1
- Grep to verify exports are imported somewhere before deleting
- Remove unused `export` keywords
- Remove dead code
- Remove `import React` if not used
- Strip comments that restate code; keep license headers, "why" comments, TODOs
- Replace hard-coded colors with OUI color variables
- Replace inline styles with EUI component props or className + SCSS
- Wrap user-facing strings with `<FormattedMessage>` or `i18n.translate()`

## Phase 3: Tests

- Fix broken unit tests (old paths, removed APIs, stale mocks)
- Add tests for new files that do not have coverage
- Run the tests using `yarn test:jest <path>`
- Run the linter using `git add -A && node scripts/precommit_hook --fix`
