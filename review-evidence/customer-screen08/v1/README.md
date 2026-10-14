# KONFRM — Screen 08 (Phone Entry / Auth Gateway) Physical Device Design Candidate Evidence

**Repository:** `Essxm01/KONFRM`  
**Tracking Issues:** [#128](https://github.com/Essxm01/KONFRM/issues/128), [#125](https://github.com/Essxm01/KONFRM/issues/125), [#49](https://github.com/Essxm01/KONFRM/issues/49)  
**Evidence Branch:** `evidence/customer-screen08-design-review`  
**Base Commit:** `origin/main` (`f6911eeecfa100cbbfec935e15769e66966ce835`)  
**Hardware Device:** Samsung Galaxy A56 5G (`SM-A566B`)  
**Display Specification:** 1080 × 2340 px, 450 dpi, scale factor ~2.8125x (effective logical width: ~384 dp)  
**OS:** Android 16 (API 36) / One UI  
**Execution Mode:** Visual Design Candidate Verification (Zero production modifications; 100% isolated prototype)  
**Capture Method:** Native `adb shell screencap -p` directly from live physical hardware frame buffer  
**Privacy Status:** Cleaned and verified. System status bar indicators only; zero personal notifications, zero SMS/social alerts, zero credentials.

---

## Evidence Manifest

| # | Filename | Scenario Description | Resolution | Raw Image URL | GitHub View |
|---|---|---|---|---|---|
| **01** | `01_screen08_a56_phone_default.png` | **Phone Entry — Default State**. Unfocused, empty input with exact placeholder `1012345678`; isolated `+20` country code badge on the right; disabled monochrome CTA button (`إرسال رمز التحقق`); secondary email link. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/01_screen08_a56_phone_default.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/01_screen08_a56_phone_default.png) |
| **02** | `02_screen08_a56_phone_valid.png` | **Phone Entry — Valid Input Active**. Valid Egyptian phone number `1012345678` entered; solid black CTA button enabled (`#000000`, 6px button radius, 54dp height); Cairo typography. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/02_screen08_a56_phone_valid.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/02_screen08_a56_phone_valid.png) |
| **03** | `03_screen08_a56_email_alternative.png` | **Email Alternative Mode Active**. Tapped `تسجيل الدخول بالبريد الإلكتروني`; single email input (`sarah@example.com`); solid black CTA enabled; secondary return link `المتابعة برقم الهاتف`. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/03_screen08_a56_email_alternative.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/03_screen08_a56_email_alternative.png) |
| **04** | `04_screen08_a56_keyboard_open.png` | **Native Soft Keyboard Open**. Focused phone input with active cursor; physical Samsung numeric dial pad open; scrollable viewport prevents overflow; CTA remains fully visible. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/04_screen08_a56_keyboard_open.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/04_screen08_a56_keyboard_open.png) |
| **05** | `05_screen08_a56_booking_origin.png` | **Contextual Booking Origin Context**. Auth triggered from active booking review; calm, unboxed neutral notice `بعد التحقق، ستعود لمراجعة طلب الحجز.` rendered cleanly beneath CTA. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/05_screen08_a56_booking_origin.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/05_screen08_a56_booking_origin.png) |
| **06** | `06_screen08_a56_validation_error.png` | **Validation Error Feedback**. Malformed number `10123`; red border `#DC2626` around input container; red inline error text `أدخل رقم هاتف مصري صحيح (10 أو 11 رقمًا).`; CTA disabled. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/06_screen08_a56_validation_error.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/06_screen08_a56_validation_error.png) |
| **07** | `07_screen08_a56_accessibility_200.png` | **Accessibility 200% Text Scaling**. Text scaled to 2.0x; Cairo headline wraps gracefully onto two lines; inputs and CTA expand cleanly without clipping; zero overflow stripes. | 1080 × 2340 | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/07_screen08_a56_accessibility_200.png) | [View](https://github.com/Essxm01/KONFRM/blob/evidence/customer-screen08-design-review/review-evidence/customer-screen08/v1/07_screen08_a56_accessibility_200.png) |

---

## Key Visual & UX Characteristics Confirmed on Physical Device

1. **Strict Monochrome Discipline:** Strictly follows the Founder's directive for the Customer application — solid black `#000000` primary CTA button, pure white `#FFFFFF` surface background, neutral grey `#E5E7EB` / `#6B7280` secondary elements. Zero blue highlights, zero amber warning boxes.
2. **Arabic-First RTL Layout:** Full RTL hierarchy, right-aligned labels and headings, canonical RTL back arrow (`->` pointing back out of screen), centered geometric `K` symbol (`KonfrmBrandSymbol`, size 28). Bottom navigation bar is strictly hidden.
3. **Isolated Country Code Badge:** Fixed `+20` prefix badge housed in a visually distinct container on the natural entry side (right in RTL), with explicit `TextDirection.ltr` isolation so it never renders as `20+`.
4. **Exact Placeholder:** The phone input placeholder strictly renders `1012345678` in ASCII Western numerals (`0-9`). No dual hints, no cluttered instructions inside the field.
5. **Unified Passwordless Headline:** Single headline `تسجيل الدخول أو إنشاء حساب` with subtext `أدخل رقم هاتفك للمتابعة.` — avoiding premature login/signup tab bifurcation.
6. **Harmonized Design System Radii:** Exact adherence to `KonfrmRadii.button` (6px) for the 54dp CTA button and `KonfrmRadii.input` (8px) for form fields.
7. **Accessibility & Responsive Durability:** Completely stable at 200% font scaling and when the native Samsung keyboard opens, with smooth scrolling and zero layout overflows.
