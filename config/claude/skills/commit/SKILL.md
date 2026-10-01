---
name: commit
description: Commit changes to git using conventional commits. Use when the user asks to commit, or another skill says to commit.
allowed-tools: Bash(git log --oneline -n 5), Bash(git status)
---

Commit ONLY YOUR CHANGES to git, include pre-existing diffs only if user stages or specifies. Use the `--signoff` flag. Use conventional commits format with no emojis, keep the commit title and description simple and high level, skip implementation details and focus on reasoning. Don't add Co-authored-by.

$ git log --oneline -n 5
!`git log --oneline -n 5`

$ git status
!`git status`
