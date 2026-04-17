---
name: audit-workflow
description: Audit a WORKFLOW document — Antigravity .agent/workflows/<name>.md (slash-command-triggered), Kiro spec, runbook, SOP, plan-mode document. Runs the standard audit checklist plus phase-boundary checks (are checkpoints meaningful, are approval gates correctly placed) plus portability audit (workflows often invoke specific tools). Use when reviewing or revising any document that prescribes a multi-step procedure with phases. SKIP for always-on rules (use audit-rule) or single-pass invocable skills (use audit-skill).
---

# Audit Workflow

## Goal

Audit a WORKFLOW document. WORKFLOWs are multi-step procedures with explicit phases, often with human-approval checkpoints between phases — distinct from RULEs (always-on, no procedure) and SKILLs (invocable, single-pass).

The audit catches the failure modes specific to multi-step procedures: ceremonial checkpoints, phase amnesia, hidden roll-back assumptions, mode confusion, checkpoint-as-shutdown, implicit ordering.

## Instructions

1. **Read the workflow in full.**
2. **State the workflow's intent in one sentence.**
3. **Confirm document type is WORKFLOW.** A workflow with no real checkpoints may be a SKILL (use `audit-skill`); a workflow that's mostly behavioral guidance may be a RULE (use `audit-rule`). For Antigravity workflows specifically: a `.agent/workflows/*.md` file that orchestrates other skills via persona-shifting (like the `/startcycle` example) is correctly a WORKFLOW.
4. **Map the phases.** List the distinct phases, the artifacts each produces, and the checkpoints between them.
5. **Read at least one structurally-proven exemplar** of a workflow in the same vendor format.
6. **Walk the audit checklist** (15 checks) from `steering-audit-suite/shared/checklist.md`.
7. **Phase-boundary checks** (workflow-specific):
   - Is each phase's input clearly defined?
   - Is each phase's output a concrete artifact (file, decision, report)?
   - Is each checkpoint a real decision point, or is it ceremonial?
   - Can a phase be skipped or reordered? Is that explicitly allowed or accidental?
   - Is approval requested at the right point (after the cost-of-redo becomes high, before destructive action)?
   - Are roles / authorities defined for who can approve each checkpoint?
8. **For Antigravity workflows specifically:**
   - Frontmatter has `description` field?
   - Slash-command name (filename) matches the user's expectation when typing `/<name>`?
   - If the workflow shifts between agent personas (per the `agents.md` pattern), are persona transitions explicit?
   - Are the skills it orchestrates actually present in `.agent/skills/`?
9. **Run the portability audit** from `steering-audit-suite/shared/portability.md` if the workflow invokes specific tools.
10. **Distinguish surface fixes from intent fixes.**
11. **Produce the audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.

## Workflow-Specific Failure Modes

In addition to the general checklist, watch for:

- **Ceremonial checkpoints** — approval gates that produce nothing the approver actually evaluates
- **Phase amnesia** — the workflow assumes context from earlier phases without recording it in an artifact
- **Hidden roll-back assumption** — the workflow assumes failed phases can be retried with no state cleanup
- **Mode confusion** — the workflow runs in plan mode, agent mode, or interactive mode but doesn't say which
- **Checkpoint-as-shutdown** — the workflow stops at a checkpoint and has no way to resume
- **Implicit ordering** — the order of phases matters but isn't enforced; an agent might run them concurrently or out of order
- **Orphaned skill references** (Antigravity-specific) — the workflow names a skill that doesn't exist in `.agent/skills/`

## Examples

**Input:** A `.agent/workflows/release.md` with one phase that says "build, test, and publish."

**Audit finding (Document type):** This is a single-pass action with no checkpoints. Reformat candidate — should be a SKILL (`.agent/skills/release/SKILL.md`), not a workflow. Workflows in Antigravity are for orchestrating multiple skills with persona shifts or user-approved checkpoints. A single-pass action is properly a skill.

**Input:** A workflow that says "Phase 1: write specs. Phase 2: generate code. Phase 3: deploy." with no artifact handover described.

**Audit finding (Phase amnesia):** The workflow lists phases but doesn't say where Phase 1's specs live or how Phase 2 reads them. Without artifact handover, Phase 2 will either re-derive what Phase 1 already produced or skip the dependency entirely.

## Constraints

- Don't propose collapsing a multi-phase workflow into a single-pass skill without checking why the phases exist. The checkpoints often reflect human-judgment requirements that can't be automated.
- Don't make stylistic findings about phase naming or ordering aesthetics. Audit for whether the phases produce the right artifacts and whether the checkpoints are meaningful decision points.
- Don't apply changes without explicit authorization from the workflow owner.

## Reference Files

- `steering-audit-suite/shared/checklist.md`
- `steering-audit-suite/shared/doc-types.md`
- `steering-audit-suite/shared/portability.md`
- `steering-audit-suite/shared/reference-exemplars.md`
- `steering-audit-suite/shared/output-format.md`
