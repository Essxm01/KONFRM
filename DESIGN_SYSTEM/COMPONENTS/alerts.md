# Alerts, Banners & Toast Contracts

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Maturity & Scoping Disclaimer:** This document governs cross-role feedback and recovery architecture. Individual token hexes, toast durations, alert corner radii, and platform accessibility mechanics preserve their distinct maturity (`SYSTEM_EVALUATED_PROVISIONAL`, `CURRENT_WEB_REFERENCE`, `OPEN`, `DEFERRED_TO_4I`).
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - 4-Tier State Delivery Hierarchy (`STATUS_BADGE` → `INLINE_TEXT` → `SECTION_ALERT` → `TOAST`, plus Phase 4F `DIALOG` for consequential confirmations).
  - Critical Error Rule: Critical errors, financial warnings, and blocking preconditions must **NEVER** rely solely on toasts.
  - Founder Invariant (`MR-17`): Yellow/amber/orange alert containers are prohibited across Customer, Owner, and Admin. Caution uses copy-first treatment on neutral/light surfaces.
  - Actionable Recovery: Section alerts must always include plain-language explanation and state-appropriate recovery.
- **Open Parameters:** Exact toast duration (`OPEN / PLATFORM_ACCESSIBILITY_GATED`), SectionAlert radius (`OPEN / COMPONENT-GOVERNED`), exact semantic alert color hexes (`OPEN / DEFERRED_TO_4I`).

---

## 2. Component Taxonomy & Subcontracts

| Subcontract | Tier | Role & Presentation | Constraints & Governance |
|---|---|---|---|
| `Toast` | Layer 4 | Transient confirmation of low-risk actions | Floating bottom pill; auto-dismiss; never used for errors or critical warnings. |
| `SectionAlert` | Layer 3 | Persistent feedback within a screen section | Neutral or soft-blue/rose surface; clear plain-language message + recovery CTA button. |
| `ScreenAlert` | Layer 3 | Full-screen blocking failure boundary | Centered container replacing page content; failure explanation + recovery button. |
| `InlineNotice` | Layer 2 | Contextual procedural guidance | Clean open typography on natural surface without box borders. |

---

## 3. Subcontract Details

### 3.1 Toast
- **Role:** Confirmation of low-risk, completed user actions (e.g. *"تم حفظ التعديلات"*, *"تم نسخ الرابط"*).
- **Positioning:** Bottom-centered floating pill (`fixed bottom-6 left-1/2 -translate-x-1/2`), above bottom navigation or safe area.
- **Duration:** `TOAST_DURATION: OPEN / PLATFORM_ACCESSIBILITY_GATED`.
  - Required semantic properties: transient, perceivable, readable, never carries critical information.
  - Exact duration curve and timing: `DEFERRED_TO_4I` (Web pilot reference ~3500ms is `CURRENT_WEB_REFERENCE_ONLY`).
- **Dismiss:** Auto-dismisses; optional swipe or tap to dismiss early.
- **Rule:** NEVER use for network failures, payment errors, or required user decisions.

### 3.2 SectionAlert
- **Role:** Scoped failure, partial sync failure, or actionable warning within a specific workflow area.
- **Geometry:** `SECTION_ALERT_RADIUS: OPEN / COMPONENT-GOVERNED`. (Web pilot CSS radius 8px/12px is `WEB_REFERENCE_ONLY`; not promoted to cross-platform Canon).
- **Anatomy:**
  - Leading semantic icon (info / danger).
  - Message text (plain Arabic explanation answering the 4 Critical State Questions).
  - Trailing or inline Action CTA (`STATE_APPROPRIATE_RECOVERY`).
- **Color Grammar:**
  - Stale / Process: Neutral light surface or soft-blue with slate text (`#F8FAFC` is `CURRENT_WEB_REFERENCE_ONLY`).
  - Caution: Copy-first on neutral surface; small amber icon permitted; **NO yellow background fill (MR-17)**.
  - Failure / Error: Soft rose/danger surface with red text and border (`#FEF2F2` is `CURRENT_WEB_REFERENCE_ONLY`).
  - Exact semantic color hexes: `OPEN / DEFERRED_TO_4I`.

### 3.3 ScreenAlert
- **Role:** Fatal view-level load failure (e.g. booking not found, network offline).
- **Presentation:** Centered illustration/icon, clear heading ("تعذر تحميل تفاصيل الحجز"), explanation of safe boundary, full-width or centered recovery button.

### 3.4 InlineNotice (Open Typography)
- **Role:** Layer 2 procedural guidance and educational notices.
- **Rule:** Delivered via clean typography directly on natural canvas surfaces. Avoids container framing to prevent "alert soup".

---

## 4. State Matrix

| State | Toast | SectionAlert | ScreenAlert |
|---|---|---|---|
| `IDLE / MOUNTED` | Visible for transient duration. | Persistent until condition resolved. | Persistent until recovery succeeds. |
| `ACTION_TRIGGERED` | Not applicable (no nested actions). | Enters `SUBMITTING` spinner on action. | Enters `SUBMITTING` spinner on recovery. |
| `RESOLVED` | Fades out / unmounts. | Dismissed / re-renders parent section. | Dismissed / renders loaded content. |

---

## 5. Role Differences

- **Customer:** Soft, friendly copy; errors explain next steps clearly without exposing internal database or HTTP codes.
- **Owner:** Dense, operational feedback; clear instructions for payout or listing resolution.
- **Admin:** Dense rectangular alerts; includes technical reference ID for system-level errors.

---

## 6. RTL & Bidirectional Layout Rules

- **Icon / Text Order:** Alert icon appears on the right (logical `start`); message text follows to the left.
- **Action Button:** Trailing action CTA placed at the left (logical `end`) in horizontal alerts.
- **Text Alignment:** All alert messages align to the right (`text-align: right`).

---

## 7. Accessibility Contract (Web vs Native Scoping)

### A. Platform-Agnostic Accessibility Intent
- Clear perception: Feedback is announced or highlighted in the accessibility tree without disorienting the user.
- Contrast requirement: Text inside all alerts must maintain >= 4.5:1 contrast ratio against the alert surface background.
- Recovery focus: Screen-level and section-level alerts provide direct keyboard/screen reader focus access to recovery CTAs.
- Toasts never trap focus: Transient toasts do not steal focus from active tasks.

### B. Current Web Mapping (`CURRENT_WEB_MAPPING`)
- Toasts use `role="status"` and `aria-live="polite"`.
- Error SectionAlerts use `role="alert"` and `aria-live="assertive"`.
- Informational alerts use `role="status"` and `aria-live="polite"`.

### C. Future Native Acceptance (`DEFERRED_TO_4I`)
- Flutter `SnackBar` / floating notification semantics and TalkBack/VoiceOver live announcements.
- Platform-appropriate contrast and Dynamic Type text wrapping.

---

## 8. Composition Invariants & Anti-Patterns

1. **Critical Failure Rule:** Critical errors and financial warnings must never use toasts alone.
2. **No Yellow Box Alert Rule (MR-17):** Never use yellow, amber, or orange container backgrounds for notices or alert cards.
3. **Actionable Requirement:** An error alert without an actionable recovery CTA or next step is prohibited.
4. **Anti-Soup Discipline:** Do not wrap every procedural text block in a bordered alert box; reserve SectionAlert for actionable recovery.
