# .cursor/

Cursor-specific agent instructions for this repo.

## Status

**First cut.** The `rules/` directory contains `.mdc` (Markdown with Configuration) files implementing the four audit skills as Cursor rules:

- `rules/audit-rule.mdc`
- `rules/audit-skill.mdc`
- `rules/audit-workflow.mdc`
- `rules/audit-collection.mdc`

These are Cursor-format adaptations of the canonical content at `../steering-audit-suite/shared/`. Parallel deployments exist for Claude Code (`../.claude/skills/`), Antigravity (`../.agent/skills/`), and Kiro (`../.kiro/steering/`).

## Cursor Rule Format Reference

Cursor rules use `.mdc` files with YAML frontmatter:

```yaml
---
description: When this rule should apply (one-line, used by Cursor's matcher)
globs:
  - "**/*.tsx"          # File globs that trigger auto-inclusion
  - "**/*.ts"
alwaysApply: false      # Always include in context vs. trigger by glob/keyword
---

Rule body content here.
```

Three modes:

- `alwaysApply: true` — always loaded into agent context (RULE)
- `alwaysApply: false` with `globs` — auto-included when matching files are touched (RULE with scope)
- `alwaysApply: false` with no globs — invoked on-demand by description matching (SKILL-like)

The four audit rules in this directory use file-glob-scoped triggering with description-matched invocation.

## Maintaining

When updating any of the audit operations:

1. The canonical content lives at `../steering-audit-suite/shared/`
2. Each vendor variant inherits the shared content; per-vendor frontmatter and format-specific notes live in the variant
3. When the shared content changes, regenerate or hand-update the relevant sections of each vendor variant
