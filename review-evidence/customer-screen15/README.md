# KONFRM Customer Screen 15 — Favorites (المفضلة) Visual Review Evidence

This directory contains the authoritative physical visual evidence, source code companions, and behavioral verification test results for **Customer Screen 15: Favorites (المفضلة)**.

## Executive Summary & Context

- **Governing Issues:**
  - [GitHub Issue #163](https://github.com/Essxm01/KONFRM/issues/163): Screen 14 Visual Design Frozen, deferred QA unblocking Screen 15.
  - [GitHub Issue #165](https://github.com/Essxm01/KONFRM/issues/165): Customer Screen 15 Canonical Contract & Scope.
  - [GitHub Issue #166](https://github.com/Essxm01/KONFRM/issues/166): Founder Design-First Priorities (Native UI/UX, Arabic RTL, Cairo typography).
  - [GitHub Issue #155](https://github.com/Essxm01/KONFRM/issues/155): Evidence Directory Immutability & Preservation.
- **Physical Test Device:** Samsung Galaxy A56 5G (`SM-A566B`), 1080x2340 physical resolution, Android 16 (API 36). Hardware serial redacted per Issue #145.
- **Scope Boundary:** 100% isolated native Flutter design runner (`screen15_preview_runner.dart`). Zero changes to production `customer_app/lib/`, backend APIs, database schemas, or financial processing.

---

## Screen 15 Canonical Role & Customer Journey Position

Screen 15 represents the customer's curated list of saved properties within the KONFRM native mobile application.
It resides as **Tab 1 (المفضلة)** in the persistent 4-destination Customer Bottom Navigation Bar:
1. `استكشف` (Explore - Index 0)
2. `المفضلة` (Favorites - Index 1, **ACTIVE**)
3. `حجوزاتي` (My Bookings - Index 2)
4. `الحساب` (Account - Index 3)

### Core Product Invariants Enforced

- **MR-FAV-01 (Saving Is Not Booking):** Explicit Arabic disclaimer presented in guest mode and guidance copy: *"حفظ الإقامات لا يمثل حجزاً ولا يضمن توفرها في المستقبل"*. Saving an accommodation is strictly an intent marker and does not lock dates or rates.
- **MR-FAV-02 (Authenticated Privacy & 401 Purge):** Favorites are tied to the authenticated customer identity. Upon HTTP 401 (Session Expired), private property listings are purged immediately from the view. No saved data leaks into the unauthorized screen.
- **MR-FAV-03 (Guest vs Empty State Distinction):** Unauthorized guest mode displays clear account login affordances and value propositions, whereas empty state for an authenticated user provides peaceful encouragement to explore properties.
- **MR-FAV-04 (Optimistic Removal & Floating Undo Toast):** Tapping the heart icon removes the accommodation immediately with an animated transition and presents a floating, accessible Undo Toast (*"تمت الإزالة من المفضلة"* + *"تراجع"* button) positioned above the bottom navigation bar.
- **MR-FAV-05 (Unavailable / Unlisted Accommodations):** Inactive or owner-unlisted accommodations display a neutral status badge (*"غير متوفرة حالياً"*), an explanation (*"أوقف المالك النشر مؤقتاً"*), and an easy remove affordance without broken UI states.

---

## 14 Comprehensive Scenarios Implemented

1. **`01_screen15_a56_ready_list_top.png`**: Ready state at top fold showing authentic property cards, Cairo bold typography, RTL alignment, and active Favorites tab.
2. **`02_screen15_a56_ready_list_scrolled.png`**: Scrolled view proving smooth vertical list physics, sticky header stability, and persistent bottom navigation bar.
3. **`03_screen15_a56_empty_no_favorites.png`**: Peaceful empty state with subtle outline heart icon, welcoming Arabic copy, and 56dp Solid True Black primary CTA (*"استكشف الإقامات"*).
4. **`04_screen15_a56_guest_unauthorized.png`**: Guest session displaying account benefits and disclaimer that saving is not booking, with dual CTAs (Login / Explore as Guest).
5. **`05_screen15_a56_session_expired_401.png`**: Session expiration state with burgundy security badge, private data purged, and single re-authentication CTA.
6. **`06_screen15_a56_initial_loading.png`**: High-polish shimmer skeleton placeholders avoiding screen jumps or flash.
7. **`07_screen15_a56_network_error_initial.png`**: Offline/network failure state with disconnected cloud icon and clear retry action.
8. **`08_screen15_a56_stale_data_refresh_error.png`**: Soft neutral banner informing the user that refresh failed while gracefully preserving already cached properties below.
9. **`09_screen15_a56_removed_undo_toast.png`**: Real-time floating undo notification banner positioned safely above the bottom navigation bar with a quick restoration button.
10. **`10_screen15_a56_unavailable_item.png`**: Scrolled card focus displaying neutral unavailable badge (*"غير متوفرة حالياً"*) and remove affordance.
11. **`11_screen15_a56_single_card_focus.png`**: Single card deep-dive evaluating image aspect ratio (1.4:1), circular 48dp heart action button, specs pills, and Arabic pricing layout.
12. **`12_screen15_a56_accessibility_200_top.png`**: Dynamic Text Scaling at 200% on physical hardware; zero RenderFlex overflows, titles and specs wrap gracefully.
13. **`13_screen15_a56_accessibility_200_scrolled.png`**: 200% text scale scrolled state confirming layout integrity across multi-line content.
14. **`14_screen15_a56_qa_audit_dev_overlay.png`**: Developer audit overlay allowing instant switching, scenario inspection, and state diagnostics.

---

## Design System & UX Standards Compliance

- **True Black Primary:** `#000000` solid color used for primary CTAs and active bottom navigation indicators (zero generic blue).
- **Typography:** Cairo font family applied across all widgets with distinct optical hierarchies (22px page title, 18px section title, 14px body, 11px specs).
- **Directional Isolation:** Currency and numbers rendered with strict RTL isolation (`DirectionalPriceText`) guaranteeing consistent Arabic placement (`4,500 ج.م / ليلة`).
- **Touch Target Compliance:** Heart icon hit target enclosed in a 48x48 dp minimum interactive box (`SizedBox(width: 48, height: 48)`).
- **Bottom Navigation Pinned:** Scoped to 62dp height with subtle `#E5E7EB` top border and 4 destinations in canonical Arabic RTL order.

---

## Source Artifacts & Testing

All runner and test source files are mirrored in `review-source/`:
- `review-source/screen15_preview_runner.dart`
- `review-source/screen15_source_linked_tests.dart`
- All 13 unit & widget tests pass (100% pass rate).
- Full cryptographic SHA-256 hashes for all PNGs and Base64 companions are documented in `VISUAL_BRIDGE_README.md`.
