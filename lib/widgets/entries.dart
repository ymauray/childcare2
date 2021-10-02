import 'package:childcare2/i18n/child_care_localization.dart';
import 'package:childcare2/model/entry.dart';
import 'package:childcare2/model/folder.dart';
import 'package:childcare2/widgets/outlined_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Entries extends StatefulWidget {
  const Entries({Key? key}) : super(key: key);

  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  List<Entry> entries = [];
  Entry entry = Entry();
  final _hoursFocusNode = FocusNode();
  final _minutesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final i18n = ChildCareLocalizations.of(context);
    final t = Theme.of(context);
    final folder = ModalRoute.of(context)!.settings.arguments as Folder;
    final _formKey = GlobalKey<FormState>();

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
                  dateAndHours(i18n, context),
                  buttons(t),
                  pendingBalance(i18n),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding pendingBalance(ChildCareLocalizations i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Text("${i18n.t('Total pending billing')} : ${123.toStringAsFixed(2)}"),
          ),
        ],
      ),
    );
  }

  Padding buttons(ThemeData t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      child: Row(
        children: [
          dinerButton(),
          const SizedBox(
            width: 8,
          ),
          nightButton(),
          const SizedBox(
            width: 8,
          ),
          saveButton(t),
        ],
      ),
    );
  }

  Expanded saveButton(ThemeData t) {
    return Expanded(
      child: OutlinedButton(
        child: const FaIcon(FontAwesomeIcons.save),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(t.colorScheme.primary),
          foregroundColor: MaterialStateProperty.all<Color>(t.colorScheme.onPrimary),
        ),
        onPressed: () {},
      ),
      flex: 2,
    );
  }

  Expanded nightButton() {
    return Expanded(
      child: OutlinedToggleButton(
        child: const FaIcon(FontAwesomeIcons.bed),
        isSelected: entry.night,
        onPressed: () {
          setState(() {
            entry.night = !entry.night;
          });
        },
      ),
      flex: 1,
    );
  }

  Expanded dinerButton() {
    return Expanded(
      child: OutlinedToggleButton(
        child: const FaIcon(FontAwesomeIcons.utensils),
        isSelected: entry.diner,
        onPressed: () {
          setState(() {
            entry.diner = !entry.diner;
          });
        },
      ),
      flex: 1,
    );
  }

  Padding dateAndHours(ChildCareLocalizations i18n, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          dateSelector(i18n, context),
          const SizedBox(
            width: 8,
          ),
          hoursDropdown(i18n),
          const SizedBox(
            width: 8,
          ),
          minutesDropdown(i18n)
        ],
      ),
    );
  }

  Expanded minutesDropdown(ChildCareLocalizations i18n) {
    return Expanded(
      flex: 1,
      child: DropdownButtonFormField<int>(
        focusNode: _minutesFocusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          label: Text(i18n.t('Minutes')),
        ),
        items: [0, 15, 30, 45].map((value) => DropdownMenuItem(value: value, child: Text("$value"))).toList(),
        value: 0,
        onChanged: (value) {},
        onTap: () {
          _minutesFocusNode.requestFocus();
        },
      ),
    );
  }

  Expanded hoursDropdown(ChildCareLocalizations i18n) {
    return Expanded(
      flex: 1,
      child: DropdownButtonFormField<int>(
        focusNode: _hoursFocusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          label: Text(i18n.t('Hours')),
        ),
        items: [0, 1, 2, 3, 4, 5, 6, 7, 8].map((value) => DropdownMenuItem(value: value, child: Text("$value"))).toList(),
        value: 0,
        onChanged: (value) {},
        onTap: () {
          _hoursFocusNode.requestFocus();
        },
      ),
    );
  }

  Expanded dateSelector(ChildCareLocalizations i18n, BuildContext context) {
    return Expanded(
      flex: 2,
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(i18n.t('Date')),
        ),
        keyboardType: TextInputType.none,
        showCursor: false,
        enableInteractiveSelection: false,
        controller: TextEditingController(text: DateFormat('dd.MM.yyyy').format(entry.date)),
        onTap: () {
          showDatePicker(
            context: context,
            //initialDate: widget.expense.date == null ? DateTime.now() : widget.expense.date!,
            initialDate: entry.date,
            firstDate: DateTime.now().add(
              const Duration(days: -1000),
            ),
            lastDate: DateTime.now().add(
              const Duration(days: 1000),
            ),
          ).then((date) {
            setState(() {
              entry.date = date ?? entry.date;
            });
          });
        },
      ),
    );
  }
}
