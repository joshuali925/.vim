---
name: wt
description: Make all changes in a separate git worktree, then cherry-pick them into the main checkout.
---

Make all changes through a separate worktree:

1. Create a separate git worktree for all your changes in `./.claude/worktrees/`.
2. If feasible (and it won't impact the main worktree), symlink or reuse the dependency directory from the main worktree to avoid reinstalling.
3. Make your changes and commit them in the separate worktree.
4. In the separate worktree, rebase your commits onto the main worktree's current `HEAD`. Resolve conflicts and run checks there.
5. Leave the separate worktree (e.g. `ExitWorktree`) and run `git cherry-pick <commits>` from the main worktree. If it succeeds, you're done.
6. If git refuses because of local changes in the main worktree:
   1. In the main worktree, run `git stash push -u -m "wt: <desc>"`.
   2. In the separate worktree, run `git stash apply --index stash@{0}` to confirm the changes reapply cleanly on top of your commits, then `git reset --hard && git clean -fd` there.
   3. If that conflicts, run `git stash pop --index` in the main worktree to put everything back, then stop and report the conflict.
   4. Otherwise, in the main worktree: cherry-pick, then run `git stash pop --index`.
7. Never resolve conflicts in the main worktree.
