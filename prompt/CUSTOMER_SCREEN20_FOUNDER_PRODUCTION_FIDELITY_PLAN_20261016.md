# KONFRM — CUSTOMER SCREEN20 FOUNDER PRODUCTION-FIDELITY PLAN MODE

**SOURCE OF TRUTH:** This long numbered instruction is the latest Founder-overridden Plan Mode brief for Antigravity, version 2026-10-16, replacing the earlier Bridge mock-disclaimer correction. Read governing original Issue #179 and #166 Founder directive. DO NOT silently rewrite frozen evidence or build production finance.

# FOUNDER OVERRIDE — Screen20 production-like appearance, complete visual correction PLAN MODE

**AUTHORITATIVE, SUPERSEDES PRIOR BRIDGE REQUEST:** Founder explicitly REJECTED V1 design acceptance and the Bridge partial review. Founder's direct instructions in active conversation: «ج.م» must appear physically on LEFT of digits; absolutely NO visible user-facing «بيانات تجريبية» or other test/prototype terms because Founder needs to see EXACT production-like UI; remove unnecessary explanatory walls and internal MR-13/MR-15 / BK-prefix codes; thoughtfully re-audit ALL nine images + contexts, older screens and future release-like copy; compose ONE comprehensive numbered Antigravity PLAN MODE prompt. The prior Bridge #179 comment 6223110992 asking for a compact visible QA disclaimer is superseded. Global policy #166 comment 6223499612. Existing live security/PSP restrictions NOT relaxed.

**PAUSE old Antigravity correction prompt. NEW plan authority lives below. No production merge, PSP charge, DB or deployment.**

## 01 — Preflight and genuine full audit
Read #179, #166 Founder override, #180 deferred financial gate, #181 public references, #182 past/future copy cleanup; inspect actual 9 Screen20 V1 PNGs at commit 04c250b6521a272ca3e3694913ca71dd35186bd1, source+tests, navigation Canon, MR-11/13/15/17. Before edit, PLAN MODE must produce numbered evidence-based issue→fix→test matrix. Do not assume all defects are covered by old Bridge review.

## 02 — Core screen identity and simplification
Design the final-looking customer app (Cairo Arabic RTL, quiet premium white/light, true black #000000). The user needs transaction status, amount, date/time, booking number, property and optional detail. REMOVE huge QA/amber banner entirely; no replacement grey or soft-blue disclaimer. REMOVE redundant summary card/counters/policy footnotes unless indispensable, and simplify repeated status descriptions. First fold MUST show useful transactions rather than disclaimers. Do not show code tags MR-13/MR-15 or any GitHub/test/UI fixture words.

## 03 — Currency physically LEFT
V1 shows digit 1450 physically LEFT and «ج.م» to its RIGHT; Founder requires the REVERSE. Show from physical left-to-right: «ج.م 1,450» on cards and detail at 100% and 200%. Use explicit amount component and controlled bidi direction; format thousands; geometry test physical x(currency) < x(digits), plus A56 screenshot, not merely string assertions. Leave whole app RTL.

## 04 — Booking, transaction and multi-service references
Display «رقم الحجز 651900» not «حجز #BK-651900». Preserve internal key unchanged. Do not shorten/truncate arbitrary last digits, do not invent DB ID generator. Founder wants future shorter public service-specific references BK for booking, VK for verification and other classes: decision OPEN under #181 (mapping, collisions, security, non-enumeration, role labels). Customer-safe transaction reference is distinct and optional; do not leak internal TXN/PSP TEST identifiers.

## 05 — Financial status and receipt realism without real settlement
Use fixture values ONLY in isolated Flutter runner and LABEL fixtures in Github report/manifest/tests, NOT in any customer-rendered UI or screenshot. Future LIVE release must only render authoritative authenticated PSP-confirmed PAID or REFUNDED records, never fixtures. In customer UI no «معاينة», «تجريبية», «محاكاة», «إيصال تجريبي», mock, «حالة توضيحية», fake provider references or fake card brands. Do not put a different-looking test UI in front of Founder. Drop unsupported provider/card details entirely rather than show fiction. Keep realistic read-only future status semantics. Payment mode PROTOTYPE is not bank settlement. Refund policy MR-15 open, no invented refund guarantee. Screen20 is not Customer Wallet #173.

## 06 — Filters, summaries and information density
Fix actual code mismatch: filter «المطابقة والمسترد» also includes FAILED. Make filter label and predicate exactly match, or reduce to a few simple useful statuses. No misleading paid count. Remove excessive summary and duplicated explanation; use progressive disclosure. Reconciliation warning must be concise, neutral, informative, never fake provider confirmation. Follow Founder MR-17: yellow/orange boxed cards NOT default. Keep whitespace and status legibility.

## 07 — Actions, copy and errors
Detail sheet title «تفاصيل العملية» without fake legal bank receipt banner or raw internal test refs. Delete fake «المبلغ المسدد» if no actual paid status, use correct context-dependent amount and explain only necessary uncertainty. Current «نسخ المرجع» only shows toast, copies nothing: implement safe local Clipboard.setData in isolated runner or remove the button, no false success. No dev Screen 03/04 tags in toasts. Empty/guest/network error each get one simple headline, optional one sentence and one relevant action. Do not claim server cause without evidence.

## 08 — Accessibility and image-level QA
Inspect all nine V1 states plus representative before/after at normal and runner-driven 200% on physical A56. Ensure physical currency layout, visible booking-only digits, no QA text, readable status/amount, full scrolling without horizontal overflow, semantic accessible data, 48dp reachability, correct back on RIGHT, nested bottom bar HIDDEN, pure black, balanced detail sheet and error/guest privacy. Honestly note 200% is TextScaler.linear(2.0) runner on A56, not necessarily OS-wide scale, in report ONLY.

## 09 — Frozen earlier screens, future quality rule
Read-only inspect approved Screens17–19 screenshot/source for repeated sample/dev copy and lengthy explanatory text (Screen18 bottom local-save demo footer; Screen19 verified-demo badges/illustrative permission blocks). Identify actual issue per screen, screenshot SHA/path, recommended production-like copy, severity, API dependency. Do not edit old accepted SHAs or historic screenshots in Screen20 branch. Record one later scoped batch under #182, not endless V5/V6 loops. New Customer, Owner and Admin UI must follow the same final-facing copy standard proactively.

## 10 — Execution/Evidence boundaries
PLAN first, execute ONE Screen20 isolated design pass on existing evidence/customer-screen20-design-review based on 04c250b; only tool/screen20_preview_runner.dart, focused Screen20 tests, task tracking and NEW additive evidence review-evidence/customer-screen20/v1-production-fidelity-refinement/. Preserve V1 and all Screens12–19 unchanged (#155); no production customer_app/lib, backend, Supabase, Cloudflare Worker, Paymob, Auth, financial data, global design tokens, live routes, Owner/Admin, merge/deploy or Screen21. Do not modify old frozen visuals from same branch.

## 11 — Acceptance (source and actual visual)
Verify: (a) no UI-facing test/meta words, MR codes, BK-/fake TEST provider/card refs, and no inflated footer; (b) currency «ج.م» strictly on physical left of formatted digits in both 100%/200%; (c) booking number natural digits only, unchanged internal mapping; (d) statuses/filters match data; paid/refund only future-authoritative conditions, fixtures isolated offscreen; (e) no false clipboard/PSP/retry/receipt success; (f) distinct empty/guest/error/unknown states; (g) clear first fold and premium quiet hierarchy; (h) 100% and 200% A56 screenshot inspection and focused tests; (i) exact diff strictly isolated/additive.

## 12 — ONE final delivery, no loops
Report plan checklist, exact new Git commit/branch, BEFORE/AFTER defects mapped to screenshots and source, 7–9 NEW authentic A56 screenshots normal/scrolled/detail/unknown/empty/error/guest/200%, manifest+hashes, truthful Flutter tests/analyzer, read-only prior-screens audit table #182, deferred #180/#163/#181. NO visible QA labels in screenshots, but report truthfully fixtures and never claim real payment. Stop for Bridge and Founder design-only approval. No Screen21.

**Founder specific distinction:** A production-faithful LOOK is not production integration approval. Never release fake money/verified user identities to actual customers. Preserve all technical blockers under #180 until the later three-role design-first integration phase.

---

**EXECUTOR HANDOFF:** In Antigravity select Plan Mode, read entire document and ground every step in actual code/screenshots before edits, then perform only the permitted one isolated Screen20 refinement if execution is authorized. Stop at Founder visual-decision gate.
