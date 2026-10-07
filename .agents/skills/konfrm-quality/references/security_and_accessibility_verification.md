# `konfrm-quality` — Security & Accessibility Verification

```yaml
MODULE: security_and_accessibility_verification.md
GOVERNING_SPEC: docs/agents/KONFRM_SKILL_CONSOLIDATION_BLUEPRINT_V1.md
STATUS: CURRENT_APPROVED_METHOD
```

---

## 1. RISK-TRIGGERED OWASP MASVS V2.0 AUDIT

Security audits use **OWASP MASVS v2.0** as a selected engineering baseline. Rather than running exhaustive audits on every minor change, security checks are triggered by touched surfaces:

```
+------------------------------------+---------------------------------------------------------------+
| TOUCHED SURFACE                    | TRIGGERED MASVS CONTROLS                                      |
+------------------------------------+---------------------------------------------------------------+
| Authentication / Token Storage     | MASVS-STORAGE & MASVS-AUTH:                                    |
|                                    | - Verify credentials and secrets use secure-storage abstraction.|
|                                    | - Zero plaintext tokens in SharedPreferences / NSUserDefaults. |
|                                    | - Non-rotating refresh token semantics preserved as Canon.    |
|                                    | - Role isolation: Customer and Owner tokens never shared.     |
|                                    | - Other personal data: Handled per sensitivity, minimization,  |
|                                    |   and privacy architecture; no blanket overgeneralization.     |
+------------------------------------+---------------------------------------------------------------+
| Network Client / DTO Endpoints     | MASVS-NETWORK:                                                |
|                                    | - Verify HTTPS/TLS transport with modern cipher configuration.|
|                                    | - Verify cleartext traffic permitted = false.                 |
|                                    | - Verify badCertificateCallback returns false (no SSL bypass).|
+------------------------------------+---------------------------------------------------------------+
| Deep Links / Native Shell          | MASVS-PLATFORM:                                               |
|                                    | - Verify deep link URI parameters are validated in route guard|
|                                    | - Verify Android exported components are secured.             |
|                                    | - Verify photo selection uses system Photo Picker (no broad   |
|                                    |   storage permissions).                                       |
+------------------------------------+---------------------------------------------------------------+
```

### Invariant: Security Does Not Rewrite Business Canon
Security guidance may identify risk, but it must NEVER silently alter accepted product economics, user flows, or authentication Canon (such as non-rotating refresh token semantics). Material conflicts are escalated as `PRODUCT_REQUIREMENT × SECURITY_CONSTRAINT`.

---

## 2. ACCESSIBILITY VERIFICATION PROTOCOL

1. **Accessibility Tree Inspection:**
   - Execute widget tests that dump and inspect the accessibility tree for every interactive component:
     ```dart
     final handle = tester.ensureSemantics();
     // Assert labels, hints, and button traits
     handle.dispose();
     ```
2. **Phase 4I Distilled Verification Rules:**
   - **Absence of Selected-State Capability:** Assert that non-toggle ordinary action buttons (such as navigation icons, search clear buttons, back buttons) have selected-state capability completely ABSENT (`hasSelectedState = false`). They must NOT emit `isSelected == false` or declare `selected: false` (which causes Android TalkBack to announce "Not selected, Button", creating user confusion). Selection capability (`hasSelectedState: true, isSelected: true | false`) is reserved strictly for genuine stateful toggles (such as filter chips or checkboxes).
   - **No Duplicate Screen Reader Labels:** Assert that semantic label wrappers do not duplicate the child widget's inherent label. Redundant wrapping causes screen readers to read the same label twice in sequence.
   - **Touch Target Dimensions:** Assert that interactive bounds satisfy platform criteria (~48dp on Android, ~44pt on iOS).
3. **Multi-Platform Reality Gates:**
   - Android TalkBack and Samsung One UI accessibility engines must be tested on physical devices when physical gates are active.
   - **iOS is a Distinct Reality Gate:** Passing Android TalkBack verification is NOT proof of iOS VoiceOver compliance. Do not infer iOS accessibility acceptance from Android evidence.
