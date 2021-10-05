import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/widgets/custom_dropdown_button_form_field.dart';
import 'package:childcare2/widgets/custom_row.dart';
import 'package:childcare2/widgets/date_picker_form_field.dart';
import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:developer';

class Entries extends StatefulWidget {
  const Entries({Key? key}) : super(key: key);

  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  List<Entry> entries = [];
  final Entry _entry = Entry();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${folder.childFirstName} ${folder.childLastName}",
          style: TextStyle(color: t.colorScheme.onPrimary),
        ),
        backgroundColor: t.colorScheme.primary,
        iconTheme: IconThemeData(color: t.colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  dateHoursMinutes(i18n, context),
                  buttons(i18n, t),
                  saveButton(t),
                  pendingBalance(i18n),
                ],
              ),
            )
          ],
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
                  _entry.date = date;
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
                _entry.hours = value!;
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
                _entry.minutes = value!;
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
              isSelected: _entry.lunch,
              onSaved: (value) {
                _entry.lunch = value!;
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
              isSelected: _entry.diner,
              onSaved: (value) {
                _entry.diner = value!;
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
              isSelected: _entry.night,
              onSaved: (value) {
                _entry.night = value!;
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

  Widget saveButton(ThemeData t) {
    return CustomRow(
      icon: null,
      child: OutlinedButton(
        child: const FaIcon(FontAwesomeIcons.save),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(t.colorScheme.primary),
          foregroundColor: MaterialStateProperty.all<Color>(t.colorScheme.onPrimary),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            inspect(_entry);
          }
        },
      ),
    );
  }
}
