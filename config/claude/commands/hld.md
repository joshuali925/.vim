---
description: Create a high-level design (HLD) markdown file with mermaid diagrams.
---

You are drafting a high-level design document. An HLD describes a system at the level of components, contracts, and flows — not line-by-line implementation — so a new engineer, a reviewer, or an adjacent team can understand what it does, how it is built, and why. Do not write the HLD yet. First interview the user until you have enough grounded material, then write it.

## Phase 1: Interview the user

Read @~/.vim/config/claude/commands/grill-me.md and follow it.

The value of an HLD comes from accuracy and from the reasoning behind the design, neither of which you can invent. If the code is available locally, offer to explore it first (entry points, routes, configs) so you arrive already grounded rather than asking the user what the code answers.

Cover, in roughly this order:

1. **System + scope** — what the system does, who uses it, which repos/packages/services are in vs. out of scope.
2. **Components + boundaries** — the major parts and where the process/network boundaries fall. Watch for conflating logical separation with physical co-location; two logical components can share one process, so say which.
3. **Key flows** — the two or three request paths worth a sequence diagram (the happy path, plus any that reveal the design's character). Get the actors and ordering right.
4. **Cross-cutting concerns** — identity/credentials, persistence, error and lifecycle handling, styling/embedding, anything that spans components.
5. **Alternatives + risks** — propose the alternatives you can infer (including "do nothing / status quo") and the main risks, then ask the user to confirm or correct rather than asking open-ended.

Ask questions one at a time. Do not proceed to Phase 2 until the user signals they're ready (e.g., "write it", "that's enough", "go ahead"). If the user hands you an existing system and says to just document it, a shorter interview is fine — but still confirm scope, the flows worth diagramming, and the design rationale before writing.

## Phase 2: Write the HLD

Output path: ask the user where to save. Default to `./hld-<kebab-title>.md`. Use `Write`. Do not add hard line breaks; there is no line length limit.

### Structure

Follow this section order — numbered sections, a scope line under the title. Include a section only when the interview produced material for it; omit empty sections entirely rather than padding with boilerplate.

```markdown
# High-Level Design: <Title>

**Scope:** <packages / services this doc covers>

## 1. Overview
<What the system does and who uses it, reader placed in the scene ("You ask…"). For a multi-system doc, a short bulleted list naming each system and its role. End by naming the one architectural fact a reader most needs up front, pointing to the section that details it.> (required)

## 2. Terminology
<Bulleted glossary. Format each as `**Term** — definition`. Only terms a reader might not know.> (include when the doc uses non-obvious terms)

## 3. Requirements
**Functional**
- <what the system must do> (required)

**Non-Functional**
- **<quality>** — <the requirement> (required)

**Out of Scope**
- <what this design deliberately does not cover> (required)

## 4. Architecture Overview
<A mermaid `flowchart` of the tiers/components and the edges between them, followed by a short bulleted walk of each tier. Keep it conceptual — no file paths, class names, ports, or endpoint strings in the diagram.> (required)

### 4.1 <The central design decision>
<Call out the one decision that defines the architecture — the routing split, the storage model, the sync boundary — as its own subsection. This is usually what a reviewer argues about.> (include when there is one)

## 5. Key Flows
<Two or three `sequenceDiagram`s for the request paths that matter, each with a one-line intro.> (required)

## 6. Cross-Cutting Concerns
<Short bolded-lead paragraphs: identity & credentials, persistence, lifecycle, styling/embedding — whatever spans components.> (include when applicable)

## 7. Alternatives Considered
<Bulleted list. Each: `**<Decision>** — chose X over Y, because <reason>.` At least two, usually including status quo.> (required)

## 8. Risks & Open Issues
<Bulleted list of known gaps, divergences, and blocked-on items. State the impact, not just the item.> (required)

## 9. Appendix — Package Reference
<Bulleted list mapping each component to its source.> (optional)
```

### Diagram rules

Every HLD needs an architecture flowchart (§4) and at least one sequence diagram (§5). Mermaid parsers are strict, and a diagram that fails to render is worse than no diagram, so author defensively:

- Keep `participant ... as <alias>` labels plain: letters, spaces, digits. No parentheses, slashes, colons, or asterisks in an alias — `User (Browser)` and `MCP / OpenSearch` break the parser. Use `User` and `MCP and OpenSearch`.
- In message text, avoid bare `/` and `*` and `()`. Write `text deltas and tool_use`, not `text deltas / tool_use`; write `TEXT_MESSAGE events`, not `TEXT_MESSAGE_*`.
- In `flowchart` node labels, put any text with punctuation inside `["..."]` quotes, and use `<br/>` for line breaks.
- Draw components at the boundary the user confirmed. A control-plane decision (which backend serves a request) belongs on the edges leaving the deciding component; the components it delegates to stay as their own nodes, not nested inside it.

### Style rules

- Direct statements, active voice, a human subject doing something. Name the specific thing rather than gesturing at it ("the routing gate lives in X", not "the implications are significant").
- Factual and structured. Tables for dense comparisons, bullets for lists, prose for reasoning. No marketing language, no emojis.
- Cut throat-clearing openers and adverbs. Vary sentence length so it does not read metronomic.
- The `**Term** — definition` em-dash in glossary and alternatives lists is a labeling convention and is fine; avoid em-dashes in ordinary prose.
- Number sections consistently — if you drop an optional section, renumber the rest and fix cross-references (`§4.1`, `§5.2`) so nothing dangles.
- Include at least two alternatives in "Alternatives Considered," one usually being status quo.
- Do not invent facts. If the interview left something unanswered, put it under "Risks & Open Issues" rather than guessing — an HLD that is confidently wrong is the worst outcome, because a reader will build on it.

### After writing

Report the file path and offer to open it. Flag anything you stated that you did not fully verify (a package name, a boundary you inferred) so the user can correct it. Do not commit or push.
