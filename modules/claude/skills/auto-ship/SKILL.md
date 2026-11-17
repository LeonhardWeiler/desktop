---
name: auto-ship
description: Like ship, but squash-merges the PR itself once the merge gate passes. Use only when the user says "auto-ship" or "auto ship".
user-invocable: true
---

# Auto-ship

Follow [ship](../ship/SKILL.md) completely. Once the PR is ready and the proof
covers the whole diff, run `gh pr merge <n> --squash --delete-branch --auto`;
GitHub merges when the required checks pass. Keep watching until it is merged
and fix real CI failures. Never use `--admin` or bypass a rule.
Report the PR link and the merge commit.

If the gate cannot pass, stop as `ship` does and leave the PR open.
