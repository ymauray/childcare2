import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final Widget? label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;

  final _hoursFocusNode = FocusNode();

  CustomDropdownButtonFormField({
    Key? key,
    this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      focusNode: _hoursFocusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(12, 17, 12, 18),
        border: const OutlineInputBorder(),
        label: label,
      ),
      items: items,
      value: value,
      onChanged: (value) {
        if (onChanged != null) onChanged!(value);
      },
      onSaved: onSaved,
      onTap: () {
        _hoursFocusNode.requestFocus();
      },
    );
  }
}
