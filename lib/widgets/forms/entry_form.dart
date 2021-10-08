import 'dart:developer';

import 'package:childcare2/i18n/child_care_localizations.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/widgets/custom_dropdown_button_form_field.dart';
import 'package:childcare2/widgets/custom_row.dart';
import 'package:childcare2/widgets/date_picker_form_field.dart';
import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EntryForm extends StatelessWidget {
  final Entry? entry;
  final Entry returnValue = Entry();
  final _formKey = GlobalKey<FormState>();
  EntryForm({Key? key, this.entry}) : super(key: key);

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
        title: const Text("New entry"),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                inspect(returnValue);
                Navigator.of(context).pop();
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
              buttons(i18n, t),
              pendingBalance(i18n),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateHoursMinutes(ChildCareLocalizations i18n, BuildContext context) {
    return CustomRow(
      icon: const Icon(Icons.hourglass_bottom),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DatePickerFormField(
              label: Text(i18n.t('Date')),
              initialDate: DateTime.now(),
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
              value: 0,
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
              value: 0,
              onSaved: (value) {
                returnValue.minutes = value!;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buttons(ChildCareLocalizations i18n, ThemeData t) {
    return CustomRow(
      icon: const SizedBox(
        width: 24,
        height: 24,
        child: FaIcon(
          FontAwesomeIcons.utensils,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedToggleButtonFormField(
              child: Text(i18n.t("Noon")),
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
              child: Text(i18n.t("Evening")),
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
              child: Text(i18n.t("Night")),
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

  Padding pendingBalance(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Text("${i18n.t('Total pending billing :')} ${123.toStringAsFixed(2)}"),
          ),
        ],
      ),
    );
  }
}
