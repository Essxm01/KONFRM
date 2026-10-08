#!/usr/bin/env node

/**
 * KONFRM Quality Evidence Mesh — Stage B Negative Control Runner
 *
 * Verifies that the Playwright test harness cannot pass vacuously.
 * Demonstrates:
 * 1. Corrupted expectation triggers deterministic assertion failure (exit code != 0).
 * 2. Cured expectation passes cleanly (exit code == 0).
 */

import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const QA_ROOT = path.resolve(__dirname, '..');

console.log('====================================================');
console.log('KONFRM Stage B — Playwright Negative Control Runner');
console.log('====================================================\n');

// 1. Run Corrupted Expectation (Must Fail)
console.log('[1/2] Injecting corrupted expectation (TAMPERED_NEGATIVE_TEST=CORRUPTED)...');
const corruptedRun = spawnSync(
  'npx',
  ['playwright', 'test', 'tests/negative/tampered-expectation.spec.ts', '--project=Mobile-390x844-Default'],
  {
    cwd: QA_ROOT,
    env: { ...process.env, TAMPERED_NEGATIVE_TEST: 'CORRUPTED' },
    encoding: 'utf-8',
    shell: true,
  }
);

if (corruptedRun.status === 0) {
  console.error('❌ [FATAL] Corrupted expectation unexpectedly PASSED! Test oracle is vacuous.');
  process.exit(1);
}

const corruptedOutput = (corruptedRun.stdout || '') + (corruptedRun.stderr || '');
const hasExpectedFailureDiagnostic =
  corruptedOutput.includes('toBeVisible') ||
  corruptedOutput.includes('عنوان غير موجود نهائياً') ||
  corruptedOutput.includes('Error:');

if (!hasExpectedFailureDiagnostic) {
  console.error('❌ [FATAL] Corrupted expectation failed, but diagnostic did not identify assertion mismatch:');
  console.error(corruptedOutput);
  process.exit(1);
}

console.log('✓ [PASS] Corrupted expectation successfully caught by test runner (exit code: ' + corruptedRun.status + ')');

// 2. Run Cured Expectation (Must Pass)
console.log('\n[2/2] Running cured expectation (TAMPERED_NEGATIVE_TEST=CURED)...');
const curedRun = spawnSync(
  'npx',
  ['playwright', 'test', 'tests/negative/tampered-expectation.spec.ts', '--project=Mobile-390x844-Default'],
  {
    cwd: QA_ROOT,
    env: { ...process.env, TAMPERED_NEGATIVE_TEST: 'CURED' },
    encoding: 'utf-8',
    shell: true,
  }
);

if (curedRun.status !== 0) {
  console.error('❌ [FATAL] Cured expectation failed unexpectedly (exit code: ' + curedRun.status + '):');
  console.error(curedRun.stdout);
  console.error(curedRun.stderr);
  process.exit(1);
}

console.log('✓ [PASS] Cured expectation passed cleanly (exit code: 0)');

console.log('\n====================================================');
console.log('NEGATIVE CONTROL VERIFICATION: ALL PROOFS PASSED.');
console.log('Playwright test runner is active, sensitive, and non-vacuous.');
console.log('====================================================');
process.exit(0);
