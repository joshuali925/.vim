---
name: commit
description: Commit changes to git using conventional commits. Use when the user asks to commit, or another skill says to commit.
---

Commit ONLY YOUR CHANGES to git, include pre-existing diffs only if user stages or specifies. Use the `--signoff` flag. Use conventional commits format with no emojis, keep the commit title simple and high level, not implementation details. Don't add unnecessary descriptions. Don't add Co-authored-by.

$ git log --oneline -n 5
!`git log --oneline -n 5`

$ git status
!`git status`
