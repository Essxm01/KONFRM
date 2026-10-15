# KONFRM — Premium Personal Account Design Directive (Screen17 + Screen18 vision)
**Founder design directive • 2026-10-15 • DESIGN ONLY, not financial/identity production authority**

## 0. Authority and preservation
- Screen17 V1 evidence pinned at `1f1b5a043d82ff2cb6c5d72ce2bd10ede78b83ef` is REJECTED VISUALLY by Founder. Do **not** delete/rewrite historical V1 evidence. It is a record, not the visual direction.
- Founder explicitly wants a new premium, social-caliber and modern *personal home*, NOT the old React Account page, nor a plain list of cards. No phone number beside/below profile portrait; no initial-only avatar as the showcased happy-path.
- Approved cross-screen design system: white/neutral true-black Cairo Arabic RTL, real shared CustomerBottomNavigation with Account index3, physical LEFT on forward chevrons, consistent safe areas and 200% typography. Do not change other approved screens or shared tokens.
- Canonical numbering: Screen17 ACCOUNT HOME, Screen18 PROFILE/EDIT, Screen19 SETTINGS, Screen20 PAYMENT HISTORY. Wallet is a NEW proposed route requiring separate IA and financial product approval. No direct Screen18 production work hidden inside 17.
- Track identity/wallet/backend decisions in [#172](https://github.com/Essxm01/KONFRM/issues/172); account integration in [#171](https://github.com/Essxm01/KONFRM/issues/171); screen scope in [#170](https://github.com/Essxm01/KONFRM/issues/170). Previous evidence retention [#155](https://github.com/Essxm01/KONFRM/issues/155).

## 1. Verified inspiration — principles, not copying
1. Airbnb profile 2025 (official redesigned profile + user trust) and user photo guidance: trust + photo identity + owned travel, not settings-admin look. https://news.airbnb.com/product-releases/airbnb-2025-summer-release and https://www.airbnb.com/help/article/3515
2. Pinterest (official share profile): easily share a personal identity/link without making phone/email public; separate sharing UI from Account navigation. https://help.pinterest.com/en/article/share-pins-and-boards-to-social-networks
3. WhatsApp profile + QR-code pattern is a *UX inspiration*, not authority for QR payload or social graph; expose "رمزي" and "مسح رمز" only after deciding profile visibility/identity. No sensitive data in QR.
4. Apple account linking guidelines explicitly allow linking existing identity from Settings; Google describes explicit consent and shared name/email/avatar. Never claim existing OAuth linking works. https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple and https://support.google.com/accounts/answer/12849458
5. Android scoped system Photo Picker minimizes full gallery access; crop/photo capture can be a later secured implementation. https://developer.android.com/training/data-storage/shared/photo-picker
6. Mobbin may be consulted for reference **only where accessible**. Do not claim complete/paywalled Mobbin screen coverage; do not scrape protected assets or clone brand imagery/trade dress.

## 2. Original art direction — "KONFRM Personal Passport" / «مساحتي في كونفرم»
Make the first fold emotionally personal and functionally useful, without ornamental empty blocks:
- Root header: `حسابي` right; a discrete QR-entry icon on the opposite physical LEFT side. Settings link accessible but not compete with avatar/name.
- Identity hero: genuine **consented/approved demo portrait asset** in a larger circular, elegantly framed 96–112dp avatar (and honest initials silhouette fallback for no photo); an unmistakable small camera/pencil badge overlaps the **physical lower edge** of photo. Full tap area >=48dp. Do not claim demo portrait is customer's real image. Actual image when production-approved must load from canonical avatar URL. No stock portrait presented as verified personal identity.
- Main name (bold Cairo) clearly visible, optional `@username` ONLY as separate **proposed** label in developer fixtures; never invent unique handle for actual customer. Avoid full/masked phone near hero, do not display DOB, age, gender or contact info in public Account Home hero. A single compact `تعديل الملف` route to Screen18.
- No fake verified badges, KYC status, followers, badges, 'travel score' or fabricated personalized trip counts.
- Immediately usable compact actions (`حجوزاتي`, `المفضلة`, `الإشعارات`) with justified, coherent icon rhythm. Only show count if authoritative, or clearly QA fixture.
- Contextual strip (0/1): actual upcoming reservation ONLY IF present and authorized; otherwise no empty promo filler. Avoid duplication of main bottom tabs' entire functionality.
- Payment section: preview most recent actual paid transaction/receipt status if available; otherwise honest entry `سجل المدفوعات` to Screen20. Do not invent money amounts, balance, cashback or refunds.
- Profile/private controls: `الملف الشخصي`, `الخصوصية والأمان`, `الإعدادات`, `المساعدة والدعم` with a calm grouped divider pattern rather than 6 separated tall cards. Sign out reachable near bottom. At end a tasteful `شارك كونفرم` strip (generic official share ONLY; personal referral ID and rewards conceptual pending policy).
- Emphasize premium by rhythm, portrait crop, motion subtlety, microfeedback, typography, responsive constraints and privacy. No rainbow badges, bright blues, gradients, advertising cards, empty 300px spacers or social follower grid.
- At 200% font: identity hero switches to vertical, no name/handle collision with avatar/camera; 4-tab bottom navigation remains canonical and fully readable.

## 3. Screen18 full-profile vision — SEPARATE DESIGN CONCEPT
**Avatar flow:** tap image/camera badge -> choose `التقاط صورة`, `اختيار من الصور`, `عرض الصورة`, optional remove -> platform picker with permission rationale -> 1:1 square crop with pan/zoom/rotate as supported -> circular preview -> Save/Cancel, failures, retake and remove; no fake server-success state. Prototype can use a real licensed/test-consented image asset, but backend storage remains gated.

**Fields:** fullName editable; optional proposed globally unique handle with availability/policy pending; DOB optional private with age **derived automatically** (never editable independent age); optional private gender with prefer-not-to-say; fields not shown in root hero or shared by default. Optional travel preferences only by explicit consent; avoid forcing disclosure.

**Security/connected accounts belongs in Screen19 Settings/linked-identities sub-flow:** verified existing phone/email masked on Account Home and more detail under authenticated profile; add/verify missing email after phone signup and missing phone after email signup by separate verification challenge, collision handling, reauthentication, no direct unsanctioned PATCH. Google & Apple linking rows with accurate real status when implemented; mock/demo statuses only in dedicated QA variants. Never silently merge identities or unlink sole usable login. Preserve Apple private relay confidentiality.

## 4. Personal QR UX — design concept with product contract OPEN
- Screen17 upper-corner icon opens dedicated modal/surface with `رمزي` and `مسح رمز`. QR may be used to exchange a *proposed public profile* after Founder decides discoverability, private-public separation, link permissions, guest access, expiry/revocation, report/block.
- QR's encoded content must NEVER be raw phone, email, birthday, gender, account UUID, backend primary key, payment info, access token or login credential. Use an opaque scoped short link/token only after approved backend. Scanner should detect malformed/expired/unauthorized/offline QR gracefully.
- For now a clearly labeled DEMO visual placeholder with no claim of scannable personal account identity or working scan, not an exposed real QR code.

## 5. Wallet — special financial gate, NOT 'payments history'
- Founder requests a polished wallet experience with optional top-up and any approved admin-dispute fee refund possibly credited to wallet. No such stored-value rules are currently approved.
- DESIGN CONCEPT: `محفظتي` entry (only developer-proposed where policy pending); wallet full-view hierarchy: available balance vs pending refund, top-up, real transaction ledger, dispute refund source and destination, downloadable receipt only if issued, problem/help state, pending/failed/reversed/success distinctions.
- Never silently claim disputed fees are refundable, credited to wallet, available for withdrawal, or usable for bookings. Admin dispute approval is NOT automatically a financial transaction. Need distinct Founder decision about refunds to original source vs stored-value credit, approvals, rails, custody, accounting, compliance and liabilities.
- The actual Screen20 remains `سجل المدفوعات`, showing authoritative payments and refunds when available; do not silently repurpose it as wallet.
- Prototype wallet states can be captured ONLY as clearly tagged proposed developer design. No live CTA pretending to top-up, refund, link payment methods or expose balance.

## 6. Engineering split and QA
**Can design now:** New isolated Screen17 V2 and separate Screen18/19/wallet UX blueprint, dev-only sample crop/QR mock preview if genuinely helpful for Founder visual judgment. Never merge unsupported feature UI into customer-facing real screens as if live.

**Before real integration:** user-owned photo storage path/resize/EXIF stripping/file type enforcement/privacy/access/cache; verified account identity and handle uniqueness across roles; DOB/gender necessity/visibility/minors; Google/Apple server OAuth and consent; phone/email verification; private QR token/deep-links; payments/refunds/top-up ledger/compliance; referral program terms; E2E/QA. Track #172.

**Screen17 visual deliverable:** 1 recommended composition and at most 1 compact hero alternative. Real A56 representative physical captures incl. normal, 200%, guest, with/without photo, useful scrolled feed. New add-only directory `review-evidence/customer-screen17/v2-premium/`, never overwrite V1. Include source, manifest, exact commit, approvals vs proposals matrix. Test what visibly matters; other release-only tests deferred. Never start Screen18 implementation without explicit next-phase authorization.

**No production changes:** `customer_app/lib/`, Supabase/DB, Backend, payments, wallet balance, real Apple/Google linking, identity business rules, role changes, shared design-system edits, merge/deploy. Founder final visual approval required.
