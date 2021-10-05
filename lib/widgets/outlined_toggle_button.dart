import 'package:flutter/material.dart';

class OutlinedToggleButtonFormField extends FormField<bool> {
  final bool isSelected;

  OutlinedToggleButtonFormField({
    Key? key,
    String? restorationId,
    required Widget child,
    FormFieldSetter<bool>? onSaved,
    this.isSelected = false,
    EdgeInsets? padding = const EdgeInsets.fromLTRB(0, 20, 0, 20),
    VoidCallback? onChanged,
  }) : super(
          key: key,
          restorationId: restorationId,
          onSaved: onSaved,
          initialValue: isSelected,
          builder: (FormFieldState<bool> field) {
            final t = Theme.of(field.context);
            final _OutlinedButtonFormFieldState state = field as _OutlinedButtonFormFieldState;
            return OutlinedButton(
              onPressed: onChanged ?? () => state.didChange(!state.isSelected),
              child: Padding(
                padding: padding!,
                child: child,
              ),
              style: state.isSelected
                  ? OutlinedButton.styleFrom(
                      onSurface: t.colorScheme.onSurface,
                      primary: t.colorScheme.primary,
                      backgroundColor: t.colorScheme.primary.withOpacity(.12),
                      side: BorderSide(color: t.colorScheme.primary.withOpacity(.36)))
                  : OutlinedButton.styleFrom(
                      side: BorderSide(color: t.colorScheme.onSurface.withOpacity(.36)),
                    ),
            );
          },
        );

  @override
  FormFieldState<bool> createState() => _OutlinedButtonFormFieldState();
}

class _OutlinedButtonFormFieldState extends FormFieldState<bool> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  OutlinedToggleButtonFormField get widget => super.widget as OutlinedToggleButtonFormField;

  @override
  void didChange(bool? value) {
    super.didChange(value);
    setState(() {
      isSelected = value!;
    });
  }
}
