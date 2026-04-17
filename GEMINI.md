# GEMINI.md — gnomatix/skills

Repo-level instructions for Google Antigravity (Gemini) when invoked in this repo. Plain Markdown per Antigravity convention — no frontmatter. Takes precedence over `AGENTS.md` for Antigravity-specific tooling.

## What This Repo Is

A staging ground for agent-instruction artifacts (RULE / SKILL / WORKFLOW documents) maintained by GNOMATIX as a public-service contribution to the global research community. Contributions pass through the audit suite at `steering-audit-suite/` before being promoted to distribution channels.

## Document Type Conventions

Per Google Antigravity, Kiro IDE, and Cursor:

- **RULE** — Always-loaded behavioral prescription. In Antigravity: `AGENTS.md`, `GEMINI.md`, or `.agent/rules/*.md`.
- **SKILL** — On-demand invocable capability with frontmatter. In Antigravity: `.agent/skills/<name>/SKILL.md`.
- **WORKFLOW** — Multi-step procedure with phases and checkpoints. In Antigravity: `.agent/workflows/<name>.md`, triggered by `/<name>`.

Definitions in `steering-audit-suite/shared/doc-types.md`.

## Audit Suite

Four audit skills installed at `.agent/skills/audit-{rule,skill,workflow,collection}/SKILL.md`. The canonical content lives in `steering-audit-suite/`. Vendor-specific deployments also exist for Claude Code (`.claude/skills/`), Cursor (`.cursor/rules/`), and Kiro (`.kiro/steering/`).

## Behavior Constraints

- Read `steering-audit-suite/shared/checklist.md` before auditing or editing any RULE/SKILL/WORKFLOW file in this repo
- Do not modify contributions without running the audit
- Do not apply substantive intent changes without owner approval
- Do not write outside this repo
- For new skills: place in `.agent/skills/<name>/SKILL.md` with `name` and `description` in YAML frontmatter, body containing Goal / Instructions / Examples / Constraints sections
- For new workflows: place in `.agent/workflows/<name>.md` with `description` in YAML frontmatter, body describing the orchestration

## Concise CLI Output

- Less than 3 lines per response unless tool use or code generation requires more
- No preambles or postambles
- Direct action or direct answer

## Investigation Before Action

- Do not rely on assumptions
- Read the audit suite's shared content before making structural changes
- When unclear, flag and ask

## Authority

Brett Whitty is the project owner. GNOMATIX is the publisher.
