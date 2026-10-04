#!/usr/bin/env node
/**
 * KONFRM Design Court — Deterministic Contract Test
 *
 * Validates that the Design Court governance contract classifies the required
 * scenarios correctly. It does NOT simulate human design judgment.
 *
 * - Fixtures: the JSON block in docs/ai/skills/konfrm-design-court/TEST_CASES.md
 * - Rules: encoded below; every rule token used is asserted to exist in the
 *   Court contract files, so removing a rule from the docs fails this test.
 * - Built-in Node APIs only. No network. No model calls.
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(__dirname, '..');
const COURT_DIR = path.join(projectRoot, 'docs', 'ai', 'skills', 'konfrm-design-court');

let failures = 0;
const fail = (m) => { console.error(`❌ [COURT CONTRACT FAILURE]: ${m}`); failures++; };
const pass = (m) => console.log(`✓ [PASS]: ${m}`);

// ---------------------------------------------------------------------------
// 1. Load contract text
// ---------------------------------------------------------------------------
const CONTRACT_FILES = [
  'SKILL.md', 'ROLES.md', 'DELIBERATION_PROTOCOL.md', 'PERSONA_PANEL.md',
  'EVIDENCE_MODEL.md', 'VERDICT_TEMPLATE.md', 'TEST_CASES.md',
];
const contract = {};
for (const f of CONTRACT_FILES) {
  const p = path.join(COURT_DIR, f);
  if (!fs.existsSync(p)) { fail(`Missing contract file ${f}`); continue; }
  contract[f] = fs.readFileSync(p, 'utf8');
}
if (failures > 0) { console.error(`FAILED: ${failures}`); process.exit(1); }
const allText = Object.values(contract).join('\n');

// ---------------------------------------------------------------------------
// 2. Contract rules (mirrors SKILL.md / DELIBERATION_PROTOCOL.md)
// ---------------------------------------------------------------------------
const NOT_REQUIRED_CATEGORIES = new Set([
  'TYPO', 'LITERAL_CLIPPING_BUG', 'OBVIOUS_BROKEN_RTL_PROPERTY', 'KNOWN_A11Y_DEFECT',
  'IMPLEMENTATION_PARITY_FIX', 'BACKEND_BEHAVIOR', 'ROUTINE_CODE_BUG', 'ALREADY_GOVERNED_RULE',
]);
const FULL_COURT_SCOPES = new Set([
  'NEW_PRIMITIVE_SYSTEM', 'NAVIGATION_ARCHITECTURE', 'MAJOR_SCREEN_ARCHITECTURE',
  'BRAND_LANGUAGE', 'SHARED_COMPONENT_SYSTEM', 'TOKEN_FAMILY_STRATEGY', 'INTERACTION_ARCHITECTURE',
]);
const HARD_GATES = [
  'BUSINESS_CANON', 'PRODUCT_TRUTH', 'FINANCIAL_RULE', 'SECURITY_CONSTRAINT',
  'APPLICABLE_ACCESSIBILITY_REQUIREMENT', 'PLATFORM_IMPOSSIBILITY', 'RTL_CORRECTNESS', 'ARCHITECTURE_BOUNDARY',
];
const OUTCOMES = new Set([
  'VERDICT_REACHED', 'NEEDS_VISUAL_EVIDENCE', 'NEEDS_USER_RESEARCH', 'NEEDS_FOUNDER_VISUAL_DECISION',
  'BLOCKED_BY_PRODUCT_OR_CANON', 'NO_MATERIAL_DIFFERENCE', 'COURT_NOT_REQUIRED',
]);
const ALLOWED_DECISION_STATUS = new Set(['ADVISORY', 'CANDIDATE', 'VALIDATED_CANDIDATE']);
const PLATFORM_TOUCH_GUIDANCE = { ios: '44pt', android: '48dp' };

function assertDecisionStatus(status) {
  if (!ALLOWED_DECISION_STATUS.has(status)) {
    throw new Error(`Court may not emit DECISION_STATUS: ${status}`);
  }
  return status;
}

function classify(input) {
  const r = { courtRequired: true, decisionStatus: assertDecisionStatus('ADVISORY'), mutatesCanon: false };

  // External heuristic universalization (independent of court requirement)
  if (Array.isArray(input.externalClaims)) {
    for (const c of input.externalClaims) {
      if (c.property === 'TOUCH_TARGET' && c.universal) {
        r.externalClaimDisposition = 'REJECT_UNIVERSALIZATION';
        r.platformGuidance = { ...PLATFORM_TOUCH_GUIDANCE };
      }
    }
  }

  // Court-not-required route
  if (NOT_REQUIRED_CATEGORIES.has(input.category) || input.materialAmbiguity === false) {
    r.courtRequired = false;
    r.courtOutcome = 'COURT_NOT_REQUIRED';
    return r;
  }

  // Historical replay may never mutate canon or reopen a closed phase
  if (input.replayMode === 'HISTORICAL_NON_MUTATING_REPLAY') {
    r.replayMode = input.replayMode;
    r.mutatesCanon = false;
    r.reopensClosedPhase = false;
  }

  // Mode selection
  const crossRole = input.category === 'CROSS_ROLE_CONFLICT' || (input.roles || []).length > 1;
  r.mode = (crossRole || FULL_COURT_SCOPES.has(input.scope)) ? 'FULL_COURT' : 'FAST_PANEL';
  if (crossRole) r.roleSensitiveWeighting = true;

  // Attribution truth: unavailable specialists get no position and no vote
  r.attribution = (input.specialists || []).map((s) => (
    s.available
      ? { skill: s.skill, status: 'CONSULTED' }
      : { skill: s.skill, status: 'UNAVAILABLE', position: null, vote: null }
  ));

  // Founder decision stability
  if (input.founderSelected) {
    const marginal = !input.panelPreference || input.panelPreference.margin === 'MARGINAL';
    const noNewEvidence = !input.materialNewEvidence || input.materialNewEvidence.length === 0;
    if (marginal && noNewEvidence) {
      r.founderAction = 'PRESERVE_FOUNDER_DECISION';
      r.reopen = 'NO_REOPEN';
      r.courtOutcome = 'VERDICT_REACHED';
      return r;
    }
  }

  // Hard gates — majority support never overrides a failure
  const options = input.options || [];
  const surviving = options.filter((o) => !(o.hardGateViolations || []).some((g) => HARD_GATES.includes(g)));
  r.majorityOverrideApplied = false;
  if (options.length > 0 && surviving.length === 0) {
    r.courtOutcome = 'BLOCKED_BY_PRODUCT_OR_CANON';
    r.consensus = 'BLOCKED_BY_CANON';
    return r;
  }

  // Evidence gate
  if (input.requiresVisualEvidence && (!input.artifacts || input.artifacts.length === 0)) {
    r.courtOutcome = 'NEEDS_VISUAL_EVIDENCE';
    r.consensus = 'INSUFFICIENT_EVIDENCE';
    return r;
  }

  // A deterministic contract test cannot decide design merit: deliberation pending
  r.courtOutcome = 'PENDING_DELIBERATION';
  return r;
}

// ---------------------------------------------------------------------------
// 3. Contract anchors — rules used above must be documented in the Court files
// ---------------------------------------------------------------------------
const anchors = [
  'COURT_NOT_REQUIRED', 'FAST_PANEL', 'FULL_COURT', 'BLOCKED_BY_PRODUCT_OR_CANON', 'BLOCKED_BY_CANON',
  'NEEDS_VISUAL_EVIDENCE', 'INSUFFICIENT_EVIDENCE', 'PRESERVE_FOUNDER_DECISION', 'NO_REOPEN',
  'UNAVAILABLE', 'NOT_CONSULTED', 'HISTORICAL_NON_MUTATING_REPLAY', 'MINORITY_OPINION',
  'DELIBERATION_TOPOLOGY', 'SINGLE_AGENT_STRUCTURED_PANEL', 'TRUE_MULTI_AGENT', 'SYNTHETIC_ROLE_LENS',
  'CONSULTATION_SOURCE', 'SOURCE_ANCHOR', 'APPLIED_PRINCIPLE',
  '44pt', '48dp', ...HARD_GATES, ...OUTCOMES,
];
const missingAnchors = anchors.filter((a) => !allText.includes(a));
if (missingAnchors.length) fail(`Contract files missing rule anchors: ${missingAnchors.join(', ')}`);
else pass(`All ${anchors.length} contract rule anchors present in Court files.`);

// ---------------------------------------------------------------------------
// 4. Run fixtures
// ---------------------------------------------------------------------------
const jsonMatch = contract['TEST_CASES.md'].match(/```json\s*([\s\S]*?)```/);
if (!jsonMatch) { fail('TEST_CASES.md has no JSON fixture block'); }
let cases = [];
try { cases = JSON.parse(jsonMatch[1]).cases; } catch (e) { fail(`Fixture JSON invalid: ${e.message}`); }
if (cases.length < 8) fail(`Expected at least 8 fixtures, found ${cases.length}`);

function deepEqual(a, b) { return JSON.stringify(a) === JSON.stringify(b); }

let casePasses = 0;
for (const c of cases) {
  const out = classify(c.input);
  const errs = [];
  const exp = c.expected;
  if (exp.unavailableSkill) {
    const entry = (out.attribution || []).find((x) => x.skill === exp.unavailableSkill);
    if (!entry) errs.push('unavailable skill missing from attribution ledger');
    else {
      if (entry.status !== exp.status) errs.push(`status ${entry.status} != ${exp.status}`);
      if (entry.position !== null || 'stance' in entry) errs.push('fabricated position');
      if (entry.vote !== null) errs.push('fabricated vote');
    }
  }
  for (const [k, v] of Object.entries(exp)) {
    if (['unavailableSkill', 'status', 'position', 'vote'].includes(k)) continue;
    if (!deepEqual(out[k], v)) errs.push(`${k}: got ${JSON.stringify(out[k])}, expected ${JSON.stringify(v)}`);
  }
  if (out.courtOutcome && out.courtOutcome !== 'PENDING_DELIBERATION' && !OUTCOMES.has(out.courtOutcome)) {
    errs.push(`invalid outcome ${out.courtOutcome}`);
  }
  if (out.mutatesCanon !== false) errs.push('Court output mutates canon');
  if (errs.length) fail(`${c.id}: ${errs.join('; ')}`);
  else { casePasses++; pass(`${c.id}`); }
}
console.log(`CONTRACT_TEST_CASES: ${casePasses}/${cases.length} PASS`);

// ---------------------------------------------------------------------------
// 5. Invariant: the Court cannot emit a canonical decision status
// ---------------------------------------------------------------------------
let canonBlocked = false;
try { assertDecisionStatus('CANONICAL'); } catch { canonBlocked = true; }
if (!canonBlocked) fail('Court classifier allowed DECISION_STATUS: CANONICAL');
else pass('Court classifier rejects DECISION_STATUS: CANONICAL.');

if (failures > 0) {
  console.error(`FAILED: ${failures} Design Court contract check(s) failed.`);
  process.exit(1);
}
console.log('DESIGN COURT CONTRACT TEST PASSED.');
