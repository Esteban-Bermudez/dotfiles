---
name: git-commit
description: This team's git commit message conventions. Follows cbea.ms/git-commit with no co-author trailers, no conventional/semantic prefixes, and no ticket prefix on the subject. Use when writing a commit message or committing changes.
---

# Git commit conventions

Follow the seven rules from [cbea.ms/git-commit](https://cbea.ms/git-commit/):

1. Separate subject from body with a blank line.
2. Limit the subject line to 50 characters.
3. Capitalize the subject line.
4. Do not end the subject line with a period.
5. Use the imperative mood in the subject ("Add x", not "Added x" / "Adds x").
6. Wrap the body at 72 characters.
7. Use the body to explain **what** and **why**, not how.

Hard rules for this team:

- **No co-author trailers.** Never add `Co-Authored-By:` (Claude or anyone)
  unless the user explicitly asks.
- **No conventional / semantic prefixes.** No `feat:`, `fix:`, `chore:`, etc.
- **No ticket prefix on the subject.** Don't write `PVD-1234: ...`. The ticket
  belongs in the PR title/body, not the commit subject.
- Subject says what changes; body explains why it's needed and what problem it
  solves.

Commit with a heredoc so the body wraps correctly:

```bash
git commit -F - <<'EOF'
Add profile_url to MCP newsletter tools

The tools returned only a slug, so the model fabricated the URL.
Return a canonical profile_url so it copies an authoritative link.
EOF
```

## After committing: stop

Do **not** push or open a PR until the user explicitly asks. Summarize what
was committed and let them review first. When they ask to open a PR, use the
`open-pull-request` skill.
