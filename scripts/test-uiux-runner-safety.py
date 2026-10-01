#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
KONFRM UI/UX Pro Max Safe Runner Security & Safety Test Suite
Executes behavioral negative tests against bypass attempts and verifies read-only integrity.
"""

import sys
import os
import subprocess
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
RUNNER_SCRIPT = REPO_ROOT / "docs" / "ai" / "skills" / "ui-ux-pro-max-wrapper" / "runner.py"

if not RUNNER_SCRIPT.exists():
    print(f"[TEST ERROR]: Runner script missing at {RUNNER_SCRIPT}", file=sys.stderr)
    sys.exit(1)

print("=" * 70)
print("KONFRM UI/UX Pro Max Runner Security & Safety Tests")
print("=" * 70)

failures = 0

# Negative test vectors (all must exit non-zero and create zero files/directories)
NEGATIVE_VECTORS = [
    ["test query", "--persist"],
    ["test query", "--per"],
    ["test query", "--pers"],
    ["test query", "--output-dir", "temp_out"],
    ["test query", "--out", "temp_out"],
    ["test query", "-o", "temp_out"],
    ["test query", "--page", "dashboard"],
    ["test query", "--pag", "dashboard"],
    ["test query", "--force"],
    ["test query", "--for"],
    ["test query", "--design-system", "--per", "-o", "temp_out"],
    ["test query", "-ds", "--out=test_dir"],
    ["test query", "--persist=true"],
    ["test query", "--output-dir=./test"],
    ["test query", "-o=./test"],
]

for idx, vector in enumerate(NEGATIVE_VECTORS, 1):
    with tempfile.TemporaryDirectory() as tmpdir:
        cmd = [sys.executable, str(RUNNER_SCRIPT)] + vector
        result = subprocess.run(cmd, cwd=tmpdir, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # Check 1: Must exit non-zero
        if result.returncode == 0:
            print(f"❌ FAIL: Vector {idx} {vector} exited with code 0 (expected non-zero failure)")
            failures += 1
            continue

        # Check 2: Must create zero files or directories in temp dir
        created_items = list(Path(tmpdir).iterdir())
        if created_items:
            print(f"❌ FAIL: Vector {idx} created files/dirs in temp dir: {created_items}")
            failures += 1
            continue

        # Check 3: Must not create design-system/ in repo root or cwd
        if (REPO_ROOT / "design-system").exists():
            print(f"❌ FAIL: Vector {idx} created design-system/ in repository root!")
            failures += 1
            continue

        print(f"✓ PASS: Vector {idx} blocked correctly: {' '.join(vector[1:])}")

# Positive test vectors: Verify legitimate read-only options succeed without disk side-effects
POSITIVE_VECTORS = [
    ("normal domain query", ["contrast", "--domain", "ux", "--max-results", "1"]),
    ("--json flag", ["contrast", "--domain", "ux", "--json", "--max-results", "1"]),
    ("--full flag", ["contrast", "--domain", "ux", "--full", "--max-results", "1"]),
    ("--stack option", ["button", "--stack", "react", "--max-results", "1"]),
    ("--max-results option", ["button", "--domain", "style", "--max-results", "2"]),
    ("--design-system without persistence", ["fintech", "--design-system"]),
    ("--project-name option", ["fintech", "--design-system", "--project-name", "KONFRM_SAMPLE"]),
    ("--format markdown option", ["fintech", "--design-system", "--format", "markdown"]),
    ("--variance dial", ["fintech", "--design-system", "--variance", "5"]),
    ("--motion dial", ["fintech", "--design-system", "--motion", "3"]),
    ("--density dial", ["fintech", "--design-system", "--density", "8"]),
    ("combined dials and format", ["booking", "--design-system", "-p", "KONFRM", "--format", "markdown", "--variance", "3", "--motion", "2", "--density", "9"]),
]

print("\nVerifying legitimate read-only queries (positive tests)...")
for desc, vector in POSITIVE_VECTORS:
    with tempfile.TemporaryDirectory() as tmpdir:
        cmd = [sys.executable, str(RUNNER_SCRIPT)] + vector
        res = subprocess.run(cmd, cwd=tmpdir, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        created_items = list(Path(tmpdir).iterdir())

        if res.returncode != 0:
            print(f"❌ FAIL: Positive test '{desc}' failed with exit code {res.returncode}:\n{res.stderr}")
            failures += 1
            continue

        if created_items:
            print(f"❌ FAIL: Positive test '{desc}' created unexpected files: {created_items}")
            failures += 1
            continue

        if (REPO_ROOT / "design-system").exists():
            print(f"❌ FAIL: Positive test '{desc}' created design-system/ in repository root!")
            failures += 1
            continue

        if "--json" not in vector and "[KONFRM CANON NOTICE]" not in res.stdout:
            print(f"❌ FAIL: Positive test '{desc}' missing advisory banner from stdout")
            failures += 1
            continue

        print(f"✓ PASS: Legitimate query '{desc}' succeeded safely (0 writes).")

print("=" * 70)
if failures > 0:
    print(f"FAILED: {failures} test(s) failed.")
    sys.exit(1)
else:
    print("ALL RUNNER SAFETY TESTS PASSED (0 writes, 0 bypasses).")
    print("=" * 70)
    sys.exit(0)
