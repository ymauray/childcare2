import 'package:childcare2/utils/i18n_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField({
    Key? key,
    this.label,
    this.initialDate,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.nullable = true,
  }) : super(key: key);

  final Widget? label;
  final DateTime? initialDate;
  final ValueChanged<DateTime?>? onChanged;
  final FormFieldSetter<DateTime?>? onSaved;
  final FormFieldValidator<DateTime?>? validator;
  final bool nullable;

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime? _value;

  @override
  initState() {
    _value = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: widget.label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.none,
      showCursor: false,
      enableInteractiveSelection: false,
      controller: TextEditingController(
        text: _value == null ? "" : DateFormat.yMMMMd(I18nUtils.locale).format(_value!),
      ),
      onSaved: (_) {
        if (widget.onSaved != null) widget.onSaved!(_value);
      },
      validator: (_) {
        if (widget.validator != null) widget.validator!(_value);
      },
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: widget.initialDate ?? DateTime.now(),
          firstDate: DateTime.now().add(
            const Duration(days: -20 * 366),
          ),
          lastDate: DateTime.now(),
        ).then((date) {
          if (widget.nullable || date != null) {
            setState(() {
              _value = date;
            });
            if (widget.onChanged != null) widget.onChanged!(_value);
          }
        });
      },
    );
  }
}
