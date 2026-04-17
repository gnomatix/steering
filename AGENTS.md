# AGENTS.md — gnomatix/skills

Cross-vendor agent instructions following the emerging AGENTS.md convention used by OpenAI Codex, Sourcegraph Cody, and other tools that look for a vendor-neutral entry point.

## What This Repo Is

A staging ground for agent-instruction artifacts — RULE, SKILL, and WORKFLOW documents — maintained by GNOMATIX as a public-service contribution to the global research community. Contributions are audited and cleaned by the steering audit suite before promotion to distribution channels.

## Document Type Conventions

Per Google Antigravity, Kiro IDE, and Cursor:

- **RULE** — Always-loaded behavioral prescription
- **SKILL** — On-demand invocable capability with frontmatter
- **WORKFLOW** — Multi-step procedure with phases and checkpoints

Definitions and discriminators: `steering-audit-suite/shared/doc-types.md`.

## Audit Suite

Four audit skills are available:

- **audit-rule** — for RULE documents
- **audit-skill** — for SKILL documents (includes portability + graceful-degradation pass)
- **audit-workflow** — for WORKFLOW documents (includes phase-boundary checks)
- **audit-collection** — for a body of related documents (includes refactoring proposals)

Vendor-specific installations:

- Claude Code: `.claude/skills/audit-*/SKILL.md`
- Cursor: `.cursor/rules/audit-*.mdc` (stub — see `.cursor/README.md`)
- Kiro: `.kiro/steering/audit-*.md` (stub — see `.kiro/README.md`)
- Other vendors: see `steering-audit-suite/README.md` for the canonical content; adapt to your vendor's format

## Ingestion Script

`scripts/ingest.sh` automates the audit-and-ingest workflow for incoming contributions. See `scripts/README.md`.

## Conventions for Contributors

- Run the audit before submitting a PR
- Frontmatter must match the target vendor's format
- The `description` must tell a future user when to invoke (not internal mechanics)
- Tool dependencies must be declared and degrade gracefully when the tool isn't available
- No swipes at other models, vendors, or generations in the rule body

## Authority

GNOMATIX is the publisher. Brett Whitty is the project owner. Contributions reviewed per the contribution flow in `README.md`.
