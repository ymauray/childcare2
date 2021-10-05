import 'package:childcare2/forms/entry_form.dart';
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

class EntriesPage extends StatefulWidget {
  const EntriesPage({Key? key}) : super(key: key);

  @override
  _EntriesPageState createState() => _EntriesPageState();
}

class _EntriesPageState extends State<EntriesPage> {
  List<Entry> entries = [];
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
          children: const [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EntryForm(),
              )).then((_) {});
        },
        tooltip: i18n.t('New folder'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
