#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
KONFRM Portable Safe Runner for UI/UX Pro Max
Provides local, zero-network inspiration and guidelines queries while strictly
enforcing KONFRM Canon Subordination and forbidding dangerous write/persistence flags.
"""

import sys
import os
import argparse
import subprocess
from pathlib import Path

# Path to local vendor search.py
current_dir = Path(__file__).parent.resolve()
search_script = current_dir / "vendor" / "scripts" / "search.py"

if not search_script.exists():
    print(f"[KONFRM ERROR]: Cannot locate search script at {search_script}", file=sys.stderr)
    sys.exit(1)

# Pre-validation: Explicitly detect any write/persistence flags or their abbreviations
FORBIDDEN_WRITE_PREFIXES = ("--per", "--out", "--pag", "--for", "-o")
for arg in sys.argv[1:]:
    lower_arg = arg.lower()
    for prefix in FORBIDDEN_WRITE_PREFIXES:
        if lower_arg == prefix or lower_arg.startswith(prefix + "=") or (prefix.startswith("--") and lower_arg.startswith(prefix)):
            print(f"[KONFRM GUARDRAIL ERROR]: Forbidden write/persistence option detected: '{arg}'.", file=sys.stderr)
            print("Persistence and disk mutations (--persist, --output-dir, -o, --page, --force) are strictly prohibited under KONFRM Canon.", file=sys.stderr)
            sys.exit(1)

# Strict wrapper-owned parser with allow_abbrev=False to prevent prefix expansion
parser = argparse.ArgumentParser(
    description="KONFRM UI/UX Pro Max Safe Read-Only Runner",
    allow_abbrev=False,
)
parser.add_argument("query", help="Search query")
parser.add_argument("--domain", "-d", help="Search domain")
parser.add_argument("--stack", "-s", help="Stack-specific search")
parser.add_argument("--max-results", "-n", type=int, default=None, help="Max results (1-20)")
parser.add_argument("--json", action="store_true", help="Output as JSON")
parser.add_argument("--full", action="store_true", help="Do not truncate field values")
parser.add_argument("--design-system", "-ds", action="store_true", help="Generate design system advisory")
parser.add_argument("--project-name", "-p", type=str, default=None, help="Project name")
parser.add_argument("--format", "-f", choices=["ascii", "markdown"], default=None, help="Output format")
parser.add_argument("--variance", type=int, choices=range(1, 11), default=None, help="Design variance dial (1-10)")
parser.add_argument("--motion", type=int, choices=range(1, 11), default=None, help="Motion intensity dial (1-10)")
parser.add_argument("--density", type=int, choices=range(1, 11), default=None, help="Visual density dial (1-10)")

try:
    args = parser.parse_args()
except SystemExit as e:
    sys.exit(e.code)

# Reconstruct sanitized, safe command vector. NEVER append raw sys.argv.
cmd = [sys.executable, str(search_script), args.query]
if args.domain:
    cmd.extend(["--domain", args.domain])
if args.stack:
    cmd.extend(["--stack", args.stack])
if args.max_results is not None:
    cmd.extend(["--max-results", str(args.max_results)])
if args.json:
    cmd.append("--json")
if args.full:
    cmd.append("--full")
if args.design_system:
    cmd.append("--design-system")
if args.project_name:
    cmd.extend(["--project-name", args.project_name])
if args.format:
    cmd.extend(["--format", args.format])
if args.variance is not None:
    cmd.extend(["--variance", str(args.variance)])
if args.motion is not None:
    cmd.extend(["--motion", str(args.motion)])
if args.density is not None:
    cmd.extend(["--density", str(args.density)])

# Print Canon advisory banner (unless JSON requested)
if not args.json:
    print("=" * 70)
    print("[KONFRM CANON NOTICE]: External UI/UX Pro Max Guidance is ADVISORY ONLY.")
    print("All numeric metrics, brand colors, and LTR defaults are strictly")
    print("subordinate to KONFRM DF2 v1.1 Canon and Business Invariants.")
    print("=" * 70)
    print()

result = subprocess.run(cmd)
sys.exit(result.returncode)
