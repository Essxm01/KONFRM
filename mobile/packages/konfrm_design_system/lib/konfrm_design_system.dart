/// KONFRM Design System — Mobile Foundation & Component Contracts
///
/// This package hosts the native Flutter primitives and component contracts
/// developed in Phase 4I under the governed Design System authority (DF2 v1.7).
///
/// Codex ownership areas:
/// - Theme & Cairo typography
/// - Buttons & IconButtons
/// - Form & Input primitives
/// - Status badges & State views
/// - Section alerts & Structural containers
/// - RTL / Bidi & Semantics contracts
library;

export 'src/constants.dart';
export 'src/theme/konfrm_theme.dart'
    show KonfrmTypography, KonfrmColors, konfrmLightTheme;
export 'src/utils/bidi.dart';
export 'src/components/actions/action_phase.dart';
export 'src/components/actions/primary_button.dart';
export 'src/components/actions/secondary_button.dart';
export 'src/components/actions/icon_action_button.dart';
export 'src/components/inputs/input_field.dart';
export 'src/components/status/status_badge.dart';
export 'src/components/states/state_view.dart';
export 'src/components/feedback/section_alert.dart';
export 'src/components/structure/structural_container.dart';
export 'src/components/navigation/customer_bottom_navigation.dart';
export 'src/components/navigation/sticky_action_surface.dart';
