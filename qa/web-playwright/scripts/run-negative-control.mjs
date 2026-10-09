#!/usr/bin/env node

/**
 * KONFRM Quality Evidence Mesh — Stage B Negative Control Runner
 *
 * Verifies that the Playwright test harness cannot pass vacuously.
 * Demonstrates:
 * 1. Corrupted expectation triggers deterministic assertion failure (exit code != 0).
 * 2. Corrupted failure diagnostic specifically identifies the deliberate locator mismatch
 *    and rejects crashes/environment failures as false passes.
 * 3. Cured expectation passes cleanly (exit code == 0).
 * 4. Network isolation negative suite executes and proves fail-closed route policies.
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
console.log('[1/3] Injecting corrupted expectation (TAMPERED_NEGATIVE_TEST=CORRUPTED)...');
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

// Fail-closed verification: ensure the failure was an actual assertion mismatch, NOT a crash/env failure
const hasTestFile = corruptedOutput.includes('tampered-expectation.spec.ts');
const hasCorruptedLocator = corruptedOutput.includes('DELIBERATE_CORRUPTED_HEADING_NONEXISTENT');
const hasAssertionMismatch = corruptedOutput.includes('toBeVisible') || corruptedOutput.includes('Timed out');

// Reject crash/missing executable as a false pass
const hasFatalCrash =
  corruptedOutput.includes('browserType.launch:') ||
  corruptedOutput.includes("Executable doesn't exist") ||
  corruptedOutput.includes('Cannot find module') ||
  corruptedOutput.includes('SyntaxError');

if (hasFatalCrash) {
  console.error('❌ [FATAL] Runner failed due to browser or environment crash, not controlled assertion failure:');
  console.error(corruptedOutput);
  process.exit(1);
}

if (!hasTestFile || !hasCorruptedLocator || !hasAssertionMismatch) {
  console.error('❌ [FATAL] Corrupted expectation failed, but diagnostic did not report the expected assertion mismatch:');
  console.error(`- Has test file: ${hasTestFile}`);
  console.error(`- Has corrupted locator: ${hasCorruptedLocator}`);
  console.error(`- Has assertion mismatch: ${hasAssertionMismatch}`);
  console.error(corruptedOutput);
  process.exit(1);
}

console.log('✓ [PASS] Corrupted expectation caught by test runner with verified assertion diagnostic (exit code: ' + corruptedRun.status + ')');

// 2. Run Cured Expectation (Must Pass)
console.log('\n[2/3] Running cured expectation (TAMPERED_NEGATIVE_TEST=CURED)...');
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

const curedOutput = (curedRun.stdout || '') + (curedRun.stderr || '');
if (!curedOutput.includes('1 passed')) {
  console.error('❌ [FATAL] Cured run exited with 0 but did not report 1 passed:');
  console.error(curedOutput);
  process.exit(1);
}

console.log('✓ [PASS] Cured expectation passed cleanly (exit code: 0, 1 passed)');

// 3. Run Network Isolation Negative Proofs (7 Scenarios)
console.log('\n[3/3] Running network isolation negative verification suite (7 negative proofs)...');
const netRun = spawnSync(
  'npx',
  ['playwright', 'test', 'tests/negative/network-isolation.spec.ts', '--project=Mobile-390x844-Default'],
  {
    cwd: QA_ROOT,
    encoding: 'utf-8',
    shell: true,
  }
);

if (netRun.status !== 0) {
  console.error('❌ [FATAL] Network isolation verification suite failed (exit code: ' + netRun.status + '):');
  console.error(netRun.stdout);
  console.error(netRun.stderr);
  process.exit(1);
}

const netOutput = (netRun.stdout || '') + (netRun.stderr || '');
if (!netOutput.includes('7 passed')) {
  console.error('❌ [FATAL] Network isolation suite did not report 7 passed:');
  console.error(netOutput);
  process.exit(1);
}

console.log('✓ [PASS] Network isolation suite passed cleanly (7/7 negative proofs passed)');

console.log('\n====================================================');
console.log('NEGATIVE CONTROL VERIFICATION: ALL PROOFS PASSED.');
console.log('Playwright test runner is active, sensitive, and non-vacuous.');
console.log('====================================================');
process.exit(0);
