<#
.SYNOPSIS
    Audit and ingest an incoming RULE / SKILL / WORKFLOW document into this repo.

.DESCRIPTION
    Wraps the `claude` CLI to run the appropriate audit skill from
    `.claude/skills/audit-*/`, write a report to `scripts/audits/`, and (with
    approval) apply surface-level cleaning and place the cleaned bundle into
    the appropriate vendor directory.

.PARAMETER Input
    Path to the input file or directory to audit.

.PARAMETER Type
    Override document type detection. One of: RULE, SKILL, WORKFLOW.

.PARAMETER Vendor
    Override vendor target (e.g., claude-code, cursor, kiro).

.PARAMETER Yes
    Skip interactive approval; apply if audit produces no blocking findings.

.PARAMETER AuditOnly
    Run audit and write report, do not ingest.

.PARAMETER Report
    Write the audit report to a specific path (default: scripts/audits/<basename>-audit.md).

.PARAMETER Model
    Override the Claude model (default: opus).

.PARAMETER Debug
    Print the prompt before invoking claude.

.EXAMPLE
    ./scripts/ingest.ps1 path/to/contribution.md

.EXAMPLE
    ./scripts/ingest.ps1 path/to/contribution-dir/ -Yes

.EXAMPLE
    ./scripts/ingest.ps1 -AuditOnly path/to/contribution.md -Type SKILL

.NOTES
    Requires `claude` CLI on PATH. Bash variant available at scripts/ingest.sh.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Input file or directory path")]
    [string]$InputPath,

    [ValidateSet('RULE', 'SKILL', 'WORKFLOW', 'rule', 'skill', 'workflow')]
    [string]$Type,

    [string]$Vendor,

    [switch]$Yes,

    [switch]$AuditOnly,

    [string]$Report,

    [string]$Model = 'opus',

    [switch]$DebugPrompt
)

$ErrorActionPreference = 'Stop'

# --- preflight ------------------------------------------------------------

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$AuditsDir = Join-Path $RepoRoot 'scripts/audits'

if (-not (Test-Path -LiteralPath $InputPath)) {
    Write-Error "Input not found: $InputPath"
    exit 1
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Error "'claude' CLI not found on PATH. Install Claude Code from https://docs.claude.com/en/docs/claude-code"
    exit 1
}

if (-not (Test-Path -LiteralPath $AuditsDir)) {
    New-Item -ItemType Directory -Path $AuditsDir -Force | Out-Null
}

# Resolve absolute input path
$InputAbs = (Resolve-Path -LiteralPath $InputPath).Path

# Compute report path if not specified
if (-not $Report) {
    $basename = [System.IO.Path]::GetFileNameWithoutExtension($InputAbs)
    $clean = ($basename -replace '[^A-Za-z0-9.\-]', '_')
    $Report = Join-Path $AuditsDir "$clean-audit.md"
}

# Detect input kind
if (Test-Path -LiteralPath $InputAbs -PathType Container) {
    $InputKind = 'directory'
} elseif (Test-Path -LiteralPath $InputAbs -PathType Leaf) {
    $InputKind = 'file'
} else {
    Write-Error "Input is neither a file nor a directory: $InputAbs"
    exit 1
}

Write-Host "==> Input: $InputAbs ($InputKind)"
Write-Host "==> Repo:  $RepoRoot"
Write-Host "==> Report: $Report"

# --- compose audit prompt -------------------------------------------------

$SkillHint = ''
if ($InputKind -eq 'directory') {
    $SkillHint = 'Use the audit-collection skill (it will dispatch to audit-rule, audit-skill, or audit-workflow per file).'
} elseif ($Type) {
    switch ($Type.ToUpper()) {
        'RULE'     { $SkillHint = 'Use the audit-rule skill.' }
        'SKILL'    { $SkillHint = 'Use the audit-skill skill.' }
        'WORKFLOW' { $SkillHint = 'Use the audit-workflow skill.' }
    }
} else {
    $SkillHint = 'Identify the document type (RULE / SKILL / WORKFLOW) per the discriminators in steering-audit-suite/shared/doc-types.md, then use the matching audit skill (audit-rule, audit-skill, or audit-workflow).'
}

$VendorHint = ''
if ($Vendor) {
    $VendorHint = "Target vendor for ingestion: $Vendor. After cleaning, place the result in the vendor's expected location in this repo."
} else {
    $VendorHint = "Identify the vendor format from the document's frontmatter and conventions. If multi-vendor, propose all applicable target locations."
}

$AuditPrompt = @"
You are running in the gnomatix/skills repo at $RepoRoot.

Task: audit an incoming contribution.

Input path: $InputAbs
Input kind: $InputKind

$SkillHint

$VendorHint

Steps:
1. Read the input. For a directory, enumerate every .md file plus any associated
   artifacts (README, scripts, templates).
2. Identify the document type and vendor for each file.
3. Run the appropriate audit skill(s) from .claude/skills/audit-*/.
4. Read the shared content at steering-audit-suite/shared/ for the checklist,
   doc types, refactoring operations, portability dimensions, and output format.
5. Produce a single consolidated audit report. Write it to: $Report
   Follow the format in steering-audit-suite/shared/output-format.md.
6. The report MUST include:
   - Stated intent of each input document
   - Document type classification with justification
   - Reference exemplar comparison
   - Findings by checklist item (mark 'no finding' explicitly per check)
   - Refactoring proposals (for directory inputs)
   - Portability findings (for SKILL or tool-prescribing WORKFLOW inputs)
   - Surface vs intent fix distinction
   - Proposed target location(s) in this repo for ingestion
   - List of associated artifacts that should accompany the contribution
7. Do not modify the input. Do not write outside the repo. Do not apply
   any cleaning yet — this is the audit phase only.

When the report is written, print exactly: REPORT_WRITTEN: $Report
"@

if ($DebugPrompt) {
    Write-Host '===== AUDIT PROMPT ====='
    Write-Host $AuditPrompt
    Write-Host '========================'
}

# --- run audit ------------------------------------------------------------

Write-Host "==> Running audit (model: $Model)..."
Write-Host ''

$claudeArgs = @('--model', $Model, '-p', $AuditPrompt)
& claude @claudeArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Audit invocation failed (exit code $LASTEXITCODE)"
    exit 1
}

if (-not (Test-Path -LiteralPath $Report)) {
    Write-Error "Audit did not produce a report at $Report"
    exit 1
}

Write-Host ''
Write-Host "==> Audit report written: $Report"

if ($AuditOnly) {
    Write-Host '==> -AuditOnly set, exiting.'
    exit 0
}

# --- show report and prompt for approval ---------------------------------

Write-Host ''
Write-Host '===== AUDIT REPORT ====='
Get-Content -LiteralPath $Report
Write-Host '========================'
Write-Host ''

if (-not $Yes) {
    $ans = Read-Host 'Apply surface-level cleaning and ingest the contribution? [y/N]'
    if ($ans -notmatch '^[Yy]$') {
        Write-Host "==> Aborted. Audit report retained at: $Report"
        exit 0
    }
}

# --- ingest ---------------------------------------------------------------

$IngestPrompt = @"
You are running in the gnomatix/skills repo at $RepoRoot.

Task: apply surface-level cleaning and ingest the contribution per the audit
report at $Report.

Input path: $InputAbs
Audit report: $Report

Steps:
1. Read the audit report.
2. Apply the surface fixes the report identified (frontmatter normalization,
   wording fixes flagged as unambiguous, formatting consistency).
3. DO NOT apply intent fixes — those require owner approval per the audit.
4. Place the cleaned document(s) in the target location(s) the report
   identified. For multi-vendor contributions, clone to each applicable
   vendor directory.
5. Bring associated artifacts (README, templates, scripts) into the same
   target location.
6. Do not delete the input — leave the original in place.
7. After ingesting, append a section to the audit report noting:
   - Files written
   - Surface fixes applied
   - Intent fixes deferred (with the exact text)
   - Anything skipped and why

When done, print exactly: INGEST_COMPLETE
"@

if ($DebugPrompt) {
    Write-Host '===== INGEST PROMPT ====='
    Write-Host $IngestPrompt
    Write-Host '========================='
}

Write-Host '==> Ingesting...'
Write-Host ''

$claudeArgs = @('--model', $Model, '-p', $IngestPrompt)
& claude @claudeArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Ingest invocation failed (exit code $LASTEXITCODE). Audit report retained at: $Report"
    exit 1
}

Write-Host ''
Write-Host "==> Ingest complete. Audit report at: $Report"
Write-Host "==> Review the changes with: git -C $RepoRoot status"
