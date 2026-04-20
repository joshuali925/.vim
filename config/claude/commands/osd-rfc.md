---
description: Create an OpenSearch Dashboards RFC markdown file.
---

You are drafting an RFC for OpenSearch Dashboards. Do not write the RFC yet. First interview the user until you have enough material to produce a high-quality document, then write it.

## Phase 1: Interview the user

Read @~/.vim/config/claude/commands/grill-me.md and follow it.

Minimum coverage, in roughly this order:

1. **Problem + scope** — what pain exists, who feels it, which plugins/workspaces are in vs. out of scope.
2. **Design branches** — walk the real decisions one at a time (API shape, config, UI, schema, migration, flags). This is the bulk of the interview; the rest should be quick.
3. **Alternatives + risks** — propose 2–3 alternatives yourself (including "do nothing") and the main risks; ask the user to confirm or correct rather than asking open-ended.
4. **Phases** — propose a phased plan and ask for corrections.

Ask questions one at a time. Do not proceed to Phase 2 until the user signals they're ready (e.g., "write it", "that's enough", "go ahead").

## Phase 2: Write the RFC

Output path: ask the user where to save. Default to `./rfc-<kebab-title>.md` in the current working directory. Use `Write`.

### Structure

Mirror the shape of existing OSD RFCs. Pick sections that fit the proposal — do not pad with empty boilerplate. Only **Summary**, **Motivation**, **Proposed Design**, **Scope**, **Alternatives Considered**, and **Open Questions** are required. Every other section below is optional — include it only when the interview produced material worth putting there.

```markdown
# [RFC] <Title>

## Summary
<2–4 sentences: what and why, no jargon> (required)

## Motivation
### The Problem
<concrete pain, grouped by audience if it helps: users / developers / community> (required)

### Background
<optional: existing architecture, prior attempts, context the reader needs>

## Industry Survey / Prior Art
<optional: table comparing how Grafana/Kibana/Superset/etc. handle this>

## Current Architecture
<optional: mermaid diagram or prose of how it works today>

## Proposed Design
### Architecture
<mermaid diagram or prose> (required)

### Core Concepts
<optional: data model, key terms, what things ARE and are NOT>

### Interfaces / APIs
<optional: TypeScript interfaces, config keys, CLI commands, schema — whatever applies>

### User Workflows
<optional: step-by-step: creating X, using X in Discover, etc.>

### Configuration
<optional: yaml/json config examples>

## Scope
### In Scope
- ... (required)
### Out of Scope
- ... (required)

## Migration Strategy
<optional: how existing deployments/data/plugins move to the new world; dual-write, phased cutover, etc.>

## Implementation Plan
<optional>
### Phase 1: <name>
- Bullets
- **Effort:** ~X weeks
- **Good first issues:** ...

### Phase 2: ...

## Alternatives Considered
### A. <name>
<what, pros, cons> (required — at least 2 alternatives, usually including "status quo")
### B. ...

## Risks and Mitigations
<optional>
| Risk | Mitigation |
| ---- | ---------- |
| ...  | ...        |

## Plugin / Consumer Impact
<optional: table of affected plugins and what each must change>

## Success Metrics
<optional>
- ...

## Open Questions
1. ... (required)
2. ...

## How to Contribute
<optional: table of contribution opportunities by skill level>

## References
<optional>
- [Linked issue / doc](url)
```

### Style rules

- Factual, structured, heavy use of tables and bullets. No marketing language.
- Use fenced code blocks for interfaces, config, schemas, and commands.
- Use tables for comparisons (alternatives, plugin impact, risks, migration modes).
- Label `In Scope` / `Out of Scope` explicitly.
- Include at least 2 alternatives in "Alternatives Considered," one of which is usually "status quo / do nothing."
- Include "Open Questions" — RFCs invite feedback, so leave genuine questions.
- Do not use emojis.
- Do not invent facts. If the user didn't answer something, list it under Open Questions rather than making it up.
- Omit optional sections entirely (header and body) when they'd be empty — do not leave placeholder text.

### After writing

Report the file path and offer to open it for review. Do not commit or push.
