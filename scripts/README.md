# scripts/

Automation for the gnomatix/skills repo. Wraps the Claude Code CLI to drive the audit suite over incoming contributions.

## ingest.sh / ingest.ps1

Audit and ingest an incoming RULE / SKILL / WORKFLOW document (or a directory of them) into this repo. Two equivalent variants:

- `ingest.sh` — bash, for Linux / macOS / Git Bash on Windows / WSL
- `ingest.ps1` — PowerShell, for Windows native and PowerShell Core on Linux / macOS

Both produce identical audit reports and ingestion behavior. Pick whichever matches your shell.

### Prerequisites

- `claude` CLI installed and on PATH (https://docs.claude.com/en/docs/claude-code)
- bash 4+ (for `ingest.sh`) or PowerShell 5.1+ / PowerShell Core 7+ (for `ingest.ps1`)

### Usage — Bash

```bash
# Audit one file, prompt for approval, then ingest
./scripts/ingest.sh path/to/contribution.md

# Audit a directory of related contributions (runs audit-collection)
./scripts/ingest.sh path/to/contribution-dir/

# Audit only — write the report, do not ingest
./scripts/ingest.sh --audit-only path/to/contribution.md

# Skip interactive approval (apply if no blocking findings)
./scripts/ingest.sh --yes path/to/contribution.md

# Override document type detection
./scripts/ingest.sh --type SKILL path/to/file.md

# Override target vendor
./scripts/ingest.sh --vendor cursor path/to/contribution.md

# Specify report output path
./scripts/ingest.sh --report /tmp/my-audit.md path/to/contribution.md

# Use a different model (default: opus)
./scripts/ingest.sh --model sonnet path/to/contribution.md

# Print the prompts before invocation (debugging)
./scripts/ingest.sh --debug path/to/contribution.md
```

### Usage — PowerShell

```powershell
# Audit one file, prompt for approval, then ingest
./scripts/ingest.ps1 path/to/contribution.md

# Audit a directory of related contributions
./scripts/ingest.ps1 path/to/contribution-dir/

# Audit only — write the report, do not ingest
./scripts/ingest.ps1 -AuditOnly path/to/contribution.md

# Skip interactive approval
./scripts/ingest.ps1 -Yes path/to/contribution.md

# Override document type detection
./scripts/ingest.ps1 -Type SKILL path/to/file.md

# Override target vendor
./scripts/ingest.ps1 -Vendor cursor path/to/contribution.md

# Specify report output path
./scripts/ingest.ps1 -Report C:/temp/my-audit.md path/to/contribution.md

# Use a different model (default: opus)
./scripts/ingest.ps1 -Model sonnet path/to/contribution.md

# Print the prompts before invocation (debugging)
./scripts/ingest.ps1 -DebugPrompt path/to/contribution.md
```

### Flag Mapping (bash → PowerShell)

| Bash | PowerShell |
|---|---|
| `--type` | `-Type` |
| `--vendor` | `-Vendor` |
| `--yes` / `-y` | `-Yes` |
| `--audit-only` | `-AuditOnly` |
| `--report` | `-Report` |
| `--model` | `-Model` |
| `--debug` | `-DebugPrompt` (renamed to avoid clashing with PowerShell's built-in `-Debug` parameter) |
| `--help` / `-h` | `Get-Help ./scripts/ingest.ps1` |

### What It Does

1. Validates input exists and `claude` is on PATH
2. Composes an audit prompt that points Claude at the input and the audit suite
3. Invokes `claude -p` (non-interactive) to run the audit
4. Writes the audit report to `scripts/audits/<basename>-audit.md`
5. Shows the report
6. Prompts for approval (unless `--yes` / `-Yes`)
7. On approval, invokes `claude -p` again to apply surface-level cleaning and place the cleaned bundle in the appropriate vendor directory
8. Brings associated artifacts (READMEs, templates, scripts) along with the contribution
9. Does not delete the original input
10. Does not apply substantive intent fixes — those are surfaced for owner approval

### Exit Codes

| Code | Meaning |
|---|---|
| 0 | Success (audit complete, ingest complete, or aborted by user) |
| 1 | Bad usage / missing input / missing tools / invocation failure |

### Outputs

- `scripts/audits/<basename>-audit.md` — the audit report (always)
- Files placed in vendor directories (`.claude/skills/`, `.cursor/rules/`, `.kiro/steering/`, ...) — only on approval

### What It Does NOT Do

- Does not push to git or open a PR
- Does not modify the input files
- Does not apply substantive intent changes without owner approval
- Does not bypass the audit suite — every contribution gets the audit

### Cross-Platform Notes

- Both scripts are functionally equivalent. The bash variant is preferred on Unix-like systems; the PowerShell variant on Windows native or PowerShell Core.
- For other vendors' CLIs (Cursor, Kiro, Antigravity), variants of this script could wrap their CLIs the same way. Pending design.

### Troubleshooting

**"claude: command not found" / "claude not found on PATH"** — install Claude Code per https://docs.claude.com/en/docs/claude-code and ensure it's on PATH.

**Audit report not written** — `claude -p` may have failed silently. Re-run with `--debug` (bash) or `-DebugPrompt` (PowerShell) to see the prompt and check that `claude` is producing output.

**Ingest applies wrong vendor location** — pass `--vendor <name>` (bash) or `-Vendor <name>` (PowerShell) explicitly.

**Auto-detection picked wrong document type** — pass `--type RULE|SKILL|WORKFLOW` (bash) or `-Type RULE|SKILL|WORKFLOW` (PowerShell) explicitly.

**PowerShell execution policy blocks the script** — `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` (or `Bypass` for one-off invocations: `powershell -ExecutionPolicy Bypass -File ./scripts/ingest.ps1 ...`).

## audits/

Audit reports land here. Tracked as a directory (via `.gitkeep`) but individual reports are gitignored by default. Adjust per project policy.
