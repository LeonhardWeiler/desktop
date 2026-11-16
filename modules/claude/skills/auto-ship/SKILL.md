---
name: auto-ship
description: Like ship, but squash-merges the PR itself once the merge gate passes. Use only when the user says "auto-ship" or "auto ship".
user-invocable: true
---

# Auto-ship

Follow [ship](../ship/SKILL.md) completely. At the merge gate, instead of
handing off: `git fetch`, check the PR once more, then
`gh pr merge <n> --squash --delete-branch`. Never use `--admin` or bypass a rule.
Report the PR link and the merge commit.

If the gate cannot pass, stop as `ship` does and leave the PR open.
