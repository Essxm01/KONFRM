# KONFRM Bridge — Independent V2 Screen14 Visual Rejection and V1/Screen13 Comparison

**DATE:** 2026-10-15 Cairo. **Founder verdict:** visually NOT HAPPY with Screen14 V2 — charcoal in place of intended simple monochrome, much text, noise and strange composition. **Bridge status:** `SCREEN14_V2_FOUNDER_VISUAL_REJECTED`, not a production or Founder visual approval. Detailed action defects recorded [#162](https://github.com/Essxm01/KONFRM/issues/162); historical V1 functional defects [#158](https://github.com/Essxm01/KONFRM/issues/158).

## Verified evidence read directly

1. Fetched V2 report, all 21 Base64 text companion files at EXACT `06da1c4bda118839f19711d4741188ce058bbe55`; **decoded and visually examined EACH (01–21)**, including first-fold, same-booking scroll, long-property, initiating, pending, checking/mocker, reconcile, failed, expired, amount change, provider, success, already, state changed, 401, 403, 404, skeleton, initial error, 200% top and 200% scrolled.
2. Directly visually compared [V1 first fold](https://github.com/Essxm01/KONFRM/blob/b1d9676f435f22c7f3047b254970cebd72909c2f/review-evidence/customer-screen14/v1/01_screen14_a56_ready_top_fold.png) vs [V2 first fold](https://github.com/Essxm01/KONFRM/blob/06da1c4bda118839f19711d4741188ce058bbe55/review-evidence/customer-screen14/v2/01_screen14_a56_ready_top_fold.png), plus approved [Screen13 V2 state-approved-first-night](https://github.com/Essxm01/KONFRM/blob/7c05a9b081cf457aea6c74ea8e8c9c2a91e07703/review-evidence/customer-screen13/v2/02_visual_bridge.jpg.b64.txt) and approved [Screen12 V2 first fold](https://github.com/Essxm01/KONFRM/blob/492b1dc5e98f548db81ad87817b027886c54268b/review-evidence/customer-screen12/v2/01_visual_bridge.jpg.b64.txt). The approval of Screens12/13 is VISUAL ONLY and does not authorize production integrations.
3. Read actual full 2,945-line V2 runner under `review-source/screen14_preview_runner_v2.dart`, behavioural test script, report, manifest and source README. Checked evidence SHA exists and HEAD matches; changed-file list only 48 V2 artifacts (21 PNG, 21 text companions, 6 docs/source/test), no production change in evidence commit. No Bridge independent rerun of A56/test-suite commands; green test counts are Antigravity claims.

## Side-by-side optical comparison

| Decision axis | V1 visible | V2 visible | Review |
|---|---|---|---|
| Screen header | Native Screen14 title starts under device status area; no scenario selector permanently visible | QA preview disclaimer THEN long scenario dropdown THEN large void THEN AppBar | V2 loses first-fold hierarchy, unacceptable |
| Deposit hero | White hero card with dark thin outline, prominent EGP 2,700, black/near-black CTA below | Large solid charcoal/navy `#111827` hero AND dark almost-black CTA below | Two visually competing dark slabs; founder wants true black `#000000` CTA only, white financial field |
| Booking/context density | V1 had multiple bordered cards but calmer hero; V1 rejected functionally, NOT a fully approved screen | 7 successive rounded box groups plus debug controls, amount explanation, stay-finance info and guidance | Increased visual noise and redundant copy; restore one decision hierarchy |
| Focus / semantic | Required first-night amount and pay action stand out | Screen is dominated by dark hero, repeated alert box and persistent QA/debug controls | Payment CTA must again be lone visual anchor |
| Cross-screen visual family | Closer to neutral Screen13 first-night card and Screen12 list cards | Debug tool headers and filled navy hero break the agreed family | V2 visibly drifts away from Founder-approved 12/13 |
| A11y images #20/21 | No comparable V1 dev controls at 200% | QA banner and dropdown scale to giant heights; financial labels wrap heavily; scrolled view contains no primary CTA | 'No overflow' ≠ comfortable real-world reading/tappable CTA; need customer-only A56 proof |
| Product examples | V1 synthetic 15–20 Oct2026 / 12–16 Nov2026 and human Arabic formatting | V2 synthetic 10–15 Jul2026 / 1–5 Aug2026, ISO `2026-07-10` | Old/past dates and inconsistency with approved Screen13 20–25 Oct2026; restore coherent structured fixtures |

## Exact visual root cause in native Flutter

- `Screen14PreviewApp` ThemeData lines 420–428: `ColorScheme.light(primary: Color(0xFF111827), onSurface: Color(0xFF111827))`. Former V1 also employed this charcoal for CTA/text, but V2 newly uses it as a FULL financial hero background.
- `_Screen14HarnessPageState.build()` lines 637–664: unconditional column inserts `SafeArea(_buildIsolatedPreviewBanner())`, `_buildScenarioControlBar()`, `Expanded(_buildCurrentScenarioView())`. This is NOT a genuine user interface hierarchy and is present on every A56 screenshot. QA-only mock chooser is also inside payment ScrollView on `checkingStatus` lines 875–879, `1676+` — catastrophic for review of customer-like screenshot #06.
- `Screen14MainPaymentView` `SingleChildScrollView` lines 853–892 chains status, property, large charcoal deposit, CTA, mock chooser, stay details, financial breakdown and guidance. This produces card-soup and duplicated content.
- `_buildDepositHeroCard` lines 1381–1439 sets `color: const Color(0xFF111827)` with white figure. Restore white amount block with dark text and deliberate local contrast, no filled dark hero.
- Fixture lines 348–371 changes from earlier Oct/Nov to July/Aug; `_buildStayDetailsSection` around line 1793 prints `checkInIso` and `checkOutIso` raw rather than localized readable Arabic dates and weekdays.
- 200% source uses TextScaler on whole harness, so mock controls enlarge too; deliberate full customer-mode QA test must exclude them.

## Preserve real gains from V2

- `_handleCheckStatus()` at runner lines 523–528 only enters `checkingStatus`. `_handleMockResponse` at 530–549 requires an explicit QA result (confirmed, still pending, failed, timeout, unauthorized), so no forced synthetic success merely on status-check button. Verify through widget-driven negative tests in next visual round, not independent actual provider truth.
- `_handleInitiatePayment` uses guarded state and `_epoch` around 503–520; `_trigger401SessionPurge` around 553–559 sets a test-only nullable booking reference to null and invalidates stale simulated callbacks. This is preview model protection, NOT production auth/cache E2E certification.
- V2 has distinct 401,403,404,loading,error scenarios; consistent RTL-right Back in captured error/success screens; customer-safe financial notices avoid old unverifiable security/no-debit promise. Preserve them and all testcase scenarios while moving dev-only controls outside customer capture.
- Preserve first-night 2700/total 13500/remainder10800 numerical contract, 3500 long-title alternate test, no real Paymob/payment/Backend flow.

## Founder-safe proposed correction (NOT YET AUTHORIZED)

Do NOT approve V2 visually. Proposal: narrowly scoped `CUSTOMER_SCREEN14_VISUAL_RESTORATION_V3` that uses visual V1 amount-first white card, TRUE black `#000000` black CTA per latest Founder feedback, calm header and concise status, dates consistent with approved Screen13 fixture, removes permanent preview banner/dropdown/QA response widget from ALL customer-mode screenshots, keeps developer controls in separate inspector mode & keyboard scenario access and keeps V2 corrected state controller. Exclude broad redesign and global tokens/Owner/Admin. Need real A56 A11Y top/scrolled/CTA proof and authentic screenshot set with customer-only content, plus developer audit shots labeled QA separately. Founder must explicitly authorize V3 before agent modifies anything. Keep all V1/V2 PNG, Base64, preview runners and reports under retention [#155](https://github.com/Essxm01/KONFRM/issues/155); future v3 must be additive new folder. No production/payment/merge/deploy/Screen15.

**Conclusive decision:** `SCREEN14_V2_VISUAL_REJECTED__V2_FUNCTIONAL_MOCK_REPAIRS_WORTH_KEEPING__V3_FOCUSED_VISUAL_RESTORATION_RECOMMENDED__FOUNDER_APPROVAL_PENDING`.