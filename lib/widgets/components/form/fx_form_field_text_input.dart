import 'package:flutter/material.dart';

class FxFormFieldTextInput extends StatelessWidget {
  final String initialValue;
  final bool readOnly;
  final GestureTapCallback? onTap;

  const FxFormFieldTextInput({
    Key? key,
    required this.initialValue,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: TextEditingController(
        text: initialValue,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
