# KONFRM — Customer Account & Profile: Premium Experience Research and Founder Direction
**Date:** 2026-10-15 • **Status:** FOUNDER PRODUCT VISION / DESIGN RESEARCH • UI prototype permitted, production behavior NOT authorized
**Applies to:** Customer Screen17 Account Home, Screen18 Profile / Edit Profile, Screen20 Payment History, Screen19 Settings. Technical cross-role identity remains an open contract, NOT a granted architecture change.
**Canonical:** `KONFRM_EXECUTION_TASKS.md` current 26-screen inventory; `KONFRM_EXECUTION_TASKS_SCREEN_CONTRACTS_DRAFT.md` §§17–20; `KONFRM_MASTER_PROJECT_CONTEXT.md` current single-account decision caveat; approved Screens12/15/16; design-first #166, evidence #155.

## 1. Founder intent — highest priority
Make Account and Profile a flagship, intensely polished, trustworthy and personally useful experience, **not** the traditional blue-list Account page from current React Web. Founder requests photo editing, name, a potentially unified username/handle, birthday + calculated age, optional gender, Google + Apple account connection, ability to add/verify email after phone signup and vice versa, comfortable privacy-first personalization, a meaningful paid-payment history, and a personal invite/referral link; research additional differentiated travel-profile features. Every new capability must have a design before any production-side implementation. Existing Account Home Screen17 and Edit Profile Screen18 retain distinct IA roles; do not silently merge/swap screen numbers.

## 2. External UX research (what to LEARN, not copy)
- Airbnb 2025 redesigned Profile highlights photo, personal trust and travel history (rather than dense administrative lists): https://news.airbnb.com/product-releases/airbnb-2025-summer-release
- Airbnb photo editing/gallery framing, photo guidance: https://www.airbnb.com/help/article/3515 ; add optional profile personality https://www.airbnb.com/help/article/3813
- Airbnb privacy/visibility controls and travel stamps (opt-in): https://www.airbnb.com/help/article/3386 ; https://www.airbnb.com/help/article/3802
- Uber trip receipts through activity: https://help.uber.com/en/riders/article/yolculuk-%C3%B6zeti-alma?nodeId=846f6cad-6f27-492a-9e0b-d2f056e1298e
- Apple: optional attributes / account linking / private email: https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/ ; account deletion https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion
- Google/Android system Photo Picker gives selected photos only: https://developer.android.com/training/data-storage/shared/photo-picker
- Supabase identity-linking documents show possible *technical path if this repo's approved auth architecture supports it*, NOT proof that current KONFRM uses that flow: https://supabase.com/docs/guides/auth/auth-identity-linking
- Apple private email relay 2026 domain changes: https://developer.apple.com/news/?id=1ptvdtcm

**Synthesis:** Airbnb = humane identity + history/trust; Uber = short paths to activity/payment proof; Google/Apple = low-friction identity choice and transparent privacy. Original KONFRM execution must be monochrome, Cairo/RTL, customer-centered, with no copied trade dress, brand graphics, or unnecessary social exposure. Emphasize actionable usefulness and personal delight, not artificial session-length or clutter.

## 3. Proposed art direction: KONFRM Personal Passport (مِلفّي في كونفرم)
**Design adjectives:** premium editorial, warm minimalist, calm, confident, personal and unmistakably KONFRM. White/soft neutral canvas, Cairo text, true black primary, hairline dividers, controlled grayscale, no default blue, no gradient overload, no glossy cards, no needless card soup, sparse shadows, tactile 48–56dp actions, physical RTL arrows with pixels checked, shared CustomerBottomNavigation index3. Responsive 360/390/430dp and A56 1080×2340 at normal/200% font.

**Screen17 — Account Home (useful hub, fast scan, not sprawling full data form):**
1. Top title `حسابي` with clean right-to-left hierarchy and normal optional account actions.
2. A large yet economical **identity hero**: verified-current avatar or initials fallback (88–104dp) at physical/right RTL position; name (24–28sp), `@username` *only if an approved unique handle exists*, private masked verified contact/short identity label, compact `تعديل الملف الشخصي` affordance, and no fake verification badge. Tapping image/name opens Screen18.
3. One carefully chosen **next-relevant action** (e.g., genuinely upcoming booking) only when real authorized customer data exists; otherwise omit. Do not invent stats, discounts, paid status, credits or stay nights.
4. Three concise navigational shortcuts relevant to the user: `حجوزاتي`, `المفضلة`, `الإشعارات`; optional count badges only when authoritative. Preserve shared nav where those destinations are already primary.
5. **Payment activity preview** (0–2 real recent completed events and clear status) linking Screen20 for full history. If not available, truthful `عرض سجل المدفوعات` link/empty state, not fabricated EGP amounts or wallet balance.
6. **Invite a friend / شارك كونفرم** mini feature: default safe generic app-share without claiming a personal, measurable referral link or rewards. Reserve a distinct *personal referral code/link* preview only for founder-approved policy/attribution backend contract.
7. Simple groups for `الملف والخصوصية`, `طرق الدخول والأمان`, `الإعدادات`, `الدعم`, and logout; show critical account actions without excessive decorative boxes. No Owner/Admin dashboards or account-mode switch by guess.
8. Guest mode: welcoming identity-free hero + one login CTA, limited helpful navigation; never pretend a saved profile, metrics, linked accounts, or paid history exists.

**Screen18 — My Profile (personal, editable details in meaningful groups):**
A. Large avatar-edit microflow with native system picker/camera only when permitted, square crop, preview, reframe, retake/remove, cancel and save; show before/after only upon confirmed server save in production. Current repo DTO contains read-only `avatarUrl` but does NOT establish upload support.
B. Display name and an optional `@username` handle editing state. Proposed handle globally unique as a public/profile alias but not automatically a login credential; check availability only after approved backend contract; never claim uniqueness across Owner/Customer/Admin before unified identity decision. Stable internal immutable user ID must be separate from mutable handle.
C. Birthdate (optional/private by default), calculated age as read-only derived display, never independently editable or exposed publicly. Date bounds and minor handling are product/legal TBD. Gender (optional/private, `أفضل عدم الإفصاح` allowed) is never inferred from name/image and does not affect booking flow absent explicit approved business rule.
D. `طرق التواصل وتسجيل الدخول`: read-only verified phone/email rows with linked/verified/pending status, *Add email* for phone-first and *Add phone* for email-first through separate verification UX, not by modifying ordinary `PATCH /customer/profile`. Current production Screen18 only patches `fullName` and has explicit tests prohibiting fake editable email/phone fields; DESIGN concept may illustrate these future rows as `اقتراح قيد الدراسة` in developer review, NOT working production features.
E. `الحسابات المرتبطة`: Google and Apple with accurate Linked/Not linked/Requires verification statuses only from authoritative OAuth identity data in final product. Binding needs reauthentication, explicit user consent, collision prevention, no silent duplicate merges, no unlink of last usable login and Apple Hide My Email respect. Do NOT import Supabase/Google/Apple SDKs during this design task or claim linking works.
F. `التفضيلات الشخصية` (opt-in): languages, trip interests, optional saved traveler preferences (e.g. accessibility needs) with explicit privacy. No inferred sensitive demographic traits.
G. Preview what the owner/other traveler could see **only after** Founder decides public/limited profile visibility. Never expose DOB/gender/email/phone/payment records by default.
H. Transparent save, reset, unsaved edits warning, loading/failure/collision, session-expired 401, no verified identifier fail-closed, 200% text, keyboard and focus support. No saving when unsupported.

**Screen20 — Payment History (real truth, not fake finance):**
Recent verified payment records only; display exact transaction date, paid amount/currency, status, property/booking, receipt link if issued, with distinction pending attempt vs successful captured payment vs refund, and Screen20 full list. No credit/wallet/reward math or receipt downloads unless real endpoints exist.

**Optional personal delight, only if useful & permissioned:**
- Private trips/places scrapbook from completed stays (Airbnb inspiration), opt-in share/visibility TBD, not a new social network by default.
- Travel preferences that improve future searches, shown as short editable chips.
- Progress hint `إكمال الملف` only based on **actual optional fields**, never false badges or pressure to disclose gender/DOB.
- Trusted help/help history and copy/share profile handle if public alias becomes product-approved.
- Referral sharing should never show promised rewards, earned money, expiry or fake share URI without separately approved campaign/program terms.

## 4. Contract reality from current source — DO NOT LIE IN UI
- Actual Web source: `customer-app/src/components/CustomerAccountHomeScreen.tsx`; `customer-app/src/components/CustomerEditAccountPage.tsx`.
- Backend DTO: `backend/server/src/contracts/customerRenter.ts` currently explicitly includes fullName, avatarUrl, verifiedIdentifiers(phone/email) and booking summary counts. **No canonical username, birthDate, gender, provider linking or referral code in that DTO**.
- Web Screen18 code currently PATCHes ONLY `fullName` to `/customer/profile`. Its tests expressly prohibit photo upload and add-email editable inputs, because those features ARE NOT implemented/approved *in existing code*. Founder wants to elevate future design but this request is not authority to bypass tests, API or backend.
- `KONFRM_MASTER_PROJECT_CONTEXT.md` §10.2 and §36: unified account across Customer/Owner apps remains an **open architecture/product decision**. A globally unified public handle is a *proposal*, not an existing property.
- Current color in legacy React Web #0059FF is not transferable to founder-approved native Flutter monochrome.
- The 26-screen IA remains Screen17 Account Home; Screen18 Profile/Edit; Screen19 Settings; Screen20 Payment History. A Referral feature may be embedded in Screen17/18 without inventing another screen number pending IA approval.

## 5. Decision gates & implementability matrix
| Capability | DESIGN NOW? | Production status / required gate |
|---|---|---|
| High-fidelity profile hero, image placeholder/edit affordance | YES isolated UI | Avatar picker/upload/storage/CDN/privacy and moderation contract needed |
| Name display + editable name | YES | Current `fullName` supported but native integration separately gated |
| Unified @handle | YES proposal-state mock | Global uniqueness across apps, reserved names, public visibility, renaming cooldown, conflict resolution and persistence MUST be defined |
| Date of birth + computed age | YES private optional mock | Legal need/minor policy, verified DOB? access and storage policy pending |
| Optional gender | YES opt-in/private mock | Taxonomy, disclosure, necessity, privacy and data retention decisions pending |
| Google / Apple account linking | YES linked/unlinked visuals only | Provider configuration, auth architecture, secure merge/unlink/reauth, Apple private relay policy pending |
| Add verified email / phone after other sign-in | YES UX states only | Separate OTP/email challenge, session security, collisions and backend contract pending |
| Payment record teaser / Screen20 link | YES truthful placeholders | Real paid transaction/refund/receipt endpoints and permission/presentation gates |
| Generic share KONFRM link | YES only real generic installed app URL if known; otherwise neutral concept | No fabricated URL / tracking |
| Personal referral ID, tracking, credits, rewards | YES clearly tagged CONCEPT only | Founder decision on incentive rules, anti-fraud, abuse, attribution, expiry, privacy, tax and accounting needed |
| Optional travel scrapbook/preferences | YES high-fidelity concept with mock flags | Consent, data source and sharing policy needed |
| In-app account deletion | YES visible Settings entry as future flow | Apple App Review & privacy/retention implementation mandatory before launch |

**Explicitly prohibited:** modifying production, backend, DB, mobile production auth, financial statements, linking real Google/Apple credentials, inventing username availability, real referral links, reward promises, actual invoice/receipts without source, changing shared CustomerBottomNavigation, role switching, and unauthorized Screen18 implementation. Business/identity/finance schema changes need separate Founder go-ahead.

## 6. Delivery direction to Antigravity (UPDATE EXISTING TASK; DO NOT RESTART)
1. Inspect workspace first: issue #170 Screen17 is ALREADY dispatched, so integrate this NEW Founder design ambition without discarding any current valid preview progress. No destructive reset, no duplicate branch.
2. Prioritize visual analysis and a premium **Screen17 account hero**. Produce 1 recommended hero composition and optional one alternate as design concepts (not three whole software implementations). Use actual approved Screen12/15/16 visuals for shared nav and card rhythm; no legacy Web copy/paste.
3. For the **future Screen18 full-profile experience**, produce a connected design specification and, only if needed for visual coherence, a separate **isolated preview concept** (not production and not declaring Screen18 task started/approved). Avoid replacing Screen17 Account with one giant editable form.
4. All interactive visuals for unsupported features must be labeled developer-only PROPOSED, unavailable in production; never display disabled dead controls to end users with misleading promises.
5. Test *visual usefulness, alignment, privacy, edit discoverability, avatar affordance, 200% Arabic scalability, RTL arrows and touch targets* on a real Samsung A56. Do not chase full Backend/SDK integration during visual design.
6. Provide preview/evidence and clear Founder decision questions if any business-policy choices must be made. Defer engineering details with linked pre-integration/pre-live GitHub tasks. NO rollout and NO auto-screen progression.

## 7. Reviewer UX acceptance (must pass before Founder sign-off)
- At first fold user instantly understands who they are, sees avatar/name/@handle when verified, knows where to edit and can find one most relevant task. No invented data or false confidence badges.
- Screen17 remains shorter and faster to scan than Screen18; personal-data screen is private/legible, and age is derived from DOB. No hidden essential functions.
- Last-paid items are real or truthful empty. Linking/verification labels accurately match actual state or are clearly developer-only examples.
- Shared bottom nav exact: Account index3, four items/order/spacing/icons/safe area matching Screens12/15/16. 200% scaling and 360dp view usable.
- Premium feel means outstanding hierarchy, spacing, transitions and utility, NOT adding colors/gradients, multiple advertising promos, referral incentives or fake counts.
- No loss/overwrite of any earlier evidence under #155. Founder approves visual before full implementation. 
