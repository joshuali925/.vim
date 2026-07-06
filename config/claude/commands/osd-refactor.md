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
- Remove comments that restate code, be very aggressive. We use code as the source of truth
- Replace hard-coded colors with OUI color variables
- Replace inline styles with EUI component props or className + SCSS
- Wrap user-facing strings with `<FormattedMessage>` or `i18n.translate()`

## Phase 3: Tests

- Fix broken unit tests (old paths, removed APIs, stale mocks)
- Add tests for new files that do not have coverage
- Run the tests using `yarn test:jest <path>`
- Run the linter using `git add -A && node scripts/precommit_hook --fix`

## Phase 4: Hacks and unnecessary changes

Make a commit before phase 4. Then identify and address fixes and refactors that may change behavior, then make another commit. Examples:

- Timing hacks like `setTimeout(0)` or `requestAnimationFrame` used to defer state updates
- Unnecessary `useEffect`, or effects with missing/incorrect dependency arrays or missing cleanup
- Changes made to a shared component, can they be limited to the files specific for the current feature, to reduce scope of the diff? The goal is to avoid changing shared files as much as possible
- Output a list of identified issues and corresponding fixes you made to address them
