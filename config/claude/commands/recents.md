---
description: Use this skill to see recently modified files in the project
---

# Recently Modified Files

Run this single command to list top 20 files ranked by "frecency" — a blend of filesystem edit recency and git-log recency/frequency. Actively-edited and recently-committed files (in the last 20 commits) float to the top; long-untouched files sink. Then read the top few to orient on the in-progress task.

$ git recents | head -25
!`git recents | head -25`
