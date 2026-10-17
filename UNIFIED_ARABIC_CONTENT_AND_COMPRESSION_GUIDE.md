# KONFRM Unified Arabic Content & Layout Compression Guide
## (دليل توحيد المحتوى العربي والاختزال البصري لتطبيق العميل)

**Authority:** KONFRM Design Canon & Founder Master Directives  
**Governing Issues:** [Issue #192](https://github.com/Essxm01/KONFRM/issues/192), [Issue #191](https://github.com/Essxm01/KONFRM/issues/191), [Issue #185](https://github.com/Essxm01/KONFRM/issues/185), [Issue #184](https://github.com/Essxm01/KONFRM/issues/184), [Issue #175](https://github.com/Essxm01/KONFRM/issues/175), [Issue #166](https://github.com/Essxm01/KONFRM/issues/166)  
**Applicability:** Universal standard across Customer Screens 01–22.

---

## 1. The Core Philosophy: Quiet Authority & Informational Restraint

KONFRM is an elite Arabic-first vacation rental marketplace. Its design language rejects administrative bureaucracy, wall-of-text disclaimers, and noisy multi-layer headers.

Every screen must breathe. Content should be:
1. **Calm:** Eliminating loud banners, yellow/amber warning boxes, and redundant explanatory paragraphs.
2. **Concise:** Communicating core facts in one or two clear Arabic lines using authentic hospitality vocabulary.
3. **Epistemically Honest:** Never claiming automated platform capabilities, instant refunds, key handover times, or tax statuses that have not been authoritatively confirmed.

---

## 2. Header Layout Compression: The Single-Line Law

### The Problem
Early customer screens accumulated vertical clutter:
- Row 1: App bar with Back button and Title.
- Row 2: Secondary subtitle («المالك • فيلا لؤلؤة البحر»).
- Row 3: Sticky booking context strip («14 – 18 يوليو 2026 • مؤكد»).
- Row 4: Scope security chip or advisory notice.

This stolen vertical real estate compressed usable viewport space on mobile devices, especially when the software keyboard opened or when 200% accessibility text scaling was active.

### The Canonical Pattern: Single-Line Header with Collapsible Disclosure
As proven and verified in Customer Screen 22:
1. **App Bar is Strictly Single-Line:**
   - Far Right: Physical Back button `[➔]`.
   - Title: Short, punchy title in 16pt bold Cairo, pure black `#000000` (e.g. «محادثة الحجز»).
   - Adjacent Chevron: Small toggle icon (`<` when collapsed, `v` when expanded).
   - Far Left: Tappable reference link with underline (e.g. «رقم الحجز 183223») that leads directly to parent details without occupying extra screen rows.
2. **Collapsible Disclosure Panel:**
   - Starts strictly **collapsed** by default.
   - When tapped, it smoothly discloses secondary context (Property Name, Stay Dates, Status Badge).
   - Maximizes conversation, feed, or form real estate.

---

## 3. Epistemic Content Truth: Approved Vocabulary vs Banned Claims

| Domain | Banned Unapproved Phrasing | Approved Canonical Arabic Vocabulary | Governing Rationale |
|---|---|---|---|
| **Deposit / Down Payment** | «المبلغ المطلوب دفعه حالياً»<br>«قيمة الحجز الإجمالية» | **«عربون الليلة الأولى»**<br>(«والمتبقي يُسدد عند الوصول») | Founder Unified Receipt Contract (Issue #184). Prevents customer assumption that first payment covers the entire stay. |
| **Booking Status** | «مؤكد فورياً»<br>«جاري إتمام الحجز تلقائياً» | **«قيد الانتظار»**<br>(«بانتظار مراجعة وموافقة المالك») | Master Rules MR-15 & Screen 21 FAQ Truth. Booking is not confirmed until Owner approves. |
| **Cancellation Policy** | «يمكنك إلغاء الحجز مجاناً في أي وقت»<br>«استرداد كامل وفوري» | **«وفق سياسة الإلغاء المحددة لهذا العقار»**<br>«يرجى مراجعة تفاصيل سياسة الإلغاء» | Precludes fraudulent instant refund claims; cancellation eligibility depends on property tier and time to check-in. |
| **Chat Delivery Status** | Double blue ticks<br>«تمت القراءة»<br>«المالك يكتب الآن...» | **علامة صح واحدة «✓» فقط**<br>(تؤكد استلام الخادم للرسالة) | Issue #191 & Prelive Gate #190. Prohibits phantom delivery claims in the absence of live WebSocket infrastructure. |
| **Offline Mode** | «أنت غير متصل — سيتم إرسال الرسالة تلقائياً فور عودة الشبكة» | **«لا يوجد اتصال بالإنترنت — وضع تحرير المسودة نشط»** | Truthful draft preservation. Never promise automated background queueing without verified OS background service. |
| **Timeout / Uncertainty** | «خطأ غير معروف في الخادم — حاول مرة أخرى» | **«تعذر تأكيد تسليم الرسالة من الخادم»**<br>(مع زر واحد: «مراجعة المسودة») | Neutral recovery notice. Suppresses duplicate submissions caused by frantic tapping. |
| **Booking Identifiers** | «BK-183223-EG»<br>«REF_UUID_881249» | **«رقم الحجز 183223»**<br>(أرقام فقط بدون بادئات داخلية) | Clean customer-safe formatting. Technical UUIDs and internal database prefixes remain internal. |
| **Legal / Tax Authority** | «شركة كونفرم للتقنية ش.م.م»<br>«سجل ضريبي رقم 998-124-332» | **«كونفرم — KONFRM»**<br>(دون اختلاق كيان قانوني أو رقم ضريبي) | Screen 20 Founder Directive. Legal entity and tax registration remain PRELIVE-gated until verified. |

---

## 4. The Anti-Panic Rule: Ban on Amber & Red Warning Banners

Full-width amber (`#F59E0B`, `#FEF3C7`) and harsh red (`#EF4444`) banner strips create unnecessary user anxiety and cheapen the premium interface aesthetic.

### Formatting Mandate:
1. **Zero Amber Strips:** Offline, draft, and timeout states must use subtle, monochromatic neutrals (`#F3F4F6` background, `#374151` dark text, `#9CA3AF` discrete icons).
2. **Contextual Status Indicators:** Status notices must be positioned immediately adjacent to the affected action (e.g., directly above the composer input), not floating disconnected at the top of the viewport.
3. **Single Actionable Recovery:** When an error occurs, provide exactly **one clear action button** (e.g. «مراجعة المسودة» or «إعادة المحاولة»), never dual conflicting actions.

---

## 5. Pure Black `#000000` Hierarchy (Issue #175)

In compliance with the Founder's absolute pure black mandate:

```dart
// Canonical Color Tokens for Customer App
const Color kKonfrmPureBlack = Color(0xFF000000);   // Primary text, Active CTAs, Leading Icons
const Color kKonfrmBodyDark  = Color(0xFF1F2937);   // Body paragraphs, Host bubble text
const Color kKonfrmMetaGray  = Color(0xFF6B7280);   // Secondary metadata, Timestamps, Labels
const Color kKonfrmBorder    = Color(0xFFE5E7EB);   // Clean 1px structural dividing lines
const Color kKonfrmSurface   = Color(0xFFFFFFFF);   // Cards, Guest bubbles, Input containers
const Color kKonfrmCanvas    = Color(0xFFF9FAFB);   // Scaffolding canvas background
```

All previous uses of `#1E1E1E`, `#111827`, and dark slate blues are permanently obsolete.
