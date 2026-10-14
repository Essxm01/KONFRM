# Screen 11 — Visual Bridge Inspection Manifest (V1)
## Portable UTF-8 Base64 Companions for Independent LLM/Bridge Visual Review

**Task ID:** `CUSTOMER_SCREEN11_NATIVE_DESIGN_V1` / `SCREEN11_EVIDENCE_BRIDGE_V1`  
**Application:** KONFRM Guest Application (`customer_app`)  
**Hardware Source:** Samsung Galaxy A56 5G (`SM-A566B`, Android 16 / One UI, 1080 × 2340 @ 450 dpi)  
**Evidence Branch:** `evidence/customer-screen11-design-review`  
**Directory:** `review-evidence/customer-screen11/v1/`

---

## 1. Purpose & Access Notice

This manifest and its companion `.jpg.b64.txt` files provide a text-safe visual inspection bridge for independent automated systems, LLMs, and ChatGPT Bridge that consume GitHub repositories via text-only/UTF-8 endpoints.

- **Authoritative Evidence:** The six original `.png` files remain the sole physical hardware test evidence.
- **Visual Access Companions:** The six `.jpg.b64.txt` files are derived directly from the canonical PNG files (Quality ~80 JPEG, 1080 × 2340, full aspect ratio) and encoded as plain ASCII Base64 text streams without markdown wrapping or data URI headers.
- **Decoding Instructions for LLM/Bridge:** Read the plain text from the respective `.b64.txt` URL, decode using standard Base64 (`base64.b64decode`), and render or inspect as a standard JPEG image.

---

## 2. Visual Bridge Artifact Mapping Table

| # | Scenario Title | Authoritative Source PNG | PNG Bytes / SHA-256 | Derived Base64 Companion | JPEG Bytes / B64 Chars | Decoded SHA-256 (JPEG) | Raw Companion URL |
|---|---|---|---|---|---|---|---|
| **01** | **Main Success Fold** (First Fold Baseline) | `01_screen11_a56_main_success.png` | 158,557 B<br>`b41bf198fc3b48e1100d7b0de4335fcf71b22960f3e4c814792ec96548ba5407` | `01_visual_bridge.jpg.b64.txt` | 159,585 B<br>212,780 chars | `a5fb7aa59c65c09ff74f9856d90e4da5e47b0c2e095a31c2354a61b76d8d9760` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/01_visual_bridge.jpg.b64.txt) |
| **02** | **Bottom Actions Fold** (Actions & Full Summary) | `02_screen11_a56_bottom_actions.png` | 156,409 B<br>`b6a7e27e06b11a582cab9575ab18dbf3920aa61198c12043e13868c57fe24b17` | `02_visual_bridge.jpg.b64.txt` | 158,263 B<br>211,020 chars | `5ca35c60813f2e2a1080bb061c22620526a6dca4bf2ac106db38cf31024e4ac9` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/02_visual_bridge.jpg.b64.txt) |
| **03** | **Long Title Stress Test** (3-Line Title & Complex Code) | `03_screen11_a56_long_title.png` | 176,721 B<br>`c1b74260a288807ec6fa5a6e624dac4596c19ed59dce8ee9f40463fa7d04a7d8` | `03_visual_bridge.jpg.b64.txt` | 174,731 B<br>232,976 chars | `2e6a74aba7a93c256d208a96f13d421753d7be8ba53a6cb3822e4454ae9ea71b` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/03_visual_bridge.jpg.b64.txt) |
| **04** | **Compact Viewport (360dp)** (Narrow Form-Factor) | `04_screen11_a56_compact_viewport.png` | 159,406 B<br>`7b3a3fc251c4de1fe53bf09eee8dfa3b01dfaa7a2f441265816374381a4f4ed1` | `04_visual_bridge.jpg.b64.txt` | 160,233 B<br>213,644 chars | `8f101188438515a4cef5468411c4949da85af830e6008519d2418575e689f36b` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/04_visual_bridge.jpg.b64.txt) |
| **05** | **200% Accessibility (a11y)** (Text Scaling Stress Test) | `05_screen11_a56_a11y_200.png` | 141,459 B<br>`8f369a40f16745eb1c38422907d53886ca9492ebeeaa778a85ce7410ebed8d52` | `05_visual_bridge.jpg.b64.txt` | 159,275 B<br>212,368 chars | `6595ab83d1ff8088411c6f014dc84c552abbc2b3d98ebe10ddb562fe4a8216be` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/05_visual_bridge.jpg.b64.txt) |
| **06** | **Minimal Data Fallback** (Safe State & Arabic Duals) | `06_screen11_a56_safe_state_minimal.png` | 140,391 B<br>`c4083dff33d9f4c42164848295573b83c23dfcd58239b0a23753a84d34687334` | `06_visual_bridge.jpg.b64.txt` | 147,708 B<br>196,944 chars | `a80cf332bf4fc6d2715c8b30ac10eda8fe0821d62576c48ec81dcc6b606e2e2c` | [Raw Link](https://raw.githubusercontent.com/Essxm01/KONFRM/evidence/customer-screen11-design-review/review-evidence/customer-screen11/v1/06_visual_bridge.jpg.b64.txt) |

---

## 3. Derivation Method & Technical Guarantees

1. **Pixel Integrity:** Each `.jpg.b64.txt` file was converted directly from its corresponding committed `.png` file at native 1080 × 2340 resolution with standard Quality 80 JPEG compression. No UI elements were modified, mocked, retouched, or redrawn.
2. **Text-Stream Format:** Strictly single-line Base64 ASCII text without line breaks, markdown code fences, or `data:image/jpeg;base64,` prefixes, ensuring immediate compatibility with GitHub raw HTTP endpoints and automated programmatic decoders.
3. **Payload Verification:** All 6 Base64 text files were verified by re-reading the text, decoding the byte stream, and validating that the resulting image dimensions strictly equal 1080 × 2340 pixels with valid JPEG headers.
4. **Size Budget:** All 6 companions are between 196 KB and 233 KB (well within GitHub's 1 MB API response threshold).
