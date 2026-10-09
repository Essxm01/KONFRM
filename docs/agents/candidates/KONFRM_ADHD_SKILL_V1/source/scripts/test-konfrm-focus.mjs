#!/usr/bin/env node
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import assert from 'node:assert/strict';
import {fileURLToPath} from 'node:url';
import {validateProject} from './check-konfrm-focus.mjs';

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
  // Baseline test: verified candidate configuration passes
  assert.deepEqual(validateProject(tmp), []);
  count++;
  console.log('PASS baseline: Founder-authorized Codex + Antigravity parallel lanes');

  // Negative 1: second active task in additional_active_tasks (WIP violation)
  negative('second active task', () => {
    let x = read('FOCUS_NOW.json');
    x.additional_active_tasks = [{task_id: 'other'}];
    write('FOCUS_NOW.json', x);
  }, 'WIP violation');

  // Negative 2: unapproved parallel lane (missing founder authorization)
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

  // Negative 3: conflicting file ownership between parallel lanes
  negative('conflicting file ownership', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes.push({
      lane_id: 'LANE-COLLIDING',
      title: 'Colliding Flutter lane',
      status: 'ACTIVE',
      lane_role: 'PARALLEL_DEV',
      agent_role: 'ParallelAgent',
      worktree: 'PARALLEL-WORKTREE',
      exclusive_writable_surfaces: ['mobile/apps/customer_app/**'],
      founder_authorization: {
        authority: 'Founder explicit',
        date: '2026-10-09',
        evidence: 'DIRECTIVE'
      },
      completion_gate: 'Done',
      next_action: 'Next'
    });
    write('FOCUS_NOW.json', x);
  }, 'conflicting file ownership');

  // Negative 4: same agent assigned multiple active tasks
  negative('same agent assigned multiple active tasks', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes.push({
      lane_id: 'LANE-DOUBLE-ASSIGN',
      title: 'Second task for Antigravity',
      status: 'ACTIVE',
      lane_role: 'SECOND_TASK',
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

  // Negative 5: unauthorized canonical state modification
  negative('unauthorized canonical state modification', () => {
    let x = read('FOCUS_NOW.json');
    x.authorized_parallel_lanes[0].exclusive_writable_surfaces = ['tasks/CURRENT_TASK.md'];
    write('FOCUS_NOW.json', x);
  }, 'unauthorized canonical state modification');

  // Negative 6: finished PR treated as active work
  negative('finished PR treated as active work', () => {
    let x = read('FOCUS_NOW.json');
    x.active.pr = 105;
    write('FOCUS_NOW.json', x);
  }, 'finished PR treated as active work');

  // Negative 7: concurrent focus-ledger writes / duplicate event ID
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

  // Negative 8: unapproved idea queued
  negative('unapproved idea queued', () => {
    let x = read('EXECUTION_QUEUE.json');
    x.queue.push({idea_id: 'IDEA-20261008-002', phase_slot: 'PHASE_5_GUEST_UX', status: 'READY', dependencies: []});
    write('EXECUTION_QUEUE.json', x);
  }, 'unapproved idea in queue');

  // Negative 9: unapproved priority promotion
  negative('unapproved priority promotion', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[1].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
  }, 'unapproved idea advanced');

  // Negative 10: Phase 8 bypass R2-R5
  negative('Phase 8 bypass R2-R5', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].phase_slot = 'PHASE_8_PLUS';
    x.entries[0].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
    let y = read('EXECUTION_QUEUE.json');
    y.queue = [{idea_id: x.entries[0].id, phase_slot: 'PHASE_8_PLUS', status: 'READY', dependencies: []}];
    write('EXECUTION_QUEUE.json', y);
  }, 'Phase 8+ gate absent');

  // Negative 11: duplicate idea
  negative('duplicate idea', () => {
    let x = read('IDEA_INBOX.json');
    x.entries.push({...x.entries[0]});
    write('IDEA_INBOX.json', x);
  }, 'duplicate idea ID');

  // Negative 12: duplicate normalized title
  negative('duplicate normalized title', () => {
    let x = read('IDEA_INBOX.json');
    const cp = {...x.entries[1], id: 'IDEA-20261008-099'};
    x.entries.push(cp);
    write('IDEA_INBOX.json', x);
  }, 'possible duplicate title');

  // Negative 13: fake current evidence
  negative('fake current evidence', () => {
    let x = read('FOCUS_NOW.json');
    x.verification = 'CURRENT_WITH_EVIDENCE';
    write('FOCUS_NOW.json', x);
  }, 'evidence_url');

  // Negative 14: fake queue approval without event
  negative('fake queue approval without event', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].approval.queue_approved = true;
    write('IDEA_INBOX.json', x);
    let q = read('EXECUTION_QUEUE.json');
    q.queue = [{idea_id: x.entries[0].id, phase_slot: x.entries[0].phase_slot, status: 'READY', dependencies: []}];
    write('EXECUTION_QUEUE.json', q);
  }, 'queue approval needs recorded Founder decision event');

  // Negative 15: orphan decision
  negative('orphan decision', () => {
    fs.appendFileSync(file('DECISION_LEDGER.jsonl'), JSON.stringify({
      event_id: 'x',
      authority: 'QA',
      date: '2026-10-08',
      status: 'X',
      record_id: 'IDEA-20000101-001'
    }) + '\n');
  }, 'orphan decision');

  // Negative 16: execution without queue approval
  negative('execution without queue approval', () => {
    let x = read('IDEA_INBOX.json');
    x.entries[0].approval.execution_approved = true;
    write('IDEA_INBOX.json', x);
  }, 'execution requires queue approval');

  // Negative 17: unsupported active priority state on switch
  negative('unsupported active priority state on switch', () => {
    let x = read('FOCUS_NOW.json');
    x.active = null;
    write('FOCUS_NOW.json', x);
  }, 'exactly one ACTIVE task required');

  // Confirm baseline state is completely restored
  assert.deepEqual(validateProject(tmp), []);
  console.log(`ALL TESTS PASS: ${count} (1 baseline + ${count - 1} negative controls)`);
} catch (e) {
  console.error('TEST FAILURE:', e);
  process.exitCode = 1;
} finally {
  fs.rmSync(tmp, {recursive: true, force: true});
}
