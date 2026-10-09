#!/usr/bin/env node
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import assert from 'node:assert/strict';
import {fileURLToPath} from 'node:url';
import {
  validateProject,
  validatePatternGrammar,
  patternsOverlap,
  appendDecisionEvent
} from './check-konfrm-focus.mjs';

const base = fileURLToPath(new URL('../', import.meta.url));
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'konfrm-focus-'));
const src = path.join(base, 'docs/focus');
const dst = path.join(tmp, 'docs/focus');
fs.mkdirSync(path.dirname(dst), {recursive: true});
fs.cpSync(src, dst, {recursive: true});

const file = n => path.join(dst, n);
const read = n => JSON.parse(fs.readFileSync(file(n), 'utf8'));
const write = (n, v) => fs.writeFileSync(file(n), JSON.stringify(v, null, 2) + '\n');

let count = 0;
const names = ['FOCUS_NOW.json', 'IDEA_INBOX.json', 'EXECUTION_QUEUE.json', 'DECISION_LEDGER.jsonl'];

function negative(name, mutate, expected) {
  const old = Object.fromEntries(names.map(n => [n, fs.readFileSync(file(n), 'utf8')]));
  try {
    mutate();
    const e = validateProject(tmp);
    assert.ok(e.some(s => s.includes(expected)), name + ' expected [' + expected + '] got [' + e.join('; ') + ']');
    console.log('PASS negative: ' + name);
    count++;
  } finally {
    for (const [n, v] of Object.entries(old)) fs.writeFileSync(file(n), v);
  }
}

try {
  // Unit tests for pattern grammar
  assert.equal(validatePatternGrammar('mobile/apps/customer_app/**').valid, true);
  assert.equal(validatePatternGrammar('docs/focus/README.md').valid, true);
  assert.equal(validatePatternGrammar('').valid, false);
  assert.equal(validatePatternGrammar('  path/**').valid, false);
  assert.equal(validatePatternGrammar('/absolute/**').valid, false);
  assert.equal(validatePatternGrammar('path/../traversal/**').valid, false);
  assert.equal(validatePatternGrammar('*.dart').valid, false);
  assert.equal(validatePatternGrammar('path/*/dir/**').valid, false);
  assert.equal(validatePatternGrammar('**').valid, false);
  assert.equal(patternsOverlap('mobile/apps/customer_app/**', 'mobile/apps/customer_app/pubspec.yaml'), true);
  assert.equal(patternsOverlap('mobile/apps/customer_app/**', 'docs/focus/**'), false);
  console.log('PASS: pattern grammar unit tests');
  count++;

  // Baseline test: verified candidate configuration passes
  assert.deepEqual(validateProject(tmp), []);
  count++;
  console.log('PASS baseline: Founder-authorized Codex (PR #111) + Antigravity (PR #106) + read-only Bridge');

  // Negative: pattern traversal rejected
  negative('pattern traversal rejected', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['docs/../outside/**'];
    write('FOCUS_NOW.json', x);
  }, 'path traversal rejected');

  // Negative: absolute path pattern rejected
  negative('absolute path pattern rejected', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['/etc/passwd'];
    write('FOCUS_NOW.json', x);
  }, 'absolute path rejected');

  // Negative: unsupported wildcard glob rejected
  negative('unsupported wildcard glob rejected', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['docs/**/*.ts'];
    write('FOCUS_NOW.json', x);
  }, 'unsupported glob');

  // Negative: broad claim ** rejected
  negative('broad claim ** rejected', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['**'];
    write('FOCUS_NOW.json', x);
  }, 'ambiguous broad claim rejected');

  // Negative: primary lane claiming protected canonical path
  negative('primary lane claiming protected canonical path', () => {
    let x = read('FOCUS_NOW.json');
    x.active.exclusive_writable_surfaces = ['tasks/CURRENT_TASK.md'];
    write('FOCUS_NOW.json', x);
  }, 'unauthorized claim on protected canonical path');

  // Negative: parallel lane claiming protected canonical path
  negative('parallel lane claiming protected canonical path', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['tasks/**'];
    write('FOCUS_NOW.json', x);
  }, 'unauthorized canonical state modification');

  // Negative: conflicting file ownership between primary and parallel lane
  negative('conflicting file ownership with primary lane', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['mobile/apps/customer_app/**'];
    write('FOCUS_NOW.json', x);
  }, 'conflicting file ownership');

  // Negative: second active task in additional_active_tasks (WIP violation)
  negative('second active task in additional_active_tasks', () => {
    let x = read('FOCUS_NOW.json');
    x.additional_active_tasks = [{task_id: 'other'}];
    write('FOCUS_NOW.json', x);
  }, 'WIP violation');

  // Negative: unapproved parallel lane (missing founder authorization)
  negative('unapproved parallel lane', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes.push({
      lane_id: 'LANE-UNAPPROVED',
      title: 'Unauthorized rogue workstream',
      status: 'ACTIVE',
      lane_role: 'UNAUTHORIZED_WORK',
      agent_role: 'RogueAgent',
      worktree: 'ROGUE-WORKTREE',
      exclusive_writable_surfaces: ['docs/rogue/**'],
      completion_gate: 'None',
      next_action: 'None'
    });
    write('FOCUS_NOW.json', x);
  }, 'unauthorized parallel lane');

  // Negative: same agent assigned multiple active tasks
  negative('same agent assigned multiple active tasks', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes.push({
      lane_id: 'LANE-DOUBLE-ASSIGN',
      title: 'Second task for Antigravity',
      status: 'ACTIVE',
      lane_role: 'PROCESS_TOOLING_HARDENING',
      agent_role: 'Antigravity',
      worktree: 'SEPARATE-WORKTREE',
      exclusive_writable_surfaces: ['docs/extra/**'],
      founder_authorization: {
        authority: 'Founder explicit',
        date: '2026-10-09',
        evidence: 'DIRECTIVE'
      },
      completion_gate: 'Done',
      next_action: 'Next'
    });
    write('FOCUS_NOW.json', x);
  }, 'assigned multiple active tasks');

  // Negative: finished PR treated as active work
  negative('finished PR treated as active work', () => {
    let x = read('FOCUS_NOW.json');
    x.active.pr = 105;
    write('FOCUS_NOW.json', x);
  }, 'finished PR treated as active work');

  // Negative: ledger revision mismatch
  negative('ledger revision mismatch', () => {
    let x = read('FOCUS_NOW.json');
    x.ledger_revision = 99; // actual is 3
    write('FOCUS_NOW.json', x);
  }, 'ledger revision mismatch');

  // Negative: concurrent focus-ledger writes duplicate event ID
  negative('concurrent focus-ledger duplicate event ID', () => {
    fs.appendFileSync(file('DECISION_LEDGER.jsonl'), JSON.stringify({
      event_id: 'DEC-20261008-001',
      date: '2026-10-09',
      kind: 'CONCURRENT_COLLISION',
      record_id: 'IDEA-20261008-001',
      authority: 'Concurrent Agent',
      status: 'COLLISION'
    }) + '\n');
  }, 'duplicate decision ID');

  // Real Concurrency Test: appendDecisionEvent with revision check
  {
    const oldLedger = fs.readFileSync(file('DECISION_LEDGER.jsonl'), 'utf8');
    const oldNow = fs.readFileSync(file('FOCUS_NOW.json'), 'utf8');
    try {
      const initialRev = 3;
      // Agent 1 appends with expectedRevision = 3 (succeeds)
      const res1 = appendDecisionEvent({
        event_id: 'DEC-20261009-TEST1',
        date: '2026-10-09',
        kind: 'TEST_CONCURRENCY',
        record_id: 'LANE-ADHD-HARDENING',
        authority: 'Agent 1',
        status: 'OK'
      }, initialRev, tmp);
      assert.equal(res1.success, true);
      assert.equal(res1.newRevision, 4);

      // Agent 2 attempts to append with stale expectedRevision = 3 (fails closed)
      const res2 = appendDecisionEvent({
        event_id: 'DEC-20261009-TEST2',
        date: '2026-10-09',
        kind: 'TEST_CONCURRENCY',
        record_id: 'LANE-ADHD-HARDENING',
        authority: 'Agent 2',
        status: 'CONFLICT'
      }, initialRev, tmp);
      assert.equal(res2.success, false);
      assert.ok(res2.error.includes('CONCURRENCY_CONFLICT'));
      console.log('PASS: real concurrency test (stale revision write aborted)');
      count++;
    } finally {
      fs.writeFileSync(file('DECISION_LEDGER.jsonl'), oldLedger);
      fs.writeFileSync(file('FOCUS_NOW.json'), oldNow);
    }
  }

  // Negative: unapproved idea queued
  negative('unapproved idea queued', () => {
    let x = read('EXECUTION_QUEUE.json');
    x.queue.push({idea_id: 'IDEA-20261008-002', phase_slot: 'PHASE_5_GUEST_UX', status: 'READY', dependencies: []});
    write('EXECUTION_QUEUE.json', x);
  }, 'unapproved idea in queue');

  // Negative: unapproved priority promotion
  negative('unapproved priority promotion', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[1].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
  }, 'unapproved idea advanced');

  // Negative: Phase 8 bypass R2-R5
  negative('Phase 8 bypass R2-R5', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].phase_slot = 'PHASE_8_PLUS';
    x.entries[0].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
    let y = read('EXECUTION_QUEUE.json');
    y.queue = [{idea_id: x.entries[0].id, phase_slot: 'PHASE_8_PLUS', status: 'READY', dependencies: []}];
    write('EXECUTION_QUEUE.json', y);
  }, 'Phase 8+ gate absent');

  // Negative: duplicate idea
  negative('duplicate idea', () => {
    let x = read('IDEA_INBOX.json');
    x.entries.push({...x.entries[0]});
    write('IDEA_INBOX.json', x);
  }, 'duplicate idea ID');

  // Negative: duplicate normalized title
  negative('duplicate normalized title', () => {
    let x = read('IDEA_INBOX.json');
    const cp = {...x.entries[1], id: 'IDEA-20261008-099'};
    x.entries.push(cp);
    write('IDEA_INBOX.json', x);
  }, 'possible duplicate title');

  // Negative: fake current evidence
  negative('fake current evidence', () => {
    let x = read('FOCUS_NOW.json');
    x.verification = 'CURRENT_WITH_EVIDENCE';
    write('FOCUS_NOW.json', x);
  }, 'evidence_url');

  // Negative: fake queue approval without event
  negative('fake queue approval without event', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
    let q = read('EXECUTION_QUEUE.json');
    q.queue = [{idea_id: x.entries[0].id, phase_slot: x.entries[0].phase_slot, status: 'READY', dependencies: []}];
    write('EXECUTION_QUEUE.json', q);
  }, 'queue approval needs recorded Founder decision event');

  // Negative: orphan decision
  negative('orphan decision', () => {
    fs.appendFileSync(file('DECISION_LEDGER.jsonl'), JSON.stringify({
      event_id: 'x',
      authority: 'QA',
      date: '2026-10-08',
      status: 'X',
      record_id: 'IDEA-20000101-001'
    }) + '\n');
  }, 'orphan decision');

  // Negative: execution without queue approval
  negative('execution without queue approval', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].approval.execution_approved = true;
    write('IDEA_INBOX.json', x);
  }, 'execution requires queue approval');

  // Realistic priority switch preservation test (FOCUS-19):
  // When switching primary product priority with full preservation of prior task, validation passes cleanly.
  {
    const oldNow = read('FOCUS_NOW.json');
    try {
      let x = read('FOCUS_NOW.json');
      // Founder switches priority to a new Mission 03, properly archiving Mission 02 into preserved_previous_task
      const preservedMission02 = {...x.active, status: 'PRESERVED_HANDOFF'};
      x.preserved_previous_task = preservedMission02;
      x.active = {
        task_id: 'PHASE_5_MISSION_03_PROPERTY_DETAILS',
        title: 'Phase 5 / Mission 03 — Customer Property Details & Booking Summary',
        status: 'ACTIVE',
        lane_role: 'PRIMARY_PRODUCT_DELIVERY',
        agent_role: 'Codex',
        worktree: 'customer-flutter-property-details',
        pr: 112,
        branch: 'feat/customer-flutter-property-details',
        remote_status: 'DRAFT_PR_OPEN',
        surface: 'mobile/apps/customer_app/**',
        exclusive_writable_surfaces: ['mobile/apps/customer_app/**'],
        last_known_remote_head: '5c97ab19ed6da3b1a6ecddf7dbf129c059c86811',
        last_known_main_head: '5c97ab19ed6da3b1a6ecddf7dbf129c059c86811',
        unverified_local_state: true,
        completion_gate: 'Passing widget tests and offline mocks',
        next_action: 'Begin implementation'
      };
      write('FOCUS_NOW.json', x);
      assert.deepEqual(validateProject(tmp), []);
      console.log('PASS: priority switch preserves prior task data without loss');
      count++;
    } finally {
      write('FOCUS_NOW.json', oldNow);
    }
  }

  // Confirm baseline state is completely restored
  assert.deepEqual(validateProject(tmp), []);
  console.log(`ALL TESTS PASS: ${count} assertions executed cleanly`);
} catch (e) {
  console.error('TEST FAILURE:', e);
  process.exitCode = 1;
} finally {
  fs.rmSync(tmp, {recursive: true, force: true});
}
