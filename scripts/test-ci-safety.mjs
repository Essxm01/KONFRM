#!/usr/bin/env node

/**
 * ==============================================================================
 * KONFRM Quality Evidence Mesh — CI Safety Test Harness (Stage A)
 * ==============================================================================
 *
 * Verifies that:
 * 1. Tracked GitHub Actions workflows pass `actionlint` syntax and expression validation.
 * 2. Tracked GitHub Actions workflows pass `zizmor` static security audits under `.zizmor.yml`.
 * 3. `actionlint` fails closed when an intentionally malformed workflow is scanned (Negative Test 1).
 * 4. `zizmor` fails closed when an intentionally insecure workflow is scanned (Negative Test 2).
 *
 * Requirements:
 * - Read-only analysis; zero secret exposure; zero production mutations.
 * ==============================================================================
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, '..');
const WORKFLOWS_DIR = path.join(REPO_ROOT, '.github', 'workflows');
const ZIZMOR_CONFIG = path.join(REPO_ROOT, '.zizmor.yml');

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
const results = [];

function recordResult(testName, passed, details) {
  results.push({ testName, passed, details });
  const status = passed ? '✓ [PASS]' : '✗ [FAIL]';
  console.log(`${status}: ${testName}`);
  if (details && !passed) {
    console.log(`  Details: ${details}`);
  }
}

// -----------------------------------------------------------------------------
// Test 1: Actionlint on Tracked Workflows
// -----------------------------------------------------------------------------
console.log('\n[1/4] Running actionlint syntax & expression validation on tracked workflows...');
const alRun = spawnSync(actionlintBin, ['-color'], {
  cwd: REPO_ROOT,
  encoding: 'utf-8',
});

if (alRun.status === 0) {
  recordResult('Actionlint tracked workflow validation', true, '0 syntax/expression errors');
} else {
  allPassed = false;
  recordResult('Actionlint tracked workflow validation', false, alRun.stdout + alRun.stderr);
}

// -----------------------------------------------------------------------------
// Test 2: Zizmor on Tracked Workflows
// -----------------------------------------------------------------------------
console.log('\n[2/4] Running zizmor static security audit on tracked workflows...');
const zmRun = spawnSync(
  zizmorBin,
  ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', '.github/workflows'],
  {
    cwd: REPO_ROOT,
    encoding: 'utf-8',
  }
);

if (zmRun.status === 0) {
  recordResult('Zizmor tracked workflow security audit', true, 'Clean audit under .zizmor.yml baseline');
} else {
  allPassed = false;
  recordResult('Zizmor tracked workflow security audit', false, zmRun.stdout + zmRun.stderr);
}

// -----------------------------------------------------------------------------
// Test 3: Controlled Negative Test for Actionlint (Verify the Verifier)
// -----------------------------------------------------------------------------
console.log('\n[3/4] Running controlled negative test for actionlint...');
const badActionlintFixture = path.join(WORKFLOWS_DIR, '.test-invalid-actionlint-temp.yml');
const malformedYaml = `name: Malformed Negative Test Workflow
on:
  push:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "\${{ unclosed_expression"
`;

try {
  fs.writeFileSync(badActionlintFixture, malformedYaml);
  const alNegRun = spawnSync(actionlintBin, [badActionlintFixture], {
    cwd: REPO_ROOT,
    encoding: 'utf-8',
  });

  if (alNegRun.status !== 0 && (alNegRun.stdout.includes('unclosed_expression') || alNegRun.stdout.includes('expression'))) {
    recordResult('Actionlint negative test (malformed expression rejected)', true, `Detected expected error: exit code ${alNegRun.status}`);
  } else {
    allPassed = false;
    recordResult('Actionlint negative test (malformed expression rejected)', false, 'Actionlint failed to reject malformed syntax');
  }
} finally {
  if (fs.existsSync(badActionlintFixture)) {
    fs.unlinkSync(badActionlintFixture);
  }
}

// -----------------------------------------------------------------------------
// Test 4: Controlled Negative Test for Zizmor (Verify the Verifier)
// -----------------------------------------------------------------------------
console.log('\n[4/4] Running controlled negative test for zizmor...');
const badZizmorFixture = path.join(WORKFLOWS_DIR, 'test-insecure-zizmor-temp.yml');
const insecureYaml = `name: Insecure Negative Test Workflow
on:
  pull_request_target:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: \${{ github.event.pull_request.head.sha }}
      - run: echo "untrusted"
`;

try {
  fs.writeFileSync(badZizmorFixture, insecureYaml);
  const zmNegRun = spawnSync(
    zizmorBin,
    ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', '.github/workflows'],
    {
      cwd: REPO_ROOT,
      encoding: 'utf-8',
    }
  );

  if (zmNegRun.status !== 0) {
    recordResult('Zizmor negative test (unexempted security violations detected)', true, `Detected security vulnerabilities: exit code ${zmNegRun.status}`);
  } else {
    allPassed = false;
    recordResult('Zizmor negative test (unexempted security violations detected)', false, 'Zizmor failed to reject insecure workflow');
  }
} finally {
  if (fs.existsSync(badZizmorFixture)) {
    fs.unlinkSync(badZizmorFixture);
  }
}

// -----------------------------------------------------------------------------
// Final Verdict
// -----------------------------------------------------------------------------
console.log('\n====================================================');
if (allPassed) {
  console.log('ALL CI SAFETY & VERIFICATION TESTS PASSED (4/4).');
  console.log('====================================================');
  process.exit(0);
} else {
  console.error('ONE OR MORE CI SAFETY TESTS FAILED.');
  console.log('====================================================');
  process.exit(1);
}
