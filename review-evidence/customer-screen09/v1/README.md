# KONFRM Customer Screen 09 (Native OTP Verification) — V1 Physical Evidence

**Task ID:** `CUSTOMER_SCREEN09_NATIVE_OTP_DESIGN_V1`  
**Governing Issue:** #128 (Focus Queue), #125 (Auth Contract), #140 (Auth V2 Visual Approval Track)  
**Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B`)  
**OS:** Android 16 (API 36) / One UI  
**Execution Mode:** Visual Design Candidate Verification (Zero production modifications; 100% isolated native Flutter prototype)  
**Capture Method:** Native `adb exec-out screencap -p` directly from live physical hardware frame buffer  
**Privacy Status:** Cleaned and verified. System status bar indicators only; zero personal notifications, zero SMS/social alerts, zero credentials, zero hardware serials.

---

## V1 Design Rationale & Native Craftsmanship Upgrades

Screen 09 (OTP Verification) is designed directly for the real Egyptian guest experience — someone who may have been interrupted while reserving accommodation, saving a favorite, or managing their account. The design prioritizes immediate clarity, psychological calm, and zero cognitive friction:

1. **Strict Continuity with Approved Screen 08 V2:**
   - **Monochrome Foundation:** Solid black `#000000` primary CTA button, pure white `#FFFFFF` background, subtle neutral `#E5E7EB` borders, and zero legacy prominent blue.
   - **Refined Cairo Typography:** 20sp w700 headline (`height: 1.35`) matched with 13.5sp subhead for clear hierarchy without visual aggression.
   - **Standardized 8px Radii:** Field cells and CTA buttons share an 8px radius per Issue #139/#140 direction.
   - **Western Digits:** All numeric counters and OTP digits use standard Western digits (`0–9`) as mandated across KONFRM native apps.

2. **Directionally Correct 6-Digit OTP Cells in Arabic RTL:**
   - Wrapped in an explicit LTR directionality context (`Directionality(textDirection: TextDirection.ltr)`) so the 6 individual 46×54dp cells progress strictly left-to-right (Cell 0 on the left, Cell 5 on the right) as expected for verification codes, while the entire screen shell remains native Arabic RTL.
   - **Geometric Dot Placeholders:** Inactive empty cells feature subtle, perfectly centered 6×6dp circular dot markers (`#D1D5DB`) rather than irregular font glyphs.
   - **Focused Cell Indication:** Active cell features a solid black border (`#000000`, 1.5px) and a crisp vertical blinking cursor.

3. **Masked Recipient Clarity & Edit Return:**
   - Recipient line formats phone numbers as `010 •••• ••78` (and emails as `sa•••@example.com`) with explicit LTR directional isolation.
   - Immediate subordinate change link (`تغيير رقم الهاتف` or `تغيير البريد الإلكتروني`) allows instant correction without back-stack confusion.

4. **Calm, Non-Punitive Error Architecture:**
   - Incorrect code highlights all 6 cells with a refined deep crimson border (`#E11D48`, 1.2px) and a faint warm background tint (`#FFFBFB`), accompanied by an inline warning icon and concise feedback (`رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.`) in `#BE123C`.
   - Expired code presents a clear expiration message and updates the primary CTA to `طلب رمز جديد` for instant recovery.

5. **Subordinate Resend Flow with Cooldown:**
   - While cooldown is active, displays unhurried neutral text (`إعادة إرسال الرمز بعد 42 ثانية`) preventing spam without anxiety.
   - Once cooldown elapses (0s), transitions cleanly to an interactive action (`إعادة إرسال الرمز`).

6. **Above-the-Fold Reachability:**
   - Total vertical form budget is tightly calibrated to ~370dp. When the physical Samsung numeric dialpad opens, **all primary controls** (header, cells, black CTA, and resend text) remain completely visible above the fold without forced scrolling.

---

## Evidence Manifest (9 Physical Hardware Scenarios)

| # | Filename | Scenario Description | Resolution | Raw Image URL | GitHub View |
|---|---|---|---|---|---|
| **01** | `01_screen09_a56_otp_initial_empty.png` | **Initial Empty State**. 6 geometric circular dot placeholders; masked Egyptian phone `010 •••• ••78`; disabled monochrome CTA button (`تأكيد الرمز`); active 55s resend cooldown. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/01_screen09_a56_otp_initial_empty.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/01_screen09_a56_otp_initial_empty.png) |
| **02** | `02_screen09_a56_otp_partial_entry.png` | **Partial Input Entry**. 3 digits entered LTR (`482`); active cursor in cell 3; remaining 3 cells display dot placeholders; CTA remains disabled; 45s resend cooldown. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/02_screen09_a56_otp_partial_entry.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/02_screen09_a56_otp_partial_entry.png) |
| **03** | `03_screen09_a56_otp_complete_ready.png` | **Complete Input Ready**. Full 6 digits entered LTR (`482915`); solid black CTA button enabled (`#000000`, 54dp min-height, 8px radius); Cairo typography. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/03_screen09_a56_otp_complete_ready.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/03_screen09_a56_otp_complete_ready.png) |
| **04** | `04_screen09_a56_otp_keyboard_open.png` | **Soft Keyboard Open (Above-the-Fold)**. Physical Samsung numeric dial pad open; active cursor in cell 4; all interactive elements (cells, black CTA, resend control) remain completely visible above the keyboard. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/04_screen09_a56_otp_keyboard_open.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/04_screen09_a56_otp_keyboard_open.png) |
| **05** | `05_screen09_a56_otp_incorrect_code.png` | **Incorrect Code Feedback (Calm Crimson)**. Invalid code `123456`; refined deep crimson `#E11D48` borders with faint warm `#FFFBFB` cell tint; inline warning icon and text `رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.` in `#BE123C`. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/05_screen09_a56_otp_incorrect_code.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/05_screen09_a56_otp_incorrect_code.png) |
| **06** | `06_screen09_a56_otp_resend_cooldown.png` | **Resend Cooldown Active**. Calm countdown text `إعادة إرسال الرمز بعد 42 ثانية`; secondary change number link `تغيير رقم الهاتف`; unboxed contextual booking notice. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/06_screen09_a56_otp_resend_cooldown.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/06_screen09_a56_otp_resend_cooldown.png) |
| **07** | `07_screen09_a56_otp_resend_ready.png` | **Resend Cooldown Elapsed (Action Ready)**. Cooldown counter reached 0s; active resend action `إعادة إرسال الرمز` presented clearly. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/07_screen09_a56_otp_resend_ready.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/07_screen09_a56_otp_resend_ready.png) |
| **08** | `08_screen09_a56_otp_expired_code.png` | **Expired Code State**. Clear expiration notice `انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد.`; primary CTA transitions to `طلب رمز جديد` for immediate recovery. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/08_screen09_a56_otp_expired_code.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/08_screen09_a56_otp_expired_code.png) |
| **09** | `09_screen09_a56_otp_email_variation.png` | **Email Verification Variation**. Headline `تأكيد البريد الإلكتروني`; masked recipient `sa•••@example.com`; code entered `591824`; secondary return link `تغيير البريد الإلكتروني`. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/09_screen09_a56_otp_email_variation.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen09-design-review/review-evidence/customer-screen09/v1/09_screen09_a56_otp_email_variation.png) |

---

## Technical & Design Compliance Checklist

- [x] **Monochrome visual palette:** Solid black `#000000` CTA, neutral `#E5E7EB` borders, `#111827` text, zero legacy blue accent.
- [x] **8px Radius Standard:** Cells and CTA adhere to 8px radius tokens.
- [x] **Directionality:** LTR 6-cell progression inside Arabic RTL shell; phone numbers and emails directionally isolated.
- [x] **Western Digits:** All numeric timers (`42 ثانية`) and code digits use Western digits (`0–9`).
- [x] **Zero Production Code Intrusion:** Executed via isolated tool prototype, leaving production code clean.
- [x] **Physical Samsung A56 Validation:** All 9 states captured directly on physical hardware (`SM-A566B`, Android 16).
- [x] **Lightweight Assets:** All 9 PNGs are between 76 KB and 112 KB (strictly <500 KB limit).
