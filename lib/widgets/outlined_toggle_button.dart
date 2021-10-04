import 'package:flutter/material.dart';

class OutlinedToggleButtonFormField extends FormField<bool> {
  final VoidCallback? onPressed;

  OutlinedToggleButtonFormField({
    Key? key,
    String? restorationId,
    required Widget child,
    required this.onPressed,
    FormFieldSetter<bool>? onSaved,
    bool isSelected = false,
  }) : super(
          key: key,
          restorationId: restorationId,
          onSaved: onSaved,
          initialValue: isSelected,
          builder: (FormFieldState<bool> field) {
            final t = Theme.of(field.context);
            final _OutlinedButtonFormFieldState state = field as _OutlinedButtonFormFieldState;
            return OutlinedButton(
              onPressed: onPressed == null ? null : () => state.didChange(!isSelected),
              child: child,
              style: isSelected
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
  @override
  OutlinedToggleButtonFormField get widget => super.widget as OutlinedToggleButtonFormField;

  @override
  void didChange(bool? value) {
    super.didChange(value);
    if (widget.onPressed != null) widget.onPressed!();
  }
}

class OutlinedToggleButton extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onChanged;
  final EdgeInsets? padding;
  final FormFieldSetter<bool>? onSaved;

  const OutlinedToggleButton({
    Key? key,
    required this.child,
    required this.isSelected,
    this.onChanged,
    this.padding = const EdgeInsets.fromLTRB(0, 20, 0, 20),
    this.onSaved,
  })  : assert(padding != null),
        super(key: key);

  @override
  State<OutlinedToggleButton> createState() => _OutlinedToggleButtonState();
}

class _OutlinedToggleButtonState extends State<OutlinedToggleButton> {
  bool isSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedToggleButtonFormField(
      key: widget.key,
      child: Padding(
        padding: widget.padding!,
        child: widget.child,
      ),
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (widget.onChanged != null) widget.onChanged!();
      },
      onSaved: widget.onSaved,
      isSelected: isSelected,
    );
  }
}
