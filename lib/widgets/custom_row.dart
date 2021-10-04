import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final Widget? icon;
  final Widget? child;

  const CustomRow({
    Key? key,
    this.icon = const SizedBox(width: 24),
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (icon != null) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: icon!,
      ));
    }
    if (child != null) {
      children.add(Expanded(child: child!));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: children,
      ),
    );
  }
}
