import 'package:flutter/material.dart';

import '../theme/konfrm_theme.dart';

/// iOS uses 44 logical units only as an IOS_LAYOUT_PREVIEW_ONLY structure.
/// Android's implementation target is 48dp; other test hosts use that preview.
double _touchTargetExtent(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS ? 44 : 48;

/// Shared action status. Busy is not a success state and blocks re-activation.
enum ActionPhase { idle, submitting }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.phase = ActionPhase.idle,
  });
  final String label;
  final VoidCallback? onPressed;
  final ActionPhase phase;

  @override
  Widget build(BuildContext context) {
    final busy = phase == ActionPhase.submitting;
    return Semantics(
      button: true,
      label: label,
      enabled: !busy && onPressed != null,
      value: busy ? 'جارٍ التنفيذ' : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _touchTargetExtent(context)),
        child: Opacity(
          opacity: onPressed == null && !busy
              ? ValidationReferenceOnly.disabledOpacity
              : 1,
          child: Material(
            color: KonfrmColors.primary,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: busy ? null : onPressed,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Center(
                  child: busy
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            value: MediaQuery.disableAnimationsOf(context)
                                ? 0.5
                                : null,
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: KonfrmTypography.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary radius and palette are explicitly validation references.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    enabled: onPressed != null,
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: _touchTargetExtent(context)),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: ValidationReferenceOnly.secondaryFill,
          foregroundColor: ValidationReferenceOnly.text,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ValidationReferenceOnly.secondaryRadius,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: KonfrmTypography.button,
        ),
      ),
    ),
  );
}

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.selected = false,
    this.directional = false,
  });
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool selected;
  final bool directional;

  @override
  Widget build(BuildContext context) {
    assert(semanticLabel.trim().isNotEmpty);
    final targetExtent = _touchTargetExtent(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final actualIcon = directional && rtl && icon == Icons.arrow_back
        ? Icons.arrow_forward
        : icon;
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onPressed != null,
      selected: selected,
      child: Tooltip(
        message: semanticLabel,
        child: SizedBox(
          key: const Key('konfrm-icon-action-target'),
          width: targetExtent,
          height: targetExtent,
          child: Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(
                  actualIcon,
                  color: selected
                      ? ValidationReferenceOnly.interaction
                      : ValidationReferenceOnly.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.label,
    this.controller,
    this.helper,
    this.error,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textDirection,
    this.onChanged,
  });
  final String label;
  final TextEditingController? controller;
  final String? helper;
  final String? error;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ExcludeSemantics(child: Text(label, style: KonfrmTypography.label)),
      const SizedBox(height: 6),
      Semantics(
        container: true,
        label: label,
        hint: error ?? helper,
        textField: true,
        child: TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textDirection: textDirection,
          onChanged: onChanged,
          style: KonfrmTypography.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: ValidationReferenceOnly.surface,
            helperText: error == null ? helper : null,
            errorText: error,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ValidationReferenceOnly.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ValidationReferenceOnly.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ValidationReferenceOnly.interaction,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ValidationReferenceOnly.danger,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.label,
    this.controller,
    this.error,
  });
  final String label;
  final TextEditingController? controller;
  final String? error;
  @override
  Widget build(BuildContext context) => InputField(
    label: label,
    controller: controller,
    error: error,
    keyboardType: TextInputType.phone,
    textDirection: TextDirection.ltr,
  );
}

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.loading = false,
    this.onChanged,
    this.onClear,
  });
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final bool loading;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  bool _ownsController = false;
  @override
  void initState() {
    super.initState();
    _setController();
  }

  void _setController() {
    _controller = widget.controller ?? TextEditingController();
    _ownsController = widget.controller == null;
    _controller.addListener(_sync);
  }

  void _sync() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_sync);
      if (_ownsController) _controller.dispose();
      _setController();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_sync);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ExcludeSemantics(
        child: Text(widget.label, style: KonfrmTypography.label),
      ),
      const SizedBox(height: 6),
      Semantics(
        container: true,
        label: widget.label,
        textField: true,
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          textDirection: TextDirection.rtl,
          style: KonfrmTypography.body,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixIcon: Semantics(
              label: 'بحث',
              child: const Icon(Icons.search),
            ),
            suffixIcon: widget.loading
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: MediaQuery.disableAnimationsOf(context)
                        ? const Icon(Icons.more_horiz)
                        : const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                  )
                : _controller.text.isEmpty
                ? null
                : IconActionButton(
                    icon: Icons.close,
                    semanticLabel: 'مسح البحث',
                    onPressed: () {
                      _controller.clear();
                      widget.onClear?.call();
                      widget.onChanged?.call('');
                    },
                  ),
            filled: true,
            fillColor: ValidationReferenceOnly.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    ],
  );
}

enum StatusFamily {
  property,
  propertyReview,
  booking,
  payment,
  walletBucket,
  payout,
  ownerIdentity,
  verificationDocument,
}

enum StatusTone { neutral, info, success, warning, danger }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.family,
    this.tone = StatusTone.neutral,
  });
  final String label;
  final StatusFamily family;
  final StatusTone tone;
  Color get _color => switch (tone) {
    StatusTone.neutral => ValidationReferenceOnly.pending,
    StatusTone.info => ValidationReferenceOnly.info,
    StatusTone.success => ValidationReferenceOnly.success,
    StatusTone.warning => ValidationReferenceOnly.warning,
    StatusTone.danger => ValidationReferenceOnly.danger,
  };
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            switch (tone) {
              StatusTone.success => Icons.check_circle_outline,
              StatusTone.warning => Icons.info_outline,
              StatusTone.danger => Icons.error_outline,
              StatusTone.info => Icons.info_outline,
              StatusTone.neutral => Icons.more_horiz,
            },
            size: 14,
            color: _color,
          ),
          const SizedBox(width: 4),
          Text(label, style: KonfrmTypography.label.copyWith(color: _color)),
        ],
      ),
    ),
  );
}

enum StateKind {
  loading,
  empty,
  error,
  offline,
  unauthorized,
  partial,
  stale,
  conflict,
}

class StateView extends StatelessWidget {
  const StateView({
    super.key,
    required this.kind,
    required this.heading,
    required this.explanation,
    this.recoveryLabel,
    this.onRecovery,
  });
  final StateKind kind;
  final String heading;
  final String explanation;
  final String? recoveryLabel;
  final VoidCallback? onRecovery;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: kind == StateKind.loading,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (kind == StateKind.loading &&
            !MediaQuery.disableAnimationsOf(context))
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8),
            child: LinearProgressIndicator(),
          ),
        if (kind == StateKind.loading &&
            MediaQuery.disableAnimationsOf(context))
          const Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8),
            child: Icon(Icons.more_horiz),
          ),
        Text(heading, style: KonfrmTypography.sectionTitle),
        const SizedBox(height: 4),
        Text(explanation, style: KonfrmTypography.body),
        if (recoveryLabel != null && onRecovery != null) ...[
          const SizedBox(height: 12),
          SecondaryButton(label: recoveryLabel!, onPressed: onRecovery),
        ],
      ],
    ),
  );
}

class SectionAlert extends StatelessWidget {
  const SectionAlert({
    super.key,
    required this.message,
    this.recoveryLabel,
    this.onRecovery,
    this.isError = false,
  });
  final String message;
  final String? recoveryLabel;
  final VoidCallback? onRecovery;
  final bool isError;
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: isError,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(
            width: 3,
            color: isError
                ? ValidationReferenceOnly.danger
                : ValidationReferenceOnly.info,
          ),
        ),
        color: ValidationReferenceOnly.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: KonfrmTypography.body),
          if (recoveryLabel != null && onRecovery != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: onRecovery,
                child: Text(recoveryLabel!),
              ),
            ),
        ],
      ),
    ),
  );
}

class StructuralContainer extends StatelessWidget {
  const StructuralContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: ValidationReferenceOnly.surface,
      border: Border.all(color: ValidationReferenceOnly.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

const customerDestinations = <String>['استكشف', 'المفضلة', 'حجوزاتي', 'الحساب'];

class CustomerBottomNavigation extends StatelessWidget {
  const CustomerBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  static const _icons = [
    Icons.explore_outlined,
    Icons.favorite_border,
    Icons.bookmark_border,
    Icons.person_outline,
  ];
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      destinations: List.generate(
        customerDestinations.length,
        (index) => NavigationDestination(
          icon: Icon(_icons[index]),
          selectedIcon: Icon(_icons[index]),
          label: customerDestinations[index],
          tooltip: customerDestinations[index],
        ),
      ),
    ),
  );
}

class StickyActionSurface extends StatelessWidget {
  const StickyActionSurface({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: ValidationReferenceOnly.surface,
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: child,
    ),
  );
}

class OwnerActionScenario extends StatelessWidget {
  const OwnerActionScenario({super.key});
  @override
  Widget build(BuildContext context) => const StructuralContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ما الذي يحتاج مني تصرفًا الآن؟',
          style: KonfrmTypography.sectionTitle,
        ),
        Divider(height: 24),
        Row(
          children: [
            Expanded(
              child: Text('طلب يحتاج إلى مراجعة', style: KonfrmTypography.body),
            ),
            StatusBadge(label: 'قيد المراجعة', family: StatusFamily.booking),
          ],
        ),
        Divider(height: 24),
        Row(
          children: [
            Expanded(
              child: Text('إكمال بيانات الوحدة', style: KonfrmTypography.body),
            ),
            StatusBadge(label: 'مسودة', family: StatusFamily.property),
          ],
        ),
      ],
    ),
  );
}
