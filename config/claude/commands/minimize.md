---
description: Triggers by user to minimize code
disable-model-invocation: true
---

Minimize the given file, path, or diff. Maximize the information density to match this repo's style:

- Extract and reuse shared code; delete the duplicates.
- Inline single-use helpers and single-use locals; flatten call layers.
- Collapse short multi-line statements to one line; don't join plain separate statements (`a; b`).
- Replace nesting with guard-clause early returns.
- Drop comments and error handling the code already conveys.
- Remove hand-toggled flags and collapse their branching to the active path.
- Remove unnecessary variables creation.

For bash scripts:

- Prefer `if [[ condition ]]; then action1; else action2; fi` over `[ ]` or `condition && action1 || action2`.
- Prefer shell builtins over pipe and subshells.

Done when every remaining line earns its place — dense but still readable.
