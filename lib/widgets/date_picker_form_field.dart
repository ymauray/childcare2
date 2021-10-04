import 'package:childcare2/utils/i18n_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final Widget? label;
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onChange;

  const DatePickerFormField({
    Key? key,
    this.label,
    this.initialDate,
    required this.onChange,
  }) : super(key: key);

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
        icon: const SizedBox(width: 24),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.none,
      showCursor: false,
      enableInteractiveSelection: false,
      controller: TextEditingController(
        text: _value == null ? "" : DateFormat.yMMMMd(I18nUtils.locale).format(_value!),
      ),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: widget.initialDate ?? DateTime.now(),
          firstDate: DateTime.now().add(
            const Duration(days: -20 * 366),
          ),
          lastDate: DateTime.now(),
        ).then((date) {
          setState(() {
            _value = date;
            widget.onChange(_value);
          });
        });
      },
    );
  }
}
