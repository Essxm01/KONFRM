import 'package:flutter/material.dart';

import '../../theme/konfrm_theme.dart';
import '../actions/icon_action_button.dart';

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
