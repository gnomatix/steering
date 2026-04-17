# .kiro/

Kiro IDE-specific agent instructions for this repo.

## Status

**First cut.** The `steering/` directory contains `.md` files implementing the four audit skills as Kiro steering rules with `inclusion: manual`:

- `steering/audit-rule.md`
- `steering/audit-skill.md`
- `steering/audit-workflow.md`
- `steering/audit-collection.md`

These are Kiro-format adaptations of the canonical content at `../steering-audit-suite/shared/`. Parallel deployments exist for Claude Code (`../.claude/skills/`), Cursor (`../.cursor/rules/`), and Antigravity (`../.agent/skills/`).

The `specs/` directory may be added later to hold WORKFLOW documents in Kiro spec format if a multi-phase workflow form of the audit operations is needed.

## Kiro Steering File Format Reference

Kiro steering files use `.md` with YAML frontmatter:

```yaml
---
inclusion: always | auto | manual
description: One-line description of what this steering does
---

Steering body content here.
```

Three modes:

- `inclusion: always` — always loaded into agent context (RULE)
- `inclusion: auto` — auto-included when relevant (RULE with conditional triggering)
- `inclusion: manual` — invoked on-demand by name (closest to SKILL)

The four audit rules in `steering/` use `inclusion: manual` because they are invoked on-demand for a specific document, not always-on.

## Kiro Spec Format Reference

Kiro specs (under `specs/<feature-name>/`) typically include:

- `synopsis.md` — owner's vision in their own words
- `requirements.md` — formal requirements derived from synopsis
- `design.md` or `design/*.md` — architecture and interface documents
- `tasks.md` — implementation task breakdown
- `WORKING-STATE.md` — standing instructions and current status

These are WORKFLOW documents in Kiro's format. The `audit-workflow` skill knows how to audit them.

## Maintaining

Same pattern as the other vendor variants — canonical content at `../steering-audit-suite/shared/`, per-vendor frontmatter and format-specific notes in each variant.
