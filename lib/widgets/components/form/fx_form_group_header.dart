import 'package:flutter/material.dart';

class FxFormGroupHeader extends StatelessWidget {
  final String header;

  const FxFormGroupHeader({
    Key? key,
    required this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Text(header.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          )),
    );
  }
}
