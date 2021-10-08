import 'package:childcare2/utils/i18n_utils.dart';
import 'package:childcare2/widgets/components/form/fx_form_field_text_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FxFormFieldDatePicker extends StatefulWidget {
  final DateTime? date;

  const FxFormFieldDatePicker({
    Key? key,
    this.date,
  }) : super(key: key);

  @override
  _FxFormFieldDatePickerState createState() => _FxFormFieldDatePickerState();
}

class _FxFormFieldDatePickerState extends State<FxFormFieldDatePicker> {
  DateTime? _date;
  String _text = "";

  @override
  void initState() {
    _date = widget.date;
    _text = widget.date == null ? '' : DateFormat.yMMMMd(I18nUtils.locale).format(widget.date!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FxFormFieldTextInput(
      readOnly: true,
      initialValue: _text,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: _date ?? DateTime.now(),
          firstDate: DateTime.now().add(
            const Duration(days: -20 * 366),
          ),
          lastDate: DateTime.now(),
        ).then((date) {
          setState(() {
            _date = date;
            _text = _date == null ? '' : DateFormat.yMMMMd(I18nUtils.locale).format(_date!);
          });
        });
      },
    );
  }
}
