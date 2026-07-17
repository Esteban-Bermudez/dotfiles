---
name: write-jira-tickets
description: This team's conventions for writing JIRA tickets — bugs and user stories — concise, with clear acceptance criteria, defaulting to the Paved project. Use when the user asks to write, draft, file, or create a JIRA ticket, bug report, or user story.
---

# Writing JIRA tickets

• Default to the "Paved" project unless otherwise noted
• Be concise — provide enough detail to remove ambiguity, but no fluff or lore
• **Bugs**: include a repro when possible. If unsure how to repro, ask before writing
• **User stories**: include a short story ("As a X, I want Y, so that Z") + a brief description
• **Both**: include clear acceptance criteria
• When in doubt, err on the side of brevity over verbosity

Draft the ticket in chat first, then create it with the Atlassian tools (see
below) — don't file silently.

## Bugs

Include a **repro** whenever possible:

- Steps to reproduce (numbered)
- Expected result vs. actual result
- Environment / context if relevant (user, account, URL, timestamp)

If you're unsure how to reproduce it, **ask before writing** — don't invent
steps.

```md
**Steps to reproduce**
1. …
2. …

**Expected**: …
**Actual**: …

**Acceptance criteria**
- [ ] …
```

## User stories

Lead with a one-line story, then a brief description:

```md
As a <role>, I want <capability>, so that <outcome>.

<Short description — the what and why.>

**Acceptance criteria**
- [ ] …
- [ ] …
```

## Both

Always include **clear acceptance criteria** — the checklist that says when the
work is done.

## Creating the ticket

Use the already-configured **Atlassian tools**:

- `atlassian_createJiraIssue` — create the ticket (Paved project, type `Bug`
  or `Story`).
- `atlassian_getVisibleJiraProjects` / `atlassian_getJiraProjectIssueTypesMetadata`
  — resolve the project key and issue-type IDs if you don't already have them.
- `atlassian_editJiraIssue` — refine after creation.
