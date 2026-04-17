---
inclusion: manual
description: Audit a WORKFLOW document — Kiro spec, runbook, SOP, Antigravity workflow, plan-mode document. Runs the standard checklist plus phase-boundary checks plus portability audit.
---

# Audit Workflow

Audit a WORKFLOW document. WORKFLOWs are multi-step procedures with explicit phases, often with human-approval checkpoints between phases — distinct from RULEs (always-on, no procedure) and SKILLs (invocable, single-pass).

## When to Use

- Reviewing or revising a Kiro spec document (`.kiro/specs/<feature>/`)
- Reviewing a runbook, SOP, or operational procedure
- Reviewing an Antigravity workflow definition
- Reviewing a plan-mode document with explicit phases
- Drafting a new workflow before adopting it as procedure

## When NOT to Use

- The document is always-on / auto-included → use `audit-rule`
- The document is invocable in one pass with no checkpoints → use `audit-skill`
- Multiple related workflows are in scope and cross-doc structure matters → use `audit-collection`

## Workflow

1. **Read the workflow in full.** For a Kiro spec, this includes `synopsis.md`, `requirements.md`, `design.md` (or `design/*.md`), `tasks.md`, `WORKING-STATE.md`.
2. **State the workflow's intent in one sentence.**
3. **Confirm document type is WORKFLOW.**
4. **Map the phases.** List the distinct phases, the artifacts each produces, and the checkpoints between them.
5. **Read at least one structurally-proven exemplar** of a workflow in the same vendor format. For Kiro specs: read another well-formed spec in the same project, or the Kiro documentation's spec template.
6. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`.
7. **Phase-boundary checks** (workflow-specific):
   - Is each phase's input clearly defined?
   - Is each phase's output a concrete artifact (file, decision, report)?
   - Is each checkpoint a real decision point, or is it ceremonial?
   - Can a phase be skipped or reordered? Is that explicitly allowed or accidental?
   - Is approval requested at the right point (after the cost-of-redo becomes high, before destructive action)?
   - Are roles / authorities defined for who can approve each checkpoint?
8. **Kiro spec-specific checks:**
   - Are `synopsis.md`, `requirements.md`, `design.md`, `tasks.md` all present and consistent?
   - Does `WORKING-STATE.md` reflect actual current status?
   - Are tasks traceable to requirements? Are requirements traceable to synopsis?
9. **Run the portability audit** from `steering-audit-suite/shared/portability.md` if the workflow invokes specific tools.
10. **Distinguish surface fixes from intent fixes.**
11. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.

## Workflow-Specific Failure Modes

- **Ceremonial checkpoints** — approval gates that produce nothing the approver actually evaluates
- **Phase amnesia** — the workflow assumes context from earlier phases without recording it in an artifact
- **Hidden roll-back assumption** — the workflow assumes failed phases can be retried with no state cleanup
- **Mode confusion** — the workflow runs in plan mode, agent mode, or interactive mode but doesn't say which
- **Checkpoint-as-shutdown** — the workflow stops at a checkpoint and has no way to resume
- **Implicit ordering** — the order of phases matters but isn't enforced

## Reference Files

- `steering-audit-suite/shared/checklist.md`
- `steering-audit-suite/shared/doc-types.md`
- `steering-audit-suite/shared/portability.md`
- `steering-audit-suite/shared/reference-exemplars.md`
- `steering-audit-suite/shared/output-format.md`

## Anti-Patterns

- Don't propose collapsing a multi-phase workflow into a single-pass skill without checking why the phases exist.
- Don't make stylistic findings about phase naming or ordering aesthetics.
