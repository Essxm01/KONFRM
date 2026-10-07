#!/usr/bin/env node
/**
 * KONFRM Product Brain — Routing & Domain Truth Contract Test
 *
 * Deterministically tests the 5 Positive and 4 Negative evaluation cases
 * required by KONFRM Engineering Intelligence Stage F.
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
console.log('====================================================');

// 1. Verify router and skill files
const routerPath = path.join(projectRoot, '.agents', 'SKILL_ROUTER.md');
const manifestPath = path.join(projectRoot, '.agents', 'SKILL_MANIFEST.yaml');
const productSkillPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'SKILL.md');
const retrievalPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'references', 'product_state_retrieval.md');
const mentalModelsPath = path.join(projectRoot, '.agents', 'skills', 'konfrm-product', 'references', 'role_mental_models.md');

if (!fs.existsSync(routerPath)) fail('SKILL_ROUTER.md missing');
if (!fs.existsSync(manifestPath)) fail('SKILL_MANIFEST.yaml missing');
if (!fs.existsSync(productSkillPath)) fail('konfrm-product SKILL.md missing');
if (!fs.existsSync(retrievalPath)) fail('product_state_retrieval.md missing');
if (!fs.existsSync(mentalModelsPath)) fail('role_mental_models.md missing');

const routerContent = fs.readFileSync(routerPath, 'utf8');
const productSkillContent = fs.readFileSync(productSkillPath, 'utf8');
const retrievalContent = fs.readFileSync(retrievalPath, 'utf8');
const mentalModelsContent = fs.readFileSync(mentalModelsPath, 'utf8');

// 2. Evaluation Cases
const testCases = [
  {
    id: 'POS-1',
    name: 'Clarify whether a booking request is confirmed',
    prompt: 'A guest just submitted the booking form on the customer app. Is this booking confirmed right now and are the calendar dates blocked?',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      // Must state booking is a request awaiting owner review; dates not blocked until approved
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
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      // Must state deposit credits pending balance initially; released 24h after check-in
      const hasPendingRule = retrievalContent.includes('pending_balance');
      const has24hRule = retrievalContent.includes('24 hours after check-in');
      return hasPendingRule && has24hRule;
    }
  },
  {
    id: 'POS-3',
    name: 'Assess a proposed change to cancellation behavior',
    prompt: 'We want to allow guests to cancel for a full refund up to 48 hours before check-in. Can we add this cancellation policy right now?',
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'OPEN_ASSUMPTION',
    verification: () => {
      // Must flag renter cancellation as open and forbid arbitrary 48h full refund invention
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
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'ACCEPTED_CANON',
    verification: () => {
      // Must differentiate human identity users from optional owners, and enforce boundary matrix
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
    expectedBrain: 'konfrm-product',
    expectedEpistemic: 'OPEN_ASSUMPTION',
    verification: () => {
      // Must identify remaining payment method and renter cancellation as open
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
    expectedBrain: 'konfrm-flutter',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      // Router routes widget implementation to konfrm-flutter, product brain excludes code
      const routerRoutesFlutter = routerContent.includes('New Flutter widget / layout implementation          | konfrm-flutter');
      const productExcludesCode = productSkillContent.includes('Write Flutter Dart code, widgets, or Riverpod controllers (hands off to `konfrm-flutter`)');
      return routerRoutesFlutter && productExcludesCode;
    }
  },
  {
    id: 'NEG-2',
    name: 'Review visual hierarchy',
    prompt: 'Review the typography scale, spacing tiers, and monochrome contrast of the owner home screen per DF2.',
    expectedBrain: 'konfrm-design',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      // Router routes visual hierarchy to konfrm-design, product brain excludes tokens/styles
      const routerRoutesDesign = routerContent.includes('Visual hierarchy / DF2 token consumption / spacing  | konfrm-design');
      const productExcludesTokens = productSkillContent.includes('Author DF2 design tokens, color hexes, typography scales, or component styling');
      return routerRoutesDesign && productExcludesTokens;
    }
  },
  {
    id: 'NEG-3',
    name: 'Diagnose a failing test',
    prompt: 'The booking flow integration test failed with an assertion error. Diagnose the root cause with 4-phase RCA.',
    expectedBrain: 'konfrm-quality',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      // Router routes test diagnosis to konfrm-quality, product brain excludes RCA execution
      const routerRoutesQuality = routerContent.includes('Bug diagnosis / unexpected test failure / crash     | konfrm-quality');
      const productExcludesRCA = productSkillContent.includes('Execute automated tests or conduct 4-phase RCA debugging');
      return routerRoutesQuality && productExcludesRCA;
    }
  },
  {
    id: 'NEG-4',
    name: 'Write backend SQL',
    prompt: 'Write a Supabase PostgreSQL migration to alter the bookings table schema and add an index.',
    expectedBrain: 'konfrm-backend',
    prohibitedBrain: 'konfrm-product',
    verification: () => {
      // Router routes SQL to konfrm-backend, product brain excludes SQL migrations
      const routerRoutesBackend = routerContent.includes('Backend SQL migration / Cloudflare Worker proxy     | konfrm-backend');
      const productExcludesSQL = productSkillContent.includes('Write SQL migrations, database tables, or backend server code');
      return routerRoutesBackend && productExcludesSQL;
    }
  }
];

// 3. Execute all evaluations
for (const tc of testCases) {
  const result = tc.verification();
  if (result) {
    pass(`[${tc.id}] ${tc.name} -> Target: ${tc.expectedBrain || tc.prohibitedBrain} (Rule Verified)`);
  } else {
    fail(`[${tc.id}] ${tc.name} failed verification`);
  }
}

// 4. Invariant checks: zero duplicated mutable formulas in root SKILL.md
console.log('--- Checking for prohibited mutable formula duplication in root SKILL.md ---');
const prohibitedHardcodes = [
  '20% of deposit',
  '80% of deposit',
  '500 EGP',
  '2-30 nights',
  'PENDING_OWNER_APPROVAL -> APPROVED_PENDING_PAYMENT',
];
for (const phrase of prohibitedHardcodes) {
  if (productSkillContent.includes(phrase)) {
    fail(`Prohibited mutable business constant hardcoded in root SKILL.md: "${phrase}"`);
  } else {
    pass(`Zero mutable hardcoding of "${phrase}" in root SKILL.md`);
  }
}

console.log('====================================================');
if (failures > 0) {
  console.error(`FAILED: ${failures} evaluation failure(s).`);
  process.exit(1);
} else {
  console.log('ALL 9 PRODUCT ROUTING & EVALUATION CASES PASSED.');
  console.log('====================================================');
}
