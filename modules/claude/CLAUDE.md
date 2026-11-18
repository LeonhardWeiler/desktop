# Global rules

## Code

- Aim for the most result with the least code. Prefer deletion over addition.
- Make the smallest change that solves the problem.
- Keep the call hierarchy flat. No wrappers with one caller, no layers for hypothetical needs.
- Put each decision in one place, not repeated across files.
- Write code as Ken Thompson, Rob Pike or djb would: simple, minimal, obvious.
- Fix the root cause. A fault is fixed, not documented in a footnote.
- Delete dead code and unreachable branches. No commented-out code; git log holds the history.
- Check library APIs against the installed version, not from memory.

## Comments and prose

- No comments by default. A comment only carries what the code cannot, e.g. something that is weirdly done only in this project and would CONFUSE others.
- Never explain why an option was chosen. State the thing and stop.
- Keep docs, READMEs and CLAUDE.md files short and easy for humans to read and parse.

## Workflow

- Make a plan before larger changes. Ask when something is unclear.
- Ask questions with the AskUserQuestion tool, one decision per question, recommended option first; never as a text list. This also applies inside skills such as grilling.
- Never `rm -rf` a path held in a variable or glob. Leave temp dirs in /tmp or delete one literal, checked path.
- Work is tracked in GitHub issues. The skill `ship` takes one to a PR ready to merge, `auto-ship` also merges it, `review` files new ones.
- Work that can only happen later (after another feature, at a date, once a dependency exists) is an issue with the label `later` that names the condition; `ship` proposes it once the condition is met. Work that waits on something outside the repo gets `blocked`. Write such todos as issues, never as files or comments.
- A list of points handed over (a message or a Markdown file) becomes issues: check each against existing issues and the code first, a heading becomes a parent issue with its points as sub-issues, "später"/"wenn …" becomes `later` with that condition, unclear points are asked about together. Report what was already done or a duplicate, then delete the file.
- One PR per issue, body `Closes #n`, the PR template filled in, squash merge. Each change in its own git worktree; commit after each step, stage files by name, never `git commit -a`.
- Before each commit run the fast checks (typecheck, lint, unit tests) and the slow tests the change affects. CI on the PR runs the full suite; wait for it with `watch_pull_request`, not by polling.
- "mach #a #b …" (several issues): this thread organizes and writes no code. Per issue one `t3_thread_launch`, title `#n <issue title>`, `workspaceStrategy` worktree from `origin/main` with `startFromOrigin: true`, message `auto-ship #n` plus what I said about it. Issues that depend on each other start one after another. A thread that needs me or is unsure asks in its own thread and leaves its PR open. Then `t3_thread_wait` on each and report per thread: link, PR, merged or what waits on me.
- Direct pushes to main only for docs.
- Repos outside GitHub: commit on main, push at the end.
- Provide toolchains and dependencies through a `flake.nix`, not system-wide installs.

## Language

- Answer in German. Code, identifiers, commit messages, comments and repo docs in English; use German in docs only where they already are German.
- Write numbers as digits, not words.

## Answers

- Give one recommendation instead of a list of options. Be honest about weak ideas.
- Say what was tested and what was not.

## Git

- Commit subject: lowercase `area: what it does`.
- Use my git config as is (name, email, signing). Never change author or skip signing.
- Do not add "Authored by" or "Signed-off-by" lines to commit messages in school projects (files/school).

## System

- NAS: `root@nas` over Tailscale (100.65.0.90), NixOS, config in `~/files/repos/nas`.
- Server: `deploy@server` over Tailscale (100.125.41.118), NixOS, config in `~/files/school/HTL4/waentw/server-config`.
- PDF/X-4 for print (FOGRA52): `nix run ~/files/repos/pdfx -- in.pdf out.pdf <bleed_mm>` on a Typst PDF compiled with `--pdf-standard 1.6`; as flake input `git+file:///home/leo/files/repos/pdfx`. See its README.
- Anthropic Pro plan: be economical with tokens, use subagents only when needed.
