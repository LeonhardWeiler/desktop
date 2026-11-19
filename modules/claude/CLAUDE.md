# Global rules

## Code

- Aim for the most result with the least code. Prefer deletion over addition.
- Make the smallest change that solves the problem.
- Keep the call hierarchy flat. No wrappers with one caller, no layers for hypothetical needs.
- Put each decision in one place, not repeated across files.
- Write code as Ken Thompson, Rob Pike or djb would: simple, minimal, obvious.
- Fix the root cause. A fault is fixed, not documented in a footnote.
- Delete dead code and unreachable branches. No commented-out code; git log holds the history.
- Check library APIs against the installed version, not from memory. Find a crate's source with `ls -d ~/.cargo/registry/src/*/<crate>-*`; never `cd` into a glob.
- Every way in has a way out and a way to see it: open needs close, hide needs show. A one-way door is a bug.
- A feature is done when every way to reach it works: button, menu, shortcut, command palette, each client and platform. Name in the report which applied.
- React effects only sync with something outside React. Derive values in render, act in handlers.

## Tests

- Test what can break: logic, parsing, state, persistence, races, the code a bug fix changed. Not what types guarantee, trivial code, copy text or wiring.
- Extend an existing test or table before writing a new one.
- Test once, at the lowest layer that fails on main; not again in wrappers or callers.
- A logic bug gets a failing test first, then the fix. A purely visual bug gets before/after captures and no test.
- No sleeps, timeouts or retries in tests; wait for the event or state itself. A flaky test is fixed, not retried.

## Comments and prose

- No comments by default. A comment only carries what the code cannot, e.g. something that is weirdly done only in this project and would CONFUSE others.
- Never explain why an option was chosen. State the thing and stop.
- Keep docs, READMEs and CLAUDE.md files short and easy for humans to read and parse.
- Docs hold only what the code cannot show: decisions and their reasons, constraints across components, traps. Before adding a sentence, ask what a reader would get wrong without it; if the code answers it, leave it out. No field or method lists, no control-flow narration, no change logs.
- User docs say per feature what it does, how to start and what is unintuitive; not what the UI already shows.
- When a decision changes, rewrite or delete its text; never append the new state.

## Workflow

- Make a plan before larger changes. Ask when something is unclear.
- If a rule here fights the task, say so plainly and get my sign-off before breaking it.
- Kill only a PID you captured at spawn, or the owner of your own port. Never kill by pattern (`pkill -f`, `pgrep | kill`): parallel worktrees and agents run on this machine.
- Run dev servers from your own shell so they end with the session. Never detach them (`nohup`, `setsid`, `tmux`, `systemd-run`) unless I ask.
- Ask questions with the AskUserQuestion tool, one decision per question, recommended option first; never as a text list. This also applies inside skills such as grilling.
- Never `rm -rf` a path held in a variable or glob. Leave temp dirs in /tmp or delete one literal, checked path.
- Work is tracked in GitHub issues. The skill `ship` takes one to a PR ready to merge, `auto-ship` also merges it, `review` files new ones.
- Work that can only happen later (after another feature, at a date, once a dependency exists) is an issue with the label `later` that names the condition; `ship` proposes it once the condition is met. Work that waits on something outside the repo gets `blocked`. Write such todos as issues, never as files or comments.
- A list of points handed over (a message or a Markdown file) becomes issues: check each against existing issues and the code first, a heading becomes a parent issue with its points as sub-issues, "später"/"wenn …" becomes `later` with that condition, unclear points are asked about together. Report what was already done or a duplicate, then delete the file.
- One PR per issue, body `Closes #n`, the PR template filled in, squash merge. Each change in its own git worktree; commit after each step, stage files by name, never `git commit -a`.
- Before each commit run the fast checks (typecheck, lint, unit tests) and the slow tests the change affects. CI on the PR runs the full suite; wait for it with `watch_pull_request`, not by polling.
- Report done only when no build or task you started still runs, no branch, worktree or PR is left behind, and the docs cover the change.
- Rounds of rating, review and fixing stop after 2 rounds without a better result and report a plan for a structural change. A review round looks at the views it changed, not every screenshot. Each delegated agent works in its own worktree.
- Load a deferred tool's schema before its first call; never guess its parameters.
- "mach #a #b …" (several issues): this thread organizes and writes no code. Per issue one `t3_thread_launch`, title `#n <issue title>`, `workspaceStrategy` worktree from `origin/main` with `startFromOrigin: true`, message `auto-ship #n` plus what I said about it. Issues that depend on each other start one after another. A thread that needs me or is unsure asks in its own thread and leaves its PR open. Then `t3_thread_wait` on each and report per thread: link, PR, merged or what waits on me.
- Direct pushes to main only for docs.
- Repos outside GitHub: commit on main, push at the end.
- Provide project toolchains and dependencies through a `flake.nix`. perl, python3, node, pnpm and imagemagick are installed system-wide.

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

- Run sudo commands yourself, never hand them to me. Anything that needs a password, key, token or similar is asked for through T3 Code's secret input (`request_secret`), never in chat.
- NAS: `root@nas` over Tailscale (100.65.0.90), NixOS, config in `~/files/repos/nas`.
- Server: `deploy@server` over Tailscale (100.125.41.118), NixOS, config in `~/files/school/HTL4/waentw/server-config`.
- PDF/X-4 for print (FOGRA52): `nix run ~/files/repos/pdfx -- in.pdf out.pdf <bleed_mm>` on a Typst PDF compiled with `--pdf-standard 1.6`; as flake input `git+file:///home/leo/files/repos/pdfx`. See its README.
- Anthropic Pro plan: be economical with tokens, use subagents only when needed.
