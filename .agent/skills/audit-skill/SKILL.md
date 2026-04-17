---
name: audit-skill
description: Audit a SKILL document — Antigravity .agent/skills/<name>/SKILL.md, Claude Code SKILL.md, Cursor agent skill .mdc, Kiro skill, or equivalent invocable capability with frontmatter. Runs the standard audit checklist plus reference-exemplar comparison plus portability/graceful-degradation audit (cross-platform support, OSS alternatives to proprietary services). Use when reviewing or revising any invocable skill file. SKIP for always-on rules (use audit-rule) or multi-step workflow documents (use audit-workflow).
---

# Audit Skill

## Goal

Audit a SKILL document. SKILLs are invocable capabilities loaded on-demand when their trigger condition (description, glob, keyword) is recognized — distinct from RULEs (always-on) and WORKFLOWs (multi-step with checkpoints).

The audit catches the failure modes that let a skill misfire — wrong trigger conditions, hard-coded tool dependencies that exclude users with different environments, performative compliance, missing graceful-degradation paths.

## Instructions

1. **Read the skill in full**, including frontmatter.
2. **State the skill's intent in one sentence.**
3. **Confirm document type is SKILL.** A skill with phases and checkpoints may actually be a WORKFLOW (use `audit-workflow` instead). See `steering-audit-suite/shared/doc-types.md`.
4. **Read at least two structurally-proven exemplars** of skills in the same vendor format. For Antigravity: read other skills in `.agent/skills/` plus published Antigravity skill examples (codelabs.developers.google.com). See `steering-audit-suite/shared/reference-exemplars.md`.
5. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`.
6. **Run the portability and graceful-degradation audit** from `steering-audit-suite/shared/portability.md`. Skills are the primary subject of this pass — they often prescribe specific tools.
7. **Frontmatter-specific checks** for the vendor format:
   - **Antigravity:** `name` matches directory name? `description` is "descriptive enough for the LLM to recognize semantic relevance" (not vague)? Skill body has Goal / Instructions / Examples / Constraints sections?
   - **Claude Code:** `name` matches dir name? `description` describes when to invoke (not internal mechanics)? `tools` (if present) lists only tools actually used?
   - **Cursor:** `description` clear? `globs` accurate? `alwaysApply` set deliberately?
   - **Kiro:** `inclusion` matches actual usage pattern? `description` actionable?
8. **Distinguish surface fixes from intent fixes.**
9. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.

## Examples

**Input:** A `.agent/skills/database-tools/SKILL.md` with frontmatter `description: Database tools`.

**Audit finding (Description vagueness, Antigravity-specific):** Per Antigravity skill authoring guidance, descriptions must be "descriptive enough for the LLM to recognize semantic relevance." "Database tools" is the canonical example of a vague description that underperforms. Surface fix: rewrite as e.g., "Executes read-only SQL queries against the local PostgreSQL database to retrieve user or transaction data."

**Input:** A skill that hard-codes `gh` (GitHub CLI) for issue creation.

**Audit finding (Portability):** The skill assumes GitHub. OSS / self-hosted alternatives include Gitea (`tea` CLI), Forgejo, GitLab CE (`glab`), Codeberg. Detection strategy: check for `gh`, `tea`, `glab` on PATH; pick what's available. Fallback: if none available, write the issue draft to a local file and instruct the user to file it manually.

## Constraints

- Don't recommend an OSS alternative just because it exists. Recommend it only if it would meet the skill's actual requirements; otherwise note that no equivalent exists at the required capability level.
- Don't propose a portability change for a skill that has a deliberate single-tool dependency. Surface as a question to the owner.
- Don't copy structure from a manufacturer exemplar without understanding why it works there. The exemplar is a reference, not a template to clone.
- Don't make stylistic preference findings. Audit for behavior leakage and portability gaps, not aesthetics.
- Don't apply changes without explicit authorization from the skill owner.

## Reference Files

- `steering-audit-suite/shared/checklist.md` — 15 checks
- `steering-audit-suite/shared/doc-types.md` — type discriminators
- `steering-audit-suite/shared/portability.md` — portability dimensions and tool-pair tables
- `steering-audit-suite/shared/reference-exemplars.md` — finding exemplars
- `steering-audit-suite/shared/output-format.md` — report shape
