import 'package:flutter/material.dart';

class FxRow extends StatelessWidget {
  final Widget child;
  final Widget? icon;

  const FxRow({
    Key? key,
    required this.child,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Center(
              child: icon != null ? const Icon(Icons.child_care) : Container(),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
