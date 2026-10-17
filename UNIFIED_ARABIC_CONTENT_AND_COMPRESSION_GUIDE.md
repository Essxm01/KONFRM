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
2. **Concise:** Communicating core facts in clear Arabic lines using authentic hospitality vocabulary.
3. **Epistemically Honest:** Never claiming automated platform capabilities, instant refunds, key handover times, or tax statuses that have not been authoritatively confirmed.
4. **Context-Appropriate:** Applying layout compression sensibly per screen archetype rather than forcing every screen blindly into a single pattern.

---

## 2. Header Layout & Visual Restraint Guidelines

### The Core Problem
Early customer screens accumulated unnecessary vertical clutter: redundant subtitles, duplicate property chips, repetitive status banners, and illustrative QA disclaimers. This wasted valuable viewport space, especially when the software keyboard opened or under 200% accessibility font scaling.

### Archetype-Specific Header Restraint:
1. **Nested Conversational / Detail Screens (e.g., Screen 22):**
   - Single-line app bar with physical right Back arrow `[➔]`, concise bold Cairo title, and collapsible context disclosure to maximize message or scroll headroom.
2. **Form & Verification Flows (e.g., Screens 08, 09, 10):**
   - Clean app bar with physical right Back arrow `[➔]`, concise step title, and discrete progress indicator without secondary banners.
3. **Search & Discovery Screens (e.g., Screens 04, 05):**
   - Embedded search bar or query header with physical right Back arrow `[➔]`, clean filter chips, and zero duplicated summary banners.
4. **Hero & Property Views (e.g., Screen 06):**
   - Immersive hero visual with floating physical right Back button `[➔]` overlaid on scrim, keeping action controls accessible without obstructing media.
5. **Review & Payment Screens (e.g., Screens 07, 14):**
   - Clear transaction header with physical right Back arrow `[➔]`, booking identifier, and structured card breakdown without redundant security disclaimers.

---

## 3. Epistemic Content Truth: Approved Vocabulary vs Banned Claims

| Domain | Banned Unapproved Phrasing | Approved Canonical Arabic Vocabulary | Governing Rationale |
|---|---|---|---|
| **Deposit / Down Payment** | «المبلغ المطلوب دفعه حالياً»<br>«قيمة الحجز الإجمالية»<br>«عربون غير قابل للاسترداد»<br>«المتبقي يُسدد عند الوصول» | **«عربون الليلة الأولى»**<br>(دون اختلاق شروط الاسترداد أو موعد سداد المتبقي) | Founder Directives & Canon (Issue #184). Only «عربون الليلة الأولى» is approved. Refundability conditions and remainder payment timing remain OPEN under MR-15. |
| **Booking Status** | «مؤكد فورياً»<br>«جاري إتمام الحجز تلقائياً» | **«قيد الانتظار»**<br>(«بانتظار موافقة المالك») | Master Rules MR-15 & Screen 21 FAQ Truth. Booking is not confirmed until Owner approves. |
| **Cancellation Policy** | «يمكنك إلغاء الحجز مجاناً في أي وقت»<br>«استرداد كامل وفوري» | **«وفق سياسة الإلغاء المحددة لهذا العقار»**<br>«يرجى مراجعة تفاصيل سياسة الإلغاء» | Precludes unsupported instant refund claims; cancellation terms depend on property tier and time to check-in. |
| **Chat Delivery Status** | Double blue ticks<br>«تمت القراءة»<br>«المالك يكتب الآن...» | **علامة صح واحدة «✓» فقط**<br>(تؤكد استلام الخادم للرسالة) | Issue #191 & Prelive Gate #190. Prohibits phantom delivery claims in the absence of live WebSocket infrastructure. |
| **Offline Mode** | «أنت غير متصل — سيتم إرسال الرسالة تلقائياً فور عودة الشبكة» | **«لا يوجد اتصال بالإنترنت — وضع تحرير المسودة نشط»** | Truthful draft preservation. Never promise automated background queueing without verified background services. |
| **Timeout / Uncertainty** | «خطأ غير معروف في الخادم — حاول مرة أخرى» | **«تعذر تأكيد تسليم الرسالة من الخادم»**<br>(مع زر واحد: «مراجعة المسودة») | Neutral recovery notice. Suppresses duplicate submissions caused by frantic tapping. |
| **Booking Identifiers** | «BK-183223-EG»<br>«REF_UUID_881249» | **«رقم الحجز 183223»**<br>(أرقام فقط بدون بادئات داخلية) | Clean customer-safe formatting. Technical UUIDs and internal database prefixes remain internal. |
| **Legal / Tax Authority** | «شركة كونفرم للتقنية ش.م.م»<br>«سجل ضريبي رقم 998-124-332» | **«كونفرم — KONFRM»**<br>(دون اختلاق كيان قانوني أو رقم ضريبي) | Screen 20 Founder Directive. Legal entity and tax registration remain PRELIVE-gated until verified. |

---

## 4. The Anti-Panic Rule: Ban on Amber & Red Warning Banners

Full-width amber (`#F59E0B`, `#FEF3C7`) and harsh red (`#EF4444`) banner strips create unnecessary user anxiety and cheapen the premium interface aesthetic.

### Formatting Mandate:
1. **Zero Amber Strips:** Offline, draft, and timeout states must use subtle, monochromatic neutrals (`#F3F4F6` background, `#374151` dark text, `#9CA3AF` discrete icons).
2. **Contextual Status Indicators:** Status notices must be positioned immediately adjacent to the affected action (e.g., directly above the composer input or primary CTA), not floating disconnected at the top of the viewport.
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
