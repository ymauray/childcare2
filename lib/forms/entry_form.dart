import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/widgets/custom_dropdown_button_form_field.dart';
import 'package:childcare2/widgets/custom_row.dart';
import 'package:childcare2/widgets/date_picker_form_field.dart';
import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  DateTime toStartOfDay() => DateTime(year, month, day);
}

class EntryForm extends StatelessWidget {
  EntryForm({Key? key, this.entry, int? folderId, bool? preschool})
      : assert((entry != null && folderId == null && preschool == null) || (entry == null && folderId != null && preschool != null)),
        returnValue = Entry(folderId: folderId ?? entry!.folderId, preschool: preschool ?? entry!.preschool),
        super(key: key);

  final Entry? entry;
  final Entry returnValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        title: Text(entry == null ? 'New entry'.t(context) : 'Edit entry'.t(context)),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop(returnValue);
              }
            },
            child: Text(
              i18n.t("Save").toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              dateHoursMinutes(i18n, context),
              buttons(context),
              //pendingBalance(i18n),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateHoursMinutes(ChildCareLocalizations i18n, BuildContext context) {
    return CustomRow(
      icon: null,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DatePickerFormField(
              label: Text(i18n.t('Date')),
              nullable: false,
              initialDate: entry?.date ?? DateTime.now().toStartOfDay(),
              onSaved: (date) {
                if (date != null) {
                  returnValue.date = date;
                }
              },
              validator: (date) {
                if (date == null) {
                  return '';
                }
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: CustomDropdownButtonFormField<int>(
              label: Text(i18n.t('Hours')),
              items: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((value) => DropdownMenuItem(value: value, child: Text("$value"))).toList(),
              value: entry?.hours ?? 0,
              onSaved: (value) {
                returnValue.hours = value!;
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: CustomDropdownButtonFormField<int>(
              label: Text(i18n.t('Minutes')),
              items: [0, 15, 30, 45].map((value) => DropdownMenuItem(value: value, child: Text("$value"))).toList(),
              value: entry?.minutes ?? 0,
              onSaved: (value) {
                returnValue.minutes = value!;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return CustomRow(
      icon: null,
      child: Row(
        children: [
          Expanded(
            child: OutlinedToggleButtonFormField(
              child: Text('Lunch'.t(context)),
              isSelected: entry?.lunch ?? false,
              onSaved: (value) {
                returnValue.lunch = value!;
              },
            ),
            flex: 1,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: OutlinedToggleButtonFormField(
              child: Text('Dinner'.t(context)),
              isSelected: entry?.diner ?? false,
              onSaved: (value) {
                returnValue.diner = value!;
              },
            ),
            flex: 1,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: OutlinedToggleButtonFormField(
              child: Text('Night'.t(context)),
              isSelected: entry?.night ?? false,
              onSaved: (value) {
                returnValue.night = value!;
              },
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
