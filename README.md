!["Who let the Gorilla drive?!?"](assets/images/steering-audit-logo.gif "Oh Gemini!")

# GNOMATIX Skills

Working repo for stashing global SKILL / RULE / WORKFLOW files, etc. before they go into npm-packages, etc.

## What This Repo Is

A staging ground for agent-instruction artifacts (skills, rules, workflows) that the GNOMATIX research org maintains for the global research community. Contributions land here, get audited and cleaned by the **steering audit suite**, then are promoted to distribution channels (npm-packages, vendor marketplaces, etc.).

## Document Types

These follow Google Antigravity, Kiro IDE, and Cursor conventions:

- **RULE** — Behavioral prescription, always-loaded into the agent's context. Examples: `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.agent/rules/*.md`, Cursor `.cursorrules`, Cursor `.cursor/rules/*.mdc`, Kiro `.kiro/steering/*.md`.
- **SKILL** — Invocable capability with frontmatter, loaded on-demand when its trigger condition matches. Examples: Claude Code `~/.claude/skills/*/SKILL.md`, Cursor agent skills `.mdc`, Kiro skills, Antigravity `.agent/skills/<name>/SKILL.md`.
- **WORKFLOW** — Multi-step procedure or runbook with phases and checkpoints. Examples: SOPs, Kiro spec documents, Antigravity `.agent/workflows/<name>.md`.

See `steering-audit-suite/shared/doc-types.md` for the full discriminators.

## Ingress Linter: The Steering Audit Suite

Every contribution to this repo passes through the **steering audit suite** at `steering-audit-suite/` — a multi-vendor toolkit for auditing the prescriptive documents that govern AI agent behavior. The suite catches the failure modes that let a compliant-looking actor violate a rule's intent: behavior-vs-surface confusion, embedded biases, escape hatches, performative compliance, and others.

The suite ships four audit skills:

1. **audit-rule** — for behavioral RULE documents (CLAUDE.md, AGENTS.md, GEMINI.md, steering files, system prompts)
2. **audit-skill** — for invocable SKILL documents (with frontmatter and trigger conditions); includes portability + graceful-degradation audit
3. **audit-workflow** — for multi-step WORKFLOW documents; includes phase-boundary checks
4. **audit-collection** — for a body of related documents; includes cross-document refactoring proposals (split / join / merge / clone / reformat)

Each audit produces a report following a standard format. The audit does not modify documents — it surfaces findings and proposes fixes for the document owner to approve.

### Self-Demonstrating

This repo demonstrates its own conventions: the audit suite is installed as project-local skills/rules in each vendor's expected location.

- **Claude Code:** `.claude/skills/audit-{rule,skill,workflow,collection}/SKILL.md`
- **Cursor:** `.cursor/rules/audit-{rule,skill,workflow,collection}.mdc`
- **Kiro IDE:** `.kiro/steering/audit-{rule,skill,workflow,collection}.md`
- **Google Antigravity:** `.agent/skills/audit-{rule,skill,workflow,collection}/SKILL.md`
- **Cross-vendor entry points:** `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `.cursorrules` at repo root

Open this repo in any supported tool and the audit skills are immediately available.

## Ingestion Script

`scripts/ingest.sh` (bash) and `scripts/ingest.ps1` (PowerShell) wrap the Claude Code CLI to automate the audit-and-ingest workflow:

```bash
./scripts/ingest.sh path/to/contribution.md
./scripts/ingest.sh path/to/contribution-dir/
./scripts/ingest.sh --audit-only path/to/contribution.md
./scripts/ingest.sh --yes path/to/contribution-dir/   # apply without interactive approval
```

```powershell
./scripts/ingest.ps1 path/to/contribution.md
./scripts/ingest.ps1 -AuditOnly path/to/contribution.md
./scripts/ingest.ps1 -Yes path/to/contribution-dir/
```

Both scripts:

1. Identify the document type for each `.md` in the input
2. Run the appropriate audit skill from this repo
3. Write an audit report to `scripts/audits/<basename>-audit.md`
4. Show the report and prompt for approval (unless `--yes` / `-Yes`)
5. On approval, apply surface-level cleaning per audit findings
6. Identify associated artifacts (READMEs, scripts, templates) and include them
7. Move the cleaned bundle into the appropriate vendor directory and `steering-audit-suite/` structure

See `scripts/README.md` for full documentation.

## Repo Layout

```
/                                    # repo root
├── README.md                        # this file
├── CLAUDE.md                        # Claude Code project memory
├── AGENTS.md                        # cross-vendor agent instructions (Codex, Cody, etc.)
├── GEMINI.md                        # Gemini CLI / Antigravity instructions (plain markdown)
├── .cursorrules                     # Cursor legacy single-file rule
├── .claude/
│   └── skills/
│       ├── audit-rule/SKILL.md
│       ├── audit-skill/SKILL.md
│       ├── audit-workflow/SKILL.md
│       └── audit-collection/SKILL.md
├── .cursor/
│   ├── README.md
│   └── rules/
│       ├── audit-rule.mdc
│       ├── audit-skill.mdc
│       ├── audit-workflow.mdc
│       └── audit-collection.mdc
├── .kiro/
│   ├── README.md
│   └── steering/
│       ├── audit-rule.md
│       ├── audit-skill.md
│       ├── audit-workflow.md
│       └── audit-collection.md
├── .agent/                          # Antigravity
│   ├── rules/README.md
│   ├── workflows/README.md
│   └── skills/
│       ├── audit-rule/SKILL.md
│       ├── audit-skill/SKILL.md
│       ├── audit-workflow/SKILL.md
│       └── audit-collection/SKILL.md
├── scripts/
│   ├── README.md
│   ├── ingest.sh                    # ingestion script (bash)
│   ├── ingest.ps1                   # ingestion script (PowerShell)
│   └── audits/                      # generated audit reports land here
├── steering-audit-suite/            # canonical design + shared content
│   ├── README.md
│   ├── shared/
│   │   ├── doc-types.md
│   │   ├── checklist.md
│   │   ├── refactoring.md
│   │   ├── portability.md
│   │   ├── reference-exemplars.md
│   │   └── output-format.md
│   └── design-notes/
│       └── antigravity-format.md    # researched format notes
└── (incoming contributions land in vendor-appropriate locations after ingestion)
```

## Status

**First cut.** All four vendor variants drafted (Claude Code, Cursor, Kiro, Antigravity). Ingestion script available in bash and PowerShell. Ingestion script is functional but unproven against real contributions. Self-audit pending against the Claude Code variants — see `steering-audit-suite/design-notes/` when complete.

## Authorship and License

GNOMATIX is a public-serving research organization. This project is provided for use by other like-minded organizations and individuals.

![GNOMATIX "TEAM"](assets/images/gnomatix-killbots-activate-xs.png)
![GNOMATIX LOGO](assets/images/gnomatix-new-xs.png "GNOMATIX")

---

> **ALL YOUR SKILLS ARE BELONG TO US.**
>
> **...MAKE YOUR TIME!**
