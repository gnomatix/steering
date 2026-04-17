# Self-Audit: Claude Code Audit Skills (First Cut)

Audit pass over `/.claude/skills/audit-{rule,skill,workflow,collection}/SKILL.md` using the suite's own 15-item checklist. Findings only — no rewrites without authorization.

## Audited Files

- `.claude/skills/audit-rule/SKILL.md`
- `.claude/skills/audit-skill/SKILL.md`
- `.claude/skills/audit-workflow/SKILL.md`
- `.claude/skills/audit-collection/SKILL.md`

## Reference Exemplars Used

- `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/claude-md-management/skills/claude-md-improver/SKILL.md` — closest genre match (audit-style skill)
- Built-in `find-skills` SKILL.md — short focused capability skill
- `~/.claude/skills/rule-audit/SKILL.md` — predecessor of this suite (for regression check)

## Findings

### [Check 1: Surface vs Behavior]

**No finding.** All four skills describe behaviors (audit, propose, identify) rather than prohibited surface markers.

### [Check 2: Example-as-Definition]

**Finding (audit-skill, audit-workflow):** The "Frontmatter-specific checks" sections in audit-skill and audit-workflow enumerate per-vendor checks (Claude Code / Cursor / Kiro / Antigravity). The list is presented as exhaustive but isn't — a future vendor would have no entry. Not a leakage in the rule's intent (the principle "check the frontmatter against vendor conventions" is stated), but the list reads as definitional. Surface fix: add a closing line "for other vendors, infer from the format-specific docs."

**No finding (audit-rule, audit-collection).**

### [Check 3: Embedded Calls-Out / Stereotypes]

**No finding.** No swipes at vendors, models, generations. The "structurally-proven" framing inherited from shared/reference-exemplars.md is used consistently.

### [Check 4: Escape Hatches Through Specificity]

**Finding (audit-rule):** The "Skip the Portability Pass" section permits skipping a substantive check based on document type. The criterion ("RULEs prescribe behavior, not tools") is objective, but in borderline cases (a RULE that mentions a specific tool inline) the auditor must judge. Not a true escape hatch — the principle is sound — but worth noting.

**Finding (audit-collection):** "Don't surface every per-document finding as a collection-level concern. Per-doc findings stay per-doc; the collection pass focuses on cross-document structure." This is a deliberate scope limit, but uses "every" without defining the threshold. An auditor could either over-surface or under-surface depending on interpretation.

### [Check 5: Resilience to Correction]

**Finding (all four):** None of the four skills address what the auditor does when the document owner pushes back on a finding. The Anti-Patterns sections cover "don't apply changes without authorization" but not "what to do if the owner disputes the finding itself." Inherits the gap from the original rule-audit. Surface fix: add a one-line note that contested findings should be quoted back with the owner's response, not silently dropped.

### [Check 6: Performative Compliance]

**No finding.** All four require an audit report as observable output (per `shared/output-format.md`).

### [Check 7: Right Action vs. Right Reason]

**Finding (all four):** The check applies to actors complying with the audited rule. The auditor itself is not held to the same standard — there's no test that the auditor's findings reflect actual engagement vs. mechanical pattern-match. Inherits the gap from the original rule-audit; documented as known limitation.

### [Check 8: Loophole-by-Omission]

**Finding (all four):** Anti-Patterns lists are enumerated. The shared `checklist.md` explicitly says "non-exhaustive" and adds an "Other Findings" section to the output format. None of the four SKILL.md files restate this caveat — a future user reading just the skill might treat the Anti-Patterns as exhaustive. Surface fix: add a one-line note pointing to `shared/checklist.md` for the full non-exhaustiveness convention.

### [Check 9: Ambiguity About Authority]

**No finding for the audited document's owner** — all four say "the document owner decides." 

**Finding for the skill itself:** Authority for changes to the audit skills (the `.claude/skills/audit-*/SKILL.md` files themselves) is not stated. If a future audit of these skills produces a finding, who can authorize the change? Implicitly the repo owner (Brett Whitty / GNOMATIX), but not documented in the skill.

### [Check 10: Hidden Dependencies]

**Finding (all four):** The "Reference Files" sections assume the auditor is operating in this repo and can read `steering-audit-suite/shared/`. If a skill is copied standalone to `~/.claude/skills/audit-rule/`, the references break. The audit-rule SKILL.md addresses this with "When in this repo / When installed standalone, the SKILL.md is the canonical reference. Inline the shared content if needed." The other three skills don't have that note. Surface fix: clone the standalone-mode note into audit-skill, audit-workflow, audit-collection.

### [Check 11: Internal Contradiction]

**No finding.** Spot-checked common terms (RULE / SKILL / WORKFLOW, surface vs behavior) — used consistently across the four skills.

### [Check 12: Unverifiable Assertion]

**No finding.** All checks the auditor performs map to observable file content.

### [Check 13: Stale References]

**No finding currently.** All referenced files exist (`shared/checklist.md`, `shared/doc-types.md`, etc.). At-risk: if the shared/ structure changes, the four skills' Reference Files lists must be kept in sync. No automation to enforce this.

### [Check 14: Triggering Conditions Undefined]

**No finding.** All four have explicit "When to Use" and "When NOT to Use" sections.

### [Check 15: Conflict Precedence Undefined]

**Finding (audit-collection):** When audit-collection delegates to audit-rule, audit-skill, or audit-workflow, and those single-doc audits produce findings, audit-collection's section on "Per-Document Findings" doesn't say how to resolve the case where a finding from one tool conflicts with the cross-doc analysis. Likely rare in practice; document the convention (per-doc findings are reported as-stated; cross-doc analysis builds on them).

## Other Findings

**Length asymmetry:** audit-collection is the longest of the four; audit-rule is the shortest. This is appropriate given the scope (collection covers more), but worth noting that audit-rule may be too thin if it's the entry point a new user reads first to understand the suite.

**Missing `tools:` declaration:** None of the four SKILL.md frontmatters declare `tools:`. The exemplar `claude-md-improver` declares `tools: Read, Glob, Grep, Bash, Edit`. The four audit skills primarily use Read, Write, Edit. Adding `tools:` would be a defensible improvement but isn't required (find-skills exemplar omits it).

**Antigravity-specific content embedded in Claude Code skill:** audit-skill, audit-workflow, audit-collection mention Antigravity-specific patterns inline (e.g., "Antigravity skill body has Goal / Instructions / Examples / Constraints sections"). This is correct — the audit skill needs to know about all vendor formats it might encounter. But a reader could mistake it for vendor-specific drift.

## Surface vs Intent Distinction

**Surface fixes (cheap):**
- Add "for other vendors, infer from the format-specific docs" closing line to frontmatter-checks enumerations
- Clone the "When installed standalone" note from audit-rule into the other three
- Add a one-line "see shared/checklist.md for non-exhaustiveness convention" note in each skill's Anti-Patterns
- Add resilience-to-correction one-liner ("Contested findings: quote back with owner's response, don't silently drop")

**Intent fixes (substantive, may require discussion):**
- The auditor-itself blind spot (Checks 5, 7) — bigger question of whether to extend the audit pattern reflexively
- Authority for changes to the audit skills themselves — needs a one-line statement

## Authorization

These four files were authored by the user (via me) in this session. Per the suite's own rules, the user can authorize fixes. Surface fixes proposed above are not yet applied — pending owner review of this audit.
