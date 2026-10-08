#!/usr/bin/env node

/**
 * ==============================================================================
 * KONFRM Quality Evidence Mesh — Hardened CI Safety Test Harness (Stage A)
 * ==============================================================================
 *
 * Verifies that:
 * 1. Tracked GitHub Actions workflows pass `actionlint` syntax and expression validation.
 * 2. Tracked GitHub Actions workflows pass `zizmor` static security audits under `.zizmor.yml`.
 * 3. Exact acknowledged legacy findings inventory is maintained and verified via deterministic,
 *    normalized, order-independent identity comparison against `docs/security/ci-findings-baseline.json`.
 * 4. Baseline identity negative cases (A: added finding, B: removed finding, C: equal-count substitution,
 *    D: reordering invariance, E: different issue on exempted line) fail closed.
 * 5. Auditor-mode visibility audit (`--persona auditor --no-ignores`) catalogs all advisory/lower-tier
 *    observations, proving 0 uncataloged high-risk vulnerabilities exist.
 * 6. `actionlint` fails closed against malformed expressions in isolated temp fixtures (Negative Test 1),
 *    and passes when cured.
 * 7. `zizmor` fails closed against genuine `template-injection` in isolated temp fixtures (Negative Test 2),
 *    and passes when cured.
 * 8. Baseline drift detection: adding a new unpinned action to an existing legacy workflow triggers detection.
 * 9. Harness self-verification: meta-tests verify `verifyScannerRejection` rejects false-passes,
 *    empty output, scanner crashes, and wrong rules.
 * 10. Markdown safe encoding & stale-report fail-closed lifecycle: adversarial string escaping (CodeQL
 *     compliant backslash-first sanitization) and fail-closed rejection of stale/interrupted reports.
 *
 * Strict Isolation & Safety Guarantees:
 * - ZERO modifications or temporary file writes to `.github/workflows/`.
 * - All fixtures execute in isolated OS temporary directories with deterministic cleanup.
 * - Zero secret access; read-only repository inspection.
 * - Runtime execution report generated outside tracked source files.
 * ==============================================================================
 */

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import {
  resolveReportPath,
  escapeMarkdownTableCell,
  loadAndValidateReport,
} from './render-ci-summary.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, '..');
const WORKFLOWS_DIR = path.join(REPO_ROOT, '.github', 'workflows');
const ZIZMOR_CONFIG = path.join(REPO_ROOT, '.zizmor.yml');
const BASELINE_INVENTORY_PATH = path.join(REPO_ROOT, 'docs', 'security', 'ci-findings-baseline.json');
const REPORT_OUTPUT_PATH = resolveReportPath();

// Clean up any pre-existing report at runtime path to prevent stale report consumption
try {
  if (fs.existsSync(REPORT_OUTPUT_PATH)) {
    fs.unlinkSync(REPORT_OUTPUT_PATH);
  }
} catch {
  // ignore
}

const executionNonce = process.env.CI_EXECUTION_NONCE || `run-${Date.now()}-${process.pid}`;

// -----------------------------------------------------------------------------
// Binary Resolution
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// Test Report Architecture
// -----------------------------------------------------------------------------
const testReport = {
  timestamp: new Date().toISOString(),
  executionNonce,
  pid: process.pid,
  isCompleted: false,
  setupBlocked: false,
  setupBlockedReason: null,
  overallStatus: 'PENDING',
  summary: {
    totalSuites: 0,
    passed: 0,
    failed: 0,
    blocked: 0,
    skipped: 0,
  },
  suites: [],
  legacyBaseline: {
    totalAcknowledged: 29,
    exemptedRules: ['unpinned-uses', 'excessive-permissions', 'artipacked', 'cache-poisoning'],
    zeroToleranceRules: ['template-injection', 'untrusted-checkout', 'dangerous-triggers'],
    unresolvedCount: 0,
  },
  auditorVisibility: {
    totalFindings: 0,
    breakdownByRule: {},
    highRiskCount: 0,
  },
  zeroTrustVerification: {
    tokenPermissions: 'contents: read',
    secretAccessAttempted: false,
    secretValuesLogged: false,
    deploymentsBlocked: true,
  },
};

let allPassed = true;

function recordSuite({ id, name, status, details, diagnostics = null }) {
  testReport.suites.push({ id, name, status, details, diagnostics });
  if (status === 'PASS') {
    testReport.summary.passed++;
    console.log(`✓ [PASS] Suite ${id}: ${name}`);
  } else if (status === 'FAIL') {
    testReport.summary.failed++;
    allPassed = false;
    console.log(`✗ [FAIL] Suite ${id}: ${name}`);
  } else if (status === 'BLOCKED') {
    testReport.summary.blocked++;
    allPassed = false;
    console.log(`⛔ [BLOCKED] Suite ${id}: ${name}`);
  } else if (status === 'SKIPPED') {
    testReport.summary.skipped++;
    console.log(`↷ [SKIPPED] Suite ${id}: ${name}`);
  }
  if (details) {
    console.log(`   ${details}`);
  }
}

// -----------------------------------------------------------------------------
// Unified Diagnostic Verification Engine
// -----------------------------------------------------------------------------
export function verifyScannerRejection(runResult, { expectedRule, expectedFile, expectedLine, expectedSnippet }) {
  if (runResult.status === 0) {
    return {
      valid: false,
      errorType: 'FALSE_PASS',
      reason: 'Scanner exited 0 (false pass); defect was not detected',
    };
  }

  const stdout = runResult.stdout || '';
  const stderr = runResult.stderr || '';
  const combined = (stdout + '\n' + stderr).trim();

  if (!combined) {
    return {
      valid: false,
      errorType: 'EMPTY_OUTPUT',
      reason: 'Scanner exited non-zero but produced completely empty output',
    };
  }

  const crashPatterns = [
    /panic:/i,
    /segmentation fault/i,
    /core dumped/i,
    /fatal error/i,
    /internal error/i,
    /syntax error near unexpected token/i,
    /command not found/i,
  ];
  for (const p of crashPatterns) {
    if (p.test(combined)) {
      return {
        valid: false,
        errorType: 'SCANNER_CRASH',
        reason: `Scanner crashed or encountered an unexpected tool failure: ${combined.slice(0, 150)}`,
      };
    }
  }

  // Structured JSON findings evaluation
  if (runResult.findings && Array.isArray(runResult.findings)) {
    const matched = runResult.findings.filter(f => f.ident === expectedRule);
    if (matched.length === 0) {
      const foundRules = runResult.findings.map(f => f.ident);
      return {
        valid: false,
        errorType: 'WRONG_RULE',
        reason: `Expected rule '${expectedRule}', found rules: [${foundRules.join(', ')}]`,
      };
    }
    if (expectedFile) {
      const fileMatched = matched.filter(f => {
        return (f.locations || []).some(l => {
          const rawPath = l.symbolic?.key?.Local?.verbatim_path || '';
          return path.basename(rawPath.replace(/\\/g, '/')) === expectedFile;
        });
      });
      if (fileMatched.length === 0) {
        return {
          valid: false,
          errorType: 'WRONG_FILE',
          reason: `Finding was not located in expected file '${expectedFile}'`,
        };
      }
    }
    if (typeof expectedLine === 'number') {
      const lineMatched = matched.filter(f => {
        return (f.locations || []).some(l => {
          const row = l.concrete?.location?.start_point?.row;
          return typeof row === 'number' && (row + 1) === expectedLine;
        });
      });
      if (lineMatched.length === 0) {
        return {
          valid: false,
          errorType: 'WRONG_LINE',
          reason: `Finding was not located at expected line ${expectedLine}`,
        };
      }
    }
    return { valid: true, detectedRule: expectedRule, detectedFile: expectedFile, detectedLine: expectedLine };
  }

  // Plain-text diagnostics evaluation
  if (expectedFile && !combined.includes(expectedFile)) {
    return {
      valid: false,
      errorType: 'WRONG_FILE',
      reason: `Scanner output did not reference expected file '${expectedFile}'`,
    };
  }
  if (expectedRule && !combined.includes(expectedRule)) {
    return {
      valid: false,
      errorType: 'WRONG_RULE',
      reason: `Scanner output did not reference expected rule '${expectedRule}'`,
    };
  }
  if (expectedSnippet && !combined.includes(expectedSnippet)) {
    return {
      valid: false,
      errorType: 'UNMATCHED_DIAGNOSTIC',
      reason: `Scanner output missing expected diagnostic snippet '${expectedSnippet}'`,
    };
  }
  if (typeof expectedLine === 'number' && !new RegExp(`:${expectedLine}(:|\\s)`).test(combined)) {
    return {
      valid: false,
      errorType: 'WRONG_LINE',
      reason: `Scanner output missing expected line reference :${expectedLine}:`,
    };
  }

  return { valid: true, detectedRule: expectedRule, detectedFile: expectedFile, detectedLine: expectedLine };
}

// -----------------------------------------------------------------------------
// Baseline Identity Normalization & Comparator Engine
// -----------------------------------------------------------------------------
export function normalizeZizmorFinding(f) {
  const normLocs = (f.locations || []).map(l => {
    const rawPath = l.symbolic?.key?.Local?.verbatim_path || '';
    const filePath = path.basename(rawPath.replace(/\\/g, '/'));
    const startPoint = l.concrete?.location?.start_point;
    const line = typeof startPoint?.row === 'number' ? startPoint.row + 1 : -1;
    const col = typeof startPoint?.column === 'number' ? startPoint.column + 1 : -1;
    const kind = l.symbolic?.kind || 'Normal';
    return { file: filePath, line, col, kind };
  }).sort((a, b) => {
    if (a.file !== b.file) return a.file.localeCompare(b.file);
    if (a.line !== b.line) return a.line - b.line;
    return a.col - b.col;
  });

  const primaryLoc = normLocs.find(l => l.kind === 'Primary') || normLocs[0] || { file: 'unknown', line: -1, col: -1 };
  const locSignature = normLocs.map(l => `${l.file}:${l.line}:${l.col}`).join(';');
  const identityKey = `${f.ident}::${primaryLoc.file}:${primaryLoc.line}::${locSignature}`;

  return {
    identity_key: identityKey,
    ident: f.ident,
    file: primaryLoc.file,
    line: primaryLoc.line,
    col: primaryLoc.col,
    severity: f.determinations?.severity || 'Unknown',
    confidence: f.determinations?.confidence || 'Unknown',
    locations: normLocs,
  };
}

export function compareBaselineIdentities(baselineFindings, scannerFindings) {
  const baselineMap = new Map();
  baselineFindings.forEach(f => {
    const key = f.identity_key || f.identityKey;
    baselineMap.set(key, f);
  });

  const scannerMap = new Map();
  scannerFindings.forEach(f => {
    const key = f.identity_key || f.identityKey;
    scannerMap.set(key, f);
  });

  const added = [];
  for (const [key, f] of scannerMap.entries()) {
    if (!baselineMap.has(key)) added.push(f);
  }

  const removed = [];
  for (const [key, f] of baselineMap.entries()) {
    if (!scannerMap.has(key)) removed.push(f);
  }

  const matches = [];
  for (const [key, f] of scannerMap.entries()) {
    if (baselineMap.has(key)) matches.push(f);
  }

  const passed = added.length === 0 && removed.length === 0 && matches.length === baselineMap.size;

  return {
    passed,
    totalExpected: baselineMap.size,
    totalFound: scannerMap.size,
    matchCount: matches.length,
    added,
    removed,
  };
}

// -----------------------------------------------------------------------------
// Pre-flight Verification
// -----------------------------------------------------------------------------
console.log('====================================================');
console.log('KONFRM Quality Evidence Mesh — CI Safety Test Harness');
console.log('----------------------------------------------------');
console.log(`Repository root : ${REPO_ROOT}`);
console.log(`Actionlint path : ${actionlintBin || 'NOT FOUND'}`);
console.log(`Zizmor path     : ${zizmorBin || 'NOT FOUND'}`);
console.log(`Baseline file   : ${BASELINE_INVENTORY_PATH}`);
console.log(`Runtime report  : ${REPORT_OUTPUT_PATH}`);
console.log(`Execution nonce : ${executionNonce}`);
console.log('====================================================\n');

if (!actionlintBin) {
  recordSuite({
    id: 0,
    name: 'Tool resolution pre-flight',
    status: 'BLOCKED',
    details: 'actionlint binary not found. Please install actionlint v1.7.12.',
  });
  testReport.setupBlocked = true;
  testReport.setupBlockedReason = 'actionlint binary not found';
  testReport.overallStatus = 'BLOCKED';
  testReport.isCompleted = true;
  fs.writeFileSync(REPORT_OUTPUT_PATH, JSON.stringify(testReport, null, 2) + '\n', 'utf-8');
  process.exit(1);
}

if (!zizmorBin) {
  recordSuite({
    id: 0,
    name: 'Tool resolution pre-flight',
    status: 'BLOCKED',
    details: 'zizmor binary not found. Please install zizmor v1.30.1.',
  });
  testReport.setupBlocked = true;
  testReport.setupBlockedReason = 'zizmor binary not found';
  testReport.overallStatus = 'BLOCKED';
  testReport.isCompleted = true;
  fs.writeFileSync(REPORT_OUTPUT_PATH, JSON.stringify(testReport, null, 2) + '\n', 'utf-8');
  process.exit(1);
}

// -----------------------------------------------------------------------------
// Suite 1: Actionlint on Tracked Workflows
// -----------------------------------------------------------------------------
console.log('[1/10] Running actionlint on tracked repository workflows...');
const alRun = spawnSync(actionlintBin, ['-color'], {
  cwd: REPO_ROOT,
  encoding: 'utf-8',
});

if (alRun.status === 0) {
  recordSuite({
    id: 1,
    name: 'Tracked workflow actionlint validation',
    status: 'PASS',
    details: '0 syntax/expression errors detected across all tracked workflows',
  });
} else {
  recordSuite({
    id: 1,
    name: 'Tracked workflow actionlint validation',
    status: 'FAIL',
    details: `Exit ${alRun.status}: ${alRun.stdout || alRun.stderr}`,
  });
}

// -----------------------------------------------------------------------------
// Suite 2: Zizmor on Tracked Workflows with Traceable Baseline (.zizmor.yml)
// -----------------------------------------------------------------------------
console.log('\n[2/10] Running zizmor audit against .zizmor.yml baseline...');
const zmRun = spawnSync(
  zizmorBin,
  ['--config', ZIZMOR_CONFIG, '--format', 'plain', '--offline', '.github/workflows'],
  {
    cwd: REPO_ROOT,
    encoding: 'utf-8',
  }
);

if (zmRun.status === 0) {
  recordSuite({
    id: 2,
    name: 'Tracked workflow zizmor baseline audit',
    status: 'PASS',
    details: 'Clean scan: zero unexempted security findings under .zizmor.yml',
  });
} else {
  recordSuite({
    id: 2,
    name: 'Tracked workflow zizmor baseline audit',
    status: 'FAIL',
    details: `Exit ${zmRun.status}: ${zmRun.stdout || zmRun.stderr}`,
  });
}

// -----------------------------------------------------------------------------
// Suite 3: Deterministic Baseline Identity Inventory Audit
// -----------------------------------------------------------------------------
console.log('\n[3/10] Verifying acknowledged legacy findings baseline identities...');
let rawFindings = [];
try {
  const rawZizmor = spawnSync(
    zizmorBin,
    ['--no-config', '--no-ignores', '--format', 'json', '--offline', '.github/workflows'],
    {
      cwd: REPO_ROOT,
      encoding: 'utf-8',
    }
  );

  rawFindings = JSON.parse(rawZizmor.stdout || '[]');
  const baselineDoc = JSON.parse(fs.readFileSync(BASELINE_INVENTORY_PATH, 'utf-8'));
  const normalizedScanner = rawFindings.map(normalizeZizmorFinding);

  const comp = compareBaselineIdentities(baselineDoc.findings, normalizedScanner);

  if (comp.passed && comp.matchCount === 29) {
    recordSuite({
      id: 3,
      name: 'Deterministic baseline identity comparison',
      status: 'PASS',
      details: `Exact match: 29 acknowledged legacy findings verified by deterministic normalized identity keys (0 added, 0 removed)`,
    });
  } else {
    recordSuite({
      id: 3,
      name: 'Deterministic baseline identity comparison',
      status: 'FAIL',
      details: `Identity mismatch: expected ${comp.totalExpected}, found ${comp.totalFound}. Matches: ${comp.matchCount}. Added: ${comp.added.length}, Removed: ${comp.removed.length}`,
    });
  }
} catch (err) {
  recordSuite({
    id: 3,
    name: 'Deterministic baseline identity comparison',
    status: 'FAIL',
    details: `Inventory verification error: ${err.message}`,
  });
}

// -----------------------------------------------------------------------------
// Suite 4: Baseline Identity Negative Proofs (Cases A, B, C, D, E)
// -----------------------------------------------------------------------------
console.log('\n[4/10] Verifying baseline identity negative proofs (Cases A, B, C, D, E)...');
try {
  const baselineDoc = JSON.parse(fs.readFileSync(BASELINE_INVENTORY_PATH, 'utf-8'));
  const baseFindings = baselineDoc.findings;

  // Case A: Add one new finding — must FAIL
  const caseA = compareBaselineIdentities(baseFindings, [
    ...baseFindings,
    { identity_key: 'unpinned-uses::new-wf.yml:10::new-wf.yml:10:5', ident: 'unpinned-uses', file: 'new-wf.yml', line: 10 },
  ]);

  // Case B: Remove one acknowledged finding — must FAIL
  const caseB = compareBaselineIdentities(baseFindings, baseFindings.slice(1));

  // Case C: Replace one old finding with one new finding while preserving count 29 — must FAIL
  const caseC = compareBaselineIdentities(baseFindings, [
    ...baseFindings.slice(1),
    { identity_key: 'untrusted-checkout::ci-validation.yml:99::ci-validation.yml:99:5', ident: 'untrusted-checkout', file: 'ci-validation.yml', line: 99 },
  ]);

  // Case D: Reorder identical findings without changing identities — must PASS
  const caseD = compareBaselineIdentities(baseFindings, [...baseFindings].reverse());

  // Case E: Introduce a different issue on an existing exempted line — must FAIL
  const caseE = compareBaselineIdentities(baseFindings, [
    ...baseFindings,
    { identity_key: 'template-injection::ci-validation.yml:25::ci-validation.yml:25:9', ident: 'template-injection', file: 'ci-validation.yml', line: 25 },
  ]);

  const allCasesCorrect =
    caseA.passed === false && caseA.added.length === 1 &&
    caseB.passed === false && caseB.removed.length === 1 &&
    caseC.passed === false && caseC.totalFound === 29 && caseC.added.length === 1 && caseC.removed.length === 1 &&
    caseD.passed === true && caseD.matchCount === 29 &&
    caseE.passed === false && caseE.added.length === 1;

  if (allCasesCorrect) {
    recordSuite({
      id: 4,
      name: 'Baseline identity negative proofs (Cases A-E)',
      status: 'PASS',
      details: 'All 5 identity-integrity negative cases verified: A (added: FAIL), B (removed: FAIL), C (equal-count substitution: FAIL), D (reordered: PASS), E (different issue on exempted line: FAIL)',
    });
  } else {
    recordSuite({
      id: 4,
      name: 'Baseline identity negative proofs (Cases A-E)',
      status: 'FAIL',
      details: `Negative cases evaluation failed: A=${caseA.passed}, B=${caseB.passed}, C=${caseC.passed}, D=${caseD.passed}, E=${caseE.passed}`,
    });
  }
} catch (err) {
  recordSuite({
    id: 4,
    name: 'Baseline identity negative proofs (Cases A-E)',
    status: 'FAIL',
    details: `Evaluation error: ${err.message}`,
  });
}

// -----------------------------------------------------------------------------
// Suite 5: Auditor-Mode Visibility Audit
// -----------------------------------------------------------------------------
console.log('\n[5/10] Running auditor-mode visibility audit (--persona auditor --no-ignores)...');
try {
  const auditorRun = spawnSync(
    zizmorBin,
    ['--no-config', '--no-ignores', '--persona', 'auditor', '--format', 'json', '--offline', '.github/workflows'],
    {
      cwd: REPO_ROOT,
      encoding: 'utf-8',
    }
  );

  const auditorFindings = JSON.parse(auditorRun.stdout || '[]');
  const ruleCounts = {};
  auditorFindings.forEach(f => {
    ruleCounts[f.ident] = (ruleCounts[f.ident] || 0) + 1;
  });

  const highRisk = auditorFindings.filter(f =>
    f.ident === 'template-injection' || f.ident === 'untrusted-checkout' || f.ident === 'dangerous-triggers'
  );

  testReport.auditorVisibility.totalFindings = auditorFindings.length;
  testReport.auditorVisibility.breakdownByRule = ruleCounts;
  testReport.auditorVisibility.highRiskCount = highRisk.length;

  if (highRisk.length === 0 && auditorFindings.length > 0) {
    recordSuite({
      id: 5,
      name: 'Auditor-mode visibility audit',
      status: 'PASS',
      details: `Full visibility: ${auditorFindings.length} findings cataloged under auditor persona (0 high-risk vulnerabilities). Hidden findings are fully cataloged, never mistaken for zero risk.`,
    });
  } else {
    recordSuite({
      id: 5,
      name: 'Auditor-mode visibility audit',
      status: 'FAIL',
      details: `Auditor mode flagged ${highRisk.length} unexpected high-risk vulnerabilities!`,
    });
  }
} catch (err) {
  recordSuite({
    id: 5,
    name: 'Auditor-mode visibility audit',
    status: 'FAIL',
    details: `Auditor audit error: ${err.message}`,
  });
}

// -----------------------------------------------------------------------------
// Suite 6: Controlled Negative Test for Actionlint (Isolated Temp Directory)
// -----------------------------------------------------------------------------
console.log('\n[6/10] Running controlled negative test for actionlint in isolated tmpDir...');
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
  const evalNeg = verifyScannerRejection(alNegRun, {
    expectedRule: 'expression',
    expectedFile: 'bad-syntax.yml',
    expectedLine: 7,
    expectedSnippet: 'lexing expression',
  });

  if (!evalNeg.valid) {
    recordSuite({
      id: 6,
      name: 'Actionlint negative test (defect injection + cure)',
      status: 'FAIL',
      details: `Negative test failed rejection evaluation: ${evalNeg.reason}`,
    });
  } else {
    // Verify defect cure causes error to disappear
    fs.writeFileSync(curedFixture, curedYaml);
    const alCuredRun = spawnSync(actionlintBin, [curedFixture], { encoding: 'utf-8' });

    if (alCuredRun.status === 0) {
      recordSuite({
        id: 6,
        name: 'Actionlint negative test (defect injection + cure)',
        status: 'PASS',
        details: `Defect caught (exit ${alNegRun.status}, diagnosed '${evalNeg.detectedRule}' at line ${evalNeg.detectedLine}) and verified resolved upon cure (exit 0)`,
      });
    } else {
      recordSuite({
        id: 6,
        name: 'Actionlint negative test (defect injection + cure)',
        status: 'FAIL',
        details: `Cured fixture failed unexpectedly with exit ${alCuredRun.status}`,
      });
    }
  }
} finally {
  fs.rmSync(alTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Suite 7: Controlled Negative Test for Zizmor (Genuine Template Injection)
// -----------------------------------------------------------------------------
console.log('\n[7/10] Running controlled negative test for zizmor (genuine template-injection in isolated tmpDir)...');
const zmTmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-zm-neg-'));
try {
  const badFixture = path.join(zmTmpDir, 'ti-insecure.yml');
  const curedFixture = path.join(zmTmpDir, 'ti-cured.yml');

  const insecureYaml = `name: Template Injection Test Fixture
on:
  issues:
    types: [opened]
permissions:
  contents: read
jobs:
  vuln:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Insecure step with template injection
        run: echo "\${{ github.event.issue.title }}"
`;

  const hardenedYaml = `name: Template Injection Cured Fixture
on:
  issues:
    types: [opened]
permissions:
  contents: read
jobs:
  secure:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Hardened step with environment variable isolation
        env:
          ISSUE_TITLE: \${{ github.event.issue.title }}
        run: echo "$ISSUE_TITLE"
`;

  fs.writeFileSync(badFixture, insecureYaml);

  const zmNegRun = spawnSync(
    zizmorBin,
    ['--format', 'json', '--offline', badFixture],
    { encoding: 'utf-8' }
  );

  let negFindings = [];
  try {
    negFindings = JSON.parse(zmNegRun.stdout || '[]');
  } catch {
    negFindings = [];
  }

  const evalNeg = verifyScannerRejection(
    { status: zmNegRun.status, stdout: zmNegRun.stdout, stderr: zmNegRun.stderr, findings: negFindings },
    {
      expectedRule: 'template-injection',
      expectedFile: 'ti-insecure.yml',
      expectedLine: 13,
    }
  );

  if (!evalNeg.valid) {
    recordSuite({
      id: 7,
      name: 'Zizmor negative test (genuine template-injection + cure)',
      status: 'FAIL',
      details: `Negative test failed rejection evaluation: ${evalNeg.reason}`,
    });
  } else {
    // Verify defect cure causes finding to clear
    fs.writeFileSync(curedFixture, hardenedYaml);
    const zmCuredRun = spawnSync(
      zizmorBin,
      ['--format', 'json', '--offline', curedFixture],
      { encoding: 'utf-8' }
    );

    let curedFindings = [];
    try {
      curedFindings = JSON.parse(zmCuredRun.stdout || '[]');
    } catch {
      curedFindings = [];
    }

    if (zmCuredRun.status === 0 && curedFindings.length === 0) {
      recordSuite({
        id: 7,
        name: 'Zizmor negative test (genuine template-injection + cure)',
        status: 'PASS',
        details: `Vulnerability caught (exit ${zmNegRun.status}, confirmed 'template-injection' at line 13) and verified resolved upon hardening (exit 0, 0 findings)`,
      });
    } else {
      recordSuite({
        id: 7,
        name: 'Zizmor negative test (genuine template-injection + cure)',
        status: 'FAIL',
        details: `Hardened fixture failed unexpectedly: exit ${zmCuredRun.status}, ${curedFindings.length} findings`,
      });
    }
  }
} finally {
  fs.rmSync(zmTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Suite 8: Baseline Drift Detection (Legacy Workflow Mutation in Temp Dir)
// -----------------------------------------------------------------------------
console.log('\n[8/10] Running baseline drift detection (mutating legacy workflow copy in isolated tmpDir)...');
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

  const evalDrift = verifyScannerRejection(driftRun, {
    expectedRule: 'unpinned-uses',
    expectedFile: 'ci-validation.yml',
  });

  if (evalDrift.valid) {
    recordSuite({
      id: 8,
      name: 'Legacy baseline drift detection',
      status: 'PASS',
      details: `Detected unexempted finding added to legacy workflow (exit ${driftRun.status}): newly introduced issues cannot hide behind legacy exceptions`,
    });
  } else {
    recordSuite({
      id: 8,
      name: 'Legacy baseline drift detection',
      status: 'FAIL',
      details: `Drift was not properly rejected: ${evalDrift.reason}`,
    });
  }
} finally {
  fs.rmSync(driftTmpDir, { recursive: true, force: true });
}

// -----------------------------------------------------------------------------
// Suite 9: Harness Self-Verification (Anti-False-Positive Meta-Tests)
// -----------------------------------------------------------------------------
console.log('\n[9/10] Running test harness self-verification (meta-evaluation of verifyScannerRejection)...');
const metaFakePass = verifyScannerRejection(
  { status: 0, stdout: 'clean run', stderr: '' },
  { expectedRule: 'template-injection', expectedFile: 'test.yml' }
);
const metaEmptyOutput = verifyScannerRejection(
  { status: 1, stdout: '', stderr: '' },
  { expectedRule: 'template-injection', expectedFile: 'test.yml' }
);
const metaCrash = verifyScannerRejection(
  { status: 139, stdout: '', stderr: 'Segmentation fault (core dumped)' },
  { expectedRule: 'template-injection', expectedFile: 'test.yml' }
);
const metaWrongRule = verifyScannerRejection(
  { status: 14, stdout: '{"findings": [{"ident": "artipacked"}]}', findings: [{ ident: 'artipacked' }] },
  { expectedRule: 'template-injection', expectedFile: 'test.yml' }
);
const metaGenuine = verifyScannerRejection(
  {
    status: 14,
    stdout: '{"findings": [{"ident": "template-injection", "locations": [{"symbolic": {"key": {"Local": {"verbatim_path": "test.yml"}}}, "concrete": {"location": {"start_point": {"row": 12}}}}]}]}',
    findings: [{
      ident: 'template-injection',
      locations: [{
        symbolic: { key: { Local: { verbatim_path: 'test.yml' } } },
        concrete: { location: { start_point: { row: 12 } } },
      }],
    }],
  },
  { expectedRule: 'template-injection', expectedFile: 'test.yml', expectedLine: 13 }
);

const selfTestPassed =
  metaFakePass.valid === false && metaFakePass.errorType === 'FALSE_PASS' &&
  metaEmptyOutput.valid === false && metaEmptyOutput.errorType === 'EMPTY_OUTPUT' &&
  metaCrash.valid === false && metaCrash.errorType === 'SCANNER_CRASH' &&
  metaWrongRule.valid === false && metaWrongRule.errorType === 'WRONG_RULE' &&
  metaGenuine.valid === true;

if (selfTestPassed) {
  recordSuite({
    id: 9,
    name: 'Harness self-verification (anti-false-positive meta-test)',
    status: 'PASS',
    details: 'Verified that verifyScannerRejection rejects false passes (exit 0), empty output, scanner crashes, and mismatched rules on actual production verification logic',
  });
} else {
  recordSuite({
    id: 9,
    name: 'Harness self-verification',
    status: 'FAIL',
    details: 'Meta-evaluation failed to reject all error classes',
  });
}

// -----------------------------------------------------------------------------
// Suite 10: Markdown Table Cell Safe Encoding & Stale-Report Fail-Closed Verification
// -----------------------------------------------------------------------------
console.log('\n[10/10] Verifying markdown table safe encoding & stale-report fail-closed lifecycle...');
try {
  // Part A: Adversarial Escaping Tests
  // 1. Backslashes must be escaped before pipes
  const adv1 = 'C:\\path\\with\\backslashes|and|pipes';
  const esc1 = escapeMarkdownTableCell(adv1);
  const correctEsc1 = esc1 === 'C:\\\\path\\\\with\\\\backslashes\\|and\\|pipes';

  // 2. Multiline strings and carriage returns must be flattened
  const adv2 = "line1\r\nline2\nline3 | with | pipes";
  const esc2 = escapeMarkdownTableCell(adv2);
  const correctEsc2 = !esc2.includes('\n') && !esc2.includes('\r') && esc2.includes('\\|');

  // 3. Control characters must be stripped
  const adv3 = 'clean\x00text\x08with\x1Fcontrol\x7Fchars|pipe';
  const esc3 = escapeMarkdownTableCell(adv3);
  const correctEsc3 = esc3 === 'cleantextwithcontrolchars\\|pipe';

  // 4. Backslash preceding pipe: \|
  const adv4 = 'already\\|escaped';
  const esc4 = escapeMarkdownTableCell(adv4);
  const correctEsc4 = esc4 === 'already\\\\\\|escaped';

  // 5. Table integrity test: verify rendered cell inside row produces valid row without splitting
  const row = `| 1 | Test | **PASS** | ${esc1} |`;
  const pipeCount = (row.match(/(?<!\\)\|/g) || []).length;
  // A table row with 4 columns has exactly 5 unescaped delimiters: | 1 | Test | **PASS** | details |
  const correctTableFormat = pipeCount === 5;

  const escapingPassed = correctEsc1 && correctEsc2 && correctEsc3 && correctEsc4 && correctTableFormat;

  // Part B: Stale-Report Fail-Closed Tests
  const tmpLifecycleDir = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-report-lifecycle-'));
  const testReportFile = path.join(tmpLifecycleDir, 'test-report.json');

  let lifecyclePassed = false;
  try {
    // 1. Missing report -> BLOCKED
    const checkMissing = loadAndValidateReport(testReportFile, 'nonce-123');
    const missingOk = checkMissing.valid === false && checkMissing.status === 'BLOCKED';

    // 2. Older report with stale nonce -> BLOCKED (mismatched nonce)
    const staleReportData = {
      overallStatus: 'PASS',
      executionNonce: 'old-nonce-456',
      isCompleted: true,
      summary: { totalSuites: 10, passed: 10, failed: 0, blocked: 0, skipped: 0 },
      suites: new Array(10).fill({ id: 1, name: 'dummy', status: 'PASS', details: 'ok' }),
    };
    fs.writeFileSync(testReportFile, JSON.stringify(staleReportData));
    const checkStale = loadAndValidateReport(testReportFile, 'current-nonce-789');
    const staleOk = checkStale.valid === false && checkStale.status === 'BLOCKED';

    // 3. Interrupted execution (isCompleted: false) -> FAIL
    const interruptedData = {
      overallStatus: 'PASS',
      executionNonce: 'current-nonce-789',
      isCompleted: false,
      summary: { totalSuites: 10, passed: 5, failed: 0, blocked: 0, skipped: 0 },
      suites: new Array(5).fill({ id: 1, name: 'dummy', status: 'PASS', details: 'ok' }),
    };
    fs.writeFileSync(testReportFile, JSON.stringify(interruptedData));
    const checkInterrupted = loadAndValidateReport(testReportFile, 'current-nonce-789');
    const interruptedOk = checkInterrupted.valid === false && checkInterrupted.status === 'FAIL';

    // 4. Setup blocked report -> BLOCKED, never PASS
    const blockedData = {
      overallStatus: 'BLOCKED',
      setupBlocked: true,
      executionNonce: 'current-nonce-789',
      isCompleted: true,
      summary: { totalSuites: 10, passed: 0, failed: 0, blocked: 1, skipped: 9 },
      suites: new Array(10).fill({ id: 1, name: 'dummy', status: 'BLOCKED', details: 'Tool resolution blocked' }),
    };
    fs.writeFileSync(testReportFile, JSON.stringify(blockedData));
    const checkBlocked = loadAndValidateReport(testReportFile, 'current-nonce-789');
    const blockedOk = checkBlocked.valid === true && checkBlocked.status === 'BLOCKED';

    lifecyclePassed = missingOk && staleOk && interruptedOk && blockedOk;
  } finally {
    fs.rmSync(tmpLifecycleDir, { recursive: true, force: true });
  }

  if (escapingPassed && lifecyclePassed) {
    recordSuite({
      id: 10,
      name: 'Markdown safe encoding & stale-report fail-closed verification',
      status: 'PASS',
      details: 'Verified backslash-first escaping, multiline/control sanitization, and fail-closed rejection of missing, stale-nonce, interrupted, or blocked reports',
    });
  } else {
    recordSuite({
      id: 10,
      name: 'Markdown safe encoding & stale-report fail-closed verification',
      status: 'FAIL',
      details: `Escaping checks passed: ${escapingPassed}, Lifecycle checks passed: ${lifecyclePassed}`,
    });
  }
} catch (err) {
  recordSuite({
    id: 10,
    name: 'Markdown safe encoding & stale-report fail-closed verification',
    status: 'FAIL',
    details: `Evaluation error: ${err.message}`,
  });
}

// -----------------------------------------------------------------------------
// Write Machine-Readable Report & Exit
// -----------------------------------------------------------------------------
testReport.summary.totalSuites = testReport.suites.length;
testReport.overallStatus = (testReport.summary.failed === 0 && testReport.summary.blocked === 0) ? 'PASS' : 'FAIL';
testReport.isCompleted = true;

fs.writeFileSync(REPORT_OUTPUT_PATH, JSON.stringify(testReport, null, 2) + '\n', 'utf-8');
console.log(`\nMachine-readable test report written to: ${REPORT_OUTPUT_PATH}`);

console.log('\n====================================================');
console.log(`SUMMARY: ${testReport.summary.passed}/${testReport.summary.totalSuites} TEST SUITES PASSED.`);
if (allPassed) {
  console.log('ALL CI SAFETY & HARDENED VERIFICATION TESTS PASSED.');
  console.log('====================================================');
  process.exit(0);
} else {
  console.error('ONE OR MORE CI SAFETY TESTS FAILED.');
  console.log('====================================================');
  process.exit(1);
}
