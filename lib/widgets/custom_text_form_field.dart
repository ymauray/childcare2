import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry padding;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.icon, // = const SizedBox(width: 24),
    this.maxLines = 1,
    this.keyboardType,
    this.padding = EdgeInsets.zero, // = const EdgeInsets.fromLTRB(16, 16, 16, 0),
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          icon: widget.icon,
          labelText: widget.labelText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
