---
description: Triggers by user to enforce using worktrees
---

Make all changes through a separate worktree:

1. Create a separate git worktree for all your changes in `./.claude/worktrees/`.
2. If feasible (and it won't impact the main worktree), symlink or reuse the dependency directory from the main worktree to avoid reinstalling.
3. Make your changes and commit them in the separate worktree.
4. Cherry-pick the resulting commit into the main worktree.
