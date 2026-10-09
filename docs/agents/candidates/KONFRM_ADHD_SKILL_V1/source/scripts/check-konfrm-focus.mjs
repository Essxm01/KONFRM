#!/usr/bin/env node
// Deterministic governance checks — never equate file validity with verified live reality.
import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';

const defaultRoot = fileURLToPath(new URL('../', import.meta.url));
const statuses = new Set([
  'CAPTURED', 'ASSESSED', 'NEEDS_FOUNDER_DECISION', 'DEFERRED',
  'FOUNDER_APPROVED', 'REJECTED', 'SUPERSEDED', 'BLOCKED', 'VERIFIED_CLOSED'
]);
const slots = new Set([
  'CURRENT_TASK', 'AFTER_PR_105', 'FOUNDATION_GOVERNANCE',
  'PHASE_5_GUEST_UX', 'PHASE_6_HOST_UX', 'PHASE_7_ADMIN_UX',
  'POST_PHASE_7_R2_R5', 'PHASE_8_PLUS', 'UNPLACED'
]);
const canonicalSharedPaths = [
  'tasks/CURRENT_TASK.md',
  'AGENTS.md',
  'docs/INDEX.md',
  'docs/CURRENT_STATE.md',
  '.agents/SKILL_ROUTER.md',
  '.agents/SKILL_MANIFEST.yaml',
  'KONFRM_EXECUTION_DEPENDENCY_ORDER.md'
];
const finishedMergedPRs = new Set([105, 107, 109, 110]);

const txt = x => typeof x === 'string' && !!x.trim();

function normalizePattern(p) {
  return String(p || '').replace(/\\/g, '/').replace(/^\/+/, '').replace(/\/+$/, '');
}

function surfacesOverlap(patA, patB) {
  const a = normalizePattern(patA).replace(/\/\*\*?$/, '');
  const b = normalizePattern(patB).replace(/\/\*\*?$/, '');
  if (!a || !b) return false;
  if (a === b) return true;
  if (a.startsWith(b + '/') || b.startsWith(a + '/')) return true;
  return false;
}

export function validateProject(root = defaultRoot) {
  const errors = [];
  const read = f => {
    try {
      return JSON.parse(fs.readFileSync(path.join(root, 'docs/focus', f), 'utf8'));
    } catch (e) {
      errors.push(`invalid ${f}: ${e.message}`);
      return null;
    }
  };

  const now = read('FOCUS_NOW.json');
  const inbox = read('IDEA_INBOX.json');
  const q = read('EXECUTION_QUEUE.json');
  if (!now || !inbox || !q) return errors;

  if ([now, inbox, q].some(x => x.schema_version !== '1.0.0')) {
    errors.push('invalid schema version');
  }

  // Active Primary Product Delivery Task
  const active = now.active;
  if (!active || Array.isArray(active) || active.status !== 'ACTIVE') {
    errors.push('exactly one ACTIVE task required');
  }
  for (const k of ['task_id', 'title', 'completion_gate', 'next_action']) {
    if (!txt(active?.[k])) errors.push(`missing active.${k}`);
  }
  if (!/^[a-f0-9]{40}$/.test(active?.last_known_remote_head ?? '') ||
      !/^[a-f0-9]{40}$/.test(active?.last_known_main_head ?? '')) {
    errors.push('invalid SHA evidence');
  }
  if (typeof active?.unverified_local_state !== 'boolean') {
    errors.push('local uncertainty flag required');
  }
  if (active?.pr && finishedMergedPRs.has(Number(active.pr)) && active.status === 'ACTIVE') {
    errors.push(`finished PR treated as active work: PR #${active.pr}`);
  }

  // WIP Violation: Unauthorized task proliferation in additional_active_tasks
  if (now.additional_active_tasks?.length) {
    errors.push('WIP violation: uncontrolled task proliferation in additional_active_tasks');
  }

  // Parallel Lanes Validation
  const assignedAgents = new Map();
  const assignedWorktrees = new Map();
  const allSurfaces = []; // { lane_id, surface }

  if (active) {
    const activeAgent = active.agent_role || 'DEFAULT_AGENT';
    assignedAgents.set(activeAgent, active.task_id);
    const activeWorktree = active.worktree || 'DEFAULT_WORKTREE';
    assignedWorktrees.set(activeWorktree, active.task_id);
    const activeSurfaces = Array.isArray(active.exclusive_writable_surfaces)
      ? active.exclusive_writable_surfaces
      : (txt(active.surface) ? [active.surface] : []);
    for (const s of activeSurfaces) {
      allSurfaces.push({ lane_id: active.task_id, surface: s });
    }
  }

  if (now.authorized_parallel_lanes !== undefined) {
    if (!Array.isArray(now.authorized_parallel_lanes)) {
      errors.push('authorized_parallel_lanes must be an array');
    } else {
      for (const lane of now.authorized_parallel_lanes) {
        const lid = lane.lane_id ?? 'MISSING_LANE_ID';
        if (!txt(lane.lane_id)) errors.push('missing lane_id');
        if (!txt(lane.title)) errors.push(`lane ${lid}: missing title`);
        if (!['ACTIVE', 'PAUSED', 'COMPLETED'].includes(lane.status)) {
          errors.push(`lane ${lid}: invalid status ${lane.status}`);
        }
        if (!txt(lane.agent_role)) errors.push(`lane ${lid}: missing agent_role`);
        if (!txt(lane.worktree)) errors.push(`lane ${lid}: missing worktree`);
        if (!txt(lane.completion_gate)) errors.push(`lane ${lid}: missing completion_gate`);
        if (!txt(lane.next_action)) errors.push(`lane ${lid}: missing next_action`);
        if (lane.last_known_remote_head && !/^[a-f0-9]{40}$/.test(lane.last_known_remote_head)) {
          errors.push(`lane ${lid}: invalid remote head SHA`);
        }
        if (lane.last_known_main_head && !/^[a-f0-9]{40}$/.test(lane.last_known_main_head)) {
          errors.push(`lane ${lid}: invalid main head SHA`);
        }

        // Check finished PR treated as active work
        if (lane.pr && finishedMergedPRs.has(Number(lane.pr)) && lane.status === 'ACTIVE') {
          errors.push(`finished PR treated as active work: lane ${lid} references merged PR #${lane.pr}`);
        }

        // Founder authorization requirement
        const auth = lane.founder_authorization;
        if (!auth || !txt(auth.authority) || !txt(auth.date) || !txt(auth.evidence)) {
          errors.push(`lane ${lid}: unauthorized parallel lane (missing founder authorization)`);
        }

        // Check assigned agent and worktree uniqueness for ACTIVE lanes
        if (lane.status === 'ACTIVE') {
          if (lane.agent_role) {
            if (assignedAgents.has(lane.agent_role)) {
              errors.push(`agent ${lane.agent_role} assigned multiple active tasks (${assignedAgents.get(lane.agent_role)} and ${lid})`);
            } else {
              assignedAgents.set(lane.agent_role, lid);
            }
          }
          if (lane.worktree) {
            if (assignedWorktrees.has(lane.worktree)) {
              errors.push(`worktree ${lane.worktree} assigned multiple active tasks (${assignedWorktrees.get(lane.worktree)} and ${lid})`);
            } else {
              assignedWorktrees.set(lane.worktree, lid);
            }
          }
        }

        // Check exclusive writable surfaces
        if (!Array.isArray(lane.exclusive_writable_surfaces) || lane.exclusive_writable_surfaces.length === 0) {
          errors.push(`lane ${lid}: exclusive_writable_surfaces must be a non-empty array`);
        } else {
          for (const s of lane.exclusive_writable_surfaces) {
            if (!txt(s)) {
              errors.push(`lane ${lid}: invalid empty surface`);
              continue;
            }
            // Check canonical shared state files
            const norm = normalizePattern(s);
            for (const can of canonicalSharedPaths) {
              if (norm === can || norm.startsWith(can) || surfacesOverlap(norm, can)) {
                errors.push(`lane ${lid}: unauthorized canonical state modification (${can})`);
              }
            }
            if (lane.status === 'ACTIVE') {
              allSurfaces.push({ lane_id: lid, surface: s });
            }
          }
        }
      }

      // Check disjoint writable surfaces (no overlapping file ownership)
      for (let i = 0; i < allSurfaces.length; i++) {
        for (let j = i + 1; j < allSurfaces.length; j++) {
          const s1 = allSurfaces[i];
          const s2 = allSurfaces[j];
          if (s1.lane_id !== s2.lane_id && surfacesOverlap(s1.surface, s2.surface)) {
            errors.push(`conflicting file ownership: ${s1.lane_id} and ${s2.lane_id} overlap on ${s1.surface} / ${s2.surface}`);
          }
        }
      }
    }
  }

  // Verification status check
  if (!['HISTORICAL_REMOTE_ONLY_RECHECK_REQUIRED', 'CURRENT_WITH_EVIDENCE', 'STALE_SNAPSHOT'].includes(now.verification)) {
    errors.push('unknown verification status');
  }
  if (now.verification === 'CURRENT_WITH_EVIDENCE' && !txt(now.evidence_url)) {
    errors.push('CURRENT_WITH_EVIDENCE needs evidence_url');
  }

  // Idea inbox validation
  if (!Array.isArray(inbox.entries) || !Array.isArray(q.queue)) {
    return [...errors, 'missing idea/queue arrays'];
  }
  const seen = new Set(), byId = new Map(), normalizedTitles = new Map();
  for (const v of inbox.entries) {
    const id = v.id ?? 'MISSING';
    if (seen.has(id)) errors.push(`duplicate idea ID ${id}`);
    seen.add(id);
    byId.set(id, v);
    const titleKey = String(v.title ?? '').normalize('NFKC').trim().toLowerCase().replace(/\s+/g, ' ');
    if (titleKey && normalizedTitles.has(titleKey) && !v.duplicate_of) {
      errors.push(`possible duplicate title: ${id} duplicates ${normalizedTitles.get(titleKey)}`);
    }
    if (titleKey) normalizedTitles.set(titleKey, id);
    if (!/^IDEA-\d{8}-\d{3}$/.test(id)) errors.push(`invalid idea ID ${id}`);
    if (!statuses.has(v.status)) errors.push(`${id}: invalid status`);
    if (!slots.has(v.phase_slot)) errors.push(`${id}: invalid phase slot`);
    for (const k of ['captured_at', 'title', 'founder_intent', 'reason_for_later', 'next_review_gate']) {
      if (!txt(v[k])) errors.push(`${id}: missing ${k}`);
    }
    for (const k of ['sources', 'role_surface', 'dependencies', 'affected_surfaces']) {
      if (!Array.isArray(v[k])) errors.push(`${id}: invalid ${k}`);
    }
    if (!txt(v.approval?.source)) errors.push(`${id}: source missing`);
    for (const k of ['codified_in_canon', 'queue_approved', 'execution_approved']) {
      if (typeof v.approval?.[k] !== 'boolean') errors.push(`${id}: invalid approval.${k}`);
    }
    if (v.approval?.queue_approved && !['FOUNDER_APPROVED', 'VERIFIED_CLOSED'].includes(v.status)) {
      errors.push(`${id}: unapproved idea advanced`);
    }
    if (v.approval?.execution_approved && !v.approval.queue_approved) {
      errors.push(`${id}: execution requires queue approval`);
    }
    if (v.duplicate_of === id) errors.push(`${id}: self duplicate`);
  }
  for (const v of inbox.entries) {
    if (v.duplicate_of && !byId.has(v.duplicate_of)) errors.push(`${v.id}: dangling duplicate`);
  }

  // Execution queue validation
  const queued = new Set();
  for (const x of q.queue) {
    if (queued.has(x.idea_id)) errors.push(`duplicate queue ID ${x.idea_id}`);
    queued.add(x.idea_id);
    const idea = byId.get(x.idea_id);
    if (!idea) {
      errors.push(`unknown queued idea ${x.idea_id}`);
      continue;
    }
    if (!idea.approval?.queue_approved || !['FOUNDER_APPROVED', 'VERIFIED_CLOSED'].includes(idea.status)) {
      errors.push(`${x.idea_id}: unapproved idea in queue`);
    }
    if (x.phase_slot !== idea.phase_slot || !slots.has(x.phase_slot)) {
      errors.push(`${x.idea_id}: phase mismatch`);
    }
    if (!Array.isArray(x.dependencies)) errors.push(`${x.idea_id}: missing dependencies`);
    if (x.status === 'ACTIVE' && (!idea.approval.execution_approved || active?.idea_id !== x.idea_id)) {
      errors.push(`${x.idea_id}: second unauthorized ACTIVE`);
    }
    if (x.phase_slot === 'PHASE_8_PLUS' && (x.dependency_gate !== 'POST_PHASE_7_R2_R5_VERIFIED' || !txt(x.gate_evidence))) {
      errors.push(`${x.idea_id}: Phase 8+ gate absent or unevidenced`);
    }
  }

  // Decision ledger validation
  try {
    const lines = fs.readFileSync(path.join(root, 'docs/focus/DECISION_LEDGER.jsonl'), 'utf8').split(/\r?\n/).filter(Boolean);
    const eventIDs = new Set(), queuedEventIDs = new Set();
    lines.forEach((line, n) => {
      try {
        const e = JSON.parse(line);
        if (eventIDs.has(e.event_id)) errors.push(`duplicate decision ID ${e.event_id}`);
        eventIDs.add(e.event_id);
        if (!txt(e.event_id) || !txt(e.date) || !txt(e.authority) || !txt(e.status)) {
          errors.push(`malformed decision event ${n + 1}`);
        }
        if (e.record_id && !byId.has(e.record_id) && !e.record_id.startsWith('PR-') && !e.record_id.startsWith('LANE-')) {
          errors.push(`orphan decision ${e.record_id}`);
        }
        if (e.kind === 'QUEUE_APPROVED' && txt(e.authority) && txt(e.evidence)) {
          queuedEventIDs.add(e.record_id);
        }
      } catch {
        errors.push(`bad JSONL decision line ${n + 1}`);
      }
    });
    for (const x of q.queue) {
      if (!queuedEventIDs.has(x.idea_id)) errors.push(`${x.idea_id}: queue approval needs recorded Founder decision event`);
    }
  } catch (e) {
    errors.push(`missing decision ledger: ${e.message}`);
  }

  return errors;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const err = validateProject(process.argv[2] ? path.resolve(process.argv[2]) : defaultRoot);
  if (err.length) {
    console.error('FOCUS GUARD FAIL:', err.join(' | '));
    process.exitCode = 1;
  } else {
    console.log('FOCUS GUARD PASS — file consistency, WIP, approval, phase, parallel lanes, ledger. GitHub/Live truth NOT checked.');
  }
}
