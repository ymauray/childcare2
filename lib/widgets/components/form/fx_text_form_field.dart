import 'package:flutter/material.dart';

class FxTextFormField extends StatelessWidget {
  final String? initialValue;

  const FxTextFormField({
    Key? key,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(
        text: initialValue,
      ),
    );
  }
}
