# .agent/workflows/

Antigravity-specific workflow definitions for this repo. Triggered by the user typing `/<workflow-name>` in the agent chat.

## Format

Markdown with YAML frontmatter:

```markdown
---
description: Short description of what this workflow does
---

# Workflow body — orchestration instructions
```

## Convention

- One workflow per file
- Filename = slash-command name (e.g., `release.md` becomes `/release`)
- Body describes the orchestration sequence: which skills to invoke, in what order, with what handovers
- Skills referenced should exist in `../skills/<name>/SKILL.md`

## Status

Empty for this repo by default. The audit suite's four operations are skills (single-pass), not workflows. If the audit-collection skill is composed with the per-document audits as a multi-phase workflow with checkpoints, that orchestration could live here as `/audit-collection-workflow.md` — pending design.
