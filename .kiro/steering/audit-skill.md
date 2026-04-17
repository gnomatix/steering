---
inclusion: manual
description: Audit a SKILL document — Claude Code SKILL.md, Cursor agent skill .mdc, Antigravity .agent/skills/<name>/SKILL.md, Kiro skill, or equivalent invocable capability with frontmatter. Runs the standard checklist plus reference-exemplar comparison plus portability/graceful-degradation audit.
---

# Audit Skill

Audit a SKILL document. SKILLs are invocable capabilities loaded on-demand when their trigger condition (description, glob, keyword) is recognized — distinct from RULEs (always-on) and WORKFLOWs (multi-step with checkpoints).

## When to Use

- Reviewing or revising a Kiro skill, Claude Code SKILL.md, Cursor `.mdc`, or Antigravity `.agent/skills/<name>/SKILL.md`
- Drafting a new skill before publishing or installing
- Auditing a third-party skill before installation

## When NOT to Use

- The document is always-on / auto-included → use `audit-rule`
- The document is a multi-step procedure with checkpoints → use `audit-workflow`
- Multiple related skills are in scope and cross-skill structure matters → use `audit-collection`

## Workflow

1. **Read the skill in full**, including frontmatter.
2. **State the skill's intent in one sentence.**
3. **Confirm document type is SKILL.** A skill with phases and checkpoints may actually be a WORKFLOW.
4. **Read at least two structurally-proven exemplars** of skills in the same vendor format.
5. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`.
6. **Run the portability and graceful-degradation audit** from `steering-audit-suite/shared/portability.md`.
7. **Frontmatter-specific checks** for the vendor format:
   - **Kiro:** `inclusion` matches actual usage pattern? (Kiro's manual-inclusion mode is the closest fit for SKILL-like behavior.) `description` actionable?
   - **Claude Code:** `name` matches dir name? `description` describes when to invoke (not internal mechanics)? `tools` (if present) lists only tools actually used?
   - **Cursor:** `description` clear? `globs` accurate? `alwaysApply` set deliberately?
   - **Antigravity:** `name` matches directory name? `description` is "descriptive enough for the LLM to recognize semantic relevance" (not vague)? Skill body has Goal / Instructions / Examples / Constraints sections?
8. **Distinguish surface fixes from intent fixes.**
9. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.

## Reference Files

- `steering-audit-suite/shared/checklist.md`
- `steering-audit-suite/shared/doc-types.md`
- `steering-audit-suite/shared/portability.md`
- `steering-audit-suite/shared/reference-exemplars.md`
- `steering-audit-suite/shared/output-format.md`

## Anti-Patterns

- Don't recommend an OSS alternative just because it exists.
- Don't propose a portability change for a skill that has a deliberate single-tool dependency.
- Don't copy structure from a manufacturer exemplar without understanding why it works there.
- Don't make stylistic preference findings.
