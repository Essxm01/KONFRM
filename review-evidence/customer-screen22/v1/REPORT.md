# Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز») Native Flutter V1 Report

**Task:** Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز») Native Flutter Design V1  
**Governing Issues:** [Issue #191](https://github.com/Essxm01/KONFRM/issues/191) (Execution Contract), [Issue #190](https://github.com/Essxm01/KONFRM/issues/190) (Deferred Prelive Gate), [Issue #183](https://github.com/Essxm01/KONFRM/issues/183) (Design Skills & Court Gate), [Issue #175](https://github.com/Essxm01/KONFRM/issues/175) (Pure Black #000000 Rule), [Issue #166](https://github.com/Essxm01/KONFRM/issues/166) (Founder Design Priorities), [Issue #155](https://github.com/Essxm01/KONFRM/issues/155) (Evidence Immutability), [Issue #145](https://github.com/Essxm01/KONFRM/issues/145) (Hardware Serial Redaction)  
**Frozen Base Commit:** `d04f8e5e657502b58886a9b9d0dd934d1a97f20a`  
**Dedicated Branch:** `evidence/customer-screen22-design-review`  
**Physical Hardware:** Samsung Galaxy A56 5G (`SM_A566B`, Android 16 API 36, Serial `[REDACTED_A56_ID]`)  

---

## 1. Executive Summary

This delivery provides the authoritative native Flutter UI/UX design V1 for **Customer Screen 22 — Booking-Scoped Chat («محادثة الحجز»)** in accordance with Founder Issue #191 and its Plan Mode brief.

Screen 22 provides a dedicated, privacy-preserving conversation surface between an authenticated Customer (Guest) and authorized Owner (Host) scoped strictly to an active, verified booking (`#183223` — «فيلا لؤلؤة البحر — مراسي»). The design adheres strictly to Arabic RTL-first interaction, Cairo typography, pure black `#000000` visual language, canonical NESTED_CUSTOMER navigation without a bottom navigation bar, and epistemic honesty regarding message delivery states.

All live communication infrastructure (WebSocket channels, Supabase Realtime presence, push notifications, and server-side chat storage) is strictly deferred to PRELIVE Issue #190.

---

## 2. Information Architecture & Visual Design

### A. Canonical Navigation & App Bar
- **Navigation Model:** `NESTED_CUSTOMER` hierarchical child screen returning to Customer Screen 13 (Booking Details / Hub).
- **Physical Back Button:** Physical right back arrow `[➔]` (`Icons.arrow_forward_rounded`) positioned on the leading right edge in RTL, with a 48×48dp touch target.
- **Header Elements:**
  - Screen Title: «محادثة الحجز» (16pt bold Cairo, pure black `#000000`).
  - Context Subtitle: «المالك • فيلا لؤلؤة البحر — مراسي» (11pt medium Cairo, gray `#6B7280`).
  - Booking Pill: Discrete informational pill `#183223` on the trailing left edge, using sanitized numeric digits with zero raw `BK-` internal prefixes.
- **Bottom Navigation Bar Invariant:** Strictly omitted. Screen 22 is a focused modal communication thread that never displays the customer bottom navigation bar.

### B. Booking Context Strip & Scope Security Notice
- **Sticky Context Strip:** Positioned directly below the app bar divider, providing persistent confirmation of the active booking context:
  - Property Icon & Title: «فيلا لؤلؤة البحر — مراسي (14 يوليو – 18 يوليو)»
  - Discrete Badge: «محادثة مرتبطة بالحجز» (10pt medium Cairo, subtle gray container)
- **Scope Security Banner:** Centered discrete chip informing participants:
  - «هذه المحادثة مخصصة لترتيبات هذا الحجز بينك وبين المالك فقط»
- **Date Separator:** Elegant pill displaying «اليوم» separating message batches.

### C. Message Bubble Grammar & RTL Alignment
- **Outgoing Customer Bubble (Guest / Me):**
  - Aligned to the left (reading end in RTL).
  - Background: Pure black `#000000` (Issue #175 compliance; zero charcoal or navy).
  - Text: Crisp white Cairo typography (14pt, 1.45 line height).
  - Metadata: Subtle white-70 timestamp with truthful delivery status icon.
  - Border Radius: Asymmetric bubble with 16px rounded corners and a 4px anchor on the lower left.
- **Incoming Owner Bubble (Host):**
  - Aligned to the right (reading start in RTL).
  - Identity Header: Circular host avatar icon with «المالك» label.
  - Background: Crisp white with 1px border `#E5E7EB`.
  - Text: Dark Cairo typography (`#1F2937`, 14pt, 1.45 line height).
  - Metadata: Gray timestamp (`#9CA3AF`).
  - Border Radius: Asymmetric bubble with 16px rounded corners and a 4px anchor on the lower right.

### D. Keyboard-Safe Message Composer
- **Layout:** Bottom container with 1px top border `#E5E7EB`, safe area padding, and expanding multiline `TextField`.
- **Placeholder:** «اكتب رسالتك للمالك...»
- **Dynamic Headroom:** Dynamic `BoxConstraints` (min 44dp, max 120dp in normal scale; expanding to 180dp in 200% accessibility mode to eliminate text clipping).
- **Send CTA Button:**
  - 48×48dp circular button.
  - Transitions from disabled gray (`#E5E7EB`) when draft is empty to pure black (`#000000`) when active.
  - Mirrored send icon (`Transform.rotate(angle: π)`) to ensure natural arrow direction in Arabic RTL.

---

## 3. Epistemic Delivery Truth & Recovery States

In strict compliance with Issue #191, phantom delivery claims are completely barred:
- **Prohibited:** No double blue ticks, no fake read receipts, no owner typing indicators, no last seen/online status indicators.
- **Truthful Status Taxonomy:**
  1. `MessageDeliveryStatus.sending`: Local optimistic pending draft with a discrete rotating progress spinner (`CircularProgressIndicator`).
  2. `MessageDeliveryStatus.sent`: Server-acknowledged delivery indicated by a single check mark (`Icons.check_rounded`).
  3. `MessageDeliveryStatus.unknownTimeout`: Network timeout or unconfirmed state. Renders a neutral gray recovery card («تعذر تأكيد تسليم الرسالة حالياً») explaining that the draft was preserved to prevent loss, with a single «مراجعة المسودة» button that suppresses duplicate message creation.
  4. `MessageDeliveryStatus.failed`: Confirmed delivery failure. Renders a subtle red recovery card («فشل تسليم الرسالة») with an «إعادة إرسال الرسالة» retry affordance.

---

## 4. Barrier States & Offline Handling

- **Unauthenticated Guest Shield (`chat_guest_barrier_card`):**
  - Triggered if an unauthenticated user navigates to the thread.
  - Renders a centered card with a lock icon, clear explanation («تسجيل الدخول مطلوب لعرض المحادثة»), and a pure black «تسجيل الدخول» button.
  - Completely suppresses message history, composer, and metadata to eliminate data leakage.
- **Unavailable Thread Barrier (`chat_unavailable_card`):**
  - Triggered for ineligible bookings (e.g., cancelled or expired bookings without an active chat channel).
  - Renders an explanation («المحادثة غير متاحة حالياً») and an «العودة لتفاصيل الحجز» return button.
- **Offline Mode Banner (`screen22_offline_banner`):**
  - Displays a persistent amber warning strip: «أنت في وضع عدم الاتصال — يمكنك كتابة مسودة رسالتك وسيتم إرسالها فور استعادة الاتصال.»
  - Permits draft authoring while disabling the send CTA until connectivity is restored.

---

## 5. Accessibility 200% Font Scale Reflow

Ambient UI reflow was tested and verified under `TextScaler.linear(2.0)` on genuine Samsung Galaxy A56 5G hardware:
- **Conversation Stream:** App bar title, context strip, date pill, and message bubbles wrap naturally without horizontal truncation or RenderFlex overflow bars.
- **Composer Headroom:** The message input container expands dynamically up to 180px in 200% scale mode, ensuring multiline Arabic sentences display with full line height and zero bottom clipping.
- **Touch Targets:** Back button, send CTA, recovery buttons, and barrier buttons all strictly maintain ≥ 48×48dp physical interactive targets.

---

## 6. Verification Evidence & Quality Gates

### A. Static Analysis
```
flutter analyze mobile/apps/customer_app/tool/screen22_preview_runner.dart mobile/apps/customer_app/test/screen22_source_linked_tests.dart
Analyzing 2 items...
No issues found! (ran in 3.1s)
```

### B. Behavioral & Widget Test Suite
```
flutter test test/screen22_source_linked_tests.dart
00:01 +20: All tests passed!
```
The test suite covers:
1. `CustomerBookingChatController` default values, scenario transitions, message manipulation, retry, and draft handling.
2. Sourced conversation fixtures verification (4 messages, alternating customer/owner, correct dates and booking #183223).
3. Invariant tests proving zero double ticks, zero phantom ACKs, zero read receipts, and zero typing status.
4. Negative assertion checks proving zero forbidden test/mock strings (`بيانات تجريبية`, `BK-`, `PRELIVE #190`, fake contact numbers, unapproved external links).
5. Issue #175 pure black compliance check (`#000000` only, zero charcoal/navy).
6. Canonical app bar, right back arrow, absence of bottom navigation bar.
7. Booking context strip with verified dates and details.
8. Message bubbles for both customer and owner with host badge.
9. Message composer input, draft updates, and send interaction.
10. Timeout uncertain recovery notice with single review button suppressing duplicates.
11. Delivery failed recovery notice with retry button.
12. Unauthorized guest barrier shield preventing chat access.
13. Unavailable chat thread card for ineligible bookings.
14. Offline banner when device is disconnected.
15. Accessibility 200% font scale reflow tests for conversation stream.
16. Accessibility 200% font scale reflow tests for composer and input controls.

### C. Physical Hardware Verification (Samsung Galaxy A56 5G)
- **Device Model:** Samsung Galaxy A56 5G (`SM_A566B`)
- **OS Version:** Android 16 (API 36)
- **Physical Resolution:** 1080 × 2340, 2.625× DPR
- **Hardware Serial:** Redacted as `[REDACTED_A56_ID]` per Issue #145
- **Screenshots Captured (11 Scenarios):**
  - `01_screen22_authorized_thread_top.png` (`.b64.txt`)
  - `02_screen22_thread_scrolled_long.png` (`.b64.txt`)
  - `03_screen22_composer_draft_active.png` (`.b64.txt`)
  - `04_screen22_message_sending_pending.png` (`.b64.txt`)
  - `05_screen22_submission_timeout_uncertain.png` (`.b64.txt`)
  - `06_screen22_message_delivery_failed.png` (`.b64.txt`)
  - `07_screen22_offline_state.png` (`.b64.txt`)
  - `08_screen22_unauthorized_guest_barrier.png` (`.b64.txt`)
  - `09_screen22_unavailable_thread.png` (`.b64.txt`)
  - `10_screen22_a11y_200_thread.png` (`.b64.txt`)
  - `11_screen22_a11y_200_composer.png` (`.b64.txt`)

---

## 7. Deferred Scope & Clean Stop

- **Production Code Isolation:** `mobile/apps/customer_app/lib/`, backend codebase, and database migrations remain 100% untouched.
- **Historical Evidence Preservation (Issue #155):** All previous evidence directories (`review-evidence/customer-screen21/` and Screens 12–20) remain strictly immutable.
- **Prelive Deferred Scope (Issue #190):** Live Supabase Realtime synchronization, WebSocket channels, push notifications, and server-side chat persistence are formally tracked under Issue #190.
- **Clean Stop:** Work stops cleanly here. Screen 23 (Dispute / Evidence) is strictly unauthorized pending formal Bridge review and Founder visual signoff.
