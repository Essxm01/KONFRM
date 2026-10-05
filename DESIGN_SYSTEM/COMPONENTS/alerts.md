# Alerts, Banners & Toast Contracts

## 1. Authority & Classification

- **Governance Level:** `GOVERNED_CANONICAL_SPECIFICATION`
- **Surface Reality:** React 19 / TypeScript Web baseline (`CONTROLLED_WEB_PILOT_REFERENCE`); native mobile architecture governed for Flutter target (`PHASE_4I_TARGET`).
- **Governed Structural Invariants:**
  - 4-Tier State Delivery Hierarchy (`STATUS_BADGE` → `INLINE_TEXT` → `SECTION_ALERT` → `TOAST`).
  - Critical Error Rule: Critical errors, financial warnings, and blocking preconditions must **NEVER** rely solely on toasts.
  - Founder Invariant (`MR-17`): Yellow/amber/orange alert containers are prohibited across Customer, Owner, and Admin. Caution uses copy-first treatment on neutral/light surfaces.
  - Actionable Recovery: Section alerts must always include plain-language explanation and an actionable retry/recovery CTA.
- **Open Parameters:** Exact toast duration (transient, accessible, deferred to Phase 4I native validation), exact semantic alert color hexes (`OPEN / DEFERRED_TO_4I`).

---

## 2. Component Taxonomy & Subcontracts

| Subcontract | Tier | Role & Presentation | Constraints & Governance |
|---|---|---|---|
| `Toast` | Layer 4 | Transient confirmation of low-risk actions | Floating bottom pill; auto-dismiss; never used for errors or critical warnings. |
| `SectionAlert` | Layer 3 | Persistent feedback within a screen section | Neutral or soft-blue/rose surface (8px radius); clear plain-language message + retry CTA button. |
| `ScreenAlert` | Layer 3 | Full-screen blocking failure boundary | Centered container replacing page content; failure explanation + retry button. |
| `InlineNotice` | Layer 2 | Contextual procedural guidance | Clean typography on natural surface without box borders. |

---

## 3. Subcontract Details

### 3.1 Toast
- **Role:** Confirmation of low-risk, completed user actions (e.g. *"تم حفظ التعديلات"*, *"تم نسخ الرابط"*).
- **Positioning:** Bottom-centered floating pill (`fixed bottom-6 left-1/2 -translate-x-1/2`), above bottom navigation or safe area.
- **Duration:** Transient, long enough to perceive and read (3000–4000ms candidate range; exact duration `OPEN / DEFERRED_TO_4I`).
- **Dismiss:** Auto-dismisses; optional swipe or tap to dismiss early.
- **Rule:** NEVER use for network failures, payment errors, or required user decisions.

### 3.2 SectionAlert
- **Role:** Scoped failure, partial sync failure, or actionable warning within a specific workflow area.
- **Geometry:** 8px border radius (`radius.input / radius.field` scale), 12px or 16px internal padding.
- **Anatomy:**
  - Leading semantic icon (info / danger).
  - Message text (plain Arabic explanation answering the 4 Critical State Questions).
  - Trailing or inline Action CTA (`[إعادة المحاولة]`, `[تحديث]`, or `[تصحيح البيانات]`).
- **Color Grammar:**
  - Stale / Process: Neutral light surface (`#F8FAFC`) or soft-blue with slate text.
  - Caution: Copy-first on neutral surface; small amber icon permitted; **NO yellow background fill (MR-17)**.
  - Failure / Error: Soft rose/danger surface (`#FEF2F2`) with red text and border.

### 3.3 ScreenAlert
- **Role:** Fatal view-level load failure (e.g. booking not found, network offline).
- **Presentation:** Centered illustration/icon, clear heading ("تعذر تحميل تفاصيل الحجز"), explanation of safe boundary, full-width or centered retry button.

---

## 4. State Matrix

| State | Toast | SectionAlert | ScreenAlert |
|---|---|---|---|
| `IDLE / MOUNTED` | Visible for fixed duration. | Persistent until condition resolved. | Persistent until retry succeeds. |
| `ACTION_TRIGGERED` | Not applicable (no nested buttons). | Enters `SUBMITTING` spinner on retry. | Enters `SUBMITTING` spinner on retry. |
| `RESOLVED` | Fades out / unmounts. | Dismantled / re-renders parent section. | Dismantled / renders loaded content. |

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

## 7. Accessibility & Focus Management

- **ARIA Roles:**
  - `Toast`: `role="status"`, `aria-live="polite"`.
  - `SectionAlert` (Error): `role="alert"`, `aria-live="assertive"`.
  - `SectionAlert` (Info): `role="status"`, `aria-live="polite"`.
- **Contrast:** Text inside all alerts must maintain >= 4.5:1 contrast ratio against the alert surface background.

---

## 8. Composition Invariants & Anti-Patterns

1. **Critical Failure Rule:** Critical errors and financial warnings must never use toasts alone.
2. **No Yellow Box Alert Rule (MR-17):** Never use yellow, amber, or orange container backgrounds for notices or alert cards.
3. **Actionable Requirement:** An error alert without an actionable retry CTA or next step is prohibited.
