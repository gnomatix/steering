---
name: audit-rule
description: Audit a behavioral RULE document — AGENTS.md, GEMINI.md, .agent/rules/*.md, CLAUDE.md, .cursorrules, .cursor/rules/*.mdc, .kiro/steering/*.md, system prompt, or any always-on agent rule. Catches behavior-vs-surface failures, embedded biases, escape hatches, and other ways the rule can be technically followed while violating its intent. Use when reviewing or revising any document that prescribes always-on or auto-included agent behavior. SKIP for invocable skill files (use audit-skill) or multi-step workflow documents (use audit-workflow).
---

# Audit Rule

## Goal

Audit a behavioral RULE document. RULEs are always-loaded (or auto-included) prescriptions of agent behavior — distinct from SKILLs (invocable on-demand) and WORKFLOWs (multi-step procedures with checkpoints).

The audit catches the failure modes that let a compliant-looking actor violate the rule's intent: behavior-vs-surface confusion, embedded biases, escape hatches, performative compliance, and others. The audit produces a report with findings; the audit does not modify the rule.

## Instructions

1. **Read the rule in full.** Don't paraphrase. The exact wording is what's enforced.
2. **State the rule's intent in one sentence.** If you can't, the rule has a clarity problem before any of the other checks apply.
3. **Identify the document type.** Confirm it's a RULE (not a SKILL or WORKFLOW). See `steering-audit-suite/shared/doc-types.md` for discriminators.
4. **Read at least two structurally-proven exemplars** of rules in the same vendor format. See `steering-audit-suite/shared/reference-exemplars.md`.
5. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`. For each, note specific evidence — line references, exact phrases. Mark "no finding" explicitly for each check applied.
6. **For Antigravity-specific rules** (`AGENTS.md`, `GEMINI.md`, `.agent/rules/*.md`), additional checks:
   - Plain Markdown, no YAML frontmatter (Antigravity convention)
   - When both `GEMINI.md` and `AGENTS.md` exist, `GEMINI.md` takes precedence — does the project intend that, and is the override scope deliberate?
   - Multiple files in `.agent/rules/` — is the file split deliberate, and do they conflict?
   - Nested rule files (e.g., `src/components/AGENTS.md`) — do they correctly scope to their directory?
7. **Distinguish surface fixes from intent fixes.** Some findings are wording issues; some indicate the rule's intent is unclear or contested.
8. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.
9. **Do not rewrite without authorization.** Present findings; let the author decide.

## Skip the Portability Pass

RULEs prescribe behavior, not tools. Skip the portability/graceful-degradation audit (that's for SKILLs and tool-prescribing WORKFLOWs).

## Examples

**Input:** A `.agent/rules/coding-style.md` that says "Always use 2-space indentation. Never use tabs. Don't say 'utilize' when you mean 'use'."

**Audit finding (Surface vs Behavior):** "Don't say 'utilize' when you mean 'use'" prohibits a specific token. The underlying intent appears to be "prefer simple direct vocabulary." A compliant agent could substitute "leverage" or "employ" and still violate the spirit. Behavioral form: "Use the simplest accurate verb. Avoid corporate-speak synonyms when a plain verb fits."

**Input:** A `GEMINI.md` with YAML frontmatter and a `tags` field.

**Audit finding (Format):** Antigravity convention is plain Markdown for `GEMINI.md` and `AGENTS.md`, no frontmatter. The frontmatter will not be processed and adds noise. Surface fix: remove the frontmatter and integrate any meaningful metadata into the prose.

## Constraints

- Don't audit your own session behavior into the rule. If the rule applies to you and you've been violating it, the audit isn't the place to confess.
- Don't gut the original wording in the audit output. Quote it; don't replace it.
- Don't make stylistic preference findings. Audit for behavior leakage, not aesthetics.
- Don't add new rules. The audit surfaces findings about the existing rule, not new rules to adopt.
- Don't apply changes without explicit authorization from the rule owner.

## Reference Files

- `steering-audit-suite/shared/checklist.md` — the 15 checks
- `steering-audit-suite/shared/doc-types.md` — RULE vs SKILL vs WORKFLOW
- `steering-audit-suite/shared/reference-exemplars.md` — finding exemplars per vendor
- `steering-audit-suite/shared/output-format.md` — report shape
