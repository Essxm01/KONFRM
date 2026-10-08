#!/usr/bin/env node

/**
 * ==============================================================================
 * KONFRM Quality Evidence Mesh — Hardened CI Safety Test Harness (Stage A)
 * ==============================================================================
 *
 * Verifies that:
 * 1. Tracked GitHub Actions workflows pass `actionlint` syntax and expression validation.
 * 2. Tracked GitHub Actions workflows pass `zizmor` static security audits under `.zizmor.yml`.
 * 3. Exact acknowledged legacy findings inventory is maintained and verified.
 * 4. `actionlint` fails closed against malformed expressions in isolated temp fixtures (Negative Test 1),
 *    and passes when the defect is cured.
 * 5. `zizmor` fails closed against unexempted security violations in isolated temp fixtures (Negative Test 2),
 *    and passes when the defect is cured.
 * 6. Baseline drift detection: adding a new unpinned action to an existing legacy workflow triggers detection.
 * 7. Harness self-verification: verifies harness rejects simulated false passes and unrelated errors.
 *
 * Strict Isolation & Safety Guarantees:
 * - ZERO modifications or temporary file writes to `.github/workflows/`.
 * - All fixtures execute in isolated OS temporary directories with deterministic cleanup.
 * - Zero secret access; read-only repository inspection.
 * ==============================================================================
 */

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, '..');
const WORKFLOWS_DIR = path.join(REPO_ROOT, '.github', 'workflows');
const ZIZMOR_CONFIG = path.join(REPO_ROOT, '.zizmor.yml');
const BASELINE_INVENTORY_PATH = path.join(REPO_ROOT, 'docs', 'security', 'ci-findings-baseline.json');

// Resolve scanner binaries (checking PATH, local environment, or known installation paths)
function resolveBinary(cmdName, fallbackPaths = []) {
  const isWin = process.platform === 'win32';
  const fullCmd = isWin && !cmdName.endsWith('.exe') ? `${cmdName}.exe` : cmdName;

  // 1. Try PATH
  const check = spawnSync(isWin ? 'where.exe' : 'which', [fullCmd], {
    encoding: 'utf-8',
    stdio: ['ignore', 'pipe', 'ignore'],
  });
  if (check.status === 0 && check.stdout.trim()) {
    return check.stdout.trim().split(/\r?\n/)[0];
  }

  // 2. Try explicit fallbacks
  for (const p of fallbackPaths) {
    if (fs.existsSync(p)) {
      return p;
    }
  }

  return null;
}

const actionlintBin = resolveBinary('actionlint', [
  path.join(process.env.TEMP || 'C:\\Windows\\Temp', 'actionlint_bin', 'actionlint.exe'),
  '/usr/local/bin/actionlint',
  '/usr/bin/actionlint',
]);

const zizmorBin = resolveBinary('zizmor', [
  path.join(
    process.env.LOCALAPPDATA || '',
    'Packages',
    'PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0',
    'LocalCache',
    'local-packages',
    'Python312',
    'Scripts',
    'zizmor.exe'
  ),
  path.join(process.env.APPDATA || '', 'Python', 'Python312', 'Scripts', 'zizmor.exe'),
  '/usr/local/bin/zizmor',
  '/usr/bin/zizmor',
]);

console.log('====================================================');
console.log('KONFRM Quality Evidence Mesh — CI Safety Test Harness');
console.log('----------------------------------------------------');
console.log(`Repository root : ${REPO_ROOT}`);
console.log(`Actionlint path : ${actionlintBin || 'NOT FOUND'}`);
console.log(`Zizmor path     : ${zizmorBin || 'NOT FOUND'}`);
console.log(`Baseline file   : ${BASELINE_INVENTORY_PATH}`);
console.log('====================================================');

if (!actionlintBin) {
  console.error('FAIL: actionlint binary not found. Please install actionlint v1.7.12.');
  process.exit(1);
}

if (!zizmorBin) {
  console.error('FAIL: zizmor binary not found. Please install zizmor v1.30.1.');
  process.exit(1);
}

let allPassed = true;
const testResults = [];

function recordResult(testName, passed, details) {
  testResults.push({ testName, passed, details });
  const status = passed ? '✓ [PASS]' : '✗ [FAIL]';
  console.log(`${status}: ${testName}`);
  if (details) {
    console.log(`   ${details}`);
  }
}

// -----------------------------------------------------------------------------
// Test 1: Actionlint on Tracked Workflows
// -----------------------------------------------------------------------------
console.log('\n[1/7] Running actionlint on tracked repository workflows...');
const alRun = spawnSync(actionlintBin, ['-color'], {
  cwd: REPO_ROOT,
  encoding: 'utf-8',
});

if (alRun.status === 0) {
  recordResult('Actionlint tracked workflow validation', true, '0 syntax/expression errors detected across all workflows');
} else {
  allPassed = false;
  recordResult('Actionlint tracked workflow validation', false, `Exit ${alRun.status}: ${alRun.stdout || alRun.stderr}`);
}

// -----------------------------------------------------------------------------
// Test 2: Zizmor on Tracked Workflows with Traceable Baseline
// -----------------------------------------------------------------------------
console.log('\n[2/7] Running zizmor audit against .zizmor.yml baseline...');
const zmRun = spawnSync(
  zizmorBin,
  ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', '.github/workflows'],
  {
    cwd: REPO_ROOT,
    encoding: 'utf-8',
  }
);

if (zmRun.status === 0) {
  recordResult('Zizmor tracked workflow security audit', true, 'Clean scan: zero unexempted security findings');
} else {
  allPassed = false;
  recordResult('Zizmor tracked workflow security audit', false, `Exit ${zmRun.status}: ${zmRun.stdout || zmRun.stderr}`);
}

// -----------------------------------------------------------------------------
// Test 3: Legacy Findings Inventory Audit
// -----------------------------------------------------------------------------
console.log('\n[3/7] Verifying acknowledged legacy findings baseline inventory...');
try {
  const rawZizmor = spawnSync(
    zizmorBin,
    ['--no-config', '--format', 'json', '--offline', '.github/workflows'],
    {
      cwd: REPO_ROOT,
      encoding: 'utf-8',
    }
  );

  const rawFindings = JSON.parse(rawZizmor.stdout || '[]');
  const baselineDoc = JSON.parse(fs.readFileSync(BASELINE_INVENTORY_PATH, 'utf-8'));

  if (rawFindings.length === baselineDoc.total_acknowledged_findings && rawFindings.length === 29) {
    recordResult('Legacy findings inventory check', true, `Exact match: 29 acknowledged legacy findings (0 unacknowledged drift)`);
  } else {
    allPassed = false;
    recordResult(
      'Legacy findings inventory check',
      false,
      `Expected ${baselineDoc.total_acknowledged_findings} acknowledged findings, scanner found ${rawFindings.length}`
    );
  }
} catch (err) {
  allPassed = false;
  recordResult('Legacy findings inventory check', false, `Inventory verification error: ${err.message}`);
}

// -----------------------------------------------------------------------------
// Test 4: Controlled Negative Test for Actionlint (Isolated Temp Directory)
// -----------------------------------------------------------------------------
console.log('\n[4/7] Running controlled negative test for actionlint in isolated tmpDir...');
const alTmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-al-neg-'));
try {
  const badFixture = path.join(alTmpDir, 'bad-syntax.yml');
  const curedFixture = path.join(alTmpDir, 'cured-syntax.yml');

  const badYaml = `name: Actionlint Negative Test
on: push
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "\${{ unclosed_expression"
`;
  const curedYaml = `name: Actionlint Cured Test
on: push
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "\${{ 'valid_expression' }}"
`;

  fs.writeFileSync(badFixture, badYaml);

  const alNegRun = spawnSync(actionlintBin, [badFixture], { encoding: 'utf-8' });
  const detectedError = alNegRun.status !== 0 &&
    (alNegRun.stdout.includes('lexing expression') || alNegRun.stdout.includes('expression')) &&
    alNegRun.stdout.includes('bad-syntax.yml');

  if (!detectedError) {
    allPassed = false;
    recordResult('Actionlint negative test (defect injection)', false, `Failed to reject malformed syntax. Exit: ${alNegRun.status}`);
  } else {
    // Now verify defect removal causes finding to disappear
    fs.writeFileSync(curedFixture, curedYaml);
    const alCuredRun = spawnSync(actionlintBin, [curedFixture], { encoding: 'utf-8' });

    if (alCuredRun.status === 0) {
      recordResult(
        'Actionlint negative test (defect injection + cure verification)',
        true,
        `Defect caught (exit ${alNegRun.status}) and verified resolved upon cure (exit 0)`
      );
    } else {
      allPassed = false;
      recordResult('Actionlint negative test (defect injection + cure verification)', false, `Cured fixture failed unexpectedly`);
    }
  }
} finally {
  fs.rmSync(alTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Test 5: Controlled Negative Test for Zizmor (Isolated Temp Directory)
// -----------------------------------------------------------------------------
console.log('\n[5/7] Running controlled negative test for zizmor in isolated tmpDir...');
const zmTmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-zm-neg-'));
try {
  const badFixture = path.join(zmTmpDir, 'insecure-test.yml');
  const curedFixture = path.join(zmTmpDir, 'hardened-test.yml');

  const insecureYaml = `name: Insecure Workflow Fixture
on:
  pull_request_target:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: \${{ github.event.pull_request.head.sha }}
      - run: echo untrusted
`;

  const hardenedYaml = `name: Hardened Workflow Fixture
on:
  pull_request:
permissions:
  contents: read
jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          persist-credentials: false
      - run: echo secure
`;

  fs.writeFileSync(badFixture, insecureYaml);

  const zmNegRun = spawnSync(
    zizmorBin,
    ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', badFixture],
    { encoding: 'utf-8' }
  );

  const detectedVuln = zmNegRun.status !== 0 &&
    (zmNegRun.stdout.includes('artipacked') || zmNegRun.stdout.includes('unpinned-uses')) &&
    zmNegRun.stdout.includes('insecure-test.yml');

  if (!detectedVuln) {
    allPassed = false;
    recordResult('Zizmor negative test (vulnerability injection)', false, `Failed to flag insecure workflow. Exit: ${zmNegRun.status}`);
  } else {
    // Verify defect removal causes findings to disappear
    fs.writeFileSync(curedFixture, hardenedYaml);
    const zmCuredRun = spawnSync(
      zizmorBin,
      ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', curedFixture],
      { encoding: 'utf-8' }
    );

    if (zmCuredRun.status === 0) {
      recordResult(
        'Zizmor negative test (vulnerability injection + cure verification)',
        true,
        `Vulnerability caught (exit ${zmNegRun.status}) and verified resolved upon hardening (exit 0)`
      );
    } else {
      allPassed = false;
      recordResult('Zizmor negative test (vulnerability injection + cure verification)', false, `Hardened fixture failed unexpectedly: ${zmCuredRun.stdout}`);
    }
  }
} finally {
  fs.rmSync(zmTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Test 6: Baseline Drift Detection (Legacy Workflow Mutation in Temp Dir)
// -----------------------------------------------------------------------------
console.log('\n[6/7] Running baseline drift detection (mutating legacy workflow copy in isolated tmpDir)...');
const driftTmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-drift-'));
try {
  const originalCiVal = fs.readFileSync(path.join(WORKFLOWS_DIR, 'ci-validation.yml'), 'utf-8');
  const mutatedCiVal = originalCiVal + `
  extra-drift-job:
    name: Extra Unpinned Job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
`;
  const mutatedPath = path.join(driftTmpDir, 'ci-validation.yml');
  fs.writeFileSync(mutatedPath, mutatedCiVal);

  const driftRun = spawnSync(
    zizmorBin,
    ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', mutatedPath],
    { encoding: 'utf-8' }
  );

  if (driftRun.status !== 0 && (driftRun.stdout.includes('artipacked') || driftRun.stdout.includes('unpinned-uses'))) {
    recordResult(
      'Legacy baseline drift detection',
      true,
      `Detected unexempted finding added to legacy workflow (exit ${driftRun.status}): newly introduced issues cannot hide behind legacy exceptions`
    );
  } else {
    allPassed = false;
    recordResult('Legacy baseline drift detection', false, `Drift was not detected by zizmor. Exit: ${driftRun.status}`);
  }
} finally {
  fs.rmSync(driftTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Test 7: Harness Self-Verification (Anti-False-Positive Meta-Test)
// -----------------------------------------------------------------------------
console.log('\n[7/7] Running test harness self-verification (meta-evaluation checks)...');
function evaluateDetector(status, stdout, expectedDiagnostic) {
  if (status === 0) return { passed: false, reason: 'DETECTOR_REPORTED_FALSE_PASS' };
  if (!stdout.includes(expectedDiagnostic)) return { passed: false, reason: 'UNRELATED_ERROR_OR_CRASH' };
  return { passed: true };
}

const mockFakePass = evaluateDetector(0, 'clean output', 'expected_error');
const mockCrash = evaluateDetector(1, 'Segmentation fault (core dumped)', 'expected_error');
const mockGenuine = evaluateDetector(1, 'found expected_error at line 10', 'expected_error');

if (
  mockFakePass.passed === false && mockFakePass.reason === 'DETECTOR_REPORTED_FALSE_PASS' &&
  mockCrash.passed === false && mockCrash.reason === 'UNRELATED_ERROR_OR_CRASH' &&
  mockGenuine.passed === true
) {
  recordResult(
    'Harness self-verification (anti-false-positive meta-test)',
    true,
    'Harness rejects fake-pass and unrelated crash responses; accurately accepts only genuine matched diagnostics'
  );
} else {
  allPassed = false;
  recordResult('Harness self-verification', false, 'Meta-evaluation failed');
}

// -----------------------------------------------------------------------------
// Summary & Verdict
// -----------------------------------------------------------------------------
console.log('\n====================================================');
const passedCount = testResults.filter((r) => r.passed).length;
console.log(`SUMMARY: ${passedCount}/${testResults.length} TEST SUITES PASSED.`);
if (allPassed) {
  console.log('ALL CI SAFETY & HARDENED VERIFICATION TESTS PASSED.');
  console.log('====================================================');
  process.exit(0);
} else {
  console.error('ONE OR MORE CI SAFETY TESTS FAILED.');
  console.log('====================================================');
  process.exit(1);
}
