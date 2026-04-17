# CLAUDE.md — gnomatix/skills Repo

This file is loaded as project memory when Claude Code is invoked in this repo.

## What This Repo Is

A staging ground for agent-instruction artifacts (RULE / SKILL / WORKFLOW files) that are audited and cleaned before being promoted to distribution channels (npm-packages, vendor marketplaces).

## Available Skills

The four audit skills are installed at `.claude/skills/`:

- **`/audit-rule`** — Audit a behavioral RULE document
- **`/audit-skill`** — Audit a SKILL document (with portability + graceful-degradation pass)
- **`/audit-workflow`** — Audit a WORKFLOW / multi-step procedure
- **`/audit-collection`** — Audit a body of related documents with cross-doc refactoring

Each skill references the shared content at `steering-audit-suite/shared/`.

## Document Type Definitions

Per Google Antigravity / Kiro IDE / Cursor conventions:

- **RULE** — Always-loaded behavioral prescription (CLAUDE.md, .cursorrules, steering files)
- **SKILL** — On-demand invocable capability with frontmatter (SKILL.md, .mdc)
- **WORKFLOW** — Multi-step procedure with phases and checkpoints (SOPs, specs, runbooks)

Discriminators in `steering-audit-suite/shared/doc-types.md`.

## Workflow for Incoming Contributions

When a user wants to contribute a new RULE/SKILL/WORKFLOW to this repo:

1. **Run the audit.** Use `./scripts/ingest.sh <path>` or invoke an audit skill directly.
2. **Read the audit report.** Surface findings to the user; do not auto-apply substantive changes.
3. **Apply surface fixes.** Wording, formatting, frontmatter normalization — only if findings are unambiguous.
4. **Surface intent fixes as questions.** Don't rewrite the contribution's substance without owner approval.
5. **Identify the right vendor directory** for the cleaned contribution. Multi-vendor contributions should be cloned into each applicable vendor location.
6. **Bring associated artifacts** — README, templates, scripts that ship with the contribution.

## Conventions

- Every contribution lands with frontmatter that matches its target vendor's format
- Every contribution has a non-trivial `description` that tells a future user when to invoke (not internal mechanics)
- Skills with tool dependencies declare them and degrade gracefully when the tool isn't available
- No swipes at other models, vendors, or generations in the rule body

## Tools and Environment

- The repo is multi-vendor — touch the appropriate vendor directories when ingesting
- The `scripts/` directory contains automation that wraps Claude Code CLI: `ingest.sh` (bash) and `ingest.ps1` (PowerShell)
- Vendor coverage: Claude Code (`.claude/skills/`), Cursor (`.cursor/rules/`), Kiro (`.kiro/steering/`), Antigravity (`.agent/skills/`) all drafted

## Anti-Patterns in This Repo

- Don't auto-merge contributions without running the audit
- Don't apply substantive cleanings without owner approval
- Don't write rules that prescribe automated event-driven behavior — those are hooks, not rules; route them to `settings.json` per the manufacturer-provided `update-config` skill

## Authority

GNOMATIX is the publisher. Brett Whitty is the project owner for this repo. Contributions are reviewed per the standard contribution flow described in `README.md`.
