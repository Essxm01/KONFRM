# IDEA INTAKE — Fast capture without derailment

## 1. Parse without hijacking
Find Founder exact phrase and intended benefit; identify whether this is (a) observation, (b) brainstorming, (c) request to evaluate, (d) explicit approval, or (e) explicit instruction to change current work. These states are NOT equivalent. One vague assent (`تمام`) does not upgrade an unpresented alternative.

## 2. Capture record
Create `IDEA-YYYYMMDD-NNN` with immutable `id`, `captured_at` (ISO), `title`, `founder_intent`, `status`, `role_surface`, `phase_slot`, `reason_for_later`, `sources`, `duplicate_of`, `existing_pr`, `dependencies`, `affected_surfaces`, `assessment`, `next_review_gate`, `approval`. Do not copy health details, raw conversations, credentials, OTPs, payment/customer records or private personal secrets.

## 3. De-dup first
Search: existing inbox IDs and title/semantic similarities; execution queue; GitHub open PR/Issues; `docs/DECISIONS.md` and governed design decisions; CURRENT TASK. Cases:
- Already implemented and verified -> `SUPERSEDED`, link evidence, keep audit history.
- Same approved task -> add source to existing record, do not create duplicate work.
- Conflicts with approved decision -> `NEEDS_FOUNDER_DECISION`, do not force it into execution.
- Clearly unrelated to KONFRM focus scope -> note separately ONLY if Founder asks; do not import into this skill's ledger.

## 4. Low-friction approval, no duplicate questioning
`FOUNDER_APPROVED` = Founder agrees with the **idea/decision**. If the Founder also says to **document, save in the roadmap, or execute later**, that single explicit instruction authorizes **queue placement**; append a `QUEUE_APPROVED` decision event with source and evidence, set `approval.queue_approved=true`, and place the idea in the dependency slot *without another approval question*. Approval of an aesthetic *direction only* does NOT silently authorize immediate implementation.
`EXECUTION_APPROVED` = the Founder or prior governing authorization specifically permits execution now, after active work safety checks and prerequisites. Future queue placement is never execution permission.

## 5. Reply recipe
- «سجلت فكرة [ID] ضمن [Phase/Decision Gate] كـ[Candidate/Approved].»
- «السبب لعدم البدء دلوقتي: [dependency, risk, or agreed NOW].»
- «إحنا الآن: [one sentence]. الخطوة التالية: [one action].»

If recording is not actually persisted to a readable repository file, say **«جهزت سجلًا للنسخ لكنه لم يُحفظ بعد على GitHub»**. Never claim it was saved.
