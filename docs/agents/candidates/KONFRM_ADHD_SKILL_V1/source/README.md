# KONFRM ADHD SKILL — Focus & Continuity Governance (Candidate v1.0)

**Status:** IMPLEMENTATION PACKAGE — NOT INSTALLED / NOT CANON / NOT MERGED. Created 2026-10-08.  
**Mission:** Protect KONFRM execution continuity while never losing a Founder idea.  
**Scope:** Project focus, capture, prioritization, phase placement, deduplication, and verifiable continuation. Not diagnosis, medical care, surveillance, or arbitrary executive authority.

## Contents
- `.agents/skills/konfrm-adhd/SKILL.md`: concise operating router — user-visible name **ADHD SKILL**.
- `.agents/skills/konfrm-adhd/references/`: on-demand decision, interruption, queue, memory, handoff, reporting protocols.
- `docs/focus/FOCUS_NOW.json`: a single active work item and verified/unverified state.
- `docs/focus/IDEA_INBOX.json`: recorded ideas + assessments + provenance.
- `docs/focus/EXECUTION_QUEUE.json`: separately approved/scheduled work, NO automatic promotion.
- `docs/focus/DECISION_LEDGER.jsonl`: append-only **references** to decisions (does not replace product Canon).
- `docs/focus/SESSION_HANDOFF.md`: recovery snapshot, never evidence by itself.
- `scripts/check-konfrm-focus.mjs`: deterministic invariant validation.
- `scripts/test-konfrm-focus.mjs`: negative controls to show validator rejects invalid priority drift.
- `INSTALLATION_PROTOCOL.md`: safe Antigravity draft PR integration instructions.

## The contract in 12 seconds
**NOW** is exactly one active task. New thought goes to **INBOX** with a receipt, never to NOW directly. The idea is analyzed against Canon, phase order, dependency, existing work, costs, and permission. An explicit Founder instruction to approve and retain it for later also approves queue placement without repeated questions; execution still requires its dependencies and the current task to be reconciled. True safety incidents are escalated without autonomous dangerous changes. Every session resumes from verifiable GitHub/local evidence.

## Usage examples
Founder: «عندي فكرة: نعمل Floating Navigation للمالك»

Assistant: «اتسجلت مرشحة للمراجعة ضمن HOST UX في Phase 6. قد تتعارض مع قرار Phase 4F الحالي، لذلك لا ننفذها قبل Design Court وموافقتك. مهمتنا الآن استرجاع PR #105. الخطوة التالية: تقرير Antigravity.»

Founder: «عايز أنقل الشغل كله دلوقتي للديزاين»

Assistant: «ده ممكن، لكن هينقطع PR #105 وفيه شغل محلي قد لا يكون اترفع. أقترح نسجل تصور التصميم، ونحسم #105 أولًا. لو عايز تغيير المسار رغم التكلفة، نحتاج موافقة واضحة وتوثيق حالة المهمة قبل الانتقال.»

Founder: «خلصنا PR #105»

Assistant: «هات Evidence: HEAD/CI/testing + merge state. بدون إثبات، تظل `REPORTED_DONE` وليس `VERIFIED_CLOSED`.»

## Non-goals
Does NOT own git merges, credentials, database, product/finance Canon, designs, QA judgments, or clinical ADHD assessments. It is a coordination overlay, NOT a replacement `konfrm-product`, `konfrm-quality` or `AGENTS.md`.

## Validation
From repo root after integration: `node scripts/check-konfrm-focus.mjs` then `node scripts/test-konfrm-focus.mjs`. All content is human-readable; no npm package or paid service required.
