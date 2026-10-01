#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
KONFRM Portable Safe Runner for UI/UX Pro Max
Provides local, zero-network inspiration and guidelines queries while strictly
enforcing KONFRM Canon Subordination and forbidding dangerous --persist flags.
"""

import sys
import os
import subprocess
from pathlib import Path

# Enforce Canon Subordination: Disallow --persist
if "--persist" in sys.argv:
    print("[KONFRM GUARDRAIL ERROR]: The --persist flag is strictly forbidden under KONFRM Canon.", file=sys.stderr)
    print("External design skills are not permitted to write to design-system/ or mutate tokens.", file=sys.stderr)
    sys.exit(1)

# Path to local vendor search.py
current_dir = Path(__file__).parent.resolve()
search_script = current_dir / "vendor" / "scripts" / "search.py"

if not search_script.exists():
    print(f"[KONFRM ERROR]: Cannot locate search script at {search_script}", file=sys.stderr)
    sys.exit(1)

# Print Canon advisory banner
print("=" * 70)
print("[KONFRM CANON NOTICE]: External UI/UX Pro Max Guidance is ADVISORY ONLY.")
print("All numeric metrics (44px touch, 12px font), brand colors, and LTR defaults")
print("are strictly subordinate to KONFRM DF2 v1.1 Canon.")
print("=" * 70)
print()

# Forward arguments to search.py
cmd = [sys.executable, str(search_script)] + sys.argv[1:]
result = subprocess.run(cmd)
sys.exit(result.returncode)
