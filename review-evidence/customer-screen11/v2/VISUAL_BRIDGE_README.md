# KONFRM Customer Screen 11 V2 — Visual Bridge Evidence Manifest

**Task ID:** `SCREEN11_VISUAL_CORRECTION_V2`  
**State Target:** `SCREEN11_V2_AWAITING_FOUNDER_VISUAL_REVIEW`  
**Target Hardware:** Samsung Galaxy A56 5G (`SM-A566B` / Android 16 API 36)  
**Display Framebuffer:** 1080 × 2340 px @ 450 dpi  
**Evidence Branch:** `evidence/customer-screen11-design-review`  
**Companion Format:** ASCII single-line Base64-encoded JPEG (Quality 80) derived directly from live framebuffer captures.

---

## 1. Visual Companion Mapping & Integrity Manifest

The independent Bridge can directly fetch and decode each `.b64.txt` companion file into image pixels without requiring manual image uploads.

| # | Scenario Description | PNG Filename | PNG Size | PNG SHA-256 | Base64 Companion File | B64 Size | B64 SHA-256 | Resolution | Raw Companion Link |
|---|---|---|---|---|---|---|---|---|---|
| **01** | **Main Success (First Fold Full CTA)** | `01_screen11_a56_main_success.png` | 157,497 B | `1c2d6fb2824650286c4a60f7018321e52d397a7eb11f3722dace9ccd315a41c1` | `01_visual_bridge.jpg.b64.txt` | 214,076 B | `318fed787ce6d9816dfa6ef6697cfc2951f6b26497077ed343c2aceca557464c` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/01_visual_bridge.jpg.b64.txt) |
| **02** | **Bottom Actions & Scrolled Safe Area** | `02_screen11_a56_bottom_actions.png` | 153,228 B | `8719d6f3963a7b4dd3415bc0b54535d352ac5a58b9fff9c55a5d0badd7528ef8` | `02_visual_bridge.jpg.b64.txt` | 209,984 B | `80efafd8fde3e440595627905c7218b2446d0bb145300dbca67d31c7a39af5ec` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/02_visual_bridge.jpg.b64.txt) |
| **03** | **Long Title & Left-Pointing Chronology Arrow** | `03_screen11_a56_long_title.png` | 176,407 B | `43d615c0b1f305355256b1f5cf862d17ff0205ed392d2d6f9eb4257136ed752f` | `03_visual_bridge.jpg.b64.txt` | 237,468 B | `d3cf00106d9082bd1da3b8b541685ffeeea91321a047740bc8ac1c910d877c76` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/03_visual_bridge.jpg.b64.txt) |
| **04** | **Compact Viewport (360dp Width)** | `04_screen11_a56_compact_viewport.png` | 157,809 B | `612645a3f02bbb982b46d6a796e950c1e34fef068a2b791e8dbe9b8d7282a5dd` | `04_visual_bridge.jpg.b64.txt` | 213,128 B | `ab0c93f032de3b56e1280ea2809b65be04d0237d3589a7c63478fd5319a39d19` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/04_visual_bridge.jpg.b64.txt) |
| **05** | **Accessibility Text Scaling (200%)** | `05_screen11_a56_a11y_200.png` | 158,051 B | `35eb1077f476961cbdcd435bbd01803b892d72476a5c9202752e0d1812ba16ed` | `05_visual_bridge.jpg.b64.txt` | 237,704 B | `254c30162f49f13b07dbd5665b1c07556386bf9b6516347dda607b1bf9bcb5af` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/05_visual_bridge.jpg.b64.txt) |
| **06** | **Safe Minimal Data Fallback State** | `06_screen11_a56_safe_state_minimal.png` | 127,169 B | `32f3912e06d77e2e613dbcf43e7c50c0968950688510e91b53f75e87d0a2cba4` | `06_visual_bridge.jpg.b64.txt` | 184,988 B | `86cff6b7bd81a4cc32eeac1cbcb7cbddbc4ad230cd0c1ce6150600ba5cdc8b69` | 1080 × 2340 | [Raw B64 Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/06_visual_bridge.jpg.b64.txt) |

---

## 2. Bridge Retrieval Instructions

To inspect these physical screenshots, Bridge can fetch any raw `.b64.txt` file above:
```bash
curl -sL https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v2/01_visual_bridge.jpg.b64.txt
```
Decode the Base64 stream into a JPEG file, inspect the image, and verify the three narrow visual corrections.
