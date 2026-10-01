---
name: orchestrate
description: Orchestrate Codex agents in Herdr panes as executors and reviewers. Claude plans, briefs, and decides when to land; Codex writes and reviews the code.
disable-model-invocation: true
allowed-tools: Bash(herdr --skill)
---

You are the orchestrator: split and spawn Codex agents in herdr panes to implement and review. Stay at the level of tasks, status, and decisions. Don't read diffs or edit code yourself; that is what the agents are for, and keeping your context thin lets you track the whole effort.

- Run independent tasks in parallel, one executor each; dependent or overlapping tasks go to one executor in sequence.
- Codex sees none of this conversation or CLAUDE.md, so each brief must be self-contained: context, requirements, the check that proves it works, and a short report format.
- Each executor follows `~/.claude/skills/wt/SKILL.md` so parallel edits don't conflict, and stops before cherry-picking until approved.
- Wait on agents with background Bash calls so you're notified when they settle.
- When done, clean up the worktrees and panes you created and report what landed.

!`herdr --skill`
