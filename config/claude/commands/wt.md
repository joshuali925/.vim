---
description: Triggers by user to enforce using worktrees
disable-model-invocation: true
---

Make all changes through a separate worktree:

1. Create a separate git worktree for all your changes in `./.claude/worktrees/`.
2. If feasible (and it won't impact the main worktree), symlink or reuse the dependency directory from the main worktree to avoid reinstalling.
3. Make your changes and commit them in the separate worktree.
4. Cherry-pick the resulting commit into the main worktree. This step must run from the main checkout, leave the worktree first (e.g. `ExitWorktree` back to the main checkout) before cherry-picking. If the cherry-pick fails due to unstaged changes, stop and report the commit with the error.
