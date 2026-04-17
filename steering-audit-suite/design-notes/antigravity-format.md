# Google Antigravity Format Notes

**Status:** Researched and applied. Variants drafted at `.agent/skills/`, `.agent/rules/`, `.agent/workflows/`, and `GEMINI.md` / `AGENTS.md` at repo root.

**Sources consulted:**
- https://antigravity.google/docs/rules-workflows
- https://antigravity.google/docs/skills
- https://codelabs.developers.google.com/getting-started-with-antigravity-skills
- https://codelabs.developers.google.com/autonomous-ai-developer-pipelines-antigravity
- https://antigravity.codes/blog/user-rules

## RULE Format

Plain Markdown — **no YAML frontmatter**. The Antigravity docs explicitly state: "the file uses plain Markdown, so there is no special syntax to learn."

**Locations** (in precedence order, more specific overrides more general):

| Location | Scope |
|---|---|
| `<workspace>/src/<dir>/AGENTS.md` | Directory-specific, nested |
| `<workspace>/.agent/rules/*.md` | Workspace, multiple rule files |
| `<workspace>/GEMINI.md` | Workspace, Antigravity-specific (overrides AGENTS.md) |
| `<workspace>/AGENTS.md` | Workspace, cross-tool standard |
| `~/.gemini/GEMINI.md` | Global, Antigravity-specific |
| `~/.gemini/AGENTS.md` | Global, cross-tool standard |

When both `GEMINI.md` and `AGENTS.md` exist at the same level, `GEMINI.md` takes precedence.

## SKILL Format

Directory-based package: `<skill-name>/SKILL.md` plus optional supporting subdirectories.

**Frontmatter** (YAML):

```yaml
---
name: skill-name           # optional; defaults to directory name
description: <detailed>    # required; must be specific enough for the LLM to recognize semantic relevance
---
```

The `description` requirement is strict: vague descriptions ("Database tools") underperform. Per official guidance, descriptions must be like "Executes read-only SQL queries against the local PostgreSQL database to retrieve user or transaction data."

**Body sections** (recommended structure):
- **Goal** — clear statement of what the skill achieves
- **Instructions** — step-by-step logic
- **Examples** — few-shot input/output samples
- **Constraints** — "do not" rules and safety limits

**Directory structure:**

```
<skill-name>/
├── SKILL.md              # required
├── scripts/              # optional: Python, Bash, Node executables
├── resources/            # optional: templates, documentation
├── examples/             # optional: input/output samples
└── assets/               # optional: images, logos
```

**Locations:**

| Location | Scope |
|---|---|
| `<workspace>/.agent/skills/<name>/SKILL.md` | Workspace |
| `~/.gemini/antigravity/skills/<name>/SKILL.md` | Global |

## WORKFLOW Format

Saved prompts triggered by the user typing `/<workflow-name>` in chat.

**Frontmatter** (YAML):

```yaml
---
description: Short description of what this workflow does
---
```

**Body:** Markdown describing the orchestration — which skills to invoke in what order, with what handovers between them, what user approvals are required at which points.

**Location:** `<workspace>/.agent/workflows/<name>.md`

## Persona Pattern (`agents.md`)

The third codelab demonstrates a `agents.md` file (note: this is distinct from `AGENTS.md` — the codelab places it inside `.agents/` and uses lowercase). It defines AI personas with structured sections:

```markdown
## The [Role Name] (@handle)
You are a [description].
**Goal**: [Primary objective]
**Traits**: [Behavioral characteristics]
**Constraint**: [Strict guardrails]
```

Workflows can shift between personas defined in `agents.md` while orchestrating skills. This is an advanced pattern — not required for simple skills, but useful when an autonomous pipeline has distinct phases requiring distinct mindsets (PM, engineer, QA, devops).

The codelab uses `.agents/` (plural) for its persona-based pattern, while the official rules and skills docs use `.agent/` (singular). Both directories are referenced in different Antigravity examples; the official documented paths are singular `.agent/`.

## Applied to This Repo

Variants drafted following these conventions:

- `.agent/skills/audit-{rule,skill,workflow,collection}/SKILL.md` — four audit skills with proper frontmatter and Goal/Instructions/Examples/Constraints body
- `.agent/rules/README.md` — placeholder explaining the convention; no actual rules placed there (this repo's behavioral rules live at root in `GEMINI.md` / `AGENTS.md`)
- `.agent/workflows/README.md` — placeholder; no workflows currently needed (the four audit operations are skills, not workflows)
- `GEMINI.md` at repo root — plain Markdown, no frontmatter, takes precedence over `AGENTS.md` for Antigravity
- `AGENTS.md` at repo root — plain Markdown, no frontmatter, cross-vendor standard

## Open Questions

- Should the audit-collection operation be modeled as an Antigravity workflow (`/audit-collection-workflow`) that orchestrates the per-document audit skills with checkpoints, rather than as a single audit-collection skill? Defer until a real use case requires the workflow form.
- The `.agent/` (singular) vs `.agents/` (plural) inconsistency in Antigravity examples — verify with newer documentation when revising.
