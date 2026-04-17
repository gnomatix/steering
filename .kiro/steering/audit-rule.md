---
inclusion: manual
description: Audit a behavioral RULE document — CLAUDE.md, AGENTS.md, GEMINI.md, .cursorrules, .cursor/rules/*.mdc, .kiro/steering/*.md, system prompt, or any always-on agent rule. Catches behavior-vs-surface failures, embedded biases, escape hatches, and other ways the rule can be technically followed while violating its intent.
---

# Audit Rule

Audit a behavioral RULE document. RULEs are always-loaded (or auto-included) prescriptions of agent behavior — distinct from SKILLs (invocable on-demand) and WORKFLOWs (multi-step procedures with checkpoints).

## When to Use

- Reviewing or revising a Kiro steering file (`.kiro/steering/*.md` with `inclusion: always` or `inclusion: auto`)
- Reviewing a CLAUDE.md, AGENTS.md, GEMINI.md, .cursorrules, .cursor/rules/*.mdc
- Drafting new agent rules or organizational standards
- Diagnosing why a rule that appears clear is producing unwanted behavior
- Before adopting a rule wholesale from another project or person

## When NOT to Use

- The document is an invocable skill with a specific trigger condition → use `audit-skill`
- The document is a multi-step procedure with phases and checkpoints → use `audit-workflow` (or apply to a `.kiro/specs/` document)
- The document is one of many related documents and the cross-document structure is in scope → use `audit-collection`

## Workflow

1. **Read the rule in full.** Don't paraphrase. The exact wording is what's enforced.
2. **State the rule's intent in one sentence.**
3. **Identify the document type.** Confirm it's a RULE (not a SKILL or WORKFLOW). See `steering-audit-suite/shared/doc-types.md`.
4. **Read at least two structurally-proven exemplars** of rules in the same vendor format. See `steering-audit-suite/shared/reference-exemplars.md`.
5. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`. Mark "no finding" explicitly per check.
6. **Kiro-specific frontmatter checks:**
   - `inclusion` field present? `always` / `auto` / `manual` matches actual usage pattern?
   - `inclusion: always` for genuinely always-on content; `inclusion: auto` for conditionally-included content; `inclusion: manual` for content invoked only by name (which makes it more like a SKILL — consider whether it should be relocated)
   - `description` field present and actionable (matters more for `auto` and `manual` modes where Kiro uses it for matching)?
7. **Distinguish surface fixes from intent fixes.**
8. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.
9. **Do not rewrite without authorization.**

## Skip the Portability Pass

RULEs prescribe behavior, not tools. Skip the portability/graceful-degradation audit (that's for SKILLs and tool-prescribing WORKFLOWs).

## Reference Files

- `steering-audit-suite/shared/checklist.md`
- `steering-audit-suite/shared/doc-types.md`
- `steering-audit-suite/shared/reference-exemplars.md`
- `steering-audit-suite/shared/output-format.md`

## Anti-Patterns

- Don't audit your own session behavior into the rule.
- Don't gut the original wording in the audit output. Quote it; don't replace it.
- Don't make stylistic preference findings.
- Don't add new rules. The audit surfaces findings about the existing rule, not new rules to adopt.
