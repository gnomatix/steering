# .agent/rules/

Antigravity-specific behavioral rules for this repo. Loaded by the Antigravity agent when working in this workspace.

## Format

Plain Markdown — no YAML frontmatter (per Antigravity convention).

## Convention

- One concern per file. Multiple files for unrelated concerns.
- File name reflects the rule's scope or topic (e.g., `coding-style.md`, `security.md`, `git-conventions.md`).
- Nested `AGENTS.md` files in subdirectories scope to that directory.

## Precedence

When `GEMINI.md` and `AGENTS.md` both exist, `GEMINI.md` takes precedence (Antigravity-specific override).

`.agent/rules/*.md` are workspace-scoped and apply alongside `AGENTS.md` / `GEMINI.md`.

## Status

Empty for this repo by default. Project-specific rules can be added here. The repo's behavioral conventions live in `../../GEMINI.md` and `../../AGENTS.md` at the repo root.
