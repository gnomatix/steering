# Steering Audit Suite

A multi-vendor toolkit for auditing the prescriptive documents that govern AI agent behavior: **rules**, **skills**, and **workflows**.

This is the canonical design + shared content. Vendor-specific installations live in the agent directories at the repo root (`.claude/skills/`, `.cursor/rules/`, `.kiro/steering/`, `.agent/skills/`).

## Why This Exists

Rules are only as good as the behavior they actually produce. The most common failure is that a compliant-looking actor follows the letter while violating the intent — by re-wording around prohibited tokens, satisfying examples while missing the principle, or producing acknowledgement without action.

This suite catches those failure modes. It also catches structural issues: documents in the wrong format for what they do, vendor-specific assumptions baked into supposedly portable skills, missing graceful-degradation paths between proprietary and self-hosted tools.

## Document Types

Per Google Antigravity, Kiro IDE, and Cursor conventions:

- **RULE** — Always-loaded behavioral prescription
- **SKILL** — On-demand invocable capability with frontmatter
- **WORKFLOW** — Multi-step procedure with phases and checkpoints

See `shared/doc-types.md`.

## The Four Audit Skills

1. **audit-rule** — Audit a behavioral RULE document. Runs the 15-item checklist. No portability check.
2. **audit-skill** — Audit a SKILL document. Runs the checklist plus portability + graceful-degradation plus reference-exemplar comparison.
3. **audit-workflow** — Audit a multi-step procedure. Runs the checklist plus portability plus phase-boundary checks.
4. **audit-collection** — Audit a body of related documents. Runs per-doc audits plus the cross-document refactoring pass (split / join / merge / clone / reformat).

## Suite Layout

```
steering-audit-suite/
├── README.md                    # this file
├── shared/                      # vendor-neutral content
│   ├── doc-types.md             # RULE / SKILL / WORKFLOW definitions
│   ├── checklist.md             # the 15-item audit checklist
│   ├── refactoring.md           # split / join / merge / clone / reformat
│   ├── portability.md           # cross-platform / OSS-degradation dimensions
│   ├── reference-exemplars.md   # finding exemplars per vendor
│   └── output-format.md         # standard audit report shape
└── design-notes/                # research, format notes for new vendors
```

Vendor-specific deployments at the repo root:

```
/.claude/skills/audit-{rule,skill,workflow,collection}/SKILL.md   # Claude Code
/.cursor/rules/audit-{rule,skill,workflow,collection}.mdc          # Cursor
/.kiro/steering/audit-{rule,skill,workflow,collection}.md          # Kiro IDE
/.agent/skills/audit-{rule,skill,workflow,collection}/SKILL.md     # Antigravity
```

## Vendor Coverage

| Vendor | Status |
|---|---|
| Claude Code | First cut — `.claude/skills/` |
| Cursor | First cut — `.cursor/rules/` |
| Kiro IDE | First cut — `.kiro/steering/` |
| Google Antigravity | First cut — `.agent/skills/`, format notes in `design-notes/antigravity-format.md` |
| Generic / cross-vendor | Entry points at root (`AGENTS.md`, `GEMINI.md`, `.cursorrules`, `CLAUDE.md`) |

## Why Vendor-Specific Variants

The audit checklist content is largely vendor-neutral. What differs across vendors:

- **Frontmatter shape** — Claude Code uses `name`/`description`; Cursor uses `description`/`globs`/`alwaysApply`; Kiro uses `inclusion`/`description`
- **File location** — `~/.claude/skills/` vs `.cursor/rules/` vs `.kiro/steering/`
- **Invocation semantics** — always-loaded vs trigger-on-glob vs trigger-on-keyword
- **Reference exemplars** — Anthropic's published skills vs Cursor's templates vs Kiro's built-ins
- **Format-specific failure modes** — e.g., a Cursor rule with `alwaysApply: true` and `globs: []` is a configuration error specific to Cursor

Each vendor variant inherits the shared content and adds the format-specific knowledge.

## Tool-Ecosystem Variants (Orthogonal Axis)

Some skills depend on specific tool ecosystems (GitHub vs Gitea, Slack vs Synology Chat). Those variants live with the skill itself, not in this audit suite. The portability audit (`shared/portability.md`) is what catches missing variants.

## Self-Audit

The suite is self-applicable: invoke `audit-skill` on any of the four `.claude/skills/audit-*/SKILL.md` files to audit the auditor. Findings should be captured in this directory under `design-notes/` or filed as issues. See `design-notes/self-audit.md` for the latest pass.

## Status

**First cut.** All four vendor variants drafted. Self-audit and real-world ingestion testing pending.
