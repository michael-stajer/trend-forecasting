---
name: present
description: Show Michael a rendered HTML page on whichever screen he's at, or notify him when something needs his decision. Use when the answer is better seen than described — comparisons, dashboards, drafts for review, multi-option decisions, anything with links he'll click. Use notify only when a human decision is genuinely blocked.
---

# present

The `present` CLI is on `PATH`. It reads `PRESENT_URL` and `PRESENT_TOKEN`
from the environment (already set alongside the other MCP variables). Run
`present check` first if you are unsure the server is reachable.

## Showing something

Write a self-contained HTML file, then:

    present show ./out/report.html --title "FB ads — week 32" --repo welleum-ads --open

`show` prints the URL to stdout. Without `--open` it does nothing else — that
is the "here's a link, click when you want" path. With `--open` it also opens
the tab on whichever screen Michael is at.

Use a stable `--id` for anything you regenerate on a schedule, so it replaces
in place instead of piling up:

    present show ./out/weekly.html --id welleum-ads-fbads-weekly --title "FB ads — weekly"

**Namespace stable IDs as `<repo>-<name>`** so two projects never collide on
`--id weekly`.

Pages update live. If Michael already has it open, `present update <id> <file>`
refreshes it in his browser without stealing focus.

## When to show

- A decision with more than two options, or options with several attributes each
- Anything Michael needs to click through (links, drafts, docs, ad previews)
- A status surface a routine regenerates on a schedule
- Side-by-side comparisons, tables, before/after

## When NOT to show

- Ordinary conversational replies. Text in the session is fine and faster.
- Anything under roughly a paragraph.
- Progress narration. He does not want a page to watch you work.

## Notifying

    present notify "Spring Wind PO approval blocked on you" --level high --url /p/K3f9aQ2xR7Lm

Levels:
- `low` — queued, badge only, no OS notification. Default for FYI.
- `normal` — desktop notification, no phone.
- `high` — desktop + phone push. **Someone is blocked on Michael, or something
  is broken and losing money.** Nothing else qualifies.

A `--url` starting with `/` is expanded to a full URL for you.

## When NOT to notify

- Routine completions. If nothing needs a decision, say nothing.
- Anything that can wait for the next P1 sweep. Most things can.
- Errors you can retry or work around yourself.

If you are unsure whether something is `high`, it is not.

## Artifact conventions

- Single self-contained HTML file. Inline CSS and JS. No frameworks, no build step.
- Link the shared stylesheet: `<link rel="stylesheet" href="/assets/base.css">`
- Structure a decision page as: what happened → the options → what you're asking
  him to pick. Not a prose dump with a heading on top.
- Start from `templates/decision.html` when the page is a decision.
- For a genuinely interactive dashboard (filtering, sorting, drill-down), you may
  build it with the `web-artifacts-builder` skill and pass the resulting
  `bundle.html` to `present show`. This is the exception, not the default — plain
  single-file HTML for everything else, and the bundle must be self-contained
  (no CDN fetches at view time) and under 5 MB.

## Failure behaviour

On any network failure, `show`/`update` print the error **and the absolute local
path of your HTML file** to stderr and exit non-zero. If that happens, tell
Michael the local path — never assume he saw the page.
