# KONFRM Customer Screen 10 (First-Time Account Completion) — V1 Physical Evidence

**Task ID:** `CUSTOMER_SCREEN10_NATIVE_PROFILE_SETUP_DESIGN_V1`  
**Governing Issue:** #128 (Current Focus Queue), #49 (Screen 10 Contract), #125 (Auth Contract), #140 (Auth V2 Visual Approval Track)  
**Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`)  
**OS:** Android 16 (API 36) / One UI  
**Execution Mode:** Visual Design Candidate Verification (Zero production modifications; 100% isolated native Flutter prototype)  
**Capture Method:** Native `adb exec-out screencap -p` directly from live physical hardware frame buffer  
**Privacy Status:** Cleaned and verified. System status bar indicators only; zero personal notifications, zero SMS/social alerts, zero credentials, zero hardware serials.

---

## V1 Design Rationale & Native Craftsmanship Upgrades

Screen 10 (First-Time Account Completion) is designed directly around a fundamental product reality: **the guest has already verified ownership of their phone number or email address, and their immediate goal is to complete this mandatory final step and return to what they were doing** (e.g., reserving accommodation, saving a favorite, or exploring).

The candidate avoids unnecessary complexity, questionnaires, profile photos, or decorative stepper noise, delivering a tranquil, reassuring, consumer-grade experience:

1. **Strict Continuity with Approved Screens 08 V2 and 09 V1:**
   - **Monochrome Foundation:** Solid black `#000000` primary CTA button (`إكمال إنشاء الحساب`), pure white `#FFFFFF` background, subtle neutral `#E5E7EB` borders, and zero legacy prominent blue.
   - **Refined Cairo Typography:** 20sp w700 headline (`height: 1.35`) paired with 13.5sp body subtitle (`#6B7280`).
   - **Provisional 8px Radii:** Full-name input field and primary CTA share an 8px radius per Issue #139/#140 direction.
   - **Auth Shell App Bar:** 52dp minimalist top app bar featuring the official centered monochrome `KonfrmBrandSymbol` and RTL-aware back navigation (`➔`).

2. **Native Mobile Design vs. Historical React Webpage:**
   - **Above-the-Fold Reachability:** The entire form vertical budget is compressed to ~350dp. When the native Samsung Arabic text keyboard opens, **all primary controls** (header, verified badge, input field, and solid black CTA button) remain comfortably visible and reachable above the fold without forced scrolling.
   - **Subtle Verified Badge:** Replaced the heavy full-width gray box with a delicate, right-aligned inline badge (`#F9FAFB` fill, 1px `#F3F4F6` border) with an emerald checkmark and directionally isolated masked recipient (`010 •••• ••78` or `sa•••@example.com`).
   - **Native Input Feel:** True native Android text input with autofill name hints (`AutofillHints.name`), natural text direction, and smooth cursor dynamics.

3. **Origin-Aware Reassurance:**
   - When entered from a protected booking context, an unboxed, calm reassurance notice appears beneath the CTA: `بعد إكمال الحساب، ستعود لمراجعة طلب الحجز.` (13sp `#6B7280`), reinforcing that completing the account will return the user to review their booking rather than blindly auto-submitting.

4. **Truthful Error & Recovery Semantics:**
   - **Inline Validation:** Empty or whitespace-only submission triggers the approved product copy `أدخل اسمك الكامل.` with a calm crimson `#E11D48` border, subtle `#FFFBFB` tint, and `#BE123C` text/icon.
   - **Recoverable Server Failure:** If a network or retryable server error occurs, the user stays on Screen 10, the entered full name is preserved, and feedback is presented calmly (`تعذر إنشاء الحساب حاليًا. حاول مرة أخرى.`) with the CTA enabled for instant retry.
   - **Reverification Required:** If the continuation token has expired or been consumed, the user is not trapped in a retry loop; the field is disabled, and the primary action safely transitions to `إعادة التحقق من رقم الهاتف` (or email).

5. **Submitting State Polish:**
   - During submission, the CTA remains solid black `#000000` with an 18×18dp white circular progress indicator and `جارٍ إنشاء الحساب…` in Cairo w700, while the input field transitions to a calm read-only state.

---

## Evidence Manifest (9 Physical Hardware Scenarios)

| # | Filename | Scenario Description | Resolution | Raw Image URL | GitHub View |
|---|---|---|---|---|---|
| **01** | `01_screen10_a56_initial_empty.png` | **Initial Phone-Verified State**. Empty full-name field; placeholder `أحمد محمد`; subtle right-aligned verified phone badge (`تم التحقق من رقم الهاتف · 010 •••• ••78`); disabled monochrome CTA (`إكمال إنشاء الحساب`). | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/01_screen10_a56_initial_empty.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/01_screen10_a56_initial_empty.png) |
| **02** | `02_screen10_a56_name_valid.png` | **Valid Full Name Active**. Valid name entered (`أحمد محمد`); solid black CTA button enabled (`#000000`, 54dp min-height, 8px radius); Cairo typography. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/02_screen10_a56_name_valid.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/02_screen10_a56_name_valid.png) |
| **03** | `03_screen10_a56_keyboard_open.png` | **Native Soft Keyboard Open (Above-the-Fold)**. Native Samsung Arabic text keyboard open; active cursor in name field; all interactive elements (title, verified badge, input, black CTA) comfortably visible above the keyboard without scrolling. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/03_screen10_a56_keyboard_open.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/03_screen10_a56_keyboard_open.png) |
| **04** | `04_screen10_a56_validation_error.png` | **Inline Validation Error (Calm Crimson)**. Empty/whitespace submit attempt; refined deep crimson `#E11D48` border around input with subtle `#FFFBFB` tint; inline warning icon and approved product copy `أدخل اسمك الكامل.` in `#BE123C`; CTA disabled. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/04_screen10_a56_validation_error.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/04_screen10_a56_validation_error.png) |
| **05** | `05_screen10_a56_submitting_state.png` | **Submitting State (Controlled Preview)**. Name entered (`أحمد محمد`); input field in calm read-only state; solid black CTA with white circular progress indicator and `جارٍ إنشاء الحساب…`. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/05_screen10_a56_submitting_state.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/05_screen10_a56_submitting_state.png) |
| **06** | `06_screen10_a56_booking_origin.png` | **Contextual Booking Origin Notice**. Auth triggered from active booking review; unboxed, neutral reassurance notice `بعد إكمال الحساب، ستعود لمراجعة طلب الحجز.` rendered cleanly beneath CTA without decorative cards. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/06_screen10_a56_booking_origin.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/06_screen10_a56_booking_origin.png) |
| **07** | `07_screen10_a56_recoverable_failure.png` | **Recoverable Server Failure (Name Preserved)**. Temporary failure; entered name `أحمد محمد` preserved in field; calm inline warning `تعذر إنشاء الحساب حاليًا. حاول مرة أخرى.`; CTA enabled for immediate retry. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/07_screen10_a56_recoverable_failure.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/07_screen10_a56_recoverable_failure.png) |
| **08** | `08_screen10_a56_reverify_required.png` | **Reverification Required (Expired/Consumed Token)**. Token expired/consumed; inline feedback `انتهت خطوة التحقق. تحقق من رقم الهاتف مرة أخرى لإكمال إنشاء الحساب.`; primary CTA safely transitions to `إعادة التحقق من رقم الهاتف`. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/08_screen10_a56_reverify_required.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/08_screen10_a56_reverify_required.png) |
| **09** | `09_screen10_a56_email_verified_variant.png` | **Email-Verified Presentation Variant**. Headline `أكمل إنشاء حسابك`; verified line `تم التحقق من البريد الإلكتروني · sa•••@example.com`; name entered `سارة الشناوي`; solid black CTA enabled. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/09_screen10_a56_email_verified_variant.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen10-design-review/review-evidence/customer-screen10/v1/09_screen10_a56_email_verified_variant.png) |

---

## Technical & Design Compliance Checklist

- [x] **Monochrome visual palette:** Solid black `#000000` CTA, neutral `#E5E7EB` borders, `#111827` text, zero legacy blue accent.
- [x] **8px Radius Standard:** Input field and CTA adhere to provisional 8px radius per #139/#140 direction.
- [x] **Directionality & Language:** Native Arabic RTL layout; masked identifiers and Western digits directionally isolated (`ltr`).
- [x] **Whitespace Normalization:** Input handles trimming and space-collapsing without disruptive formatting during editing.
- [x] **Zero Production Code Intrusion:** Executed via isolated tool preview harness, leaving production code clean.
- [x] **Physical Samsung A56 Validation:** All 9 states captured directly on physical hardware (`SM-A566B`, Android 16).
- [x] **Lightweight Assets:** All 9 PNGs are between 60 KB and 147 KB (strictly <500 KB limit).
