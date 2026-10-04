# Forms and controls

Forms follow the visual component contracts and add experience rules:

- Ask only for information required for the current valid step.
- Explain a disabled action when the reason is not obvious.
- Keep decision-critical fields comfortable on mobile; use compact desktop controls only where density improves Admin work.
- Surface field validation adjacent to the field and preserve entered data when recoverable.
- Never use a control to suggest an unimplemented capability or an unavailable provider.
- For stateful actions, prevent accidental repeats during real submission and confirm canonical success only after the server confirms it.

## Role Lenses & Experience Semantics

Owner property creation, Customer booking and Admin review are separate forms with different density; shared control semantics do not force the same composition.

- **Customer Mobile Experience:**
  - *Tone & Psychology:* Hospitality, high trust, reassurance, low ambiguity.
  - *Interaction Ergonomics:* Lower cognitive load, spacious vertical breathing room, standalone outlined fields, clear error recovery without bureaucratic hurdles (e.g. zero terms-checkbox bureaucracy in booking requests).
- **Owner Mobile Experience:**
  - *Tone & Psychology:* Operational clarity, control, confidence.
  - *Interaction Ergonomics:* Higher useful operational density, rapid scanability, repeated-entry confidence, structured property wizards, compact steppers, and currency-suffixed numeric fields.
- **Admin Review Governance (Web Only):**
  - Admin remains strictly a Web application. Compact desktop controls are utilized where density improves Admin audit governance and review queues. DF2 and mobile primitives do not define or implement a mobile Admin system.
