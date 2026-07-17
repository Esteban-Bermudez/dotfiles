---
name: open-pull-request
description: This team's pull request conventions — a simple description that leads with the ticket, and a title prefixed with the ticket key. Use when opening a PR, pushing a branch for review, or writing a PR description. Only do this after the user explicitly asks (commits stop and wait first).
---

# Pull request conventions

Keep PRs simple. Only open one after the user has asked (commits stop and wait
first — see the `git-commit` skill).

## Title

Format: `<TICKET> <subject>` — the ticket key, a space, then the commit subject
(no colon, no `feat:`/`fix:` prefix).

```
PVD-1701 Add profile_url to MCP newsletter tools
```

Derive the ticket key (e.g. `PVD-1701`) from the branch name
(`PVD-1701-...`), the conversation, or the ticket itself.

**No ticket?** Some work (lint cleanups, chores) has no Jira ticket. When
there genuinely is no ticket, omit the key entirely — the title is just the
bare commit subject (`Fix RuboCop offenses and add lint mise task`), and the
body has no bare ticket line at the top. Don't invent a key or block on one.

## Body

- **First line is the bare ticket key on its own line** (e.g. `PVD-1701`),
  unless there is no ticket — then skip it. Either way, do not add a `## What`
  heading.
- A short paragraph of what changed and why (mirror the commit body).
- A `#### Testing` section (heading 4): what you ran and the result.

Example:

```md
PVD-1701

The marketplace MCP tools returned only a newsletter's slug, so the model
fabricated the profile URL. This returns a canonical `profile_url` built
from `Site#url_path` so it copies an authoritative link instead.

#### Testing

`37 examples, 0 failures` across the three MCP service specs (run in Docker).
```

Create it with `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`.
