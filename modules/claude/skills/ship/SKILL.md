---
name: ship
description: Take a GitHub issue (or a task, filed as an issue first) to a pull request that is ready to merge, and stop there. Use when the user says "ship", "ship #12", "next issue", "continue #12" or asks to work on an issue. Without a number it takes the next issue.
user-invocable: true
---

# Ship

Take one issue to a PR that is ready for the user to merge. Never merge.

## 1. Pick the issue

- A number given: that issue. A task given: file it as an issue first.
- Nothing given: the oldest open issue without the `blocked` or `later` label, without an
  open PR and without open sub-issues; `bug` before the rest.
  `gh issue list --state open --json number,title,labels` and
  `gh issue view <n> --json body,subIssues,closedByPullRequestsReferences`.
- An open PR that closes the issue exists: continue on its branch.
- Too big for one PR, or vague: propose sub-issues with AskUserQuestion. On yes,
  create them with `gh issue create --parent <n>` and take the first.
- State in one line which issue you take.

## 2. Work

- Learn the project from `README.md`, `CLAUDE.md` and `docs/`; take checks from
  `CLAUDE.md`, the flake and CI.
- Own git worktree off the latest `origin/main`. Commit after each step in the
  repo's style, staging files by name.
- After the first commit push and open a draft PR: title as the squashed commit
  subject, the repo's PR template filled in, `Closes #<n>`. The description
  starts with the problem in 1 to 2 sentences, not a list of changes.
- Stay within the issue. Anything else worth doing becomes a new issue, linked in
  the PR; label it `later` if it can only be done later.

## 3. Proof

Evidence you saw yourself in this session:

- Reproduce the failure, fix it, watch the same reproduction pass.
- A focused test that fails without the change, when the repo has tests for it.
- For UI and runtime behaviour, run the app and look at it.
- The fast checks and the slow tests the change touches.

Write under Verification what was checked and what was not. Without proof, ask
the user instead of calling the PR ready.

## 4. Ready

- Rebase on `origin/main` if behind, mark the PR ready, call
  `watch_pull_request` and end the turn. Fix real CI failures, push, watch again.
- Merge gate on the latest head: required checks green, branch up to date and
  mergeable, proof covers the whole diff.
- Then `unwatch_pull_request` and report: PR link, what changed, proof, and the
  decisions you made alone. The PR stays open for the user.
