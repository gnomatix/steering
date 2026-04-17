---
name: audit-collection
description: Audit a body of related agent documents — a `.agent/` tree, a `.kiro/` tree, a `~/.claude/skills/` directory, a `.cursor/rules/` directory, a project's `docs/agent/` collection, or any directory of RULE/SKILL/WORKFLOW files. Runs per-document audits plus the cross-document refactoring pass (split / join / merge / clone / reformat). Use when reviewing the structure of a documentation set, not just one file. For single-document audits, use audit-rule, audit-skill, or audit-workflow directly.
---

# Audit Collection

## Goal

Audit a body of related agent documents. Runs per-document audits and adds the cross-document refactoring pass — catches structural problems that don't show up when looking at one document at a time.

## Instructions

1. **Enumerate the documents in scope.** List every file that prescribes agent behavior (RULE, SKILL, WORKFLOW), with paths.
2. **Classify each document by type.** Use discriminators in `steering-audit-suite/shared/doc-types.md`. Note any document whose type doesn't match its file location/format (Reformat candidate).
3. **Per-document audit pass.** For each document, invoke the appropriate single-doc audit (audit-rule, audit-skill, or audit-workflow). Collect findings.
4. **Cross-document refactoring pass.** Apply the operations in `steering-audit-suite/shared/refactoring.md`:
   - **Split:** any document covering multiple unrelated concerns?
   - **Join:** any documents that always need to be read together?
   - **Merge:** any documents with overlapping or contradictory content?
   - **Clone:** any pattern that should also live elsewhere (e.g., promoted from project to global, or from one vendor's directory to another)?
   - **Reformat:** any document whose content is one type but its format/location declares another?
5. **Conflict and overlap analysis:**
   - Do any two documents contradict each other?
   - Do any two documents share the same trigger condition (would both invoke for the same input)?
   - Are any documents orphaned (referenced nowhere, invoked never)?
6. **Vendor-mismatch analysis** (if the collection spans vendors):
   - Are documents intended to apply across vendors duplicated correctly?
   - Are documents in vendor-specific formats but with vendor-agnostic content (clone candidates for other vendors)?
7. **Antigravity-specific structural checks:**
   - Are RULE files split between `AGENTS.md`, `GEMINI.md`, and `.agent/rules/*.md` with deliberate scope, or accidentally?
   - Do nested `AGENTS.md` files (e.g., `src/components/AGENTS.md`) make sense for their directory scope?
   - Do skill directories under `.agent/skills/` follow the standard structure (SKILL.md required, optional `scripts/` `resources/` `examples/` subdirs)?
   - Do workflows in `.agent/workflows/` reference skills that exist in `.agent/skills/`?
8. **Produce the consolidated audit report** in the format defined in `steering-audit-suite/shared/output-format.md`.

## Output Structure

```
# Collection Audit: <root path>

## Inventory
| Path | Type | Vendor | Status |
|---|---|---|---|

## Per-Document Findings
### <path>
<findings from audit-rule/skill/workflow>

## Cross-Document Findings
### Refactor: <operation>
<source, destination, reason>

### Conflicts
<list of contradictions or overlapping triggers>

### Orphans
<documents referenced nowhere or never invoked>

## Vendor Coverage
<which document patterns exist in which vendor formats; gaps>
```

## Examples

**Input:** A project with `AGENTS.md` (root) and `.agent/rules/coding-style.md` (workspace), both prescribing the same indentation convention.

**Audit finding (Merge candidate):** Indentation rule is duplicated across two files with subtle wording drift. Choose canonical home — `.agent/rules/coding-style.md` is the more specific location and likely the better long-term home; remove the duplicate from `AGENTS.md` or replace with a pointer.

**Input:** A project with skills in both `.claude/skills/` and `.agent/skills/` that have drifted apart over time.

**Audit finding (Vendor coverage drift):** Same skill exists in two vendor directories with different content. Either consolidate around one canonical version that both vendors track, or document that they are intentionally different.

## Constraints

- Don't execute split/join/merge/clone/reformat operations without explicit authorization. Propose them. The author decides.
- Don't propose vendor coverage for collections that are intentionally single-vendor.
- Don't surface every per-document finding as a collection-level concern. Per-doc findings stay per-doc; the collection pass focuses on cross-document structure.
- Don't apply changes without explicit authorization from the collection owner.

## Reference Files

- `steering-audit-suite/shared/doc-types.md`
- `steering-audit-suite/shared/checklist.md`
- `steering-audit-suite/shared/refactoring.md`
- `steering-audit-suite/shared/portability.md`
- `steering-audit-suite/shared/reference-exemplars.md`
- `steering-audit-suite/shared/output-format.md`
