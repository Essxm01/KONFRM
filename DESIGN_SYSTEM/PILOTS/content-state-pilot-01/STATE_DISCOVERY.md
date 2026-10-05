# Phase 4G — Content & State Presentation System Discovery

**Document Version:** 1.0.0  
**Phase:** Phase 4G — Content & State Presentation System  
**Status:** `PILOT_DISCOVERY_DRAFT`  
**Context:** Empirical inventory of real state presentation patterns across `customer-app/`, `owner-app/`, and `admin-app/`.

---

## 1. Executive Summary & Defect Audit

### 1.1 Historical Defect Audit (Section 17)

| Defect ID | Role | Domain / Component | Historical Finding | Real Code Audit Status (Phase 4G) | Evidence & Code Location |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **C-01** | Customer | Explore / Search (`App.tsx`) | Failed property search clears `properties`/`filteredProperties` on non-success, looking like "no properties exist". | **`RESOLVED`** | In `customer-app/src/App.tsx` (lines 454–458, 1584–1596), `propertyLoadState` explicitly distinguishes `'LOADING'` (`<ExploreSkeletonFeed />`), `'ERROR'` (`<ExploreErrorView />` with title, message, and retry button), and `filteredProperties.length === 0` (`<ExploreEmptyView />`). Error never renders as Empty. |
| **C-02** | Customer | Payments / History (`CustomerWalletModal.tsx`) | Failed payment history read clears payments and renders zero-data empty state. | **`RESOLVED`** | In `customer-app/src/components/CustomerWalletModal.tsx` (lines 29–44, 79–90), `paymentLoadState` explicitly distinguishes `'LOADING'`, `'ERROR'` (renders dedicated rose error banner with error message and retry button), and `payments.length === 0` (clean zero-data empty state). Error does not masquerade as Empty. |
| **C-04** | Customer | Profile / Account Restoration (`CustomerEditAccountPage.tsx`) | Profile/account restoration catches silently, leaving stale or empty account presentation. | **`RESOLVED`** | In `customer-app/src/components/CustomerEditAccountPage.tsx` (lines 134, 474–490), `profileLoadState` explicitly tracks `'IDLE' \| 'LOADING' \| 'READY' \| 'NETWORK_ERROR'`. On `'NETWORK_ERROR'`, an explicit recovery banner is rendered. |
| **O-03** | Owner | Notifications, Disputes, Payout Metadata (`AppContext.tsx`) | Quietly falls back to empty arrays for notifications, disputes, and payout metadata on failure, masking operational failure. | **`PARTIALLY_FIXED`** | In `owner-app/src/context/AppContext.tsx`, notifications has an explicit `notificationsError` state (`lines 59–60, 198, 1210`). However, lines 336–337 still use `.catch(() => [])` for `repo.payout.getPayoutMethods()` and `repo.payout.getPayoutRequests()`, and disputes catch silently without dedicated error state. Operational payout/dispute failure can still look like an empty list. |
| **A-01** | Admin | Session Entry / Shell (`App.tsx`, `adminTruthfulState.ts`) | Authenticated shell rendered from local `sola_admin_user` before canonical backend validation, risking stale display. | **`RESOLVED`** | In `admin-app/src/App.tsx` (lines 134–140) and `adminTruthfulState.ts`, `bootstrapState` starts as `'RESTORING'` and renders a centered session verification skeleton until canonical `/admin/auth/session` returns valid. `shouldRenderAdminShell()` strictly requires `'AUTHENTICATED'`. |
| **A-02** | Admin | Overview Metrics (`App.tsx`, `StateViews.tsx`) | Overview/notification requests catch quietly; overview renders fallback `0` metrics and "stable" copy. | **`RESOLVED`** | In `admin-app/src/App.tsx` (lines 101–115, 348–354), `overviewState` explicitly tracks `'LOADING' \| 'SUCCESS' \| 'ERROR'`. On `'ERROR'`, it renders `<ErrorState title="تعذر تحميل المؤشرات التشغيلية" message="لم يتم استلام بيانات موثوقة للنظرة العامة. لم تُعرض أي أرقام بديلة." onRetry={...} />`. No false 0 metrics are rendered. |

---

## 2. Comprehensive State Inventory by Role

### 2.1 Customer Experience Surfaces

| Record ID | Screen / Domain | Data Source | State Type | Current Trigger | Current Presentation | Current Copy | Recovery Action | Delivery / Lifespan | Server Auth? | Known Problem | Authority Class | Directive |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **C-ST-01** | Explore Feed | `GET /customer/properties/search` | `LOADING` | Initial load / filter apply | 3 vertical skeleton cards with 1.4:1 ratio image + text lines | None (`role="status"` aria-label) | None | Screen Section | Yes | None; good shape preservation | Implemented Code | **PRESERVE** |
| **C-ST-02** | Explore Feed | `GET /customer/properties/search` | `EMPTY` (Zero Matches) | No properties match query filters | Centered card with Compass icon, title, subtitle | "لسه مفيش إقامات هنا" / "جرّب مرة تانية لاحقًا." | Filter adjustment | Screen Section | Yes | Needs clear distinction between zero filter matches vs empty global catalog | Implemented Code | **CHANGE** (Separate Zero Search Results from Marketplace Empty) |
| **C-ST-03** | Explore Feed | `GET /customer/properties/search` | `ERROR` | Network failure / 500 error | Red-tinted card with AlertCircle, title, message, retry CTA | "تعذر تحميل الإقامات" / "حاول مرة تانية." | "إعادة المحاولة" button | Screen Section | Yes | Uses legacy `#0059FF` blue button; needs semantic neutral/danger alignment | Implemented Code | **PRESERVE** (Structure) / **CHANGE** (Styling) |
| **C-ST-04** | Property Detail | `GET /customer/properties/:id/availability` | `LOADING` | Calendar date picker opened | In-place spinner on calendar grid | "جارٍ التحقق من التوافر..." | None | In-Place Section | Yes | Good in-place progress | Implemented Code | **PRESERVE** |
| **C-ST-05** | Property Detail | `GET /customer/properties/:id/quote` | `LOADING` | Dates selected, calculating pricing | Sticky bar disabled with skeleton / spinner | "جارٍ احتساب السعر..." | None | Sticky Surface | Yes | Prevents premature booking request | Implemented Code | **PRESERVE** |
| **C-ST-06** | Property Detail | `POST /customer/properties/:id/quote` | `ERROR` / `CONFLICT` | Dates unavailable / price mismatch | Inline error text below pricing breakdown | "التواريخ المحددة غير متاحة حالياً" or price change notice | Change dates | Inline / Section | Yes | Revalidation failure must block CTA without taking down property presentation | Implemented Code | **PRESERVE** |
| **C-ST-07** | Booking Review (Screen 07) | `POST /customer/bookings/request` | `SUBMITTING` | User taps "إرسال طلب الحجز" | Button disabled with spinner, label updates | "جارٍ إرسال الطلب..." | None | Button In-Flight | Yes | Duplicate submission prevented | Implemented Code | **PRESERVE** |
| **C-ST-08** | Booking Sent (Screen 11) | `BookingRequestSentScreen.tsx` | `SUCCESS` | Server confirms booking request created | Full-screen confirmation surface with green checkmark, lifecycle recap, CTA | "تم إرسال طلب الحجز بنجاح" / "طلبك وصل للمالك وسيتم إشعارك فور الرد" | "متابعة الطلب في حجوزاتي" | Full Page | Yes | Truthful request lifecycle; does NOT claim booking is confirmed | Implemented Code | **PRESERVE** |
| **C-ST-09** | My Bookings (Screen 12) | Guest Session | `UNAUTHORIZED` (Guest) | Unauthenticated user visits Bookings tab | Centered guest state card with lock icon, explanation, CTA | "سجّل الدخول لعرض حجوزاتك" / "تابع طلبات الحجز والإقامات القادمة" | "تسجيل الدخول" (opens Auth V2) | Screen State | Yes | Fails closed; clears private state cleanly | Implemented Code | **PRESERVE** |
| **C-ST-10** | My Bookings (Screen 12) | `GET /customer/bookings` (401) | `UNAUTHORIZED` (Session Expired) | Stale token / 401 response | Amber-bordered session expired card with CTA | "انتهت جلسة تسجيل الدخول" / "سجّل الدخول مجددًا لمتابعة حجوزاتك" | "تسجيل الدخول مجددًا" | Screen State | Yes | Violates Founder Rule MR-17 (uses amber-bordered card) | Implemented Code | **CHANGE** (Neutral/soft-blue treatment; eliminate amber box) |
| **C-ST-11** | My Bookings (Screen 12) | `GET /customer/bookings` (200, []) | `EMPTY` (True Empty) | Authenticated user with 0 bookings | Centered card with suitcase icon, title, subtitle, CTA | "لا توجد حجوزات بعد" / "استكشف الإقامات المتاحة وقدّم أول طلب حجز" | "استكشف الإقامات" | Screen State | Yes | Clean empty state; routes to Explore tab | Implemented Code | **PRESERVE** |
| **C-ST-12** | My Bookings (Screen 12) | `APPROVED_PENDING_PAYMENT` | `ACTION_NEEDED` | Owner approved booking request | Booking card in "يحتاج إجراء منك" section with payment CTA | "تمت الموافقة — مطلوب سداد العربون" / "سداد العربون لتأكيد الحجز" | "متابعة إلى الدفع" (routes to Screen 14) | Card Surface | Yes | Blocks dates; distinct attention from normal pending | Implemented Code | **PRESERVE** |
| **C-ST-13** | My Bookings (Screen 12) | `PENDING_OWNER_APPROVAL` | `IN_PROGRESS` (Process) | Booking request awaiting Owner response | Booking card with subtle badge | "بانتظار موافقة المالك" | None (awaiting Owner) | Card Surface | Yes | Must NOT be treated as warning/failure; normal operational state | Implemented Code | **PRESERVE** |
| **C-ST-14** | Favorites (Screen 15) | `GET /customer/favorites` | `EMPTY` | Authenticated user with 0 saved stays | Centered card with Heart icon, title, subtitle, CTA | "قائمة المفضلة فارغة" / "احفظ الإقامات التي تعجبك للرجوع إليها بسهولة" | "استكشف الإقامات" | Screen State | Yes | Proper server-authoritative empty state | Implemented Code | **PRESERVE** |
| **C-ST-15** | Favorites (Screen 15) | Mutation in-flight | `SUBMITTING` | Heart button tapped | In-flight ID set; heart pulse/disable | None | None | Micro-Control | Yes | Race-safe optimistic update with server rollback | Implemented Code | **PRESERVE** |

---

### 2.2 Owner Experience Surfaces

| Record ID | Screen / Domain | Data Source | State Type | Current Trigger | Current Presentation | Current Copy | Recovery Action | Delivery / Lifespan | Server Auth? | Known Problem | Authority Class | Directive |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **O-ST-01** | Home Dashboard | `ownerBootstrap.ts` | `LOADING` | App mount / session restore | Skeleton cards across top stats, pending bookings, and properties | None | None | Screen Skeletons | Yes | Preserves layout structure well | Implemented Code | **PRESERVE** |
| **O-ST-02** | Home Dashboard | `RecentBookingsSection.tsx` | `EMPTY` | 0 pending or active bookings | Subtle card with Calendar/Check icon | "لا توجد طلبات حجز حالياً" / "ستظهر هنا الطلبات الجديدة فور تقديمها" | None | Section Surface | Yes | Truthful operational empty state | Implemented Code | **PRESERVE** |
| **O-ST-03** | Home Dashboard | Wallet fetch failure | `PARTIAL` | Wallet fails but bookings/properties succeed | Dashboard shows error banner on wallet section only | "تعذر تحميل بيانات المحفظة" | Retry wallet fetch | Section Alert | Yes | Must not fake 0 balance or take down rest of dashboard | Implemented Code | **PRESERVE** |
| **O-ST-04** | Bookings Queue | `GET /owner/bookings` | `LOADED` (`PENDING_OWNER_APPROVAL`) | Guest submitted booking request | Operational item with guest details, stay dates, net payout, Approve / Reject CTAs | "طلب حجز جديد" / "يحتاج قرارك" | Approve (Primary) / Reject (Secondary Destructive) | Queue Item | Yes | Clear operational action priority | Implemented Code | **PRESERVE** |
| **O-ST-05** | Bookings Queue | `POST /owner/bookings/:id/decision` | `SUBMITTING` | Owner taps Approve or Reject | Button shows spinner, disables other button | "جارٍ الحفظ..." | None | Button In-Flight | Yes | Prevents dual submission / race | Implemented Code | **PRESERVE** |
| **O-ST-06** | Properties List | `GET /owner/properties` (200, []) | `EMPTY` (First-Run) | Owner has 0 properties registered | Dedicated hero card with Plus icon, onboarding copy, primary CTA | "أضف أول وحدة لك على كونفرم" / "ابدأ في استقبال طلبات الحجز وتحقيق العوائد" | "إضافة وحدة جديدة" | Screen State | Yes | Encourages valid next operational action | Implemented Code | **PRESERVE** |
| **O-ST-07** | Properties List | `PropertyItem` status | `DOMAIN_STATUS` (`PENDING_REVIEW`) | Property submitted for review | Badge on property card | "قيد المراجعة" | None (in Admin queue) | Status Badge | Yes | Normal review lifecycle; must NOT look alarming | Implemented Code | **PRESERVE** |
| **O-ST-08** | Properties List | `PropertyItem` status | `DOMAIN_STATUS` (`REJECTED`) | Admin rejected property | Badge on property card + plain Arabic reason | "مرفوضة" / "راجع الملاحظات وعدّل الوحدة لإعادة الإرسال" | Edit & Resubmit | Card + Badge | Yes | Truthful failure; actionable recovery | Implemented Code | **PRESERVE** |
| **O-ST-09** | Wallet | `GET /owner/wallet` | `LOADED` (`PENDING` vs `AVAILABLE`) | Wallet balances loaded | Two distinct balance boxes: Available vs Pending with 24h explanation | "الرصيد المتاح للسحب: X ج.م" / "الرصيد المعلق: Y ج.م (يتاح بعد 24 ساعة من الدخول)" | "طلب سحب الأرباح" (enabled only if Available >= 500) | Metric Panels | Yes | Clear distinction between pending and available | Implemented Code | **PRESERVE** |
| **O-ST-10** | Wallet | Payout button | `DISABLED` | Available balance < 500 EGP or pending verification | Button disabled with explanatory caption | "زر السحب غير نشط: الحد الأدنى للسحب 500 ج.م" | Accumulate balance / verify KYC | Disabled CTA + Helper Text | Yes | Explains unavailable action truthfully | Implemented Code | **PRESERVE** |
| **O-ST-11** | Payout Metadata | `AppContext.tsx` | `ERROR` (Silent Fallback) | Payout API fails | Falls back to `[]` silently (`.catch(() => [])`) | None (renders empty list) | None | Silent Failure | Yes | **Defect O-03:** Must show explicit retryable error rather than empty list | Implemented Code | **REJECT** (Needs explicit error handling) |

---

### 2.3 Admin Experience Surfaces

| Record ID | Screen / Domain | Data Source | State Type | Current Trigger | Current Presentation | Current Copy | Recovery Action | Delivery / Lifespan | Server Auth? | Known Problem | Authority Class | Directive |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **A-ST-01** | Overview | `GET /admin/overview/stats` | `LOADING` | App mount | 4 skeleton metric cards with subtle pulse | None | None | Metric Skeletons | Yes | Structure preserved | Implemented Code | **PRESERVE** |
| **A-ST-02** | Overview | `GET /admin/overview/stats` | `ERROR` | API failure | Explicit error panel; no fake 0 metrics | "تعذر تحميل المؤشرات التشغيلية" / "لم يتم استلام بيانات موثوقة للنظرة العامة. لم تُعرض أي أرقام بديلة." | "إعادة المحاولة" | Section Alert | Yes | Fixed A-02; truth-preserving | Implemented Code | **PRESERVE** |
| **A-ST-03** | Property Queue | `GET /admin/properties/review` (200, []) | `EMPTY` | All properties reviewed; 0 in queue | Centered table placeholder with CheckCircle icon | "لا توجد وحدات بانتظار المراجعة" / "تمت مراجعة جميع الوحدات المقدمة حتى الآن." | None (operational clean queue) | Table Empty State | Yes | Distinguishes clean queue from query failure | Implemented Code | **PRESERVE** |
| **A-ST-04** | Property Queue | `GET /admin/properties/review` (500) | `ERROR` | Database query failure | Full table replacement with red-tinted error container | "تعذر تحميل قائمة المراجعة" / "حدث خطأ أثناء جلب البيانات من الخادم." | "إعادة المحاولة" | Table Error State | Yes | Fails closed; never renders empty queue | Implemented Code | **PRESERVE** |
| **A-ST-05** | Decision Action | `POST /admin/properties/:id/decision` | `SUBMITTING` | Admin submits approval or rejection | Modal action buttons disabled with spinner | "جارٍ تسجيل القرار..." | None | Modal In-Flight | Yes | Prevents double audit entry | Implemented Code | **PRESERVE** |
| **A-ST-06** | Session Restore | `/admin/auth/session` | `RESTORING` | Page load with token | Centered modal with spinner | "جارٍ التحقق من جلسة الإدارة…" | None | Screen Gate | Yes | Prevents unauthenticated operational shell render (Fixed A-01) | Implemented Code | **PRESERVE** |
| **A-ST-07** | Session Expired | API returns 401/403 | `UNAUTHORIZED` | Expired token during review | Clears local session, redirects to login with session expired notice | "انتهت جلسة المشرف. يرجى تسجيل الدخول مجددًا للمتابعة." | "تسجيل الدخول" | Login Route | Yes | Fails closed immediately | Implemented Code | **PRESERVE** |

---

## 3. Key Discovery Insights for Phase 4G

1. **Progress Made Since Early Audits:**
   - C-01 (Explore empty vs error) is **`RESOLVED`** in `App.tsx`.
   - C-02 (Wallet modal empty vs error) is **`RESOLVED`** in `CustomerWalletModal.tsx`.
   - C-04 (Profile restoration) is **`RESOLVED`** in `CustomerEditAccountPage.tsx`.
   - A-01 (Admin session gate) is **`RESOLVED`** in `adminTruthfulState.ts`.
   - A-02 (Admin fake 0 metrics) is **`RESOLVED`** in `App.tsx`.
2. **Remaining Legacy Defects to Reconcile:**
   - O-03 remains **`PARTIALLY_FIXED`**: Payout methods and requests still fall back to empty arrays on catch in `AppContext.tsx`. Phase 4G must specify that payout metadata failure must show explicit error/retry instead of empty methods.
   - Screen 12 (My Bookings) currently uses an **amber-bordered session expired card**, violating Founder Rule MR-17 ("NO yellow/amber/orange boxed UI by default"). Must be reconciled to neutral/soft-blue informational treatment.
   - Customer Explore "No properties" copy does not clearly differentiate between **Zero Matches for Active Search Filters** vs **Marketplace Catalog Empty**.
   - Status Badge mappings in `badges.md` currently map `PENDING_OWNER_APPROVAL`, `PENDING_REVIEW`, and `Wallet PENDING` to `warning` semantic types. These are normal process states, not warnings or alarms. Phase 4G must decouple domain business process from visual alarm level.
