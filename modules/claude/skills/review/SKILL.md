---
name: review
description: Fresh review of the whole project; files real findings as GitHub issues and closes issues that no longer apply. No code changes. Use when the user asks for a review, audit or health check of the project.
user-invocable: true
---

# Review

## 1. Analyze

- Learn purpose, stack and entry points from the repo, `CLAUDE.md` and `docs/`.
- Scan source, config, CI, docs and tests. Judge the current code.
- Run format, lint, test and build where that has no side effects. A broken gate
  is a finding; do not repair it.
- Look at bugs, security, performance, UX and UI consistency, accessibility,
  architecture, fragile or missing tests, docs. An outdated `CLAUDE.md` is a
  finding.
- Walk the main user flows end to end, with errors, interruptions, invalid input
  and destructive actions. Run the app if possible, otherwise trace the code.

## 2. Compare with the issues

`gh issue list --state all --limit 200 --json number,title,state,labels,body`.

- A finding an open issue already covers: update that issue if the facts
  changed, otherwise skip it.
- A finding a closed `wontfix` issue covers: skip it.
- An open issue whose problem is gone: close it with a one-line reason.

## 3. File

One issue per finding you would fix: title `area: problem`, body with what is
wrong, where (`file:line`), and the fix. Label `bug` for defects, `enhancement`
for improvements, `later` if it can only be done later, `blocked` if it waits on
something outside the repo.

Do not file nitpicks; list them in the reply only. A finding whose fix is to keep
things as they are is no issue.

## 4. Report

The reply lists the filed, updated and closed issues with links, the nitpicks,
and what could not be checked. Commit nothing.
