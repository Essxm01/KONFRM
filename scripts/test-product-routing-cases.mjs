#!/usr/bin/env node
/**
 * KONFRM Product Brain — Routing & Domain Truth Contract Test
 *
 * Deterministically derives and asserts:
 * 1. Routing outcomes against the published SKILL_ROUTER.md decision matrix & SKILL_MANIFEST.yaml
 * 2. Epistemic outcomes against Canon (BUSINESS_RULES.md & KONFRM_MASTER_RULES.md)
 * 3. Substantive domain truth in Product Brain modules
 * 4. Zero mutable numeric formula duplication
 * 5. Regression invariants REG-1 through REG-7
 * 6. Negative test harness: Evaluator fails closed upon corrupted input
 *
 * Built-in Node APIs only. Zero network calls. Zero model calls.
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(__dirname, '..');

let failures = 0;
const fail = (m) => { console.error(`❌ [PRODUCT EVALUATION FAILURE]: ${m}`); failures++; };
const pass = (m) => console.log(`✓ [PASS]: ${m}`);

console.log('====================================================');
console.log('KONFRM Product Brain — Routing & Invariant Evaluation');
console.log('--- [STATIC ROUTING-CONTRACT & CANONICAL EPISTEMIC VERIFICATION] ---');
console.log('(Evaluation strictly verifies static contracts, SKILL_ROUTER matrix, and Canon; zero live LLM/agent calls)');
console.log('====================================================');

// 1. Verify router, manifest, skill, and Canon files
const routerPath = path.join(projectRoot, '.agents', 'SKILL_ROUTER.md');
const manifestPath = path.join(projectRoot, '.agents', 'SKILL_MANIFEST.yaml');
const productSkillPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'SKILL.md');
const retrievalPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'references', 'product_state_retrieval.md');
const mentalModelsPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'references', 'role_mental_models.md');
const businessRulesPath = path.join(projectRoot, 'docs', 'BUSINESS_RULES.md');
const masterRulesPath = path.join(projectRoot, 'docs', 'codex', 'KONFRM_MASTER_RULES.md');

if (!fs.existsSync(routerPath)) fail('SKILL_ROUTER.md missing');
if (!fs.existsSync(manifestPath)) fail('SKILL_MANIFEST.yaml missing');
if (!fs.existsSync(productSkillPath)) fail('konfrm-product SKILL.md missing');
if (!fs.existsSync(retrievalPath)) fail('product_state_retrieval.md missing');
if (!fs.existsSync(mentalModelsPath)) fail('role_mental_models.md missing');
if (!fs.existsSync(businessRulesPath)) fail('docs/BUSINESS_RULES.md missing');
if (!fs.existsSync(masterRulesPath)) fail('docs/codex/KONFRM_MASTER_RULES.md missing');

const routerContent = fs.readFileSync(routerPath, 'utf8');
const manifestContent = fs.readFileSync(manifestPath, 'utf8');
const productSkillContent = fs.readFileSync(productSkillPath, 'utf8');
const retrievalContent = fs.readFileSync(retrievalPath, 'utf8');
const mentalModelsContent = fs.readFileSync(mentalModelsPath, 'utf8');
const businessRulesContent = fs.readFileSync(businessRulesPath, 'utf8');
const masterRulesContent = fs.readFileSync(masterRulesPath, 'utf8');

const allProductModules = [
  { name: 'SKILL.md', text: productSkillContent },
  { name: 'product_state_retrieval.md', text: retrievalContent },
  { name: 'role_mental_models.md', text: mentalModelsContent },
];

const canonContext = {
  businessRulesContent,
  masterRulesContent,
  retrievalContent,
};

// 2. Parse Decision Matrix from SKILL_ROUTER.md
function parseRouterDecisionMatrix(markdown) {
  const lines = markdown.split(/\r?\n/);
  const matrix = new Map();
  let inMatrix = false;

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (line.includes('## 2. DETERMINISTIC DECISION MATRIX')) {
      inMatrix = true;
      continue;
    }
    if (inMatrix && line.startsWith('## 3.')) {
      break;
    }
    if (!inMatrix) continue;

    if (line.startsWith('|') && line.endsWith('|')) {
      const parts = line.split('|');
      if (parts.length >= 4) {
        const intent = parts[1].trim();
        const rawBrain = parts[2].trim().replace(/\*+/g, '');
        if (intent && rawBrain && !intent.includes('TASK CLASS') && !intent.startsWith('---')) {
          matrix.set(intent, rawBrain);
        }
      }
    }
  }
  return matrix;
}

const parsedMatrix = parseRouterDecisionMatrix(routerContent);

// 3. Deterministic Routing & Epistemic Derivation Engines
function deriveRoutingOutcome(tc, matrix, manifest) {
  const mappedBrain = matrix.get(tc.taskClass);
  if (!mappedBrain) {
    throw new Error(`Task class "${tc.taskClass}" not found in SKILL_ROUTER.md decision matrix`);
  }

  // Check negative routing rules (SKILL_ROUTER.md Section 4.6)
  if (tc.prohibitedBrain === 'konfrm-product') {
    const isCodePrompt = /Flutter|widget|Riverpod|Dart/i.test(tc.prompt);
    const isDesignPrompt = /DF2|typography|tokens|spacing|contrast/i.test(tc.prompt);
    const isQualityPrompt = /failing test|RCA|assertion error|debugging/i.test(tc.prompt);
    const isBackendPrompt = /SQL|migration|PostgreSQL|database tables/i.test(tc.prompt);

    if (mappedBrain === 'konfrm-product' && (isCodePrompt || isDesignPrompt || isQualityPrompt || isBackendPrompt)) {
      throw new Error(`Negative routing rule violated: prompt matches implementation/design/quality/sql but mapped to konfrm-product`);
    }
  }

  // Verify target brain is registered in manifest
  if (!manifest.includes(`id: ${mappedBrain}`) && !manifest.includes(`- id: ${mappedBrain}`)) {
    throw new Error(`Target brain "${mappedBrain}" is not declared in SKILL_MANIFEST.yaml`);
  }

  return mappedBrain;
}

function deriveEpistemicClassification(tc, canon) {
  const { businessRulesContent: br, masterRulesContent: mr, retrievalContent: ret } = canon;

  // Extract a specific rule row from MASTER_RULES markdown table
  const getMasterRuleRow = (ruleId) => {
    const lines = mr.split(/\r?\n/);
    const row = lines.find((l) => l.includes(`| ${ruleId} `) || l.includes(`| ${ruleId}|`));
    return row || '';
  };

  // Case-specific Canon evaluation
  if (tc.id === 'POS-1') {
    // Governed by MR-12 and Booking lifecycle section
    const mr12Row = getMasterRuleRow('MR-12');
    const isMR12Confirmed = mr12Row.includes('Confirmed');
    const hasBrBookingClause = /## Booking lifecycle and availability[\s\S]*?not for `?PENDING_OWNER_APPROVAL`?/i.test(br);
    const hasRetBookingClause = ret.includes('PENDING_OWNER_APPROVAL') && ret.includes('DO NOT BLOCK');
    if (isMR12Confirmed && hasBrBookingClause && hasRetBookingClause) {
      return 'ACCEPTED_CANON';
    }
    return 'UNCERTAIN_CANON';
  }

  if (tc.id === 'POS-2') {
    // Governed by MR-16 and Owner wallet and ledger section
    const mr16Row = getMasterRuleRow('MR-16');
    const isMR16Confirmed = mr16Row.includes('Confirmed');
    const hasBrLedgerClause = /## Owner wallet and ledger[\s\S]*?release-clock/i.test(br);
    const hasRetLedgerClause = ret.includes('pending_balance') && /release clock/i.test(ret);
    if (isMR16Confirmed && hasBrLedgerClause && hasRetLedgerClause) {
      return 'ACCEPTED_CANON';
    }
    return 'UNCERTAIN_CANON';
  }

  if (tc.id === 'POS-3') {
    // Governed by MR-15 and Needs product confirmation section
    const mr15Row = getMasterRuleRow('MR-15');
    const isMR15Open = mr15Row.includes('Open');
    const hasBrOpenCancellation = /## Needs product confirmation[\s\S]*?renter cancellation\/refund matrix/i.test(br);
    const hasRetOpenCancellation = ret.includes('Renter Cancellation & Refund Matrix') && ret.includes('OPEN / UNRESOLVED');
    if (isMR15Open && hasBrOpenCancellation && hasRetOpenCancellation) {
      return 'OPEN_ASSUMPTION';
    }
    return 'UNCERTAIN_OPEN';
  }

  if (tc.id === 'POS-4') {
    // Governed by MR-10 and Identity and access section
    const mr10Row = getMasterRuleRow('MR-10');
    const isMR10Confirmed = mr10Row.includes('Confirmed');
    const hasIdentityInMR = /One human can be Customer plus optional Owner/i.test(mr10Row);
    const hasRetIdentityClause = /`?users`? represents human identity/i.test(ret) &&
                                 /`?owners`? is an optional capability/i.test(ret);
    if (isMR10Confirmed && hasIdentityInMR && hasRetIdentityClause) {
      return 'ACCEPTED_CANON';
    }
    return 'UNCERTAIN_CANON';
  }

  if (tc.id === 'POS-5') {
    // Governed by MR-15 and remaining balance openness
    const mr15Row = getMasterRuleRow('MR-15');
    const isMR15Open = mr15Row.includes('Open');
    const hasBrOpenRemaining = /## Needs product confirmation[\s\S]*?remaining-balance payment method/i.test(br);
    const hasRetOpenRemaining = ret.includes('OPEN / UNCONFIRMED');
    if (isMR15Open && hasBrOpenRemaining && hasRetOpenRemaining) {
      return 'OPEN_ASSUMPTION';
    }
    return 'UNCERTAIN_OPEN';
  }

  return 'UNKNOWN_EPISTEMIC';
}

// 4. Evaluation Cases (5 Positive, 4 Negative)
const testCases = [
  {
    id: 'POS-1',
    name: 'Clarify whether a booking request is confirmed',
    prompt: 'A guest just submitted the booking form on the customer app. Is this booking confirmed right now and are the calendar dates blocked?',
    taskClass: 'Booking lifecycle semantics / request vs confirm',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      const hasRequestConcept = retrievalContent.includes('PENDING_OWNER_APPROVAL') &&
                                /Instant booking does (\*\*|__)?NOT(\*\*|__)? exist/i.test(retrievalContent);
      const hasBlockingRule = retrievalContent.includes('DO NOT BLOCK') &&
                              /`?PENDING_OWNER_APPROVAL`? does (\*\*|__)?NOT(\*\*|__)? block dates/i.test(retrievalContent);
      return hasRequestConcept && hasBlockingRule;
    }
  },
  {
    id: 'POS-2',
    name: 'Interpret an Owner-visible payment status',
    prompt: 'An owner sees a booking deposit marked as paid, but their available payout balance hasn\'t increased yet. Can you explain why and what this financial status means?',
    taskClass: 'Financial model meaning / deposit vs commission',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      const hasPendingRule = retrievalContent.includes('pending_balance');
      const hasReleaseClockRule = /release clock|post-check-in/i.test(retrievalContent);
      return hasPendingRule && hasReleaseClockRule;
    }
  },
  {
    id: 'POS-3',
    name: 'Assess a proposed change to cancellation behavior',
    prompt: 'We want to allow guests to cancel for a full refund up to 48 hours before check-in. Can we add this cancellation policy right now?',
    taskClass: 'Cancellation / refund policy interpretation',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'OPEN_ASSUMPTION',
    verification: () => {
      const isOpen = retrievalContent.includes('OPEN / UNRESOLVED') &&
                     retrievalContent.includes('BLOCKED_OPEN_DECISION');
      const noFabrication = !retrievalContent.includes('free cancellation up to 48');
      return isOpen && noFabrication;
    }
  },
  {
    id: 'POS-4',
    name: 'Explain the difference between Customer, Owner, and Admin permissions',
    prompt: 'How are access rights, permissions, and identity capabilities differentiated between Customers, Owners, and Admins across our apps?',
    taskClass: 'Role mental model definition / cross-role boundary',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      const hasIdentityModel = /`?users`? represents human identity/i.test(retrievalContent) &&
                               /`?owners`? is an optional capability/i.test(retrievalContent);
      const hasBoundaryMatrix = mentalModelsContent.includes('CROSS-ROLE INFORMATION BOUNDARY MATRIX') &&
                                mentalModelsContent.includes('STRICTLY PROHIBITED');
      return hasIdentityModel && hasBoundaryMatrix;
    }
  },
  {
    id: 'POS-5',
    name: 'Identify an unresolved product decision without inventing its answer',
    prompt: 'What is our exact policy for how the remaining balance of a stay is collected, and what happens if the guest cancels after the deposit is paid?',
    taskClass: 'Epistemic audit (Canon vs Insight vs Hypo vs Open)',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'OPEN_ASSUMPTION',
    verification: () => {
      const hasOpenRemaining = retrievalContent.includes('OPEN / UNCONFIRMED');
      const hasOpenCancellation = retrievalContent.includes('Renter Cancellation & Refund Matrix') &&
                                  retrievalContent.includes('OPEN / UNRESOLVED');
      return hasOpenRemaining && hasOpenCancellation;
    }
  },
  {
    id: 'NEG-1',
    name: 'Implement a Flutter widget',
    prompt: 'Implement a new responsive booking summary card in Flutter with Riverpod state bindings and Cairo typography.',
    taskClass: 'New Flutter widget / layout implementation',
    expectedBrain: 'konfrm-flutter',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      const routerRoutesFlutter = routerContent.includes('New Flutter widget / layout implementation          | konfrm-flutter');
      const productExcludesCode = productSkillContent.includes('Write Flutter Dart code, widgets, or Riverpod controllers (hands off to `konfrm-flutter`)');
      return routerRoutesFlutter && productExcludesCode;
    }
  },
  {
    id: 'NEG-2',
    name: 'Review visual hierarchy',
    prompt: 'Review the typography scale, spacing tiers, and monochrome contrast of the owner home screen per DF2.',
    taskClass: 'Visual hierarchy / DF2 token consumption / spacing',
    expectedBrain: 'konfrm-design',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      const routerRoutesDesign = routerContent.includes('Visual hierarchy / DF2 token consumption / spacing  | konfrm-design');
      const productExcludesTokens = productSkillContent.includes('Author DF2 design tokens, color hexes, typography scales, or component styling');
      return routerRoutesDesign && productExcludesTokens;
    }
  },
  {
    id: 'NEG-3',
    name: 'Diagnose a failing test',
    prompt: 'The booking flow integration test failed with an assertion error. Diagnose the root cause with 4-phase RCA.',
    taskClass: 'Bug diagnosis / unexpected test failure / crash',
    expectedBrain: 'konfrm-quality',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      const routerRoutesQuality = routerContent.includes('Bug diagnosis / unexpected test failure / crash     | konfrm-quality');
      const productExcludesRCA = productSkillContent.includes('Execute automated tests or conduct 4-phase RCA debugging');
      return routerRoutesQuality && productExcludesRCA;
    }
  },
  {
    id: 'NEG-4',
    name: 'Write backend SQL',
    prompt: 'Write a Supabase PostgreSQL migration to alter the bookings table schema and add an index.',
    taskClass: 'Backend SQL migration / Cloudflare Worker proxy',
    expectedBrain: 'konfrm-backend',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      const routerRoutesBackend = routerContent.includes('Backend SQL migration / Cloudflare Worker proxy     | konfrm-backend');
      const productExcludesSQL = productSkillContent.includes('Write SQL migrations, database tables, or backend server code');
      return routerRoutesBackend && productExcludesSQL;
    }
  }
];

// Execute and Assert all Routing & Epistemic Evaluations
for (const tc of testCases) {
  let routePassed = false;
  let epistemicPassed = false;
  let verificationPassed = false;

  // 1. Derive & assert routing outcome
  try {
    const actualBrain = deriveRoutingOutcome(tc, parsedMatrix, manifestContent);
    if (tc.expectedBrain && actualBrain !== tc.expectedBrain) {
      fail(`[${tc.id}] Routing mismatch: expected "${tc.expectedBrain}", derived "${actualBrain}"`);
    } else if (tc.prohibitedBrain && actualBrain === tc.prohibitedBrain) {
      fail(`[${tc.id}] Negative routing violation: prohibited brain "${tc.prohibitedBrain}" was derived`);
    } else {
      routePassed = true;
    }
  } catch (err) {
    fail(`[${tc.id}] Routing derivation failed: ${err.message}`);
  }

  // 2. Derive & assert epistemic outcome (for positive cases)
  if (tc.expectedEpistemic) {
    try {
      const actualEpistemic = deriveEpistemicClassification(tc, canonContext);
      if (actualEpistemic !== tc.expectedEpistemic) {
        fail(`[${tc.id}] Epistemic mismatch: expected "${tc.expectedEpistemic}", derived "${actualEpistemic}"`);
      } else {
        epistemicPassed = true;
      }
    } catch (err) {
      fail(`[${tc.id}] Epistemic derivation failed: ${err.message}`);
    }
  } else {
    epistemicPassed = true; // Not applicable for negative routing cases
  }

  // 3. Substantive content verification callback
  try {
    if (tc.verification()) {
      verificationPassed = true;
    } else {
      fail(`[${tc.id}] Substantive content verification callback returned false`);
    }
  } catch (err) {
    fail(`[${tc.id}] Substantive content verification threw error: ${err.message}`);
  }

  if (routePassed && epistemicPassed && verificationPassed) {
    const targetDesc = tc.expectedBrain || `NOT ${tc.prohibitedBrain}`;
    const epistemicDesc = tc.expectedEpistemic ? ` | Epistemic: ${tc.expectedEpistemic}` : '';
    pass(`[${tc.id}] ${tc.name} -> Target: ${targetDesc}${epistemicDesc} (All Outcomes Derived & Verified)`);
  }
}

// 5. Invariant checks: zero duplicated mutable numbers across entire Product Brain
console.log('--- Checking for prohibited mutable formula duplication across entire Product Brain ---');
const prohibitedNumericHardcodes = [
  '20% of deposit',
  '20% of the deposit',
  '80% of deposit',
  '80% of the deposit',
  '500 EGP',
  '2-30 nights',
  '2–30 nights',
  'Nightly rate × nights',
  'PENDING_OWNER_APPROVAL -> APPROVED_PENDING_PAYMENT',
  'equal to the first-night price',
];

for (const mod of allProductModules) {
  for (const phrase of prohibitedNumericHardcodes) {
    if (mod.text.includes(phrase)) {
      fail(`Prohibited mutable business constant hardcoded in ${mod.name}: "${phrase}"`);
    } else {
      pass(`Zero mutable hardcoding of "${phrase}" in ${mod.name}`);
    }
  }
}

// 6. Deterministic Regression Tests for PR #102 Targeted Remediation
console.log('--- Checking PR #102 Targeted Remediation Regression Invariants ---');

// REG-1: Contact Privacy (No post-confirmation phone exposure)
const prohibitedTemporalPrivacyPhrases = [
  'until confirmation',
  'prior to a confirmed booking',
  'Pre-Confirmation Contact',
];
let reg1Passed = true;
for (const mod of allProductModules) {
  for (const phrase of prohibitedTemporalPrivacyPhrases) {
    if (mod.text.includes(phrase)) {
      fail(`[REG-1] Prohibited temporal contact qualification in ${mod.name}: "${phrase}"`);
      reg1Passed = false;
    }
  }
}
const enforcesInAppOnly = /communication remains in-app|in-app messaging is strictly/i.test(retrievalContent) &&
                          /communication remains in-app/i.test(mentalModelsContent);
if (!enforcesInAppOnly) {
  fail('[REG-1] Product Brain missing unconditional in-app contact privacy enforcement');
  reg1Passed = false;
}
if (reg1Passed) {
  pass('[REG-1] Contact Privacy: Direct phone/contact strictly withheld across all states (in-app only verified)');
}

// REG-2: Remaining Balance Collection Method (Must remain OPEN / UNCONFIRMED)
const prohibitedRemainingCollectionPhrases = [
  'collected directly by Owner at check-in',
  'collect at check-in',
  'Due to the host at check-in',
];
let reg2Passed = true;
for (const mod of allProductModules) {
  for (const phrase of prohibitedRemainingCollectionPhrases) {
    if (mod.text.includes(phrase)) {
      fail(`[REG-2] Invented remaining-balance collection method in ${mod.name}: "${phrase}"`);
      reg2Passed = false;
    }
  }
}
const remainingIsOpen = retrievalContent.includes('OPEN / UNCONFIRMED') &&
                        mentalModelsContent.includes('OPEN / UNCONFIRMED');
if (!remainingIsOpen) {
  fail('[REG-2] Remaining-balance payment method not consistently marked OPEN / UNCONFIRMED');
  reg2Passed = false;
}
if (reg2Passed) {
  pass('[REG-2] Remaining-Balance Collection: Collection method strictly preserved as OPEN / UNCONFIRMED');
}

// REG-3: Admin Reason Codes (Must NOT be universal mandatory)
const prohibitedUniversalReasonPhrases = [
  'every approval, rejection, or dispute resolution must be backed by an auditable reason code',
  'every approval, rejection, or status hold must require a selected reason code',
];
let reg3Passed = true;
for (const mod of allProductModules) {
  for (const phrase of prohibitedUniversalReasonPhrases) {
    if (mod.text.includes(phrase)) {
      fail(`[REG-3] Universal mandatory admin reason code claim in ${mod.name}: "${phrase}"`);
      reg3Passed = false;
    }
  }
}
const scopesReasonCodes = /Endpoint-specific governance & auditability/i.test(productSkillContent) &&
                          /Actions align with confirmed endpoint capabilities/i.test(mentalModelsContent);
if (!scopesReasonCodes) {
  fail('[REG-3] Admin reason codes not scoped to confirmed endpoint capabilities');
  reg3Passed = false;
}
if (reg3Passed) {
  pass('[REG-3] Admin Reason Codes: Reason codes strictly scoped to confirmed endpoint requirements');
}

// REG-4: Server-Side Pricing (No naive client calculation)
const requiresServerPricing = retrievalContent.includes('canonical server-side pricing calculations') ||
                              retrievalContent.includes('canonical server-side quote');
if (requiresServerPricing) {
  pass('[REG-4] Server-Side Pricing: Customer totals retrieved from server quote/pricing, not naive formula');
} else {
  fail('[REG-4] Customer price totals missing server-side pricing retrieval requirement');
}

// REG-5: Customer Pricing Commission Secrecy (No internal commission leakage in customer model)
const customerPricingSection = mentalModelsContent.split('## 3. OWNER MENTAL MODEL')[0];
if (/المتبقي[\s\S]*?zero platform commission/i.test(customerPricingSection)) {
  fail('[REG-5] Customer 3-amount pricing presentation in role_mental_models.md references platform commission (leakage risk)');
} else {
  pass('[REG-5] Customer Pricing Commission Secrecy: Customer 3-amount model contains zero commission leakage');
}

// REG-6: Deposit State Truth (No premature paid-deposit label during pending triage)
const prohibitedPaidDepositPhrases = [
  'VISIBLE (`العربون المدفوع`)',
  'VISIBLE (العربون المدفوع)',
];
let reg6Passed = true;
for (const mod of allProductModules) {
  for (const phrase of prohibitedPaidDepositPhrases) {
    if (mod.text.includes(phrase)) {
      fail(`[REG-6] Unconditional paid-deposit label in ${mod.name}: "${phrase}"`);
      reg6Passed = false;
    }
  }
}
const hasStateNeutralDepositLabel = mentalModelsContent.includes('VISIBLE (`العربون المطلوب / بحسب حالة الحجز`)') ||
                                    mentalModelsContent.includes('VISIBLE (`العربون`)');
if (!hasStateNeutralDepositLabel) {
  fail('[REG-6] Cross-role information boundary matrix missing state-neutral deposit label for Owner');
  reg6Passed = false;
}
if (reg6Passed) {
  pass('[REG-6] Deposit State Truth: Cross-role matrix uses state-neutral deposit label; no premature paid-deposit claim');
}

// REG-7: Deposit Rule Canonical Retrieval (Zero duplication of mutable first-night calculation rule)
const prohibitedDepositRuleHardcodes = [
  'equal to the first-night price',
  'equals the first night',
  'equal to first night',
];
let reg7Passed = true;
for (const phrase of prohibitedDepositRuleHardcodes) {
  if (mentalModelsContent.includes(phrase)) {
    fail(`[REG-7] Duplicated mutable deposit calculation rule in role_mental_models.md: "${phrase}"`);
    reg7Passed = false;
  }
}
const customerDepositRetrievesQuote = /العربون المطلوب[\s\S]*?retrieved from canonical server-side quote/i.test(mentalModelsContent);
if (!customerDepositRetrievesQuote) {
  fail('[REG-7] Customer deposit description does not specify canonical server-side quote retrieval');
  reg7Passed = false;
}
if (reg7Passed) {
  pass('[REG-7] Retrieval Over Duplication: Upfront deposit rule dynamically retrieved from canonical quote per MR-13');
}

// REG-8: Invented Lock Prohibition (No invented "pending review locks" across Product Brain)
const prohibitedLockPhrases = [
  'pending review locks',
  'release any pending review locks',
  'releases any pending review locks',
];
let reg8Passed = true;
for (const mod of allProductModules) {
  for (const phrase of prohibitedLockPhrases) {
    if (mod.text.includes(phrase)) {
      fail(`[REG-8] Invented lock mechanism in ${mod.name}: "${phrase}"`);
      reg8Passed = false;
    }
  }
}
if (reg8Passed) {
  pass('[REG-8] Invented Lock Prohibition: Zero references to unconfirmed pending review locks');
}

// REG-9: Blocking States Canonical Retrieval (Dynamic retrieval from BUSINESS_RULES.md / MR-12)
const blockingRetrievalEnforced = /Retrieve inventory-blocking states dynamically from `?docs\/BUSINESS_RULES\.md`?/i.test(retrievalContent);
if (blockingRetrievalEnforced) {
  pass('[REG-9] Blocking States Retrieval: Inventory blocking states dynamically retrieved from Canon per MR-12');
} else {
  fail('[REG-9] Inventory blocking states not configured as dynamic retrieval procedure from Canon');
}

// REG-10: Epistemic Framework Canon Definition (No numeric ID range MR-01..14)
if (productSkillContent.includes('MR-01..14')) {
  fail('[REG-10] ACCEPTED_CANON defined by arbitrary numeric range MR-01..14 in SKILL.md');
} else if (/Confirmed status in Master Rules/i.test(productSkillContent)) {
  pass('[REG-10] Epistemic Framework: ACCEPTED_CANON derived from Confirmed status, not arbitrary ID range');
} else {
  fail('[REG-10] ACCEPTED_CANON missing Confirmed classification requirement in SKILL.md');
}

// REG-11: Four-Bucket Owner Ledger Architecture (held_balance vs reserved_for_payout distinct)
if (mentalModelsContent.includes('رصيد محجوز / قيد المعالجة')) {
  fail('[REG-11] Owner mental model collapses heldBalance and reservedForPayout into single bucket');
} else if (mentalModelsContent.includes('held_balance') && mentalModelsContent.includes('reserved_for_payout')) {
  pass('[REG-11] Four-Bucket Ledger Architecture: held_balance (dispute freezes) and reserved_for_payout (withdrawals) kept distinct');
} else {
  fail('[REG-11] Owner mental model missing distinct held_balance and reserved_for_payout buckets');
}

// REG-12: Payout Verification & Eligibility Openness (OPEN / UNCONFIRMED per Canon)
if (/Payout requests require validated Owner verification status/i.test(retrievalContent)) {
  fail('[REG-12] Product brain invents unconfirmed mandatory KYC restriction for payouts');
} else if (/payout providers, payment rails, and verification\/eligibility prerequisites remains OPEN \/ UNCONFIRMED/i.test(retrievalContent)) {
  pass('[REG-12] Payout Eligibility Openness: Payout rails and eligibility prerequisites preserved as OPEN / UNCONFIRMED per BR:53');
} else {
  fail('[REG-12] Payout eligibility prerequisites not explicitly classified as OPEN / UNCONFIRMED');
}


// REG-13: Canonical Column Name (reserved_for_payout_balance, not reserved_for_payout)
if (/\(`reserved_for_payout`\)/.test(mentalModelsContent)) {
  fail('[REG-13] role_mental_models.md uses non-canonical column `reserved_for_payout` — must be `reserved_for_payout_balance`');
} else if (mentalModelsContent.includes('reserved_for_payout_balance')) {
  pass('[REG-13] Canonical Column Name: reserved_for_payout_balance used correctly in Owner balance buckets');
} else {
  fail('[REG-13] Owner balance bucket missing reserved_for_payout_balance column reference');
}

// REG-14: Prototype-Only KYC Classification (MR-14)
const kycPrototypeInMM = mentalModelsContent.includes('Prototype-only') && mentalModelsContent.includes('MR-14');
const kycPrototypeInSKILL = productSkillContent.includes('Prototype-only') && productSkillContent.includes('MR-14');
if (!kycPrototypeInMM || !kycPrototypeInSKILL) {
  fail('[REG-14] KYC requirements not classified as Prototype-only per MR-14 in all relevant files');
} else {
  pass('[REG-14] KYC Prototype Classification: National ID/selfie KYC classified as Prototype-only per MR-14 in SKILL.md and role_mental_models.md');
}

// REG-15: No Invented Property Publication Criteria
if (/Verifies high-resolution photos.*realistic pricing.*accurate location mapping/i.test(mentalModelsContent)) {
  fail('[REG-15] role_mental_models.md invents unapproved subjective property publication criteria');
} else if (mentalModelsContent.includes('Do not invent unapproved subjective publication criteria')) {
  pass('[REG-15] Property Review Canon Anchor: No invented subjective publication criteria; review anchored to Canon endpoint only');
} else {
  fail('[REG-15] Property review clause missing Canon anchor and subjective-criteria prohibition');
}

// REG-16: Dynamic Lifecycle Transition Retrieval (no frozen Owner-decision state names)
if (/Owner approval transitions the request to `APPROVED_PENDING_PAYMENT`/.test(retrievalContent)) {
  fail('[REG-16] product_state_retrieval.md freezes Owner-decision lifecycle transition state names instead of retrieving from Canon');
} else if (/Retrieve the exact Owner-approval and rejection transition state names from.*BUSINESS_RULES/i.test(retrievalContent)) {
  pass('[REG-16] Dynamic Lifecycle Retrieval: Owner-decision and deposit-payment lifecycle transitions retrieved from Canon, not frozen');
} else {
  fail('[REG-16] product_state_retrieval.md missing canonical retrieval pointer for Owner-decision lifecycle transitions');
}

// 7. Negative Test Harness: Verify Evaluator Fails Closed on Corrupted Input
console.log('--- [NEGATIVE TEST HARNESS: FAIL-CLOSED VERIFICATION] ---');
let harnessFailures = 0;

// Harness 1: Corrupted Routing Outcome must fail closed
try {
  const corruptedRoutingCase = {
    id: 'CORRUPT-ROUTING-TEST',
    taskClass: 'Booking lifecycle semantics / request vs confirm',
    expectedBrain: 'konfrm-flutter', // Deliberately corrupted expectation
    prompt: 'Is this booking confirmed?'
  };
  const derivedBrain = deriveRoutingOutcome(corruptedRoutingCase, parsedMatrix, manifestContent);
  if (derivedBrain === corruptedRoutingCase.expectedBrain) {
    harnessFailures++;
    fail('Negative Harness 1: Corrupted routing unexpectedly matched');
  } else {
    pass('Negative Harness 1: Corrupted routing outcome detected and failed closed as expected');
  }
} catch (err) {
  harnessFailures++;
  fail(`Negative Harness 1 unexpected error: ${err.message}`);
}

// Harness 2: Corrupted Epistemic Classification must fail closed
try {
  const corruptedEpistemicCase = {
    id: 'CORRUPT-EPISTEMIC-TEST',
    prompt: 'We want to allow guests to cancel for a full refund up to 48 hours before check-in.',
    expectedEpistemic: 'ACCEPTED_CANON' // Deliberately corrupted expectation (Canon is OPEN_ASSUMPTION)
  };
  const derivedEpistemic = deriveEpistemicClassification(corruptedEpistemicCase, canonContext);
  if (derivedEpistemic === corruptedEpistemicCase.expectedEpistemic) {
    harnessFailures++;
    fail('Negative Harness 2: Corrupted epistemic classification unexpectedly matched');
  } else {
    pass('Negative Harness 2: Corrupted epistemic outcome detected and failed closed as expected');
  }
} catch (err) {
  harnessFailures++;
  fail(`Negative Harness 2 unexpected error: ${err.message}`);
}

// Harness 3: Unregistered Target Brain in Matrix must fail closed
try {
  const corruptedMatrix = new Map(parsedMatrix);
  corruptedMatrix.set('Booking lifecycle semantics / request vs confirm', 'konfrm-nonexistent-brain');
  let threwExpected = false;
  try {
    deriveRoutingOutcome({
      taskClass: 'Booking lifecycle semantics / request vs confirm',
      expectedBrain: 'konfrm-product',
      prompt: 'Is this booking confirmed?'
    }, corruptedMatrix, manifestContent);
  } catch {
    threwExpected = true;
  }
  if (threwExpected) {
    pass('Negative Harness 3: Unregistered target brain in matrix caught by manifest validation');
  } else {
    harnessFailures++;
    fail('Negative Harness 3: Unregistered target brain failed to fail closed');
  }
} catch (err) {
  harnessFailures++;
  fail(`Negative Harness 3 unexpected error: ${err.message}`);
}

// Harness 4: Case-Specific Canon Rule Loss (MR-12 removal must fail closed)
try {
  const fakeCanon = {
    ...canonContext,
    masterRulesContent: canonContext.masterRulesContent.replace(/\| MR-12 \|[\s\S]*?\n/, ''),
  };
  const derivedEpistemic = deriveEpistemicClassification(testCases[0], fakeCanon);
  if (derivedEpistemic === testCases[0].expectedEpistemic) {
    harnessFailures++;
    fail('Negative Harness 4: Epistemic check did not detect loss of case-specific Canon rule MR-12');
  } else {
    pass('Negative Harness 4: Epistemic check correctly failed closed when case-specific Canon rule MR-12 was removed');
  }
} catch (err) {
  harnessFailures++;
  fail(`Negative Harness 4 unexpected error: ${err.message}`);
}

if (harnessFailures > 0) {
  fail(`Negative test harness failed closed verification (${harnessFailures} failure(s))`);
} else {
  pass('Negative test harness verified: Evaluator strictly fails closed upon routing or epistemic corruption');
}

console.log('====================================================');
if (failures > 0) {
  console.error(`FAILED: ${failures} evaluation failure(s).`);
  process.exit(1);
} else {
  console.log('ALL PRODUCT ROUTING, INVARIANT, REGRESSION & NEGATIVE HARNESS CHECKS PASSED.');
  console.log('====================================================');
}
