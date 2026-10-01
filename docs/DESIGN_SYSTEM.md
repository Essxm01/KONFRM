# Design-system routing

The authoritative visual and product-experience system is [`../DESIGN_SYSTEM/`](../DESIGN_SYSTEM/), currently KONFRM Design System v2.1.6. Do not duplicate token tables or component contracts here.

Read the following before UI work:

- [`../DESIGN_SYSTEM/README.md`](../DESIGN_SYSTEM/README.md) — authority, approved foundations, and contribution flow
- [`../DESIGN_SYSTEM/GOVERNANCE.md`](../DESIGN_SYSTEM/GOVERNANCE.md) — Founder/Product approval boundary and versioning
- [`../DESIGN_SYSTEM/TOKENS/`](../DESIGN_SYSTEM/TOKENS/) — machine-readable canonical tokens; generated output is in `generated/`
- [`../DESIGN_SYSTEM/COMPONENTS/`](../DESIGN_SYSTEM/COMPONENTS/) — component/accessibility contracts
- [`../DESIGN_SYSTEM/EXPERIENCE/`](../DESIGN_SYSTEM/EXPERIENCE/) — role-specific UX, information hierarchy, state rules, and Founder decisions

Verified foundations: KONFRM / كونفرم, canonical brand assets in `DESIGN_SYSTEM/ASSETS/brand/` (`konfrm-symbol-black.svg`, `konfrm-wordmark-black.svg`), Cairo, Arabic-first RTL, white/light-first surfaces, monochrome-first mobile identity with yellow removed from core brand architecture, restrained blue interaction role (`#276EF1` implementation candidate, `#0059FF` historical Web baseline), Customer/Owner mobile-first, Admin desktop-operational, and platform-appropriate mobile touch sizing (no universal 44px canon). Existing implementation commonly uses Lucide; it is not a Founder-approved mandate for a project-wide icon migration. Dark navy/slate slabs, decorative gradients, and glassmorphism are not normal product surfaces.

Applications consume this authority; they do not create global design rules. Run `npm run design:generate` after canonical-token changes and `npm run design:check` for drift detection. Existing legacy drift is recorded, not approved, in `DESIGN_SYSTEM/LEGACY_DRIFT.md` and `LEGACY_EXCEPTIONS.json`.
