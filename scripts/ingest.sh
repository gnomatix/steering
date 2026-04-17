#!/usr/bin/env bash
# scripts/ingest.sh
#
# Audit and ingest an incoming RULE / SKILL / WORKFLOW document (or a directory
# of them) into this repo. Wraps the `claude` CLI to run the appropriate audit
# skill from `.claude/skills/audit-*/`, write a report to `scripts/audits/`,
# and (with approval) apply surface-level cleaning and place the cleaned
# bundle into the appropriate vendor directory.
#
# Usage:
#   scripts/ingest.sh <input-file-or-dir> [options]
#
# Options:
#   --type <RULE|SKILL|WORKFLOW>   Override document type detection
#   --vendor <name>                Override vendor target (claude-code, cursor, kiro, ...)
#   --yes                          Skip interactive approval; apply if audit
#                                  produces no blocking findings
#   --audit-only                   Run audit and write report, do not ingest
#   --report <path>                Write the audit report to a specific path
#                                  (default: scripts/audits/<basename>-audit.md)
#   --model <name>                 Override the Claude model (default: opus)
#   --debug                        Print the prompt before invoking claude
#   --help                         Show this help and exit

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
AUDITS_DIR="$REPO_ROOT/scripts/audits"

INPUT=""
DOC_TYPE=""
VENDOR=""
YES=0
AUDIT_ONLY=0
REPORT_PATH=""
MODEL="opus"
DEBUG=0

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

# --- arg parsing ----------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type)        DOC_TYPE="$2"; shift 2 ;;
    --vendor)      VENDOR="$2"; shift 2 ;;
    --yes|-y)      YES=1; shift ;;
    --audit-only)  AUDIT_ONLY=1; shift ;;
    --report)      REPORT_PATH="$2"; shift 2 ;;
    --model)       MODEL="$2"; shift 2 ;;
    --debug)       DEBUG=1; shift ;;
    --help|-h)     usage 0 ;;
    --*)           echo "Unknown option: $1" >&2; usage 1 ;;
    *)
      if [[ -z "$INPUT" ]]; then
        INPUT="$1"
      else
        echo "Unexpected extra argument: $1" >&2
        usage 1
      fi
      shift
      ;;
  esac
done

# --- preflight ------------------------------------------------------------

if [[ -z "$INPUT" ]]; then
  echo "Error: input path required" >&2
  usage 1
fi

if [[ ! -e "$INPUT" ]]; then
  echo "Error: input not found: $INPUT" >&2
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: 'claude' CLI not found on PATH" >&2
  echo "Install Claude Code from https://docs.claude.com/en/docs/claude-code" >&2
  exit 1
fi

mkdir -p "$AUDITS_DIR"

# Resolve absolute input path
INPUT_ABS="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"

# Compute report path if not specified
if [[ -z "$REPORT_PATH" ]]; then
  basename_clean="$(basename "$INPUT_ABS" | tr -c '[:alnum:].-' '_' | sed 's/\.md$//')"
  REPORT_PATH="$AUDITS_DIR/${basename_clean}-audit.md"
fi

# Detect input kind
if [[ -d "$INPUT_ABS" ]]; then
  INPUT_KIND="directory"
elif [[ -f "$INPUT_ABS" ]]; then
  INPUT_KIND="file"
else
  echo "Error: input is neither a file nor a directory: $INPUT_ABS" >&2
  exit 1
fi

echo "==> Input: $INPUT_ABS ($INPUT_KIND)"
echo "==> Repo:  $REPO_ROOT"
echo "==> Report: $REPORT_PATH"

# --- compose audit prompt -------------------------------------------------

# Choose which skill(s) to run based on input kind and explicit type override.
SKILL_HINT=""
if [[ "$INPUT_KIND" == "directory" ]]; then
  SKILL_HINT="Use the audit-collection skill (it will dispatch to audit-rule, audit-skill, or audit-workflow per file)."
elif [[ -n "$DOC_TYPE" ]]; then
  case "$DOC_TYPE" in
    RULE|rule)         SKILL_HINT="Use the audit-rule skill." ;;
    SKILL|skill)       SKILL_HINT="Use the audit-skill skill." ;;
    WORKFLOW|workflow) SKILL_HINT="Use the audit-workflow skill." ;;
    *) echo "Error: unknown --type: $DOC_TYPE" >&2; exit 1 ;;
  esac
else
  SKILL_HINT="Identify the document type (RULE / SKILL / WORKFLOW) per the discriminators in steering-audit-suite/shared/doc-types.md, then use the matching audit skill (audit-rule, audit-skill, or audit-workflow)."
fi

VENDOR_HINT=""
if [[ -n "$VENDOR" ]]; then
  VENDOR_HINT="Target vendor for ingestion: $VENDOR. After cleaning, place the result in the vendor's expected location in this repo."
else
  VENDOR_HINT="Identify the vendor format from the document's frontmatter and conventions. If multi-vendor, propose all applicable target locations."
fi

AUDIT_PROMPT="You are running in the gnomatix/skills repo at $REPO_ROOT.

Task: audit an incoming contribution.

Input path: $INPUT_ABS
Input kind: $INPUT_KIND

$SKILL_HINT

$VENDOR_HINT

Steps:
1. Read the input. For a directory, enumerate every .md file plus any associated
   artifacts (README, scripts, templates).
2. Identify the document type and vendor for each file.
3. Run the appropriate audit skill(s) from .claude/skills/audit-*/.
4. Read the shared content at steering-audit-suite/shared/ for the checklist,
   doc types, refactoring operations, portability dimensions, and output format.
5. Produce a single consolidated audit report. Write it to: $REPORT_PATH
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

When the report is written, print exactly: REPORT_WRITTEN: $REPORT_PATH"

if [[ "$DEBUG" -eq 1 ]]; then
  echo "===== AUDIT PROMPT ====="
  echo "$AUDIT_PROMPT"
  echo "========================"
fi

# --- run audit ------------------------------------------------------------

echo "==> Running audit (model: $MODEL)..."
echo

# Use claude in print mode
if ! claude --model "$MODEL" -p "$AUDIT_PROMPT"; then
  echo "Error: audit invocation failed" >&2
  exit 1
fi

if [[ ! -f "$REPORT_PATH" ]]; then
  echo "Error: audit did not produce a report at $REPORT_PATH" >&2
  exit 1
fi

echo
echo "==> Audit report written: $REPORT_PATH"

if [[ "$AUDIT_ONLY" -eq 1 ]]; then
  echo "==> --audit-only set, exiting."
  exit 0
fi

# --- show report and prompt for approval ---------------------------------

echo
echo "===== AUDIT REPORT ====="
cat "$REPORT_PATH"
echo "========================"
echo

if [[ "$YES" -ne 1 ]]; then
  read -r -p "Apply surface-level cleaning and ingest the contribution? [y/N] " ans
  if [[ ! "$ans" =~ ^[Yy]$ ]]; then
    echo "==> Aborted. Audit report retained at: $REPORT_PATH"
    exit 0
  fi
fi

# --- ingest ---------------------------------------------------------------

INGEST_PROMPT="You are running in the gnomatix/skills repo at $REPO_ROOT.

Task: apply surface-level cleaning and ingest the contribution per the audit
report at $REPORT_PATH.

Input path: $INPUT_ABS
Audit report: $REPORT_PATH

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

When done, print exactly: INGEST_COMPLETE"

if [[ "$DEBUG" -eq 1 ]]; then
  echo "===== INGEST PROMPT ====="
  echo "$INGEST_PROMPT"
  echo "========================="
fi

echo "==> Ingesting..."
echo

if ! claude --model "$MODEL" -p "$INGEST_PROMPT"; then
  echo "Error: ingest invocation failed" >&2
  echo "Audit report retained at: $REPORT_PATH" >&2
  exit 1
fi

echo
echo "==> Ingest complete. Audit report at: $REPORT_PATH"
echo "==> Review the changes with: git -C $REPO_ROOT status"
