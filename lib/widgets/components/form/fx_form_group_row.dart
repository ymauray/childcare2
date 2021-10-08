import 'package:flutter/material.dart';

class FxFormGroupRow extends StatelessWidget {
  final String? leading;
  final Widget child;

  const FxFormGroupRow({
    Key? key,
    this.leading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          leading == null
              ? const SizedBox()
              : ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 96,
                  ),
                  child: Text(
                    leading!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
          SizedBox(width: leading == null ? 0 : 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
