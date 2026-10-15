# Visual Bridge Quick-Review Guide — Customer Screen 17 V4 Pure-Black Refinement

**Audience:** Bridge / Founder Visual Reviewers  
**Status:** `SCREEN17_FINAL_REFINEMENT_PURE_BLACK_000000__AWAITING_BRIDGE_FOUNDER_REVIEW`  
**Device:** Samsung Galaxy A56 5G (Android 16 API 36, $1080 \times 2340\,\text{px}$)  
**Commit:** Head of `evidence/customer-screen17-design-review`

---

## Quick Screenshot Gallery

Click each image link below to inspect the full-resolution Samsung Galaxy A56 5G captures:

1. **[01_screen17_v4_a56_account_top_compact.png](./01_screen17_v4_a56_account_top_compact.png)** ([Base64](./01_screen17_v4_a56_account_top_compact.b64.txt))  
   *Default Top Fold:* Compact horizontal hero composition (avatar on physical right, name & handle center, edit button left). Black camera on white circle. Pure black `#000000` typography. Single calm editorial container.

2. **[02_screen17_v4_a56_account_scrolled.png](./02_screen17_v4_a56_account_scrolled.png)** ([Base64](./02_screen17_v4_a56_account_scrolled.b64.txt))  
   *Scrolled Fold:* Continuous editorial list showing financial and help groups. Physical left chevrons (`<`) on every item. Share KONFRM integrated row. Reachable red logout button.

3. **[03_screen17_v4_a56_wallet_modal_light.png](./03_screen17_v4_a56_wallet_modal_light.png)** ([Base64](./03_screen17_v4_a56_wallet_modal_light.b64.txt))  
   *Light Redesigned Wallet:* Completely removed charcoal slab and fake `0.00 ج.م` balance. White card with status badge «المحفظة قيد التجهيز», clear Issue #173 disclaimer, and pure black close button.

4. **[04_screen17_v4_a56_qr_modal_prototype.png](./04_screen17_v4_a56_qr_modal_prototype.png)** ([Base64](./04_screen17_v4_a56_qr_modal_prototype.b64.txt))  
   *Truthful QR Prototype:* Prominent disclaimer «معاينة تصميمية غير مفعلة — قيد الاعتماد الفني #172». Pure black header and actions.

5. **[05_screen17_v4_a56_guest_unauthenticated.png](./05_screen17_v4_a56_guest_unauthenticated.png)** ([Base64](./05_screen17_v4_a56_guest_unauthenticated.b64.txt))  
   *Guest Unauthenticated:* Minimalist canvas with user placeholder and pure black login/register button (`#000000`).

6. **[06_screen17_v4_a56_accessibility_200_top.png](./06_screen17_v4_a56_accessibility_200_top.png)** ([Base64](./06_screen17_v4_a56_accessibility_200_top.b64.txt))  
   *Accessibility 200% Top:* Graceful vertical adaptive hero, full 3-line stay title with zero truncation or ellipsis, zero overflow.

7. **[07_screen17_v4_a56_accessibility_200_scrolled.png](./07_screen17_v4_a56_accessibility_200_scrolled.png)** ([Base64](./07_screen17_v4_a56_accessibility_200_scrolled.b64.txt))  
   *Accessibility 200% Scrolled:* Reflowed single editorial card, wrapped labels, zero RenderFlex overflow.

---

## Visual Verification Checklist for Bridge

- [x] **Pure Black `#000000` Check:** Screen title «حسابي», primary CTA buttons, active icons, stay title, and modal headers use exact pure black (`#000000`). No charcoal or dark navy substitutions.
- [x] **Compact Hero Placement:** Avatar renders on the physical right in RTL Arabic, name & handle in center, edit button on physical left.
- [x] **Camera Badge:** Centered black camera icon on a white circular surface with subtle `#E5E7EB` border.
- [x] **Anti-Box Grammar:** Zero outer rectangular boxes enclosing the hero. Hero integrates seamlessly into canvas.
- [x] **Anti-Card-Soup:** Single editorial card with subtle dividers and `#F9FAFB` section banners replacing 3 separate cards.
- [x] **RTL Forward Arrows:** Chevrons point physically LEFT (`<`) across all navigation items.
- [x] **Linked Accounts Subtitle:** Phrased as «وسائل الدخول (Apple / Google)» with zero bidi text collision.
- [x] **Zero-Claim Light Wallet:** No dark container, no fake `0.00` balances, honest «المحفظة قيد التجهيز» status badge.
- [x] **Bottom Navigation:** Shared `CustomerBottomNavigation` with Account (الحساب) active, exactly coherent with Screens 15 and 16.
