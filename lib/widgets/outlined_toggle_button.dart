import 'package:flutter/material.dart';

class OutlinedToggleButton extends StatefulWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onPressed;

  const OutlinedToggleButton({
    Key? key,
    required this.child,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  _OutlinedToggleButtonState createState() => _OutlinedToggleButtonState();
}

class _OutlinedToggleButtonState extends State<OutlinedToggleButton> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return OutlinedButton(
      child: Padding(
        padding: const EdgeInsets.all(21),
        child: widget.child,
      ),
      onPressed: () {
        widget.onPressed();
      },
      style: widget.isSelected
          ? OutlinedButton.styleFrom(
              onSurface: t.colorScheme.onSurface,
              primary: t.colorScheme.primary,
              backgroundColor: t.colorScheme.primary.withOpacity(.12),
              side: BorderSide(color: t.colorScheme.primary.withOpacity(.36)))
          : OutlinedButton.styleFrom(
              side: BorderSide(color: t.colorScheme.onSurface.withOpacity(.36)),
            ),
    );
  }
}
